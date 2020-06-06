/spell/shadow_shroud
	name = "Shadow Shroud"
	desc = "This spell causes darkness at the point of the caster for a duration of time."
	feedback = "SS"
	school = "abjuration"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "mutters a chant, the light around them darkening."
	charge_max = 300 //30 seconds

	range = 5
	duration = 150 //15 seconds

	cast_sound = 'sound/effects/bamf.ogg'

	hud_state = "wiz_tajaran"

/spell/shadow_shroud/choose_targets()
	return list(get_turf(holder))

/spell/shadow_shroud/cast(var/list/targets, mob/user)
	var/turf/T = targets[1]

	if(!istype(T))
		return

	var/obj/O = new /obj(T)
	O.set_light(range, -10, "#FFFFFF")

	spawn(duration)
		qdel(O)