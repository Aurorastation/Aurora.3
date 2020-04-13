/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	body_parts_covered = FACE
	w_class = 2
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_item_flags = FLEXIBLEMATERIAL
	adjustable = TRUE

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01

/obj/item/clothing/mask/breath/offworlder
	name = "overmask"
	desc = "A large breath mask with cushioning."
	icon_state = "breathcover"
	item_state = "cloth"

/obj/item/clothing/mask/breath/offworlder/jagmask
	name = "jagmask"
	desc = "A two-piece, jagged filtering mask meant to conform to one's face comfortably."
	icon_state = "jagmask"
	item_state = "muzzle"

/obj/item/clothing/mask/breath/skrell
	name = "skrellian gill cover"
	desc = "A comfy technological piece used typically by those suffering from gill-related disorders. It goes around the neck and shoulders with a small water tank on the back, featuring a hookup for oxytanks to keep the water oxygenated."
	icon = 'icons/obj/skrell_items.dmi'
	icon_state = "gillcover"
	item_state = "gillcover"
	contained_sprite = TRUE
	species_restricted = list("Skrell")
	adjustable = FALSE