/datum/component/skill/pilot_mechs

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

/datum/component/skill/pilot_mechs/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_MECH_MOVE_WASD)
	UnregisterSignal(parent, COMSIG_MECH_MOVE_STRAFE)
	return ..()

/datum/component/skill/pilot_mechs/proc/handle_user_move(mob/living/user, direction, delay_modifier)
	if (parent != user)
		return

	// Potentially scramble the direction if the pilot is minimally skilled.
	if (skill_level == SKILL_LEVEL_UNFAMILIAR && prob(move_scramble_chance))
		to_chat(user, SPAN_WARNING("You fumble with the controls!"))
		*direction = pick(GLOB.cardinals)

	// Don't modify the "Forward" throttle no matter the skill level. All other directions are slower than this for mechs.
	if (direction == NORTH)
		return

	*delay_modifier += (SKILL_LEVEL_TRAINED - skill_level) * move_delay_per_skill_diff

/datum/component/skill/pilot_mechs/proc/handle_user_strafe(mob/living/user, direction, delay_modifier)
	if (parent != user)
		return

	// Potentially flip the strafe direction if the pilot is minimally skilled.
	if (skill_level == SKILL_LEVEL_UNFAMILIAR && prob(move_scramble_chance))
		to_chat(user, SPAN_WARNING("You fumble with the controls!"))
		*direction = angle2dir(dir2angle(direction) + 180)

	*delay_modifier += (SKILL_LEVEL_TRAINED - skill_level) * move_delay_per_skill_diff
