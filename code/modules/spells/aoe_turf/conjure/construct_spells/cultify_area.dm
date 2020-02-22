/spell/aoe_turf/cultify_area
	name = "Cultify Area"
	desc = "This spell converts the surrounding turfs into cultified versions."
	feedback = "DT"
	charge_max = 400
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE
	selection_type = "range"
	range = 2
	inner_radius = -1

	cooldown_min = 200

	hud_state = "const_floor"

	cast_sound = 'sound/items/welder.ogg'

/spell/aoe_turf/cultify_area/cast(list/targets, mob/user)
	for(var/turf/target in targets)
		target.cultify()
	return