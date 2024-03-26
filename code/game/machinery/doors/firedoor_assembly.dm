/obj/structure/firedoor_assembly
	name = "emergency shutter assembly"
	desc = "An emergency shutter assembly."
	icon = 'icons/obj/doors/basic/single/emergency/firedoor.dmi'
	icon_state = "door_construction"
	anchored = 0
	opacity = 0
	density = 1
	build_amt = 4
	var/wired = 0

/obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

/obj/structure/firedoor_assembly/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscoil() && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = attacking_item
		if (cable.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of coil to wire \the [src].</span>")
			return TRUE
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, "<span class='notice'>You wire \the [src].</span>")
		return TRUE
	else if(attacking_item.iswirecutter() && wired )
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(attacking_item.use_tool(src, user, 40, volume = 50))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the wires!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0
		return TRUE
	else if(istype(attacking_item, /obj/item/airalarm_electronics) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='warning'>[user] has inserted a circuit into \the [src]!</span>",
									"You have inserted the circuit into \the [src]!")
			new /obj/machinery/door/firedoor(src.loc)
			qdel(attacking_item)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You must secure \the [src] first!</span>")
		return TRUE
	else if(attacking_item.iswrench())
		anchored = !anchored
		attacking_item.play_tool_sound(get_turf(src), 50)
		user.visible_message("<span class='warning'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
								"You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
		return TRUE
	else if(!anchored && attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.use(0, user))
			user.visible_message("<span class='warning'>[user] dissassembles \the [src].</span>",
			"You start to dissassemble \the [src].")
			if(attacking_item.use_tool(src, user, 40, volume = 50))
				if(!src || !WT.isOn()) return
				user.visible_message("<span class='warning'>[user] has dissassembled \the [src].</span>",
									"You have dissassembled \the [src].")
				new /obj/item/stack/material/steel(src.loc, 2)
				qdel(src)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
		return TRUE
	else
		return ..()
