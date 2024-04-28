/obj/item/implant/mindshield/loyalty
	name = "loyalty implant"
	desc = "A controversial device, these were replaced with mindshield implants by the corporations of the spur. However, they still find usage with several entities across the spur."
	///The entity that the implantee should be loyal to
	var/loyal_entity
	///Whether this implant will override mindshield implants. These are supposed to be older versions of mindshields, so only specially modified versions should do so.
	var/mindshield_override = FALSE

/obj/item/implant/mindshield/loyalty/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Solarian Corporate Authority NT-02 Employee Management Implant Mk.I<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the entity provided.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions, to ensure no harmful thoughts are present against an entity.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."
<B>Loyal entity:</B><BR>
This is the entity that the implantee will align their thoughts to benefit.<BR>
<A href='byond://?src=\ref[src];loyal=1'>[loyal_entity ? loyal_entity : "NONE SET"]</A>
"}

/obj/item/implant/mindshield/loyalty/Topic(href, href_list)
	..()
	if(href_list["loyal"])
		var/entity = tgui_input_text(usr, "Set loyalty target.", "Loyalty", loyal_entity)
		if(entity)
			loyal_entity = entity
		interact(usr)

/obj/item/implant/mindshield/loyalty/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/H = M

	for(var/obj/item/implant/mindshield/I in H)
		if(I.implanted && !mindshield_override)
			to_chat(H, SPAN_DANGER("You almost feel your loyalties shifting, but nanobots from your mindshield implant stop it soon after it starts!"))
			meltdown()
			return FALSE
		else if(I.implanted && mindshield_override)
			to_chat(H, SPAN_DANGER("You hear a buzzing sound as your mindshield implant struggles to defend against the new implant."))
			I.meltdown()

	to_chat(H, SPAN_GOOD("You feel a sudden surge of loyalty to \the [loyal_entity]!"))
	log_and_message_admins("[key_name(H)] was implanted by an loyalty implant, set to [loyal_entity]!", H)
	return TRUE

/obj/item/implant/mindshield/loyalty/sol
	name = "loyalty implant - Sol Alliance"
	desc = "A device used by the Sol Alliance, to ensure loyalty to the only human government in the spur."
	loyal_entity = "\improper Sol Alliance"

/obj/item/implant/mindshield/loyalty/nralakk
	name = "loyalty implant - Nralakk Federation"
	desc = "A device used by the Nralakk Federation, to ensure loyalty to its ideals and to the best caretaker of the skrellian people."
	loyal_entity = "\improper Nralakk Federation"

/obj/item/implant/mindshield/loyalty/scc
	name = "loyalty implant - Stellar Corporate Conglomerate"
	desc = "A device that is allegedly used by the Stellar Corporate Conglomerate, which is allegedly used to enforce loyalty to the corporate agenda for its emergency response teams and high-ranking officers."
	loyal_entity = "\improper Stellar Corporate Conglomerate"

/obj/item/implant/mindshield/loyalty/nt
	name = "loyalty implant - NanoTrasen"
	desc = "A device that is allegedly used by NanoTrasen, which is allegedly used to enforce loyalty to the corporate agenda for its emergency response teams and high-ranking officers."
	loyal_entity = "NanoTrasen"
	//They made them originally, they would know how to override them.
	mindshield_override = TRUE

/obj/item/implantcase/loyalty
	name = "glass case - 'loyalty'"
	imp = /obj/item/implant/mindshield/loyalty

/obj/item/implanter/loyalty
	name = "implanter-loyalty"
	imp = /obj/item/implant/mindshield/loyalty

/obj/item/implantcase/loyalty/sol
	name = "glass case - 'loyalty - Sol Alliance'"
	imp = /obj/item/implant/mindshield/loyalty/sol

/obj/item/implanter/loyalty/sol
	name = "implanter-loyalty - Sol Alliance"
	imp = /obj/item/implant/mindshield/loyalty/sol

/obj/item/implantcase/loyalty/nralakk
	name = "glass case - 'loyalty - Nralakk Federation'"
	imp = /obj/item/implant/mindshield/loyalty/nralakk

/obj/item/implanter/loyalty/nralakk
	name = "implanter-loyalty - Nralakk Federation"
	imp = /obj/item/implant/mindshield/loyalty/nralakk

/obj/item/implantcase/loyalty/scc
	name = "glass case - 'loyalty - Stellar Corporate Conglomerate'"
	imp = /obj/item/implant/mindshield/loyalty/scc

/obj/item/implanter/loyalty/scc
	name = "implanter-loyalty - Stellar Corporate Conglomerate"
	imp = /obj/item/implant/mindshield/loyalty/scc
