/obj/vehicle/wheelchair
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "wheelchair"
	var/atom/movable/pusher //Someone pushing the wheelchair

	health = 100
	maxhealth = 100
	powered = 0

/obj/vehicle/wheelchair/update_icon()
	cut_overlays()
	add_overlay(image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = FLY_LAYER))