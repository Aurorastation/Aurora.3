/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "jackboots"
	item_state = "jackboots"

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon = 'icons/obj/item/clothing/shoes/miscellaneous.dmi'
	contained_sprite = TRUE
	icon_state = "flippers"
	item_state = "flippers"
	item_flags = NOSLIP
	slowdown = 1

/obj/item/clothing/shoes/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated cloth used for wrapping clawed feet."
	icon = 'icons/obj/item/clothing/shoes/miscellaneous.dmi'
	icon_state = "clothwrap"
	item_state = "clothwrap"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	species_restricted = null
	icon_auto_adapt = TRUE
	silent = 1
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	move_trail = null
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi' //depreceated, only used for bulwarks due to their size
	)


/obj/item/clothing/shoes/heels
	name = "high heels"
	desc = "A pair of high-heeled shoes. Fancy!"
	icon = 'icons/obj/item/clothing/shoes/miscellaneous.dmi'
	contained_sprite = TRUE
	icon_state = "heels"
	item_state = "heels"
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

/obj/item/clothing/shoes/galoshes
	name = "galoshes"
	desc = "A waterproof overshoe, made of rubber."
	icon = 'icons/obj/item/clothing/shoes/miscellaneous.dmi'
	contained_sprite = TRUE
	icon_state = "galoshes"
	item_state = "galoshes"
	permeability_coefficient = 0.05
	item_flags = NOSLIP
	slowdown = 1
	species_restricted = null
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("taj")
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi' //depreceated, only used for bulwarks due to their size
	)


/obj/item/clothing/shoes/galoshes/syndie
	name = "brown shoes"
	desc = "A pair of brown shoes. They seem to have extra grip."
	icon = 'icons/obj/item/clothing/shoes/sneakers.dmi'
	icon_state = "brown"
	item_state = "brown"
	contained_sprite = TRUE
	item_flags = NOSLIP|LIGHTSTEP
	slowdown = 0
	origin_tech = list(TECH_ILLEGAL = 3)
	icon_auto_adapt = FALSE
	icon_supported_species_tags = null
	var/list/clothing_choices = list()
	siemens_coefficient = 0.75
