/obj/structure/window_frame
	name = "window frame"
	desc = "An empty window frame."
	icon = 'icons/obj/smooth/full_window.dmi'
	icon_state = "window_frame"
	build_amt = 4
	anchored = FALSE

/obj/structure/window_frame/anchored
	anchored = TRUE

/obj/structure/window_frame/attackby(obj/item/W, mob/user)
	if((W.isscrewdriver()) && (istype(loc, /turf/simulated) || anchored))
		playsound(src, W.usesound, 80, 1)
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] \the [src].</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor.</span>")
		return

	else if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [WT] isn't turned on."))
			return
		if(WT.remove_fuel(0, user))
			to_chat(user, SPAN_NOTICE("You use \the [WT] to remove \the [src]."))
			playsound(src, WT.usesound, 80, 1)
			new /obj/item/stack/material/steel(get_turf(src),rand(1,3))
			qdel(src)
			return

	else if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS_REINFORCED && anchored)
		var/obj/item/stack/material/G = W
		if(G.use(4))
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_WARNING ("You place the glass on the window frame."))
			new /obj/structure/window/full(get_turf(src))
			qdel(src)
			return
		else
			to_chat(user, SPAN_WARNING ("You need at least four sheets of reinforced glass to finished the window."))

	else if(istype(W, /obj/item/stack/material) && W.get_material_name() == MATERIAL_GLASS_REINFORCED_PHORON && anchored)
		var/obj/item/stack/material/G = W
		if(G.use(4))
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_WARNING ("You place the glass on the window frame."))
			new /obj/structure/window/full/phoron(get_turf(src))
			qdel(src)
			return
		else
			to_chat(user, SPAN_WARNING ("You need at least four sheets of reinforced borosilicate  glass to finished the window."))
