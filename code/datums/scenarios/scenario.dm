/singleton/scenario
	/// The scenario's name. Displayed in the round end report and some other places.
	var/name = "Generic Scenario"
	/// The scenario's description. Displayed in the round end report and some other places.
	var/desc = "A generic scenario that should not be in the rotation."
	/// What sectors this scenario can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of scenario this is. NOT a boolean or a bitfield.
	var/scenario_type = SCENARIO_TYPE_NONCANON

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

	/// The title for the messages sent to the Horizon to notify them of the scenarios, both in notify_scenario_early and notify_scenario_late.
	var/horizon_announcement_title = "Central Command Situation Report"
	/// The announcement message sent to the Horizon immediately after roundstart (5 minutes or so), telling them to prepare for a yet unknown expedition.
	var/horizon_early_announcement_message = "SCCV Horizon, your sensors suite has located a site of interest and we are in the process of scanning the received deta. You will shortly be sent to investigate it. Please prepare an expedition."
	/// The announcement message sent to the Horizon around 20 minutes in, typically telling them to go investigate the scenario and the reason why.
	var/horizon_late_announcement_message = "The site of interest has been located and its coordinates have been registered on your sensors. Send an expedition to investigate."

	/// The announcement message for offships. This one contains all the info and is sent quickly.
	var/offship_announcement_message = "A recent sensors scan indicates the presence of a site of interest to investigate. The oordinates have been registered on the sensors consoles."

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
	scenario_site.load_new_z()
	SSodyssey.scenario_zlevel = world.maxz
	base_area = new base_area()

	// regenerate minimaps
	SSholomap.generate_all_minimaps()

/**
 * This proc sends the early message to the Horizon. It is supposed to be sent around 5 minutes in, telling them to get ready for a yet-unknown expedition.
 * It essentially lets them prepare stuff for the expeditions, like shuttle, manpower and resources, without it being metagaming.
 * Again, they probably shouldn't know the exact details here and they should await further information, but this is case-by-case depending on the scenario.
 * You can override it with an empty return if you don't want anything sent early on.
 */
/singleton/scenario/proc/notify_horizon_early(var/obj/effect/overmap/visitable/ship/horizon)
	command_announcement.Announce(horizon_early_announcement_message, horizon_announcement_title, do_print = TRUE)

/**
 * This proc is what you should override if you want anything specific to be messaged to the Horizon. Keep in mind this is the message sent about 20 minutes in.
 * This is essentially the distress signal or central command order that makes the Horizon go investigate the odyssey point.
 */
/singleton/scenario/proc/notify_horizon_late(var/obj/effect/overmap/visitable/ship/horizon)
	// We don't want to send the announcement if there are Storytellers.
	// We want to have them control when to end their prep and when to tell the Horizon to come.
	if(!length(SSodyssey.storytellers))
		command_announcement.Announce(horizon_late_announcement_message, horizon_announcement_title, do_print = TRUE)
		var/obj/effect/overmap/odyssey_site = GLOB.map_sectors["[SSodyssey.scenario_zlevel]"]
		if(odyssey_site)
			for(var/obj/machinery/computer/ship/sensors/sensors in SSodyssey.horizon.consoles)
				sensors.add_contact(odyssey_site)
	else
		for(var/mob/storyteller in SSodyssey.storytellers)
			to_chat(storyteller, FONT_LARGE(SPAN_NOTICE("The automated announcement to the Horizon would have been sent now, but it has been blocked by the presence of a Storyteller.")))
			to_chat(storyteller, FONT_LARGE(SPAN_NOTICE("Please remember to use the <b>Send Odyssey Message</b> verb as soon as your prep is done!")))
			to_chat(storyteller, FONT_LARGE(SPAN_NOTICE("If it is an Overmap scenario, please make sure to <b>include either the exact name or the coordinates of the Overmap object</b> the scenario takes place on.")))

/**
 * This proc notifies the offships about the presence of the Scenario and its coordinates.
 */
/singleton/scenario/proc/notify_offships(obj/effect/overmap/odyssey_site)
	if(!istype(odyssey_site))
		return

	for(var/obj/effect/overmap/visitable/ship/ship as anything in SSshuttle.ships)
		// Don't duplicate the message for landable ships. We don't want to notify both the big ship and its shuttle.
		// Or notify the Horizon again, for that matter...
		if(istype(ship, /obj/effect/overmap/visitable/ship/landable) || (ship == SSodyssey.horizon))
			continue

		for(var/obj/machinery/computer/ship/sensors/sensors in ship.consoles)
			priority_announcement.Announce(offship_announcement_message, "[ship.name] Sensors Report", zlevels = ship.map_z)
			sensors.add_contact(odyssey_site)

/obj/effect/landmark/actor
	name = "actor"

/obj/effect/ghostspawpoint/storyteller
	name = "storyteller"
	identifier = "storyteller"
