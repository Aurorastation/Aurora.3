/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/tables.dmi'
	icon_state = "rack"
	build_amt = 1
	can_plate = 0
	can_reinforce = 0
	flipped = -1
	table_mat = DEFAULT_TABLE_MATERIAL

/obj/structure/table/rack/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/remove_material(obj/item/wrench/W, mob/user)
	src.dismantle(W, user)

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	return

/obj/structure/table/rack/no_cargo
	no_cargo = TRUE

/obj/structure/table/rack/holorack/dismantle(obj/item/wrench/W, mob/user)
	to_chat(user, SPAN_WARNING("You cannot dismantle \the [src]."))
	return

/obj/structure/table/rack/fancy_table
	name = "fancy table"
	desc = "A wood table covered by a fancy cloth."
	icon_state = "fancy_table"
	table_mat = MATERIAL_WOOD

/obj/structure/table/rack/fancy_table/black
	icon_state = "fancy_table_black"