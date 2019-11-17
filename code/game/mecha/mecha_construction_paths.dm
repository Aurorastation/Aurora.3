////////////////////////////////
///// Construction datums //////
////////////////////////////////

/datum/construction/mecha/custom_action(step, atom/used_atom, mob/user)
	var/obj/item/I = used_atom
	if(I.iswelder())
		var/obj/item/weldingtool/W = I
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0

	else if(I.iswrench())
		playsound(holder, I.usesound, 50, 1)

	else if(I.isscrewdriver())
		playsound(holder, I.usesound, 50, 1)

	else if(I.iswirecutter())
		playsound(holder, I.usesound, 50, 1)

	else if(I.iscoil())
		var/obj/item/stack/cable_coil/C = I
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, ("There's not enough cable to finish the task."))
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, ("There's not enough material in this stack."))
			return 0
		else
			S.use(5)
	return 1

/datum/construction/reversible/mecha/custom_action(index as num, diff as num, atom/used_atom, mob/user as mob)
	var/obj/item/I = used_atom
	if(I.iswelder())
		var/obj/item/weldingtool/W = I
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(I.iswrench())
		playsound(holder, I.usesound, 50, 1)

	else if(I.isscrewdriver())
		playsound(holder, I.usesound, 50, 1)

	else if(I.iswirecutter())
		playsound(holder, I.usesound, 50, 1)

	else if(I.iscoil())
		var/obj/item/stack/cable_coil/C = used_atom
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, ("There's not enough cable to finish the task."))
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, ("There's not enough material in this stack."))
			return 0
		else
			S.use(5)
	return 1


/datum/construction/mecha/ripley_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/ripley_torso),//1
					 list("key"=/obj/item/mecha_parts/part/ripley_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/ripley_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/ripley_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/ripley_right_leg)//5
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.add_overlay("[used_atom.icon_state]+o")
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/ripley(const_holder)
		const_holder.icon = 'icons/mecha/mech_construction.dmi'
		const_holder.icon_state = "ripley0"
		const_holder.density = 1
		const_holder.cut_overlays()
		QDEL_IN(src, 0)

/datum/construction/reversible/mecha/ripley
	result = "/obj/mecha/working/ripley"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured"),
					 //7
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //8
					 list("key"=/obj/item/circuitboard/mecha/ripley/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/circuitboard/mecha/ripley/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added"),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //13
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //14
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(14)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "ripley1"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "ripley2"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "ripley0"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "ripley3"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "ripley1"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "ripley4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "ripley2"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "ripley5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "ripley3"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "ripley6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/circuitboard/mecha/ripley/main(get_turf(holder))
					holder.icon_state = "ripley4"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "ripley7"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "ripley5"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
					holder.icon_state = "ripley8"
				else
					user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
					new /obj/item/circuitboard/mecha/ripley/peripherals(get_turf(holder))
					holder.icon_state = "ripley6"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "ripley9"
				else
					user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
					holder.icon_state = "ripley7"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "ripley10"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "ripley8"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "ripley11"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "ripley9"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					holder.icon_state = "ripley12"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "ripley10"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "ripley13"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "ripley11"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "ripley12"
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_ripley_created",1)
		return



/datum/construction/mecha/gygax_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/gygax_torso),//1
					 list("key"=/obj/item/mecha_parts/part/gygax_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/gygax_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/gygax_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/gygax_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/gygax_head)
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.add_overlay("[used_atom.icon_state]+o")
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/gygax(const_holder)
		const_holder.icon = 'icons/mecha/mech_construction.dmi'
		const_holder.icon_state = "gygax0"
		const_holder.density = 1
		QDEL_IN(src, 0)
		return


/datum/construction/reversible/mecha/gygax
	result = "/obj/mecha/combat/gygax"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					 //2
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/mecha_parts/part/gygax_armour,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Advanced capacitor is secured"),
					 //7
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Advanced capacitor is installed"),
					 //8
					 list("key"=/obj/item/stock_parts/capacitor/adv,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/stock_parts/scanning_module/adv,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/circuitboard/mecha/gygax/targeting,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/circuitboard/mecha/gygax/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/gygax/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added"),
					 //18
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //19
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //20
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(20)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "gygax1"
			if(19)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "gygax2"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "gygax0"
			if(18)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "gygax3"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "gygax1"
			if(17)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "gygax4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "gygax2"
			if(16)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "gygax3"
			if(15)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "gygax6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/circuitboard/mecha/gygax/main(get_turf(holder))
					holder.icon_state = "gygax4"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax7"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "gygax5"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
					holder.icon_state = "gygax8"
				else
					user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
					new /obj/item/circuitboard/mecha/gygax/peripherals(get_turf(holder))
					holder.icon_state = "gygax6"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax9"
				else
					user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
					holder.icon_state = "gygax7"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
					holder.icon_state = "gygax10"
				else
					user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
					new /obj/item/circuitboard/mecha/gygax/targeting(get_turf(holder))
					holder.icon_state = "gygax8"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax11"
				else
					user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
					holder.icon_state = "gygax9"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
					holder.icon_state = "gygax12"
				else
					user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
					new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
					holder.icon_state = "gygax10"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs advanced capacitor to [holder].", "You install advanced capacitor to [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax13"
				else
					user.visible_message("[user] unfastens the advanced scanner module.", "You unfasten the advanced scanner module.")
					holder.icon_state = "gygax11"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
					holder.icon_state = "gygax14"
				else
					user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
					new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
					holder.icon_state = "gygax12"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "gygax15"
				else
					user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
					holder.icon_state = "gygax13"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "gygax16"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "gygax14"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "gygax17"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "gygax15"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs Gygax Armour Plates to [holder].", "You install Gygax Armour Plates to [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax18"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "gygax16"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures Gygax Armour Plates.", "You secure Gygax Armour Plates.")
					holder.icon_state = "gygax19"
				else
					user.visible_message("[user] pries Gygax Armour Plates from [holder].", "You prie Gygax Armour Plates from [holder].")
					new /obj/item/mecha_parts/part/gygax_armour(get_turf(holder))
					holder.icon_state = "gygax17"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds Gygax Armour Plates to [holder].", "You weld Gygax Armour Plates to [holder].")
				else
					user.visible_message("[user] unfastens Gygax Armour Plates.", "You unfasten Gygax Armour Plates.")
					holder.icon_state = "gygax18"
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_gygax_created",1)
		return

/datum/construction/mecha/firefighter_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/ripley_torso),//1
					 list("key"=/obj/item/mecha_parts/part/ripley_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/ripley_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/ripley_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/ripley_right_leg),//5
					 list("key"=/obj/item/clothing/suit/fire)//6
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.add_overlay("[used_atom.icon_state]+o")
		user.drop_from_inventory(used_atom,get_turf(holder))
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/firefighter(const_holder)
		const_holder.icon = 'icons/mecha/mech_construction.dmi'
		const_holder.icon_state = "fireripley0"
		const_holder.density = 1
		QDEL_IN(src, 0)
		return


/datum/construction/reversible/mecha/firefighter
	result = "/obj/mecha/working/ripley/firefighter"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is being installed."),
					 //4
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //5
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //6
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Internal armor is installed"),

					 //7
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured"),
					 //8
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //9
					 list("key"=/obj/item/circuitboard/mecha/ripley/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed"),
					 //11
					 list("key"=/obj/item/circuitboard/mecha/ripley/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //12
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added"),
					 //13
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //14
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //15
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(15)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "fireripley1"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "fireripley2"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "fireripley0"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "fireripley3"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "fireripley1"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "fireripley4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "fireripley2"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "fireripley5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "fireripley3"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "fireripley6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/circuitboard/mecha/ripley/main(get_turf(holder))
					holder.icon_state = "fireripley4"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "fireripley7"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "fireripley5"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
					holder.icon_state = "fireripley8"
				else
					user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
					new /obj/item/circuitboard/mecha/ripley/peripherals(get_turf(holder))
					holder.icon_state = "fireripley6"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "fireripley9"
				else
					user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
					holder.icon_state = "fireripley7"

			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "fireripley10"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "fireripley8"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "fireripley11"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "fireripley9"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] starts to install the external armor layer to [holder].", "You start to install the external armor layer to [holder].")
					holder.icon_state = "fireripley12"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "fireripley10"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
					holder.icon_state = "fireripley13"
				else
					user.visible_message("[user] removes the external armor from [holder].", "You remove the external armor from [holder].")
					var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "fireripley11"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "fireripley14"
				else
					user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
					var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "fireripley12"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "fireripley13"
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_firefighter_created",1)
		return

/datum/construction/mecha/durand_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/durand_torso),//1
					 list("key"=/obj/item/mecha_parts/part/durand_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/durand_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/durand_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/durand_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/durand_head)
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.add_overlay("[used_atom.icon_state]+o")
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/durand(const_holder)
		const_holder.icon = 'icons/mecha/mech_construction.dmi'
		const_holder.icon_state = "durand0"
		const_holder.density = 1
		QDEL_IN(src, 0)
		return

/datum/construction/reversible/mecha/durand
	result = "/obj/mecha/combat/durand"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					 //2
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/mecha_parts/part/durand_armour,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Advanced capacitor is secured"),
					 //7
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Advanced capacitor is installed"),
					 //8
					 list("key"=/obj/item/stock_parts/capacitor/adv,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Advanced scanner module is secured"),
					 //9
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Advanced scanner module is installed"),
					 //10
					 list("key"=/obj/item/stock_parts/scanning_module/adv,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Targeting module is secured"),
					 //11
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Targeting module is installed"),
					 //12
					 list("key"=/obj/item/circuitboard/mecha/durand/targeting,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured"),
					 //13
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //14
					 list("key"=/obj/item/circuitboard/mecha/durand/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured"),
					 //15
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed"),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/durand/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //17
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added"),
					 //18
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //19
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //20
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)


	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(20)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "durand1"
			if(19)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "durand2"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "durand0"
			if(18)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "durand3"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "durand1"
			if(17)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "durand4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "durand2"
			if(16)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "durand5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "durand3"
			if(15)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "durand6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/circuitboard/mecha/durand/main(get_turf(holder))
					holder.icon_state = "durand4"
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "durand7"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "durand5"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
					holder.icon_state = "durand8"
				else
					user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
					new /obj/item/circuitboard/mecha/durand/peripherals(get_turf(holder))
					holder.icon_state = "durand6"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "durand9"
				else
					user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
					holder.icon_state = "durand7"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
					holder.icon_state = "durand10"
				else
					user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
					new /obj/item/circuitboard/mecha/durand/targeting(get_turf(holder))
					holder.icon_state = "durand8"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
					qdel(used_atom)
					holder.icon_state = "durand11"
				else
					user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
					holder.icon_state = "durand9"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
					holder.icon_state = "durand12"
				else
					user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
					new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
					holder.icon_state = "durand10"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs advanced capacitor to [holder].", "You install advanced capacitor to [holder].")
					qdel(used_atom)
					holder.icon_state = "durand13"
				else
					user.visible_message("[user] unfastens the advanced scanner module.", "You unfasten the advanced scanner module.")
					holder.icon_state = "durand11"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] secures the advanced capacitor.", "You secure the advanced capacitor.")
					holder.icon_state = "durand14"
				else
					user.visible_message("[user] removes the advanced capacitor from [holder].", "You remove the advanced capacitor from [holder].")
					new /obj/item/stock_parts/capacitor/adv(get_turf(holder))
					holder.icon_state = "durand12"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "durand15"
				else
					user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
					holder.icon_state = "durand13"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "durand16"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "durand14"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "durand17"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "durand15"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs Durand Armour Plates to [holder].", "You install Durand Armour Plates to [holder].")
					qdel(used_atom)
					holder.icon_state = "durand18"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "durand16"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures Durand Armour Plates.", "You secure Durand Armour Plates.")
					holder.icon_state = "durand19"
				else
					user.visible_message("[user] pries Durand Armour Plates from [holder].", "You prie Durand Armour Plates from [holder].")
					new /obj/item/mecha_parts/part/durand_armour(get_turf(holder))
					holder.icon_state = "durand17"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds Durand Armour Plates to [holder].", "You weld Durand Armour Plates to [holder].")
				else
					user.visible_message("[user] unfastens Durand Armour Plates.", "You unfasten Durand Armour Plates.")
					holder.icon_state = "durand18"
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_durand_created",1)
		return


/datum/construction/mecha/phazon_chassis
	result = "/obj/mecha/combat/phazon"
	steps = list(list("key"=/obj/item/mecha_parts/part/phazon_torso),//1
					 list("key"=/obj/item/mecha_parts/part/phazon_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/phazon_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/phazon_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/phazon_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/phazon_head)
					)

/datum/construction/mecha/phazon_chassis/custom_action(step, atom/used_atom, mob/user)
	user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
	holder.add_overlay("[used_atom.icon_state]+o")
	qdel(used_atom)
	return 1

/datum/construction/mecha/phazon_chassis/action(atom/used_atom,mob/user as mob)
	return check_all_steps(used_atom,user)

/datum/construction/mecha/phazon_chassis/spawn_result()
	var/obj/item/mecha_parts/chassis/const_holder = holder
	const_holder.construct = new /datum/construction/reversible/mecha/phazon(const_holder)
	const_holder.icon = 'icons/mecha/mech_construction.dmi'
	const_holder.icon_state = "phazon0"
	const_holder.density = TRUE
	QDEL_IN(src, 0)
	return

/datum/construction/reversible/mecha/phazon
	result = "/obj/mecha/combat/phazon"
	steps = list(
					//1
					list("key"=/obj/item/anomaly_core,
						 "backkey"=null, //Cannot remove the anomaly core once it's in
						 "desc"="Anomaly core socket is open and awaiting connection."),

					//2
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					 //3
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //4
					 list("key"=/obj/item/mecha_parts/part/phazon_armour,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Phase armor is welded."),
					 //5
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Phase armor is wrenched."),
					 //6
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Phase armor is installed."),
					 //7
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The bluespace crystal is engaged."),
					 //8
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wirecutters,
					 		"desc"="The bluespace crystal is connected."),
					 //9
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="The bluespace crystal is installed."),
					 //10
					 list("key"=/obj/item/bluespace_crystal,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Super capacitor is secured."),
					 //12
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Super capacitor is installed."),
					 //12
					 list("key"=/obj/item/stock_parts/capacitor/super,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Phasic scanner module is secured."),
					 //13
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Phasic scanner module is installed."),
					 //14
					 list("key"=/obj/item/stock_parts/scanning_module/phasic,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Weapon control module is secured."),
					 //15
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Weapon control is installed."),
					 //16
					 list("key"=/obj/item/circuitboard/mecha/phazon/targeting,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured."),
					 //17
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //18
					 list("key"=/obj/item/circuitboard/mecha/phazon/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured."),
					 //19
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed."),
					 //20
					 list("key"=/obj/item/circuitboard/mecha/phazon/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted."),
					 //21
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added."),
					 //22
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //23
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //24
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/phazon/action(atom/used_atom,mob/user as mob)
	return check_step(used_atom,user)

/datum/construction/reversible/mecha/phazon/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(24)
			user.visible_message("[user] connects the [holder] hydraulic systems", "<span class='notice'>You connect the [holder] hydraulic systems.</span>")
			holder.icon_state = "phazon1"
		if(23)
			if(diff==FORWARD)
				user.visible_message("[user] activates the [holder] hydraulic systems.", "<span class='notice'>You activate the [holder] hydraulic systems.</span>")
				holder.icon_state = "phazon2"
			else
				user.visible_message("[user] disconnects the [holder] hydraulic systems", "<span class='notice'>You disconnect the [holder] hydraulic systems.</span>")
				holder.icon_state = "phazon0"
		if(22)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to the [holder].", "<span class='notice'>You add the wiring to the [holder].</span>")
				holder.icon_state = "phazon3"
			else
				user.visible_message("[user] deactivates the [holder] hydraulic systems.", "<span class='notice'>You deactivate the [holder] hydraulic systems.</span>")
				holder.icon_state = "phazon1"
		if(21)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of the [holder].", "<span class='notice'>You adjust the wiring of the [holder].</span>")
				holder.icon_state = "phazon4"
			else
				user.visible_message("[user] removes the wiring from the [holder].", "<span class='notice'>You remove the wiring from the [holder].</span>")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "phazon2"
		if(20)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into the [holder].", "<span class='notice'>You install the central computer mainboard into the [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "phazon5"
			else
				user.visible_message("[user] disconnects the wiring of the [holder].", "<span class='notice'>You disconnect the wiring of the [holder].</span>")
				holder.icon_state = "phazon3"
		if(19)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "<span class='notice'>You secure the mainboard.</span>")
				holder.icon_state = "phazon6"
			else
				user.visible_message("[user] removes the central control module from the [holder].", "<span class='notice'>You remove the central computer mainboard from the [holder].</span>")
				new /obj/item/circuitboard/mecha/phazon/main(get_turf(holder))
				holder.icon_state = "phazon4"
		if(18)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into the [holder].", "<span class='notice'>You install the peripherals control module into the [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "phazon7"
			else
				user.visible_message("[user] unfastens the mainboard.", "<span class='notice'>You unfasten the mainboard.</span>")
				holder.icon_state = "phazon5"
		if(17)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "<span class='notice'>You secure the peripherals control module.</span>")
				holder.icon_state = "phazon8"
			else
				user.visible_message("[user] removes the peripherals control module from the [holder].", "<span class='notice'>You remove the peripherals control module from the [holder].</span>")
				new /obj/item/circuitboard/mecha/phazon/peripherals(get_turf(holder))
				holder.icon_state = "phazon6"
		if(16)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into the [holder].", "<span class='notice'>You install the weapon control module into the [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "phazon9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "<span class='notice'>You unfasten the peripherals control module.</span>")
				holder.icon_state = "phazon7"
		if(15)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "<span class='notice'>You secure the weapon control module.</span>")
				holder.icon_state = "phazon10"
			else
				user.visible_message("[user] removes the weapon control module from the [holder].", "<span class='notice'>You remove the weapon control module from the [holder].</span>")
				new /obj/item/circuitboard/mecha/phazon/targeting(get_turf(holder))
				holder.icon_state = "phazon8"
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] installs phasic scanner module to the [holder].", "<span class='notice'>You install scanner module to the [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "phazon11"
			else
				user.visible_message("[user] unfastens the weapon control module.", "<span class='notice'>You unfasten the weapon control module.</span>")
				holder.icon_state = "phazon9"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] secures the phasic scanner module.", "<span class='notice'>You secure the scanner module.</span>")
				holder.icon_state = "phazon12"
			else
				user.visible_message("[user] removes the phasic scanner module from the [holder].", "<span class='notice'>You remove the scanner module from the [holder].</span>")
				new /obj/item/stock_parts/scanning_module/phasic(get_turf(holder))
				holder.icon_state = "phazon10"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs super capacitor to the [holder].", "<span class='notice'>You install capacitor to the [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "phazon13"
			else
				user.visible_message("[user] unfastens the phasic scanner module.", "<span class='notice'>You unfasten the scanner module.</span>")
				holder.icon_state = "phazon11"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the super capacitor.", "<span class='notice'>You secure the capacitor.</span>")
				holder.icon_state = "phazon14"
			else
				user.visible_message("[user] removes the super capacitor from the [holder].", "<span class='notice'>You remove the capacitor from the [holder].</span>")
				new /obj/item/stock_parts/capacitor/super(get_turf(holder))
				holder.icon_state = "phazon12"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the bluespace crystal.", "<span class='notice'>You install the bluespace crystal.</span>")
				qdel(used_atom)
				holder.icon_state = "phazon15"
			else
				user.visible_message("[user] unsecures the super capacitor from the [holder].", "<span class='notice'>You unsecure the capacitor from the [holder].</span>")
				holder.icon_state = "phazon13"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] connects the bluespace crystal.", "<span class='notice'>You connect the bluespace crystal.</span>")
				holder.icon_state = "phazon16"
			else
				user.visible_message("[user] removes the bluespace crystal from the [holder].", "<span class='notice'>You remove the bluespace crystal from the [holder].</span>")
				new /obj/item/bluespace_crystal(get_turf(holder))
				holder.icon_state = "phazon14"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] engages the bluespace crystal.", "<span class='notice'>You engage the bluespace crystal.</span>")
				holder.icon_state = "phazon17"
			else
				user.visible_message("[user] disconnects the bluespace crystal from the [holder].", "<span class='notice'>You disconnect the bluespace crystal from the [holder].</span>")
				holder.icon_state = "phazon15"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] installs the phase armor layer to the [holder].", "<span class='notice'>You install the phase armor layer to the [holder].</span>")
				holder.icon_state = "phazon18"
			else
				user.visible_message("[user] disengages the bluespace crystal.", "<span class='notice'>You disengage the bluespace crystal.</span>")
				holder.icon_state = "phazon16"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] secures the phase armor layer.", "<span class='notice'>You secure the phase armor layer.</span>")
				holder.icon_state = "phazon19"
			else
				user.visible_message("[user] pries the phase armor layer from the [holder].", "<span class='notice'>You pry the phase armor layer from the [holder].</span>")
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "phazon17"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] welds the phase armor layer to the [holder].", "<span class='notice'>You weld the phase armor layer to the [holder].</span>")
				holder.icon_state = "phazon20"
			else
				user.visible_message("[user] unfastens the phase armor layer.", "<span class='notice'>You unfasten the phase armor layer.</span>")
				holder.icon_state = "phazon18"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] installs Phazon Armor Plates to the [holder].", "<span class='notice'>You install Phazon Armor Plates to the [holder].</span>")
				qdel(used_atom)
				holder.icon_state = "phazon21"
			else
				user.visible_message("[user] cuts phase armor layer from the [holder].", "<span class='notice'>You cut the phase armor layer from the [holder].</span>")
				holder.icon_state = "phazon19"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] secures Phazon Armor Plates.", "<span class='notice'>You secure Phazon Armor Plates.</span>")
				holder.icon_state = "phazon22"
			else
				user.visible_message("[user] pries Phazon Armor Plates from the [holder].", "<span class='notice'>You pry Phazon Armor Plates from the [holder].</span>")
				new /obj/item/mecha_parts/part/phazon_armour(get_turf(holder))
				holder.icon_state = "phazon20"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] welds Phazon Armor Plates to the [holder].", "<span class='notice'>You weld Phazon Armor Plates to the [holder].</span>")
			else
				user.visible_message("[user] unfastens Phazon Armor Plates.", "<span class='notice'>You unfasten Phazon Armor Plates.</span>")
				holder.icon_state = "phazon21"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] carefully inserts the anomaly core into \the [holder] and secures it.", "<span class='notice'>You slowly place the anomaly core into its socket and close its chamber.</span>")
				qdel(used_atom)
	return 1

/datum/construction/mecha/phazon_chassis/spawn_result()
	..()
	feedback_inc("mecha_phazon_created",1)
	return

/datum/construction/mecha/odysseus_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/odysseus_torso),//1
					 list("key"=/obj/item/mecha_parts/part/odysseus_head),//2
					 list("key"=/obj/item/mecha_parts/part/odysseus_left_arm),//3
					 list("key"=/obj/item/mecha_parts/part/odysseus_right_arm),//4
					 list("key"=/obj/item/mecha_parts/part/odysseus_left_leg),//5
					 list("key"=/obj/item/mecha_parts/part/odysseus_right_leg)//6
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.add_overlay("[used_atom.icon_state]+o")
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/odysseus(const_holder)
		const_holder.icon = 'icons/mecha/mech_construction.dmi'
		const_holder.icon_state = "odysseus0"
		const_holder.density = 1
		QDEL_IN(src, 0)
		return


/datum/construction/reversible/mecha/odysseus
	result = "/obj/mecha/medical/odysseus"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured"),
					 //7
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //8
					 list("key"=/obj/item/circuitboard/mecha/odysseus/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/circuitboard/mecha/odysseus/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added"),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //13
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //14
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(14)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "odysseus1"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
					holder.icon_state = "odysseus2"
				else
					user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
					holder.icon_state = "odysseus0"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "odysseus3"
				else
					user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
					holder.icon_state = "odysseus1"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "odysseus4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "odysseus2"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "odysseus5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "odysseus3"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "odysseus6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new /obj/item/circuitboard/mecha/odysseus/main(get_turf(holder))
					holder.icon_state = "odysseus4"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "odysseus7"
				else
					user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
					holder.icon_state = "odysseus5"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
					holder.icon_state = "odysseus8"
				else
					user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
					new /obj/item/circuitboard/mecha/odysseus/peripherals(get_turf(holder))
					holder.icon_state = "odysseus6"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
					holder.icon_state = "odysseus9"
				else
					user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
					holder.icon_state = "odysseus7"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
					holder.icon_state = "odysseus10"
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
					MS.amount = 5
					holder.icon_state = "odysseus8"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
					holder.icon_state = "odysseus11"
				else
					user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
					holder.icon_state = "odysseus9"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs [used_atom] layer to [holder].", "You install external reinforced armor layer to [holder].")

					holder.icon_state = "odysseus12"
				else
					user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
					holder.icon_state = "odysseus10"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
					holder.icon_state = "odysseus13"
				else
					var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
					MS.amount = 5
					user.visible_message("[user] pries [MS] from [holder].", "You prie [MS] from [holder].")
					holder.icon_state = "odysseus11"
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
					holder.icon_state = "odysseus14"
				else
					user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
					holder.icon_state = "odysseus12"
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_odysseus_created",1)
		return


/////// Hermes

/datum/construction/mecha/hermes_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/hermes_torso),//1
					 list("key"=/obj/item/mecha_parts/part/hermes_head),//2
					 list("key"=/obj/item/mecha_parts/part/hermes_left_arm),//3
					 list("key"=/obj/item/mecha_parts/part/hermes_right_arm),//4
					 list("key"=/obj/item/mecha_parts/part/hermes_left_leg),//5
					 list("key"=/obj/item/mecha_parts/part/hermes_right_leg)//6
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.add_overlay("[used_atom.icon_state]+o")
		qdel(used_atom)
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/mecha/hermes(const_holder)
		const_holder.icon = 'icons/mecha/mech_construction.dmi'
		const_holder.icon_state = "hermes0"
		const_holder.density = 1
		QDEL_IN(src, 0)
		return


/datum/construction/reversible/mecha/hermes
	result = "/obj/mecha/working/hermes"
	steps = list(
					//1
					list("key"=/obj/item/weldingtool,
							"backkey"=/obj/item/wrench,
							"desc"="External armor is wrenched."),
					//2
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="External armor is installed."),
					 //3
					 list("key"=/obj/item/stack/material/plasteel,
					 		"backkey"=/obj/item/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //4
					 list("key"=/obj/item/weldingtool,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //5
					 list("key"=/obj/item/wrench,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Internal armor is installed"),
					 //6
					 list("key"=/obj/item/stack/material/steel,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Peripherals control module is secured"),
					 //7
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Peripherals control module is installed"),
					 //8
					 list("key"=/obj/item/circuitboard/mecha/hermes/peripherals,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="Central control module is secured"),
					 //9
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/crowbar,
					 		"desc"="Central control module is installed"),
					 //10
					 list("key"=/obj/item/circuitboard/mecha/hermes/main,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is adjusted"),
					 //11
					 list("key"=/obj/item/wirecutters,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The wiring is added"),
					 //12
					 list("key"=/obj/item/stack/cable_coil,
					 		"backkey"=/obj/item/screwdriver,
					 		"desc"="The hydraulic systems are active."),
					 //13
					 list("key"=/obj/item/screwdriver,
					 		"backkey"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are connected."),
					 //14
					 list("key"=/obj/item/wrench,
					 		"desc"="The hydraulic systems are disconnected.")
					)

/datum/construction/reversible/mecha/hermes/action(atom/used_atom,mob/user as mob)
	return check_step(used_atom,user)

/datum/construction/reversible/mecha/hermes/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return 0

	//TODO: better messages.
	switch(index)
		if(14)
			user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
			holder.icon_state = "hermes1"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] activates [holder] hydraulic systems.", "You activate [holder] hydraulic systems.")
				holder.icon_state = "hermes2"
			else
				user.visible_message("[user] disconnects [holder] hydraulic systems", "You disconnect [holder] hydraulic systems.")
				holder.icon_state = "hermes0"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				holder.icon_state = "hermes4"
			else
				user.visible_message("[user] deactivates [holder] hydraulic systems.", "You deactivate [holder] hydraulic systems.")
				holder.icon_state = "hermes1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
				holder.icon_state = "hermes5"
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				holder.icon_state = "hermes3"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(used_atom)
				holder.icon_state = "hermes5"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				holder.icon_state = "hermes3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
				holder.icon_state = "hermes6"
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new /obj/item/circuitboard/mecha/hermes/main(get_turf(holder))
				holder.icon_state = "hermes4"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				qdel(used_atom)
				holder.icon_state = "hermes7"
			else
				user.visible_message("[user] unfastens the mainboard.", "You unfasten the mainboard.")
				holder.icon_state = "hermes5"
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the peripherals control module.", "You secure the peripherals control module.")
				holder.icon_state = "hermes8"
			else
				user.visible_message("[user] removes the peripherals control module from [holder].", "You remove the peripherals control module from [holder].")
				new /obj/item/circuitboard/mecha/hermes/peripherals(get_turf(holder))
				holder.icon_state = "hermes6"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				holder.icon_state = "hermes9"
			else
				user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
				holder.icon_state = "hermes7"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
				holder.icon_state = "hermes10"
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				holder.icon_state = "hermes8"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
				holder.icon_state = "hermes11"
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
				holder.icon_state = "hermes9"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs [used_atom] layer to [holder].", "You install external reinforced armor layer to [holder].")

				holder.icon_state = "hermes12"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
				holder.icon_state = "hermes10"
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
				holder.icon_state = "hermes13"
			else
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				user.visible_message("[user] pries [MS] from [holder].", "You prie [MS] from [holder].")
				holder.icon_state = "hermes11"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				holder.icon_state = "hermes14"
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				holder.icon_state = "hermes12"
	return 1

/datum/construction/reversible/mecha/hermes/spawn_result()
	..()
	feedback_inc("mecha_hermes_created",1)
	return