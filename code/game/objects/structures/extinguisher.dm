/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "cabinet"
	anchored = 1
	density = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/obj/item/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Alt-click to close the door."

/obj/structure/extinguisher_cabinet/north
	dir = NORTH
	pixel_y = 24

/obj/structure/extinguisher_cabinet/east
	dir = EAST
	pixel_x = 21
	pixel_y = 4

/obj/structure/extinguisher_cabinet/west
	dir = WEST
	pixel_x = -21
	pixel_y = 4

/obj/structure/extinguisher_cabinet/south
	dir = SOUTH
	pixel_y = -23

/obj/structure/extinguisher_cabinet/Initialize(mapload)
	. = ..()
	has_extinguisher = new /obj/item/extinguisher(src)
	update_icon()

	if(!mapload)
		set_pixel_offsets()

/obj/structure/extinguisher_cabinet/set_pixel_offsets()
	pixel_x = dir & (NORTH|SOUTH) ? 0 : (dir == EAST ? 21 : 4)
	pixel_y = dir & (NORTH|SOUTH) ? (dir == NORTH ? 24 : -23) : 4

/obj/structure/extinguisher_cabinet/attackby(obj/item/attacking_item, mob/user)
	if(isrobot(user))
		return
	if(istype(attacking_item, /obj/item/extinguisher))
		if(!has_extinguisher && opened)
			user.remove_from_mob(attacking_item)
			contents += attacking_item
			has_extinguisher = attacking_item
			to_chat(user, SPAN_NOTICE("You place [attacking_item] in [src]."))
			playsound(src.loc, 'sound/effects/extin.ogg', 50, 0)
		else
			opened = !opened
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/AltClick(mob/user)
	opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/attack_hand(mob/user)
	if(isrobot(user))
		return
	if(use_check_and_message(usr))
		return 0
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, SPAN_NOTICE("You take [has_extinguisher] from [src]."))
		playsound(src.loc, 'sound/effects/extout.ogg', 50, 0)
		has_extinguisher = null
		opened = TRUE
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/update_icon()
	ClearOverlays()
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/extinguisher/mini))
			AddOverlays("extinguisher_mini")
		else
			AddOverlays("extinguisher_full")
	if(opened)
		AddOverlays("cabinet_door_open")
	else
		AddOverlays("cabinet_door_closed")

/obj/structure/extinguisher_cabinet/do_simple_ranged_interaction(var/mob/user)
	if(has_extinguisher)
		has_extinguisher.dropInto(loc)
		has_extinguisher = null
		opened = TRUE
	else
		opened = !opened
	update_icon()
	return TRUE
