SUBSYSTEM_DEF(odyssey)
	name = "Odyssey"
	init_order = INIT_ORDER_ODYSSEY
	flags = SS_BACKGROUND|SS_NO_FIRE
	wait = 8

	/// The selected odyssey singleton.
	var/singleton/odyssey/odyssey
	/// The z-levels that the odyssey takes place in. If null, it means that there are no loaded zlevels for this odyssey.
	/// It probably takes place on the Horizon in that case.
	var/odyssey_zlevel
	/// This is the site the odyssey takes place on. If null, then the mission takes place on a non-site zlevel.
	/// Should only be changed through set_odyssey_site().
	var/datum/map_template/ruin/away_site/odyssey_site
	/// A list of currently spawned actors for easy access.
	var/list/actors
	/// A list of currently spawned storytellers for easy access.
	var/list/storytellers
	/// Whether or not we've sent the odyssey's roundstart report yet.
	var/has_sent_roundstart_announcement = FALSE
	/// The Horizon's overmap object. We keep it here for convenience.
	var/obj/effect/overmap/visitable/ship/horizon

/datum/controller/subsystem/odyssey/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/odyssey/Recover()
	odyssey = SSodyssey.odyssey
	odyssey_site = SSodyssey.odyssey_site
	odyssey_zlevel = SSodyssey.odyssey_zlevel
	actors = SSodyssey.actors
	storytellers = SSodyssey.storytellers

/datum/controller/subsystem/odyssey/fire()
	. = ..()
	if(!has_sent_roundstart_announcement)
		addtimer(CALLBACK(odyssey, TYPE_PROC_REF(/singleton/odyssey, notify_horizon), horizon), rand(4 MINUTES, 5 MINUTES))

/**
 * Picks a random odyssey while keeping in mind sector requirements.
 * If successful, makes the SS start firing.
 */
/datum/controller/subsystem/odyssey/proc/pick_odyssey()
	var/list/all_odysseys = GET_SINGLETON_SUBTYPE_LIST(/singleton/odyssey)
	var/list/possible_odysseys = list()
	for(var/singleton/odyssey/S in all_odysseys)
		if((SSatlas.current_sector.name in S.sector_whitelist) || !length(S.sector_whitelist))
			possible_odysseys[S] = S.weight

	if(!length(possible_odysseys))
		log_debug("CRITICAL ERROR: No available odyssey for sector [SSatlas.current_sector.name]!")
		log_and_message_admins(SPAN_DANGER(FONT_HUGE("CRITICAL ERROR: NO SITUATIONS ARE AVAILABLE FOR THIS SECTOR! CHANGE THE GAMEMODE MANUALLY!")))
		return

	odyssey = pickweight(possible_odysseys)
	gamemode_setup()
	/// Now that we actually have an odyssey, the subsystem can fire!
	flags &= ~SS_NO_FIRE
	horizon = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/sccv_horizon)

/**
 * This proc overrides the gamemode variables for the amount of actors.
 * Note that Storytellers spawn through a ghost role.
 */
/datum/controller/subsystem/odyssey/proc/gamemode_setup()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/game_mode/odyssey/ody_gamemode = GLOB.gamemode_cache["odyssey"]
	/// There's a bit of an issue with this: essentially, due to the fact that odyssey map loading is done after voting, you can load a map and end up
	/// not having enough actors for it, so it boots you back to the voting screen. Now you have an useless zlevel and an extra storyteller spawner.
	/// The fix for this is, currently, making odyssey force itself to start by adding antag drafting for it. Not ideal, but deleting a zlevel is an even
	// worse solution, probably.
	if(odyssey)
		ody_gamemode.required_players = odyssey.min_player_amount
		ody_gamemode.required_enemies = odyssey.min_actor_amount

/**
 * This is the proc that should be used to set the odyssey away site.
 */
/datum/controller/subsystem/odyssey/proc/set_odyssey_site(datum/map_template/ruin/away_site/site)
	if(!istype(site))
		return

	odyssey_site = site

/**
 * Adds an actor to the subsystem actor list.
 */
/datum/controller/subsystem/odyssey/proc/add_actor(mob/living/carbon/human/H)
	LAZYDISTINCTADD(actors, H)

/**
 * Adds a storyteller to the subsystem storyteller list.
 */
/datum/controller/subsystem/odyssey/proc/add_storyteller(mob/abstract/storyteller/S)
	LAZYDISTINCTADD(storytellers, S)

/**
 * Removes an actor from the subsystem actor list.
 */
/datum/controller/subsystem/odyssey/proc/remove_actor(mob/living/carbon/human/H)
	LAZYREMOVE(actors, H)

/**
 * Removes a storyteller from the subsystem storyteller list.
 */
/datum/controller/subsystem/odyssey/proc/remove_storyteller(mob/abstract/storyteller/S)
	LAZYREMOVE(storytellers, S)
