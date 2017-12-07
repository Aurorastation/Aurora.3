/obj/item/weapon/gun/energy/laser/prototype
	name = "laser prototype"
	desc = "A custom prototype laser weapon."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	can_turret = 0
	zoomdevicename = null
	var/origin_chassis
	var/gun_type
	var/list/gun_mods
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens
	var/chargetime
	var/is_charging

/obj/item/weapon/gun/energy/laser/prototype/examine()
	..()
	if(gun_mods.len)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods)
			usr << "You can see a [modifier] attached."
	if(capacitor)
		usr << "You can see a [capacitor] attached."
	if(focusing_lens)
		usr << "You can see a [focusing_lens] attached."

/obj/item/weapon/gun/energy/laser/prototype/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	if(!isscrewdriver(D))
		return ..()
	user << "You disassemble the [src]."
	disassemble()

/obj/item/weapon/gun/energy/laser/prototype/proc/updatetype()
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			gun_type =  CHASSIS_SMALL
			slot_flags = SLOT_BELT | SLOT_HOLSTER
			//item_state = sprite
		if(CHASSIS_MEDIUM)
			gun_type = CHASSIS_MEDIUM
			slot_flags = SLOT_BELT | SLOT_BACK
			//item_state = sprite
		if(CHASSIS_LARGE)
			gun_type = CHASSIS_LARGE
			slot_flags = SLOT_BACK
			//item_state = sprite
	if(gun_mods.len)
		handle_mod()
	w_class = gun_type
	if(!capacitor.reliability)
		qdel(capacitor)
		capacitor = null
	if(!focusing_lens.reliability)
		qdel(focusing_lens)
		focusing_lens = null
	if(!focusing_lens || !capacitor)
		disassemble()
	reliability = capacitor.reliability + focusing_lens.reliability
	if(reliability > 100)
		reliability = 100
	if(reliability < 0)
		reliability = 0
	fire_delay = capacitor.fire_delay
	max_shots = capacitor.shots
	dispersion = focusing_lens.dispersion
	fire_delay_wielded = min(0,(fire_delay - fire_delay*3))
	accuracy_wielded = accuracy + accuracy/4
	scoped_accuracy = accuracy_wielded + accuracy/4

/obj/item/weapon/gun/energy/laser/prototype/proc/handle_mod()
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		switch(modifier.mod_type)
			if(MOD_SILENCE)
				silenced = 1
			if(MOD_NUCLEAR_CHARGE)
				self_recharge = 1
		fire_delay += modifier.fire_delay
		reliability += modifier.reliability
		if(modifier.projectile)
			projectile_type = modifier.projectile
		burst += modifier.burst
		burst_delay += modifier.burst_delay
		max_shots += modifier.shots
		force += modifier.gun_force
		accuracy += modifier.accuracy
		chargetime += modifier.chargetime
		if(modifier.scope_name)
			zoomdevicename = modifier.scope_name

/obj/item/weapon/gun/energy/laser/prototype/consume_next_projectile()
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	if (self_recharge)
		addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	var/obj/item/projectile/beam/A = new projectile_type(src)
	if(!istype(A))
		return ..()
	A.damage = capacitor.damage
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		A.damage += modifier.damage
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		if(prob(50))
			capacitor.reliability -= modifier.malus
		else
			focusing_lens.reliability -= modifier.malus
	updatetype()
	return A

/obj/item/weapon/gun/energy/laser/prototype/proc/disassemble()
	if(gun_mods.len)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods)
			modifier.loc = src.loc
	if(capacitor)
		capacitor = src.loc
	if(focusing_lens)
		focusing_lens = src.loc
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			new /obj/item/device/laser_assembly(src.loc)
		if(CHASSIS_MEDIUM)
			new /obj/item/device/laser_assembly/medium(src.loc)
		if(CHASSIS_LARGE)
			new /obj/item/device/laser_assembly/large(src.loc)
	qdel(src)

/obj/item/weapon/gun/energy/laser/prototype/small_fail()
	if(capacitor)
		capacitor.small_fail(src)
	return

/obj/item/weapon/gun/energy/laser/prototype/medium_fail()
	if(capacitor)
		capacitor.medium_fail(src)
	return

/obj/item/weapon/gun/energy/laser/prototype/critical_fail()
	if(capacitor)
		capacitor.critical_fail(src)
	return

/obj/item/weapon/gun/energy/laser/prototype/can_wield()
	if(origin_chassis >= CHASSIS_MEDIUM)
		return 1
	else
		return 0

/obj/item/weapon/gun/energy/laser/prototype/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/laser/prototype/verb/wield_shotgun()
	set name = "Wield prototype"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/laser/prototype/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(zoomdevicename)
		if(wielded)
			toggle_scope(2.0, usr)
		else
			usr << "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>"
	else
		usr << "<span class='warning'>This device does not have a scope installed!</span>"

/obj/item/weapon/gun/energy/laser/prototype/special_check(var/mob/user)
	..()
	if(is_charging && chargetime)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	if(!wielded && origin_chassis == CHASSIS_LARGE)
		user << "<span class='danger'>You require both hands to fire this weapon!</span>"
		return 0
	if(chargetime)
		user.visible_message(
						"<span class='danger'>\The [user] begins charging the [src]!</span>",
						"<span class='danger'>You begin charging the [src]!</span>",
						"<span class='danger'>You hear a low pulsing roar!</span>"
						)
		is_charging = 1
		sleep(chargetime*10)
		is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	return 1