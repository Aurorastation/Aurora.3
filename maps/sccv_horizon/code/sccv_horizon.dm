/datum/map/sccv_horizon
	name = "SCCV Horizon"
	full_name = "SCCV Horizon"
	path = "sccv_horizon"

	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi', 'icons/misc/titlescreens/aurora/Vaurca.dmi')
	lobby_transitions = 25 SECONDS

	station_levels = list(1, 2, 3)
	admin_levels = list(4)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3, 5, 6)
	restricted_levels = list()
	accessible_z_levels = list(1, 2, 3)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/space,
		"4" = /turf/space,
		"5" = /turf/space,
		"6" = /turf/space
	)

	station_name = "SCCV Horizon"
	station_short = "Horizon"
	dock_name = "SCC Sector Liaison Post"
	dock_short = "Sector Liaison Post"
	boss_name = "Stellar Corporate Conglomerate"
	boss_short = "SCC"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"
	station_type = "ship"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the SCCV Horizon!"

	use_overmap = TRUE
	num_exoplanets = 2
	overmap_event_areas = 34
	planet_size = list(255,255)

	away_site_budget = 3

	station_networks = list(
		NETWORK_COMMAND,
		NETWORK_REACTOR,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY,
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_INTREPID
	)

	shuttle_docked_message = "Attention all hands: Bluespace jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETA%."
	shuttle_leaving_dock = "Attention all hands: Bluespace jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Bluespace jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Bluespace jump sequence aborted, return to normal operating conditions."
	emergency_shuttle_docked_message = "Attention all hands: the emergency evacuation has started. You have approximately %ETA% minutes to board the emergency pods."
	emergency_shuttle_leaving_dock = "Attention all hands: the emergency evacuation has been completed."
	emergency_shuttle_recall_message = "Attention all hands: the emergency evacuation has been canceled."
	emergency_shuttle_called_message = "Attention all hands: an emergency evacuation has been called. It will start in approximately %ETA%."

	meteors_detected_message = "A meteor storm has been detected on collision course with the ship. Estimated three minutes until impact, please activate the shielding fields and seek shelter in the central areas."
	meteor_contact_message = "Contact with meteor wave imminent, all hands brace for impact."
	meteor_end_message = "The ship has cleared the meteor shower, please return to your stations."

	ship_meteor_contact_message = "Debris from a nearby derelict are on collision course with the ship. Prepare for impact."
	ship_detected_end_message = "Ship debris colliding now, all hands brace for impact."
	ship_meteor_end_message = "The last of the ship debris has hit or passed by the ship, it is now safe to commence repairs."

	dust_detected_message = "A belt of space dust is approaching the ship."
	dust_contact_message = "The ship is now passing through a belt of space dust."
	dust_end_message = "The ship has now passed through the belt of space dust."

	radiation_detected_message = "High levels of radiation detected near the ship. Please evacuate into one of the shielded maintenance tunnels."
	radiation_contact_message = "The ship has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt."
	radiation_end_message = "The ship has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all-access again shortly."

	rogue_drone_detected_messages = list("Combat drone swarm from a nearby facility have engaged the ship. If any are sighted in the area, approach with caution.",
													"Malfunctioning combat drones have been detected close to the ship. If any are sighted in the area, approach with caution.")
	rogue_drone_end_message = "The hostile drone swarm has left the ship's proximity."
	rogue_drone_destroyed_message = "Sensors indicate the unidentified drone swarm has left the immediate proximity of the ship."


	map_shuttles = list(
		/datum/shuttle/autodock/ferry/lift/scc_ship/cargo,
		/datum/shuttle/autodock/ferry/lift/scc_ship/morgue,
		/datum/shuttle/autodock/ferry/lift/scc_ship/robotics,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod4,
		/datum/shuttle/autodock/ferry/supply/horizon,
		/datum/shuttle/autodock/ferry/specops/ert_aurora,
		/datum/shuttle/autodock/multi/antag/skipjack_ship,
		/datum/shuttle/autodock/multi/antag/burglar_ship,
		/datum/shuttle/autodock/multi/antag/merc_ship,
		/datum/shuttle/autodock/multi/legion,
		/datum/shuttle/autodock/multi/distress,
		/datum/shuttle/autodock/overmap/intrepid,
		/datum/shuttle/autodock/overmap/mining,
		/datum/shuttle/autodock/ferry/merchant_aurora,
		/datum/shuttle/autodock/ferry/autoreturn/ccia,
		/datum/shuttle/autodock/overmap/orion_express_shuttle,
		/datum/shuttle/autodock/overmap/sfa_shuttle,
		/datum/shuttle/autodock/overmap/tcfl_shuttle,
		/datum/shuttle/autodock/overmap/ee_shuttle,
		/datum/shuttle/autodock/overmap/fsf_shuttle,
		/datum/shuttle/autodock/overmap/freighter_shuttle,
		/datum/shuttle/autodock/overmap/kataphract_transport
	)

	evac_controller_type = /datum/evacuation_controller/starship

	allowed_spawns = list("Living Quarters Lift", "Cryogenic Storage")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift, /datum/spawnpoint/cryo)
	default_spawn = "Living Quarters Lift"

	allow_borgs_to_leave = TRUE

	warehouse_basearea = /area/operations/storage
