/singleton/scenario
	/// The scenario's name. Displayed in the round end report and some other places.
	var/name = "Generic Scenario"
	/// The scenario's description. Displayed in the round end report and some other places.
	var/desc = "A generic scenario that should not be in the rotation."
	/// What sectors this scenario can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of scenario this is. NOT a boolean or a bitfield.
	var/scenario_type = SCENARIO_TYPE_NONCANON
	/// Whether or not landing on the Odyssey away site is restricted by default. Has to be either unrestricted by Storytellers manually, or happens forcefully at 40 minutes in.
	var/site_landing_restricted = TRUE

	// All scenarios happen in an away site, which is manually spawned the very second the round starts.
	// This away site can have its exoplanet themes defined and then mapped to give the semblance of being on a planet (see the Tret away site).
	// Alternatively, without defining exoplanet themes, it can take place in space, for example.
	// In the future there will likely be support for no-away site scenarios that take place on the Horizon.

	/// The away site ID of the scenario to spawn. This is what you should edit, set it to the away site's id variable.
	var/scenario_site_id
	/// This is the away site where the scenario takes place. Do not edit this variable - it's set automatically.
	var/datum/map_template/ruin/away_site/scenario_site
	/// Weight given to the odyssey in pickweight when being picked.
	var/weight = 20
	/// The minimum amount of total players required for an odyssey to spawn.
	var/min_player_amount = 8
	/// The minimum amount of actors we want to spawn in this odyssey.
	var/min_actor_amount = 1

	/// The scenario_announcements singleton for this scenario. Contains information on the announcements sent to the Horizon and the offships.
	/// Initially set to a type, which is then created in Initialize().
	var/singleton/scenario_announcements/scenario_announcements = /singleton/scenario_announcements

	/// The default outfit every actor is given on this scenario.
	/// They can select their role and outfit on the Odyssey UI when ingame.
	var/default_outfit = /obj/outfit/admin/generic

	/// The displayed list of scenario roles.
	/// The players will be able to see the role names in the Odyssey UI, and when they click them, they'll equip the relevant outfit.
	var/list/singleton/role/roles

	/// The base area of this scenario's away site. Used for blueprints. Must have  AREA_FLAG_IS_BACKGROUND.
	var/base_area

	/// The name of the frequency that will be used by the radios on the away site.
	var/radio_frequency_name = "Sector"

/singleton/scenario/Initialize()
	. = ..()
	if(!ispath(scenario_announcements))
		crash_with("Scenario [type] tried initializing without appropriate announcements!")
	scenario_announcements = GET_SINGLETON(scenario_announcements)

/**
 * This proc handles the creation and spawning of everything that the odyssey needs.
 * This could be a map or landmarks or whatever.
 */
/singleton/scenario/proc/setup_scenario()
	SHOULD_NOT_OVERRIDE(TRUE)
	scenario_site = SSmapping.away_sites_templates[scenario_site_id]
	if(istype(scenario_site))
		to_world(FONT_LARGE(SPAN_DANGER("Setting up this round's Odyssey...")))
		setup_away_site()
		to_world(FONT_LARGE(SPAN_DANGER("Your Odyssey is ready!")))
	else
		// To edit this part eventually for Horizon odyssey scenarios.
		log_and_message_admins(FONT_HUGE("CRITICAL FAILURE: SCENARIO [name] DOES NOT HAVE A VALID SITE!"))
		return FALSE
	return TRUE

/**
 * This proc is the one called to set up a new z-level for the odyssey.
 * This is the one you should override for custom logic.
 */
/singleton/scenario/proc/setup_away_site()
	// load the site
	var/list/bounds = scenario_site.load_new_z()
	for(var/z_index in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
		SSodyssey.scenario_zlevels += world.maxz
	base_area = new base_area()

	// regenerate minimaps
	SSholomap.generate_all_minimaps()

/**
 * This proc sends the early message to the Horizon. It is supposed to be sent around 5 minutes in, telling them to get ready for the expedition and to start going there.
 * It essentially lets them move to the away site and prepare stuff for the expeditions, like shuttles, manpower and resources, without it being metagaming.
 * You can override it with an empty return if you don't want anything sent early on.
 */
/singleton/scenario/proc/send_main_map_message(var/obj/effect/overmap/visitable/ship/horizon)
	command_announcement.Announce(scenario_announcements.horizon_early_announcement_message, scenario_announcements.horizon_announcement_title, do_print = TRUE)
	var/obj/effect/overmap/odyssey_site = SSodyssey.get_odyssey_overmap_effect()
	if(odyssey_site)
		for(var/obj/machinery/computer/ship/sensors/sensors in SSodyssey.main_map.consoles)
			sensors.add_contact(odyssey_site)

/**
 * This proc is called when the away site landing restrictions are lifted. Generally the flavour message here should contain something about the landing site being cleared/authorized or whatever to get the point across.
 * This also automatically unrestricts the landing if there is no storyteller.
 */
/singleton/scenario/proc/unrestrict_landing_and_message_horizon(var/obj/effect/overmap/visitable/ship/horizon)
	// We don't want to send the default announcement if there are Storytellers. Let them make their own.
	if(!length(SSodyssey.storytellers))
		command_announcement.Announce(scenario_announcements.horizon_unrestrict_landing_message, scenario_announcements.horizon_announcement_title, do_print = TRUE)
		unrestrict_away_site_landing()
	else
		for(var/mob/storyteller in SSodyssey.storytellers)
			to_chat(storyteller, FONT_LARGE(SPAN_NOTICE("The automated announcement to the Horizon would have been sent now, but it has been blocked by the presence of a Storyteller.")))
			to_chat(storyteller, FONT_LARGE(SPAN_NOTICE("Remember that nobody can dock with the Scenario away site yet.")))
			to_chat(storyteller, FONT_LARGE(SPAN_DANGER("When you are ready, use the Unrestrict Away Site Landing verb!")))
/**
 * This proc notifies the offships about the presence of the Scenario and its coordinates.
 */
/singleton/scenario/proc/notify_offships(obj/effect/overmap/odyssey_site)
	if(!istype(odyssey_site))
		return

	for(var/obj/effect/overmap/visitable/ship/ship as anything in SSshuttle.ships)
		// Don't duplicate the message for landable ships. We don't want to notify both the big ship and its shuttle.
		// Or notify the Horizon again, for that matter...
		if(istype(ship, /obj/effect/overmap/visitable/ship/landable) || (ship == SSodyssey.main_map))
			continue

		for(var/obj/machinery/computer/ship/sensors/sensors in ship.consoles)
			priority_announcement.Announce(scenario_announcements.offship_announcement_message, "[ship.name] Sensors Report", zlevels = ship.map_z)
			sensors.add_contact(odyssey_site)

/**
 * Unrestricts the landing on the away site. This proc is on the scenario so it can be overridden if a scenario wants to do something specific
 * when the away site landing is unrestricted.
 */
/singleton/scenario/proc/unrestrict_away_site_landing()
	SHOULD_CALL_PARENT(TRUE)
	SSodyssey.site_landing_restricted = FALSE

/singleton/scenario_announcements
	/// The title for the messages sent to the Horizon to notify them of the scenarios, both in notify_scenario_early and notify_scenario_late.
	var/horizon_announcement_title = "Central Command Situation Report"
	/// The announcement message sent to the Horizon immediately after roundstart (5 minutes or so), telling them to prepare for a yet unknown expedition.
	var/horizon_early_announcement_message = "SCCV Horizon, your sensors suite has located a site of interest and the coordinates have been marked on your sensors. Please prepare an expedition while we investigate landing conditions.\n\nAll crew are encouraged to volunteer and should notify their relevant department heads as soon as possible. Volunteers should only be rejected in the most dire circumstances."
	/// The announcement message sent to the Horizon around 20 minutes in, typically telling them to go investigate the scenario and the reason why.
	var/horizon_unrestrict_landing_message = "The landing sites have been registered and cleared. An expedition is now authorized to depart."

	/// The announcement message for offships. This one contains all the info, without time segmentation.
	var/offship_announcement_message = "A recent sensors scan indicates the presence of a site of interest to investigate. The oordinates have been registered on the sensors consoles."

/obj/effect/landmark/actor
	name = "actor"

/obj/effect/ghostspawpoint/storyteller
	name = "storyteller"
	identifier = "storyteller"
