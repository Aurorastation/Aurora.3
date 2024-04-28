/obj/item/reagent_containers/weldpack
	name = "welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/item/tools/welderpack.dmi'
	icon_state = "welderpack"
	item_state = "welderpack"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	volume = 350
	reagents_to_add = list(/singleton/reagent/fuel = 350)
	amount_per_transfer_from_this = 30
	possible_transfer_amounts = list(30, 60, 120, 350)
	recyclable = FALSE
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/reagent_containers/weldpack/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(ishuman(loc) && user != loc) // what if we want to sneak some reagents out of somewhere?
		return
	if(reagents.total_volume)
		var/fuel_volume = REAGENT_VOLUME(reagents, /singleton/reagent/fuel)
		if(!fuel_volume)
			fuel_volume = 0
		. += SPAN_NOTICE("\The [src] has [reagents.total_volume]u of reagents in it, <b>[fuel_volume]u</b> of which is fuel.")
	else
		. += SPAN_WARNING("\The [src] is empty!")

/obj/item/reagent_containers/weldpack/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		else
			atom_flags = ATOM_FLAG_OPEN_CONTAINER
		attacking_item.play_tool_sound(get_turf(src), 70)
		to_chat(user, SPAN_NOTICE("You wrench \the [src]'s fuel cap [(atom_flags & ATOM_FLAG_OPEN_CONTAINER) ? "open" : "closed"]."))
		return
	else if(attacking_item.iswelder())
		var/obj/item/weldingtool/T = attacking_item
		var/fuel_volume = REAGENT_VOLUME(reagents, /singleton/reagent/fuel)
		if(!fuel_volume)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have any fuel in it!"))
			return
		var/tool_fuel_volume = REAGENT_VOLUME(T.reagents, /singleton/reagent/fuel)
		if(!tool_fuel_volume)
			tool_fuel_volume = 0
		else if(tool_fuel_volume >= T.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [T] is already fully fueled!"))
			return
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.",ckey=key_name(user))
			to_chat(user, SPAN_DANGER("That was stupid of you."))
			explosion(get_turf(src),-1,0,2)
			qdel(src)
		else
			if(T.welding)
				to_chat(user, SPAN_DANGER("That was close!"))
			reagents.trans_type_to(attacking_item, /singleton/reagent/fuel, min(fuel_volume, T.reagents.maximum_volume - tool_fuel_volume))
			to_chat(user, SPAN_NOTICE("Welder refilled!"))
			playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	return ..()
