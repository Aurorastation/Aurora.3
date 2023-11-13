#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/implant/aggression
	name = "aggression implant"
	desc = "An implant that microdoses its user with chemicals that induce anger."
	icon_state = "implant_chem" //Temporary
	implant_icon = "chem" //Ditto
	implant_color = "#eba7eb" //Ditto
	default_action_type = null

/obj/item/implant/aggression/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Aggression Implant<BR>
	<b>Life:</b> N/A.<BR>
	<b>Important Notes:</b> Users injected with this device get increasingly angry to a breaking point. Users tend to expire before the implant does.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
	<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/implant/aggression/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/H = M

	for(var/obj/item/implant/mindshield/I in H)
		if(I.implanted)
			to_chat(H, SPAN_DANGER("Rage surges through your body, but the nanobots from your mind shield implant stop it soon after it starts!"))
			return TRUE

	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data?.flags & ANTAG_IMPLANT_IMMUNE)
		H.visible_message("[H] seems to resist the implant!", "You feel rage overtake your body, but you manage to fend it off by sheer will!")
		log_and_message_admins("[key_name(H)] was implanted by an aggression implant, but was not affected.", H)
	else if(antag_data?.id == MODE_LOYALIST)
		clear_antag_roles(H.mind, 1)
		to_chat(H, SPAN_DANGER("You feel a surge of rage override your loyalty!"))
		log_and_message_admins("[key_name(H)] was implanted by an aggression implant, clearing their loyalist status!", H)
	else
		to_chat(H, SPAN_DANGER("You feel a surge of rage course through your body and very soul!"))
		log_and_message_admins("[key_name(H)] was implanted by an aggression implant!", H)
	return TRUE

/obj/item/implant/aggression/emp_act(severity)
	if(malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")
	if(severity == 1)
		if(prob(50))
			meltdown()
		else if(prob(50))
			malfunction = MALFUNCTION_PERMANENT
		return
	spawn(20)
		malfunction--

#undef MALFUNCTION_TEMPORARY
#undef MALFUNCTION_PERMANENT

/obj/item/implantcase/aggression
	name = "glass case - 'aggression'"
	imp = /obj/item/implant/aggression
