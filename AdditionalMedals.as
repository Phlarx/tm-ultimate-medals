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

[Setting category="Additional Medals" name="Enable Champion Medals" if="IsChampionMedalsActive"]
bool enableChampionMedals = true;

[Setting category="Additional Medals" name="Enable Warrior Medals" if="IsWarriorMedalsActive"]
bool enableWarriorMedals = true;

[Setting category="Display Text" name="Champion Text" if="IsChampionMedalsActive"]
string championText = true;

[Setting category="Display Text" name="Warrior Text" if="IsWarriorMedalsActive"]
string warriorText = true;

uint GetChampionMedalsTime() {
#if DEPENDENCY_CHAMPIONMEDALS
    if (!IsChampionMedalsActive) {
        return -1;
    }
    return ChampionMedals::GetCMTime();
#else
    return -1;
#endif
}

uint GetWarriorMedalsTime() {
#if DEPENDENCY_WARRIORMEDALS
    if (!IsWarriorMedalsActive) {
        return -1;
    }
    return WarriorMedals::GetWMTime();
#else
    return -1;
#endif
}
