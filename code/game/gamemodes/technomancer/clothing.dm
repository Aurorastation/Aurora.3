/obj/item/clothing/suit/technomancer
	name = "chrome manipulation suit"
	desc = "It's a very shiny and somewhat protective suit, built to help carry cores on the user's back."
	icon_state = "technomancer_uni"
	item_state = "technomancer_uni"
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	allowed = list(/obj/item/tank)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.75

/obj/item/clothing/under/technomancer
	name = "initiate's jumpsuit"
	desc = "It's a blue colored jumpsuit.  There appears to be light-weight armor padding underneath, providing some protection.  \
	There is also a healthy amount of insulation underneath."
	icon_state = "initiate_uni"
	item_state = "initiate_uni"
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_MINOR,
	)
	siemens_coefficient = 0.3

/obj/item/clothing/under/technomancer/apprentice
	name = "apprentice's jumpsuit"
	desc = "It's a blue colored jumpsuit with some silver markings.  There appears to be light-weight armor padding \
	underneath, providing some protection.  There is also a healthy amount of insulation underneath."
	icon_state = "apprentice_uni"
	item_state = "apprentice_uni"
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE

/obj/item/clothing/under/technomancer/master
	name = "master's jumpsuit"
	desc = "It's a blue colored jumpsuit with some gold markings.  There appears to be light-weight armor padding \
	underneath, providing some protection.  There is also a healthy amount of insulation underneath."
	icon_state = "technomancer_uni"
	item_state = "technomancer_uni"
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/technomancer
	name = "initiate's hat"
	desc = "It's a somewhat silly looking blue pointed hat."
	icon_state = "initiate_hat"
	item_state = "initiate_hat"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
	)
	siemens_coefficient = 0.3
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/technomancer/apprentice
	name = "apprentice's hat"
	desc = "It's a somewhat silly looking blue pointed hat.  This one has a silver colored metalic feather strapped to it."
	icon_state = "apprentice_hat"
	item_state = "apprentice_hat"
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/technomancer/master
	name = "master's hat"
	desc = "It's a somewhat silly looking blue pointed hat.  This one has a gold colored metalic feather strapped to it."
	icon_state = "technomancer_hat"
	item_state = "technomancer_hat"
	icon = 'icons/obj/item/clothing/technomancer.dmi'
	contained_sprite = TRUE

/obj/item/clothing/under/chameleon/technomancer
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/head/chameleon/technomancer
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/shoes/chameleon/technomancer
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/chameleon/technomancer
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_MINOR,
		rad = ARMOR_RAD_RESISTANT
	)
