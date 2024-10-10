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

[Setting category="Additional Medals" name="Enabel Champion Medals" if="IsChampionMedalsActive"]
bool enableChampionMedals = true;

[Setting category="Additional Medals" name="Enable Warrior Medals" if="IsWarriorMedalsActive"]
bool enableWarriorMedals = true;
