/singleton/situation
	/// The situation's name. Displayed in the round end report and some other places.
	var/name = "Generic Situation"
	/// The situation's description. Displayed in the round end report and some other places.
	var/desc = "A generic situation that should not be in the rotation."
	/// What sectors this situation can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of situation this is. NOT a boolean or a bitfield.
	var/mission_type = SITUATION_TYPE_NONCANON

	/**
	 * All situations happen in an away site, which is manually spawned when the situation is picked.
	 * This away site can have its exoplanet themes defined and then mapped to give the semblance of being on a planet (see the Tret away site).
	 * Alternatively, without defining exoplanet themes, it can take place in space, for example.
	 * In the future there will likely be support for no-away site Situations that take place on the Horizon.
	 */
	/// The ID of the situation to spawn. This is what you should edit, set it to the away site's id variable.
	var/situation_site_id
	/// This is the away site where the situation takes place. Do not edit this variable - it's set automatically.
	var/datum/map_template/ruin/away_site/situation_site
	/// Weight given to the situation in pickweight when being picked.
	var/weight = 20
	/// The minimum amount of total players required for a situation to spawn.
	var/min_player_amount = 8
	/// The minimum amount of actors we want to spawn in this situation.
	var/min_actor_amount = 1

	/// The title for the message sent to the Horizon at roundstart.
	var/horizon_announcement_title = "Central Command Situation Report"
	/// The announcement message sent to the Horizon at roundstart, typically telling them to go investigate the Situation and why.
	var/horizon_announcement_message = "There is a situation on the Away Site. Go investigate it, yo."


/**
 * This proc handles the creation and spawning of everything that the situation needs.
 * This could be a map or landmarks or whatever.
 */
/singleton/situation/proc/setup_situation()
	SHOULD_NOT_OVERRIDE(TRUE)
	situation_site = SSmapping.away_sites_templates[situation_site_id]
	if(istype(situation_site))
		to_world(FONT_LARGE(SPAN_DANGER("Setting up this round's Odyssey...")))
		setup_away_site()
		to_world(FONT_LARGE(SPAN_DANGER("Your Odyssey is ready!")))
	else
		log_and_message_admins(FONT_HUGE("CRITICAL FAILURE: SITUATION DOES NOT HAVE A VALID SITE!"))
		return FALSE
	return TRUE

/**
 * This proc is the one called to set up a new z-level for the situation.
 * This is the one you should override for custom logic.
 */
/singleton/situation/proc/setup_away_site()
	situation_site.load_new_z()
	LAZYADD(SSodyssey.situation_zlevels, world.maxz)

/**
 * This proc is what you should override if you want anything specific to be messaged to the Horizon.
 * This is essentially the distress signal or central command order that makes the Horizon investigate the situation point.
 */
/singleton/situation/proc/notify_horizon(var/obj/effect/overmap/visitable/ship/horizon)
	/// We don't want to send the announcement if there are Storytellers. We want to have them control when to end their prep and when to tell the Horizon to come.
	if(!length(SSodyssey.storytellers))
		command_announcement.Announce(horizon_announcement_message, horizon_announcement_title, do_print = TRUE)
	else
		for(var/mob/storyteller in SSodyssey.storytellers)
			to_chat(storyteller, SPAN_NOTICE("The automated announcement to the Horizon would have been sent now, but it has been blocked by the presence of a Storyteller."))
			to_chat(storyteller, SPAN_DANGER("Please remember to use the Send Distress Message verb as soon as your prep is done!"))

/obj/effect/landmark/actor
	name = "actor"

/obj/effect/ghostspawpoint/storyteller
	name = "storyteller"
	identifier = "storyteller"
