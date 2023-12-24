Scriptname IOSS_AdultScene extends Quest  

GlobalVariable Property IOSS_CheatingDetectionType  Auto  
Quest Property IOSS_CheatingDetection  Auto  
ReferenceAlias Property SceneNPC  Auto  
OCR_OStimScenesUtil Property Util Auto

function StartAdultScene(actor actor1)
    SceneNPC.Clear()
    SceneNPC.ForceRefTo(actor1)
    IOSS_CheatingDetectionType.SetValue(1)
    IOSS_CheatingDetection.Stop()
    IOSS_CheatingDetection.Start()
    (IOSS_CheatingDetection as IOSS_Cheating).AdultSceneDetectCheating(actor1)
    Util.OCR_StartScene(actor1)
endfunction