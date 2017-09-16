/obj/item/weapon/implant/integrated_circuit
	name = "electronic implant"
	desc = "It's a case, for building very tiny electronics with."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_implant"
	var/obj/item/device/electronic_assembly/implant/IC = null

/obj/item/weapon/implant/integrated_circuit/islegal()
	return TRUE

/obj/item/weapon/implant/integrated_circuit/Initialize()
	..()
	IC = new(src)
	IC.implant = src

/obj/item/weapon/implant/integrated_circuit/Destroy()
	IC.implant = null
	qdel(IC)
	return ..()

/obj/item/weapon/implant/integrated_circuit/get_data()
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

/obj/item/weapon/implant/integrated_circuit/emp_act(severity)
	IC.emp_act(severity)

/obj/item/weapon/implant/integrated_circuit/examine(mob/user)
	IC.examine(user)

/obj/item/weapon/implant/integrated_circuit/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/weapon/crowbar) || istype(O, /obj/item/device/integrated_electronics) || istype(O, /obj/item/integrated_circuit) || istype(O, /obj/item/weapon/screwdriver) || istype(O, /obj/item/weapon/cell/device) )
		IC.attackby(O, user)
	else
		..()

/obj/item/weapon/implant/integrated_circuit/attack_self(mob/user)
	IC.attack_self(user)
