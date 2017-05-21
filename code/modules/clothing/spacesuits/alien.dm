//Skrell space gear. Sleek like a wetsuit.
/obj/item/clothing/head/helmet/space/skrell
	name = "skrellian helmet"
	desc = "Smoothly contoured and polished to a shine. Still looks like a fishbowl."
	armor = list(melee = 20, bullet = 20, laser = 50,energy = 50, bomb = 50, bio = 100, rad = 100)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Skrell","Human")
	siemens_coefficient = 0.4

/obj/item/clothing/head/helmet/space/skrell/white
	icon_state = "skrell_helmet_white"

/obj/item/clothing/head/helmet/space/skrell/black
	icon_state = "skrell_helmet_black"

/obj/item/clothing/suit/space/skrell
	name = "skrellian voidsuit"
	desc = "Seems like a wetsuit with reinforced plating seamlessly attached to it. Very chic."
	armor = list(melee = 20, bullet = 20, laser = 50,energy = 50, bomb = 50, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Skrell","Human")
	siemens_coefficient = 0.4

/obj/item/clothing/suit/space/skrell/white
	icon_state = "skrell_suit_white"
	item_state = "skrell_suit_white"

/obj/item/clothing/suit/space/skrell/black
	icon_state = "skrell_suit_black"
	item_state = "skrell_suit_black"

// Vox space gear (vaccuum suit, low pressure armour)
// Can't be equipped by any other species due to bone structure and vox cybernetics.
/obj/item/clothing/suit/space/vox
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank)
	slowdown = 2
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.3
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Vox", "Vox Armalis")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/suit.dmi',
		"Vox Armalis" = 'icons/mob/species/armalis/suit.dmi'
		)

/obj/item/clothing/head/helmet/space/vox
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.6
	item_flags = STOPPRESSUREDAMAGE
	flags_inv = null
	species_restricted = list("Vox","Vox Armalis")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/head.dmi',
		"Vox Armalis" = 'icons/mob/species/armalis/head.dmi'
		)

/obj/item/clothing/head/helmet/space/vox/pressure
	name = "alien helmet"
	icon_state = "vox-pressure"
	item_state = "vox-pressure"
	desc = "Hey, wasn't this a prop in \'The Abyss\'?"

/obj/item/clothing/suit/space/vox/pressure
	name = "alien pressure suit"
	icon_state = "vox-pressure"
	item_state = "vox-pressure"
	desc = "A huge, armoured, pressurized suit, designed for distinctly nonhuman proportions."

/obj/item/clothing/head/helmet/space/vox/carapace
	name = "alien visor"
	icon_state = "vox-carapace"
	item_state = "vox-carapace"
	desc = "A glowing visor, perhaps stolen from a depressed Cylon."

/obj/item/clothing/suit/space/vox/carapace
	name = "alien carapace armour"
	icon_state = "vox-carapace"
	item_state = "vox-carapace"
	desc = "An armoured, segmented carapace with glowing purple lights. It looks pretty run-down."

/obj/item/clothing/head/helmet/space/vox/stealth
	name = "alien stealth helmet"
	icon_state = "vox-stealth"
	item_state = "vox-stealth"
	desc = "A smoothly contoured, matte-black alien helmet."

/obj/item/clothing/suit/space/vox/stealth
	name = "alien stealth suit"
	icon_state = "vox-stealth"
	item_state = "vox-stealth"
	desc = "A sleek black suit. It seems to have a tail, and is very heavy."

/obj/item/clothing/head/helmet/space/vox/medic
	name = "alien goggled helmet"
	icon_state = "vox-medic"
	item_state = "vox-medic"
	desc = "An alien helmet with enormous goggled lenses."

/obj/item/clothing/suit/space/vox/medic
	name = "alien armour"
	icon_state = "vox-medic"
	item_state = "vox-medic"
	desc = "An almost organic looking nonhuman pressure suit."

/obj/item/clothing/under/vox
	has_sensor = 0
	species_restricted = list("Vox")

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon_state = "vox-casual-1"
	item_state = "vox-casual-1"
	body_parts_covered = LEGS

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon_state = "vox-casual-2"
	item_state = "vox-casual-2"

/obj/item/clothing/gloves/yellow/vox
	desc = "These bizarre gauntlets seem to be fitted for... bird claws?"
	name = "insulated gauntlets"
	icon_state = "gloves-vox"
	item_state = "gloves-vox"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	species_restricted = list("Vox","Vox Armalis")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/gloves.dmi',
		"Vox Armalis" = 'icons/mob/species/armalis/gloves.dmi'
		)

/obj/item/clothing/shoes/magboots/vox

	desc = "A pair of heavy, jagged armoured foot pieces, seemingly suitable for a velociraptor."
	name = "vox magclaws"
	item_state = "boots-vox"
	icon_state = "boots-vox"

	species_restricted = list("Vox","Vox Armalis")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/shoes.dmi',
		"Vox Armalis" = 'icons/mob/species/armalis/feet.dmi'
		)

	action_button_name = "Toggle the magclaws"

/obj/item/clothing/shoes/magboots/vox/attack_self(mob/user)
	if(src.magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		canremove = 1
		user << "You relax your deathgrip on the flooring."
	else
		//make sure these can only be used when equipped.
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/H = user
		if (H.shoes != src)
			user << "You will have to put on the [src] before you can do that."
			return

		item_flags |= NOSLIP
		magpulse = 1
		canremove = 0	//kinda hard to take off magclaws when you are gripping them tightly.
		user << "You dig your claws deeply into the flooring, bracing yourself."
		user << "It would be hard to take off the [src] without relaxing your grip first."
	user.update_action_buttons()

//In case they somehow come off while enabled.
/obj/item/clothing/shoes/magboots/vox/dropped(mob/user as mob)
	..()
	if(src.magpulse)
		user.visible_message("The [src] go limp as they are removed from [usr]'s feet.", "The [src] go limp as they are removed from your feet.")
		item_flags &= ~NOSLIP
		magpulse = 0
		canremove = 1

/obj/item/clothing/shoes/magboots/vox/examine(mob/user)
	..(user)
	if (magpulse)
		user << "It would be hard to take these off without relaxing your grip first." //theoretically this message should only be seen by the wearer when the claws are equipped.

// Type C Spacesuit (vaccuum suit, low pressure armour)
// Can't be equipped by any other species.

/obj/item/clothing/suit/space/typec
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	name = "carapace plating"
	desc = "Form fitting and tight...but definitely not for a human form!"
	w_class = 5.0
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank)
	slowdown = 2
	armor = list(melee = 90, bullet = 80, laser = 75,energy = 60, bomb = 60, bio = 60, rad = 60)
	siemens_coefficient = 0
	item_state = "carapace_body"
	icon_state = "carapace_body"
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list(
		"Vaurca Breeder" = 'icons/mob/species/breeder/suit.dmi'
		)
/obj/item/clothing/head/helmet/space/typec
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	name = "cranial carapace plating"
	desc = "An intimidating alien helmet that fits over the head."
	w_class = 5.0
	armor = list(melee = 80, bullet = 80, laser = 60, energy = 60, bomb = 60, bio = 60, rad = 60)
	siemens_coefficient = 0
	item_state = "carapace_head"
	icon_state = "carapace_head"
	flags = STOPPRESSUREDAMAGE
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list(
		"Vaurca Breeder" = 'icons/mob/species/breeder/head.dmi'
		)

/obj/item/clothing/shoes/magboots/typec

	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	desc = "A set of several heavy magboots, fitted for long, thick legs."
	name = "carapace magclaws"
	w_class = 5.0
	armor = list(melee = 60, bullet = 60, laser = 30, energy = 30, bomb = 30, bio = 30, rad = 30)
	item_state = "magboots"
	icon_state = "magboots"

	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list(
		"Vaurca Breeder" = 'icons/mob/species/breeder/shoes.dmi'
		)

	action_button_name = "Toggle the magclaws"

/obj/item/clothing/shoes/magboots/typec/attack_self(mob/user)
	if(src.magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		canremove = 1
		user << "You relax your deathgrip on the flooring."
	else
		//make sure these can only be used when equipped.
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/H = user
		if (H.shoes != src)
			user << "You will have to put on the [src] before you can do that."
			return


		item_flags |= NOSLIP
		magpulse = 1
		canremove = 0	//kinda hard to take off magclaws when you are gripping them tightly.
		user << "You dig your claws deeply into the flooring, bracing yourself."
		user << "It would be hard to take off the [src] without relaxing your grip first."

//In case they somehow come off while enabled.
/obj/item/clothing/shoes/magboots/typec/dropped(mob/user as mob)
	..()
	if(src.magpulse)
		user.visible_message("The [src] go limp as they are removed from [usr]'s feet.", "The [src] go limp as they are removed from your feet.")
		item_flags &= ~NOSLIP
		magpulse = 0
		canremove = 1

/obj/item/clothing/shoes/magboots/typec/examine(mob/user)
	..(user)
	if (magpulse)
		user << "It would be hard to take these off without relaxing your grip first." //theoretically this message should only be seen by the wearer when the claws are equipped.


//ZZODDAA
/obj/item/clothing/gloves/yellow/typec
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	desc = "A set of form-fitting carapace gauntlets. They appear to be fitted with some robust hydralics."
	name = "carapace gauntlets"
	w_class = 5.0
	icon_state = "forceglove"
	item_state = "forceglove"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 60, laser = 30, energy = 30, bomb = 30, bio = 30, rad = 30)
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list(
		"Vaurca Breeder" = 'icons/mob/species/breeder/gloves.dmi'
		)

/obj/item/clothing/mask/gas/typec
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	name = "carapace mask"
	desc = "A carapace gas filter designed to fit over an insectoid maw without hindering the mandibles."
	icon_state = "breath"
	item_state = "breath"
	body_parts_covered = 0
	flags_inv = null
	w_class = 5.0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.3
	gas_filter_strength = 5			//For gas mask filters
	filtered_gases = list("nitrogen", "sleeping_agent")
	armor = list(melee = 25, bullet = 25, laser = 15, energy = 15, bomb = 15, bio = 75, rad = 50)
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list(
		"Vaurca Breeder" = 'icons/mob/species/breeder/mask.dmi'
		)

obj/item/weapon/storage/backpack/typec
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	name = "type c wings"
	desc = "The wings of a CB Caste Vaurca. They are far too small at this stage to permit sustained periods of flight in most situations."
	icon_state = "wings"
	item_state = "wings"
	w_class = 5.0
	slot_flags = SLOT_BACK
	max_w_class = 3
	max_storage_space = 12
	canremove = 0
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list(
		"Vaurca Breeder" = 'icons/mob/species/breeder/back.dmi'
		)
