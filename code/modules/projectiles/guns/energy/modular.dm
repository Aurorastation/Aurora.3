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
	var/criticality = 1 //multiplier for the negative effects of capacitor failures. Not just limited to critical failures.
	var/named = 0
	var/described = 0

/obj/item/weapon/gun/energy/laser/prototype/examine()
	..()
	if(usr.Adjacent(src))
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
	if((capacitor.reliability - capacitor.condition <= 0))
		qdel(capacitor)
		capacitor = null
	if(focusing_lens.reliability - focusing_lens.condition <= 0)
		qdel(focusing_lens)
		focusing_lens = null
	if(!focusing_lens || !capacitor)
		disassemble()
	reliability = (capacitor.reliability - capacitor.condition) + (focusing_lens.reliability - focusing_lens.condition)
	if(reliability < 0)
		reliability = 0
	fire_delay = capacitor.fire_delay
	max_shots = capacitor.shots
	dispersion = focusing_lens.dispersion
	accuracy = focusing_lens.accuracy
	burst += focusing_lens.burst
	if(gun_mods.len)
		handle_mod()
	fire_delay_wielded = min(0,(fire_delay - fire_delay*3))
	accuracy_wielded = accuracy + accuracy/4
	scoped_accuracy = accuracy_wielded + accuracy/4
	max_shots = max_shots * burst
	w_class = gun_type

/obj/item/weapon/gun/energy/laser/prototype/proc/handle_mod()
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		switch(modifier.mod_type)
			if(MOD_SILENCE)
				silenced = 1
			if(MOD_NUCLEAR_CHARGE)
				self_recharge = 1
				criticality *= 2
		fire_delay *= modifier.fire_delay
		reliability += modifier.reliability
		if(modifier.projectile)
			projectile_type = modifier.projectile
		burst += modifier.burst
		burst_delay += modifier.burst_delay
		max_shots *= modifier.shots
		force += modifier.gun_force
		chargetime += modifier.chargetime
		accuracy += modifier.accuracy
		criticality *= modifier.criticality
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
		A.damage *= modifier.damage
	A.damage = A.damage/(burst - 1)
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		if(prob(66))
			capacitor.condition += modifier.malus
		else
			focusing_lens.condition += modifier.malus
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
	if(!wielded && (origin_chassis == CHASSIS_LARGE || chargetime))
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

/obj/item/weapon/gun/energy/laser/prototype/verb/rename_gun()
	set name = "Name Prototype"
	set category = "Object"
	set desc = "Name your invention so that its glory might be eternal"

	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		named = 1
		return 1

/obj/item/weapon/gun/energy/laser/prototype/verb/describe_gun()
	set name = "Describe Prototype"
	set category = "Object"
	set desc = "Describe your invention so that its glory might be eternal"

	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""))

	if(src && input && !M.stat && in_range(M,src))
		desc = input
		M << "You describe the gun as [input]. Say hello to your new friend."
		described = 1
		return 1