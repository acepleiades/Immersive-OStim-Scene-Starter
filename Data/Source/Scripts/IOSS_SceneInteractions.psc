Scriptname IOSS_SceneInteractions extends Quest  

OCR_OStimSequencesUtil Property Util Auto
message property IOSS_Scene_Chat_ConfessS auto

function ConfessSuccess(actor actor1)
    RegisterForModEvent("ostim_end", "OStimEnd")

    Util.Court(actor1)
endFunction

Event OStimEnd(string eventName, string strArg, float numArg, Form sender)
	Utility.Wait(0.5)
	IOSS_Scene_Chat_ConfessS.show()
EndEvent