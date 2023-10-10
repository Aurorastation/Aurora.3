#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/implant/mindshield
	name = "mind shield implant"
	desc = "A neurostimulator and autohypnosis device. These replaced older, controversial loyalty implants for the corporations of the spur. When implanted against the amygdala, it ensures the host maintains a consistent personality, preventing outside interference through brainwashing or hypnotic suggestion."
	icon_state = "implant_excel"
	implant_icon = "excel"
	implant_color = "#ffd079"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 3)
	default_action_type = null
	known = TRUE

/obj/item/implant/mindshield/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> NanoTrasen NT-02 Employee Management Implant Mk.II<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more resistant to brain washing and other external influences.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that observe the host's mental functions, and will destroy and interfere with common techniques of intrusion.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/implant/mindshield/implanted(mob/M)
	to_chat(M, SPAN_SUBTLE("You feel a weird feeling, as the implant's nanobots disperse through your brain."))
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/implant/mindshield/loyalty/I in H)
			if(I.implanted && !I.mindshield_override)
				to_chat(H, SPAN_DANGER("The new mindshield implant activates, destroying your loyalty implant."))
				I.meltdown()
				continue
			else if(I.implanted && I.mindshield_override)
				to_chat(H, SPAN_DANGER("You hear a buzzing sound as your loyalty implant defends itself against the new implant."))
				meltdown()
				return FALSE
	return TRUE

/obj/item/implant/mindshield/emp_act(severity)
	if (malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")
	if(severity == 1)
		if(prob(50))
			meltdown()
		else if (prob(50))
			malfunction = MALFUNCTION_PERMANENT
		return
	spawn(20)
		malfunction--

/obj/item/implant/mindshield/ipc
	name = "software protection chip"
	desc = "A dedicated processor core designed to identify and terminate malignant software, ensuring a synthetics protection from outside hacking."

/obj/item/implant/mindshield/ipc/implanted(mob/M)
	if (!isipc(M))
		return

	..()

#undef MALFUNCTION_TEMPORARY
#undef MALFUNCTION_PERMANENT

/obj/item/implantcase/mindshield
	name = "glass case - 'mind shield'"
	imp = /obj/item/implant/mindshield

/obj/item/implanter/mindshield
	name = "implanter-mindshield"
	imp = /obj/item/implant/mindshield
