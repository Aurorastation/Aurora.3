#define MALFUNCTION_TEMPORARY 1

/obj/item/implant/chem
	name = "chemical implant"
	desc = "Injects things."
	icon_state = "implant_chem"
	implant_icon = "chem"
	implant_color = "#eba7eb"
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	default_action_type = /datum/action/item_action/hands_free/activate/implant/chemical
	action_button_name = "Dispense Reagents from Chemical Implant"
	known = TRUE

/obj/item/implant/chem/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Ingkom ZV-02 Prisoner Management Implant<BR>
<b>Life:</b> Deactivates upon death but remains within the body.<BR>
<b>Important Notes: Due to the system functioning off of nutrients in the implanted subject's body, the subject<BR>
will suffer from an increased appetite.</B><BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small capsule that can contain various chemicals. Upon receiving a specially encoded signal<BR>
the implant releases the chemicals directly into the blood stream.<BR>
<b>Special Features:</b>
<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
Can only be loaded while still in its original case.<BR>
<b>Integrity:</b> Implant will last so long as the subject is alive. However, if the subject suffers from malnutrition,<BR>
the implant may become unstable and either pre-maturely inject the subject or simply break."}

/obj/item/implant/chem/New()
	..()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src

/obj/item/implant/chem/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate(src.reagents.total_volume)
	return

/obj/item/implant/chem/activate(cause)
	if((malfunction) || (!iscarbon(imp_in)))
		return 0
	if(!cause)
		cause = rand(1, 25)
	var/mob/living/carbon/R = imp_in
	src.reagents.trans_to_mob(R, cause, CHEM_BLOOD)
	to_chat(R, SPAN_HEAR("You hear a faint *beep*."))
	if(!reagents.total_volume)
		to_chat(R, SPAN_WARNING("You hear a faint *click*."))

/obj/item/implant/chem/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/syringe))
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [src] is full."))
		else
			if(do_after(user, 0.5 SECONDS, src))
				I.reagents.trans_to_obj(src, 5)
				to_chat(user, SPAN_NOTICE("You inject 5 units of the solution. The syringe now contains [I.reagents.total_volume] units."))
	else
		..()

/obj/item/implant/chem/emp_act(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	switch(severity)
		if(1)
			if(prob(60))
				activate(20)
		if(2)
			if(prob(30))
				activate(5)

	spawn(20)
		malfunction--

#undef MALFUNCTION_TEMPORARY

/obj/item/implantcase/chem
	name = "glass case - 'chem'"
	imp = /obj/item/implant/chem
