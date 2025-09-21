/**
 * Checks if the current round is considered canon by gamemode or odyssey canonicity.
 * Returns true if the current gamemode is extended or odyssey and scenario is of type canon.
 */
/proc/is_round_canon()
    if(GLOB.master_mode == "extended")
        return TRUE
    if(GLOB.master_mode == "odyssey" && !SSodyssey.scenario && SSodyssey.scenario.scenario_type == SCENARIO_TYPE_CANON)
        return TRUE
    return FALSE
