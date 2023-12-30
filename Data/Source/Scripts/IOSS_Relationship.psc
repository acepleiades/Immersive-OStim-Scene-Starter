Scriptname IOSS_Relationship extends Quest  

Actor Property PlayerRef Auto
Faction Property IOSS_DispositionBeforeUpset  Auto
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
Quest Property IOSS_Make3PPCandidatesQST Auto
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
    SceneNPC.ForceRefTo(actor1)
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 1
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Inquire_SocialClass(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 2
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Inquire_Commitment(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 3
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Relationship_GoSteady(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    float actor1Love = actor1.GetFactionRank(OCR_Lover_Value_Love)
	if OCR_CurrentAttraction.GetValue() > 1.5 && actor1Intimacy > 5 && actor1Love > 0
        MiscUtil.PrintConsole("Relationship_GoSteady: Attraction is higher than 1.5, requirement was 5 Intimacy and positive Love.")
		Util.Court(actor1)
		Query = 4
	ElseIf OCR_CurrentAttraction.GetValue() > 1.15 && actor1Intimacy > 10 && actor1Love > 0
        MiscUtil.PrintConsole("Relationship_GoSteady: Attraction is < 1.5 and > 1.15, requirement was 10 Intimacy and positive Love.")
		Util.Court(actor1)
		Query = 4
	elseif OCR_CurrentAttraction.GetValue() > 1 && actor1Intimacy > 15 && actor1Love > 5
        MiscUtil.PrintConsole("Relationship_GoSteady: Attraction is < 1.15 and > 1, requirement was 15 Intimacy and 5 Love.")
		Util.Court(actor1)
		Query = 4
	elseif OCR_CurrentAttraction.GetValue() > 0.85 && actor1Intimacy > 20 && actor1Love > 10
        MiscUtil.PrintConsole("Relationship_GoSteady: Attraction is < 1 and > 0.85, requirement was 20 Intimacy and 10 Love.")
		Util.Court(actor1)
		Query = 4
	else
        MiscUtil.PrintConsole("Relationship_GoSteady: Did not match the required Attraction, Intimacy and/or Love.")
		Util.CourtFail(actor1)
		Query = 5
	endif
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Relationship_BreakUp(actor actor1)
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    if actor1Intimacy > 50
        ;Apply interactions cooldown
    	Rel_InteractionCooldown24h(actor1)
        MiscUtil.PrintConsole("Relationship_BreakUp: NPC is not upset because Intimacy is > 50.")
        ;Update factions
    	actor1.SetFactionRank(OCR_Lover_Value_Love, 0)
    	actor1.RemoveFromFaction(OCR_Lover_Value_Love)
    	actor1.RemoveFromFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	actor1.AddToFaction(OCR_Lover_PlayerBrokeUpFaction)
        ;Message and notification
    	IOSS_Relationship_BreakUp_NotUpset.Show()
        Debug.Notification("Your partner is no longer committed to you.")
    else
        MiscUtil.PrintConsole("Relationship_BreakUp: NPC is upset because Intimacy is < 50.")
        ;Make NPC upset and apply interactions cooldown
    	Rel_InteractionCooldown24h(actor1)
        MakeUpset(actor1, 2)
        ;Update factions
    	actor1.SetFactionRank(OCR_Lover_Value_Love, 0)
    	actor1.RemoveFromFaction(OCR_Lover_Value_Love)
    	actor1.RemoveFromFaction(OCR_Lover_PlayerCommittedRelationshipFaction)
    	actor1.AddToFaction(OCR_Lover_PlayerBrokeUpFaction)
        ;Message and notifications
    	IOSS_Relationship_BreakUp_Upset.Show()
        Debug.Notification("Your partner is no longer committed to you.")
    	Debug.Notification("Your partner is upset.")
    endif
endfunction
function Relationship_Reconcile(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    ; Calculate the success rate for reconciliation
    float Penalty_Commitment = actor1.GetFactionRank(OCR_Lover_Commitment) * -20
    float Bonus_Attraction = OCR_CurrentAttraction.GetValue() * 15
    float Bonus_Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy) / 2
    float Bonus_Speechcraft = playerref.GetAV("Speechcraft") / 3
    float SuccessChance = actor1.GetFactionRank(OCR_Lover_Commitment) + Bonus_Intimacy + Bonus_Speechcraft
    MiscUtil.PrintConsole("Relationship_Reconcile: Penalty_Commitment is " + Penalty_Commitment)
    MiscUtil.PrintConsole("Relationship_Reconcile: Bonus_Attraction is " + Bonus_Attraction)
    MiscUtil.PrintConsole("Relationship_Reconcile: Bonus_Intimacy is " + Bonus_Intimacy)
    MiscUtil.PrintConsole("Relationship_Reconcile: Bonus_Speechcraft is " + Bonus_Speechcraft)
    MiscUtil.PrintConsole("Relationship_Apologize: Success Chance for Apology is " + SuccessChance)
    MiscUtil.PrintConsole("Relationship_Reconcile: See that the 'dice roll' has to be lower than the success rate to succeed.")
    ; "Roll the dice"
    float RandomChance = Utility.RandomFloat(0, 100)
    MiscUtil.PrintConsole("Relationship_Reconcile: 'Dice roll' is " + RandomChance)
    MiscUtil.PrintConsole("Relationship_Reconcile: See that the 'dice roll' must be lower than the success rate to succeed.")
    ; Minimum 5% chance
    if SuccessChance < 0
        SuccessChance = 5
        MiscUtil.PrintConsole("Relationship_Reconcile: Applied minimum success chance of 5%.")
    endif
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
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    ; Calculate the success rate for apology
    float Penalty_UpsetLevel = actor1.GetFactionRank(OCR_Lover_State_Upset) * 15
    float Penalty_Cheating = 0
    ; Check for cheating penalty
    if actor1.IsInFaction(OCR_Lover_PlayerCheatedFaction) && actor1.GetFactionRank(OCR_Lover_Commitment) > 0
        Penalty_Cheating = actor1.GetFactionRank(OCR_Lover_PlayerCheatedFaction) * 30
    	MiscUtil.PrintConsole("Relationship_Apologize: Player has cheated.")
    endif
    float Bonus_Speechcraft = playerref.GetAV("Speechcraft") / 4
    float SuccessChance = 100 - Penalty_UpsetLevel - Penalty_Cheating + Bonus_Speechcraft
    ; Minimum 5% chance
    if SuccessChance < 0
        SuccessChance = 5
        MiscUtil.PrintConsole("Relationship_Reconcile: Applied minimum success chance of 5%.")
    endif
    MiscUtil.PrintConsole("Relationship_Apologize: Penalty_UpsetLevel is " + Penalty_UpsetLevel)
    MiscUtil.PrintConsole("Relationship_Apologize: Penalty_Cheating is " + Penalty_Cheating)
    MiscUtil.PrintConsole("Relationship_Apologize: Bonus_Speechcraft is " + Bonus_Speechcraft)
    MiscUtil.PrintConsole("Relationship_Apologize: Success Chance for Apology is " + SuccessChance)
    ; "Roll the dice"
    float RandomChance = Utility.RandomFloat(0, 100)
    MiscUtil.PrintConsole("Relationship_Apologize: 'Dice roll' is " + RandomChance)
    MiscUtil.PrintConsole("Relationship_Apologize: See that the 'dice roll' must be lower than the success rate to succeed.")
    if RandomChance < SuccessChance
        Util.Chatter(actor1)
        Query = 8  ; Indicates an "Apology Success" result
    else
        Util.ChatterFail(actor1)
        Query = 9  ; Indicates an "Apology Fail" result
    endif
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction
function Relationship_PersuadeNonExcl(actor actor1)
    if actor1.IsInFaction(OCR_Lover_AcceptsMultiplePartnersFaction) ;Automatically applied to commitment 0
        IOSS_Relationship_PersuadeNonExcl_Yes.Show()
    else
        int actor1Commitment = actor1.GetFactionRank(OCR_Lover_Commitment)
        float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
        float actor1Love = actor1.GetFactionRank(OCR_Lover_Value_Love)
        if actor1Commitment == 1
            if OCR_CurrentAttraction.GetValue() >= 1.5 && actor1Intimacy >= 50
                int iChoice = IOSS_Relationship_PersuadeNonExcl_Maybe.Show()
                if iChoice == 0
                    IOSS_Relationship_PersuadedNE_Intimacy.Show()
                    actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
                endif
            elseif OCR_CurrentAttraction.GetValue() >= 1.5 && actor1Love >= 75
                int iChoice = IOSS_Relationship_PersuadeNonExcl_Maybe.Show()
                if iChoice == 0
                    IOSS_Relationship_PersuadedNE_Love.Show()
                    actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
                endif
            elseif OCR_CurrentAttraction.GetValue() >= 2
                int iChoice = IOSS_Relationship_PersuadeNonExcl_Maybe.Show()
                if iChoice == 0
                    IOSS_Relationship_PersuadedNE_Attraction.Show()
                    actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
                endif
            else
                IOSS_Relationship_PersuadeNonExcl_No1.Show()
            endif
        else ;Commitment 2
            if OCR_CurrentAttraction.GetValue() >= 1.75 && actor1Intimacy >= 75
                int iChoice = IOSS_Relationship_PersuadeNonExcl_Maybe.Show()
                if iChoice == 0
                    IOSS_Relationship_PersuadedNE_Intimacy.Show()
                    actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
                endif
            elseif OCR_CurrentAttraction.GetValue() >= 1.75 && actor1Love >= 100
                int iChoice = IOSS_Relationship_PersuadeNonExcl_Maybe.Show()
                if iChoice == 0
                    IOSS_Relationship_PersuadedNE_Love.Show()
                    actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
                endif
            elseif OCR_CurrentAttraction.GetValue() >= 2.5
                int iChoice = IOSS_Relationship_PersuadeNonExcl_Maybe.Show()
                if iChoice == 0
                    IOSS_Relationship_PersuadedNE_Attraction.Show()
                    actor1.AddToFaction(OCR_Lover_AcceptsMultiplePartnersFaction)
                endif
            else
                IOSS_Relationship_PersuadeNonExcl_No2.Show()
            endif
        endif
    endif
endfunction

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
        actor1.SetFactionRank(OCR_Lover_Value_Love, 1)
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
        RestoreDisposition(actor1)
    	IOSS_Relationship_Apologize_Success.Show()
    	Debug.Notification("Your partner is no longer upset.")
    elseif (Query == 9) ;Apology Fail
    	actor actor1 = SceneNPC.GetActorReference()
    	if actor1.GetFactionRank(OCR_Lover_State_Upset) == 4
    		Rel_InteractionCooldown24h(actor1)
            MiscUtil.PrintConsole("Relationship_Apologize: UpsetLevel is 4, applying 24-hours interactions cooldown.")
    	elseif actor1.GetFactionRank(OCR_Lover_State_Upset) == 3
    		Rel_InteractionCooldown12h(actor1)
            MiscUtil.PrintConsole("Relationship_Apologize: UpsetLevel is 3, applying 12-hours interactions cooldown.")
    	elseif actor1.GetFactionRank(OCR_Lover_State_Upset) == 2
    		Rel_InteractionCooldown6h(actor1)
            MiscUtil.PrintConsole("Relationship_Apologize: UpsetLevel is 2, applying 6-hours interactions cooldown.")
    	elseif actor1.GetFactionRank(OCR_Lover_State_Upset) == 1
    		Rel_InteractionCooldown2h(actor1)
            MiscUtil.PrintConsole("Relationship_Apologize: UpsetLevel is 1, applying 2-hours interactions cooldown.")
    	endif
    	IOSS_Relationship_Apologize_Fail.Show()
    endif
    ;Reset
    Query = 0
EndEvent

function MakeUpset(actor actor1, int UpsetLevel)
    ;This function will temporarily lower the disposition of the NPC to the player. First, we must store the value to be restored
    int CurrentDisposition = actor1.GetRelationshipRank(playerref)
    if CurrentDisposition < 0
        CurrentDisposition = 0
    endif
    actor1.SetFactionRank(IOSS_DispositionBeforeUpset, CurrentDisposition)
    if UpsetLevel >= 0 && UpsetLevel <= 4
        actor1.SetFactionRank(OCR_Lover_State_Upset, UpsetLevel)
    else
        Debug.Notification("MakeUpset: Passed UpsetLevel " + UpsetLevel + " is not valid.")
    endif
    ;Finally, lower the disposition
    actor1.SetRelationshipRank(playerref, -1)
    MiscUtil.PrintConsole("MakeUpset: lowered NPC's disposition toward PC. Previous value was " + CurrentDisposition)
endFunction

function RestoreDisposition(actor actor1)
    int PreviousDisposition = actor1.GetFactionRank(IOSS_DispositionBeforeUpset)
    actor1.SetRelationshipRank(playerref, PreviousDisposition)
    actor1.RemoveFromFaction(IOSS_DispositionBeforeUpset)
    MiscUtil.PrintConsole("RestoreDisposition: restored NPC's disposition value of " + PreviousDisposition)
endfunction

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

function Make3PPCandidates()
    IOSS_Make3PPCandidatesQST.Stop()
    IOSS_Make3PPCandidatesQST.Start()
endfunction