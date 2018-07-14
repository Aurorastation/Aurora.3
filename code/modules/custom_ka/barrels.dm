/obj/item/custom_ka_upgrade/barrels/barrel01
	name = "standard core KA power converter"
	build_name = "'Standard'"
	desc = "A very standard kinetic accelerator energy converter and barrel assembly. Has poor range and firerate, but gets the job done."
	icon_state = "barrel01"
	damage_increase = 15
	firedelay_increase = 1 SECONDS
	range_increase = 3
	recoil_increase = 2
	cost_increase = 1
	cell_increase = 0
	capacity_increase = -1
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'
	projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1,TECH_MAGNET = 1, TECH_PHORON = 2)

/obj/item/custom_ka_upgrade/barrels/barrel02
	name = "professional core KA power converter"
	build_name = "'Professional'"
	desc = "A more advanced kinetic accelerator energy converter and barrel assembly intended for professional miners out on the rock."
	icon_state = "barrel02"
	damage_increase = 15
	firedelay_increase = 0.5 SECONDS
	range_increase = 4
	recoil_increase = 3
	cost_increase = 1
	cell_increase = 0
	capacity_increase = -2
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'
	projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1,TECH_MAGNET = 3, TECH_PHORON = 2)

/obj/item/custom_ka_upgrade/barrels/barrel03
	name = "meteor core KA power converter"
	build_name = "'Meteor'"
	desc = "A very robust kinetic accelerator energy converter used by professional mining contractors intended for the use in mining soft metals such as gold on asteroids."
	icon_state = "barrel03"
	damage_increase = 20
	firedelay_increase = 0.75 SECONDS
	range_increase = 5
	recoil_increase = 4
	cost_increase = 2
	cell_increase = 0
	capacity_increase = -3
	fire_sound = 'sound/weapons/resonator_fire.ogg'
	projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 3,TECH_MAGNET = 3, TECH_PHORON = 3)


/obj/item/custom_ka_upgrade/barrels/barrel04
	name = "planet core KA power converter"
	build_name = "'Planet'"
	desc = "An incredibly powerful and efficient kinetic accelerator energy converter intended for the use in atmospheric areas such as planets and gas giants."
	icon_state = "barrel04"
	damage_increase = 25
	firedelay_increase = 1 SECONDS
	range_increase = 6
	recoil_increase = 6
	cost_increase = 5
	cell_increase = 0
	capacity_increase = -4
	fire_sound = 'sound/weapons/pulse.ogg'
	projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 3,TECH_MAGNET = 5, TECH_PHORON = 4)

/obj/item/custom_ka_upgrade/barrels/barrel05
	name = "experimental core KA power converter"
	build_name = "'Experimental'"
	desc = "A very experimental kinetic accelerator energy converter. Not much is known about this thing, other than it kicks like a mule and stings like an e-sword."
	icon_state = "barrel05"
	damage_increase = 30
	firedelay_increase = 1 SECONDS
	range_increase = 7
	recoil_increase = 10
	cost_increase = 10
	cell_increase = 0
	capacity_increase = -5
	fire_sound = 'sound/weapons/resonator_blast.ogg'
	projectile_type = /obj/item/projectile/kinetic
	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 5,TECH_MAGNET = 6, TECH_PHORON = 5)

/obj/item/custom_ka_upgrade/barrels/illegal
	name = "laser KA power converter"
	build_name = "'Syndicate''"
	desc = "A laser crystal ripped from a laser rifle and repurposed for kinetic accelerator assemblies."
	icon_state = "barrel_laser"
	damage_increase = 15
	firedelay_increase = 1.5 SECONDS
	range_increase = 64
	recoil_increase = 0
	cost_increase = 10
	cell_increase = 0
	capacity_increase = 0
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	projectile_type = /obj/item/projectile/beam/midlaser
	origin_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 4,TECH_MAGNET = 4,TECH_COMBAT = 5,TECH_ILLEGAL = 5)
