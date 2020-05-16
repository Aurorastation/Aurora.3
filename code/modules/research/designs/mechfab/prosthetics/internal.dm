/datum/design/item/mechfab/prosthetic/internal
	category = "Prosthetic (Internal)"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 9000, MATERIAL_GLASS = 3000)

//make sure the printed organ is actually robotic
/datum/design/item/mechfab/prosthetic/internal/Fabricate()
	var/obj/item/organ/O = ..()
	O.robotize()
	return O

/datum/design/item/mechfab/prosthetic/internal/heart
	name = "Prosthetic Heart"
	build_path = /obj/item/organ/internal/heart

/datum/design/item/mechfab/prosthetic/internal/lungs
	name = "Prosthetic Lungs"
	build_path = /obj/item/organ/internal/lungs

/datum/design/item/mechfab/prosthetic/internal/kidneys
	name = "Prosthetic Kidneys"
	build_path = /obj/item/organ/internal/kidneys

/datum/design/item/mechfab/prosthetic/internal/eyes
	name = "Prosthetic Eyes"
	build_path = /obj/item/organ/internal/eyes

/datum/design/item/mechfab/prosthetic/internal/liver
	name = "Prosthetic Liver"
	build_path = /obj/item/organ/internal/liver

/datum/design/item/mechfab/prosthetic/internal/stomach
	name = "Prosthetic Stomach"
	build_path = /obj/item/organ/internal/stomach