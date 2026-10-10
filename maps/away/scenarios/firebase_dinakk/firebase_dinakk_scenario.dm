/singleton/scenario/firebase_dinakk
	name = "Curios 3 - Firebase Din'akk"
	desc = "The Horizon sets off to secure the final remnants of the SCCV Jaunter hidden away in an abandoned outpost."
	scenario_site_id = "firebase_dinakk"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/firebase_dinakk

	roles = list(
		/singleton/role/generic_crew
	)
	default_outfit = /obj/outfit/admin/generic/firebase_dinakk_bandit/generic
	actor_accesses = list(
		/datum/access/external_airlocks,
		/datum/access/firebase_dinakk_checkpoint,
		/datum/access/firebase_dinakk_armoury,
		/datum/access/firebase_dinakk_basement,
		)
	radio_frequency_name = "Firebase Din'akk"

	base_area = /area/firebase_dinakk

/singleton/scenario_announcements/firebase_dinakk
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "The expedition operational region surrounding the prior identified bandit outpost has been \
	identified and cleared for operations. The SCCV Horizon is expected to prepare an away team as soon as possible and secure \
	all Stellar Corporate Conglomerate assets.\
	\
	Hostile and dangerous elements have been identified in the region. It is advised to prepare adequately. Landing sites will \
	be identified and uploaded shortly."
