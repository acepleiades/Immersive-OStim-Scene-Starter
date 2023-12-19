Scriptname IOSS_SceneInteractions extends Quest  

OCR_OStimSequencesUtil Property Util Auto
ReferenceAlias Property SceneNPC  Auto  
GlobalVariable Property IOSS_CurrentAttraction  Auto  
Faction Property OCR_Lover_Value_Intimacy  Auto  
Actor Property PlayerRef Auto
Message Property IOSS_SceneMSG_Chatter_Success1  Auto  
Message Property IOSS_SceneMSG_Chatter_Fail1  Auto  

; Script-wide variable to track which animation was played
Int property AnimationPlayed Auto

function Chatter(actor actor1)
    ;Calculate the success rate for this interaction
    float Bonus_Attraction = ((IOSS_CurrentAttraction.GetValue() + 1) * playerref.GetAV("Speechcraft"))
    float Bonus_Intimacy = (actor1.GetFactionRank(OCR_Lover_Value_Intimacy) / 2)
    float Bonus_DispositionRank = (actor1.GetRelationshipRank(playerref) * 12.5)
    float SuccessRate = ((Bonus_Attraction + Bonus_Intimacy + Bonus_DispositionRank) / 100)
    MiscUtil.PrintConsole("IOSS_SceneInteractions: Success rate is" + SuccessRate)
    
    ;Now, "roll the dice"
    float r = Utility.RandomFloat(0, 100)
    if r < SuccessRate
    ;If it was successful
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
        IOSS_SceneMSG_Chatter_Success1.Show()
    elseif (AnimationPlayed == 2)
        IOSS_SceneMSG_Chatter_Fail1.Show()
    endif
    
    ;Reset
    SceneNPC.Clear()
    AnimationPlayed = 0
EndEvent