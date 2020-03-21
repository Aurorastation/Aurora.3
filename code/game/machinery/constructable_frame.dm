//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery/

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine blueprint"
	desc = "A holo blueprint for a machine."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "blueprint_0"
	density = 0
	anchored = 0
	use_power = 0
	obj_flags = OBJ_FLAG_ROTATABLE
	var/obj/item/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1
	var/pitch_toggle = 1


/obj/machinery/constructable_frame/proc/update_desc()
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
				if(P.ismultitool())
					to_chat(user, span("notice", "You begin to finalize the blueprint."))
					if(do_after(user, 20) && state == 1)
						to_chat(user, span("notice", "You finalize the blueprint."))
						playsound(src.loc, 'sound/items/poster_being_created.ogg', 75, 1)
						state = 2
				else
					if(P.iswirecutter() || istype(P, /obj/item/gun/energy/plasmacutter))
						playsound(src.loc, 'sound/items/poster_ripped.ogg', 75, 1)
						to_chat(user, span("notice", "You decide to scrap the blueprint."))
						new /obj/item/stack/material/steel(src.loc, 2)
						qdel(src)
			if(2)
				if(P.iscoil())
					var/obj/item/stack/cable_coil/C = P
					if (C.get_amount() < 5)
						to_chat(user, span("notice", "You need five lengths of cable to add them to the blueprint."))
						return
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, span("notice", "You start to add cables to the blueprint."))
					if(do_after(user, 20) && state == 2)
						if(C.use(5))
							to_chat(user, "<span class='notice'>You add cables to the frame.</span>")
							state = 3
							icon_state = "blueprint_1"
				else
					if(P.iswrench())
						playsound(src.loc, P.usesound, 75, 1)
						to_chat(user, SPAN_NOTICE("You dismantle the blueprint."))
						new /obj/item/stack/material/steel(src.loc, 2)
						qdel(src)
					else if(istype(P, /obj/item/gun/energy/plasmacutter))
						var/obj/item/gun/energy/plasmacutter/PC = P
						if(!PC.power_supply)
							to_chat(user, SPAN_WARNING("\The [src] doesn't have a power supply installed!"))
							return
						playsound(get_turf(src), PC.fire_sound, 75, TRUE)
						to_chat(user, SPAN_NOTICE("You dismantle the blueprint."))
						new /obj/item/stack/material/steel(get_turf(src), 2)
						qdel(src)
			if(3)
				if(istype(P, /obj/item/circuitboard))
					var/obj/item/circuitboard/B = P
					if(B.board_type == "machine")
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
						to_chat(user, span("notice", "You add the circuit board to the blueprint."))
						circuit = P
						user.drop_from_inventory(P,src)
						icon_state = "blueprint_2"
						state = 4
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
						to_chat(user, desc)
					else
						to_chat(user, span("warning", "This blueprint does not accept circuit boards of this type!"))
				else
					if(P.iswirecutter())
						playsound(src.loc, P.usesound, 50, 1, pitch_toggle)
						to_chat(user, span("notice", "You remove the cables."))
						state = 2
						icon_state = "blueprint_0"
						var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
						A.amount = 5

			if(4)
				if(P.iscrowbar())
					playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
					state = 3
					circuit.forceMove(src.loc)
					circuit = null
					if(components.len == 0)
						to_chat(user, span("notice", "You remove the circuit board."))
					else
						to_chat(user, span("notice", "You remove the circuit board and other components."))
						for(var/obj/item/W in components)
							W.forceMove(src.loc)
					desc = initial(desc)
					req_components = null
					components = null
					icon_state = "blueprint_2"
				else
					if(P.isscrewdriver())
						var/component_check = 1
						for(var/R in req_components)
							if(req_components[R] > 0)
								component_check = 0
								break
						if(component_check)
							playsound(src.loc,  P.usesound, 50, 1)
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
							anchored = 1
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
							to_chat(user, desc)
							if(P && P.loc != src && !istype(P, /obj/item/stack))
								to_chat(user, span("notice", "You cannot add that component to the machine!."))


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

/obj/machinery/constructable_frame/temp_deco
	name = "machine frame"
	desc = "An old and dusty machine frame that once housed a machine of some kind."
	icon_state = "box_0"
	anchored = 1
	density = 1

/obj/machinery/constructable_frame/temp_deco/attackby(obj/item/P as obj, mob/user as mob)
	if(P.iswrench())
		playsound(src.loc, P.usesound, 75, 1)
		to_chat(user, "<span class='notice'>You dismantle [src]</span>")
		new /obj/item/stack/material/steel(src.loc, 5)
		qdel(src)