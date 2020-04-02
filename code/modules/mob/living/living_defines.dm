/mob/living
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	var/hud_updateflag = 0

	// Virtual Reality
	var/remote_network // The network this mob is attached to, used in virtual reality and remote control things

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	var/t_phoron = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/mob/living/cameraFollow = null
	var/list/datum/action/actions = list()

	var/tod = null // Time of death
	var/update_slimes = 1
	var/silent = null 		// Can't talk. Value goes down every life proc.
	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks = 0
	var/footstep = 0

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/possession_candidate // Can be possessed by ghosts if unplayed.

	var/composition_reagent
	var/composition_reagent_quantity
	var/mouth_size = 2//how large of a creature it can swallow at once, and how big of a bite it can take out of larger things
	var/eat_types = 0//This is a bitfield which must be initialised in New(). The valid values for it are in devour.dm
	var/underdoor //Used for mobs that can walk through maintenance hatches - drones, pais, and spiderbots
	var/life_tick = 0      // The amount of life ticks that have processed on this mob.


	//These values are duplicated from the species datum so we can handle things on a per-mob basis, allows for chemicals to affect them
	var/stamina = 0
	var/max_stamina = 100//Maximum stamina. We start taking oxyloss when this runs out while sprinting
	var/sprint_speed_factor = 0.4
	var/sprint_cost_factor = 1
	var/stamina_recovery = 1
	var/min_walk_delay = 0//When move intent is walk, movedelay is clamped to this value as a lower bound
	var/exhaust_threshold = 50
	var/datum/progressbar/stamina_bar	// Progress bar shown when stamina is not at full, and the mob supports stamina. Deleted on Logout or when stamina is full.

	var/move_delay_mod = 0//Added to move delay, used for calculating movement speeds. Provides a centralised value for modifiers to alter

	var/total_radiation	= 0 // DON'T MODIFY THIS DIRECTLY. USE apply_radiation()!
	var/cloaked = 0//Set to 1 by cloaking devices, optimises update_icons

	var/tesla_ignore = 0	// If true, mob is not affected by tesla bolts.

	var/stop_sight_update = 0 //If true, it won't reset the mob vision flags

	var/burn_mod = 1
	var/brute_mod = 1

	var/limb_breaking = FALSE // used to limit people from queuing up limb-breaks