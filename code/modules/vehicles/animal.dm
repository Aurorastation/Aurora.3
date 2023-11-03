/obj/vehicle/bike/climber
	name = "climber"
	desc = "A rideable beast of burden, large enough for one adult rider only but perfectly adapted for the rough terrain on Adhomai. This one has a saddle mounted on it."
	icon = 'icons/mob/npc/adhomai_48.dmi'
	icon_state = "climber_s"
	bike_icon = "climber_s"
	desc_info = "Click-drag yourself onto the animal to climb onto it.<br>\
		- Click-drag it onto yourself to access its mounted storage.<br>"
	pixel_x = -8
	mob_offset_y = 8
	kickstand = FALSE
	on = TRUE
	land_speed = 2
	space_speed = 0

	health = 100

	can_hover = FALSE
	organic = TRUE

	storage_type = /obj/item/storage/toolbox/bike_storage/saddle
	corpse = /mob/living/simple_animal/climber/saddle

/obj/vehicle/bike/climber/setup_vehicle()
	..()
	on = TRUE
	set_light(0)

/obj/vehicle/bike/climber/CtrlClick(var/mob/user)
	return

/obj/vehicle/bike/climber/toggle_engine(var/mob/user)
	return

/obj/vehicle/bike/climber/kickstand(var/mob/user)
	return

/obj/item/storage/toolbox/bike_storage/saddle
	name = "saddle storage"

/obj/item/saddle
	name = "saddle"
	desc = "A structure used to ride animals."
	icon = 'icons/obj/saddle.dmi'
	icon_state = "saddle"
	w_class = ITEMSIZE_NORMAL