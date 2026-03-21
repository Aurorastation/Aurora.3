/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon = 'icons/obj/item/clothing/shoes/slippers.dmi'
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	contained_sprite = TRUE
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)
	silent = TRUE
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una")

/obj/item/clothing/shoes/slippers/worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"

/obj/item/clothing/shoes/slippers/carp
	name = "carp slippers"
	desc = "Slippers made to look like baby carp, but on your feet! Squeeeeeee!!"
	item_state = "carpslippers"
	icon_state = "carpslippers"

/obj/item/clothing/shoes/slippers/recolourable_slippers
	desc = "A pair of simple slippers, in a variety of colours."
	name = "slippers"
	icon_state = "colourslippers"
	item_state = "colourslippers"

/obj/item/clothing/shoes/slippers/scc_slippers
	desc = "A pair of simple slippers, branded with the unmistakable logo of the Stellar Corporate Conglomerate. A small logo on the inside indicates it is a pair of Nyx-brand slippers, produced by Idris Incorporated for Stellar Corporate Conglomerate vessels."
	name = "\improper SCC Slippers"
	icon_state = "sccslippers"
	item_state = "sccslippers"
