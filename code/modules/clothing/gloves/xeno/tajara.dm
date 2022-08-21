/obj/item/clothing/gloves/yellow/specialt
	name = "tajaran electrical gloves"
	desc = "These gloves will protect the wearer from electric shock. Made specially for use by Tajara."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/black/tajara
	desc = "Black gloves made for Tajara use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/red/tajara
	desc = "Red gloves made for Tajaran use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/blue/tajara
 	desc = "Blue gloves made for Tajaran use."
 	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/orange/tajara
 	desc = "Orange gloves made for Tajaran use."
 	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/purple/tajara
 	desc = "Purple gloves made for Tajaran use."
 	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/brown/tajara
 	desc = "Brown gloves made for Tajaran use."
 	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/light_brown/tajara
	desc = "Light brown gloves made for Tajaran use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/green/tajara
 	desc = "Green gloves made for Tajaran use."
 	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/grey/tajara
	desc = "Grey gloves made for Tajaran use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/white/tajara
 	desc = "White gloves made for Tajaran use."
 	species_restricted = list (BODYTYPE_TAJARA)

/obj/item/clothing/gloves/rainbow/tajara
	desc = "Rainbow gloves made for Tajaran use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/black_leather/tajara
	desc = "Black leather gloves made for Tajaran use."
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/gloves/black/tajara/smithgloves
	name = "machinist gloves"
	desc = "Protective leather gloves worn by Adhomian urban workers."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "smithgloves"
	item_state = "smithgloves"
	contained_sprite = TRUE
	desc_fluff = "The quality of life for an urban dweller in Nal'tor, or any other major city, can vary considerably according to the Tajara's occupation, education and standing \
	with the Party. The average worker that labours in the industrial suburbs, can expect an honest living to be made, and a modest lifestyle to be led. The majority of the city labourers \
	work in government run factories and spaceports, with stable but strict work hours and schedule the Hadii regime boasts of its fairness to the worker."

/obj/item/clothing/gloves/tajaran_gauntlets
	name = "adhomian gauntlets"
	desc = "A pair of armored gauntlets made for Tajaran use."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "armored_arms"
	item_state = "armored_arms"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)
	body_parts_covered = ARMS|HANDS

	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

	punch_force = 5
	clipped = TRUE

	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'