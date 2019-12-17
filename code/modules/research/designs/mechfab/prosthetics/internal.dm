/datum/design/item/mechfab/prosthetic/internal
	category = "Prosthetic (Internal)"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 9000, "glass" = 3000)

//make sure the printed organ is actually robotic
/datum/design/item/mechfab/prosthetic/internal/Fabricate()
	var/obj/item/organ/O = ..()
	O.robotize()
	return O

/datum/design/item/mechfab/prosthetic/internal/heart
	name = "Prosthetic Heart"
	id = "robotic_heart"
	build_path = /obj/item/organ/internal/heart

/datum/design/item/mechfab/prosthetic/internal/lungs
	name = "Prosthetic Lungs"
	id = "robotic_lungs"
	build_path = /obj/item/organ/internal/lungs

/datum/design/item/mechfab/prosthetic/internal/kidneys
	name = "Prosthetic Kidneys"
	id = "robotic_kidneys"
	build_path = /obj/item/organ/internal/kidneys

/datum/design/item/mechfab/prosthetic/internal/eyes
	name = "Prosthetic Eyes"
	id = "robotic_eyes"
	build_path = /obj/item/organ/internal/eyes

/datum/design/item/mechfab/prosthetic/internal/liver
	name = "Prosthetic Liver"
	id = "robotic_liver"
	build_path = /obj/item/organ/internal/liver