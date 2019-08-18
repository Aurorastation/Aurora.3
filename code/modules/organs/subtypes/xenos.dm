// Skeleton limbs.
/obj/item/organ/external/chest/skeleton
	name = "rib cage"

/obj/item/organ/external/groin/skeleton
	name = "pelvis"
	vital = 0

/obj/item/organ/external/arm/skeleton
	dislocated = -1

/obj/item/organ/external/arm/right/skeleton
	dislocated = -1

/obj/item/organ/external/leg/skeleton
	dislocated = -1

/obj/item/organ/external/leg/right/skeleton
	dislocated = -1

/obj/item/organ/external/foot/skeleton
	dislocated = -1

/obj/item/organ/external/foot/right/skeleton
	dislocated = -1

/obj/item/organ/external/hand/skeleton
	dislocated = -1

/obj/item/organ/external/hand/right/skeleton
	dislocated = -1

/obj/item/organ/external/head/skeleton
	name = "skull"
	dislocated = -1
	vital = 0

//vox organs

/obj/item/organ/heart/vox
	icon_state = "vox_heart"
	dead_icon = "vox_heart"

/obj/item/organ/lungs/vox
	name = "air capillary sack"
	icon_state = "vox_lung"

/obj/item/organ/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs"
	color = "#99ccff"
	parent_organ = "chest"

/obj/item/organ/liver/vox
	name = "waste tract"
	parent_organ = "chest"
	color = "#0033cc"
	tolerance = 20
