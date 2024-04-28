/obj/item/implant/adrenaline
	name = "adrenaline implant"
	desc = "Removes all stuns and knockdowns."
	icon_state = "implant_chem" //Temporary, this is currently unused so no need for a custom sprite
	implant_icon = "chem" //Ditto
	implant_color = "#eba7eb" //Ditto
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 2)
	default_action_type = /datum/action/item_action/hands_free/activate/implant/adrenaline
	action_button_name = "Activate Adrenaline Implant"
	var/uses = 3

/obj/item/implant/adrenaline/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Kumar Arms ZV-16 Combat Readiness Implant<BR>
<b>Life:</b> Five days.<BR>
<b>Important Notes:</b> <span class='warning'>Illegal for non-licensed personnel in Biesel space.</span><BR>
<HR>
<b>Implant Details:</b> Subjects injected with implant can activate a massive injection of adrenaline.<BR>
<b>Function:</b> Contains nanobots to stimulate body to mass-produce Adrenaline.<BR>
<b>Integrity:</b> Implant can only be used three times before the nanobots are depleted."}

/obj/item/implant/adrenaline/activate()
	if (malfunction || !imp_in)
		return
	if (uses < 1)
		to_chat(imp_in, SPAN_WARNING("\The [src] gives a faint beep inside your head, indicating that it's out of uses!"))
		return
	uses--
	to_chat(imp_in, SPAN_NOTICE("You feel a sudden surge of energy!"))
	imp_in.SetStunned(0)
	imp_in.SetWeakened(0)
	imp_in.SetParalysis(0)

/obj/item/implantcase/adrenaline
	name = "glass case - 'adrenalin'"
	imp = /obj/item/implant/adrenaline

/obj/item/implanter/adrenaline
	name = "implanter-adrenaline"
	imp = /obj/item/implant/adrenaline
