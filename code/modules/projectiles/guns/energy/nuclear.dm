/obj/item/weapon/gun/energy/gun
	name = "energy carbine"
	desc = "An energy-based carbine with two settings: Stun and kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT
	max_shots = 10
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam
	secondary_fire_sound = 'sound/weapons/Laser.ogg'
	can_switch_modes = 1
	turret_is_lethal = 0

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill", fire_sound='sound/weapons/Laser.ogg')
		)

	var/crit_fail = 0 //Added crit_fail as a local variable

/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1
	can_turret = 0

/obj/item/weapon/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	self_recharge = 1
	modifystate = null
	var/reliability = 95
	turret_sprite_set = "nuclear"
	charge_failure_message = "'s charging socket was removed to make room for a minaturized reactor."

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg')
		)

	var/lightfail = 0

/obj/item/weapon/gun/energy/gun/nuclear/get_cell()
	return DEVICE_NO_CELL

/obj/item/weapon/gun/energy/gun/nuclear/proc/failcheck()
	lightfail = 0
	if (prob(src.reliability)) return 1 //No failure
	if (prob(src.reliability))
		for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
			if (src in M.contents)
				M << "<span class='warning'>Your gun feels pleasantly warm for a moment.</span>"
			else
				M << "<span class='warning'>You feel a warm sensation.</span>"
			M.apply_effect(rand(3,120), IRRADIATE)
		lightfail = 1
	else
		for (var/mob/living/M in range(rand(1,4),src)) //Big failure, TIME FOR RADIATION BITCHES
			if (src in M.contents)
				M << "<span class='danger'>Your gun's reactor overloads!</span>"
			M << "<span class='warning'>You feel a wave of heat wash over you.</span>"
			M.apply_effect(300, IRRADIATE)
		crit_fail = 1 //break the gun so it stops recharging
		self_recharge = FALSE
		update_icon()
	return 0

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_charge()
	if (crit_fail)
		add_overlay("nucgun-whee")
		return
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	add_overlay("nucgun-[ratio]")

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_reactor()
	if(crit_fail)
		add_overlay("nucgun-crit")
		return
	if(lightfail)
		add_overlay("nucgun-medium")
	else if ((power_supply.charge/power_supply.maxcharge) <= 0.5)
		add_overlay("nucgun-light")
	else
		add_overlay("nucgun-clean")

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") 
			add_overlay("nucgun-stun")
		if("lethal") 
			add_overlay("nucgun-kill")
/*
/obj/item/weapon/gun/energy/gun/nuclear/emp_act(severity)
	..()
	reliability -= round(15/severity)
*/
/obj/item/weapon/gun/energy/gun/nuclear/update_icon()
	cut_overlays()
	update_charge()
	update_reactor()
	update_mode()

/obj/item/weapon/gun/energy/pistol
	name = "energy pistol"
	desc = "A basic energy-based pistol gun with two settings: Stun and kill."
	icon_state = "epistolstun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shots = 5
	fire_delay = 4
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam/pistol
	secondary_fire_sound = 'sound/weapons/Laser.ogg'
	can_switch_modes = 1
	turret_sprite_set = "carbine"
	turret_is_lethal = 0

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "epistolstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="epistolstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam/pistol, modifystate="epistolkill", fire_sound='sound/weapons/Laser.ogg')
		)
