/datum/design/item/mechfab/prosthetic
	category = "Prosthetic (External)"

//if the fabricator is a mech fab we need to construct the proper typepath for the manufacturer
/datum/design/item/mechfab/prosthetic/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/mecha_part_fabricator))
		var/obj/machinery/mecha_part_fabricator/mechfab = fabricator
		for(var/model_path in subtypesof(build_path))
			var/obj/item/organ/external/E = new model_path
			if(E.robotize_type == mechfab.manufacturer)
				return E.forceMove(newloc)
			else
				qdel(E)
		return new build_path(newloc) // We didn't find our manufacturer in the list, so return an unbranded one
	return ..()

/datum/design/item/mechfab/prosthetic/l_arm
	name = "Prosthetic left arm"
	id = "prosthetic_l_arm"
	build_path = /obj/item/organ/external/arm/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/prosthetic/r_arm
	name = "Prosthetic right arm"
	id = "prosthetic_r_arm"
	build_path = /obj/item/organ/external/arm/right/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/prosthetic/l_leg
	name = "Prosthetic left leg"
	id = "prosthetic_l_leg"
	build_path = /obj/item/organ/external/leg/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/prosthetic/r_leg
	name = "Prosthetic right leg"
	id = "prosthetic_r_leg"
	build_path = /obj/item/organ/external/leg/right/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/prosthetic/l_hand
	name = "Prosthetic left hand"
	id = "prosthetic_l_hand"
	build_path = /obj/item/organ/external/hand/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/r_hand
	name = "Prosthetic right hand"
	id = "prosthetic_r_hand"
	build_path = /obj/item/organ/external/hand/right/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/l_foot
	name = "Prosthetic left foot"
	id = "prosthetic_l_foot"
	build_path = /obj/item/organ/external/foot/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/r_foot
	name = "Prosthetic right foot"
	id = "prosthetic_r_foot"
	build_path = /obj/item/organ/external/foot/right/industrial
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)