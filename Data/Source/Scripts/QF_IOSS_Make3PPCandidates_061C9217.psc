;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname QF_IOSS_Make3PPCandidates_061C9217 Extends Quest Hidden

;BEGIN ALIAS PROPERTY RemoveCandidate
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RemoveCandidate Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AddCandidate
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AddCandidate Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE IOSS_Make3PPCandidates
Quest __temp = self as Quest
IOSS_Make3PPCandidates kmyQuest = __temp as IOSS_Make3PPCandidates
;END AUTOCAST
;BEGIN CODE
(kmyQuest as IOSS_Make3PPCandidates).Update3PPCandidates()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
