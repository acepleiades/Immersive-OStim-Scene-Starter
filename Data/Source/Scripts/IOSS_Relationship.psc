Scriptname IOSS_Relationship extends Quest  

Faction Property OCR_Lover_AcceptsMultiplePartnersFaction  Auto
Faction Property OCR_Lover_Commitment  Auto
Faction Property OCR_Lover_PlayerCommittedRelationshipFaction  Auto
Faction Property OCR_Lover_Value_Intimacy  Auto
Faction Property OCR_Lover_Value_Love  Auto
Faction Property OCR_Trait_EnthusiastArcane  Auto
Faction Property OCR_Trait_EnthusiastEscapade  Auto
Faction Property OCR_Trait_EnthusiastMartial  Auto
Faction Property OCR_SocialClass_CitizenLow Auto
Faction Property OCR_SocialClass_CitizenLowest Auto
Faction Property OCR_SocialClass_CitizenMiddle Auto
Faction Property OCR_SocialClass_CitizenNoble Auto
Faction Property OCR_SocialClass_Other Auto
Faction Property OCR_SocialClass_SoldierOrGuard Auto
GlobalVariable Property OCR_CurrentAttraction  Auto
GlobalVariable Property IOSS_ShownTooltip_EndAnimation  Auto
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
Message Property IOSS_Relationship_GoSteady_No  Auto
Message Property IOSS_Relationship_GoSteady_Yes_PCExclusive  Auto
Message Property IOSS_Relationship_GoSteady_Yes_PCNonExclusive  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_Maybe  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_No  Auto
Message Property IOSS_Relationship_PersuadeNonExcl_Yes  Auto
Message Property IOSS_Relationship_PersuadedNE_Attraction  Auto
Message Property IOSS_Relationship_PersuadedNE_Intimacy  Auto
Message Property IOSS_Relationship_PersuadedNE_Love  Auto
Message Property IOSS_Tooltip_EndAnimation  Auto
OCR_OStimSequencesUtil Property Util Auto
ReferenceAlias Property SceneNPC  Auto

; Script-wide variable to track which animation was played
Int property Query Auto

function TooltipEndAnimation()
    if (IOSS_ShownTooltip_EndAnimation.GetValue()) == 0
        IOSS_Tooltip_EndAnimation.Show()
        IOSS_ShownTooltip_EndAnimation.SetValue(1)
    endif
endfunction

;Inquire interactions are for learning information about the NPC.
function Inquire_Interests(actor actor1)
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 1
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Inquire_SocialClass(actor actor1)
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 2
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endfunction
function Inquire_Commitment(actor actor1)
	TooltipEndAnimation()
    Util.StandingConversation(actor1)
    Query = 3
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
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
    endif
    if (Query == 3) ;Inquire_Interests
    	actor actor1 = SceneNPC.GetActorReference()
    	if actor1.GetFactionRank(OCR_Lover_Commitment) == 0
    		IOSS_Inquire_Commitment_0.Show()
    	ElseIf actor1.GetFactionRank(OCR_Lover_Commitment) == 1
    		IOSS_Inquire_Commitment_1.Show()
    	ElseIf actor1.GetFactionRank(OCR_Lover_Commitment) == 2
    		IOSS_Inquire_Commitment_2.Show()
    	Else
    		Debug.Notification("There was nothing to talk about.")
    	endif
    endif
    ;Reset
    SceneNPC.Clear()
    Query = 0
EndEvent