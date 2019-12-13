/obj/item/rig_assembly
	name = "hardsuit control module assembly"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "An assembly frame of back-mounted hardsuit deployment and control mechanism."
	var/icon_base = null
	w_class = 4
	var/obj/item/circuitboard/board_type = null
	var/obj/item/circuitboard/target_board_type = null
	var/obj/item/rig/rig_type = /obj/item/rig

	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_POWER = 4)
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
	icon_base = "ce"
	icon_state = "ce1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/ce
	rig_type = /obj/item/rig/ce
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 4, TECH_POWER = 5)

/obj/item/rig_assembly/eva
	name = "EVA suit control module assembly"
	desc = "An assembly for light rig that is desiged for repairs and maintenance to the outside of habitats and vessels."
	icon_base = "eva"
	icon_state = "eva1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/eva
	rig_type = /obj/item/rig/eva

/obj/item/rig_assembly/industrial
	name = "industrial suit control module assembly"
	desc = "An assembly for a heavy, powerful rig used by construction crews and mining corporations."
	icon_base = "industrial"
	icon_state = "industrial1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/industrial
	rig_type = /obj/item/rig/industrial

/obj/item/rig_assembly/hazmat
	name = "AMI control module assembly"
	desc = "An assembly for Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon_base = "hazmat"
	icon_state = "hazmat1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/hazmat
	rig_type = /obj/item/rig/hazmat

/obj/item/rig_assembly/medical
	name = "rescue suit control module assembly"
	desc = "An assembly for a durable suit designed for medical rescue in high risk areas."
	icon_base = "medical"
	icon_state = "medical1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/medical
	rig_type = /obj/item/rig/medical

///////////////////////
////COMBAT ASSEMBLY////
///////////////////////

/obj/item/rig_assembly/combat
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 4)

/obj/item/rig_assembly/combat/hazard
	name = "hazard hardsuit control module"
	desc = "An assembly for a security hardsuit designed for prolonged EVA in dangerous environments."
	icon_base = "hazard"
	icon_state = "hazard1"
	rig_type = /obj/item/rig/hazard
	board_type = /obj/item/circuitboard/rig_assembly/combat/hazard
	target_board_type = /obj/item/circuitboard/rig_assembly/combat/targeting/hazard

/obj/item/rig_assembly/combat/combat
	name = "combat hardsuit control module assembly"
	desc = "An assembly frame for a sleek and dangerous hardsuit for active combat."
	icon_base = "combat"
	icon_state = "combat1"
	rig_type = /obj/item/rig/combat
	board_type = /obj/item/circuitboard/rig_assembly/combat/combat
	target_board_type = /obj/item/circuitboard/rig_assembly/combat/targeting/combat
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 6)

////////////////////////
////ILLEGAL ASSEMBLY////
////////////////////////

/obj/item/rig_assembly/combat/illegal
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 4)

/obj/item/rig_assembly/combat/illegal/hacker
	name = "cybersuit control module assembly"
	desc = "An assembly for an advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_base = "hacker"
	icon_state = "hacker1"
	rig_type = /obj/item/rig/light/hacker
	board_type = /obj/item/circuitboard/rig_assembly/illegal/hacker
	target_board_type = /obj/item/circuitboard/rig_assembly/illegal/targeting/hacker

/obj/item/rig_assembly/combat/illegal/stealth
	name = "stealth suit control module assembly"
	desc = "An assembly for a highly advanced and expensive suit designed for covert operations."
	icon_base = "stealth"
	icon_state = "stealth1"
	rig_type = /obj/item/rig/light/stealth
	board_type = /obj/item/circuitboard/rig_assembly/illegal/stealth
	target_board_type = /obj/item/circuitboard/rig_assembly/illegal/targeting/stealth
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 6, TECH_ILLEGAL = 6)

/datum/construction/reversible/rig_assembly
	result = null
	var/obj/item/circuitboard/rig_assembly/board_type = null
	var/obj/item/circuitboard/rig_assembly/target_board_type = null

/datum/construction/reversible/rig_assembly/custom_action(index as num, diff as num, atom/used_atom, mob/user as mob)
	var/obj/item/I = used_atom
	if(I.iswelder())
		var/obj/item/weldingtool/W = I
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
				list("key"=/obj/item/weldingtool,
					"backkey"=/obj/item/wrench,
					"desc"="External armor is wrenched"),
				//2
				list("key"=/obj/item/wrench,
						"backkey"=/obj/item/crowbar,
						"desc"="External armor is installed"),
				//3
				list("key"=/obj/item/stack/material/steel,
						"backkey"=/obj/item/screwdriver,
						"desc"="Central control module is secured"),
				//4
				list("key"=/obj/item/screwdriver,
						"backkey"=/obj/item/crowbar,
						"desc"="Central control module is installed"),
				//5
				list("key"=null,
						"backkey"=/obj/item/wirecutters,
						"desc"="The wiring is adjusted"),
				//6
				list("key"=/obj/item/wirecutters,
						"backkey"=/obj/item/screwdriver,
						"desc"="The wiring is added"),
				//7
				list("key"=/obj/item/stack/cable_coil,
						"desc"="The wiring is removed"),
				)

/datum/construction/reversible/rig_assembly/civilian/action(atom/used_atom,mob/user as mob)
	return check_step(used_atom,user)

/datum/construction/reversible/rig_assembly/civilian/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return 0

	var/obj/item/rig_assembly/r = holder
	if(!istype(r))
		return 0

	switch(index)
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				r.icon_state = r.icon_base + "2"
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				r.icon_state = r.icon_base + "1"
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(used_atom)
				r.icon_state = r.icon_base + "3"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				r.icon_state = r.icon_base + "2"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] secures the central control module.", "You secure the central control module.")
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new board_type(get_turf(holder))
				r.icon_state = r.icon_base + "2"
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs external armor layer to [holder].", "You install external reinforced armor layer to [holder].")
				r.icon_state = r.icon_base + "4"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
			else
				user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				r.icon_state = r.icon_base + "3"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
				r.icon_state = r.icon_base + "5"
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
				r.icon_state = r.icon_base + "4"
	return 1

/datum/construction/reversible/rig_assembly/combat
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
						"desc"="Advanced scanner module is secured"),
				//7
				list("key"=/obj/item/screwdriver,
						"backkey"=/obj/item/crowbar,
						"desc"="Advanced scanner module is installed"),
				//8
				list("key"=/obj/item/stock_parts/scanning_module/adv,
						"backkey"=/obj/item/screwdriver,
						"desc"="Targeting module is secured"),
				//9
				list("key"=/obj/item/screwdriver,
						"backkey"=/obj/item/crowbar,
						"desc"="Targeting module is installed"),
				//10
				list("key"=null,
						"backkey"=/obj/item/screwdriver,
						"desc"="Central control module is secured"),
				//11
				list("key"=/obj/item/screwdriver,
						"backkey"=/obj/item/crowbar,
						"desc"="Central control module is installed"),
				//12
				list("key"=null,
						"backkey"=/obj/item/wirecutters,
						"desc"="The wiring is adjusted"),
				//13
				list("key"=/obj/item/wirecutters,
						"backkey"=/obj/item/screwdriver,
						"desc"="The wiring is added"),
				//14
				list("key"=/obj/item/stack/cable_coil,
						"desc"="The wiring is removed"),
				)

/datum/construction/reversible/rig_assembly/combat/action(atom/used_atom,mob/user as mob)
	return check_step(used_atom,user)

/datum/construction/reversible/rig_assembly/combat/custom_action(index, diff, atom/used_atom, mob/user)
	if(!..())
		return 0

	var/obj/item/rig_assembly/r = holder
	if(!istype(r))
		return 0

	switch(index)
		
		if(14)
			if(diff==FORWARD)
				user.visible_message("[user] adds the wiring to [holder].", "You add the wiring to [holder].")
				r.icon_state = r.icon_base + "2"
		if(13)
			if(diff==FORWARD)
				user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
			else
				user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				r.icon_state = r.icon_base + "1"
		if(12)
			if(diff==FORWARD)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central computer mainboard into [holder].")
				qdel(used_atom)
				r.icon_state = r.icon_base + "3"
			else
				user.visible_message("[user] disconnects the wiring of [holder].", "You disconnect the wiring of [holder].")
				r.icon_state = r.icon_base + "1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
			else
				user.visible_message("[user] removes the central control module from [holder].", "You remove the central computer mainboard from [holder].")
				new board_type(get_turf(holder))
				r.icon_state = r.icon_base + "2"
		if(10)
			if(diff==FORWARD)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				qdel(used_atom)
				r.icon_state = r.icon_base + "4"
			else
				user.visible_message("[user] unfastens the central control module.", "You unfasten the central control module.")
				r.icon_state = r.icon_base + "3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] secures the weapon control module.", "You secure the weapon control module.")
			else
				user.visible_message("[user] removes the weapon control module from [holder].", "You remove the weapon control module from [holder].")
				new target_board_type(get_turf(holder))
				r.icon_state = r.icon_base + "3"
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] installs advanced scanner module to [holder].", "You install advanced scanner module to [holder].")
				qdel(used_atom)
			else
				user.visible_message("[user] unfastens the weapon control module.", "You unfasten the weapon control module.")
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] secures the advanced scanner module.", "You secure the advanced scanner module.")
			else
				user.visible_message("[user] removes the advanced scanner module from [holder].", "You remove the advanced scanner module from [holder].")
				new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] installs internal armor layer to [holder].", "You install internal armor layer to [holder].")
				r.icon_state = r.icon_base + "5"
			else
				user.visible_message("[user] unfastens the advanced capacitor.", "You unfasten the advanced capacitor.")
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] secures internal armor layer.", "You secure internal armor layer.")
			else
				user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				r.icon_state = r.icon_base + "4"
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] welds internal armor layer to [holder].", "You weld the internal armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the internal armor layer.", "You unfasten the internal armor layer.")
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] installs external reinforced armor layer to [holder].", "You install external reinforced armor layer to [holder].")
				r.icon_state = r.icon_base + "5"
			else
				user.visible_message("[user] cuts internal armor layer from [holder].", "You cut the internal armor layer from [holder].")
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] secures external armor layer.", "You secure external reinforced armor layer.")
			else
				user.visible_message("[user] pries external armor layer from [holder].", "You prie external armor layer from [holder].")
				var/obj/item/stack/material/plasteel/MS = new /obj/item/stack/material/plasteel(get_turf(holder))
				MS.amount = 5
				r.icon_state = r.icon_base + "4"
		if(1)
			if(diff==FORWARD)
				user.visible_message("[user] welds external armor layer to [holder].", "You weld external armor layer to [holder].")
			else
				user.visible_message("[user] unfastens the external armor layer.", "You unfasten the external armor layer.")
	return 1
