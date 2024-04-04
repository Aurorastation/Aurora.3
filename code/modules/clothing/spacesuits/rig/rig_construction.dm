/obj/item/rig_assembly
	name = "hardsuit control module assembly"
	desc = "The assembly frame of a back-mounted hardsuit deployment and control mechanism."
	icon = 'icons/obj/rig_modules.dmi'
	var/icon_base = null
	w_class = ITEMSIZE_LARGE

	///The type of board, a path of `/obj/item/circuitboard`
	var/board_type = null

	///The type of target board, a path of `/obj/item/circuitboard`
	var/target_board_type = null

	///The type of rig, a path of `/obj/item/rig`
	var/rig_type = /obj/item/rig

	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_POWER = 4)

	var/datum/construction/reversible/rig_assembly/construct

	obj_flags = OBJ_FLAG_CONDUCTABLE

/obj/item/rig_assembly/Initialize(mapload, ...)
	. = ..()

	construct = new /datum/construction/reversible/rig_assembly/civilian(src)
	construct.board_type = board_type
	construct.steps[5]["key"] = board_type // defining board in construction step
	construct.result = "[rig_type]"

/obj/item/rig_assembly/Destroy()
	QDEL_NULL(construct)

	. = ..()


/obj/item/rig_assembly/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(construct)
		. += construct.get_desc()

/obj/item/rig_assembly/MouseEntered(location, control, params)
	. = ..()
	if(construct)
		var/list/modifiers = params2list(params)
		if(modifiers["shift"] && get_dist(usr, src) <= 2)
			params = replacetext(params, "shift=1;", "") // tooltip doesn't appear unless this is stripped
			openToolTip(usr, src, params, name, construct.get_desc())

/obj/item/rig_assembly/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/rig_assembly/attackby(obj/item/attacking_item, mob/user)
	if(!construct || !construct.action(attacking_item, user))
		..()
	return


/obj/item/rig_assembly/combat/Initialize(mapload, ...)
	. = ..()

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
	desc = "The assembly frame for an advanced voidsuit that protects against hazardous, low pressure environments."
	icon_base = "ce"
	icon_state = "ce1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/ce
	rig_type = /obj/item/rig/ce
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 4, TECH_POWER = 5)

/obj/item/rig_assembly/eva
	name = "EVA suit control module assembly"
	desc = "The assembly frame for a light hardsuit that is designed for the external maintenance and repair of habitats and vessels."
	icon_base = "eva"
	icon_state = "eva1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/eva
	rig_type = /obj/item/rig/eva

/obj/item/rig_assembly/eva/pilot
	name = "pilot suit control module assembly"
	desc = "The assembly frame for a light hardsuit that is designed for pilots."
	icon_base = "eva"
	icon_state = "eva1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/eva/pilot
	rig_type = /obj/item/rig/eva/pilot

/obj/item/rig_assembly/industrial
	name = "industrial suit control module assembly"
	desc = "The assembly frame for a sturdy hardsuit used by construction crews and mining corporations."
	icon_base = "industrial"
	icon_state = "industrial1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/industrial
	rig_type = /obj/item/rig/industrial
	convert_options = list(/obj/item/rig_assembly/industrial/himeo)

/obj/item/rig_assembly/industrial/himeo
	name = "himean industrial suit control module assembly"
	desc = "The assembly frame for a rugged hardsuit used by Himean miners, engineers, and naval sappers."
	icon_base = "himeo"
	icon_state = "himeo1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/industrial
	rig_type = /obj/item/rig/industrial/himeo
	convert_options = list(/obj/item/rig_assembly/industrial)

/obj/item/rig_assembly/hazmat
	name = "AMI control module assembly"
	desc = "The assembly frame for a Anomalous Material Interaction hardsuit that protects the wearer against the strangest energies the universe can throw at them."
	icon_base = "hazmat"
	icon_state = "hazmat1"
	board_type = /obj/item/circuitboard/rig_assembly/civilian/hazmat
	rig_type = /obj/item/rig/hazmat

/obj/item/rig_assembly/medical
	name = "rescue suit control module assembly"
	desc = "The assembly frame for a durable hardsuit designed for medical rescue in high risk areas."
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
	desc = "The assembly frame for a robust security hardsuit designed for prolonged EVA in dangerous environments."
	icon_base = "hazard"
	icon_state = "hazard1"
	rig_type = /obj/item/rig/hazard
	board_type = /obj/item/circuitboard/rig_assembly/combat/hazard
	target_board_type = /obj/item/circuitboard/rig_assembly/combat/targeting/hazard

/obj/item/rig_assembly/combat/combat
	name = "combat hardsuit control module assembly"
	desc = "The assembly frame for a sleek and dangerous hardsuit for active combat."
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
	desc = "The assembly frame for an advanced powered armor suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon_base = "hacker"
	icon_state = "hacker1"
	rig_type = /obj/item/rig/light/hacker
	board_type = /obj/item/circuitboard/rig_assembly/illegal/hacker
	target_board_type = /obj/item/circuitboard/rig_assembly/illegal/targeting/hacker

/obj/item/rig_assembly/combat/illegal/stealth
	name = "stealth suit control module assembly"
	desc = "The assembly frame for a highly advanced and expensive suit designed for covert operations."
	icon_base = "stealth"
	icon_state = "stealth1"
	rig_type = /obj/item/rig/light/stealth
	board_type = /obj/item/circuitboard/rig_assembly/illegal/stealth
	target_board_type = /obj/item/circuitboard/rig_assembly/illegal/targeting/stealth
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 6, TECH_ILLEGAL = 6)

/datum/construction/reversible/rig_assembly
	result = null

	///The type of board, a path of `/obj/item/circuitboard`
	var/board_type = null

	///The type of target board, a path of `/obj/item/circuitboard`
	var/target_board_type = null

/datum/construction/reversible/rig_assembly/custom_action(index as num, diff as num, atom/used_atom, mob/user as mob)
	var/obj/item/I = used_atom
	if(I.iswelder())
		var/obj/item/weldingtool/W = I
		if (W.use(0, user))
			playsound(holder, 'sound/items/welder_pry.ogg', 50, 1)
		else
			return 0
	else if(I.iswrench())
		I.play_tool_sound(get_turf(src), 50)

	else if(I.isscrewdriver())
		I.play_tool_sound(get_turf(src), 50)

	else if(I.iswirecutter())
		I.play_tool_sound(get_turf(src), 50)

	else if(I.iscoil())
		var/obj/item/stack/cable_coil/C = used_atom
		if(C.use(4))
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
		else
			to_chat(user, "There isn't enough cable to finish the task.")
			return 0
	else if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(S.get_amount() < 5)
			to_chat(user, "There isn't enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1

/datum/construction/reversible/rig_assembly/civilian
	steps = list(
				//1
				list("key"=/obj/item/weldingtool,
					"backkey"=WRENCH,
					"desc"="The external armor has been wrenched down, use a welding tool to finish it off, or use a wrench to unsecure the external armor."),
				//2
				list("key"=WRENCH,
						"backkey"=/obj/item/crowbar,
						"desc"="The external armor has been installed, use a wrench to secure it, or use a crowbar to pry it out of place."),
				//3
				list("key"=/obj/item/stack/material/steel,
						"backkey"=/obj/item/screwdriver,
						"desc"="The central control module has been secured, add some steel to install external armor, or use a screwdriver to unsecure the control module."),
				//4
				list("key"=SCREWDRIVER,
						"backkey"=/obj/item/crowbar,
						"desc"="The central control module has been installed, use a screwdriver to secure it, or use a crowbar to pry it out."),
				//5
				list("key"=null,
						"backkey"=/obj/item/wirecutters,
						"desc"="The wiring has been adjusted, install the central control module to continue, or use a wirecutter to unset the wires."),
				//6
				list("key"=WIRECUTTER,
						"backkey"=/obj/item/screwdriver,
						"desc"="The wiring has been added, use a wirecutter to properly adjust them, or use a screwdriver to remove them."),
				//7
				list("key"=/obj/item/stack/cable_coil,
						"desc"="The assembly lacks wiring, add some to begin."),
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
				user.visible_message("<b>[user]</b> adds wiring to \the [holder].", SPAN_NOTICE("You add wiring to \the [holder]."))
				r.icon_state = r.icon_base + "2"
		if(6)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> adjusts the wiring of \the [holder].", SPAN_NOTICE("You adjust the wiring of \the [holder]."))
			else
				user.visible_message("<b>[user]</b> removes the wiring from \the [holder].", SPAN_NOTICE("You remove the wiring from \the [holder]."))
				var/obj/item/stack/cable_coil/coil = new /obj/item/stack/cable_coil(get_turf(holder))
				coil.amount = 4
				r.icon_state = r.icon_base + "1"
		if(5)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs the central control module into \the [holder].", SPAN_NOTICE("You install the central control module into \the [holder]."))
				qdel(used_atom)
				r.icon_state = r.icon_base + "3"
			else
				user.visible_message("<b>[user]</b> disconnects the wiring of \the [holder].", SPAN_NOTICE("You disconnect the wiring of \the [holder]."))
				r.icon_state = r.icon_base + "2"
		if(4)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the central control module.", SPAN_NOTICE("You secure the central control module."))
			else
				user.visible_message("<b>[user]</b> removes the central control module from \the [holder].", SPAN_NOTICE("You remove the central control module from \the [holder]."))
				new board_type(get_turf(holder))
				r.icon_state = r.icon_base + "2"
		if(3)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs an external armor layer into \the [holder].", SPAN_NOTICE("You install an external reinforced armor layer into \the [holder]."))
				r.icon_state = r.icon_base + "4"
			else
				user.visible_message("<b>[user]</b> cuts the external armor layer from \the [holder].", SPAN_NOTICE("You cut the external armor layer from \the [holder]."))
		if(2)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the external armor layer.", SPAN_NOTICE("You secure the external reinforced armor layer."))
			else
				user.visible_message("<b>[user]</b> pries the external armor layer from \the [holder].", SPAN_NOTICE("You pry the external armor layer from \the [holder]."))
				var/obj/item/stack/material/steel/MS = new /obj/item/stack/material/steel(get_turf(holder))
				MS.amount = 5
				r.icon_state = r.icon_base + "3"
		if(1)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> welds the external armor layer of \the [holder] into position.", SPAN_NOTICE("You weld the external armor layer of \the [holder] into position."))
				r.icon_state = r.icon_base + "5"
			else
				user.visible_message("<b>[user]</b> unfastens the external armor layer.", SPAN_NOTICE("You unfasten the external armor layer."))
				r.icon_state = r.icon_base + "4"
	return 1

/datum/construction/reversible/rig_assembly/combat
	steps = list(
				//1
				list("key"=/obj/item/weldingtool,
						"backkey"=WRENCH,
						"desc"="The external armor has been wrenched down, use a welding tool to finish it off, or use a wrench to unsecure the external armor."),
				//2
				list("key"=WRENCH,
						"backkey"=CROWBAR,
						"desc"="The external armor has been installed, use a wrench to secure it, or use a crowbar to pry it out of place."),
				//3
				list("key"=/obj/item/stack/material/plasteel,
						"backkey"=/obj/item/weldingtool,
						"desc"="The internal armor has been welded into place, add some plasteel to install external armor, or use a welding tool to unweld the internal armor.."),
				//4
				list("key"=/obj/item/weldingtool,
						"backkey"=WRENCH,
						"desc"="The internal armor has been wrenched down, use a welding tool to weld it into place, or use a wrench to unsecure the internal armor."),
				//5
				list("key"=WRENCH,
						"backkey"=CROWBAR,
						"desc"="The internal armor has been installed, use a wrench to secure it, or use a crowbar to pry it out of place."),
				//6
				list("key"=/obj/item/stack/material/steel,
						"backkey"=SCREWDRIVER,
						"desc"="The advanced scanner module has been secured, add some steel to install internal armor, or use a screwdriver to unsecure it."),
				//7
				list("key"=SCREWDRIVER,
						"backkey"=CROWBAR,
						"desc"="The advanced scanner module has been installed, use a screwdriver to secure it, or use a crowbar to pry it out."),
				//8
				list("key"=/obj/item/stock_parts/scanning_module/adv,
						"backkey"=SCREWDRIVER,
						"desc"="The targeting module has been secured, add an advanced scanning module to continue, or use a screwdriver to unsecure it."),
				//9
				list("key"=SCREWDRIVER,
						"backkey"=CROWBAR,
						"desc"="The targeting module has been installed, use a screwdriver to secure it, or use a crowbar to pry it out."),
				//10
				list("key"=null,
						"backkey"=SCREWDRIVER,
						"desc"="The central control module has been secured, add a targeting module to continue, or use a screwdriver to unsecure it."),
				//11
				list("key"=SCREWDRIVER,
						"backkey"=CROWBAR,
						"desc"="The central control module has been installed, use a screwdriver to secure it, or use a crowbar to pry it out."),
				//12
				list("key"=null,
						"backkey"=WIRECUTTER,
						"desc"="The wiring has been adjusted, install the central control module to continue, or use a wirecutter to unset the wires."),
				//13
				list("key"=WIRECUTTER,
						"backkey"=SCREWDRIVER,
						"desc"="The wiring has been added, use a wirecutter to properly adjust them, or use a screwdriver to remove them."),
				//14
				list("key"=/obj/item/stack/cable_coil,
						"desc"="The assembly lacks wiring, add some to begin."),
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
				user.visible_message("<b>[user]</b> adds wiring to \the [holder].", SPAN_NOTICE("You add wiring to \the [holder]."))
				r.icon_state = r.icon_base + "2"
		if(13)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> adjusts the wiring of \the [holder].", SPAN_NOTICE("You adjust the wiring of \the [holder]."))
			else
				user.visible_message("<b>[user]</b> removes the wiring from \the [holder].", SPAN_NOTICE("You remove the wiring from \the [holder]."))
				new /obj/item/stack/cable_coil(get_turf(holder), 4)
				r.icon_state = r.icon_base + "1"
		if(12)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs the central control module into \the [holder].", SPAN_NOTICE("You install the central control module into \the [holder]."))
				qdel(used_atom)
				r.icon_state = r.icon_base + "3"
			else
				user.visible_message("<b>[user]</b> disconnects the wiring of \the [holder].", SPAN_NOTICE("You disconnect the wiring of [holder]."))
				r.icon_state = r.icon_base + "1"
		if(11)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the central control module.", SPAN_NOTICE("You secure the central control module."))
			else
				user.visible_message("<b>[user]</b> removes the central control module from \the [holder].", SPAN_NOTICE("You remove the central control module from \the [holder]."))
				new board_type(get_turf(holder))
				r.icon_state = r.icon_base + "2"
		if(10)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs the targeting control module into \the [holder].", SPAN_NOTICE("You install the targeting control module into \the [holder]."))
				qdel(used_atom)
				r.icon_state = r.icon_base + "4"
			else
				user.visible_message("<b>[user]</b> unfastens the central control module.", SPAN_NOTICE("You unfasten the central control module."))
				r.icon_state = r.icon_base + "3"
		if(9)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the targeting control module.", SPAN_NOTICE("You secure the targeting control module."))
			else
				user.visible_message("<b>[user]</b> removes the targeting control module from \the [holder].", SPAN_NOTICE("You remove the targeting control module from \the [holder]."))
				new target_board_type(get_turf(holder))
				r.icon_state = r.icon_base + "3"
		if(8)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs the advanced scanner module into \the [holder].", SPAN_NOTICE("You install the advanced scanner module into \the [holder]."))
				qdel(used_atom)
			else
				user.visible_message("<b>[user]</b> unfastens the targeting control module.", SPAN_NOTICE("You unfasten the targeting control module."))
		if(7)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the advanced scanner module.", SPAN_NOTICE("You secure the advanced scanner module."))
			else
				user.visible_message("<b>[user]</b> removes the advanced scanner module from \the [holder].", SPAN_NOTICE("You remove the advanced scanner module from \the [holder]."))
				new /obj/item/stock_parts/scanning_module/adv(get_turf(holder))
		if(6)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs an internal armor layer into \the [holder].", SPAN_WARNING("You install an internal armor layer into \the [holder]."))
				r.icon_state = r.icon_base + "5"
			else
				user.visible_message("<b>[user]</b> unfastens the advanced scanner module.", SPAN_NOTICE("You unfasten the advanced scanner module."))
		if(5)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the internal armor layer.", SPAN_NOTICE("You secure the internal armor layer."))
			else
				user.visible_message("<b>[user]</b> pries the internal armor layer from \the [holder].", SPAN_NOTICE("You pry the internal armor layer from \the [holder]."))
				new /obj/item/stack/material/steel(get_turf(holder), 5)
				r.icon_state = r.icon_base + "4"
		if(4)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> welds the internal armor layer of \the [holder] into position.", SPAN_NOTICE("You weld the internal armor layer of \the [holder] into position."))
			else
				user.visible_message("<b>[user]</b> unfastens the internal armor layer.", SPAN_NOTICE("You unfasten the internal armor layer."))
		if(3)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> installs an external reinforced armor layer into \the [holder].", SPAN_NOTICE("You install an external reinforced armor layer into \the [holder]."))
				r.icon_state = r.icon_base + "5"
			else
				user.visible_message("<b>[user]</b> cuts the internal armor layer from \the [holder].", SPAN_NOTICE("You cut the internal armor layer from \the [holder]."))
		if(2)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> secures the external armor layer.", SPAN_NOTICE("You secure the external armor layer."))
			else
				user.visible_message("<b>[user]</b> pries the external armor layer from \the [holder].", SPAN_NOTICE("You pry the external armor layer from \the [holder]."))
				new /obj/item/stack/material/plasteel(get_turf(holder), 5)
				r.icon_state = r.icon_base + "4"
		if(1)
			if(diff==FORWARD)
				user.visible_message("<b>[user]</b> welds the external armor layer of \the [holder] into position.", SPAN_NOTICE("You weld the external armor layer of \the [holder] into position."))
			else
				user.visible_message("<b>[user]</b> unfastens the external armor layer.", SPAN_NOTICE("You unfasten the external armor layer."))
	return 1
