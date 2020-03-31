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
	name = "Robot Exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 35000)

/datum/design/item/mechfab/robot/torso
	name = "Robot Torso"
	build_path = /obj/item/robot_parts/chest
	time = 25
	materials = list(DEFAULT_WALL_MATERIAL = 25000)

/datum/design/item/mechfab/robot/head
	name = "Robot Head"
	build_path = /obj/item/robot_parts/head
	time = 25
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/robot/l_arm
	name = "Robot Left Arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mechfab/robot/r_arm
	name = "Robot Right Arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mechfab/robot/l_leg
	name = "Robot Left Leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mechfab/robot/r_leg
	name = "Robot Right Leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 10000)

/datum/design/item/mechfab/robot/component
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/robot/component/synthetic_flash
	name = "Synthetic Flash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 750)
	build_path = /obj/item/device/flash/synthetic

/datum/design/item/mechfab/robot/component/binary_communication_device
	name = "Binary Communication Device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/item/mechfab/robot/component/radio
	name = "Radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/item/mechfab/robot/component/actuator
	name = "Actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/item/mechfab/robot/component/diagnosis_unit
	name = "Diagnosis unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/item/mechfab/robot/component/camera
	name = "Camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/item/mechfab/robot/component/armor
	name = "Armor Plating"
	build_path = /obj/item/robot_parts/robot_component/armor

/datum/design/item/mechfab/robot/component/surge
	name = "Heavy Surge Prevention Module"
	desc = "Used to boost prevent damage from EMP. Has limited surge preventions."
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 5000, MATERIAL_SILVER = 7500) // Should be expensive
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_MAGNET = 5, TECH_POWER = 5, TECH_ENGINEERING = 4, TECH_COMBAT = 3)
	build_path = /obj/item/robot_parts/robot_component/surge