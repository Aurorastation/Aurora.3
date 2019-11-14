/datum/design/item/mecha/weapon
	req_tech = list(TECH_COMBAT = 3)
	build_type = MECHFAB
	category = "Exosuit Equipment (Weapons)"
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mecha/weapon/flamethrower
	name = "Flamethrower"
	id = "flamethrower"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_COMBAT = 2, TECH_PHORON = 2)
	materials = list("glass" = 5250, DEFAULT_WALL_MATERIAL = 40000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/flamethrower

/datum/design/item/mecha/weapon/taser
	name = "Mounted taser carbine"
	id = "mech_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser

/datum/design/item/mecha/weapon/lmg
	name = "Mounted machine gun"
	id = "mech_lmg"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg

/datum/design/item/mecha/weapon/scattershot
	name = "Mounted shotgun"
	id = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot

/datum/design/item/mecha/weapon/laser
	name = "Mounted laser carbine"
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser

/datum/design/item/mecha/weapon/laser_rigged
	name = "Jury-rigged welder-laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design/item/mecha/weapon/laser_heavy
	name = "Mounted laser cannon"
	id = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy

/datum/design/item/mecha/weapon/ion
	name = "Heavy ion cannon"
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

/datum/design/item/mecha/weapon/laser_gatling
	name = "Mounted gatling laser"
	id = "laser_gatling"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gatling
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "gold" = 6000)

/datum/design/item/mecha/weapon/xray_gatling
	name = "Gatling xray gun"
	id = "xray_gatling"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/xray
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "gold" = 6000, "phoron" = 6000)

/datum/design/item/mecha/weapon/tesla_gun
	name = "Mounted tesla cannon"
	id = "tesla_gun"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/tesla
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "silver" = 6000, "phoron" = 6000)

/datum/design/item/mecha/weapon/gyro_gun
	name = "Mounted gyrojet autocannon"
	id = "gyro_gun"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_MATERIAL = 6, TECH_ILLEGAL = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gyro
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "silver" = 6000, "phoron" = 6000, "diamond" = 7500)

/datum/design/item/mecha/weapon/grenade_launcher
	name = "Grenade launcher"
	id = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

/datum/design/item/mecha/weapon/clusterbang_launcher
	name = "Clusterbang Grenade launcher"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "gold" = 6000, "uranium" = 6000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited

/datum/design/item/mecha/weapon/plasma_cutter
	name = "Heavy plasma cutter"
	desc = "A large mining tool capable of expelling concentrated plasma bursts, useful for crushing rocks."
	id = "mecha_plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "gold" = 1000, "phoron" = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/plasma

/datum/design/item/mecha/weapon/incendiary
	name = "Mounted incendiary carbine"
	desc = "A weapon for combat exosuits. Shoots incendiary shells."
	id = "mecha_incendiary"
	req_tech = list(TECH_COMBAT= 4, TECH_MATERIAL = 4, TECH_PHORON = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "phoron" = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary