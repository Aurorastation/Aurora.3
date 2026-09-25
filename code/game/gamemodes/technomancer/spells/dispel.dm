/datum/technomancer/spell/dispel
	name = "Dispel"
	desc = "Ends most on-going effects caused by another Technomancer function on the target.  Useful if you are worried about \
	hitting an ally with a deterimental function, if your opponent has similar capabilities to you, or if you're tired of Instability \
	plaguing you."
	cost = 25
	obj_path = /obj/item/spell/dispel
	ability_icon_state = "tech_dispel"
	category = SUPPORT_SPELLS

/obj/item/spell/dispel
	name = "dispel"
	desc = "Useful if you're tired of glowing because of a miscast."
	icon_state = "dispel"
	cast_methods = CAST_RANGED
	aspect = ASPECT_BIOMED

/obj/item/spell/dispel/on_ranged_cast(atom/hit_atom, mob/living/user)
	. = ..()
	if(!isliving(hit_atom))
		return FALSE

	var/mob/living/L = hit_atom
	var/dispelled_effects = 0

	if(L.modifiers)
		var/list/modifiers_to_dispel = L.modifiers.Copy()
		for(var/datum/modifier/technomancer/M in modifiers_to_dispel)
			M.stop()
			dispelled_effects++

	var/list/inserted_spells_to_dispel = list()
	for(var/obj/item/inserted_spell/IS in L.contents)
		inserted_spells_to_dispel += IS
	for(var/obj/item/inserted_spell/IS in inserted_spells_to_dispel)
		IS.on_expire(TRUE)
		dispelled_effects++

	if(L.instability)
		var/instability_to_remove = min(L.instability, calculate_spell_power(25))
		L.adjust_instability(-instability_to_remove)
		dispelled_effects++

	if(!dispelled_effects)
		to_chat(user, SPAN_WARNING("\The [L] has no Technomancer effects to dispel."))
		return FALSE

	to_chat(user, SPAN_NOTICE("You dispel the Technomancer energies affecting \the [L]."))
	log_and_message_admins("has dispelled Technomancer effects from [L].")
	adjust_instability(10)
	qdel(src)
	return TRUE
