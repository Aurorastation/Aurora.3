#define BLUEPRINT_STATE 1
#define WIRING_STATE 2
#define CIRCUITBOARD_STATE 3
#define COMPONENT_STATE 4

//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery
/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine blueprint"
	desc = "A holo-blueprint for a machine."
	description_info = "A blueprint that allows the user to rotate the direction the final result will be built in. Putting better components in now, will cause the machine made to have better components and functionality."
	var/machine_description
	var/components_description
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "blueprint_0"
	density = FALSE
	anchored = FALSE
	use_power = 0
	obj_flags = OBJ_FLAG_ROTATABLE
	var/obj/item/circuitboard/circuit
	var/list/components = list()
	var/list/req_components = list()
	var/list/req_component_names = list()
	var/state = 1
	var/pitch_toggle = 1

/obj/machinery/constructable_frame/examine(mob/user)
	. = ..()
	switch(state)
		if(BLUEPRINT_STATE)
			to_chat(user, FONT_SMALL(SPAN_NOTICE("<i>Click on \the [src] to finalize its direction.</i>")))
			to_chat(user, FONT_SMALL(SPAN_WARNING("Use a wirecutter or a plasma cutter to disassemble \the [src].")))
		if(WIRING_STATE)
			to_chat(user, FONT_SMALL(SPAN_NOTICE("<i>Add cable coil to wire \the [src].</i>")))
			to_chat(user, FONT_SMALL(SPAN_WARNING("Use a wrench or a plasma cutter to disassemble \the [src].")))
		if(CIRCUITBOARD_STATE)
			to_chat(user, FONT_SMALL(SPAN_NOTICE("<i>Add the desired circuitboard.</i>")))
			to_chat(user, FONT_SMALL(SPAN_WARNING("Use a wirecutter to remove the cables.")))
		if(COMPONENT_STATE)
			to_chat(user, FONT_SMALL(SPAN_NOTICE("<i>Add the required components. Use the screwdriver to complete the machine.</i>")))
			to_chat(user, FONT_SMALL(SPAN_WARNING("Use a crowbar to pry out the circuitboard and the components out.")))
	if(machine_description)
		to_chat(user, FONT_SMALL(SPAN_NOTICE(machine_description)))
	if(components_description)
		to_chat(user, FONT_SMALL(SPAN_NOTICE(components_description)))

/obj/machinery/constructable_frame/proc/update_component_desc()
	var/D
	if(length(req_components))
		var/list/component_list = list()
		for(var/I in req_components)
			if(req_components[I] > 0)
				component_list += "<b>[num2text(req_components[I])] [req_component_names[I]]\s</b>"
		D = "Requires [english_list(component_list)]."
	components_description = D

/obj/machinery/constructable_frame/machine_frame/attack_hand(mob/user)
	if(state == BLUEPRINT_STATE)
		to_chat(user, SPAN_NOTICE("You begin to finalize the blueprint..."))
		if(do_after(user, 20, act_target = src))
			if(state != BLUEPRINT_STATE)
				return
			to_chat(user, SPAN_NOTICE("You finalize the blueprint."))
			playsound(get_turf(src), 'sound/items/poster_being_created.ogg', 75, TRUE)
			state = WIRING_STATE
	else
		..()

/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/P, mob/user)
	switch(state)
		if(BLUEPRINT_STATE)
			if(P.iswirecutter() || istype(P, /obj/item/gun/energy/plasmacutter))
				playsound(get_turf(src), 'sound/items/poster_ripped.ogg', 75, TRUE)
				to_chat(user, SPAN_NOTICE("You decide to scrap the blueprint."))
				new /obj/item/stack/material/steel(get_turf(src), 2)
				qdel(src)
		if(WIRING_STATE)
			if(P.iscoil())
				var/obj/item/stack/cable_coil/C = P
				if(C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("You need five lengths of cable to add them to the blueprint."))
					return
				playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, TRUE)
				to_chat(user, SPAN_NOTICE("You start wiring up the blueprint..."))
				if(do_after(user, 20, act_target = src))
					if(state == WIRING_STATE && C.use(5))
						to_chat(user, SPAN_NOTICE("You wire up the blueprint."))
						state = CIRCUITBOARD_STATE
						icon_state = "blueprint_1"
			else
				if(P.iswrench())
					playsound(get_turf(src), P.usesound, 75, TRUE)
					to_chat(user, SPAN_NOTICE("You dismantle the blueprint."))
					new /obj/item/stack/material/steel(get_turf(src), 2)
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
		if(CIRCUITBOARD_STATE)
			if(istype(P, /obj/item/circuitboard))
				var/obj/item/circuitboard/B = P
				if(B.board_type == "machine")
					playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, TRUE)
					to_chat(user, SPAN_NOTICE("You add the circuit board to the blueprint."))
					circuit = P
					user.drop_from_inventory(P, src)
					var/obj/machine = new circuit.build_path
					name = "[machine.name] blueprint"
					desc = "A holo-blueprint for a [machine.name]."
					machine_description = "This blueprint will become a <b>[capitalize_first_letters(machine.name)]</b>: [machine.desc]"
					qdel(machine)
					icon_state = "blueprint_2"
					state = COMPONENT_STATE
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						var/cp = text2path(A)
						var/obj/ct = new cp() // have to quickly instantiate it get name
						req_component_names[A] = ct.name
					update_component_desc()
					to_chat(user, SPAN_NOTICE("[components_description]"))
				else
					to_chat(user, SPAN_WARNING("This blueprint does not accept circuit boards of this type!"))
			else
				if(P.iswirecutter())
					playsound(get_turf(src), P.usesound, 50, TRUE, pitch_toggle)
					to_chat(user, SPAN_NOTICE("You remove the cables."))
					state = WIRING_STATE
					icon_state = "blueprint_0"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(get_turf(src))
					A.amount = 5
					A.update_icon()

		if(COMPONENT_STATE)
			if(P.iscrowbar())
				playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, TRUE)
				state = CIRCUITBOARD_STATE
				circuit.forceMove(get_turf(src))
				circuit = null
				if(components.len == 0)
					to_chat(user, SPAN_NOTICE("You remove the circuit board."))
				else
					to_chat(user, SPAN_NOTICE("You remove the circuit board and other components."))
					for(var/obj/item/W in components)
						W.forceMove(get_turf(src))
				desc = initial(desc)
				machine_description = null
				components_description = null
				req_components = list()
				components = list()
				icon_state = "blueprint_2"
			else
				if(P.isscrewdriver())
					var/component_check = TRUE
					for(var/R in req_components)
						if(req_components[R] > 0)
							component_check = FALSE
							break
					if(component_check)
						playsound(get_turf(src), P.usesound, 50, TRUE)
						var/obj/machinery/new_machine = new circuit.build_path(loc, dir, FALSE)
						if(new_machine.component_parts)
							new_machine.component_parts.Cut()
						else
							new_machine.component_parts = list()
						circuit.construct(new_machine)

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
						new_machine.anchored = TRUE
						qdel(src)
				else
					if(istype(P, /obj/item))
						for(var/I in req_components)
							if(istype(P, text2path(I)) && (req_components[I] > 0))
								playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, TRUE)
								if(istype(P, /obj/item/stack))
									var/obj/item/stack/CP = P
									if(CP.get_amount() > 1)
										var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
										var/obj/item/stack/CC = new CP.type(src)
										CC.amount = camt
										CC.update_icon()
										CP.use(camt)
										components += CC
										req_components[I] -= camt
										update_component_desc()
										break
								user.drop_from_inventory(P,src)
								components += P
								req_components[I]--
								update_component_desc()
								break
						to_chat(user, SPAN_NOTICE("[components_description]"))
						if(P?.loc != src && !istype(P, /obj/item/stack))
							to_chat(user, SPAN_WARNING("You cannot add that component to the machine!."))


/obj/machinery/constructable_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return TRUE
	if(istype(mover,/obj/item/projectile) && density)
		if(prob(50))
			return TRUE
		else
			return FALSE
	else if(mover.checkpass(PASSTABLE)) // Animals can run under them, lots of empty space
		return TRUE
	return ..()

/obj/machinery/constructable_frame/temp_deco
	name = "machine frame"
	desc = "An old and dusty machine frame that once housed a machine of some kind."
	icon_state = "box_0"
	anchored = TRUE
	density = TRUE

/obj/machinery/constructable_frame/temp_deco/attackby(obj/item/P, mob/user)
	if(P.iswrench())
		playsound(get_turf(src), P.usesound, 75, 1)
		to_chat(user, SPAN_NOTICE("You dismantle \the [src]."))
		new /obj/item/stack/material/steel(get_turf(src), 5)
		qdel(src)

#undef BLUEPRINT_STATE
#undef WIRING_STATE
#undef CIRCUITBOARD_STATE
#undef COMPONENT_STATE