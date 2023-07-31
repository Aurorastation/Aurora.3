/datum/technomancer/spell/raise_wall
	name = "Raise Wall"
	desc = "This allows you to raise an immovable, impassable, but not invulnerable wall from the aether. The wall dissipates after ten seconds."
	enhancement_desc = "Raised walls will be opaque."
	spell_power_desc = "Raised walls will last for longer."
	cost = 50
	ability_icon_state = "const_juggwall"
	obj_path = /obj/item/spell/raise_wall
	category = DEFENSIVE_SPELLS

/obj/item/spell/raise_wall
	name = "raise wall"
	desc = "Allows you to raise a wall from the aether. The wall dissipates after ten seconds."
	icon_state = "raise_wall"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FORCE

/obj/item/spell/raise_wall/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/target_turf = isturf(hit_atom) ? hit_atom : get_turf(hit_atom)
	if(target_turf.density)
		return
	if(!pay_energy(1000))
		return
	adjust_instability(1)
	var/obj/effect/forcefield/force_wall = locate() in target_turf
	if(force_wall)
		qdel(force_wall)
	force_wall = new(target_turf)
	if(check_for_scepter())
		force_wall.opacity = TRUE
	QDEL_IN(force_wall, 10 SECONDS * core.spell_power_modifier)
	user.visible_message("<b>[user]</b> raises their fist towards \the [target_turf], and a solid wall of force rises out of it!", SPAN_NOTICE("You raise your fist towards \the [target_turf], and a solid wall of force rises out of it."))
