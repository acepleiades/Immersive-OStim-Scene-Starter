;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname IOSS_TIF__0608EA6C Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(GetOwningQuest() as OCR_AttractionUtil).GetAttraction(akspeaker)
(GetOwningQuest() as OCR_CommitmentUtil).GetCommitment(akspeaker)
(GetOwningQuest() as IOSS_Relationship).Make3PPCandidates()
(GetOwningQuest() as IOSS_SceneInteractions).OfCourseCooldown(akspeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
