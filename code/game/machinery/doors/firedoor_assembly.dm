obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_construction"
	anchored = 0
	opacity = 0
	density = 1
	var/wired = 0

obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

obj/structure/firedoor_assembly/attackby(var/obj/item/C as obj, mob/user as mob)
	if(C.iscoil() && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = C
		if (cable.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You need one length of coil to wire \the [src]."))
			return
		user.visible_message("<b>[user]</b> wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 40) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, SPAN_NOTICE("You wire \the [src]."))

	else if(C.iswirecutter() && wired )
		playsound(src.loc, 'sound/items/wirecutter.ogg', 100, 1)
		user.visible_message("<b>[user]</b> cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 40/C.toolspeed))
			if(!src) return
			to_chat(user, SPAN_NOTICE("You cut the wires!"))
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0

	else if(istype(C, /obj/item/airalarm_electronics) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message(SPAN_WARNING("[user] has inserted a circuit into \the [src]!"),
								  "You have inserted the circuit into \the [src]!")
			new /obj/machinery/door/firedoor(src.loc)
			qdel(C)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You must secure \the [src] first!"))
	else if(C.iswrench())
		anchored = !anchored
		playsound(src.loc, C.usesound, 50, 1)
		user.visible_message(SPAN_WARNING("[user] has [anchored ? "" : "un" ]secured \the [src]!"),
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if(!anchored && C.iswelder())
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_WARNING("[user] dissassembles \the [src]."),
			"You start to dissassemble \the [src].")
			if(do_after(user, 40/C.toolspeed))
				if(!src || !WT.isOn()) return
				user.visible_message(SPAN_WARNING("[user] has dissassembled \the [src]."),
									"You have dissassembled \the [src].")
				new /obj/item/stack/material/steel(src.loc, 2)
				qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel."))
	else
		..(C, user)
