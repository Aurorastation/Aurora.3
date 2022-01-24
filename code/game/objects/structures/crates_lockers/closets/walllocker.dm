//added by cael from old bs12
//not sure if there's an immediate place for secure wall lockers, but i'm sure the players will think of something

/obj/structure/closet/walllocker
	desc = "A wall mounted storage locker."
	name = "Wall Locker"
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "wall-locker"
	density = FALSE
	anchored = TRUE
	store_mobs = FALSE
	icon_closed = "wall-locker"
	icon_opened = "wall-lockeropen"

/obj/structure/closet/walllocker/emerglocker
	name = "emergency locker"
	desc = "A wall mounted locker with emergency supplies."
	icon_state = "emerg"
	icon_closed = "emerg"
	icon_opened = "emerg-open"

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
