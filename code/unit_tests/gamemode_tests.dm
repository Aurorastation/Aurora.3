/datum/unit_test/gamemode
	name = "GAMEMODE template"

/datum/unit_test/gamemode/required_enemies_check
    name = "GAMEMODE: All multi-modes shall have a required_enemies greater than or equal to their component modes."

/datum/unit_test/gamemode/required_enemies_check/start_test()
    var/list/failed = list()

    for(var/mode in subtypesof(/datum/game_mode))
        var/datum/game_mode/GM = new mode

        var/min_antag_count = 0
        for(var/antag_type in GM.antag_tags)
            var/datum/antagonist/A = all_antag_types[antag_type]
            min_antag_count += A.initial_spawn_req

        if(min_antag_count > GM.required_enemies)
            failed += "[ascii_red]--------------- [GM] ([GM.type]) requires [GM.required_enemies] but its antagonist roles require [min_antag_count]!"


    if(failed.len)
        fail("Some gamemodes did not have high enough required_enemies.")
        for(var/failed_message in failed)
            log_unit_test(failed_message)
    else
        pass("All gamemodes had enough required_enemies.")

    return 1