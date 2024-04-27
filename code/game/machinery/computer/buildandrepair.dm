//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = 1
	anchored = 0
	name = "computer frame"
	icon = 'icons/obj/machinery/modular_console.dmi'
	icon_state = "0"
	build_amt = 5
	var/state = 0
	var/obj/item/circuitboard/circuit = null

/obj/structure/computerframe/attackby(obj/item/attacking_item, mob/user)
	switch(state)
		if(0)
			if(attacking_item.iswrench())
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					to_chat(user, "<span class='notice'>You wrench the frame into place.</span>")
					src.anchored = 1
					src.state = 1
				return TRUE
			if(attacking_item.iswelder())
				var/obj/item/weldingtool/WT = attacking_item
				if(!WT.use(0, user))
					to_chat(user, "The welding tool must be on to complete this task.")
					return TRUE
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					if(!src || !WT.isOn()) return
					to_chat(user, "<span class='notice'>You deconstruct the frame.</span>")
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
				return TRUE
		if(1)
			if(attacking_item.iswrench())
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					to_chat(user, "<span class='notice'>You unfasten the frame.</span>")
					src.anchored = 0
					src.state = 0
				return TRUE
			if(istype(attacking_item, /obj/item/circuitboard) && !circuit)
				var/obj/item/circuitboard/B = attacking_item
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, "<span class='notice'>You place the circuit board inside the frame.</span>")
					src.icon_state = "1"
					src.circuit = attacking_item
					user.drop_from_inventory(attacking_item, src)
				else
					to_chat(user, "<span class='warning'>This frame does not accept circuit boards of this type!</span>")
				return TRUE
			if(attacking_item.isscrewdriver() && circuit)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You screw the circuit board into place and screw the drawer shut.</span>")
				src.state = 2
				src.icon_state = "2"
				return TRUE
			if(attacking_item.iscrowbar() && circuit)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You remove the circuit board.</span>")
				src.state = 1
				src.icon_state = "0"
				circuit.forceMove(src.loc)
				src.circuit = null
				return TRUE
		if(2)
			if(attacking_item.isscrewdriver() && circuit)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You unfasten the circuit board.</span>")
				src.state = 1
				src.icon_state = "1"
				return TRUE
			if(attacking_item.iscoil())
				var/obj/item/stack/cable_coil/C = attacking_item
				if (C.get_amount() < 5)
					to_chat(user, "<span class='warning'>You need five coils of wire to add them to the frame.</span>")
					return TRUE
				to_chat(user, "<span class='notice'>You start to add cables to the frame.</span>")
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) && state == 2)
					if (C.use(5))
						to_chat(user, "<span class='notice'>You add cables to the frame.</span>")
						state = 3
						icon_state = "3"
				return TRUE
		if(3)
			if(attacking_item.iswirecutter())
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You remove the cables.</span>")
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5
				return TRUE

			if(istype(attacking_item, /obj/item/stack/material) && attacking_item.get_material_name() == "glass")
				var/obj/item/stack/G = attacking_item
				if (G.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>")
					return TRUE
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You start to put in the glass keyboard.</span>")
				if(do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) && state == 3)
					if (G.use(2))
						to_chat(user, "<span class='notice'>You put in the glass keyboard.</span>")
						src.state = 4
						src.icon_state = "4"
				return TRUE
		if(4)
			if(attacking_item.iscrowbar())
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You remove the glass keyboard.</span>")
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/material/glass( src.loc, 2 )
				return TRUE
			if(attacking_item.isscrewdriver())
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You connect the glass keyboard.</span>")
				var/B = new src.circuit.build_path ( src.loc )
				src.circuit.construct(B)
				qdel(src)
				return TRUE
