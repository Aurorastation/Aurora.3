
//---------- actual energy field

/obj/effect/energy_field
	name = "energy shield"
	desc = "A strong field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/effects/effects.dmi'
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
	/// If strength goes is 1 or above, this is set to TRUE, this is to prevent flickering and animate being called constantly
	var/is_strong = FALSE
	pass_flags_self = PASSSHIELD //Currently only ship weapons have this flag.

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
	energy_field.remove_individual_field(src)

/obj/effect/energy_field/attackby(obj/item/attacking_item, mob/user)
	user.do_attack_animation(src, used_item = attacking_item)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
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
			H.do_attack_animation(src)
			H.visible_message(SPAN_WARNING("[H] shreds \the [src]!"), SPAN_WARNING("You shred \the [src]!"))
			damage_field(1)
			return
	to_chat(H, SPAN_WARNING("You touch \the [src], and it repulses your hand."))

/obj/effect/energy_field/ex_act(var/severity)
	damage_field(0.5 + severity)

/obj/effect/energy_field/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)

	var/initial_damage = hitting_projectile.get_structure_damage()
	/**
	 * The shield has three possible interactions with a projectile:
	 *
	 * If the projectile is piercing (penetrating >= 1 and pierce_flags = PASSSHIELD), the shield will decrease what it can subsequently penetrate.
	 * The projectile will have it's pierces increased by half the shield's strength. If a projectile's pierces is greater than it's penetrating, it stops.
	 *
	 * Eg. A penetrating 10 shot hits a strength 10 shield. It will subsequently go through 4 additional walls (10/2 = 5, +1 for the shield tile), instead of the 10 it would originally.
	 */
	if(piercing_hit)
		hitting_projectile.pierces += round((energy_field.field_strength / 2))
		if(hitting_projectile.pierces < hitting_projectile.penetrating)
			visible_message(SPAN_WARNING("\The [src] flickers and fails as it is penetrated by the \the [hitting_projectile]."))
			damage_field(initial_damage / 20) //The shield takes less damage if it is penetrated like this.
			return BULLET_ACT_FORCE_PIERCE

	/**
	 * A projectile without pass_flags = PASSSHIELD will have its damage reduced by the shield, if its damage is reduced to zero it is blocked.
	 * A strong projectile hitting a weak shield will penetrate it. A strength 10 field will always block a projectile.
	 * The projectile's damage is multiplied by 1 minus the shield's strength divided by 10, then the shield's strength is subtracted from it's damage.
	 *
	 * Eg. A 50 damage projectile hits a 5 strength shield. (damage multiplier: 1 - 5/10 = 0.5), (shot damage: = 50 * 0.5 = 25), (final damage: 25 - 5 = 20). Penetrates.
	 * Therefore the shot would continue on, but only deal 20 damage when it hits.
	 *
	 * Eg. A 50 damage projectile hits a 9 strength shield. (damage multiplier: 1 - 9/10 = 0.1), (shot damage: = 50 * 0.1 = 5), (final damage: 5 - 9 = -4). Blocked.
	 */
	if(energy_field.field_strength < 10) //A strength 10 field will always block a projectile. Without modifications to the engines, one or more upgraded SMES units, or upgrades from research the Horizon cannot generate a field of strength 10 that covers the whole ship.
		hitting_projectile.damage *= 1 - max(0, energy_field.field_strength / 10)
		hitting_projectile.damage -= energy_field.field_strength
		if(hitting_projectile.damage >= 0)
			damage_field(initial_damage / 10)
			visible_message(SPAN_WARNING("\The [src] flashes and depletes the [hitting_projectile]'s energy, but doesn't fully block it."))
			return BULLET_ACT_FORCE_PIERCE
		else
			visible_message(SPAN_WARNING("\The [src] shimmers and absorbs \the [hitting_projectile]."))
			return BULLET_ACT_BLOCK

	/**
	 * An explosive projectile that fails to penetrate will be deleted before it can explode.
	 * All explosive ship weapons also have high damage, so this only really matters on a strength 10 shield.
	 * If the projectile is explosive, it deals whatever damage that explosion would have done to the shield.
	 */
	if(istype(hitting_projectile, /obj/projectile/ship_ammo))
		var/obj/projectile/ship_ammo/explosive_projectile = hitting_projectile
		if(explosive_projectile.explosion_strength[3] || explosive_projectile.explosion_strength[2] || explosive_projectile.explosion_strength[1])
			for(var/obj/effect/energy_field/shield_tile in energy_field.field)
				var/distance = get_dist(src, shield_tile)
				if(distance <= explosive_projectile.explosion_strength[1])
					shield_tile.damage_field(3)
				else if(distance <= explosive_projectile.explosion_strength[2])
					shield_tile.damage_field(2)
				else if(distance <= explosive_projectile.explosion_strength[3])
					shield_tile.damage_field(1)
			// explosive_projectile.explosion_strength = list(0, 0, 0) // Set the explosion strength to 0.
			visible_message(SPAN_WARNING("\The [src] shimmers and absorbs \the [hitting_projectile]."))
			return BULLET_ACT_BLOCK

	damage_field(initial_damage / 10)

	. = ..() //If we get down here fall back on normal piercing calculations, for normal projectiles hitting shields.
	if(. != BULLET_ACT_HIT)
		return .

/obj/effect/energy_field/proc/damage_field(var/severity)
	if(!severity)
		return

	damage += severity
	energy_field.field_strength = max(energy_field.field_strength - (severity / length(energy_field.field)), 0)

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
		update_strength()
		return PROCESS_KILL

	if(ticks_recovering)
		ticks_recovering--
	else
		damage = max(damage - energy_field.strengthen_rate, 0)

/obj/effect/energy_field/proc/density_check(var/turn_on)
	if(turn_on)
		alpha = 0
		density = TRUE
		mouse_opacity = MOUSE_OPACITY_ICON
		animate(src, 2 SECONDS, alpha = 255)
	else
		alpha = 255
		density = FALSE
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		animate(src, 2 SECONDS, alpha = 0)

/obj/effect/energy_field/proc/update_strength()
	SIGNAL_HANDLER
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

/**
 * Easy helper proc to return the shield's current health.
 */
/obj/effect/energy_field/proc/get_health()
	return max(energy_field.field_strength - damage, 0)

/obj/effect/energy_field/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(mover?.movement_type & PHASING)
		return TRUE

	return (!density || air_group)

/obj/effect/energy_field/afterShuttleMove(obj/effect/shuttle_landmark/destination)
	qdel_self()
