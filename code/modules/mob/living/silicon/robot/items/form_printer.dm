//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/form_printer
	name = "paper dispenser"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"

/obj/item/form_printer/attack(mob/living/carbon/M, mob/living/carbon/user)
	return

/obj/item/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)
	if(!target || !flag)
		return
	if(istype(target,/obj/structure/table))
		deploy_paper(get_turf(target))

/obj/item/form_printer/attack_self(mob/user)
	deploy_paper(get_turf(src))

/obj/item/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message(SPAN_NOTICE("\The [src.loc] dispenses a sheet of crisp white paper."))
	new /obj/item/paper(T)