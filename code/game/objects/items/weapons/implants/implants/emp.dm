/obj/item/implant/emp
	name = "\improper EMP implant"
	desc = "Triggers an EMP."
	icon_state = "implant_emp"
	implant_icon = "emp"
	implant_color = "#249fde"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 2)
	default_action_type = /datum/action/item_action/hands_free/activate/implant/emp
	action_button_name = "Activate EMP Implant"
	var/uses = 3

/obj/item/implant/emp/activate()
	if (malfunction || !imp_in)
		return
	if (uses < 1)
		to_chat(imp_in, SPAN_WARNING("\The [src] gives a faint beep inside your head, indicating that it's out of uses!"))
		return
	uses--
	empulse(imp_in, 3, 5)

/obj/item/implantcase/emp
	name = "implant case - 'EMP'"
	imp = /obj/item/implant/emp
