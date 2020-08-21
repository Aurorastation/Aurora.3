//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/computer.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(P.iswrench())
				playsound(src.loc, P.usesound, 50, 1)
				if(do_after(user, 20/P.toolspeed))
					to_chat(user, SPAN_NOTICE("You wrench the frame into place."))
					src.anchored = 1
					src.state = 1
			if(P.iswelder())
				var/obj/item/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					to_chat(user, "The welding tool must be on to complete this task.")
					return
				playsound(src.loc, 'sound/items/welder.ogg', 50, 1)
				if(do_after(user, 20/P.toolspeed))
					if(!src || !WT.isOn()) return
					to_chat(user, SPAN_NOTICE("You deconstruct the frame."))
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
		if(1)
			if(P.iswrench())
				playsound(src.loc, P.usesound, 50, 1)
				if(do_after(user, 20/P.toolspeed))
					to_chat(user, SPAN_NOTICE("You unfasten the frame."))
					src.anchored = 0
					src.state = 0
			if(istype(P, /obj/item/circuitboard) && !circuit)
				var/obj/item/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
					src.icon_state = "1"
					src.circuit = P
					user.drop_from_inventory(P,src)
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
			if(P.isscrewdriver() && circuit)
				playsound(src.loc,  P.usesound, 50, 1)
				to_chat(user, SPAN_NOTICE("You screw the circuit board into place and screw the drawer shut."))
				src.state = 2
				src.icon_state = "2"
			if(P.iscrowbar() && circuit)
				playsound(src.loc, P.usesound, 50, 1)
				to_chat(user, SPAN_NOTICE("You remove the circuit board."))
				src.state = 1
				src.icon_state = "0"
				circuit.forceMove(src.loc)
				src.circuit = null
		if(2)
			if(P.isscrewdriver() && circuit)
				playsound(src.loc,  P.usesound, 50, 1)
				to_chat(user, SPAN_NOTICE("You unfasten the circuit board."))
				src.state = 1
				src.icon_state = "1"
			if(P.iscoil())
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five coils of wire to add them to the frame."))
					return
				to_chat(user, SPAN_NOTICE("You start to add cables to the frame."))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && state == 2)
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("You add cables to the frame."))
						state = 3
						icon_state = "3"
		if(3)
			if(P.iswirecutter())
				playsound(src.loc, 'sound/items/wirecutter.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You remove the cables."))
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

			if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two sheets of glass to put in the glass panel."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You start to put in the glass keyboard."))
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						to_chat(user, SPAN_NOTICE("You put in the glass keyboard."))
						src.state = 4
						src.icon_state = "4"
		if(4)
			if(P.iscrowbar())
				playsound(src.loc, P.usesound, 50, 1)
				to_chat(user, SPAN_NOTICE("You remove the glass keyboard."))
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/material/glass( src.loc, 2 )
			if(P.isscrewdriver())
				playsound(src.loc,  P.usesound, 50, 1)
				to_chat(user, SPAN_NOTICE("You connect the glass keyboard."))
				var/B = new src.circuit.build_path ( src.loc )
				src.circuit.construct(B)
				qdel(src)
