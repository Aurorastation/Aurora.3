/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Map"
	path = "away_sites_testing"

	station_levels = list(1)
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)
	lobby_icons = list('icons/misc/titlescreens/runtime/away.dmi')
	lobby_transitions = 10 SECONDS
	allowed_spawns = list()

/datum/map/away_sites_testing/build_away_sites()
	for (var/map in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/A = SSmapping.away_sites_templates[map]
		A.load_new_z()
		testing("Spawning [A] in [english_list(GetConnectedZlevels(world.maxz))]")
