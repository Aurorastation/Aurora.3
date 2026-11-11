/singleton/psionic_power/ion
	name = "Ion Blast"
	desc = "Activate in hand to release a 3x3 ion blast around you. Be careful, this ability is expensive to use."
	icon_state = "const_mend"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/ion

/obj/item/spell/ion
	name = "ion blast"
	icon_state = "generic"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 20
	psi_cost = 30

/obj/item/spell/ion/on_use_cast(mob/user, bypass_psi_check)
	. = ..()
	if(!.)
		return

	user.visible_message(SPAN_DANGER("<font size=4>[user] opens their arms and releases an ion blast around them!</font>"),
						SPAN_DANGER("<font size=4>You open your arms and release an ion blast around you!</font>"))
	empulse(get_turf(user), 3, 3)
