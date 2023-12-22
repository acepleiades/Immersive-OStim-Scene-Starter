Scriptname IOSS_Relationship extends Quest  

Actor Property PlayerRef Auto
Faction Property OCR_Lover_AcceptsMultiplePartnersFaction  Auto
Faction Property OCR_Lover_Commitment  Auto
Faction Property OCR_Lover_PlayerBrokeUpFaction Auto
Faction Property OCR_Lover_PlayerCheatedFaction Auto
Faction Property OCR_Lover_PlayerCommittedRelationshipFaction  Auto
Faction Property OCR_Lover_State_Upset  Auto
Faction Property OCR_Lover_Value_Intimacy  Auto
Faction Property OCR_Lover_Value_Love  Auto
Faction Property OCR_SocialClass_CitizenLow Auto
Faction Property OCR_SocialClass_CitizenLowest Auto
Faction Property OCR_SocialClass_CitizenMiddle Auto
Faction Property OCR_SocialClass_CitizenNoble Auto
Faction Property OCR_SocialClass_Other Auto
Faction Property OCR_SocialClass_SoldierOrGuard Auto
Faction Property OCR_Trait_EnthusiastArcane  Auto
Faction Property OCR_Trait_EnthusiastEscapade  Auto
Faction Property OCR_Trait_EnthusiastMartial  Auto
GlobalVariable Property IOSS_ShownTooltip_EndAnimation  Auto
GlobalVariable Property IOSS_ShownTooltip_GoSteadyFail  Auto
GlobalVariable Property OCR_CurrentAttraction  Auto
Message Property IOSS_Inquire_Commitment_0  Auto
Message Property IOSS_Inquire_Commitment_1  Auto
Message Property IOSS_Inquire_Commitment_2  Auto
Message Property IOSS_Inquire_Interest_Arcane  Auto
Message Property IOSS_Inquire_Interest_Escapade  Auto
Message Property IOSS_Inquire_Interest_Martial  Auto
Message Property IOSS_Inquire_SocialClass_CitizenLow  Auto
Message Property IOSS_Inquire_SocialClass_CitizenLowest  Auto
Message Property IOSS_Inquire_SocialClass_CitizenMiddle  Auto
Message Property IOSS_Inquire_SocialClass_CitizenNoble  Auto
Message Property IOSS_Inquire_SocialClass_Other  Auto
Message Property IOSS_Inquire_SocialClass_SoldierOrGuard  Auto
Message Property IOSS_Relationship_Apologize_Fail  Auto
Message Property IOSS_Relationship_Apologize_Success  Auto
Message Property IOSS_Relationship_BreakUp_NotUpset  Auto
Message Property IOSS_Relationship_BreakUp_Upset  Auto
Message Property IOSS_Relationship_GoSteady_No  Auto
Message Property IOSS_Relationship_GoSteady_Yes_PCExclusive  Auto
Message Property IOSS_Relationship_GoSteady_Yes_PCNonExclusive  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_Maybe  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_No1  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_No2  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_Yes  Auto
Message Property IOSS_Relationship_PersuadedNE_Attraction  Auto
Message Property IOSS_Relationship_PersuadedNE_Intimacy  Auto
Message Property IOSS_Relationship_PersuadedNE_Love  Auto
Message Property IOSS_Relationship_Reconcile_Fail  Auto
Message Property IOSS_Relationship_Reconcile_Success  Auto
Message Property IOSS_Tooltip_EndAnimation  Auto
Message Property IOSS_Tooltip_GoSteadyFail  Auto
OCR_OStimSequencesUtil Property Util Auto
ReferenceAlias Property SceneNPC  Auto
SPELL Property IOSS_InteractionCooldownSpell12h  Auto
SPELL Property IOSS_InteractionCooldownSpell24h  Auto
SPELL Property IOSS_InteractionCooldownSpell2h  Auto
SPELL Property IOSS_InteractionCooldownSpell6h  Auto
SPELL Property IOSS_OfCourseCooldownSpell  Auto

; Script-wide variable to track which query was selected
Int property Query Auto

function TooltipEndAnimation()
    if (IOSS_ShownTooltip_EndAnimation.GetValue()) == 0
        IOSS_Tooltip_EndAnimation.Show()
        IOSS_ShownTooltip_EndAnimation.SetValue(1)
    endif
endfunction

;Inquire interactions are for learning information about the NPC.
function Inquire_Interests(actor actor1)
    SceneNPC.Clear()
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 1
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Inquire_SocialClass(actor actor1)
    SceneNPC.Clear()
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 2
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Inquire_Commitment(actor actor1)
    SceneNPC.Clear()
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 3
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Relationship_GoSteady(actor actor1)
    SceneNPC.Clear()
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    float actor1Love = actor1.GetFactionRank(OCR_Lover_Value_Love)
	if OCR_CurrentAttraction.GetValue() > 1.3 && actor1Intimacy > 5 && actor1Love > 0
		Util.Court(actor1)
		Query = 4
	ElseIf OCR_CurrentAttraction.GetValue() > 1.15 && actor1Intimacy > 10 && actor1Love > 5
		Util.Court(actor1)
		Query = 4
	elseif OCR_CurrentAttraction.GetValue() > 1 && actor1Intimacy > 15 && actor1Love > 10
		Util.Court(actor1)
		Query = 4
	elseif OCR_CurrentAttraction.GetValue() > 0.85 && actor1Intimacy > 20 && actor1Love > 15
		Util.Court(actor1)
		Query = 4
	else
		Util.CourtFail(actor1)
		Query = 5
	endif
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Relationship_BreakUp(actor actor1)
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    if actor1Intimacy > 50
    	Rel_InteractionCooldown24h(actor1)
    	actor1.SetFactionRank(OCR_Lover_Value_Love, 0)
    	actor1.RemoveFromFaction(OCR_Lover_Value_Love)
    	actor1.RemoveFromFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	actor1.AddToFaction(OCR_Lover_PlayerBrokeUpFaction)
    	IOSS_Relationship_BreakUp_NotUpset.Show()
    else
    	Rel_InteractionCooldown24h(actor1)
    	actor1.SetFactionRank(OCR_Lover_Value_Love, 0)
    	actor1.RemoveFromFaction(OCR_Lover_Value_Love)
    	actor1.RemoveFromFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	actor1.AddToFaction(OCR_Lover_PlayerBrokeUpFaction)
    	actor1.AddToFaction(OCR_Lover_State_Upset)
    	actor1.SetFactionRank(OCR_Lover_State_Upset, 2)
    	IOSS_Relationship_BreakUp_Upset.Show()
    	Debug.Notification("Your partner is upset.")
    endif
endfunction
function Relationship_Reconcile(actor actor1)
    SceneNPC.Clear()
    ; Calculate the success rate for reconciliation
    float Bonus_Attraction = OCR_CurrentAttraction.GetValue() * 15
    float Bonus_Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy) / 2
    float Bonus_Speechcraft = playerref.GetAV("Speechcraft") / 3
    float Penalty_Commitment = actor1.GetFactionRank(OCR_Lover_Commitment) * -20
    float SuccessChance = actor1.GetFactionRank(OCR_Lover_Commitment) + Bonus_Intimacy + Bonus_Speechcraft
    MiscUtil.PrintConsole("IOSS_Relationship: Bonus_Attraction is " + Bonus_Attraction)
    MiscUtil.PrintConsole("IOSS_Relationship: Bonus_Intimacy is " + Bonus_Intimacy)
    MiscUtil.PrintConsole("IOSS_Relationship: Bonus_Speechcraft is " + Bonus_Speechcraft)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: See that the 'dice roll' has to be lower than the success rate to succeed.")
    ; "Roll the dice"
    float RandomChance = Utility.RandomFloat(0, 100)
    MiscUtil.PrintConsole("IOSS_Relationship: 'Dice roll' is " + RandomChance)
    MiscUtil.PrintConsole("IOSS_Relationship: See that the 'dice roll' must be lower than the success rate to succeed.")
    if RandomChance < SuccessChance
        Util.Chatter(actor1)
        Query = 6  ; Indicates a "Reconciliation Success" result
    else
        Util.ChatterFail(actor1)
        Query = 7  ; Indicates the "Reconciliation Fail" result
    endif
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction
function Relationship_Apologize(actor actor1)
    ; Initialize variables
    float SuccessChance = 0
    float Penalty_UpsetLevel = actor1.GetFactionRank(OCR_Lover_State_Upset) * 20
    float Penalty_Cheating = 0
    ; Check for cheating penalty
    if actor1.IsInFaction(OCR_Lover_PlayerCheatedFaction) && actor1.GetFactionRank(OCR_Lover_Commitment) > 0
        Penalty_Cheating = actor1.GetFactionRank(OCR_Lover_PlayerCheatedFaction) * -30
    	MiscUtil.PrintConsole("IOSS_Relationship: Player has cheated.")
    endif
    ; Calculate success chance
    float Bonus_Speechcraft = playerref.GetAV("Speechcraft") / 4
    SuccessChance = 100 - Penalty_UpsetLevel + Bonus_Speechcraft + Penalty_Cheating
    ; Ensure success chance is not negative
    if SuccessChance < 0
        SuccessChance = 0
    endif
    ; Print debug information
    MiscUtil.PrintConsole("IOSS_Relationship: Penalty_UpsetLevel is " + Penalty_UpsetLevel)
    MiscUtil.PrintConsole("IOSS_Relationship: Penalty_Cheating is " + Penalty_Cheating)
    MiscUtil.PrintConsole("IOSS_Relationship: Bonus_Speechcraft is " + Bonus_Speechcraft)
    MiscUtil.PrintConsole("IOSS_Relationship: Success Chance for Apology is " + SuccessChance)
    ; "Roll the dice"
    float RandomChance = Utility.RandomFloat(0, 100)
    MiscUtil.PrintConsole("IOSS_Relationship: 'Dice roll' is " + RandomChance)
    MiscUtil.PrintConsole("IOSS_Relationship: See that the 'dice roll' must be lower than the success rate to succeed.")
    if RandomChance < SuccessChance
        Util.Chatter(actor1)
        Query = 8  ; Indicates an "Apology Success" result
    else
        Util.ChatterFail(actor1)
        Query = 9  ; Indicates an "Apology Fail" result
    endif
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
    Utility.Wait(0.5)
    ;Display the message after the scene
    if (Query == 1) ;Inquire_Interests
    	actor actor1 = SceneNPC.GetActorReference()
    	if actor1.IsInFaction(OCR_Trait_EnthusiastArcane)
    		IOSS_Inquire_Interest_Arcane.Show()
    	ElseIf actor1.IsInFaction(OCR_Trait_EnthusiastEscapade)
    		IOSS_Inquire_Interest_Escapade.Show()
    	ElseIf actor1.IsInFaction(OCR_Trait_EnthusiastMartial)
    		IOSS_Inquire_Interest_Martial.Show()
    	Else
    		Debug.Notification("There was nothing to talk about.")
    	endif
    elseif (Query == 2) ;Inquire_SocialClass
    	actor actor1 = SceneNPC.GetActorReference()
    	if actor1.IsInFaction(OCR_SocialClass_CitizenLow)
    		IOSS_Inquire_SocialClass_CitizenLow.Show()
    	ElseIf actor1.IsInFaction(OCR_SocialClass_CitizenLowest)
    		IOSS_Inquire_SocialClass_CitizenLowest.Show()
    	ElseIf actor1.IsInFaction(OCR_SocialClass_CitizenMiddle)
    		IOSS_Inquire_SocialClass_CitizenMiddle.Show()
    	ElseIf actor1.IsInFaction(OCR_SocialClass_CitizenNoble)
    		IOSS_Inquire_SocialClass_CitizenNoble.Show()
    	ElseIf actor1.IsInFaction(OCR_SocialClass_SoldierOrGuard)
    		IOSS_Inquire_SocialClass_SoldierOrGuard.Show()
    	ElseIf actor1.IsInFaction(OCR_SocialClass_Other)
    		IOSS_Inquire_SocialClass_Other.Show()
    	Else
    		Debug.Notification("There was nothing to talk about.")
    	endif
    elseif (Query == 3) ;Inquire_Interests
    	actor actor1 = SceneNPC.GetActorReference()
    	int actor1Commitment = actor1.GetFactionRank(OCR_Lover_Commitment)
    	if actor1Commitment == 0
    		IOSS_Inquire_Commitment_0.Show()
    	ElseIf actor1Commitment == 1
    		IOSS_Inquire_Commitment_1.Show()
    	ElseIf actor1Commitment == 2
    		IOSS_Inquire_Commitment_2.Show()
    	Else
    		Debug.Notification("There was nothing to talk about.")
    	endif
    elseif (Query == 4) ;Relationship_GoSteady Success
    	actor actor1 = SceneNPC.GetActorReference()
    	int actor1Commitment = actor1.GetFactionRank(OCR_Lover_Commitment)
    	if actor1Commitment == 0
    		IOSS_Relationship_GoSteady_Yes_PCNonExclusive.Show()
    		actor1.AddToFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    		actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
    	ElseIf actor1Commitment >= 1
    		IOSS_Relationship_GoSteady_Yes_PCExclusive.Show()
    		actor1.AddToFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	endif
    	Debug.Notification("Your partner has committed to you.")
    elseif (Query == 5) ;Relationship_GoSteady Fail
    	IOSS_Relationship_GoSteady_No.Show()
    	if (IOSS_ShownTooltip_GoSteadyFail.GetValue()) == 0
        	IOSS_Tooltip_GoSteadyFail.Show()
        	IOSS_ShownTooltip_GoSteadyFail.SetValue(1)
    	endif
    elseif (Query == 6) ;Reconciliation Success
    	actor actor1 = SceneNPC.GetActorReference()
    	actor1.AddToFaction(OCR_Lover_Value_Love)
    	actor1.AddToFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	actor1.RemoveFromFaction(OCR_Lover_PlayerBrokeUpFaction)
    	IOSS_Relationship_Reconcile_Success.Show()
    	Debug.Notification("Your partner has committed to you (again).")
    elseif (Query == 7) ;Reconciliation Fail
    	actor actor1 = SceneNPC.GetActorReference()
    	Rel_InteractionCooldown24h(actor1)
    	IOSS_Relationship_Reconcile_Fail.Show()
    elseif (Query == 8) ;Apology Success
    	actor actor1 = SceneNPC.GetActorReference()
    	actor1.RemoveFromFaction(OCR_Lover_PlayerCheatedFaction)
    	actor1.RemoveFromFaction(OCR_Lover_State_Upset)
    	IOSS_Relationship_Reconcile_Success.Show()
    	Debug.Notification("Your partner is no longer upset.")
    elseif (Query == 9) ;Apology Fail
    	actor actor1 = SceneNPC.GetActorReference()
    	if actor1.GetFactionRank(OCR_Lover_State_Upset) == 4
    		Rel_InteractionCooldown24h(actor1)
    	elseif actor1.GetFactionRank(OCR_Lover_State_Upset) == 3
    		Rel_InteractionCooldown12h(actor1)
    	elseif actor1.GetFactionRank(OCR_Lover_State_Upset) == 2
    		Rel_InteractionCooldown6h(actor1)
    	elseif actor1.GetFactionRank(OCR_Lover_State_Upset) == 1
    		Rel_InteractionCooldown2h(actor1)
    	endif
    	IOSS_Relationship_Reconcile_Success.Show()
    endif
    ;Reset
    SceneNPC.Clear()
    Query = 0
EndEvent

function Rel_InteractionCooldown2h(actor actor1)
    IOSS_InteractionCooldownSpell2h.Cast(playerref, actor1)
endFunction
function Rel_InteractionCooldown6h(actor actor1)
    IOSS_InteractionCooldownSpell6h.Cast(playerref, actor1)
endFunction
function Rel_InteractionCooldown12h(actor actor1)
    IOSS_InteractionCooldownSpell12h.Cast(playerref, actor1)
endFunction
function Rel_InteractionCooldown24h(actor actor1)
    IOSS_InteractionCooldownSpell24h.Cast(playerref, actor1)
endFunction