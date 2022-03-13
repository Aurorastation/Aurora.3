//added by cael from old bs12
//not sure if there's an immediate place for secure wall lockers, but i'm sure the players will think of something

/obj/structure/closet/walllocker
	desc = "A wall mounted storage locker."
	name = "Wall Locker"
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "walllocker" //...man, how OLD is this $#!?
	door_anim_angle = 108
	door_anim_squish = 0.26
	door_hinge = 9.5
	door_anim_time = 2.7
	density = FALSE
	anchored = TRUE
	wall_mounted = TRUE

/obj/structure/closet/walllocker/emerglocker
	name = "emergency locker"
	desc = "A wall mounted locker with emergency supplies."
	icon_state = "emerg"
	store_mobs = FALSE
	door_anim_time = 0

/obj/structure/closet/walllocker/emerglocker/fill()
	for(var/i = 1 to 3)
		new /obj/item/tank/emergency_oxygen(src)
		new /obj/item/clothing/mask/breath(src)
		if(prob(20))
			new /obj/item/reagent_containers/hypospray/autoinjector/emergency(src)

/obj/structure/closet/walllocker/emerglocker/north
	pixel_y = 32
	dir = SOUTH

/obj/structure/closet/walllocker/emerglocker/south
	pixel_y = -32
	dir = NORTH

/obj/structure/closet/walllocker/emerglocker/west
	pixel_x = -32
	dir = WEST

/obj/structure/closet/walllocker/emerglocker/east
	pixel_x = 32
	dir = EAST

/obj/structure/closet/walllocker/firecloset //wall mounted fire closet
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "hydrant"

/obj/structure/closet/walllocker/firecloset/fill()
	new /obj/item/clothing/head/hardhat/firefighter(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/tank/oxygen/red(src)
	new /obj/item/extinguisher(src)

	if (prob(25))
		new /obj/item/ladder_mobile(src)

/obj/structure/closet/walllocker/medical //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall"
