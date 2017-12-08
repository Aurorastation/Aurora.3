	name = "electronic implant"
	desc = "It's a case, for building very tiny electronics with."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_implant"
	var/obj/item/device/electronic_assembly/implant/IC = null

	return TRUE

	..()
	IC = new(src)
	IC.implant = src

	IC.implant = null
	qdel(IC)
	return ..()

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

	IC.emp_act(severity)

	IC.examine(user)

		IC.attackby(O, user)
	else
		..()

	IC.attack_self(user)
