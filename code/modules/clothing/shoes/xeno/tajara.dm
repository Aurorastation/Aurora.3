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
	desc_extended = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters can't stand against how undeniably effective and cheap \
	to produce Human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

// Flats.
// since everything except the onmob is a carbon copy, we just add another onmob sprite with the proper suffix and the species restriction to avoid bloat

/obj/item/clothing/shoes/flats/tajara
	desc = "A pair of black women's flats. Refitted for Tajara."
	name = "black dress flats"
	icon_state = "blackdf"
	item_state = "blackdf"
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/shoes/flats/tajara/red
	desc = "A pair of red women's flats. Refitted for Tajara."
	name = "red dress flats"
	icon_state = "reddf"
	item_state = "reddf"

/obj/item/clothing/shoes/flats/tajara/blue
	desc = "A pair of blue women's flats. Refitted for Tajara."
	name = "blue dress flats"
	icon_state = "bluedf"
	item_state = "bluedf"

/obj/item/clothing/shoes/flats/tajara/green
	desc = "A pair of green women's flats. Refitted for Tajara."
	name = "green dress flats"
	icon_state = "greendf"
	item_state = "greendf"

/obj/item/clothing/shoes/flats/tajara/purple
	desc = "A pair of purple  women's flats. Refitted for Tajara."
	name = "purple dress flats"
	icon_state = "purpledf"
	item_state = "purpledf"

/obj/item/clothing/shoes/flats/tajara/white
	desc = "A pair of white women's flats. Refitted for Tajara."
	name = "white dress flats"
	icon_state = "whitedf"
	item_state = "whitedf"

// these look completely different and should be called something else

/obj/item/clothing/shoes/flats/tajara/scarlet
	name = "scarlet dress flats"
	desc = "A pair of scarlet women's flats, made specifically for tajara."
	icon_state = "flats_scarlet"
	item_state = "flats_scarlet"
	icon_supported_species_tags = list("taj")

/obj/item/clothing/shoes/flats/tajara/mauve
	name = "mauve dress flats"
	desc = "A pair of mauve women's flats, made specifically for tajara."
	icon_state = "flats_mauve"
	item_state = "flats_mauve"
	icon_supported_species_tags = list("taj")

/obj/item/clothing/shoes/flats/tajara/dark
	name = "dark dress flats"
	desc = "A pair of dark women's flats, made specifically for tajara."
	icon_state = "flats_dark"
	item_state = "flats_dark"
	icon_supported_species_tags = list("taj")

// Jackboots

/obj/item/clothing/shoes/jackboots/tajara // Because yes, Tajara don't leave their toes out all the time.
	name = "jackboots"
	desc = "Tall synthleather boots with an artificial shine. Fitted for Tajara."
	icon_supported_species_tags = list("taj")
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/shoes/jackboots/tajara/cavalry
	name = "cavalry jackboots"
	desc = "Calf-length cavalry synthleather boots, Fitted for Tajara."
	icon_state = "cavalryboots"
	item_state = "cavalryboots"

/obj/item/clothing/shoes/jackboots/tajara/riding
	name = "riding jackboots"
	desc = "Knee-high riding synthleather boots with an artificial shine. Fitted for Tajara"
	icon_state = "ridingboots"
	item_state = "ridingboots"

/obj/item/clothing/shoes/workboots/tajara
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/shoes/workboots/tajara/brown
	name = "brown workboots"
	desc = "A pair of brown steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	icon_state = "workboots_brown"
	item_state = "workboots_brown"

/obj/item/clothing/shoes/workboots/tajara/grey
	name = "grey workboots"
	desc = "A pair of grey steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	icon_state = "workboots_grey"
	item_state = "workboots_grey"

/obj/item/clothing/shoes/workboots/tajara/dark
	name = "dark workboots"
	desc = "A pair of dark steel-toed work boots designed for use in industrial settings. Safety first. Fitted for Tajara."
	icon_state = "workboots_dark"
	item_state = "workboots_dark"

/obj/item/clothing/shoes/winter/tajara
	name = "tajaran winter boots"
	desc = "A pair of heavy winter boots made out of animal furs, reaching up to the knee. Fitted for Tajara."
	icon_state = "winterboots"
	item_state = "winterboots"
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	name = "adhomian boots"
	icon = 'icons/obj/tajara_items.dmi'
	desc = "A pair of Tajaran boots designed for the rough terrain of Adhomai."
	icon_state = "adhomian_boots"
	item_state = "adhomian_boots"
	icon_supported_species_tags = null
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
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_MINOR
	)

// High-heeled Adhomian Shoes
/obj/item/clothing/shoes/heels/tajara
	name = "black high-heeled adhomian shoes"
	desc = "A pair of black heels adapted specifically for tajara anatomy, in the latest style."
	icon_state = "heels_black"
	item_state = "heels_black"
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/shoes/heels/tajara/red
	name = "red high-heeled adhomian shoes"
	desc = "A pair of red heels adapted specifically for tajara anatomy, in the latest style."
	icon_state = "heels_red"
	item_state = "heels_red"

/obj/item/clothing/shoes/sneakers/black/tajara
	name = "black saddle shoes"
	desc = "A pair of black, well-cared for saddle shoes, made for tajara anatomy. Nifty!"
	species_restricted = list(BODYTYPE_TAJARA)
	icon_supported_species_tags = list("taj")

// Adhomian Loafers
// again, completely identical to regular laceups except by onmob, name and equipability. is this bloat? yes. do i have the discretion to change this? no.
/obj/item/clothing/shoes/laceup/tajara
	name = "black adhomian oxfords"
	desc = "A pair of black men's oxfords, made specifically for tajara anatomy. Pipe and robe not included."
	species_restricted = list(BODYTYPE_TAJARA)
	icon_supported_species_tags = list("taj")

/obj/item/clothing/shoes/laceup/brown/tajara
	name = "brown adhomian oxfords"
	desc = "A pair of brown men's loafers, made specifically for tajara anatomy. Pipe and robe not included."
	species_restricted = list(BODYTYPE_TAJARA)
	icon_supported_species_tags = list("taj")
