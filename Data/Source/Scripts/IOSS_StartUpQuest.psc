Scriptname IOSS_StartUpQuest extends Quest  

Message Property IOSS_BaseAttractiveness_Start  Auto  
Message Property IOSS_BaseAttractiveness_Physically  Auto  
Message Property IOSS_BaseAttractiveness_Socially  Auto  
GlobalVariable Property IOSS_AttractivenessBase  Auto  

Function InitialAttractivenessQuestion()

    int attPhysical 
    int attSocial 
    int attFinal 

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
        debug.Notification("Your character's attractiveness is below average.")
    elseIf attFinal >= 17
        if attFinal < 34
            debug.Notification("Your character's attractiveness is around average.")
        elseIf attFinal >= 34
            debug.Notification("Your character's attractiveness is above average.")
        endIf
    endIf

endFunction