/obj/item/mech_component/chassis/tank
	name = "hull"
	icon_state = "pra_hull"
	mech_health = 1000
	has_hardpoints = list(HARDPOINT_BACK)

/obj/item/mech_component/chassis/tank/prebuild()
	. = ..()
	mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)
	cell = new /obj/item/cell/tank(src)

/obj/item/mech_component/sensors/tank
	name = "sensors"
	icon_state = "pra_turret"
	max_damage = 300

/obj/item/mech_component/sensors/tank/prebuild()
	..()
	software = new(src)
	software.installed_software |= MECH_SOFTWARE_WEAPONS
	software.installed_software |= MECH_SOFTWARE_ADVWEAPONS

/obj/item/mech_component/propulsion/tracks/tank
	trample_damage = 45
	icon_state = "pra_treads"
	max_damage = 450

/obj/item/mech_component/manipulators/tank
	name = "weapon mount"
	icon_state = "weaponmount"
	has_hardpoints = list(HARDPOINT_CANNON, HARDPOINT_MG)

/obj/item/mecha_equipment/mounted_system/tankcannon
	name = "tank gun"
	desc = "A weapon designated for tanks, fires big bullets."
	icon_state = "pra_cannon"
	holding_type = /obj/item/gun/energy/gauss/mounted/mech/tank
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	restricted_hardpoints = list(HARDPOINT_CANNON)

/obj/item/gun/energy/gauss/mounted/mech/tank
	name = "tankgun"
	desc = "A weapon designated for tanks, fires big bullets."
	fire_sound = 'sound/effects/Explosion1.ogg'
	max_shots = 1
	projectile_type = /obj/item/projectile/bullet/cannon
	recharge_time = 60

/obj/item/mecha_equipment/mounted_system/taser/smg/heavyy
	name = "mounted machinegun"
	desc = "A tank mounted automatic weapon. Handle with care."
	icon_state = "heavysmg"
	holding_type = /obj/item/gun/energy/mountedsmg/tank
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	restricted_hardpoints = list(HARDPOINT_MG)

/obj/item/gun/energy/mountedsmg/tank
	name = "mounted machine gun"
	desc = "A tank mounted machine gun."
	max_shots = 300
	fire_sound = 'sound/weapons/gunshot/gunshot_saw.ogg'
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/cell/tank
	name = "tank engine"
	icon_state = "hpcell"
	maxcharge = 240000
