/datum/component/skill/pilot_mechs
	/// Percentage chance per rank above Unfamiliar to divert a pilot hit onto the mech.
	var/pilot_hit_avoidance_per_rank = 10
	/// Mounted gun accuracy bonus per rank above Unfamiliar.
	var/accuracy_per_rank = 0.2
	/// Mounted gun dispersion arc reduction in degrees per rank above Unfamiliar.
	var/dispersion_per_rank = 10
	/// Fractional melee damage bonus per rank above Unfamiliar.
	var/melee_damage_per_rank = 0.1
	/// Fractional melee attack delay reduction per rank above Unfamiliar.
	var/melee_delay_reduction_per_rank = 0.1

	/// The %chance per move input to scramble the input into a random direction. This only applies for Unfamiliar mech pilots.
	var/move_scramble_chance = 10

	/// Extra move delay added to
	var/move_delay_per_skill_diff = 0.5

/datum/component/skill/pilot_mechs/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_MECH_MOVE_WASD, PROC_REF(handle_user_move), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_MOVE_STRAFE, PROC_REF(handle_user_strafe), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_TOGGLE_POWER, PROC_REF(handle_toggle_power), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_AVOID_PILOT_HIT, PROC_REF(handle_avoid_pilot_hit), override = TRUE)
	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(handle_accuracy), override = TRUE)
	RegisterSignal(parent, COMSIG_MECH_MELEE_ATTACK, PROC_REF(handle_melee_attack), override = TRUE)

/datum/component/skill/pilot_mechs/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_MECH_MOVE_WASD)
	UnregisterSignal(parent, COMSIG_MECH_MOVE_STRAFE)
	UnregisterSignal(parent, COMSIG_MECH_TOGGLE_POWER)
	UnregisterSignal(parent, COMSIG_MECH_AVOID_PILOT_HIT)
	UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(parent, COMSIG_MECH_MELEE_ATTACK)
	return ..()

/datum/component/skill/pilot_mechs/proc/handle_accuracy(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	var/mob/living/heavy_vehicle/mech = shooter.loc
	if(parent != shooter || !istype(mech) || !(shooter in mech.pilots))
		return

	var/skill_ranks = SKILL_LEVEL_PROFESSIONAL - SKILL_LEVEL_UNFAMILIAR
	*accuracy_decrease = *accuracy_decrease - accuracy_per_rank * skill_ranks
	*dispersion_increase = *dispersion_increase - dispersion_per_rank * skill_ranks

/datum/component/skill/pilot_mechs/proc/handle_melee_attack(mob/user, mob/living/heavy_vehicle/mech, melee_damage, attack_delay)
	SIGNAL_HANDLER
	if(parent != user || !(user in mech.pilots))
		return

	var/skill_ranks = SKILL_LEVEL_PROFESSIONAL - SKILL_LEVEL_UNFAMILIAR
	*melee_damage = *melee_damage * (1 + melee_damage_per_rank * skill_ranks)
	*attack_delay = *attack_delay * (1 - melee_delay_reduction_per_rank * skill_ranks)

/datum/component/skill/pilot_mechs/proc/handle_user_move(mob/living/user, direction, delay_modifier)
	SIGNAL_HANDLER
	if (parent != user)
		return

	// Potentially scramble the direction if the pilot is minimally skilled.
	if (skill_level == SKILL_LEVEL_UNFAMILIAR && prob(move_scramble_chance))
		to_chat(user, SPAN_WARNING("You fumble with the controls!"))
		*direction = pick(GLOB.cardinals)

	// Don't modify the "Forward" throttle no matter the skill level. All other directions are slower than this for mechs.
	if (direction == NORTH)
		return

	*delay_modifier = *delay_modifier - (skill_level - 1) * move_delay_per_skill_diff

/datum/component/skill/pilot_mechs/proc/handle_user_strafe(mob/living/user, direction, delay_modifier)
	SIGNAL_HANDLER
	if (parent != user)
		return

	// Potentially flip the strafe direction if the pilot is minimally skilled.
	if (skill_level == SKILL_LEVEL_UNFAMILIAR && prob(move_scramble_chance))
		to_chat(user, SPAN_WARNING("You fumble with the controls!"))
		*direction = angle2dir(dir2angle(direction) + 180)

	*delay_modifier = *delay_modifier - (skill_level - 1) * move_delay_per_skill_diff

/datum/component/skill/pilot_mechs/proc/handle_toggle_power(mob/user, cancelled, delay)
	SIGNAL_HANDLER
	if (parent != user || cancelled || skill_level != SKILL_LEVEL_UNFAMILIAR)
		return

	*delay = *delay + (5 SECONDS)
	to_chat(user, SPAN_NOTICE("You struggle with searching all these buttons for the power switch."))
	playsound(user.loc, SFX_KEYBOARD, 30, TRUE)

/datum/component/skill/pilot_mechs/proc/handle_avoid_pilot_hit(mob/living/user, mob/living/heavy_vehicle/mech)
	SIGNAL_HANDLER
	if(parent != user || user.incapacitated())
		return

	var/avoidance_chance = (skill_level - SKILL_LEVEL_UNFAMILIAR) * pilot_hit_avoidance_per_rank
	if(!prob(avoidance_chance))
		return

	mech.visible_message(SPAN_NOTICE("\The [mech] sharply twists its torso, turning its armor into the incoming attack and shielding the cockpit!"))
	to_chat(user, SPAN_NOTICE("You instinctively execute a torso twist, shielding yourself from the incoming attack with \the [mech]'s armor!"))
	return COMPONENT_MECH_AVOID_PILOT_HIT
