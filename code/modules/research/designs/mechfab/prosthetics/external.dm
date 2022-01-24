/datum/design/item/mechfab/prosthetic
	category = "Prosthetic (External)"
	var/use_direct_buildpath = FALSE

//if the fabricator is a mech fab we need to construct the proper typepath for the manufacturer
/datum/design/item/mechfab/prosthetic/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/mecha_part_fabricator))
		if(!use_direct_buildpath)
			var/obj/machinery/mecha_part_fabricator/mechfab = fabricator
			for(var/model_path in subtypesof(build_path))
				var/obj/item/organ/external/E = new model_path
				if(E.robotize_type == mechfab.manufacturer)
					qdel(E)
					return new model_path(newloc)
				qdel(E)
		return new build_path(newloc) // We didn't find our manufacturer in the list, so return an unbranded one
	return ..()

/datum/design/item/mechfab/prosthetic/l_arm
	name = "Prosthetic Left Arm"
	build_path = /obj/item/organ/external/arm/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/prosthetic/r_arm
	name = "Prosthetic Right Arm"
	build_path = /obj/item/organ/external/arm/right/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/prosthetic/l_leg
	name = "Prosthetic Left Leg"
	build_path = /obj/item/organ/external/leg/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/prosthetic/r_leg
	name = "Prosthetic Right Leg"
	build_path = /obj/item/organ/external/leg/right/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/prosthetic/l_hand
	name = "Prosthetic Left Hand"
	build_path = /obj/item/organ/external/hand/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/r_hand
	name = "Prosthetic Right Hand"
	build_path = /obj/item/organ/external/hand/right/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/l_foot
	name = "Prosthetic Left Foot"
	build_path = /obj/item/organ/external/foot/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/r_foot
	name = "Prosthetic Right Foot"
	build_path = /obj/item/organ/external/foot/right/ipc
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)

/datum/design/item/mechfab/prosthetic/groin_cap
	name = "Prosthetic Groin Cap"
	build_path = /obj/item/organ/external/groin/ipc/unbranded/cap
	use_direct_buildpath = TRUE
	materials = list(DEFAULT_WALL_MATERIAL = 25000)