/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = NOSLIP
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	species_restricted = null

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.5
	can_hold_knife = 1

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "jungle"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.5
	can_hold_knife = 1

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	body_parts_covered = FEET

/obj/item/clothing/shoes/sandal/flipflop
	name = "flip flops"
	desc = "A pair of foam flip flops. For those not afraid to show a little ankle."
	icon_state = "thongsandal"

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	var/footstep = 1	//used for squeeks whilst walking
	species_restricted = null

/obj/item/clothing/shoes/clown_shoes/handle_movement(var/turf/walking, var/running)
	if(running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
		else
			footstep++
	else
		playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/cult
	name = "ragged boots"
	desc = "A ragged, dusty pair of boots."
	icon_state = "cult"
	item_state = "cult"
	force = 5
	siemens_coefficient = 0
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 10, rad = 0)

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cult/cultify()
	return

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	species_restricted = null
	w_class = 2

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	force = 0
	w_class = 2

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1

/obj/item/clothing/shoes/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping clawed feet."
	icon_state = "clothwrap"
	item_state = "clothwrap"
	w_class = 2
	species_restricted = null

/obj/item/clothing/shoes/winter
	name = "winter boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/cowboy
	name = "cowboy boots"
	desc = "Lacking a durasteel horse to ride."
	icon_state = "cowboy"

/obj/item/clothing/shoes/cowboy/classic
	name = "classic cowboy boots"
	desc = "A classic looking pair of durable cowboy boots."
	icon_state = "cowboy_classic"

/obj/item/clothing/shoes/cowboy/snakeskin
	name = "snakeskin cowboy boots"
	desc = "A pair of cowboy boots made from python skin."
	icon_state = "cowboy_snakeskin"

/obj/item/clothing/shoes/heels
	name = "high heels"
	desc = "A pair of high-heeled shoes. Fancy!"
	icon_state = "heels"