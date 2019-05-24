/obj/item/clothing/head/helmet/space/void/sol
	name = "military voidsuit helmet"
	desc = "A sleek black space helmet designed for combat. Looks to be uniform with Sol Alliance colors."
	icon_state = "sol_helmet"
	item_state = "sol_helmet"
	armor = list(melee = 70, bullet = 55, laser = 45, energy = 15, bomb = 40, bio = 100, rad = 60)
	siemens_coefficient = 0.3
	species_restricted = list("Human")

	brightness_on = 6
	refittable = FALSE


/obj/item/clothing/suit/space/void/sol
	name = "military voidsuit"
	desc = "A sleek black space suit designed for combat. Looks to have seamless composite plating. Painted in Sol Alliance colors."
	icon_state = "sol_suit"
	item_state = "sol_suit"
	slowdown = 1
	armor = list(melee = 70, bullet = 55, laser = 45, energy = 15, bomb = 40, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs)
	siemens_coefficient = 0.3
	species_restricted = list("Human")
	refittable = FALSE
