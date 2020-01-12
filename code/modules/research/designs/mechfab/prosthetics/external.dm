/datum/design/item/mechfab/prosthetic
	category = "Prosthetic (External)"

//if the fabricator is a mech fab pass the manufacturer info over to the robot part constructor
/datum/design/item/mechfab/prosthetic/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/mecha_part_fabricator))
		var/obj/machinery/mecha_part_fabricator/mechfab = fabricator
		return new build_path(newloc, mechfab.manufacturer)
	return ..()

// Copied from robot.dm, but reflavoured to be more fitting to prosthetics.
/datum/design/item/mechfab/prosthetic/l_arm
	name = "Prosthetic left arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/prosthetic/r_arm
	name = "Prosthetic right arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/prosthetic/l_leg
	name = "Prosthetic left leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/prosthetic/r_leg
	name = "Prosthetic right leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)