/singleton/psionic_power/charge
	name = "Charge"
	desc = "Use this spell on an item with a cell to charge it."
	icon_state = "wiz_charge"
	point_cost = 1
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/charge

/obj/item/spell/charge
	name = "charge"
	icon_state = "audible_deception"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 5
	psi_cost = 5

/obj/item/spell/charge/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	var/obj/item/cell/C = hit_atom.get_cell()
	if(!C)
		return
	if(C.percent() >= 100)
		to_chat(user, SPAN_WARNING("That cell is already charged."))
		return
	psi_cost = C.maxcharge * 0.001
	. = ..()
	if(!.)
		return
	user.visible_message(SPAN_NOTICE("[user] lays [get_pronoun("his")] hand on \the [C]..."), SPAN_NOTICE("You lay your hand on \the [C]..."),)
	if(do_after(user, 1 SECOND))
		to_chat(user, SPAN_WARNING("You restore some power to \the [C]."))
		C.give(C.maxcharge * 0.1)
	psi_cost = initial(psi_cost)
