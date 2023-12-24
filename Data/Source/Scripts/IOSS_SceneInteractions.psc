Scriptname IOSS_SceneInteractions extends Quest  

Actor Property PlayerRef Auto
Faction Property IOSS_Revealed_Attracted  Auto
Faction Property OCR_Lover_Commitment  Auto
Faction Property OCR_Lover_PlayerCommittedRelationshipFaction  Auto
Faction Property OCR_Lover_Value_Intimacy  Auto
Faction Property OCR_Lover_Value_Love  Auto
GlobalVariable Property GameHour  auto
GlobalVariable Property IOSS_ShownTooltip_CaressFail  Auto
GlobalVariable Property IOSS_ShownTooltip_ChatterFail  Auto
GlobalVariable Property IOSS_ShownTooltip_CourtFail  Auto
GlobalVariable Property OCR_CurrentAttraction  Auto
Message Property IOSS_SceneMSG_Caress_Fail1  Auto
Message Property IOSS_SceneMSG_Chatter_Fail1  Auto
Message Property IOSS_SceneMSG_Chatter_Success1  Auto
Message Property IOSS_SceneMSG_Court_Fail1  Auto
Message Property IOSS_SceneMSG_Court_Success1  Auto
Message Property IOSS_SceneMSG_RevealAttracted  Auto
Message Property IOSS_SceneMSG_RevealNotAttracted  Auto
Message Property IOSS_Tooltip_CaressFail  Auto
Message Property IOSS_Tooltip_ChatterFail  Auto
Message Property IOSS_Tooltip_CourtFail  Auto
OCR_OStimSequencesUtil Property Util Auto
Quest Property IOSS_CheatingDetection  Auto
ReferenceAlias Property SceneNPC  Auto
SPELL Property IOSS_InteractionCooldownSpell12h  Auto
SPELL Property IOSS_InteractionCooldownSpell24h  Auto
SPELL Property IOSS_InteractionCooldownSpell2h  Auto
SPELL Property IOSS_InteractionCooldownSpell6h  Auto
SPELL Property IOSS_OfCourseCooldownSpell  Auto

; Script-wide variables
Int property AnimationPlayed Auto

function SceneChatter(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    actor1.AddToFaction(OCR_Lover_Value_Intimacy)
    ;Calculate the success rate for this interaction
    float Bonus_AttractionSpeech = (OCR_CurrentAttraction.GetValue() + 1) * ((playerref.GetAV("Speechcraft")))
    float Bonus_Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    float Bonus_RelationshipRank = (actor1.GetRelationshipRank(playerref) + 1) * 12.5
    float SuccessChance = Bonus_AttractionSpeech + Bonus_Intimacy + Bonus_RelationshipRank
    MiscUtil.PrintConsole("SceneChatter: Bonus_AttractionSpeech is " + Bonus_AttractionSpeech)
    MiscUtil.PrintConsole("SceneChatter: Bonus_Intimacy is " + Bonus_Intimacy)
    MiscUtil.PrintConsole("SceneChatter: Bonus_RelationshipRank is " + Bonus_RelationshipRank)
    MiscUtil.PrintConsole("SceneChatter: Success rate for this interaction is " + SuccessChance)
    ;Now, "roll the dice"
    float RandomChance = Utility.RandomFloat(0, 100)
    MiscUtil.PrintConsole("SceneChatter: 'Dice roll' is " + RandomChance)
    MiscUtil.PrintConsole("SceneChatter: See that the 'dice roll' has to be lower than the success rate to succeed.")
    if RandomChance < SuccessChance
    ;If it was successful
        int currentIntimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
        if currentIntimacy < 100
            int newIntimacy = currentIntimacy + ((actor1.GetRelationshipRank(playerref) + 1) * 2)
            actor1.SetFactionRank(OCR_Lover_Value_Intimacy, newIntimacy)
        endif
        Util.Chatter(actor1)
        AnimationPlayed = 1  ; Indicates the "Chatter" result
    else
        Util.ChatterFail(actor1)
        AnimationPlayed = 2  ; Indicates the "ChatterFail" result
    endif
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction

function SceneCourt(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    IOSS_CheatingDetection.Start()
    actor1.AddToFaction(OCR_Lover_Value_Love)
    ;Automatic failure if attraction is too low
    if OCR_CurrentAttraction.GetValue() > 0.85
        ;Calculate the success rate for this interaction
        float Bonus_Attraction = OCR_CurrentAttraction.GetValue() * 50
        float Bonus_Love = actor1.GetFactionRank(OCR_Lover_Value_Love)
        float Bonus_Speechcraft = playerref.GetAV("Speechcraft") / 5
        float SuccessChance = Bonus_Attraction + Bonus_Love + Bonus_Speechcraft
        MiscUtil.PrintConsole("SceneCourt: Bonus_Attraction is " + Bonus_Attraction)
        MiscUtil.PrintConsole("SceneCourt: Bonus_Love is " + Bonus_Love)
        MiscUtil.PrintConsole("SceneCourt: Bonus_Speechcraft is " + Bonus_Speechcraft)
        MiscUtil.PrintConsole("SceneCourt: Success rate for this interaction is " + SuccessChance)
        ;Now, "roll the dice"
        float RandomChance = Utility.RandomFloat(0, 100)
        MiscUtil.PrintConsole("SceneCourt: 'Dice roll' is " + RandomChance)
        MiscUtil.PrintConsole("SceneCourt: See that the 'dice roll' has to be lower than the success rate to succeed.")
        if RandomChance < SuccessChance
            ;If it was successful
            Util.Court(actor1)
            AnimationPlayed = 3  ; Indicates the "Court" result
        else
            Util.CourtFail(actor1)
            AnimationPlayed = 4  ; Indicates the "CourtFail" result
        endif
    Else
        Util.ChatterFail(actor1)
        AnimationPlayed = 4  ; Indicates the "CourtFail" result
    endIf
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction

function SceneCaress(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    IOSS_CheatingDetection.Start()
    actor1.AddToFaction(OCR_Lover_Value_Love)
    ;Based on NPC's morality, caressing may require a minimum Intimacy value
    float actor1Morality  = actor1.GetAV("Morality")
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    MiscUtil.PrintConsole("SceneCaress: NPC's Morality is " + actor1Morality)
    MiscUtil.PrintConsole("SceneCaress: NPC's actor1Intimacy is " + actor1Intimacy)
    bool WillingToBeCaressed
    if actor1.GetAV("Morality") <= 1
        WillingToBeCaressed = true
    elseIf (actor1.GetAV("Morality") == 2 && actor1Intimacy >= 5)
        WillingToBeCaressed = true
    elseIf (actor1.GetAV("Morality") == 3 && actor1Intimacy >= 10)
        WillingToBeCaressed = true
    else
        MiscUtil.PrintConsole("SceneCaress: NPC is not willing to be caressed due to low Intimacy.")
    endif
    if WillingToBeCaressed == true
        ;Automatic failure if attraction is too low
        if OCR_CurrentAttraction.GetValue() > 0.85
            ;Calculate the success rate for this interaction
            float Bonus_Attraction = (OCR_CurrentAttraction.GetValue() * 30)
            float Bonus_Love = (actor1.GetFactionRank(OCR_Lover_Value_Love) * 1.1)
            float Bonus_Speechcraft = (playerref.GetAV("Speechcraft") / 5)
            float SuccessChance = Bonus_Attraction + Bonus_Love + Bonus_Speechcraft
            MiscUtil.PrintConsole("SceneCaress: Bonus_Attraction is " + Bonus_Attraction)
            MiscUtil.PrintConsole("SceneCaress: Bonus_Love is " + Bonus_Love)
            MiscUtil.PrintConsole("SceneCaress: Bonus_Speechcraft is " + Bonus_Speechcraft)
            MiscUtil.PrintConsole("SceneCaress: Success rate for this interaction is " + SuccessChance)
            ;Now, "roll the dice"
            float RandomChance = Utility.RandomFloat(0, 100)
            MiscUtil.PrintConsole("SceneCaress: 'Dice roll' is " + RandomChance)
            MiscUtil.PrintConsole("SceneCaress: See that the 'dice roll' has to be lower than the success rate to succeed.")
            if RandomChance < SuccessChance
                ;If it was successful
                ;Play a random caressing animation
                int randomCaress = Utility.RandomInt(1, 3)
                if randomCaress == 1
                    Util.CaressCheekStroke(actor1)
                elseIf randomCaress == 2
                    Util.CaressHoldHands(actor1)
                else
                    Util.CaressHug(actor1)
                endif
                AnimationPlayed = 5  ; Indicates a "Caress" result
            else
                Util.CaressFail(actor1)
                AnimationPlayed = 6  ; Indicates the "CaressFail" result
            endif
    Else
        Util.CaressFail(actor1)
        AnimationPlayed = 6  ; Indicates the "CaressFail" result
    endif
    Else
        Util.CaressFail(actor1)
        AnimationPlayed = 6  ; Indicates the "CaressFail" result
    endIf
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction

function SceneKiss(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    IOSS_CheatingDetection.Start()
    actor1.AddToFaction(OCR_Lover_Value_Love)
    ;Based on NPC's morality, kissing may require a minimum Intimacy value
    float actor1Morality  = actor1.GetAV("Morality")
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    MiscUtil.PrintConsole("SceneKiss: NPC's Morality is " + actor1Morality)
    MiscUtil.PrintConsole("SceneKiss: NPC's actor1Intimacy is " + actor1Intimacy)
    bool WillingToKiss
    if actor1.GetAV("Morality") == 0
        WillingToKiss = true
    elseIf actor1.GetAV("Morality") == 1 && actor1Intimacy >= 5
        WillingToKiss = true
    elseif actor1.GetAV("Morality") >= 2 && actor1.IsInFaction(OCR_Lover_PlayerCommittedRelationshipFaction) == 1 && actor1Intimacy >= 10
        WillingToKiss = true
    Else
        MiscUtil.PrintConsole("SceneKiss: NPC is not willing to be kissed due to low Intimacy or not being in a committed relationship.")
    endif
    if WillingToKiss == true
        ;Automatic failure if attraction is too low
        if OCR_CurrentAttraction.GetValue() > 0.85
            ;Calculate the success rate for this interaction
            float Bonus_Attraction = (OCR_CurrentAttraction.GetValue() * 15)
            float Bonus_Love = (actor1.GetFactionRank(OCR_Lover_Value_Love) * 1.5)
            float Bonus_Speechcraft = (playerref.GetAV("Speechcraft") / 10)
            float SuccessChance = Bonus_Attraction + Bonus_Love + Bonus_Speechcraft
            MiscUtil.PrintConsole("SceneKiss: Bonus_Attraction is " + Bonus_Attraction)
            MiscUtil.PrintConsole("SceneKiss: Bonus_Love is " + Bonus_Love)
            MiscUtil.PrintConsole("SceneKiss: Bonus_Speechcraft is " + Bonus_Speechcraft)
            MiscUtil.PrintConsole("SceneKiss: Success rate for this interaction is " + SuccessChance)
            ;Now, "roll the dice"
            float RandomChance = Utility.RandomFloat(0, 100)
            MiscUtil.PrintConsole("SceneKiss: 'Dice roll' is " + RandomChance)
            MiscUtil.PrintConsole("SceneKiss: See that the 'dice roll' has to be lower than the success rate to succeed.")
            if RandomChance < SuccessChance
                ;If it was successful
                Util.Kiss1(actor1) ; To do: adding lots of kissing animations for variety
                AnimationPlayed = 7  ; Indicates a "Kiss" result
            else
                Util.CaressFail(actor1)
                AnimationPlayed = 8  ; Indicates the "Kiss Fail" result
            endif
        Else
            Util.CaressFail(actor1)
            AnimationPlayed = 8  ; Indicates the "Kiss Fail" result
        endIf
    Else
        Util.CaressFail(actor1)
        AnimationPlayed = 8  ; Indicates the "Kiss Fail" result
    endif
    RegisterForModEvent("ostim_end", "OStimEnd")
endFunction

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
    Utility.Wait(0.5)
    ;Display the message after the scene
    if (AnimationPlayed == 1) ;Chatter Success
        ;Intimacy gain notifications
        actor actor1 = SceneNPC.GetActorReference()
        IntimacyGainNotification(actor1)
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 1.5
        GameHour.SetValue(newHour)
        ;Speech gain
        Game.AdvanceSkill("Speechcraft", 200.0)
        ;Result messages
        IOSS_SceneMSG_Chatter_Success1.Show()
        ;Reveal attraction
        RevealAttraction(actor1)
    elseif (AnimationPlayed == 2) ;Chatter Fail
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 0.5
        GameHour.SetValue(newHour)
        ;Speech gain
        Game.AdvanceSkill("Speechcraft", 1000.0)
        ;Interactions cooldown of two in-game hours
        InteractionCooldown2h(SceneNPC.GetActorReference())
        ;Result message
        IOSS_SceneMSG_Chatter_Fail1.Show()
        ;Tooltip for first failure
        if (IOSS_ShownTooltip_ChatterFail.GetValue()) == 0
            IOSS_Tooltip_ChatterFail.Show()
            IOSS_ShownTooltip_ChatterFail.SetValue(1)
        endif
    elseif (AnimationPlayed == 3) ;Court Success
        ;Love gain notifications
        actor actor1 = SceneNPC.GetActorReference()
            ;Courting has diminishing returns on Love increase
            int currentLove = actor1.GetFactionRank(OCR_Lover_Value_Love)
            if currentLove < 100
                if currentLove < 15
                    LoveGain(actor1, 3)
                elseIf currentLove < 30
                    LoveGain(actor1, 2)
                elseIf currentLove < 60
                    LoveGain(actor1, 1)
                endif
            endif
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 1.5
        GameHour.SetValue(newHour)
        ;Speech gain
        Game.AdvanceSkill("Speechcraft", 300.0)
        ;Result message
        IOSS_SceneMSG_Court_Success1.Show()
    elseif (AnimationPlayed == 4) ;Court Fail
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 0.5
        GameHour.SetValue(newHour)
        ;Speech gain
        Game.AdvanceSkill("Speechcraft", 1500.0)
        ;Interactions cooldown of two in-game hours
        InteractionCooldown2h(SceneNPC.GetActorReference())
        ;Result message
        IOSS_SceneMSG_Court_Fail1.Show()
        ;Tooltip for first failure
        if (IOSS_ShownTooltip_CourtFail.GetValue()) == 0
            IOSS_Tooltip_CourtFail.Show()
            IOSS_ShownTooltip_CourtFail.SetValue(1)
        endif
    elseif (AnimationPlayed == 5) ;Caress Success
        ;Love gain notifications
        actor actor1 = SceneNPC.GetActorReference()
        ;Caressing has diminishing returns on Love increase
        int currentLove = actor1.GetFactionRank(OCR_Lover_Value_Love)
        if currentLove < 100
            if currentLove < 15
                LoveGain(actor1, 4)
            elseIf currentLove < 30
                LoveGain(actor1, 3)
            elseIf currentLove < 60
                LoveGain(actor1, 2)
            elseIf currentLove < 100
                LoveGain(actor1, 1)
            endif
        endif
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 0.5
        GameHour.SetValue(newHour)
    elseif (AnimationPlayed == 6) ;Caress Fail
        ;Interactions cooldown of two in-game hours
        InteractionCooldown2h(SceneNPC.GetActorReference())
        ;Result message
        IOSS_SceneMSG_Caress_Fail1.Show()
        ;Tooltip for first failure
        if (IOSS_ShownTooltip_CaressFail.GetValue()) == 0
            IOSS_Tooltip_CaressFail.Show()
            IOSS_ShownTooltip_CaressFail.SetValue(1)
        endif
    elseif (AnimationPlayed == 7) ;Kiss Success
        ;Love gain notifications
        actor actor1 = SceneNPC.GetActorReference()
            ;Kissing has diminishing returns on Love increase
            int currentLove = actor1.GetFactionRank(OCR_Lover_Value_Love)
            if currentLove < 100
                if currentLove < 25
                    LoveGain(actor1, 5)
                elseIf currentLove < 50
                    LoveGain(actor1, 4)
                elseIf currentLove < 75
                    LoveGain(actor1, 3)
                elseIf currentLove < 100
                    LoveGain(actor1, 2)
                endif
            endif
        ;Skip time based on result
        float currentHour = GameHour.GetValue()
        float newHour = currentHour + 0.5
        GameHour.SetValue(newHour)
    elseif (AnimationPlayed == 8) ;Kiss Fail
        ;Interactions cooldown that goes down with higher Intimacy
        actor actor1 = SceneNPC.GetActorReference()
        float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
        if actor1Intimacy < 15
            InteractionCooldown12h(actor1)
        elseif actor1Intimacy < 30
            InteractionCooldown6h(actor1)
        else
            InteractionCooldown2h(actor1)
        endif
        InteractionCooldown6h(SceneNPC.GetActorReference())
        ;Result message
        IOSS_SceneMSG_Caress_Fail1.Show()
        ;Tooltip for first failure
        if (IOSS_ShownTooltip_CaressFail.GetValue()) == 0
            IOSS_Tooltip_CaressFail.Show()
            IOSS_ShownTooltip_CaressFail.SetValue(1)
        endif
    endif
    ;Reset
    AnimationPlayed = 0
EndEvent

function RevealAttraction(actor actor1)
    ;If attraction for this NPC has not been revealed before, calculate the chance of attraction value being revealed
    if SceneNPC.GetActorReference().IsInFaction(IOSS_Revealed_Attracted) == 0
        ;Calculate the success rate for attraction reveal
        float AttractionRevealChance = (playerref.GetAV("Speechcraft") / 3) + (OCR_CurrentAttraction.GetValue() * 10)
        float RandomChance = Utility.RandomFloat(0, 100)
        ;Check if the attraction value should be revealed
        if RandomChance < AttractionRevealChance
            if OCR_CurrentAttraction.GetValue() >= 0.85
                ;NPC is, at least, somewhat attracted
                IOSS_SceneMSG_RevealAttracted.Show()
                SceneNPC.GetActorReference().AddToFaction(IOSS_Revealed_Attracted)
            else
                ;NPC is not attracted
                IOSS_SceneMSG_RevealNotAttracted.Show()
            endif
        endif
    endif
endFunction

function IntimacyGainNotification(actor actor1)
    int currentIntimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    ;Do not display a notification if Intimacy is already at its maximum value
    if currentIntimacy != 100
        if currentIntimacy < 10
            Debug.Notification("Your companionship is a budding connection.")
        elseif currentIntimacy < 20
            Debug.Notification("Your companionship is a growing bond.")
        elseif currentIntimacy < 30
            Debug.Notification("Your companionship is deepening.")
        elseif currentIntimacy < 40
            Debug.Notification("Your companionship is a meaningful connection.")
        elseif currentIntimacy < 50
            Debug.Notification("Your companionship is a strong bond.")
        elseif currentIntimacy < 60
            Debug.Notification("Your companionship is a trusted partnership.")
        elseif currentIntimacy < 70
            Debug.Notification("Your companionship is a deepening loyalty.")
        elseif currentIntimacy < 80
            Debug.Notification("Your companionship is an harmonious bond.")
        elseif currentIntimacy < 90
            Debug.Notification("Your companionship is unwavering.")
        else
            Debug.Notification("Your companionship is forged in trust.")
        endif
        Debug.Notification("Intimacy with your partner has increased.")
    endif
endFunction

function LoveGain(actor actor1, int value)
    int actor1Commitment = actor1.GetFactionRank(OCR_Lover_Commitment)
    int actor1Love = actor1.GetFactionRank(OCR_Lover_Value_Love)
    ;There is a restriction on love gain based on Commitment
    if actor1Commitment == 1 && actor1Love > 20 && actor1.IsInFaction(OCR_Lover_PlayerCommittedRelationshipFaction) == 0
        Debug.Notification("You must commit to this person to progress the relationship.")
        return
    elseif actor1Commitment == 2 && actor1Love > 10 && actor1.IsInFaction(OCR_Lover_PlayerCommittedRelationshipFaction) == 0
        Debug.Notification("You must commit to this person to progress the relationship.")
        return
    endif
    int newLove = actor1Love + value
    actor1.SetFactionRank(OCR_Lover_Value_Love, newLove)
    LoveGainNotification(actor1)
    MiscUtil.PrintConsole("LoveGain: Commitment restriction on love gain not applied.")
endfunction

function LoveGainNotification(actor actor1)
    int currentLove = actor1.GetFactionRank(OCR_Lover_Value_Love)
    ;Do not display a notification if Intimacy is already at its maximum value
    if currentLove != 100
        if currentLove < 10
            Debug.Notification("Your relationship is an initial spark.")
        elseif currentLove < 20
            Debug.Notification("Your relationship is a growing attraction.")
        elseif currentLove < 30
            Debug.Notification("Your relationship is a budding romance.")
        elseif currentLove < 40
            Debug.Notification("Your relationship is an emerging affection.")
        elseif currentLove < 50
            Debug.Notification("Your relationship is a deepening fondness.")
        elseif currentLove < 60
            Debug.Notification("Your relationship brings warm feelings.")
        elseif currentLove < 70
            Debug.Notification("Your relationship is an intensifying passion.")
        elseif currentLove < 80
            Debug.Notification("Your relationship is deep love.")
        elseif currentLove < 90
            Debug.Notification("Your relationship is an intimate bond.")
        else
            Debug.Notification("Your relationship is true love.")
endif
    Debug.Notification("Love with your partner has increased.")
    endif
endFunction

;Functions for applying cooldowns
function OfCourseCooldown(actor actor1)
    ;It is annoying to keep hearing "of course" across multiple interactions, so this function will apply a temporary keyword for the NPC to use the unvoiced (Nods) response instead.
    IOSS_OfCourseCooldownSpell.Cast(playerref, actor1)
endFunction
function InteractionCooldown2h(actor actor1)
    IOSS_InteractionCooldownSpell2h.Cast(playerref, actor1)
endFunction
function InteractionCooldown6h(actor actor1)
    IOSS_InteractionCooldownSpell6h.Cast(playerref, actor1)
endFunction
function InteractionCooldown12h(actor actor1)
    IOSS_InteractionCooldownSpell12h.Cast(playerref, actor1)
endFunction
function InteractionCooldown24h(actor actor1)
    IOSS_InteractionCooldownSpell24h.Cast(playerref, actor1)
endFunction

;A function for calculating the interactions cooldown when the player failed to seduce NPC. The cooldown goes down with higher Intimacy. No cooldown is applied if NPC is committed to the player.
function RefusalCooldown_Seduce(actor actor1)
    float actor1Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    if actor1.IsInFaction(OCR_Lover_PlayerCommittedRelationshipFaction) == 0
        if actor1Intimacy < 5
            InteractionCooldown24h(actor1)
        elseif actor1Intimacy < 15
            InteractionCooldown12h(actor1)
        elseif actor1Intimacy < 45
            InteractionCooldown6h(actor1)
        else
            InteractionCooldown2h(actor1)
        endif
    endif
endfunction