/obj/item/stack/barricade
	name = "metal barricade kit"
	desc = "A kit of metal, pipes, nuts, and bolts. You can make a barricade with this."
	singular_name = "barricade kit"
	max_amount = 5
	icon = 'icons/obj/barricade_stacks.dmi'
	icon_state = "steel-kit"
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 650, MATERIAL_PHORON = 100, MATERIAL_PLASTEEL = 150)
	var/barricade_name = "steel"
	var/barricade_type = /obj/structure/barricade/metal
	var/build_sound = 'sound/effects/clang.ogg'

/obj/item/stack/barricade/attack_self(mob/living/user)
	..()
	add_fingerprint(user)

	if(!isturf(user.loc))
		return

	if(istype(user.loc, /turf/space))
		to_chat(user, SPAN_WARNING("The barricade must be constructed on a proper surface!"))
		return

	user.visible_message(SPAN_NOTICE("[user] starts assembling a [barricade_name] barricade."),
	SPAN_NOTICE("You start assembling a barricade."))

	if(!do_after(user, 3 SECONDS, do_flags = DO_REPAIR_CONSTRUCT))
		return

	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		if(O.density)
			if(!(O.atom_flags & ATOM_FLAG_CHECKS_BORDER) || O.dir == user.dir)
				return

	var/obj/structure/barricade/SB = new barricade_type(user.loc, user, user.dir)
	user.visible_message(SPAN_NOTICE("[user] assembles a [barricade_name] barricade."),
	SPAN_NOTICE("You assemble a [barricade_name] barricade."))
	SB.set_dir(user.dir)
	SB.add_fingerprint(user)
	playsound(SB, build_sound, 40)
	use(1)

/obj/item/stack/barricade/random/Initialize(mapload)
	. = ..()
	amount = rand(1, 5)
	update_icon()

/obj/item/stack/barricade/full/Initialize(mapload)
	. = ..()
	amount = 5
	update_icon()

/obj/item/stack/barricade/plasteel
	name = "plasteel barricade kit"
	desc = "A kit of plasteel, pipes, nuts, and bolts. You can make a barricade with this."
	barricade_name = "plasteel"
	barricade_type = /obj/structure/barricade/plasteel
	icon_state = "plasteel-kit"

/obj/item/stack/barricade/plasteel/random/Initialize(mapload)
	. = ..()
	amount = rand(1, 5)
	update_icon()

/obj/item/stack/barricade/plasteel/full/Initialize(mapload)
	. = ..()
	amount = 5
	update_icon()

/obj/item/stack/barricade/wood
	name = "wooden barricade kit"
	desc = "A kit of wooden planks, nails, and probably something to use as a hammer. You can make a barricade with this."
	barricade_name = "wood"
	barricade_type = /obj/structure/barricade/wooden
	icon_state = "wood-kit"
	build_sound = 'sound/effects/woodhit.ogg'

/obj/item/stack/barricade/wood/random/Initialize(mapload)
	. = ..()
	amount = rand(1,5)
	update_icon()

/obj/item/stack/barricade/wood/full/Initialize(mapload)
	. = ..()
	amount = 5
	update_icon()
