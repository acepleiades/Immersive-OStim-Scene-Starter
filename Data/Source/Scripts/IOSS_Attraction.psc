Scriptname IOSS_Attraction extends Quest  

Actor Property PlayerRef Auto
Message Property IOSS_BaseAttractiveness_Start  Auto  
Message Property IOSS_BaseAttractiveness_Physically  Auto  
Message Property IOSS_BaseAttractiveness_Socially  Auto  
GlobalVariable Property IOSS_AttractivenessBase  Auto  
GlobalVariable Property IOSS_CurrentAttraction  Auto  
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
Faction Property IOSS_SocialClass_Other Auto 
Faction Property IOSS_SocialClass_CitizenNoble Auto 
Faction Property IOSS_SocialClass_SoldierOrGuard Auto 
Faction Property IOSS_SocialClass_CitizenMiddle Auto 
Faction Property IOSS_SocialClass_CitizenLow Auto 
Faction Property IOSS_SocialClass_CitizenLowest Auto 
Faction Property FavorJobsBeggarsFaction Auto  
Faction Property FavorJobsDrunksFaction Auto  
Faction Property JobAnimalTrainerFaction Auto  
Faction Property JobApothecaryFaction Auto  
Faction Property JobBardFaction Auto  
Faction Property JobBlacksmithFaction Auto  
Faction Property JobCarriageFaction Auto  
Faction Property JobCourtWizardFaction Auto  
Faction Property JobFarmerFaction Auto  
Faction Property JobFenceFaction Auto  
Faction Property JobFletcherFaction Auto  
Faction Property JobGuardCaptainFaction Auto  
Faction Property JobHostlerFaction Auto  
Faction Property JobHousecarlFaction Auto  
Faction Property JobInnkeeperFaction Auto  
Faction Property JobInnServer Auto  
Faction Property JobJarlFaction Auto  
Faction Property JobJewelerFaction Auto  
Faction Property JobJusticiar Auto  
Faction Property JobLumberjackFaction Auto  
Faction Property JobMerchantFaction Auto  
Faction Property JobMinerFaction Auto  
Faction Property JobMiscFaction Auto  
Faction Property JobOrcChiefFaction Auto  
Faction Property JobPriestFaction Auto  
Faction Property JobRentRoomFaction Auto  
Faction Property JobStewardFaction Auto 
Class Property Citizen  Auto  
Class Property GuardOrc1H  Auto  
Class Property GuardOrc2H Auto  
Class Property SoldierImperialNotGuard  Auto  
Class Property SoldierSonsSkyrimNotGuard  Auto  

function GetAttraction(actor actor1)
	float attraction = CalculateNPCAttraction(actor1)
	IOSS_CurrentAttraction.SetValue(attraction)
endFunction

float Function CalculateNPCAttraction(actor actor1)
    ;Step one: get the player's base Attractiveness.
    float AttractivenessBase = IOSS_AttractivenessBase.GetValue()

    ;If the player has not answered the initial questionnaire, begin the questionnaire.
    If AttractivenessBase == 0
        InitialAttractivenessQuestionnaire()
        AttractivenessBase = IOSS_AttractivenessBase.GetValue()
    endif
    MiscUtil.PrintConsole("GetNPCAttraction: passed step one.")
    
    ;Initializations
    float AttractivenessBonus_Race = 0
    float AttractivenessBonus_Skills = 0
    float AttractivenessBonus_Fame = 0
    float AttractivenessBonus_FactionLeader = 0
    float AttractivenessBonus_Monster = 0
    float AttractivenessBonus_MainQuest = 0

    ;Step two: calculate the PC's Attractiveness bonus from the NPC's racial preferences.
    Race actor1Race = actor1.GetRace()
    if actor1Race == ArgonianRace
        AttractivenessBonus_Race += playerref.GetActorValue("Lockpicking") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Alteration") + playerref.GetActorValue("Pickpocket") + playerref.GetActorValue("Restoration") + playerref.GetActorValue("Sneak")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is ArgonianRace.")
    elseif actor1Race == BretonRace
        AttractivenessBonus_Race += playerref.GetActorValue("Conjuration") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("Speechcraft") + playerref.GetActorValue("Alchemy") + playerref.GetActorValue("Illusion") + playerref.GetActorValue("Restoration") + playerref.GetActorValue("Alteration")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is BretonRace.")
    elseif actor1Race == DarkElfRace
        AttractivenessBonus_Race += playerref.GetActorValue("Destruction") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Sneak") + playerref.GetActorValue("Alchemy") + playerref.GetActorValue("Illusion") + playerref.GetActorValue("Alteration")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is DarkElfRace.")
    elseif actor1Race == HighElfRace
        AttractivenessBonus_Race += playerref.GetActorValue("Illusion") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("Alteration") + playerref.GetActorValue("Conjuration") + playerref.GetActorValue("Destruction") + playerref.GetActorValue("Enchanting") + playerref.GetActorValue("Restoration")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is HighElfRace.")
    elseif actor1Race == ImperialRace
        AttractivenessBonus_Race += playerref.GetActorValue("Restoration") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("HeavyArmor") + playerref.GetActorValue("Block") + playerref.GetActorValue("OneHanded") + playerref.GetActorValue("Destruction") + playerref.GetActorValue("Enchanting")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is ImperialRace.")
    elseif actor1Race == KhajiitRace
        AttractivenessBonus_Race += playerref.GetActorValue("Sneak") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("OneHanded") + playerref.GetActorValue("Marksman") + playerref.GetActorValue("Lockpicking") + playerref.GetActorValue("Pickpocket") + playerref.GetActorValue("Alchemy")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is KhajiitRace.")
    elseif actor1Race == NordRace
        AttractivenessBonus_Race += playerref.GetActorValue("TwoHanded") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("Smithing") + playerref.GetActorValue("Block") + playerref.GetActorValue("OneHanded") + playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Speechcraft")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is NordRace.")
    elseif actor1Race == OrcRace
        AttractivenessBonus_Race += playerref.GetActorValue("HeavyArmor") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("Smithing") + playerref.GetActorValue("Block") + playerref.GetActorValue("TwoHanded") + playerref.GetActorValue("OneHanded") + playerref.GetActorValue("Enchanting")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is OrcRace.")
    elseif actor1Race == RedguardRace
        AttractivenessBonus_Race += playerref.GetActorValue("OneHanded") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("Smithing") + playerref.GetActorValue("TwoHanded") + playerref.GetActorValue("Marksman") + playerref.GetActorValue("Destruction") + playerref.GetActorValue("Alteration")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is RedguardRace.")
    elseif actor1Race == WoodElfRace
        AttractivenessBonus_Race += playerref.GetActorValue("Marksman") / 4  ; Major skill
        AttractivenessBonus_Race += (playerref.GetActorValue("Alchemy") + playerref.GetActorValue("LightArmor") + playerref.GetActorValue("Lockpicking") + playerref.GetActorValue("Pickpocket") + playerref.GetActorValue("Sneak")) / 20  ; Minor skills
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is WoodElfRace.")
    else  ; For every other race
        int playerLevel = playerref.GetLevel()
        AttractivenessBonus_Race += playerLevel / 2.0  ; Adjust the divisor as needed for game balance
        MiscUtil.PrintConsole("GetNPCAttraction: NPC's race is not playable. Using player level to calculate this Attractiveness bonus.")
    endif
    MiscUtil.PrintConsole("GetNPCAttraction: passed step two.")

    ;Step three: calculate the PC's Attractiveness bonus from skills.
    if actor1.IsInFaction(IOSS_Trait_EnthusiastArcane) || actor1.IsInFaction(IOSS_Trait_EnthusiastEscapade) || actor1.IsInFaction(IOSS_Trait_EnthusiastMartial)
        AttractivenessBonus_Skills = CalculateSkillAttractivenessBonus(actor1)
    else
        GiveRandomEnthusiastTrait(actor1)
        AttractivenessBonus_Skills = CalculateSkillAttractivenessBonus(actor1)
    endif
    MiscUtil.PrintConsole("GetNPCAttraction: passed step three.")

    ;Step four: take into account the PC's accomplishments.
    Float actor1Morality  = actor1.GetAV("Morality")
    if actor1Morality > 1
        ; High Morality bonuses
        MiscUtil.PrintConsole("GetNPCAttraction: NPC is has high Morality and likes a virtuous character.")
        if Favor250.IsObjectiveCompleted(15) || Favor252.IsObjectiveCompleted(15) || Favor253.IsObjectiveCompleted(15) || Favor254.IsObjectiveCompleted(15) || Favor255.IsObjectiveCompleted(15) || Favor256.IsObjectiveCompleted(15) || Favor257.IsObjectiveCompleted(15) || Favor258.IsObjectiveCompleted(15) || FreeformRiftenThane.IsObjectiveCompleted(30)
            MiscUtil.PrintConsole("GetNPCAttraction: Player character is Thane.")
            AttractivenessBonus_Fame = 10
        endif
        if MG08.IsCompleted() || C06.IsCompleted()
            MiscUtil.PrintConsole("GetNPCAttraction: Player character is the leader of a renowned faction.")
            AttractivenessBonus_FactionLeader = 15
        endif
    else
        ; Low Morality bonuses
        MiscUtil.PrintConsole("GetNPCAttraction: NPC is has low Morality and likes a vicious character.")
        if CrimeFactionEastmarch.GetCrimeGold() > 499 || CrimeFactionFalkreath.GetCrimeGold() > 499 || CrimeFactionHaafingar.GetCrimeGold() > 499 || CrimeFactionHjaalmarch.GetCrimeGold() > 499 || CrimeFactionPale.GetCrimeGold() > 499 || CrimeFactionReach.GetCrimeGold() > 499 || CrimeFactionRift.GetCrimeGold() > 499 || CrimeFactionWhiterun.GetCrimeGold() > 499 || CrimeFactionWinterhold.GetCrimeGold() > 499
            MiscUtil.PrintConsole("GetNPCAttraction: Player is a notorious criminal.")
            AttractivenessBonus_Fame = 10
        endif
        if DB11.IsCompleted() || TGLeadership.IsCompleted()
            MiscUtil.PrintConsole("GetNPCAttraction: Player character is the leader of an infamous faction.")
            AttractivenessBonus_FactionLeader = 15
        endif
        if (PlayerRef.Haskeyword(vampire)) || playerref.HasSpell(WerewolfChange)
            AttractivenessBonus_Monster = 15
            MiscUtil.PrintConsole("GetNPCAttraction: Player character is a vampire or werewolf.")
        endif
    endif
    MiscUtil.PrintConsole("GetNPCAttraction: passed step four.")

    ;Step five: a bonus in all cases if PC is the savior of Tamriel.
    if MQ305.IsCompleted()
        AttractivenessBonus_MainQuest = 30
        MiscUtil.PrintConsole("GetNPCAttraction: Player character is the savior of Tamriel.")
    endif
    MiscUtil.PrintConsole("GetNPCAttraction: passed step five.")

    ;Step six: sum up all Attractiveness values.
    float TotalAttractiveness = AttractivenessBase + AttractivenessBonus_Race + AttractivenessBonus_Skills + AttractivenessBonus_Fame + AttractivenessBonus_FactionLeader + AttractivenessBonus_Monster + AttractivenessBonus_MainQuest
    MiscUtil.PrintConsole("GetNPCAttraction: passed step six.")

    ; Step seven: get the attraction threshold based on NPC's class and sex
    int attractionThreshold = GetAttractivenessThreshold(actor1)
    MiscUtil.PrintConsole("GetNPCAttraction: passed step seven.")

    ; Return the ratio of Total Attractiveness to attractionThreshold
    ; Make sure to handle division by zero if the threshold can be zero
    if attractionThreshold > 0
        return TotalAttractiveness / attractionThreshold
    else
        return 0  ; or some other default value if attractionThreshold is zero
    endif
EndFunction

;Helper functions
Function InitialAttractivenessQuestionnaire()
    int attPhysical = 0
    int attSocial = 0
    int attFinal = 0

    IOSS_BaseAttractiveness_Start.show()
    Int iChoice0 = IOSS_BaseAttractiveness_Physically.show()
        if iChoice0 == 0
            attPhysical = 6
        elseIf iChoice0 == 1
            attPhysical = 12
        elseIf iChoice0 == 2
            attPhysical = 18
        elseIf iChoice0 == 3
            attPhysical = 24
        elseIf iChoice0 == 4  ; Changed from 3 to 4
            attPhysical = 30
        endIf

    Int iChoice1 = IOSS_BaseAttractiveness_Socially.show()
        if iChoice1 == 0
            attSocial = 4
        elseIf iChoice1 == 1
            attSocial = 8
        elseIf iChoice1 == 2
            attSocial = 12
        elseIf iChoice1 == 3
            attSocial = 16
        elseIf iChoice1 == 4  ; Changed from 3 to 4
            attSocial = 20
        endIf
    attFinal = attPhysical + attSocial 
    IOSS_AttractivenessBase.setValue(attFinal)

    if attFinal < 17
        debug.Notification("Your base attractiveness is below average.")
    elseIf attFinal >= 17
        if attFinal < 34
            debug.Notification("Your base attractiveness is around average.")
        elseIf attFinal >= 34
            debug.Notification("Your base attractiveness is above average.")
        endIf
    endIf
endFunction


int Function GetAttractivenessThreshold(Actor actor1)
    int threshold = 0

    int actor1IsFemale = 0
    ActorBase actor1Base = actor1.GetBaseObject() as ActorBase
    if (actor1Base.GetSex() == 1)
        actor1IsFemale = 1
    endIf
    Class actor1Class = actor1Base.GetClass()

    ; Check if the NPC is already in an IOSS Social Class faction
    if actor1.IsInFaction(IOSS_SocialClass_Other)
        MiscUtil.PrintConsole("GetNPCAttraction: NPC social class is IOSS_SocialClass_Other")
        if actor1IsFemale == 1
            threshold = 70
        else
            threshold = 50
        endIf
    elseif actor1.IsInFaction(IOSS_SocialClass_CitizenNoble)
        MiscUtil.PrintConsole("GetNPCAttraction: NPC social class is IOSS_SocialClass_CitizenNoble")
        if actor1IsFemale == 1
            threshold = 80
        else
            threshold = 60
        endIf
    elseif actor1.IsInFaction(IOSS_SocialClass_SoldierOrGuard)
        MiscUtil.PrintConsole("GetNPCAttraction: NPC social class is IOSS_SocialClass_SoldierOrGuard")
        if actor1IsFemale == 1
            threshold = 60
        else
            threshold = 40
        endIf
    elseif actor1.IsInFaction(IOSS_SocialClass_CitizenMiddle)
        MiscUtil.PrintConsole("GetNPCAttraction: NPC social class is IOSS_SocialClass_CitizenMiddle")
        if actor1IsFemale == 1
            threshold = 60
        else
            threshold = 40
        endIf
    elseif actor1.IsInFaction(IOSS_SocialClass_CitizenLow)
        MiscUtil.PrintConsole("GetNPCAttraction: NPC social class is IOSS_SocialClass_CitizenLow")
        if actor1IsFemale == 1
            threshold = 50
        else
            threshold = 24
        endIf
    elseif actor1.IsInFaction(IOSS_SocialClass_CitizenLowest)
        MiscUtil.PrintConsole("GetNPCAttraction: NPC social class is IOSS_SocialClass_CitizenLowest")
        if actor1IsFemale == 1
            threshold = 25
        else
            threshold = 15
        endIf
    else
        ; Assign NPC to the correct social class faction
        MiscUtil.PrintConsole("GetNPCAttraction: NPC does not have an IOSS social class. Assigning...")
        if (actor1.GetFactionRank(FavorJobsBeggarsFaction) >= -1) || (actor1.GetFactionRank(FavorJobsDrunksFaction) >= -1) || (actor1.GetFactionRank(JobLumberjackFaction) >= -1) || (actor1.GetFactionRank(JobMinerFaction) >= -1)
            MiscUtil.PrintConsole("GetNPCAttraction: Assigned social class IOSS_SocialClass_CitizenLowest")
            actor1.AddToFaction(IOSS_SocialClass_CitizenLowest)
            if actor1IsFemale == 1
                threshold = 20
            else
                threshold = 10
            endIf

        elseif (actor1.GetFactionRank(JobJarlFaction) >= -1) || (actor1.GetFactionRank(JobJusticiar) >= -1) || (actor1.GetFactionRank(JobOrcChiefFaction) >= -1) || (actor1.GetFactionRank(JobHousecarlFaction) >= -1) || (actor1.GetFactionRank(JobStewardFaction) >= -1)
            MiscUtil.PrintConsole("GetNPCAttraction: Assigned social class IOSS_SocialClass_CitizenNoble")
            actor1.AddToFaction(IOSS_SocialClass_CitizenNoble)
            if actor1IsFemale == 1
                threshold = 80
            else
                threshold = 60
            endIf
        elseif (actor1.GetFactionRank(JobFarmerFaction) >= -1) || (actor1.GetFactionRank(JobAnimalTrainerFaction) >= -1) || (actor1.GetFactionRank(JobFletcherFaction) >= -1) || (actor1.GetFactionRank(JobInnServer) >= -1) || (actor1.GetFactionRank(JobHostlerFaction) >= -1) || (actor1.GetFactionRank(JobRentRoomFaction) >= -1)
            MiscUtil.PrintConsole("GetNPCAttraction: Assigned social class IOSS_SocialClass_CitizenLow")
            actor1.AddToFaction(IOSS_SocialClass_CitizenLow)
            if actor1IsFemale == 1
                threshold = 50
            else
                threshold = 20
            endIf
        elseif  actor1Class == GuardOrc1H || actor1Class == GuardOrc2H || actor1Class == SoldierImperialNotGuard || actor1Class == SoldierSonsSkyrimNotGuard
            MiscUtil.PrintConsole("GetNPCAttraction: Assigned social class IOSS_SocialClass_SoldierOrGuard")
            actor1.AddToFaction(IOSS_SocialClass_SoldierOrGuard)
            if actor1IsFemale == 1
                threshold = 60
            else
                threshold = 40
            endIf
        elseif actor1Class == Citizen || (actor1.GetFactionRank(JobApothecaryFaction) >= -1) || (actor1.GetFactionRank(JobBardFaction) >= -1) || (actor1.GetFactionRank(JobBlacksmithFaction) >= -1) || (actor1.GetFactionRank(JobCarriageFaction) >= -1) || (actor1.GetFactionRank(JobCourtWizardFaction) >= -1) || (actor1.GetFactionRank(JobFenceFaction) >= -1) || (actor1.GetFactionRank(JobInnkeeperFaction) >= -1) || (actor1.GetFactionRank(JobJewelerFaction) >= -1) || (actor1.GetFactionRank(JobMerchantFaction) >= -1) || (actor1.GetFactionRank(JobMiscFaction) >= -1) || (actor1.GetFactionRank(JobPriestFaction) >= -1) || (actor1.GetFactionRank(JobGuardCaptainFaction) >= -1)
            MiscUtil.PrintConsole("GetNPCAttraction: Assigned social class IOSS_SocialClass_CitizenMiddle")
            actor1.AddToFaction(IOSS_SocialClass_CitizenMiddle)
            if actor1IsFemale == 1
                threshold = 60
            else
                threshold = 40
            endIf
        else
            ; Default threshold if the NPC does not meet any condition
            MiscUtil.PrintConsole("GetNPCAttraction: NPC has not matched any conditions. Assigned social class IOSS_SocialClass_Other")
            actor1.AddToFaction(IOSS_SocialClass_Other)
            if actor1IsFemale == 1
                threshold = 70
            else
                threshold = 50
            endIf
        endif
    endif

    return threshold
EndFunction

Function GiveRandomEnthusiastTrait(Actor actor1)
    MiscUtil.PrintConsole("GetNPCAttraction: NPC does not have an Enthusiast trait. Assigning a random trait...")
	int r = Utility.RandomInt(1, 3)
	if r == 1
		actor1.AddToFaction(IOSS_Trait_EnthusiastArcane)
        MiscUtil.PrintConsole("GetNPCAttraction: Assigned IOSS_Trait_EnthusiastArcane")
	elseIf r== 2
		actor1.AddToFaction(IOSS_Trait_EnthusiastEscapade)
        MiscUtil.PrintConsole("GetNPCAttraction: Assigned IOSS_Trait_EnthusiastEscapade")
	else
		actor1.AddToFaction(IOSS_Trait_EnthusiastMartial)
        MiscUtil.PrintConsole("GetNPCAttraction: Assigned IOSS_Trait_EnthusiastMartial")
	endif
endFunction

float Function GetHighestSkill(float skill1, float skill2, float skill3, float skill4, float skill5, float skill6)
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
    if skill6 > highestSkill
        highestSkill = skill6
    endIf
    return highestSkill
EndFunction

float Function CalculateSkillAttractivenessBonus(Actor actor1)
    MiscUtil.PrintConsole("GetNPCAttraction: Calculating the PC's skill attractiveness bonus...")
    float bonus = 0
    float highestWarriorSkill = GetHighestSkill(playerref.GetActorValue("OneHanded"), playerref.GetActorValue("TwoHanded"), playerref.GetActorValue("Marksman"), playerref.GetActorValue("Block"), playerref.GetActorValue("Smithing"), playerref.GetActorValue("HeavyArmor"))
    float highestThiefSkill = GetHighestSkill(playerref.GetActorValue("LightArmor"), playerref.GetActorValue("Pickpocket"), playerref.GetActorValue("Lockpicking"), playerref.GetActorValue("Sneak"), playerref.GetActorValue("Alchemy"), playerref.GetActorValue("Speechcraft"))
    float highestMageSkill = GetHighestSkill(playerref.GetActorValue("Alteration"), playerref.GetActorValue("Conjuration"), playerref.GetActorValue("Destruction"), playerref.GetActorValue("Illusion"), playerref.GetActorValue("Restoration"), playerref.GetActorValue("Enchanting"))

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