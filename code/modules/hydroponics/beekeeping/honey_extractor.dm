/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to turn honeycombs on the frame into honey and wax."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "centrifuge"
	anchored = TRUE

	var/obj/item/honey_frame/contained_frame
	var/honey = 0

/obj/machinery/honey_extractor/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(contained_frame)
		. += SPAN_NOTICE("It's holding \the <b>[contained_frame]</b>.")
	. += SPAN_NOTICE("It contains <b>[honey]</b> units of honey for collection.")

/obj/machinery/honey_extractor/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Once filled honeycombs have been obtained, insert them into this device to process them into wax and honey. The honey can be retrieved from \
	the extractor with any reagent container."

/obj/machinery/honey_extractor/attackby(obj/item/attacking_item, mob/user)
	if(contained_frame)
		to_chat(user, SPAN_WARNING("\The [src] is currently spinning, wait until it's finished."))
		return
	else if(istype(attacking_item, /obj/item/honey_frame))
		var/obj/item/honey_frame/H = attacking_item
		if(!H.honey)
			to_chat(user, SPAN_NOTICE("\The [H] is empty, put it into a beehive."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [H] into \the [src] and turns it on."), SPAN_NOTICE("You load \the [H] into \the [src] and turn it on."))
		user.drop_from_inventory(H, src)
		contained_frame = H
		icon_state = "centrifuge_moving"
		addtimer(CALLBACK(src, PROC_REF(do_process)), 100)
	else if(istype(attacking_item, /obj/item/reagent_containers/glass))
		if(!honey)
			to_chat(user, SPAN_NOTICE("There is no honey in \the [src]."))
			return
		var/obj/item/reagent_containers/glass/G = attacking_item
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.reagents.add_reagent(/singleton/reagent/nutriment/honey, transferred)
		honey -= transferred
		user.visible_message(SPAN_NOTICE("\The [user] collects honey from \the [src] into \the [G]."), SPAN_NOTICE("You collect [transferred] units of honey from \the [src] into \the [G]."))
		return
	else
		..()

/obj/machinery/honey_extractor/proc/do_process()
	honey += contained_frame.honey
	contained_frame.honey = 0
	contained_frame.forceMove(get_turf(src))
	contained_frame = null
	new /obj/item/stack/wax(get_turf(src))
	icon_state = "centrifuge"
