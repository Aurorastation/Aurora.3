/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "gravitational singularity generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 0
	density = 1
	use_power = POWER_USE_OFF
	var/energy = 0
	var/creation_type = /obj/singularity

/obj/machinery/the_singularitygen/update_icon()
	cut_overlays()
	if(anchored)
		add_overlay("[icon_state]+bolts")
		var/image/lights_image = image(icon, null, "[icon_state]+lights")
		lights_image.layer = EFFECTS_ABOVE_LIGHTING_LAYER
		add_overlay(lights_image)

/obj/machinery/the_singularitygen/process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new creation_type(T, 50)
		if(src) qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		anchored = !anchored
		attacking_item.play_tool_sound(get_turf(src), 75)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.",
									"You secure the [src.name] to the floor.",
									"You hear a ratchet")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.",
									"You unsecure the [src.name] from the floor.",
									"You hear a ratchet")
		update_icon()
		return
	return ..()
