bool get_IsChampionMedalsActive() {
#if DEPENDENCY_CHAMPIONMEDALS
    auto plugin = Meta::GetPluginFromID("ChampionMedals");
    if (plugin !is null) {
        return plugin.Enabled;
    }
    return false;
#else
    return false;
#endif
}

bool get_IsWarriorMedalsActive() {
#if DEPENDENCY_WARRIORMEDALS
    auto plugin = Meta::GetPluginFromID("WarriorMedals");
    if (plugin !is null) {
        return plugin.Enabled;
    }
    return false;
#else
    return false;
#endif
}

bool get_ShowChampionMedals() {
    return enableChampionMedals && IsChampionMedalsActive;
}

bool get_ShowWarriorMedals() {
    return enableWarriorMedals && IsWarriorMedalsActive;
}

[Setting category="Display Text" name="Champion Text" if="get_IsChampionMedalsActive"]
string championText = "Champion";

[Setting category="Display Text" name="Warrior Text" if="get_IsWarriorMedalsActive"]
string warriorText = "Warrior";

[Setting category="Additional Medals" name="Enable Champion Medals" if="get_IsChampionMedalsActive"]
bool enableChampionMedals = true;

[Setting category="Additional Medals" name="Enable Warrior Medals" if="get_IsWarriorMedalsActive"]
bool enableWarriorMedals = true;

int GetChampionMedalsTime() {
#if DEPENDENCY_CHAMPIONMEDALS
    if (!IsChampionMedalsActive) {
        return -1;
    }
    return ChampionMedals::GetCMTime();
#else
    return -1;
#endif
}

int GetWarriorMedalsTime() {
#if DEPENDENCY_WARRIORMEDALS
    if (!IsWarriorMedalsActive) {
        return -1;
    }
    return WarriorMedals::GetWMTime();
#else
    return -1;
#endif
}

uint additionalMedalCoroNonce = 0;

void WaitForAdditionalMedalsTimes(const string &in mapUid) {
#if TMNEXT
    // wait a few frames before checking for additional medals
    yield(5);
    auto myNonce = ++additionalMedalCoroNonce;
    while (myNonce == additionalMedalCoroNonce && mapUid == currentMapUid) {
        // set this to false if any time is < 0
        bool haveAllTimes = true;

        if (champion.time < 0 && ShowChampionMedals) {
            champion.time = GetChampionMedalsTime();
            haveAllTimes = haveAllTimes && champion.time >= 0;
            trace("Champion time: " + champion.time);
        }

        if (warrior.time < 0 && ShowWarriorMedals) {
            warrior.time = GetWarriorMedalsTime();
            haveAllTimes = haveAllTimes && warrior.time >= 0;
            // warrior medal returns 0 if it does not exist
            if (warrior.time == 0) {
                warrior.hidden = true;
            }
            trace("Warrior time: " + warrior.time);
        }

        UpdatePBMedalLabel();
        if (haveAllTimes) {
            break;
        }

        yield(5);
    }
    trace("Additional medals times loaded");
#endif
}
