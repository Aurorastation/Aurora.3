/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = NOSLIP|LIGHTSTEP
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/clothing_choices = list()
	siemens_coefficient = 0.75
	species_restricted = null
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

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
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_MINOR
	)
	item_flags = NOSLIP
	siemens_coefficient = 0.5
	can_hold_knife = TRUE
	build_from_parts = TRUE

/obj/item/clothing/shoes/swat/ert
	species_restricted = null
	sprite_sheets = list("Tajara" = 'icons/mob/species/tajaran/shoes.dmi')

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon_state = "jungle"
	item_state = "jungle"
	force = 5
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_MINOR
	)
	item_flags = NOSLIP
	siemens_coefficient = 0.35
	can_hold_knife = TRUE
	build_from_parts = TRUE

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain wooden sandals."
	name = "sandals"
	icon_state = "sandals"
	species_restricted = null
	body_parts_covered = FALSE
	sprite_sheets = list("Tajara" = 'icons/mob/species/tajaran/shoes.dmi')

/obj/item/clothing/shoes/sandal/wooden
	desc = "A pair of rather plain wooden sandals."
	name = "wooden sandals"
	icon = 'icons/clothing/shoes/woodensandal.dmi'
	icon_state = "woodensandal"
	item_state = "woodensandal"
	contained_sprite = TRUE

/obj/item/clothing/shoes/sandal/flipflop
	name = "flip flops"
	desc = "A pair of foam flip flops. For those not afraid to show a little ankle."
	icon_state = "thongsandal"
	item_state = "thongsandal"
	sprite_sheets = list("Tajara" = 'icons/mob/species/tajaran/shoes.dmi')

obj/item/clothing/shoes/sandal/clogs
	name = "plastic clogs"
	desc = "A pair of plastic clog shoes."
	icon_state = "clogs"
	item_state = "clogs"
	sprite_sheets = list("Tajara" = 'icons/mob/species/tajaran/shoes.dmi')

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
	w_class = ITEMSIZE_SMALL
	silent = 1
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	force = 0
	w_class = ITEMSIZE_SMALL
	silent = 1

/obj/item/clothing/shoes/laceup
	name = "black oxford shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "oxford_black"
	item_state = "oxford_black"

/obj/item/clothing/shoes/laceup/all_species
	species_restricted = null

/obj/item/clothing/shoes/laceup/grey
	name = "grey oxford shoes"
	icon_state = "oxford_grey"
	item_state = "oxford_grey"

/obj/item/clothing/shoes/laceup/brown
	name = "brown oxford shoes"
	icon_state = "oxford_brown"
	item_state = "oxford_brown"

/obj/item/clothing/shoes/laceup/brown/all_species
	species_restricted = null

/obj/item/clothing/shoes/laceup/colourable
	name = "oxford shoes"
	icon_state = "oxford_colour"
	item_state = "oxford_colour"

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
	w_class = ITEMSIZE_SMALL
	species_restricted = null
	silent = 1
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	move_trail = null

/obj/item/clothing/shoes/cowboy
	name = "cowboy boots"
	desc = "Lacking a durasteel horse to ride."
	icon_state = "cowboy"
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

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
	if((target_zone != BP_EYES && target_zone != BP_HEAD) || M.eyes_protected(src, FALSE))
		return ..()
	if((user.is_clumsy()) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/clothing/shoes/heels/handle_movement(var/turf/walking, var/running)
	trip_up(walking, running)

/obj/item/clothing/shoes/winter
	name = "winter boots"
	desc = "A pair of heavy winter boots made out of animal furs, reaching up to the knee."
	icon_state = "winterboots"
	item_state = "winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
			melee = ARMOR_MELEE_MINOR,
			bio = ARMOR_BIO_MINOR
			)
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi'
	)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE

/obj/item/clothing/shoes/winter/toeless
	name = "toe-less winter boots"
	desc = "A pair of toe-less heavy winter boots made out of animal furs, reaching up to the knee.  Modified for species whose toes have claws."
	icon_state = "winterboots_toeless"
	item_state = "winterboots_toeless"
	species_restricted = null
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/shoes.dmi')

/obj/item/clothing/shoes/caligae
	name = "caligae"
	desc = "The standard Unathi marching footwear. Made of leather and rubber, with heavy hob-nailed soles, their unique design allows for improved traction and protection, leading to them catching on with other species."
	desc_fluff = "These traditional Unathi footwear have remained relatively unchanged in principle, with improved materials and construction being the only notable change. Originally used for warriors, they became widespread for their comfort and durability. Some are worn with socks, for warmth. Although made for the Unathi anatomy, they have picked up popularity among other species."
	icon_state = "caligae"
	item_state = "caligae"
	force = 5
	armor = list(
			melee = ARMOR_MELEE_MINOR
			)
	body_parts_covered = FEET|LEGS
	species_restricted = null
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/shoes.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/shoes.dmi')

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
	desc_fluff = "These traditional Unathi footwear have remained relatively unchanged in principle, with improved materials and construction being the only notable change. This pair is reinforced with leather of the Zazehal, a Moghesian species of eel that can grow up to twenty five feet long. Typically, Zazehal Festivals are thrown every month of the warm season in which Unathi strew freshly killed birds across the shoreline and collect these creatures with baskets. The fungi that grow on their skin is harvested and used as an exotic seasoning, and their skin is used for its' incredibly durable, shark-like leather."
	icon_state = "eelcaligae"
	armor = list(
		melee = ARMOR_MELEE_KNIVES
	)
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
	sprite_sheets = list("Tajara" = 'icons/mob/species/tajaran/shoes.dmi')

/obj/item/clothing/shoes/iac
	name = "IAC shoes"
	desc = "A pair of light blue and white shoes resistant to biological and chemical hazards."
	icon_state = "surgeon"
	item_state = "blue"
	permeability_coefficient = 0.01
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)
