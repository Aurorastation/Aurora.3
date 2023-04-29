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

/obj/item/clothing/shoes/jackboots/tajara // Because yes, Tajara don't leave their toes out all the time.
	name = "jackboots"
	desc = "Tall synthleather boots with an artificial shine. Fitted for Tajara."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/shoes/jackboots/tajara/thigh
	name = "cavalry jackboots"
	desc = "Calf-length cavalry synthleather boots, Fitted for Tajara."
	icon_state = "cavalryboots"
	item_state = "cavalryboots"

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
