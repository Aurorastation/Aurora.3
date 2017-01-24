/spell/aoe_turf/knock
	name = "Knock"
	desc = "This spell opens nearby doors and does not require wizard garb."
	feedback = "KN"
	school = "transmutation"
	charge_max = 100
	spell_flags = 0
	invocation = "AULIE OXIN FIERA"
	invocation_type = SpI_WHISPER
	range = 3
	cooldown_min = 20 //20 deciseconds reduction per rank
	cast_sound = 'sound/magic/Knock.ogg'

	hud_state = "wiz_knock"

/spell/aoe_turf/knock/cast(list/targets)
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			spawn(1)
				if(istype(door,/obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AL = door //casting is important
					AL.locked = 0
				door.open()
	return

/spell/aoe_turf/knock/empower_spell()
	if(!..())
		return 0
	range *= 2

	return "You've doubled the range of [src]."

//Construct version
/spell/aoe_turf/knock/harvester
	name = "Disintegrate Doors"
	desc = "No door shall stop you."

	spell_flags = CONSTRUCT_CHECK

	charge_max = 100
	invocation = ""
	invocation_type = "silent"
	range = 5

	hud_state = "const_knock"

/spell/aoe_turf/knock/harvester/cast(list/targets)
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			spawn door.cultify()

	for(var/obj/O in range(1,user))
		O.cultify()
	for(var/turf/T in range(1,user))
		var/atom/movable/overlay/animation = new /atom/movable/overlay(T)
		animation.name = "conjure"
		animation.density = 0
		animation.anchored = 1
		animation.icon = 'icons/effects/effects.dmi'
		animation.layer = 3
		animation.master = T
		if(istype(T,/turf/simulated/wall))
			animation.icon_state = "cultwall"
			flick("cultwall",animation)
		else
			animation.icon_state = "cultfloor"
			flick("cultfloor",animation)
		spawn(10)
			qdel(animation)
		T.cultify()
	return
