/obj/item/implant/integrated_circuit
	name = "electronic implant"
	desc = "It's a case, for building very tiny electronics with."
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_implant"
	known = TRUE
	var/obj/item/device/electronic_assembly/implant/IC = null

/obj/item/implant/integrated_circuit/isLegal()
	return TRUE

/obj/item/implant/integrated_circuit/Initialize()
	. = ..()
	IC = new(src)
	IC.implant = src

/obj/item/implant/integrated_circuit/Destroy()
	IC.implant = null
	qdel(IC)
	return ..()

/obj/item/implant/integrated_circuit/get_data()
	var/dat = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Modular Implant<BR>
	<b>Life:</b> 3 years.<BR>
	<b>Important Notes: EMP can cause malfunctions in the internal electronics of this implant.</B><BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains no innate functions until other components are added.<BR>
	<b>Special Features:</b>
	<i>Modular Circuitry</i>- Can be loaded with specific modular circuitry in order to fulfill a wide possibility of functions.<BR>
	<b>Integrity:</b> Implant is not shielded from electromagnetic interference, otherwise it is independant of subject's status."}
	return dat

/obj/item/implant/integrated_circuit/emp_act(severity)
	. = ..()

	IC.emp_act(severity)

/obj/item/implant/integrated_circuit/examine(mob/user, distance, is_adjacent)
	return IC.examine(user, distance, is_adjacent)

/obj/item/implant/integrated_circuit/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscrowbar() || istype(attacking_item, /obj/item/device/integrated_electronics) || istype(attacking_item, /obj/item/integrated_circuit) || attacking_item.isscrewdriver() || istype(attacking_item, /obj/item/cell/device) )
		IC.attackby(attacking_item, user)
	else
		..()

/obj/item/implant/integrated_circuit/attack_self(mob/user)
	IC.attack_self(user)
