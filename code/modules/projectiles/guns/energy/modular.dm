/obj/item/gun/energy/laser/prototype
	name = "laser prototype"
	desc = "A custom prototype laser weapon."
	icon = 'icons/obj/guns/modular_laser.dmi'
	icon_state = "large_3"
	item_state = "large_3"
	contained_sprite = TRUE
	has_icon_ratio = FALSE
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	can_turret = TRUE
	zoomdevicename = null
	max_shots = 0
	burst_delay = 0
	pin = null
	var/origin_chassis
	var/gun_type
	var/list/gun_mods = list()
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens
	var/obj/item/laser_components/modulator/modulator
	var/chargetime
	var/is_charging
	var/criticality = 1 //multiplier for the negative effects of capacitor failures. Not just limited to critical failures.
	var/named = 0
	var/described = 0

/obj/item/gun/energy/laser/prototype/examine(mob/user)
	..(user)
	if(get_dist(src, user) > 1)
		return
	if(gun_mods.len)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods)
			to_chat(user, "You can see \the [modifier] attached.")
	if(capacitor)
		to_chat(user, "You can see \the [capacitor] attached.")
	if(focusing_lens)
		to_chat(user, "You can see \the [focusing_lens] attached.")
	if(modulator)
		to_chat(user, "You can see \the [modulator] attached.")

/obj/item/gun/energy/laser/prototype/attackby(var/obj/item/D, var/mob/user)
	if(!D.isscrewdriver())
		return ..()
	to_chat(user, "You disassemble \the [src].")
	disassemble(user)

/obj/item/gun/energy/laser/prototype/update_icon()
	..()
	if(origin_chassis == CHASSIS_LARGE)
		if(wielded)
			item_state = "large_3_wielded"
		else
			item_state = "large_3"
	underlays.Cut()
	if(length(gun_mods))
		for(var/obj/item/laser_components/mod in gun_mods)
			if(mod.gun_overlay)
				underlays += mod.gun_overlay
	update_held_icon()

/obj/item/gun/energy/laser/prototype/proc/reset_vars()
	burst = initial(burst)
	reliability = initial(reliability)
	burst_delay = initial(burst_delay)
	max_shots = initial(max_shots)
	chargetime = initial(chargetime)
	accuracy = initial(accuracy)
	criticality = initial(criticality)
	fire_sound = initial(fire_sound)
	force = initial(force)
	is_wieldable = initial(is_wieldable)
	action_button_name = initial(action_button_name)

/obj/item/gun/energy/laser/prototype/proc/updatetype(var/mob/user)
	reset_vars()
	if(!focusing_lens || !capacitor || !modulator)
		disassemble(user)
		return

	update_chassis()

	if(capacitor.reliability - capacitor.condition <= 0)
		if(prob(66))
			capacitor.small_fail(user)
		else
			capacitor.medium_fail(user)
		qdel(capacitor)
		capacitor = null

	if(focusing_lens.reliability - focusing_lens.condition <= 0)
		qdel(focusing_lens)
		focusing_lens = null

	if(!focusing_lens || !capacitor || !modulator)
		disassemble(user)
		return

	reliability = (capacitor.reliability - capacitor.condition) + (focusing_lens.reliability - focusing_lens.condition)

	if(modulator.projectile)
		projectile_type = modulator.projectile

	fire_delay = capacitor.fire_delay
	max_shots = capacitor.shots
	power_supply.maxcharge = max_shots*charge_cost
	dispersion = focusing_lens.dispersion
	accuracy = focusing_lens.accuracy
	burst += focusing_lens.burst
	fire_sound = modulator.firing_sound

	if(gun_mods.len)
		handle_mod()

	fire_delay_wielded = min(0,(fire_delay - fire_delay*3))
	accuracy_wielded = accuracy + accuracy/4
	scoped_accuracy = accuracy_wielded + accuracy/4
	max_shots = max_shots * burst
	w_class = gun_type
	reliability = max(reliability, 1)

/obj/item/gun/energy/laser/prototype/proc/update_chassis()
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			gun_type = CHASSIS_SMALL
			slot_flags = SLOT_BELT | SLOT_HOLSTER
			item_state = "small_3"
		if(CHASSIS_MEDIUM)
			gun_type = CHASSIS_MEDIUM
			slot_flags = SLOT_BELT | SLOT_BACK
			item_state = "medium_3"
			is_wieldable = TRUE
		if(CHASSIS_LARGE)
			gun_type = CHASSIS_LARGE
			slot_flags = SLOT_BACK
			item_state = "large_3"
			is_wieldable = TRUE
	update_wield_verb()

/obj/item/gun/energy/laser/prototype/proc/handle_mod()
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		switch(modifier.mod_type)
			if(MOD_SILENCE)
				silenced = 1
			if(MOD_NUCLEAR_CHARGE)
				self_recharge = 1
				criticality *= 2
		fire_delay *= modifier.fire_delay
		reliability += modifier.reliability
		burst += modifier.burst
		burst_delay += modifier.burst_delay
		max_shots *= modifier.shots
		force = min(force + modifier.gun_force, 40)
		chargetime += modifier.chargetime*10
		accuracy += modifier.accuracy
		criticality *= modifier.criticality
		if(modifier.scope_name)
			zoomdevicename = modifier.scope_name

/obj/item/gun/energy/laser/prototype/consume_next_projectile()
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	if(!capacitor)
		return null
	if (self_recharge)
		addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	var/obj/item/projectile/beam/A = new projectile_type(src)
	A.damage = capacitor.damage
	var/damage_coeff = 1
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		damage_coeff *= modifier.damage
	if(burst > 1)
		A.damage = A.damage/(burst - 1)
	damage_coeff *= modulator.damage
	A.damage *= damage_coeff
	A.damage = min(A.damage, 60) //let's not get too ridiculous here
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		if(prob((gun_mods.len * 10 * damage_coeff)/(max(1,(burst - 1)))))
			capacitor.degrade(modifier.malus)
		if(prob((gun_mods.len * 10 * damage_coeff)/(max(1,(burst - 1)))))
			focusing_lens.degrade(modifier.malus)
		if(prob((33 + capacitor.damage)/(max(1,(burst - 1)))))
			modifier.degrade(1)
	if((prob(A.damage)/burst))
		if(prob(A.damage/2))
			medium_fail(ismob(loc) ? loc : null)
		else
			small_fail(ismob(loc) ? loc : null)

	updatetype(ismob(loc) ? loc : null)
	return A

/obj/item/gun/energy/laser/prototype/proc/disassemble(var/mob/user)
	var/atom/A
	if (user && user.loc)
		A = user.loc
	else
		A = get_turf(src)
	if(gun_mods.len)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods)
			modifier.forceMove(A)
			gun_mods.Remove(modifier)
	if(capacitor)
		capacitor.forceMove(A)
		capacitor = null
	if(focusing_lens)
		focusing_lens.forceMove(A)
		focusing_lens = null
	if(modulator)
		modulator.forceMove(A)
		modulator = null
	if(pin)
		pin.forceMove(A)
		pin.gun = null
		pin = null
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			new /obj/item/device/laser_assembly(A)
		if(CHASSIS_MEDIUM)
			new /obj/item/device/laser_assembly/medium(A)
		if(CHASSIS_LARGE)
			new /obj/item/device/laser_assembly/large(A)
	qdel(src)

/obj/item/gun/energy/laser/prototype/small_fail(var/mob/user)
	if(capacitor)
		to_chat(user, "<span class='danger'>\The [src]'s [capacitor] short-circuits!</span>")
		capacitor.small_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/medium_fail(var/mob/user)
	if(capacitor)
		to_chat(user, "<span class='danger'>\The [src]'s [capacitor] overloads!</span>")
		capacitor.medium_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/critical_fail(var/mob/user)
	if(capacitor)
		to_chat(user, "<span class='danger'>\The [src]'s [capacitor] goes critical!</span>")
		capacitor.critical_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/can_wield()
	if(origin_chassis >= CHASSIS_MEDIUM)
		return 1
	else
		return 0

/obj/item/gun/energy/laser/prototype/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/gun/energy/laser/prototype/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(zoomdevicename)
		if(wielded)
			toggle_scope(2.0, usr)
		else
			to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")
	else
		to_chat(usr, "<span class='warning'>This device does not have a scope installed!</span>")

/obj/item/gun/energy/laser/prototype/special_check(var/mob/user)
	if(is_charging && chargetime)
		to_chat(user, "<span class='danger'>\The [src] is already charging!</span>")
		return 0
	if(!wielded && (origin_chassis == CHASSIS_LARGE))
		to_chat(user, "<span class='danger'>You require both hands to fire this weapon!</span>")
		return 0
	if(chargetime)
		user.visible_message(
						"<span class='danger'>\The [user] begins charging the [src]!</span>",
						"<span class='danger'>You begin charging the [src]!</span>",
						"<span class='danger'>You hear a low pulsing roar!</span>"
						)
		is_charging = 1

		if(!do_after(user, chargetime))
			is_charging = 0
			return 0

		is_charging = 0

	if(!istype(user.get_active_hand(), src))
		return 0

	return ..()

/obj/item/gun/energy/laser/prototype/verb/rename_gun()
	set name = "Name Prototype"
	set category = "Object"
	set desc = "Name your invention so that its glory might be eternal"

	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		named = 1
		return 1

/obj/item/gun/energy/laser/prototype/verb/describe_gun()
	set name = "Describe Prototype"
	set category = "Object"
	set desc = "Describe your invention so that its glory might be eternal"

	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""))

	if(src && input && !M.stat && in_range(M,src))
		desc = input
		to_chat(M, "You describe the gun as [input]. Say hello to your new friend.")
		described = 1
		return 1
