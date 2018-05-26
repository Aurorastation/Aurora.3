/obj/item/weapon/gun/custom_ka/frame01
	name = "chicken legs kinetic accelerator frame"
	build_name = "Chicken Legs"
	icon_state = "frame01"
	w_class = 3
	capacity_increase = 3
	mod_limit_increase = 2
	origin_tech = list(TECH_MATERIAL = 2,TECH_ENGINEERING = 2)

/obj/item/weapon/gun/custom_ka/frame02
	name = "boomstick kinetic accelerator frame"
	build_name = "Boomstick"
	icon_state = "frame02"
	w_class = 3
	recoil_increase = -1
	capacity_increase = 5
	mod_limit_increase = 3
	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3)

/obj/item/weapon/gun/custom_ka/frame03
	name = "black club kinetic accelerator frame"
	build_name = "Black Club"
	icon_state = "frame03"
	w_class = 4
	recoil_increase = -2
	capacity_increase = 7
	mod_limit_increase = 4
	origin_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 4)

/obj/item/weapon/gun/custom_ka/frame04
	name = "loopclaw kinetic accelerator frame"
	build_name = "Loopclaw"
	icon_state = "frame04"
	w_class = 5
	recoil_increase = -5
	capacity_increase = 9
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 5)

/obj/item/weapon/gun/custom_ka/frame05
	name = "laserback kinetic accelerator frame"
	build_name = "Laserback"
	icon_state = "frame05"
	w_class = 5
	recoil_increase = -6
	capacity_increase = 10
	mod_limit_increase = 5
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 6)

/obj/item/weapon/gun/custom_ka/frame01/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell01
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel01
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/weapon/gun/custom_ka/frame02/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell02
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/firerate

/obj/item/weapon/gun/custom_ka/frame03/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell03
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel03
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/obj/item/weapon/gun/custom_ka/frame04/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell04
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel04
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/effeciency

/obj/item/weapon/gun/custom_ka/frame05/prebuilt
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell05
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel05
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/damage

/obj/item/weapon/gun/custom_ka/frame01/illegal
	installed_cell = /obj/item/custom_ka_upgrade/cells/illegal
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/illegal
	installed_upgrade_chip = /obj/item/custom_ka_upgrade/upgrade_chips/illegal

/obj/item/weapon/gun/custom_ka/frame05/cyborg
	can_disassemble_cell = FALSE
	installed_cell = /obj/item/custom_ka_upgrade/cells/cell04
	installed_barrel = /obj/item/custom_ka_upgrade/barrels/barrel02

//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 15
	damage_type = BRUTE
	check_armour = "bomb"
	range = 5

	var/pressure_decrease = 0.25
	var/list/hit_overlays = list()

/obj/item/projectile/kinetic/on_impact(var/atom/A,var/aoe_scale = 1, var/damage_scale = 1)

	if(damage_scale == 1)
		var/turf/target_turf = get_turf(A)
		if(!target_turf)
			target_turf = get_turf(src)
		var/datum/gas_mixture/environment = target_turf.return_air()
		var/pressure = environment.return_pressure()
		if(pressure > 50)
			name = "weakened [name]"
			damage *= pressure_decrease

	strike_thing(A,aoe*aoe_scale,damage*damage_scale)
	. = ..()

/obj/item/projectile/kinetic/proc/strike_thing(atom/target,var/new_aoe,var/damage_scale)

	var/turf/target_turf = get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(damage,dir)
	var/obj/effect/overlay/temp/kinetic_blast/K = new /obj/effect/overlay/temp/kinetic_blast(target_turf)
	K.color = color

	for(var/type in hit_overlays)
		new type(target_turf)

	if(aoe)
		aoe -= 1
		for(var/new_target in orange(1, target_turf))
			on_impact(new_target,0,0.5)