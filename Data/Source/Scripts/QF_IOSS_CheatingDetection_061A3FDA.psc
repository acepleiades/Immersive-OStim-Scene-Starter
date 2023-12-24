;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname QF_IOSS_CheatingDetection_061A3FDA Extends Quest Hidden

;BEGIN ALIAS PROPERTY SceneInteractionSubject
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SceneInteractionSubject Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DetectedCheatingAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DetectedCheatingAlias Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE IOSS_Cheating
Quest __temp = self as Quest
IOSS_Cheating kmyQuest = __temp as IOSS_Cheating
;END AUTOCAST
;BEGIN CODE
Debug.Notification("IOSS_CheatingDetection started")
(kmyQuest as IOSS_Cheating).DetectCheating()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
