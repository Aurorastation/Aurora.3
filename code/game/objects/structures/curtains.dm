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
	var/manipulating = FALSE //prevents queuing up multiple deconstructs and returning a bunch of cloth

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

/obj/structure/curtain/attackby(obj/item/W, mob/user)

	if(W.iswirecutter() || W.sharp && !W.noslice)
		if(manipulating)	return
		manipulating = TRUE
		visible_message(span("notice", "[user] begins cutting down \the [src]."),
					span("notice", "You begin cutting down \the [src]."))
		if(!do_after(user, 30/W.toolspeed))
			manipulating = FALSE
			return
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		visible_message(span("notice", "[user] cuts down \the [src]."),
					span("notice", "You cut down \the [src]."))
		if(istype(src, /obj/structure/curtain/open/medical))
			new /obj/item/stack/material/plastic(src.loc)
		else
			new /obj/item/stack/material/cloth(src.loc, (W.iswirecutter() ? 2 : 1)) //wirecutters return full. Sharp items return half.
		qdel(src)

	if(W.isscrewdriver()) //You can anchor/unanchor curtains
		anchored = !anchored
		var/obj/structure/curtain/C
		for(C in src.loc)
			if(C != src && C.anchored) //Can't secure more than one curtain in a tile
				to_chat(user, "There is already a curtain secured here!")
				return
		playsound(src.loc, W.usesound, 50, 1)
		visible_message(span("notice", "\The [src] has been [anchored ? "secured in place" : "unsecured"] by \the [user]."))

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

/obj/structure/curtain/open/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	anchored = FALSE
	alpha = 200

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
