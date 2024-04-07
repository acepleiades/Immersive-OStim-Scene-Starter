Scriptname IOSS_TeammatePassiveIntimacyScript extends Quest  

Actor Property playerref Auto
Faction Property OCR_Lover_Value_Intimacy  Auto
GlobalVariable Property GameDaysPassed  Auto
GlobalVariable Property IOSS_TeammateIntimacy_SetCooldown  Auto
Message Property IOSS_TeammateIntimacyMessage  Auto
ReferenceAlias Property TeammateAlias Auto
SPELL Property IOSS_TeammateIntimacyCooldownSpell  Auto

Function IncreaseTeammateIntimacy(actor actor1)
    ;(GetOwningQuest() as IOSS_TeammatePassiveIntimacyScript).IncreaseTeammateIntimacy(akspeaker)
    ;Clear and fill alias
    TeammateAlias.Clear()
    TeammateAlias.ForceRefTo(actor1)
    ;Apply cooldown magic effect
    IOSS_TeammateIntimacyCooldownSpell.Cast(playerref, actor1)
    ;Set overall cooldown for passive intimacy gain (6 in-game hours)
    float currenttime = GameDaysPassed.getvalue()
    float setcooldown = currenttime + 0.25
    IOSS_TeammateIntimacy_SetCooldown.setvalue(setcooldown)
    ;Increase intimacy
    int Intimacy = actor1.GetFactionRank(OCR_Lover_Value_Intimacy)
    if Intimacy < 100
        int newIntimacy = Intimacy + 2
        actor1.SetFactionRank(OCR_Lover_Value_Intimacy, newIntimacy)
        MiscUtil.PrintConsole(actor1 + "'s Intimacy value was " + Intimacy + " and is now " + newIntimacy)
        IOSS_TeammateIntimacyMessage.Show()
    endif
    ;Ensure maximum intimacy is 100
    if Intimacy > 100
        actor1.SetFactionRank(OCR_Lover_Value_Intimacy, 100)
    endif
EndFunction