Scriptname IOSS_Attraction extends Quest  

Actor Property PlayerRef Auto
GlobalVariable Property IOSS_AttractivenessBase  Auto  

Faction Property IOSS_IsAttractedFaction auto
Faction Property IOSS_Trait_EnthusiastArcane auto
Faction Property IOSS_Trait_EnthusiastEscapade auto
Faction Property IOSS_Trait_EnthusiastMartial auto

Quest Property MG08  Auto  
Quest Property C06 Auto  
Quest Property DB11 Auto  
Quest Property TGLeadership Auto  

Quest Property Favor250 Auto  
Quest Property Favor252 Auto  
Quest Property Favor253 Auto  
Quest Property Favor254 Auto  
Quest Property Favor255 Auto  
Quest Property Favor256 Auto  
Quest Property Favor257 Auto  
Quest Property Favor258 Auto  
Quest Property FreeformRiftenThane Auto  

Faction Property CrimeFactionEastmarch  Auto  
Faction Property CrimeFactionFalkreath Auto  
Faction Property CrimeFactionHaafingar Auto  
Faction Property CrimeFactionHjaalmarch Auto  
Faction Property CrimeFactionPale Auto  
Faction Property CrimeFactionReach Auto  
Faction Property CrimeFactionRift Auto  
Faction Property CrimeFactionWhiterun Auto  
Faction Property CrimeFactionWinterhold Auto  

SPELL Property WerewolfChange  Auto  
Keyword Property Vampire  Auto  

Quest Property MQ305 Auto  

Race Property ArgonianRace  Auto  
Race Property BretonRace Auto  
Race Property DarkElfRace Auto  
Race Property HighElfRace Auto  
Race Property ImperialRace Auto  
Race Property KhajiitRace Auto  
Race Property NordRace Auto  
Race Property OrcRace Auto  
Race Property RedguardRace Auto  
Race Property WoodElfRace Auto  

Class Property Beggar  Auto  
Class Property Prisoner Auto  
Class Property Farmer  Auto  
Class Property Miner  Auto  
Class Property Lumberjack  Auto  
Class Property Citizen  Auto  
Class Property GuardImperial  Auto  
Class Property GuardSonsSkyrim  Auto  
Class Property Jailor  Auto  
Class Property Bard  Auto  
Class Property Priest  Auto  

bool Function IsNPCAttracted(actor actor1)
    ;If the NPC is in the IsAttracted faction, calculations are skipped.
    if actor1.IsInFaction(IOSS_IsAttractedFaction)
        return true
    else
        ;Initializations
        float AttractivenessBonus_Race = 0
        float AttractivenessBonus_Skills = 0
        float AttractivenessBonus_Fame = 0
        float AttractivenessBonus_FactionLeader = 0
        float AttractivenessBonus_Monster = 0
        float AttractivenessBonus_MainQuest = 0

        ;Step one: get the player's base Attractiveness.
        float AttractivenessBase = IOSS_AttractivenessBase.GetValue()

        ;Step two: calculate the PC's Attractiveness bonus from the NPC's racial preferences.
        Race actor1Race = actor1.GetRace()
        if actor1Race == ArgonianRace
            AttractivenessBonus_Race += playerref.GetActorValue("Lockpicking") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Alteration") + playerref.GetActorValue("Pickpocket") + playerref.GetActorValue("Restoration") + playerref.GetActorValue("Sneak")) / 20  ; Minor skills
        elseif actor1Race == BretonRace
            AttractivenessBonus_Race += playerref.GetActorValue("Conjuration") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("Speech") + playerref.GetActorValue("Alchemy") + playerref.GetActorValue("Illusion") + playerref.GetActorValue("Restoration") + playerref.GetActorValue("Alteration")) / 20  ; Minor skills
        elseif actor1Race == DarkElfRace
            AttractivenessBonus_Race += playerref.GetActorValue("Destruction") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Sneak") + playerref.GetActorValue("Alchemy") + playerref.GetActorValue("Illusion") + playerref.GetActorValue("Alteration")) / 20  ; Minor skills
        elseif actor1Race == HighElfRace
            AttractivenessBonus_Race += playerref.GetActorValue("Illusion") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("Alteration") + playerref.GetActorValue("Conjuration") + playerref.GetActorValue("Destruction") + playerref.GetActorValue("Enchanting") + playerref.GetActorValue("Restoration")) / 20  ; Minor skills
        elseif actor1Race == ImperialRace
            AttractivenessBonus_Race += playerref.GetActorValue("Restoration") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("HeavyArmor") + playerref.GetActorValue("Block") + playerref.GetActorValue("OneHanded") + playerref.GetActorValue("Destruction") + playerref.GetActorValue("Enchanting")) / 20  ; Minor skills
        elseif actor1Race == KhajiitRace
            AttractivenessBonus_Race += playerref.GetActorValue("Sneak") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("OneHanded") + playerref.GetActorValue("Archery") + playerref.GetActorValue("Lockpicking") + playerref.GetActorValue("Pickpocket") + playerref.GetActorValue("Alchemy")) / 20  ; Minor skills
        elseif actor1Race == NordRace
            AttractivenessBonus_Race += playerref.GetActorValue("TwoHanded") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("Smithing") + playerref.GetActorValue("Block") + playerref.GetActorValue("OneHanded") + playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Speech")) / 20  ; Minor skills
        elseif actor1Race == OrcRace
            AttractivenessBonus_Race += playerref.GetActorValue("HeavyArmor") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("Smithing") + playerref.GetActorValue("Block") + playerref.GetActorValue("TwoHanded") + playerref.GetActorValue("OneHanded") + playerref.GetActorValue("Enchanting")) / 20  ; Minor skills
        elseif actor1Race == RedguardRace
            AttractivenessBonus_Race += playerref.GetActorValue("OneHanded") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("Smithing") + playerref.GetActorValue("TwoHanded") + playerref.GetActorValue("Archery") + playerref.GetActorValue("Destruction") + playerref.GetActorValue("Alteration")) / 20  ; Minor skills
        elseif actor1Race == WoodElfRace
            AttractivenessBonus_Race += playerref.GetActorValue("Archery") / 4  ; Major skill
            AttractivenessBonus_Race += (playerref.GetActorValue("Alchemy") + playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Lockpicking") + playerref.GetActorValue("Pickpocket") + playerref.GetActorValue("Sneak")) / 20  ; Minor skills
        else  ; For every other race
            int playerLevel = playerref.GetLevel()
            AttractivenessBonus_Race += playerLevel / 2.0  ; Adjust the divisor as needed for game balance
        endif

        ;Step three: calculate the PC's Attractiveness bonus from skills.
        if actor1.IsInFaction(IOSS_Trait_EnthusiastArcane) || actor1.IsInFaction(IOSS_Trait_EnthusiastEscapade) || actor1.IsInFaction(IOSS_Trait_EnthusiastMartial)
            AttractivenessBonus_Skills = CalculateSkillAttractivenessBonus(actor1)
        else
            GiveRandomEnthusiastTrait(actor1)
            AttractivenessBonus_Skills = CalculateSkillAttractivenessBonus(actor1)
        endif

        ;Step four: take into account the PC's accomplishments.
        Float NPCMorality  = actor1.GetAV("Morality")
        if NPCMorality > 1
            ; High Morality bonuses
            if Favor250.IsObjectiveCompleted(25) || Favor252.IsObjectiveCompleted(25) || Favor253.IsObjectiveCompleted(25) || Favor254.IsObjectiveCompleted(25) || Favor255.IsObjectiveCompleted(25) || Favor256.IsObjectiveCompleted(25) || Favor257.IsObjectiveCompleted(25) || Favor258.IsObjectiveCompleted(25) || FreeformRiftenThane.IsObjectiveCompleted(200)
			    AttractivenessBonus_Fame = 10
		    endif
            if MG08.IsCompleted() || C06.IsCompleted()
                AttractivenessBonus_FactionLeader = 15
            endif
        else
            ; Low Morality bonuses
            if CrimeFactionEastmarch.GetCrimeGold() > 499 || CrimeFactionFalkreath.GetCrimeGold() > 499 || CrimeFactionHaafingar.GetCrimeGold() > 499 || CrimeFactionHjaalmarch.GetCrimeGold() > 499 || CrimeFactionPale.GetCrimeGold() > 499 || CrimeFactionReach.GetCrimeGold() > 499 || CrimeFactionRift.GetCrimeGold() > 499 || CrimeFactionWhiterun.GetCrimeGold() > 499 || CrimeFactionWinterhold.GetCrimeGold() > 499
			    AttractivenessBonus_Fame = 10
		    endif
            if DB11.IsCompleted() || TGLeadership.IsCompleted()
                AttractivenessBonus_FactionLeader = 15
            endif
            if (PlayerRef.Haskeyword(vampire)) || playerref.HasSpell(WerewolfChange)
                AttractivenessBonus_Monster = 15
            endif
        endif

        ;Step five: a bonus in all cases if PC is the savior of Tamriel.
        if MQ305.IsCompleted()
            AttractivenessBonus_MainQuest = 30
        endif

        ;Step six: sum up all Attractiveness values.
        float TotalAttractiveness = AttractivenessBase +  AttractivenessBonus_Race + AttractivenessBonus_Skills + AttractivenessBonus_Fame + AttractivenessBonus_FactionLeader + AttractivenessBonus_Monster + AttractivenessBonus_MainQuest

        ; Step seven: get the attraction threshold based on NPC's class and sex
         int attractionThreshold = GetAttractivenessThreshold(actor1)

        ; Step eight: Decision based on Total Attractiveness and threshold
        if TotalAttractiveness >= attractionThreshold
            return true
        else
            return false
        endif
   endif
EndFunction

;Helper functions

int Function GetAttractivenessThreshold(Actor actor1)
    int threshold = 0

    int actor1IsFemale = 0
    ActorBase actor1Base = actor1.GetBaseObject() as ActorBase
    if (actor1Base.GetSex() == 1)
        actor1IsFemale = 1
    endIf

    Class actor1Class = actor1Base.GetClass()

    ; Define thresholds based on class and sex
    ; Lowest class citizens
    if actor1Class == Beggar || actor1Class == Prisoner
        if actor1IsFemale == 1
            threshold = 15
        else
            threshold = 5
        endIf
    ; Low class citizens
    elseif actor1Class == Farmer || actor1Class == Miner || actor1Class == Lumberjack
        if actor1IsFemale == 1
            threshold = 40
        else
            threshold = 15
        endIf
    ; Middle class citizen
    elseif actor1Class == Citizen || actor1Class == GuardImperial || actor1Class == GuardSonsSkyrim || actor1Class == Jailor || actor1Class == Bard || actor1Class == Priest
        if actor1IsFemale == 1
            threshold = 50
        else
            threshold = 30
        endIf
    else
        ; Default threshold for everything else
        if actor1IsFemale == 1
            threshold = 60
        else
            threshold = 40
        endIf
    endIf

    return threshold
EndFunction

Function GiveRandomEnthusiastTrait(Actor actor1)
	int r = Utility.RandomInt(1, 3)
	if r == 1
		actor1.AddToFaction(IOSS_Trait_EnthusiastArcane)
	elseIf r== 2
		actor1.AddToFaction(IOSS_Trait_EnthusiastEscapade)
	else
		actor1.AddToFaction(IOSS_Trait_EnthusiastMartial)
	endif
endFunction

float Function GetHighestSkill(float skill1, float skill2, float skill3, float skill4, float skill5)
    float highestSkill = skill1
    if skill2 > highestSkill
        highestSkill = skill2
    endIf
    if skill3 > highestSkill
        highestSkill = skill3
    endIf
    if skill4 > highestSkill
        highestSkill = skill4
    endIf
    if skill5 > highestSkill
        highestSkill = skill5
    endIf
    return highestSkill
EndFunction

float Function CalculateSkillAttractivenessBonus(Actor actor1)
    float bonus = 0
    float highestWarriorSkill = GetHighestSkill(playerref.GetActorValue("OneHanded"), playerref.GetActorValue("TwoHanded"), playerref.GetActorValue("Archery"), playerref.GetActorValue("Block"), playerref.GetActorValue("HeavyArmor"))
    float highestThiefSkill = GetHighestSkill(playerref.GetActorValue("LightArmor"), playerref.GetActorValue("Sneak"), playerref.GetActorValue("Lockpicking"), playerref.GetActorValue("Pickpocket"), playerref.GetActorValue("Speech"))
    float highestMageSkill = GetHighestSkill(playerref.GetActorValue("Destruction"), playerref.GetActorValue("Restoration"), playerref.GetActorValue("Illusion"), playerref.GetActorValue("Conjuration"), playerref.GetActorValue("Alteration"))

    if actor1.IsInFaction(IOSS_Trait_EnthusiastArcane)
        if highestMageSkill > 25
            bonus += highestMageSkill / 5
        endIf
    elseIf actor1.IsInFaction(IOSS_Trait_EnthusiastEscapade)
        if highestThiefSkill > 25
            bonus += highestThiefSkill / 5
        endIf
    elseIf actor1.IsInFaction(IOSS_Trait_EnthusiastMartial)
        if highestWarriorSkill > 25
            bonus += highestWarriorSkill / 5
        endIf
    endIf

    return bonus
EndFunction

