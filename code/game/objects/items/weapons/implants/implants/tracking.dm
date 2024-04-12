#define MALFUNCTION_TEMPORARY 1

/obj/item/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	icon_state = "implant_freedom"
	implant_icon = "freedom"
	implant_color = "#eadb83"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_BLUESPACE = 2)
	default_action_type = null
	known = TRUE
	var/id = 1.0
	var/lifespan_postmortem = 10 MINUTES

/obj/item/implant/tracking/Initialize()
	var/list/tracking_list = list()
	for(var/obj/item/implant/tracking/T in GLOB.implants)
		tracking_list += T
	id = length(tracking_list) + 1
	. = ..()

/obj/item/implant/tracking/process()
	if(!imp_in)
		return
	if(iscarbon(imp_in))
		var/mob/living/carbon/R = imp_in
		if(R.chem_effects[CE_NEUROTOXIC])
			if(prob(5))
				meltdown()

/obj/item/implant/tracking/get_data()
	. = {"<b>Implant Specifications:</b><BR>
<b>Name:</b> Ingkom ZV-01 Tracking Beacon<BR>
<b>Life:</b> 10 minutes after death of host<BR>
<b>Important Notes:</b> None<BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Continuously transmits a low power signal. Useful for tracking subjects.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
a malfunction occurs thereby securing safety of subject. The implant will melt and
disintegrate into bio-safe elements.<BR>
<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
circuitry. As a result neurotoxins can cause massive damage.<HR>
Implant Specifics:<BR>"}

/obj/item/implant/tracking/isLegal()
	return TRUE

/obj/item/implant/tracking/emp_act(severity)
	. = ..()

	if (malfunction)	//no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(EMP_HEAVY)
			if(prob(60))
				meltdown()
		if(EMP_LIGHT)
			delay = rand(5*60*10,15*60*10)	//from 5 to 15 minutes of free time

	spawn(delay)
		malfunction--

#undef MALFUNCTION_TEMPORARY

/obj/item/implantcase/tracking
	name = "glass case - 'tracking'"
	imp = /obj/item/implant/tracking
