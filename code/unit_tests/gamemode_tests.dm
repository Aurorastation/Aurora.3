/datum/unit_test/gamemode
	name = "GAMEMODE template"

/datum/unit_test/gamemode/required_enemies_check
    name = "GAMEMODE: All modes shall have required_players and required_enemies greater than the required number of players for their antagonist types."

/datum/unit_test/gamemode/required_enemies_check/start_test()
    var/list/failed = list()

    for(var/mode in subtypesof(/datum/game_mode))
        var/datum/game_mode/GM = new mode

        var/min_antag_count = 0
        for(var/antag_type in GM.antag_tags)
            var/datum/antagonist/A = all_antag_types[antag_type]

            if(GM.require_all_templates)
                min_antag_count += A.initial_spawn_req
            else
                min_antag_count = max(min_antag_count, A.initial_spawn_req)

        if(min_antag_count != GM.required_enemies)
            failed += "[GM] ([GM.type]) requires [GM.required_enemies] enemies but its antagonist roles require [min_antag_count] players!"
        if(min_antag_count > GM.required_players)
            failed += "[GM] ([GM.type]) requires [GM.required_players] players but its antagonist roles require [min_antag_count] players!"


    if(failed.len)
        TEST_FAIL("Some gamemodes did not have high enough required_enemies or required_players.")
        for(var/failed_message in failed)
            TEST_FAIL(failed_message)
    else
        TEST_PASS("All gamemodes had suitable required_enemies and required_players.")

    return 1
