/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/structure/tables/table.dmi'
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

/obj/structure/table/rack/clothing
	name = "clothing rack"
	desc = "A mighty rack, suitable for grabbing and pushing. It's quite mobile."
	icon = 'icons/obj/structure/urban/tailoring.dmi'
	icon_state = "clothes_rack"

/obj/structure/table/rack/retail_shelf
	name = "retail shelves"
	desc = "A large, assorted shelf with many platforms for setting things upon."
	icon = 'icons/obj/structure/urban/infrastructure.dmi'
	icon_state = "shelf"

/obj/structure/table/rack/cafe_table
	name = "round cafe table"
	desc = "A wood table with soft, rounded edges."
	icon = 'icons/obj/structure/urban/restaurant.dmi'
	icon_state = "cafe"
	table_mat = MATERIAL_WOOD

/obj/structure/table/rack/holorack/dismantle(obj/item/wrench/W, mob/user)
	to_chat(user, SPAN_WARNING("You cannot dismantle \the [src]."))
	return
