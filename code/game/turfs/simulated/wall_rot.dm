/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	icon_state = "wallrot"
	anchored = TRUE
	density = TRUE
	layer = 5
	mouse_opacity = 0

/obj/effect/overlay/wallrot/Initialize(mapload, ...)
	. = ..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/wallrot/proc/scrape(var/mob/user)
	var/obj/item/rot_sample/RS = new /obj/item/rot_sample(get_turf(src))
	user.put_in_hands(RS)
	qdel(src)

/obj/item/rot_sample
	name = "rot sample"
	desc = "A gross, wet, squishy piece of what may be a plant."
	desc_info = "This sample can be ground to retrieve reagents inside it."
	icon = 'icons/effects/wallrot.dmi'
	icon_state = "rot_sample"

/obj/item/rot_sample/Initialize(mapload)
	. = ..()
	create_reagents(15)
	var/list/possible_reagents = list(/decl/reagent/bicaridine, /decl/reagent/kelotane, /decl/reagent/dexalin, /decl/reagent/mortaphenyl, /decl/reagent/oculine, /decl/reagent/peridaxon)
	reagents.add_reagent(pick(possible_reagents), 15)
	color = reagents.get_color()
