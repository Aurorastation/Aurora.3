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
	 * All Situations happen in an away site, which is manually spawned when the situation is picked.
	 * This away site can have its exoplanet themes defined and then mapped to give the semblance of being on a planet (see the Tret away site).
	 * Alternatively, without defining exoplanet themes, it can take place in space, for example.
	 * In the future there will likely be support for no-away site Situations that take place on the Horizon.
	 */
	/// This
	var/datum/map_template/ruin/away_site/situation_site
	/// Weight given to the situation in pickweight when being picked.
	var/weight = 20
	/// The minimum amount of total players required for a situation to spawn.
	var/min_player_amount = 8
	/// The minimum amount of actors we want to spawn in this situation.
	var/min_actor_amount = 1
	/// The minimum amount of storytellers we want to spawn in this situation.
	var/min_storyteller_amount = 0
	/// The maximum amount of storytellers we want to spawn in this situation.
	var/max_storyteller_amount = 1

/**
 * This proc handles the creation and spawning of everything that the situation needs.
 * This could be a map or landmarks or whatever.
 */
/singleton/situation/proc/setup_situation()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(istype(situation_site))
		to_world(FONT_LARGE("Setting up this round's Odyssey..."))
		setup_away_site()
		to_world(FONT_LARGE("The Odyssey is all set!"))
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
