/singleton/psionic_power/punch
	name = "Psi-Punch"
	desc = "Imbue your fists with psionic power."
	icon_state = "const_fist"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/punch

/obj/item/spell/punch
	name = "psi-punch"
	icon_state = "generic"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	force = 20
	armor_penetration = 20
	cooldown = 0
	psi_cost = 3
	flags = 0
	hitsound = 'sound/weapons/resonator_blast.ogg'

/obj/item/spell/punch/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!isliving(hit_atom))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/M = hit_atom
	if(prob(15))
		M.throw_at(get_edge_target_turf(loc, loc.dir), 2, 7)
		M.visible_message(SPAN_DANGER("[M] is floored by psychic energy!"), SPAN_DANGER("You are floored by psychic energy!"))
		M.apply_effect(2, WEAKEN)
