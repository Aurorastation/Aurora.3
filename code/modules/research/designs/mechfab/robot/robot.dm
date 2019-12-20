/datum/design/item/mechfab
	build_type = MECHFAB
	req_tech = list()

/datum/design/item/mechfab/robot
	category = "Robot"

//if the fabricator is a mech fab pass the manufacturer info over to the robot part constructor
/datum/design/item/mechfab/robot/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/mecha_part_fabricator))
		var/obj/machinery/mecha_part_fabricator/mechfab = fabricator
		return new build_path(newloc, mechfab.manufacturer)
	return ..()

/datum/design/item/mechfab/robot/exoskeleton
	name = "Robot exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 50000)

/datum/design/item/mechfab/robot/torso
	name = "Robot torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 40000)

/datum/design/item/mechfab/robot/head
	name = "Robot head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 25000)

/datum/design/item/mechfab/robot/l_arm
	name = "Robot left arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/robot/r_arm
	name = "Robot right arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/robot/l_leg
	name = "Robot left leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/robot/r_leg
	name = "Robot right leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/robot/component
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/robot/component/synthetic_flash
	name = "Synthetic flash"
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 750)
	build_path = /obj/item/device/flash/synthetic

/datum/design/item/mechfab/robot/component/binary_communication_device
	name = "Binary communication device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/item/mechfab/robot/component/radio
	name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/item/mechfab/robot/component/actuator
	name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/item/mechfab/robot/component/diagnosis_unit
	name = "Diagnosis unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/item/mechfab/robot/component/camera
	name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/item/mechfab/robot/component/armor
	name = "Armor plating"
	id = "armor"
	build_path = /obj/item/robot_parts/robot_component/armor

/datum/design/item/mechfab/robot/component/surge
	name = "Heavy surge prevention module"
	desc = "Used to boost prevent damage from EMP. Has limited surge preventions."
	id = "borg_surge_module"
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "glass" = 6000, "gold" = 5000, "silver" = 7500) // Should be expensive
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_MAGNET = 5, TECH_POWER = 5, TECH_ENGINEERING = 4, TECH_COMBAT = 3)
	build_path = /obj/item/robot_parts/robot_component/surge