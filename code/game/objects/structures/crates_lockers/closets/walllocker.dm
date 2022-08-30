/obj/structure/closet/walllocker
	name = "wall locker"
	desc = "A wall mounted storage locker."
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "walllocker"
	door_anim_angle = 132
	door_anim_squish = 0.38
	door_hinge = -7
	door_anim_time = 2.7
	store_mobs = FALSE
	density = FALSE
	anchored = TRUE
	wall_mounted = TRUE

	// Climbing Variables
	climbable = FALSE // Self-explanatory.
	climb_time = null // Not used.

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
	name = "firefighting closet"
	desc = "It's a storage unit for firefighting supplies."
	icon_state = "hydrant"

/obj/structure/closet/walllocker/firecloset/fill()
	new /obj/item/clothing/head/hardhat/firefighter(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/crowbar/rescue_axe/red(src)
	new /obj/item/tank/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/wall(src)
	new /obj/item/inflatable/wall(src)

	if (prob(25))
		new /obj/item/ladder_mobile(src)

/obj/structure/closet/walllocker/firecloset/medical/fill()
	new /obj/item/clothing/head/hardhat/firefighter(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/tank/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/ladder_mobile(src)
	new /obj/item/storage/bag/inflatable/emergency(src)

/obj/structure/closet/walllocker/medical //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall"

/obj/structure/closet/walllocker/medical/secure
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_door = "medical_wall_secure"
	icon_door_override = TRUE
	locked = TRUE
	secure = TRUE
	req_access = list(access_medical_equip)
