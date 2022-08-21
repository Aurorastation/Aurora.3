/obj/item/clothing/shoes/tajara/footwraps
	name = "native tajaran foot-wear"
	desc = "Native foot and leg wear worn by Tajara, completely covering the legs in wraps and the feet in adhomian fabric."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "adhomai_shoes"
	item_state = "adhomai_shoes"
	body_parts_covered = FEET|LEGS
	species_restricted = list(BODYTYPE_TAJARA)
	contained_sprite = TRUE
	move_trail = null
	desc_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters can't stand against how undeniably effective and cheap \
	to produce Human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

/obj/item/clothing/shoes/flats/tajara
	desc = "A pair of black women's flats. Refitted for Tajara."
	name = "black dress flats"
	icon = 'icons/mob/species/tajaran/shoes.dmi'
	icon_state = "tblackdf"
	item_state = "tblackdf"
	body_parts_covered = FEET
	species_restricted = list(BODYTYPE_TAJARA)
	contained_sprite = TRUE

/obj/item/clothing/shoes/flats/tajara/red
	desc = "A pair of red women's flats. Refitted for Tajara."
	name = "red dress flats"
	icon = 'icons/mob/species/tajaran/shoes.dmi'
	icon_state = "treddf"
	item_state = "treddf"

/obj/item/clothing/shoes/flats/tajara/blue
	desc = "A pair of blue women's flats. Refitted for Tajara."
	name = "blue dress flats"
	icon_state = "tbluedf"
	item_state = "tbluedf"

/obj/item/clothing/shoes/flats/tajara/green
	desc = "A pair of green women's flats. Refitted for Tajara."
	name = "green dress flats"
	icon_state = "tgreendf"
	item_state = "tgreendf"

/obj/item/clothing/shoes/flats/tajara/purple
	desc = "A pair of purple  women's flats. Refitted for Tajara."
	name = "purple dress flats"
	icon_state = "tpurpledf"
	item_state = "tpurpledf"

/obj/item/clothing/shoes/flats/tajara/white
	desc = "A pair of white women's flats. Refitted for Tajara."
	name = "white dress flats"
	icon_state = "twhitedf"
	item_state = "twhitedf"

/obj/item/clothing/shoes/tajara/jackboots // Because yes, Tajara don't leave their toes out all the time.
	name = "jackboots"
	desc = "Tall synthleather boots with an artificial shine. Fitted for Tajara."
	icon = 'icons/mob/species/tajaran/shoes.dmi'
	icon_state = "taj_jackboots"
	item_state = "taj_jackboots"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_KNIVES
	)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	species_restricted = list(BODYTYPE_TAJARA)
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/jackboots/cavalry
	name = "cavalry boots"
	desc = "Good old-fashioned calf-length cavalry boots. Adhomai doesn't have horses, but one can appreciate a good, tall boot."
	icon_state = "taj_cavalryboots"
	item_state = "taj_cavalryboots"

/obj/item/clothing/shoes/tajara/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	icon = 'icons/mob/species/tajaran/shoes.dmi'
	icon_state = "taj_workboots"
	item_state = "taj_workboots"
	force = 3
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	build_from_parts = TRUE
	species_restricted = list(BODYTYPE_TAJARA)
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/workboots/grey
	name = "grey workboots"
	desc = "A pair of grey steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	icon_state = "taj_workboots_grey"
	item_state = "taj_workboots_grey"

/obj/item/clothing/shoes/tajara/workboots/dark
	name = "dark workboots"
	desc = "A pair of dark steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	icon_state = "taj_workboots_dark"
	item_state = "taj_workboots_dark"

/obj/item/clothing/shoes/tajara/combat
	name = "tajaran combat boots"
	desc = "When you REALLY want to turn up the heat."
	icon = 'icons/mob/species/tajaran/shoes.dmi'
	icon_state = "taj_jungle"
	item_state = "taj_jungle"
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
	species_restricted = list(BODYTYPE_TAJARA)
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/winter
	name = "tajaran winter boots"
	desc = "A pair of heavy winter boots made out of animal furs, reaching up to the knee. Fitted for Tajara."
	icon = 'icons/mob/species/tajaran/shoes.dmi'
	icon_state = "taj_winterboots"
	item_state = "taj_winterboots"
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
			melee = ARMOR_MELEE_MINOR,
			bio = ARMOR_BIO_MINOR
			)
	siemens_coefficient = 0.75
	can_hold_knife = TRUE
	species_restricted = list(BODYTYPE_TAJARA)
	build_from_parts = TRUE
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/workboots/adhomian_boots
	name = "adhomian boots"
	icon = 'icons/obj/tajara_items.dmi'
	desc = "A pair of Tajaran boots designed for the rough terrain of Adhomai."
	icon_state = "adhomian_boots"
	item_state = "adhomian_boots"
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/fancy
	name = "fancy adhomian shoes"
	desc = "A pair of fancy Tajaran shoes used for formal occasions."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "fancy_shoes"
	item_state = "fancy_shoes"
	body_parts_covered = FEET
	species_restricted = list(BODYTYPE_TAJARA)
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara/armored
	name = "adhomian armored boots"
	icon = 'icons/obj/tajara_items.dmi'
	desc = "A pair of armored adhomian boots."
	icon_state = "armored_legs"
	item_state = "armored_legs"
	contained_sprite = TRUE

	body_parts_covered = FEET|LEGS
	species_restricted = list(BODYTYPE_TAJARA)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)