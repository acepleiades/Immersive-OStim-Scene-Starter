Scriptname IOSS_StartUpSpell extends ActiveMagicEffect  

Quest Property IOSS_StartUp  Auto  
SPELL Property IOSS_StartUp_Spell  Auto  

Function OnEffectStart(Actor akTarget, Actor akCaster)
IOSS_StartUp.Start()
akCaster.removespell(IOSS_StartUp_Spell)
EndFunction