/obj/item/clothing/gloves/yellow
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "yellow"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/clothing/gloves/fyellow                             //Cheap Chinese Crap
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	name = "budget insulated gloves"
	icon_state = "yellow"
	item_state = "yellow"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05
	drop_sound = 'sound/items/drop/rubber.ogg'

	New()
		//average of 0.5, somewhat better than regular gloves' 0.75
		siemens_coefficient = pick(0,0.1,0.3,0.5,0.5,0.75,1.35)

/obj/item/clothing/gloves/black
	desc = "These work gloves are thick and fire-resistant."
	name = "black gloves"
	icon_state = "black"
	item_state = "black"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/orange
	name = "orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"
	item_state = "orange"

/obj/item/clothing/gloves/red
	name = "red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"
	item_state = "red"

/obj/item/clothing/gloves/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	item_state = "rainbow"

/obj/item/clothing/gloves/blue
	name = "blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"
	item_state = "blue"

/obj/item/clothing/gloves/purple
	name = "purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"
	item_state = "purple"

/obj/item/clothing/gloves/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"
	item_state = "green"

/obj/item/clothing/gloves/grey
	name = "grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"
	item_state = "gray"

/obj/item/clothing/gloves/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"
	item_state = "lightbrown"

/obj/item/clothing/gloves/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"
	item_state = "brown"

/obj/item/clothing/gloves/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "latex"
	item_state = "latex"

/obj/item/clothing/gloves/yellow/specialu
	desc = "These gloves will protect the wearer from electric shock. Made special for Unathi use."
	name = "unathi electrical gloves"
	icon_state = "yellow"
	item_state = "yellow"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	species_restricted = list("Unathi")

/obj/item/clothing/gloves/black/unathi
	name = "black gloves"
	desc = "Black gloves made for Unathi use."
	species_restricted = list("Unathi")

//more snowflake gloves for the custom loadout

/obj/item/clothing/gloves/red/unathi
 	name = "red gloves"
 	desc = "Red gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/blue/unathi
 	name = "blue gloves"
 	desc = "Blue gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/orange/unathi
 	name = "orange gloves"
 	desc = "Orange gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/purple/unathi
 	name = "purple gloves"
 	desc = "Purple gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/brown/unathi
 	name = "brown gloves"
 	desc = "Brown gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/green/unathi
 	name = "green gloves"
 	desc = "Green gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/white/unathi
 	name = "white gloves"
 	desc = "White gloves made for Unathi use."
 	species_restricted = list("Unathi")

/obj/item/clothing/gloves/evening
	name = "evening gloves"
	desc = "A pair of gloves that reach past the elbow."
	icon_state = "evening_gloves"

/obj/item/clothing/gloves/black_leather
	name = "black leather gloves"
	desc = "A pair of tight-fitting synthleather gloves."
	icon_state = "black_leather"
	item_state = "black_leather"

/obj/item/clothing/gloves/fingerless
	desc = "A pair of gloves that don't actually cover the fingers."
	name = "fingerless gloves"
	icon_state = "fingerlessgloves"
	item_state = "fingerlessgloves"
	fingerprint_chance = 100
	clipped = 1
	species_restricted = list("exclude","Golem","Vaurca Breeder","Vaurca Warform")