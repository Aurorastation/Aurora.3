


/mob/living/simple_animal/hostile/commanded/battlemonster/mook
	name = "Mook"
	short_name = "mook"

	pixel_x = -16

	icon = 'icons/mob/mook.dmi'
	icon_state = "mook"
	icon_living = "mook"
	icon_dead = ""
	icon_gib = ""

	var/leap_state = 0
	//0 = Not leaping
	//1 = Preparing to leap (bend legs)
	//2 = leap into air
	//3 = strike down at target
	//4 = ULTRA SLASH

	ranged = TRUE

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/proc/leap_attack(var/atom/movable/T, var/leap_duration = 1 SECONDS)
	//ranged = FALSE
	leap_state = 1
	update_icon()
	sleep(leap_duration * 0.5)
	face_atom(target_mob)
	leap_state = 2
	update_icon()

	var/x_offset = (T.x - x)*32 * 0.25
	var/y_offset = (T.y - y)*32 * 0.25
	animate(src, 0, pixel_x = x_offset, pixel_y = y_offset, pixel_z = 32, time = leap_duration*0.5, easing = BOUNCE_EASING)

	sleep(leap_duration * 0.5)
	face_atom(target_mob)
	animate(src, pixel_x = -16, pixel_y = 0, pixel_z = 0, time = 2)
	throw_at(T, get_dist(src, T) + 4, 2, src)
	leap_state = 3
	update_icon()

	sleep(2)
	leap_state = 0
	update_icon()

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/proc/side_attack(var/atom/movable/T, var/leap_duration = 1 SECONDS)

	leap_state = 1
	update_icon()

	var/list/list_of_decoys = list()
	var/list/circle_turfs = getcircle(T, 3)
	for(var/i=1,i <= 4,i++)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc,src)
		D.duration = leap_duration * 2
		var/turf/chosen_turf = pick(circle_turfs)
		var/x_offset = (chosen_turf.x - x)*32
		var/y_offset = (chosen_turf.y - y)*32
		animate(D, 0, pixel_x = x_offset, pixel_y = y_offset, time = leap_duration, easing = BOUNCE_EASING)
		list_of_decoys += D

	sleep(leap_duration - 1)
	face_atom(target_mob)
	leap_state = 3
	forceMove(get_turf(pick(list_of_decoys)))
	animate(src, pixel_x = -16, pixel_y = 0, pixel_z = 0, time = 2)
	throw_at(T, get_dist(src, T) + 4, 2, src)

	sleep(2)

	leap_state = 0
	update_icon()

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/update_icon()
	switch(leap_state)
		if(0)
			icon_state = "mook"
		if(1)
			icon_state = "mook_warmup"
		if(2)
			icon_state = "mook_leap"
		if(3)
			icon_state = "mook_strike"
		if(4)
			icon_state = "mook_slash_combo"

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/OpenFire(target_mob)
	if(leap_state)
		return

	INVOKE_ASYNC(src, .proc/leap_attack, target_mob, rand(1,3) SECONDS)

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/AttackingTarget()
	if(leap_state)
		return

	if(!Adjacent(target_mob) && prob(25))
		ranged = TRUE
		return

	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/DestroySurroundings()
	if(leap_state)
		return
	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/follow_target()
	if(leap_state)
		return
	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/mook/MoveToTarget()
	if(leap_state)
		return
	. = ..()