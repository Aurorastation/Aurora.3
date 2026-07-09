/mob/living
	health = 100
	maxhealth = 100
	see_invisible = SEE_INVISIBLE_LIVING

	var/hud_updateflag = 0

	// Virtual Reality
	/// The network this mob is attached to, used in virtual reality and remote control things
	var/remote_network
	/// Directly affects how long a mob will hallucinate for
	var/hallucination = 0
	/// Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/last_special = 0

	var/t_phoron = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/hydrogen = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/mob/living/cameraFollow = null
	var/list/datum/action/actions = list()

	/// Time of death
	var/tod = null
	var/update_slimes = 1
	/// Can't talk. Value goes down every life proc.
	var/silent = null
	/// The "Are we on fire?" var
	var/on_fire = 0
	/// Used in handle_fire() and associated procs. Modifies body temperature, as moderated by var/fire_stacks_temp.
	var/fire_stacks = 0
	/// Used in handle_fire() and associated procs. Couples fire_stacks to the gas environment temperature in which fire was applied, decreases when in cooler atmos.
	var/fire_stacks_temperature = 0

	var/footstep = 0

	/// This is used to determine if the mob failed a breath. If they did fail a breath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/failed_last_breath = 0
	/// Can be possessed by ghosts if unplayed.
	var/possession_candidate

	var/composition_reagent
	var/composition_reagent_quantity
	/// How large of a creature it can swallow at once, and how big of a bite it can take out of larger things
	var/mouth_size = 2
	/// This is a bitfield which must be initialised in New(). The valid values for it are in devour.dm
	var/eat_types = 0
	/// Used for mobs that can walk through maintenance hatches - drones, pais, and spiderbots
	var/underdoor
	/// The amount of life ticks that have processed on this mob.
	var/life_tick = 0


	//These values are duplicated from the species datum so we can handle things on a per-mob basis, allows for chemicals to affect them
	var/stamina = 0
	/// Maximum stamina. We start taking oxyloss when this runs out while sprinting
	var/max_stamina = 100
	var/sprint_speed_factor = 0.4
	var/sprint_cost_factor = 1
	var/stamina_recovery = 1
	/// When move intent is walk, movedelay is clamped to this value as a lower bound
	var/min_walk_delay = 0
	var/exhaust_threshold = 50
	/// Progress bar shown when stamina is not at full, and the mob supports stamina. Deleted on Logout or when stamina is full.
	var/datum/progressbar/stamina_bar

	/// DON'T MODIFY THIS DIRECTLY. USE apply_radiation()!
	var/total_radiation	= 0
	/// Set to 1 by cloaking devices, optimises update_icons
	var/cloaked = 0

	/// If true, mob is not affected by tesla bolts.
	var/tesla_ignore = 0

	/// If true, it won't reset the mob vision flags
	var/stop_sight_update = 0

	var/burn_mod = 1
	var/brute_mod = 1

	/// Override for the visual attack effect shown on 'do_attack_animation()'.
	var/attack_vis_effect

	/// used to limit people from queuing up limb-breaks
	var/limb_breaking = FALSE
	/// Basically a catch-all aura/force-field thing.
	var/list/obj/aura/auras

	/// Affects renaming animals and monkey species. Set to TRUE for animals with unique names, such as station pets. Doesn't affect any other mob.
	var/named = FALSE

	/// What icon the mob uses for speechbubbles
	var/bubble_icon = "default"

	/// If true, ignores weather effects
	var/resists_weather = FALSE

	/// Time since last weather effect
	var/weather_cooldown_time = 0

	var/datum/psi_complexus/psi

	///The obj to overlay on the aim target
	var/obj/aiming_overlay/aiming

	///A list of mobs the target is being aimed at by
	var/list/aimed_at_by

	var/singleton/maneuver/prepared_maneuver
	var/list/available_maneuvers = list()

	var/datum/language/default_language

	var/atom/movable/z_observer/z_eye

	atom_flags = CRITICAL_ATOM
	var/instability = 0
	var/last_instability = 0 // Used to calculate instability delta.
	var/last_instability_event = null // most recent world.time that something bad happened due to instability.

	var/datum/weakref/last_weather

	var/tmp/last_push_notif
