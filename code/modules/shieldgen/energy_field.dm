
//---------- actual energy field

/obj/effect/energy_field
	name = "energy shield"
	desc = "A strong field of energy, capable of blocking anything as long as it's active and programmed correctly."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "shield_normal"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = 1
	layer = 4.1		//just above mobs
	density = 0
	var/strength = 0
	var/ticks_recovering = 10
	var/diffused_for = 0
	var/diffused = FALSE

	var/is_strong = FALSE // if strength goes is 1 or above, this is set to TRUE, this is to prevent flickering and animate being called constantly

	atmos_canpass = CANPASS_PROC
	var/obj/machinery/shield_gen/parent_gen

/obj/effect/energy_field/Initialize()
	. = ..()
	update_nearby_tiles()

/obj/effect/energy_field/Destroy()
	update_nearby_tiles()
	return ..()

/obj/effect/energy_field/update_icon()
	if(parent_gen && parent_gen.parent_matrix.has_modulator(MODEFLAG_PHOTONIC) && density)
		set_opacity(1)
	else
		set_opacity(0)

	if(parent_gen && parent_gen.parent_matrix.has_modulator(MODEFLAG_OVERCHARGE))
		icon_state = "shield_overcharged"
	else
		icon_state = "shield_normal"

/obj/effect/energy_field/proc/diffuse(var/duration)
	diffused_for = max(duration, 0)

/obj/effect/energy_field/proc/check_overcharge(var/mob/living/user)
	var/datum/shield_mode/overcharge/O = parent_gen.parent_matrix.get_modulator_by_flag(MODEFLAG_OVERCHARGE)
	if(!O)
		return FALSE
	user.adjustFireLoss(rand(20, 40) * O.charge)
	user.Weaken(5 * O.charge)
	to_chat(user, SPAN_DANGER("As you come into contact with \the [src] a surge of energy paralyses you!"))
	Stress(10)

/obj/effect/energy_field/attackby(obj/item/I, mob/user)
	user.do_attack_animation(src, I)

	var/result = parent_gen.handle_shield_damage(I.damtype, I.damage_flags(), I.force)
	if(!result)
		user.visible_message(SPAN_WARNING("[user] harmlessly attacks \the [src] with \the [I]."), SPAN_WARNING("You attack \the [src] with \the [I], but it bounces off without doing any damage."))
		return FALSE
	check_overcharge(user)
	if(result < 0)
		user.visible_message(SPAN_WARNING("[user] attacks \the [src] with \the [I], shattering it instantly."), SPAN_WARNING("You attack \the [src] with \the [I], shattering it instantly."))
		qdel(src)
		return TRUE
	user.visible_message(SPAN_WARNING("[user] attacks \the [src] with \the [I]."), SPAN_WARNING("You attack \the [src] with \the [I]."))
	Stress(result)
	return TRUE


/obj/effect/energy_field/attack_hand(mob/living/carbon/human/H)
	check_overcharge(H)
	if(istype(H))
		if((isipc(H) && !parent_gen.parent_matrix.has_modulator(MODEFLAG_INORGANIC)) || (!isipc(H) && !parent_gen.parent_matrix.has_modulator(MODEFLAG_HUMANOIDS)))
			to_chat(H, SPAN_WARNING("You touch \the [src], and your hand passes right through."))
			return FALSE
		else if(H.species.can_shred(H))
			H.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			H.do_attack_animation(src, FIST_ATTACK_ANIMATION)
			var/result = parent_gen.handle_shield_damage(DAMAGE_BRUTE, DAMAGE_FLAG_EDGE | DAMAGE_FLAG_SHARP, 1)
			if(result < 0)
				H.visible_message(SPAN_WARNING("[H] shreds \the [src]! It shatters instantly."), SPAN_WARNING("You shred \the [src]! It shatters instantly."))
				qdel(src)
				return TRUE
			H.visible_message(SPAN_WARNING("[H] shreds \the [src]!"), SPAN_WARNING("You shred \the [src]!"))
			Stress(result)
			return TRUE
	to_chat(H, SPAN_WARNING("You touch \the [src], and it repulses your hand."))
	return FALSE

/obj/effect/energy_field/ex_act(var/severity)
	var/result = parent_gen.handle_shield_damage(DAMAGE_BRUTE, DAMAGE_FLAG_EXPLODE, severity + 0.5)
	if(result < 0)
		qdel(src)
		return
	Stress(result)

/obj/effect/energy_field/bullet_act(var/obj/item/projectile/Proj)
	var/result = parent_gen.handle_shield_damage(Proj.damage_type, Proj.damage_flags, Proj.get_structure_damage() / 10)
	if(result < 0)
		qdel(src)
		return
	Stress(result)

/obj/effect/energy_field/emp_act(var/severity)
	if(density)
		Stress(rand(30,60) / severity)

/obj/effect/energy_field/fire_act()
	if(density)
		var/result = parent_gen.handle_shield_damage(DAMAGE_BURN, null, rand(5, 10))
		if(result < 0)
			qdel(src)
			return
		Stress(result)

/obj/effect/energy_field/proc/Stress(var/severity)
	strength -= severity

	//if we take too much damage, drop out - the generator will bring us back up if we have enough power
	ticks_recovering = min(ticks_recovering + 2, 10)
	if(strength < 1 && is_strong)
		density_check(FALSE)
		is_strong = FALSE
		ticks_recovering = 10
		strength = 0
	else if(strength >= 1 && !is_strong)
		density_check(TRUE)
		is_strong = TRUE

/obj/effect/energy_field/proc/density_check(var/turn_on)
	if(turn_on && !diffused)
		alpha = 0
		density = TRUE
		mouse_opacity = MOUSE_OPACITY_ICON
		animate(src, 2 SECONDS, alpha = 255)
	else if(!turn_on)
		alpha = 255
		density = FALSE
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		animate(src, 2 SECONDS, alpha = 0)

/obj/effect/energy_field/proc/diffuse_check()
	diffused_for = max(0, diffused_for - 1)

	if(diffused_for && !diffused)
		diffused = TRUE
		if(is_strong)
			density_check(FALSE)
	else if(!diffused_for && diffused)
		diffused = FALSE
		density_check(TRUE)

/obj/effect/energy_field/proc/Strengthen(var/severity)
	if(!parent_gen)
		qdel(src)
		return

	strength = min(strength + severity, parent_gen.strength)
	if (strength < 0)
		strength = 0

	//if we take too much damage, drop out - the generator will bring us back up if we have enough power
	var/old_density = density
	if(strength >= 1 && !is_strong)
		is_strong = TRUE
		density_check(TRUE)
	else if(strength < 1 && is_strong)
		is_strong = FALSE
		density_check(FALSE)

	if (density != old_density)
		update_nearby_tiles()

	diffuse_check()

/obj/effect/energy_field/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(!parent_gen)
		qdel(src)
		. = TRUE

	diffuse_check()
	if(!density)
		. = TRUE

	if(air_group)
		. = !parent_gen.parent_matrix.has_modulator(MODEFLAG_ATMOSPHERIC)

	if(mover)
		if(ishuman(mover) && !isipc(mover))
			check_overcharge(mover)
			var/datum/shield_mode/humanoids/M = parent_gen.parent_matrix.get_modulator_by_flag(MODEFLAG_HUMANOIDS)
			if(istype(M))
				mover.visible_message(SPAN_NOTICE("[mover] starts pushing through \the [src]."), SPAN_NOTICE("You start pushing through \the [src]"))
				if(do_after(mover, M.delay))
					mover.visible_message(SPAN_NOTICE("[mover] pushes through \the [src]!"), SPAN_NOTICE("You push through \the [src]!"))
					. = TRUE
				. = FALSE
			. = TRUE
		else if((ishuman(mover) && isipc(mover)) || isbot(mover) || isrobot(mover) || ispAI(mover) || isDrone(mover))
			check_overcharge(mover)
			var/datum/shield_mode/humanoids/M = parent_gen.parent_matrix.get_modulator_by_flag(MODEFLAG_INORGANIC)
			if(istype(M))
				mover.visible_message(SPAN_NOTICE("[mover] starts pushing through \the [src]."), SPAN_NOTICE("You start pushing through \the [src]"))
				if(do_after(mover, M.delay))
					mover.visible_message(SPAN_NOTICE("[mover] pushes through \the [src]!"), SPAN_NOTICE("You push through \the [src]!"))
					. = TRUE
				. = FALSE
			. = TRUE
		else if(isanimal(mover))
			check_overcharge(mover)
			var/datum/shield_mode/mobs/M = parent_gen.parent_matrix.get_modulator_by_flag(MODEFLAG_NONHUMANS)
			if(istype(M))
				mover.visible_message(SPAN_NOTICE("[mover] starts pushing through \the [src]."), SPAN_NOTICE("You start pushing through \the [src]"))
				if(do_after(mover, M.delay))
					mover.visible_message(SPAN_NOTICE("[mover] pushes through \the [src]!"), SPAN_NOTICE("You push through \the [src]!"))
					. = TRUE
				. = FALSE
			. = TRUE

	if(. && istype(mover))
		mover.forceMove(get_turf(src))
