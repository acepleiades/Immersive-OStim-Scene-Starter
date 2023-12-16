;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 19
Scriptname QF_IOSS_StartUpQuest_1300590A Extends Quest Hidden

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
(IOSS_StartUp as IOSS_StartUpQuest).InitialAttractivenessQuestion()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property IOSS_StartUp  Auto  

GlobalVariable Property IOSS_AttractivenessBase  Auto  
