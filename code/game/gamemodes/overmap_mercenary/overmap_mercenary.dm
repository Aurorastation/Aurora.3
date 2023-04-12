/*
	MERCENARY ROUNDTYPE
*/

// var/list/nuke_disks = list()

/datum/game_mode/overmap_mercenary
	name = "Overmap Mercenary"
	config_tag = "overmap-mercenary"
	required_players = 20
	required_enemies = 4
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level
	antag_tags = list(MODE_OVERMAP_MERCENARY)
	antag_scaling_coeff = 6

/datum/game_mode/overmap_mercenary/pre_setup()
	round_description = "A mercenary destruction force is approaching the [current_map.station_type]!"
	extended_round_description = "[current_map.company_short]'s wealth and success caught the attention of several enemies old and new, \
		and many seek to undermine them using illegal ways. Their crown jewel research [current_map.station_type] are not safe from those \
		malicious activities."
	. = ..()

//delete all nuke disks not on a station zlevel
/datum/game_mode/overmap_mercenary/proc/check_nuke_disks()
	for(var/obj/item/disk/nuclear/N in nuke_disks)
		var/turf/T = get_turf(N)
		if(isNotStationLevel(T.z)) qdel(N)

//checks if L has a nuke disk on their person
/datum/game_mode/overmap_mercenary/proc/check_mob(mob/living/L)
	for(var/obj/item/disk/nuclear/N in nuke_disks)
		if(N.storage_depth(L) >= 0)
			return 1
	return 0
