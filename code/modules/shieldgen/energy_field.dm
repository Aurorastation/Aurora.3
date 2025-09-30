
//---------- actual energy field

/obj/effect/energy_field
	name = "energy shield"
	desc = "A strong field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "shield_normal"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = 1
	layer = ABOVE_HUMAN_LAYER
	density = 0
	/// A ref holding the /datum/energy_field that this field object belongs to.
	var/datum/energy_field/energy_field
	/// The damage suffered by the field.
	var/damage = 0
	var/ticks_recovering = 10
	var/diffused_for = 0
	var/diffused = FALSE
	/// If strength goes is 1 or above, this is set to TRUE, this is to prevent flickering and animate being called constantly
	var/is_strong = FALSE

	atmos_canpass = CANPASS_ALWAYS

/obj/effect/energy_field/Initialize(mapload, datum/energy_field/mother_field)
	. = ..()
	if(istype(mother_field))
		energy_field = mother_field
	else
		log_debug("Energy field generated without mother field, deleting.")
		qdel_self()
	RegisterSignal(mother_field, COMSIG_SHIELDS_UPDATE_STRENGTH_STATUS, PROC_REF(update_strength))
	update_nearby_tiles()

/obj/effect/energy_field/Destroy()
	if(istype(energy_field))
		energy_field.field -= src
		energy_field = null
	update_nearby_tiles()
	return ..()

/obj/effect/energy_field/proc/diffuse(var/duration)
	diffused_for = max(duration, 0)

/obj/effect/energy_field/attackby(obj/item/attacking_item, mob/user)
	user.do_attack_animation(src, attacking_item)
	if(attacking_item.force < 10)
		user.visible_message(SPAN_WARNING("[user] harmlessly attacks \the [src] with \the [attacking_item]."),
								SPAN_WARNING("You attack \the [src] with \the [attacking_item], but it bounces off without doing any damage."))
	else
		user.visible_message(SPAN_WARNING("[user] attacks \the [src] with \the [attacking_item]."),
								SPAN_WARNING("You attack \the [src] with \the [attacking_item]."))
		damage_field(attacking_item.force / 10)

/obj/effect/energy_field/attack_hand(mob/living/carbon/human/H)
	if(istype(H))
		if(H.species.can_shred(H))
			H.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			H.do_attack_animation(src, FIST_ATTACK_ANIMATION)
			H.visible_message(SPAN_WARNING("[H] shreds \the [src]!"), SPAN_WARNING("You shred \the [src]!"))
			damage_field(1)
			return
	to_chat(H, SPAN_WARNING("You touch \the [src], and it repulses your hand."))

/obj/effect/energy_field/ex_act(var/severity)
	damage_field(0.5 + severity)

/obj/effect/energy_field/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	damage_field(hitting_projectile.get_structure_damage() / 10)

/obj/effect/energy_field/proc/damage_field(var/severity)
	if(!severity)
		return

	damage += severity

	if(!(datum_flags & DF_ISPROCESSING))
		// Start processing ONLY when we're damaged. Through processing, we're going to slowly climb back up to field strength.
		START_PROCESSING(SSprocessing, src)

	var/shield_health = get_health()
	//if we take too much damage, drop out - the generator will bring us back up if we have enough power
	ticks_recovering = min(ticks_recovering + 2, 10)
	if(shield_health < 1 && is_strong)
		density_check(FALSE)
		is_strong = FALSE
		ticks_recovering = 10
	else if(shield_health >= 1 && !is_strong)
		density_check(TRUE)
		is_strong = TRUE

/obj/effect/energy_field/process(seconds_per_tick)
	if(!damage) // No need to process anymore.
		return PROCESS_KILL

	if(ticks_recovering)
		ticks_recovering--
	else
		damage = max(damage - energy_field.strengthen_rate, 0)

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

/obj/effect/energy_field/proc/update_strength()
	//if we take too much damage, drop out - the generator will bring us back up if we have enough power
	var/old_density = density
	var/shield_health = get_health()
	if(shield_health >= 1 && !is_strong)
		is_strong = TRUE
		density_check(TRUE)
	else if(shield_health < 1 && is_strong)
		is_strong = FALSE
		density_check(FALSE)

	if (density != old_density)
		update_nearby_tiles()

	diffuse_check()

/**
 * Easy helper proc to return the shield's current health.
 */
/obj/effect/energy_field/proc/get_health()
	return max(energy_field.field_strength - damage, 0)

/obj/effect/energy_field/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(mover?.movement_type & PHASING)
		return TRUE

	return (!density || air_group)
