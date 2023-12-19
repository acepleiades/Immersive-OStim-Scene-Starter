Scriptname IOSS_SceneInteractions extends Quest  

Actor Property PlayerRef Auto
Faction Property OCR_Lover_Value_Intimacy  Auto
GlobalVariable Property GameHour  auto
GlobalVariable Property IOSS_ShownTooltip_ChatterFail  Auto
GlobalVariable Property OCR_CurrentAttraction  Auto
Message Property IOSS_SceneMSG_Chatter_Fail1  Auto
Message Property IOSS_SceneMSG_Chatter_Success1  Auto
Message Property IOSS_SceneMSG_RevealAttracted  Auto
Message Property IOSS_SceneMSG_RevealNotAttracted  Auto
Message Property IOSS_Tooltip_ChatterFail  Auto
OCR_OStimSequencesUtil Property Util Auto
ReferenceAlias Property SceneNPC  Auto
SPELL Property IOSS_InteractionCooldownSpell2h  Auto

; Script-wide variable to track which animation was played
Int property AnimationPlayed Auto
; Keeping track of time

function SceneChatter(actor actor1)
    ;If the NPC is not in the Intimacy value faction, add to it
    actor1.AddToFaction(OCR_Lover_Value_Intimacy)

    ;Calculate the success rate for this interaction
    float Bonus_Attraction = ((OCR_CurrentAttraction.GetValue() + 1) * ((playerref.GetAV("Speechcraft")) * 1.2))
    float Bonus_Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    float Bonus_DispositionRank = ((actor1.GetRelationshipRank(playerref) + 1) * 12.5)
    float SuccessChance = Bonus_Attraction + Bonus_Intimacy + Bonus_DispositionRank
    MiscUtil.PrintConsole("IOSS_SceneInteractions: Bonus_Attraction is " + Bonus_Attraction)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: Bonus_Intimacy is " + Bonus_Intimacy)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: Bonus_DispositionRank is " + Bonus_DispositionRank)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: Success rate for this interaction is " + SuccessChance)

    ;Now, "roll the dice"
    float RandomChance = Utility.RandomFloat(0, 100)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: 'Dice roll' is " + RandomChance)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: See that the 'dice roll' has to be lower than the success rate to succeed.")
    if RandomChance < SuccessChance
    ;If it was successful
        int currentIntimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
        int newIntimacy = currentIntimacy + ((actor1.GetRelationshipRank(playerref) + 1) * 2)
        actor1.SetFactionRank(OCR_Lover_Value_Intimacy, newIntimacy)
        Util.Chatter(actor1)
        AnimationPlayed = 1  ; Indicates the "Chatter" animation was played
    else
        Util.ChatterFail(actor1)
        AnimationPlayed = 2  ; Indicates the "ChatterFail" animation was played
    endif
    SceneNPC.ForceRefTo(actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
    Utility.Wait(0.5)

    ;Display the message after the scene
    if (AnimationPlayed == 1)
        ;Chatter_Success
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 2
        GameHour.SetValue(newHour)
        Debug.Notification("Intimacy with your partner has increased.")
        ;Speech gain
        Game.AdvanceSkill("Speechcraft", 200.0)
        IOSS_SceneMSG_Chatter_Success1.Show()

        ;Calculate the chance of attraction value being revealed
        float AttractionRevealChance = (playerref.GetAV("Speechcraft") / 2) + (OCR_CurrentAttraction.GetValue() * 10)
        float RandomChance = Utility.RandomFloat(0, 100)

        ;Check if the attraction value should be revealed
        if RandomChance < AttractionRevealChance
            if OCR_CurrentAttraction.GetValue() >= 1
                IOSS_SceneMSG_RevealAttracted.Show()
            Else
                IOSS_SceneMSG_RevealNotAttracted.Show()
            endif
        endif
    elseif (AnimationPlayed == 2)
        ;Chatter_Fail
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 1
        GameHour.SetValue(newHour)
        ;Speech gain
        Game.AdvanceSkill("Speechcraft", 1000.0)
        ;Interaction cooldown
        actor actor1 = SceneNPC.GetActorReference()
        IOSS_InteractionCooldownSpell2h.Cast(actor1, actor1)
        IOSS_SceneMSG_Chatter_Fail1.Show()
        if (IOSS_ShownTooltip_ChatterFail.GetValue()) == 0
            IOSS_Tooltip_ChatterFail.Show()
            IOSS_ShownTooltip_ChatterFail.SetValue(1)
        endif
    endif

    ;Reset
    SceneNPC.Clear()
    AnimationPlayed = 0
EndEvent