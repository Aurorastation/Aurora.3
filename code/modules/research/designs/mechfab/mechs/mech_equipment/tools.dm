/datum/design/item/mecha/tool
	build_type = MECHFAB
	category = "Exosuit Equipment (Tools)"
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mecha/tool/hydraulic_clamp
	name = "Hydraulic clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp

/datum/design/item/mecha/tool/drill
	name = "Drill"
	id = "drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill

/datum/design/item/mecha/tool/kinetic_accelerator
	name = "Burst kinetic accelerator"
	id = "kinetic_accelerator"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_PHORON = 3)
	materials = list("glass" = 2250, DEFAULT_WALL_MATERIAL = 55000, "silver" = 5250)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/kin_accelerator

/datum/design/item/mecha/tool/kinetic_accelerator/burst
	name = "Kinetic accelerator"
	id = "kinetic_accelerator_burst"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 4, TECH_PHORON = 4)
	materials = list("glass" = 5250, DEFAULT_WALL_MATERIAL = 60000, "silver" = 7250)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/kin_accelerator/burst

/datum/design/item/mecha/tool/extinguisher
	name = "Extinguisher"
	id = "extinguisher"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/extinguisher

/datum/design/item/mecha/tool/cable_layer
	name = "Cable layer"
	id = "mech_cable_layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer

/datum/design/item/mecha/tool/sleeper
	name = "Sleeper"
	id = "mech_sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 10000)

/datum/design/item/mecha/tool/syringe_gun
	name = "Syringe gun"
	id = "mech_syringe_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000)

/datum/design/item/mecha/tool/passenger
	name = "Passenger compartment"
	id = "mech_passenger"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)

/datum/design/item/mecha/tool/wormhole_gen
	name = "Wormhole generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/item/mecha/tool/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 6, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/item/mecha/tool/rfd_c
	name = "RFD-C"
	desc = "An exosuit-mounted Rapid-Fabrication-Device C-Class."
	id = "mech_rfd_c"
	time = 120
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "phoron" = 25000, "silver" = 20000, "gold" = 20000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rfd_c

/datum/design/item/mecha/tool/gravcatapult
	name = "Gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/item/mecha/tool/repair_droid
	name = "Repair droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "gold" = 1000, "silver" = 2000, "glass" = 5000)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/item/mecha/tool/phoron_generator
	name = "Phoron generator"
	desc = "Converts sheets of phoron into energy."
	id = "mech_phoron_generator"
	req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "silver" = 500, "glass" = 1000)

/datum/design/item/mecha/tool/energy_relay
	name = "Energy relay"
	desc = "Saps power from APCs in range to power on-board energy cell."
	id = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "gold" = 2000, "silver" = 3000, "glass" = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/item/mecha/tool/ccw_armor
	name = "CQC armor booster"
	desc = "Exosuit close-combat armor booster. Anti-melee."
	id = "mech_cqc_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "silver" = 5000)
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster

/datum/design/item/mecha/tool/proj_armor
	name = "Ranged-combat armor booster"
	desc = "Exosuit projectile armor booster. Anti-firearm."
	id = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "gold" = 5000)
	build_path = /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster

/datum/design/item/mecha/tool/diamond_drill
	name = "Diamond drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "diamond" = 6500)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/item/mecha/tool/generator_nuclear
	name = "Nuclear generator"
	desc = "Exosuit-held nuclear reactor. Converts uranium into energy. Leaks radiation."
	id = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "silver" = 500, "glass" = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear