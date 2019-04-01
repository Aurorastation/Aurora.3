/obj/item/clothing/under/uniform
	name = "levy uniform"
	desc = "A simple military uniform issued to the soldiers of the Imperial Army."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "nka_uniform"
	item_state = "nka_uniform"
	contained_sprite = TRUE
	armor = list(melee = 10, bullet = 5, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/uniform/levy
	starting_accessories = list(/obj/item/clothing/accessory/levy_coat, /obj/item/clothing/accessory/epaulette)

/obj/item/clothing/under/uniform/grenadier
	starting_accessories = list(/obj/item/clothing/accessory/levy_coat, /obj/item/clothing/accessory/epaulette/grenadier)

/obj/item/clothing/under/uniform/combat_engineer
	starting_accessories = list(/obj/item/clothing/accessory/levy_coat, /obj/item/clothing/accessory/epaulette/engineer)

/obj/item/clothing/under/uniform/sharpshooter
	starting_accessories = list(/obj/item/clothing/accessory/levy_coat, /obj/item/clothing/accessory/epaulette/sharpshooter)

/obj/item/clothing/under/uniform/supply
	starting_accessories = list(/obj/item/clothing/accessory/levy_coat, /obj/item/clothing/accessory/epaulette/supply)

/obj/item/clothing/under/uniform/hand
	name = "officer uniform"
	desc = "A service military uniform issued to the officers of the Imperial Army."
	icon_state = "captain"
	item_state = "captain"
	starting_accessories = list(/obj/item/clothing/accessory/levy_coat/officer, /obj/item/clothing/accessory/epaulette/commander)

/obj/item/clothing/under/uniform/hand/fancy
	name = "officer dress uniform"
	desc = "A fancy dress military uniform issued to the officers of the Imperial Army."
	icon_state = "noble"
	item_state = "noble"
	starting_accessories = null

/obj/item/clothing/under/uniform/hand/fancy/alt
	icon_state = "nka_officerdress"
	item_state = "nka_officerdress"
	starting_accessories = (/obj/item/clothing/accessory/levy_coat/dress/officer)

/obj/item/clothing/under/uniform/constable
	name = "constable uniform"
	desc = "An uniform used by the police forces of the New Kingdom of Adhomai."
	icon_state = "constable"
	item_state = "constable"

/obj/item/clothing/under/uniform/pra
	name = "republican uniform"
	desc = "An uniform used by the soldiers of the Republican Army."
	icon_state = "pra_uniform"
	item_state = "pra_uniform"

/obj/item/clothing/under/uniform/pra/alt
	icon_state = "catshirt"
	item_state = "catshirt"

/obj/item/clothing/under/uniform/dragoon
	name = "imperial dragoon uniform"
	desc = "A robust military uniform issued to the dragoons of the Imperial Army."
	icon_state = "military_uniform"
	item_state = "military_uniform"

/obj/item/clothing/under/uniform/dragoon/commander
	name = "imperial dragoon commander uniform"
	desc = "A robust military uniform issued to an officer of the Imperial Dragoons."
	icon_state = "military_commander"
	item_state = "military_commander"

/obj/item/clothing/under/uniform/sailor
	name = "sailor uniform"
	desc = "A military uniform issued to the sailors of the Royal Navy."
	icon_state = "sailor"
	item_state = "sailor"

/obj/item/clothing/under/archeologist
	name = "archeologist uniform"
	desc = "A simple uniform used by archeologists."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "explorer_uniform"
	item_state = "explorer_uniform"
	contained_sprite = TRUE