
//---------- actual energy field

/obj/effect/energy_field
	name = "energy shield"
	desc = "A strong field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield_normal"
	alpha = 0
	mouse_opacity = 0
	anchored = 1
	layer = 4.1		//just above mobs
	density = 0
	var/strength = 0
	var/ticks_recovering = 10
	var/diffused_for = 0
	var/diffused = FALSE

	var/is_strong = FALSE // if strength goes is 1 or above, this is set to TRUE, this is to prevent flickering and animate being called constantly

	atmos_canpass = CANPASS_ALWAYS

/obj/effect/energy_field/Initialize()
	. = ..()
	update_nearby_tiles()

/obj/effect/energy_field/Destroy()
	update_nearby_tiles()
	return ..()

/obj/effect/energy_field/proc/diffuse(var/duration)
	diffused_for = max(duration, 0)

/obj/effect/energy_field/attackby(obj/item/I, mob/user)
	user.do_attack_animation(src, I)
	if(I.force < 10)
		user.visible_message(SPAN_WARNING("[user] harmlessly attacks \the [src] with \the [I]."), SPAN_WARNING("You attack \the [src] with \the [I], but it bounces off without doing any damage."))
	else
		user.visible_message(SPAN_WARNING("[user] attacks \the [src] with \the [I]."), SPAN_WARNING("You attack \the [src] with \the [I]."))
		Stress(I.force / 10)

/obj/effect/energy_field/attack_hand(mob/living/carbon/human/H)
	if(istype(H))
		if(H.species.can_shred(H))
			H.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			H.do_attack_animation(src, FIST_ATTACK_ANIMATION)
			H.visible_message(SPAN_WARNING("[H] shreds \the [src]!"), SPAN_WARNING("You shred \the [src]!"))
			Stress(1)
			return
	to_chat(H, SPAN_WARNING("You touch \the [src], and it repulses your hand."))

/obj/effect/energy_field/ex_act(var/severity)
	Stress(0.5 + severity)

/obj/effect/energy_field/bullet_act(var/obj/item/projectile/Proj)
	Stress(Proj.get_structure_damage() / 10)

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

//
/obj/effect/energy_field/proc/density_check(var/turn_on)
	if(turn_on && !diffused)
		alpha = 0
		density = TRUE
		mouse_opacity = 1
		animate(src, 2 SECONDS, alpha = 255)
	else if(!turn_on)
		alpha = 255
		density = FALSE
		mouse_opacity = 0
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
	strength += severity
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
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by: Movement, airflow.
	//Inputs: The moving atom (optional), target turf, "height" and air group
	//Outputs: Boolean if can pass.

	//return (!density || !height || air_group)
	return (!density || air_group)
