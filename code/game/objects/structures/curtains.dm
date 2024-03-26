#define SHOWER_OPEN_LAYER OBJ_LAYER + 0.4
#define SHOWER_CLOSED_LAYER MOB_LAYER + 0.1

/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/curtain.dmi'
	icon_state = "closed"
	layer = SHOWER_OPEN_LAYER
	opacity = 1
	density = 0
	anchored = TRUE //curtains start secured in place
	build_amt = 2
	var/manipulating = FALSE //prevents queuing up multiple deconstructs and returning a bunch of cloth
	var/curtain_material = MATERIAL_CLOTH

/obj/structure/curtain/Initialize()
	. = ..()
	material = SSmaterials.get_material_by_name(curtain_material)
	AddComponent(/datum/component/turf_hand)

/obj/structure/curtain/open
	icon_state = "open"
	layer = SHOWER_CLOSED_LAYER
	opacity = 0

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message("<span class='warning'>[P] tears [src] down!</span>")
		qdel(src)
	else
		..(P, def_zone)

/obj/structure/curtain/attack_hand(mob/user)
	playsound(get_turf(loc), 'sound/effects/curtain.ogg', 15, 1, -5)
	toggle()
	..()

/obj/structure/curtain/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/curtain/attackby(obj/item/attacking_item, mob/user)

	if(attacking_item.iswirecutter() || attacking_item.sharp && !attacking_item.noslice)
		if(manipulating)	return
		manipulating = TRUE
		visible_message(SPAN_NOTICE("[user] begins cutting down \the [src]."),
					SPAN_NOTICE("You begin cutting down \the [src]."))
		if(!attacking_item.use_tool(src, user, 30, volume = 50))
			manipulating = FALSE
			return
		visible_message(SPAN_NOTICE("[user] cuts down \the [src]."),
					SPAN_NOTICE("You cut down \the [src]."))
		dismantle()

	if(attacking_item.isscrewdriver()) //You can anchor/unanchor curtains
		anchored = !anchored
		var/obj/structure/curtain/C
		for(C in src.loc)
			if(C != src && C.anchored) //Can't secure more than one curtain in a tile
				to_chat(user, "There is already a curtain secured here!")
				return
		attacking_item.play_tool_sound(get_turf(src), 50)
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "secured in place" : "unsecured"] by \the [user]."))

/obj/structure/curtain/proc/toggle()
	src.set_opacity(!src.opacity)
	if(opacity)
		icon_state = "closed"
		layer = SHOWER_CLOSED_LAYER
	else
		icon_state = "open"
		layer = SHOWER_OPEN_LAYER

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	anchored = FALSE
	alpha = 200
	curtain_material = MATERIAL_PLASTIC

/obj/structure/curtain/open/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	anchored = FALSE
	alpha = 200
	curtain_material = MATERIAL_PLASTIC

/obj/structure/curtain/open/bed
	name = "bed curtain"
	color = "#854636"

/obj/structure/curtain/open/privacy
	name = "privacy curtain"
	color = "#B8F5E3"
	anchored = FALSE

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/open/shower/engineering
	color = "#FFA500"

/obj/structure/curtain/open/shower/security
	color = "#AA0000"

#undef SHOWER_OPEN_LAYER
#undef SHOWER_CLOSED_LAYER
