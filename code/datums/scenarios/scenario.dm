/singleton/scenario
	/// The scenario's name. Displayed in the round end report and some other places.
	var/name = "Generic Scenario"
	/// The scenario's description. Displayed in the round end report and some other places.
	var/desc = "A generic scenario that should not be in the rotation."
	/// What sectors this scenario can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of scenario this is. NOT a boolean or a bitfield.
	var/scenario_type = SCENARIO_TYPE_NONCANON

	/**
	 * All scenarios happen in an away site, which is manually spawned when the odyssey is picked.
	 * This away site can have its exoplanet themes defined and then mapped to give the semblance of being on a planet (see the Tret away site).
	 * Alternatively, without defining exoplanet themes, it can take place in space, for example.
	 * In the future there will likely be support for no-away site scenarios that take place on the Horizon.
	 */
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

	/// The title for the message sent to the Horizon at roundstart.
	var/horizon_announcement_title = "Central Command Situation Report"
	/// The announcement message sent to the Horizon at roundstart, typically telling them to go investigate the Odyssey and why.
	var/horizon_announcement_message = "There is a Situation on this away site you're probably supposed to know about. Go investigate it."

	/// The default outfit every actor is given on this scenario.
	/// They can select their role and outfit on the Odyssey UI when ingame.
	var/default_outfit = /obj/outfit/admin/generic

	/// The displayed list of scenario roles. List of /singleton/role
	/// The players will be able to see the role names in the Odyssey UI, and when they click them, they'll equip the relevant outfit.
	var/list/roles

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
 * This proc is what you should override if you want anything specific to be messaged to the Horizon.
 * This is essentially the distress signal or central command order that makes the Horizon investigate the odyssey point.
 */
/singleton/scenario/proc/notify_horizon(var/obj/effect/overmap/visitable/ship/horizon)
	/// We don't want to send the announcement if there are Storytellers. We want to have them control when to end their prep and when to tell the Horizon to come.
	if(!length(SSodyssey.storytellers))
		command_announcement.Announce(horizon_announcement_message, horizon_announcement_title, do_print = TRUE)
	else
		for(var/mob/storyteller in SSodyssey.storytellers)
			to_chat(storyteller, FONT_LARGE(SPAN_NOTICE("The automated announcement to the Horizon would have been sent now, but it has been blocked by the presence of a Storyteller.")))
			to_chat(storyteller, SPAN_DANGER("Please remember to use the Send Distress Message verb as soon as your prep is done!"))

/obj/effect/landmark/actor
	name = "actor"

/obj/effect/ghostspawpoint/storyteller
	name = "storyteller"
	identifier = "storyteller"
