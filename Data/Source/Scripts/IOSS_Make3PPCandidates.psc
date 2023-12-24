Scriptname IOSS_Make3PPCandidates extends Quest  

Faction Property OCR_OStimScenes_3PPCandidateFaction  Auto
ReferenceAlias Property AddCandidate  Auto
ReferenceAlias Property RemoveCandidate  Auto

function Update3PPCandidates()
	;These functions will most often than not be aborted because the alias was not filled. That's intended
	AddCandidate.GetActorReference().AddToFaction(OCR_OStimScenes_3PPCandidateFaction)
	RemoveCandidate.GetActorReference().RemoveFromFaction(OCR_OStimScenes_3PPCandidateFaction)
endfunction