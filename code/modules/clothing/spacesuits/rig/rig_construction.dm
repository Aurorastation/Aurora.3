/obj/item/rig_assembly
	name = "hardsuit control module assembly"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "An assembly frame of back-mounted hardsuit deployment and control mechanism."
	slot_flags = SLOT_BACK
	w_class = 4
	var/obj/item/weapon/circuitboard/board_type = null
	var/obj/item/weapon/circuitboard/target_board_type = null
	var/obj/item/weapon/rig/rig_type = /obj/item/weapon/rig

	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_MAGNET = 3, TECH_POWER = 3)
	var/datum/construction/reversible/rig_assembly/construct
	flags = CONDUCT

/obj/item/rig_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(!construct || !construct.action(W, user))
		..()
	return

/obj/item/rig_assembly/New()
	..()
	construct = new /datum/construction/reversible/rig_assembly/civilian(src)
	construct.board_type = board_type
	construct.steps[5]["key"] = board_type // defining board in construction step
	construct.result = "[rig_type]"

/obj/item/rig_assembly/combat/New()
	..()
	construct = new /datum/construction/reversible/rig_assembly/combat(src)
	construct.board_type = board_type
	construct.target_board_type = target_board_type	
	construct.steps[12]["key"] = board_type // defining board in construction step
	construct.steps[10]["key"] = target_board_type
	construct.result = "[rig_type]"

////////////////////////
////CIVILIAN ASEMBLY////
////////////////////////

/obj/item/rig_assembly/ce
	name = "advanced voidsuit control module assembly"
	desc = "An assembly frame for an advanced voidsuit that protects against hazardous, low pressure environments."
	board_type = /obj/item/weapon/circuitboard/rig_assembly/civilian/ce
	rig_type = /obj/item/weapon/rig/ce

/obj/item/rig_assembly/eva
	name = "EVA suit control module assembly"
	desc = "An assembly for light rig that is desiged for repairs and maintenance to the outside of habitats and vessels."
	board_type = /obj/item/weapon/circuitboard/rig_assembly/civilian/eva
	rig_type = /obj/item/weapon/rig/eva

/obj/item/rig_assembly/industrial
	name = "industrial suit control module assembly"
	desc = "An assembly for a heavy, powerful rig used by construction crews and mining corporations."
	board_type = /obj/item/weapon/circuitboard/rig_assembly/civilian/industrial
	rig_type = /obj/item/weapon/rig/industrial

/obj/item/rig_assembly/hazmat
	name = "AMI control module assembly"
	desc = "An assembly for Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	board_type = /obj/item/weapon/circuitboard/rig_assembly/civilian/hazmat
	rig_type = /obj/item/weapon/rig/hazmat

/obj/item/rig_assembly/medical
	name = "rescue suit control module assembly"
	desc = "An assembly for a durable suit designed for medical rescue in high risk areas."
	board_type = /obj/item/weapon/circuitboard/rig_assembly/civilian/medical
	rig_type = /obj/item/weapon/rig/medical

///////////////////////
////COMBAT ASSEMBLY////
///////////////////////

/obj/item/rig_assembly/combat
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)

/obj/item/rig_assembly/combat/hazard
	name = "hazard hardsuit control module"
	desc = "An assembly for a security hardsuit designed for prolonged EVA in dangerous environments."
	rig_type = /obj/item/weapon/rig/hazard
	board_type = /obj/item/weapon/circuitboard/rig_assembly/combat/hazard
	target_board_type = /obj/item/weapon/circuitboard/rig_assembly/combat/targeting/hazard

/obj/item/rig_assembly/combat/combat
	name = "combat hardsuit control module assembly"
	desc = "An assembly frame for a sleek and dangerous hardsuit for active combat."
	rig_type = /obj/item/weapon/rig/combat
	board_type = /obj/item/weapon/circuitboard/rig_assembly/combat/combat
	target_board_type = /obj/item/weapon/circuitboard/rig_assembly/combat/targeting/combat

////////////////////////
////ILLEGAL ASSEMBLY////
////////////////////////

/obj/item/rig_assembly/illegal
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 4)

/obj/item/rig_assembly/illegal/hacker
	name = "light suit control module assembly"
	desc = "An assembly for a lighter, less armoured rig suit."
	rig_type = /obj/item/weapon/rig/light/hacker
	board_type = /obj/item/weapon/circuitboard/rig_assembly/illegal/hacker
	target_board_type = /obj/item/weapon/circuitboard/rig_assembly/illegal/targeting/hacker

/obj/item/rig_assembly/illegal/stealth
	name = "stealth suit control module assembly"
	desc = "An assembly for a highly advanced and expensive suit designed for covert operations."
	rig_type = /obj/item/weapon/rig/light/stealth
	board_type = /obj/item/weapon/circuitboard/rig_assembly/illegal/stealth
	target_board_type = /obj/item/weapon/circuitboard/rig_assembly/illegal/targeting/stealth
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 6, TECH_ILLEGAL = 6)

/datum/construction/reversible/rig_assembly
	result = null
	var/obj/item/weapon/circuitboard/rig_assembly/board_type = null
	var/obj/item/weapon/circuitboard/rig_assembly/target_board_type = null

/datum/construction/reversible/rig_assembly/custom_action(index as num, diff as num, atom/used_atom, mob/user as mob)
	var/obj/item/I = used_atom
	if(I.iswelder())
		var/obj/item/weapon/weldingtool/W = I
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(I.iswrench())
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(I.isscrewdriver())
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(I.iswirecutter())
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(I.iscoil())
		var/obj/item/stack/cable_coil/C = used_atom
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, "There's not enough cable to finish the task.")
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, "There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1

/datum/construction/reversible/rig_assembly/civilian
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched"),
					//2
					list("key"=/obj/item/weapon/wrench,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="External armor is installed"),
					//3
					list("key"=/obj/item/stack/material/steel,
							"backkey"=/obj/item/weapon/screwdriver,
							"desc"="Central control module is secured"),
					//4
					list("key"=/obj/item/weapon/screwdriver,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="Central control module is installed"),
					//5
					list("key"=null,
							"backkey"=/obj/item/weapon/wirecutters,
							"desc"="The wiring is adjusted"),
					//6
					list("key"=/obj/item/weapon/wirecutters,
							"backkey"=/obj/item/weapon/screwdriver,
							"desc"="The wiring is added"),
					//7
					list("key"=/obj/item/stack/cable_coil,
							"desc"="The wiring is removed added."),
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "ripley3"
				else
					user.visible_message("[user] removes the wiring on [holder]", "You remove the wiring on [holder].")
					holder.icon_state = "ripley1"
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "ripley4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "ripley2"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "ripley5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "ripley3"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "ripley6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new board_type(get_turf(holder))
					holder.icon_state = "ripley4"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] installs external armor layer to [holder].", "You install external reinforced armor layer to [holder].")
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

/datum/construction/reversible/rig_assembly/combat
	steps = list(
					//1
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="External armor is wrenched."),
					//2
					list("key"=/obj/item/weapon/wrench,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="External armor is installed."),
					//3
					list("key"=/obj/item/stack/material/plasteel,
							"backkey"=/obj/item/weapon/weldingtool,
							"desc"="Internal armor is welded."),
					//4
					list("key"=/obj/item/weapon/weldingtool,
							"backkey"=/obj/item/weapon/wrench,
							"desc"="Internal armor is wrenched"),
					//5
					list("key"=/obj/item/weapon/wrench,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="Internal armor is installed"),
					//6
					list("key"=/obj/item/stack/material/steel,
							"backkey"=/obj/item/weapon/screwdriver,
							"desc"="Advanced scanner module is secured"),
					//7
					list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Advanced scanner module is installed"),
					//8
					list("key"=/obj/item/weapon/stock_parts/scanning_module/adv,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Targeting module is secured"),
					//9
					list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Targeting module is installed"),
					//10
					list("key"=null,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),
					//11
					list("key"=/obj/item/weapon/screwdriver,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="Central control module is installed"),
					//12
					list("key"=null,
							"backkey"=/obj/item/weapon/wirecutters,
							"desc"="The wiring is adjusted"),
					//13
					list("key"=/obj/item/weapon/wirecutters,
							"backkey"=/obj/item/weapon/screwdriver,
							"desc"="The wiring is added"),
					//14
					list("key"=/obj/item/stack/cable_coil,
							"desc"="The wiring is removed added."),
					)

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		//TODO: better messages.
		switch(index)
			
			if(14)
				if(diff==FORWARD)
					user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
					holder.icon_state = "ripley3"
				else
					user.visible_message("[user] removes the wiring on [holder]", "You remove the wiring on [holder].")
					holder.icon_state = "ripley1"
			if(13)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "ripley4"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
					coil.amount = 4
					holder.icon_state = "ripley2"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
					qdel(used_atom)
					holder.icon_state = "ripley5"
				else
					user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
					holder.icon_state = "ripley3"
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "ripley6"
				else
					user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
					new board_type(get_turf(holder))
					holder.icon_state = "ripley4"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax9"
				else
					user.visible_message("[user] unfastens the peripherals control module.", "You unfasten the peripherals control module.")
					holder.icon_state = "gygax7"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
					holder.icon_state = "gygax10"
				else
					user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
					new target_board_type(get_turf(holder))
					holder.icon_state = "gygax8"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
					qdel(used_atom)
					holder.icon_state = "gygax11"
				else
					user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
					holder.icon_state = "gygax9"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
					holder.icon_state = "gygax12"
				else
					user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
					new /obj/item/weapon/stock_parts/scanning_module/adv(get_turf(holder))
					holder.icon_state = "gygax10"
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