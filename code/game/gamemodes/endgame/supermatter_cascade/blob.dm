// QUALITY COPYPASTA
/turf/unsimulated/wall/supermatter
	name = "unstable bluespace"
	desc = "THE END IS right now actually."

	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace-n"

	layer = EFFECTS_ABOVE_LIGHTING_LAYER
	light_color = COLOR_CYAN_BLUE
	light_power = 6
	light_range = 8

	var/spawned = 0 // DIR mask
	var/next_check = 0
	var/list/avail_dirs = list(NORTH,SOUTH,EAST,WEST)

/turf/unsimulated/wall/supermatter/Initialize()
	. = ..()
	START_PROCESSING(SScalamity, src)

/turf/unsimulated/wall/supermatter/process()
	if (!(SScalamity.times_fired % 2))
		// SScalamity ticks every 2s, we want to process every 4.
		return


	// No more available directions? Bail.
	if(avail_dirs.len == 0)
		STOP_PROCESSING(SScalamity, src)
		return

	// Choose a direction.
	var/pdir = pick(avail_dirs)
	avail_dirs -= pdir
	var/turf/T = get_step(src, pdir)
	var/turf/A = GetAbove(T)
	var/turf/B = GetBelow(T)

	// EXPAND
	if(!istype(T,type))
		addtimer(CALLBACK(src, .proc/after_tick, T), 10)
		if(A && !istype(A,type))
			addtimer(CALLBACK(src, .proc/after_tick, A), 10)
		if(B && !istype(B,type))
			addtimer(CALLBACK(src, .proc/after_tick, B), 10)
	if((spawned & (NORTH|SOUTH|EAST|WEST)) == (NORTH|SOUTH|EAST|WEST))
		STOP_PROCESSING(SScalamity, src)

/turf/unsimulated/wall/supermatter/proc/after_tick(turf/T)
	T.lighting_clear_overlay()
	for(var/atom/movable/A in T)
		if (A && A.simulated)	// No eating lighting overlays.
			if(istype(A, /mob/living))
				qdel(A)
			else if(istype(A, /mob)) // Observers, AI cameras.
				continue
			else
				qdel(A)

		CHECK_TICK
	T.ChangeTurf(type)

/turf/unsimulated/wall/supermatter/attack_generic(mob/user as mob)
	return attack_hand(user)

/turf/unsimulated/wall/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, "<span class = \"warning\">What the fuck are you doing?</span>")
	return

// /vg/: Don't let ghosts fuck with this.
/turf/unsimulated/wall/supermatter/attack_ghost(mob/user as mob)
	user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_ai(mob/user as mob)
	return user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_hand(mob/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src]... And then blinks out of existance.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything immediately goes quiet. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/turf/unsimulated/wall/supermatter/attackby(obj/item/W as obj, mob/living/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.drop_from_inventory(W,src)
	Consume(W)


/turf/unsimulated/wall/supermatter/CollidedWith(atom/AM)
	if (!AM.simulated)
		return ..()

	if(istype(AM, /mob/living))
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise as a wave of heat washes over you.</span>")
	else
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(AM)


/turf/unsimulated/wall/supermatter/proc/Consume(var/mob/living/user)
	if(istype(user,/mob/abstract/observer))
		return

	qdel(user)

/turf/unsimulated/wall/supermatter/no_spread
	avail_dirs = list()
