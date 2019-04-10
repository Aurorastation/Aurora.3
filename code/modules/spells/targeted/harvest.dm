/spell/targeted/harvest
	name = "Harvest"
	desc = "Back to where I come from, and you're coming with me."

	school = "transmutation"
	charge_max = 200
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK | INCLUDEUSER
	invocation = ""
	invocation_type = SpI_NONE
	range = 0
	max_targets = 0

	overlay = 1
	overlay_icon = 'icons/effects/effects.dmi'
	overlay_icon_state = "rune_teleport"
	overlay_lifespan = 0

	hud_state = "const_harvest"

/spell/targeted/harvest/cast(list/targets, mob/user)//because harvest is already a proc
	..()

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

	var/destination = null
	for(var/obj/singularity/narsie/large/N in narsie_list)
		destination = N.loc
		break
	if(destination)
		var/prey = 0
		for(var/mob/living/M in targets)
			if(!findNullRod(M))
				M.forceMove(destination)
				if(M != user)
					prey = 1
		to_chat(user, "<span class='alert'>You warp back to Nar-Sie[prey ? " along with your prey":""].</span>")
	else
		to_chat(user, "<span class='danger'>...something's wrong!</span>")//There shouldn't be an instance of Harvesters when Nar-Sie isn't in the world.)
