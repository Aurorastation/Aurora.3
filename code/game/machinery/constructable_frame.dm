//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery/

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	desc = "An empty frame for some kind of machine."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = 1
	anchored = 1
	use_power = 0
	var/obj/item/weapon/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

	proc/update_desc()
		var/D
		if(req_components)
			var/list/component_list = new
			for(var/I in req_components)
				if(req_components[I] > 0)
					component_list += "[num2text(req_components[I])] [req_component_names[I]]"
			D = "Requires [english_list(component_list)]."
		desc = D

/obj/machinery/constructable_frame/machine_frame
	attackby(obj/item/P as obj, mob/user as mob)
		switch(state)
			if(1)
				if(iscoil(P))
					var/obj/item/stack/cable_coil/C = P
					if (C.get_amount() < 5)
						user << "<span class='warning'>You need five lengths of cable to add them to the frame.</span>"
						return
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You start to add cables to the frame.</span>"
					if(do_after(user, 20) && state == 1)
						if(C.use(5))
							user << "<span class='notice'>You add cables to the frame.</span>"
							state = 2
							icon_state = "box_1"
				else
					if(iswrench(P))
						playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
						user << "<span class='notice'>You dismantle the frame</span>"
						new /obj/item/stack/material/steel(src.loc, 5)
						qdel(src)
			if(2)
				if(istype(P, /obj/item/weapon/circuitboard))
					var/obj/item/weapon/circuitboard/B = P
					if(B.board_type == "machine")
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
						user << "<span class='notice'>You add the circuit board to the frame.</span>"
						circuit = P
						user.drop_from_inventory(P,src)
						icon_state = "box_2"
						state = 3
						components = list()
						req_components = circuit.req_components.Copy()
						for(var/A in circuit.req_components)
							req_components[A] = circuit.req_components[A]
						req_component_names = circuit.req_components.Copy()
						for(var/A in req_components)
							var/cp = text2path(A)
							var/obj/ct = new cp() // have to quickly instantiate it get name
							req_component_names[A] = ct.name
						update_desc()
						user << desc
					else
						user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
				else
					if(iswirecutter(P))
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
						user << "<span class='notice'>You remove the cables.</span>"
						state = 1
						icon_state = "box_0"
						var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
						A.amount = 5

			if(3)
				if(iscrowbar(P))
					playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
					state = 2
					circuit.forceMove(src.loc)
					circuit = null
					if(components.len == 0)
						user << "<span class='notice'>You remove the circuit board.</span>"
					else
						user << "<span class='notice'>You remove the circuit board and other components.</span>"
						for(var/obj/item/weapon/W in components)
							W.forceMove(src.loc)
					desc = initial(desc)
					req_components = null
					components = null
					icon_state = "box_1"
				else
					if(isscrewdriver(P))
						var/component_check = 1
						for(var/R in req_components)
							if(req_components[R] > 0)
								component_check = 0
								break
						if(component_check)
							playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
							var/obj/machinery/new_machine = new src.circuit.build_path(loc, dir, FALSE)

							if(new_machine.component_parts)
								new_machine.component_parts.Cut()
							else
								new_machine.component_parts = list()

							src.circuit.construct(new_machine)

							for(var/obj/O in src)
								if(circuit.contain_parts) // things like disposal don't want their parts in them
									O.forceMove(new_machine)
								else
									O.forceMove(null)
								new_machine.component_parts += O

							if(circuit.contain_parts)
								circuit.forceMove(new_machine)
							else
								circuit.forceMove(null)

							new_machine.RefreshParts()
							qdel(src)
					else
						if(istype(P, /obj/item))
							for(var/I in req_components)
								if(istype(P, text2path(I)) && (req_components[I] > 0))
									playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
									if (istype(P, /obj/item/stack))
										var/obj/item/stack/CP = P
										if(CP.get_amount() > 1)
											var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
											var/obj/item/stack/CC = new CP.type(src)
											CC.amount = camt
											CC.update_icon()
											CP.use(camt)
											components += CC
											req_components[I] -= camt
											update_desc()
											break
									user.drop_from_inventory(P,src)
									components += P
									req_components[I]--
									update_desc()
									break
							user << desc
							if(P && P.loc != src && !istype(P, /obj/item/stack))
								user << "<span class='warning'>You cannot add that component to the machine!</span>"


/obj/machinery/constructable_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (!mover)
		return 1
	if(istype(mover,/obj/item/projectile) && density)
		if (prob(50))
			return 1
		else
			return 0
	else if(mover.checkpass(PASSTABLE))
//Animals can run under them, lots of empty space
		return 1
	return ..()
