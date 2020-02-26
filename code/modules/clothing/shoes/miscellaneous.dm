/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = NOSLIP
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.75
	species_restricted = null
	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "white"
	item_state = "white"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	item_state = "swat"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.5
	can_hold_knife = 1

/obj/item/clothing/shoes/swat/ert
	species_restricted = null

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "jungle"
	item_state = "jungle"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.35
	can_hold_knife = 1

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "sandals"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	item_state = "black"
	body_parts_covered = FEET

/obj/item/clothing/shoes/sandal/flipflop
	name = "flip flops"
	desc = "A pair of foam flip flops. For those not afraid to show a little ankle."
	icon_state = "thongsandal"
	item_state = "thongsandal"

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = 1
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
	silent = 1
	siemens_coefficient = 0.35 //antags don't get exceptions, it's just heavy armor by magical standards
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
	icon_state = "jackboots"
	item_state = "jackboots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	species_restricted = null
	w_class = 2
	silent = 1
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	force = 0
	w_class = 2
	silent = 1

/obj/item/clothing/shoes/laceup
	name = "black oxford shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "oxford_black"
	item_state = "oxford_black"

/obj/item/clothing/shoes/laceup/grey
	name = "grey oxford shoes"
	icon_state = "oxford_grey"
	item_state = "oxford_grey"

/obj/item/clothing/shoes/laceup/brown
	name = "brown oxford shoes"
	icon_state = "oxford_brown"
	item_state = "oxford_brown"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_state = "flippers"
	item_flags = NOSLIP
	slowdown = 1

/obj/item/clothing/shoes/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated cloth used for wrapping clawed feet."
	icon_state = "clothwrap"
	item_state = "white"
	w_class = 2
	species_restricted = null
	silent = 1
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/clothing/shoes/cowboy
	name = "cowboy boots"
	desc = "Lacking a durasteel horse to ride."
	icon_state = "cowboy"
	drop_sound = 'sound/items/drop/leather.ogg'

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
	item_state = "thongsandal"
	slowdown = 0
	force = 2
	sharp = TRUE

/obj/item/clothing/shoes/heels/attack(mob/living/carbon/M, mob/living/carbon/user, var/target_zone)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(target_zone != BP_EYES && target_zone != BP_HEAD)
		return ..()
	if((user.is_clumsy()) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/clothing/shoes/winter
	name = "winter boots"
	desc = "A pair of heavy winter boots made out of animal furs, reaching up to the knee."
	icon_state = "winterboots"
	item_state = "winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)
	siemens_coefficient = 0.75
	can_hold_knife = 1

/obj/item/clothing/shoes/winter/toeless
	name = "toe-less winter boots"
	desc = "A pair of toe-less heavy winter boots made out of animal furs, reaching up to the knee.  Modified for species whose toes have claws."
	icon_state = "winterboots_toeless"

/obj/item/clothing/shoes/black_boots
	name = "black boots"
	desc = "A pair of tough looking black boots."
	icon_state = "jackboots"
	item_state = "jackboots"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	can_hold_knife = 1

/obj/item/clothing/shoes/caligae
	name = "caligae"
	desc = "The standard Unathi marching footwear. Made of leather and rubber, with heavy hob-nailed soles, their unique design allows for improved traction and protection, leading to them catching on with other species."
	description_fluff = "These traditional Unathi footwear have remained relatively unchanged in principle, with improved materials and construction being the only notable change. Originally used for warriors, they became widespread for their comfort and durability. Some are worn with socks, for warmth. Although made for the Unathi anatomy, they have picked up popularity among other species."
	icon_state = "caligae"
	item_state = "caligae"
	force = 5
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = FEET|LEGS
	species_restricted = null
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/shoes.dmi',
		"Unathi" = 'icons/mob/species/unathi/shoes.dmi')

/obj/item/clothing/shoes/caligae/white
	name = "white caligae"
	desc = "The standard Unathi marching footwear. Made of leather and rubber, with heavy hob-nailed soles, their unique design allows for improved traction and protection. This one has white socks."
	icon_state = "whitecaligae"

/obj/item/clothing/shoes/caligae/grey
	name = "grey caligae"
	desc = "The standard Unathi marching footwear. Made of leather and rubber, with heavy hob-nailed soles, their unique design allows for improved traction and protection. This one has grey socks."
	icon_state = "greycaligae"

/obj/item/clothing/shoes/caligae/black
	name = "black caligae"
	desc = "The standard Unathi marching footwear. Made of leather and rubber, with heavy hob-nailed soles, their unique design allows for improved traction and protection. This one has black socks."
	icon_state = "blackcaligae"

/obj/item/clothing/shoes/caligae/armor
	name = "leather caligae"
	desc = "The standard Unathi marching footwear. These are made for heavier conditions, featuring tough and waterproof eel-leather covering, offering far greater protection."
	description_fluff = "These traditional Unathi footwear have remained relatively unchanged in principle, with improved materials and construction being the only notable change. This pair is reinforced with leather of the Zazehal, a Moghesian species of eel that can grow up to twenty five feet long. Typically, Zazehal Festivals are thrown every month of the warm season in which Unathi strew freshly killed birds across the shoreline and collect these creatures with baskets. The fungi that grow on their skin is harvested and used as an exotic seasoning, and their skin is used for its' incredibly durable, shark-like leather."
	icon_state = "eelcaligae"
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 15, bomb = 20, bio = 0, rad = 20)
	siemens_coefficient = 0.75

/obj/item/clothing/shoes/carp
	name = "carp slippers"
	desc = "Slippers made to look like baby carp, but on your feet! Squeeeeeee!!"
	item_state = "carpslippers"
	icon_state = "carpslippers"
	species_restricted = null
	silent = TRUE

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/iac
	name = "IAC shoes"
	desc = "A pair of light blue and white shoes resistant to biological and chemical hazards."
	icon_state = "surgeon"
	item_state = "blue"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 90, rad = 0)
