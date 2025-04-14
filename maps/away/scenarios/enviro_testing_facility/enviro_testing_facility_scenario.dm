/singleton/scenario/enviro_testing_facility
	name = "Environmental Testing Facility Zoya"
	desc = "A environmental testing facility on a barren planet, in a otherwise uninteresting sector. \
			SCCV Horizon, the closest ship in this sector, was dispatched to investigate."
	scenario_site_id = "enviro_testing_facility"

	possible_scenario_types = list(SCENARIO_TYPE_NONCANON, SCENARIO_TYPE_CANON)

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/enviro_testing_facility

	roles = list(
		/singleton/role/generic_crew,
		/singleton/role/generic_engineer,
		/singleton/role/generic_research,
		/singleton/role/generic_medical,
		/singleton/role/generic_security,
		/singleton/role/generic_miner,
		/singleton/role/generic_business,
		/singleton/role/generic_mercenary,
	)
	default_outfit = /obj/outfit/admin/generic
	actor_accesses = list(
		/datum/access/enviro_testing_facility_access_control,
		/datum/access/enviro_testing_facility_access_engops,
		/datum/access/enviro_testing_facility_access_medres,
		/datum/access/enviro_testing_facility_access_sec,
	)
	radio_frequency_name = "Env-Test Facility Zoya"

	base_area = /area/enviro_testing_facility

/singleton/scenario_announcements/enviro_testing_facility
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "\
		Greetings, SCCV Horizon. We have observed some unusual extranet traffic \
		from a environmental testing facility in your current sector. \
		You are to investigate and report back of your findings.\
	"
	offship_announcement_message = "\
		An unidentified outpost has been located nearby. The coordinates have been registered on the flight deck.\
	"
