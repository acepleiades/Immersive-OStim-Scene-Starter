Scriptname IOSS_SceneInteractions extends Quest  

OCR_OStimSequencesUtil Property Util Auto
message property IOSS_Scene_Chat_ConfessS auto
message property IOSS_Scene_Chat_ConfessF auto
GlobalVariable Property IOSS_CurrentAttraction  Auto  

; Script-wide variable to track which animation was played
Int property AnimationPlayed Auto

function Confess(actor actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")

    if (IOSS_CurrentAttraction.GetValue() >= 1)
        Util.Court(actor1)
        AnimationPlayed = 1  ; Indicates the "Court" animation was played
    else
        Util.CourtFail(actor1)
        AnimationPlayed = 2  ; Indicates the "CourtFail" animation was played
    endif
endFunction

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
    Utility.Wait(0.5)

    if (AnimationPlayed == 1)
        IOSS_Scene_Chat_ConfessS.Show()
    elseif (AnimationPlayed == 2)
        IOSS_Scene_Chat_ConfessF.Show()
    endif

    ; Reset the variable for future use
    AnimationPlayed = 0
EndEvent