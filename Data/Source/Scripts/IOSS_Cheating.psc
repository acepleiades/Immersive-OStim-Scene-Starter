Scriptname IOSS_Cheating extends Quest  

Actor Property PlayerRef Auto
Faction Property IOSS_DispositionBeforeUpset  Auto
Faction Property OCR_Lover_Commitment  Auto
Faction Property OCR_Lover_PlayerBrokeUpFaction Auto
Faction Property OCR_Lover_PlayerCheatedFaction Auto
Faction Property OCR_Lover_PlayerCommittedRelationshipFaction  Auto
Faction Property OCR_Lover_State_Upset  Auto
Faction Property OCR_Lover_Value_Love  Auto
GlobalVariable Property OCR_CurrentAttraction  Auto
GlobalVariable Property IOSS_CheatingDetectionType  Auto
Keyword Property OCR_AliasIsFilled  Auto
Message Property IOSS_CheatingDetectedMessage Auto
Message Property IOSS_Cheating_SceneNPC_0LoveDislike Auto
Message Property IOSS_Cheating_SceneNPC_0LoveNotCare Auto
Message Property IOSS_Cheating_SceneNPC_Commited Auto
Message Property IOSS_Cheating_SceneNPC_Dislike Auto
Message Property IOSS_Cheating_SceneNPC_Like Auto
Quest Property IOSS_CheatingDetection Auto
ReferenceAlias Property DetectedCheatingAlias Auto
ReferenceAlias Property SceneInteractionSubject Auto
SPELL Property IOSS_InteractionCooldownSpell12h  Auto
SPELL Property IOSS_InteractionCooldownSpell24h  Auto

function DetectCheating(actor SceneNPC = None)
    if IOSS_CheatingDetectionType.GetValue() == 0
        AnimatedInteractionDetectCheating()
    else
        AdultSceneDetectCheating(SceneNPC)
    endif
endFunction

function AnimatedInteractionDetectCheating()
	bool CheatingDetected
    actor actor1 = DetectedCheatingAlias.GetActorReference()
    if actor1.HasKeyword(OCR_AliasIsFilled)
    	CheatingDetected = true
    endif
	if CheatingDetected == true
    	RegisterForModEvent("ostim_end", "OStimEnd")
	else
		MiscUtil.PrintConsole("DetectCheating: No cheating was detected.")
	endif
endfunction

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
	;Wait and display message
    Utility.Wait(1)
	IOSS_CheatingDetectedMessage.Show()
	;Apply effects for involved characters
	Cheating_BreakUp(DetectedCheatingAlias.GetActorReference())
	Cheating_InvolvedReaction(SceneInteractionSubject.GetActorReference())
	;Reset
	DetectedCheatingAlias.Clear()
	IOSS_CheatingDetection.Stop()
EndEvent

function Cheating_BreakUp(actor actor1)
        ;Make NPC upset and apply interactions cooldown
        Cheating_MakeUpset(actor1, 4)
    	Che_InteractionCooldown24h(actor1)
        ;Update factions
    	actor1.SetFactionRank(OCR_Lover_Value_Love, 0)
    	actor1.RemoveFromFaction(OCR_Lover_Value_Love)
    	actor1.RemoveFromFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	actor1.AddToFaction(OCR_Lover_PlayerBrokeUpFaction)
        ;Message and notifications
        Debug.Notification("Betrayed partner is no longer committed to you.")
    	Debug.Notification("Betrayed partner is deeply upset.")
endfunction

function Cheating_InvolvedReaction(actor actor1)
    int actor1Commitment = actor1.GetFactionRank(OCR_Lover_Commitment)
    if actor1.GetFactionRank(OCR_Lover_Value_Love) > 5
    	Float actor1Morality = actor1.GetAV("Morality")
    	if actor1Morality <= 1 && actor1Commitment == 0 ; Scene NPC likes
    		;Love gain
    	    int currentLove = actor1.GetFactionRank(OCR_Lover_Value_Love)
    	    if currentLove < 100
    	    	int newLove = currentLove + 20
    	    	actor1.SetFactionRank(OCR_Lover_Value_Love, newLove)
    		endif
    	    ;Message and notifications
    		IOSS_Cheating_SceneNPC_Like.Show()
    		Debug.Notification("Love with your partner has greatly increased.")
    	elseIf actor1.IsInFaction(OCR_Lover_PlayerCommittedRelationshipFaction) == 0; Does not like
    	    ;Make NPC upset and apply interactions cooldown
    	    Cheating_MakeUpset(actor1, 2)
    		Che_InteractionCooldown12h(actor1)
    	    ;Message and notifications
    		IOSS_Cheating_SceneNPC_Dislike.Show()
    		Debug.Notification("Your betrayed partner is upset.")
    	elseIf actor1.IsInFaction(OCR_Lover_PlayerCommittedRelationshipFaction) == 1; Does not like and is committed to PC
    	    ;Make NPC upset and apply interactions cooldown
    	    Cheating_MakeUpset(actor1, 3)
    		Che_InteractionCooldown24h(actor1)
    	    ;Update factions
    		actor1.SetFactionRank(OCR_Lover_Value_Love, 0)
    		actor1.RemoveFromFaction(OCR_Lover_Value_Love)
    		actor1.RemoveFromFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    		actor1.AddToFaction(OCR_Lover_PlayerBrokeUpFaction)
    	    ;Message and notifications
    		IOSS_Cheating_SceneNPC_Commited.Show()
    	    Debug.Notification("Your partner is no longer committed to you.")
    		Debug.Notification("Your partner is deeply upset.")
    	endif
	elseIf OCR_CurrentAttraction.GetValue() > 0.85
		if actor1Commitment == 0
			IOSS_Cheating_SceneNPC_0LoveNotCare.Show()
		else
    	    ;Make NPC upset and apply interactions cooldown
    	    Cheating_MakeUpset(actor1, 2)
    		Che_InteractionCooldown24h(actor1)
    	    ;Message and notifications
			IOSS_Cheating_SceneNPC_0LoveDislike.Show()
    		Debug.Notification("Your partner is upset.")
		endif
	endif
endfunction

function Cheating_MakeUpset(actor actor1, int UpsetLevel)
    ;This function will temporarily lower the disposition of the NPC to the player. First, we must store the value to be restored
    int CurrentDisposition = actor1.GetRelationshipRank(playerref)
    if CurrentDisposition < 0
        CurrentDisposition = 0
    endif
    actor1.SetFactionRank(IOSS_DispositionBeforeUpset, CurrentDisposition)
    if UpsetLevel >= 0 && UpsetLevel <= 4
        actor1.SetFactionRank(OCR_Lover_State_Upset, UpsetLevel)
    else
        Debug.Notification("Cheating_MakeUpset: Passed UpsetLevel " + UpsetLevel + " is not valid.")
    endif
    ;Finally, lower the disposition
    actor1.SetRelationshipRank(playerref, -1)
    MiscUtil.PrintConsole("Cheating_MakeUpset: lowered NPC's disposition toward PC. Previous value was " + CurrentDisposition)
endFunction

function Che_InteractionCooldown12h(actor actor1)
    IOSS_InteractionCooldownSpell12h.Cast(playerref, actor1)
endFunction
function Che_InteractionCooldown24h(actor actor1)
    IOSS_InteractionCooldownSpell24h.Cast(playerref, actor1)
endFunction

;For starting unrestricted OStim scenes nearby exclusive-relationship lovers
;This function is used in the quest IOSS_SceneInteractions, player dialogue branch IOSS_AdultScene
function AdultSceneDetectCheating(actor SceneNPC)
	;Start quests
	SceneInteractionSubject.Clear()
	SceneInteractionSubject.ForceRefTo(SceneNPC)
	;Variable for cheating detected
	bool CheatingDetected
    actor actor1 = DetectedCheatingAlias.GetActorReference()
    if actor1.HasKeyword(OCR_AliasIsFilled)
    	CheatingDetected = true
    endif
	if CheatingDetected == true
		;Force scene end
    	RegisterForModEvent("ostim_start", "OStimStart")
	else
		MiscUtil.PrintConsole("DetectCheating: No cheating was detected.")
	endif
endfunction

Event OStimStart(string eventName, string strArg, float numArg, Form sender)
	Utility.Wait(1)
	OThread.Stop(0)
EndEvent