/obj/item/clothing/mask/breath/infiltrator
	name = "infiltration balaclava"
	desc = "A close-fitting airtight balaclava that can be connected to an air supply."
	icon = 'icons/clothing/kit/infiltrator.dmi'
	icon_state = "mask"
	item_state = "mask"
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una", "taj")
	contained_sprite = TRUE
	adjustable = FALSE
	item_flags = THICKMATERIAL | INJECTIONPORT | AIRTIGHT
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/clothing/under/infiltrator
	name = "infiltration suit"
	desc = "A tight undersuit with thin pieces of armor bolted to it. It's airtight."
	icon = 'icons/clothing/kit/infiltrator.dmi'
	icon_state = "uniform"
	item_state = "uniform"
	contained_sprite = TRUE
	item_flags = THICKMATERIAL | INJECTIONPORT | AIRTIGHT
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL
	)
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/clothing/gloves/infiltrator
	name = "infiltration gloves"
	desc = "Tight insulated gloves with interwoven self-cleaning material. It's airtight."
	icon = 'icons/clothing/kit/infiltrator.dmi'
	icon_state = "gloves"
	item_state = "gloves"
	contained_sprite = TRUE
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	germ_level = 0
	fingerprint_chance = 0
	item_flags = THICKMATERIAL | INJECTIONPORT | AIRTIGHT
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	min_pressure_protection = 0
	species_restricted = null

/obj/item/clothing/shoes/infiltrator
	name = "infiltration shoes"
	desc = "Tight shoes with in-built Silent-Soles. It's airtight."
	icon = 'icons/clothing/kit/infiltrator.dmi'
	icon_state = "shoes"
	item_state = "shoes"
	contained_sprite = TRUE
	silent = TRUE
	item_flags = THICKMATERIAL | INJECTIONPORT | AIRTIGHT
	max_pressure_protection = SPACE_SUIT_MAX_PRESSURE
	min_pressure_protection = 0
	species_restricted = null

/obj/item/storage/toolbox/infiltration
	name = "infiltration case"
	desc = "A case with an ominous red \"S\" painted on it. It seems pretty hefty."
	icon = 'icons/clothing/kit/infiltrator.dmi'
	icon_state = "case"
	item_state = "case"
	contained_sprite = TRUE
	item_icons = null
	starts_with = list(
		/obj/item/clothing/mask/breath/infiltrator = 1,
		/obj/item/clothing/under/infiltrator = 1,
		/obj/item/clothing/gloves/infiltrator = 1,
		/obj/item/clothing/shoes/infiltrator = 1
	)