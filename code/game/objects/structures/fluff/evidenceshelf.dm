/obj/structure/fluff/evidenceshelf
	name = "evidence shelf"
	desc = "A shelf filled with meticulously labeled cardboard boxes. It's fastened to the floor by sturdy bolts."
	icon = 'icons/obj/fluff/evidenceshelf.dmi'
	icon_state = "evidence_shelf"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	climbable = TRUE
	material = MATERIAL_STEEL

/obj/structure/fluff/evidenceshelf/attackby(obj/item/attacking_item, mob/user)

	if(attacking_item.tool_behaviour == TOOL_WRENCH) //hopefully unanchors the shelf
		anchored = !anchored
		var/obj/structure/fluff/evidenceshelf/E
		for(E in src.loc)
			if(E != src && E.anchored) //only one shelf per tile please
				to_chat(user, "There is already a shelf secured here!")
				return
		attacking_item.play_tool_sound(get_turf(src), 50)
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "secured in place" : "unsecured"] by \the [user]."))
