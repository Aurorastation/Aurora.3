#define MUZZLE_EFFECT_PIXEL_INCREMENT 16	//How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = TRUE
	unacidable = TRUE
	anchored = TRUE				//There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASSTABLE
	mouse_opacity = 0
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/projectile_type = /obj/item/projectile

	var/def_zone = ""	//Aiming at
	var/hit_zone		// The place that actually got hit
	var/mob/firer = null//Who shot it
	var/silenced = FALSE	//Attack message

	var/shot_from = "" // name of the object which shot us

	var/accuracy = 0
	var/dispersion = 0.0

	//used for shooting at blank range, you shouldn't be able to miss
	var/point_blank = FALSE

	//Effects
	var/damage = 10
	var/damage_type = BRUTE		//BRUTE, BURN, TOX, OXY, CLONE, PAIN are the only things that should be in here
	var/damage_flags = DAM_BULLET
	var/nodamage = FALSE		//Determines if the projectile will skip any damage inflictions
	var/check_armor = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/list/impact_sounds	//for different categories, IMPACT_MEAT etc

	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0

	var/incinerate = 0
	var/embed = 0 // whether or not the projectile can embed itself in the mob
	var/embed_chance = 0 // a flat bonus to the % chance to embed
	var/shrapnel_type //type of shrapnel the projectile leaves in its target.

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	//For Maim / Maiming.
	var/maiming = 0 //Enables special limb dismemberment calculation; used primarily for ranged weapons that can maim, but do not do brute damage.
	var/maim_rate = 0 //Factor that the recipiant will be maimed by the projectile (NOT OUT OF 100%.)
	var/clean_cut = 0 //Is the delimbning painful and unclean? Probably. Can be a function or proc, if you're doing something odd.
	var/maim_type = DROPLIMB_EDGE
	/*Does the projectile simply lop/tear the limb off, or does it vaporize it?
	Set maim_type to DROPLIMB_EDGE to chop off the limb
	set maim_type to DROPLIMB_BURN to vaporize it.
	set maim_type to DROPLIMB_BLUNT to gib (Explode/Hamburger) the limb.
	*/

	//Movement parameters
	var/speed = 0.2			//Amount of deciseconds it takes for projectile to travel
	var/pixel_speed = 33	//pixels per move - DO NOT FUCK WITH THIS UNLESS YOU ABSOLUTELY KNOW WHAT YOU ARE DOING OR UNEXPECTED THINGS /WILL/ HAPPEN!
	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/yo = null
	var/xo = null
	var/atom/original			// the target clicked (not necessarily where the projectile is headed). Should probably be renamed to 'target' or something.
	var/turf/starting			// the projectile's starting turf
	var/list/permutated			// we've passed through these atoms, don't try to hit them again
	var/penetrating = 0			//If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/forcedodge = FALSE		//to pass through everything
	var/ignore_source_check = FALSE

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/paused = FALSE	//for suspending the projectile midair
	var/reflected = FALSE
	var/last_projectile_move = 0
	var/last_process = 0
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!
	var/range = 50 //This will de-increment every step. When 0, it will deletze the projectile.
	var/aoe = 0 //For KAs, really

	//Hitscan
	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	var/list/beam_segments	//assoc list of datum/point or datum/point/vector, start = end. Used for hitscan effect generation.
	var/datum/point/beam_index
	var/turf/hitscan_last	//last turf touched during hitscanning.
	var/tracer_type
	var/muzzle_type
	var/impact_type
	var/hit_effect
	var/anti_materiel_potential = 1 //how much the damage of this bullet is increased against mechs

	var/iff // identify friend or foe. will check mob's IDs to see if they match, if they do, won't hit

/obj/item/projectile/CanPass()
	return TRUE

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile/proc/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked >= 100)	//Full block
		return FALSE
	if(!isliving(target))
		return FALSE
	if(isanimal(target))
		return FALSE
	var/mob/living/L = target
	if(damage_type == BRUTE && damage > 5) //weak hits shouldn't make you gush blood
		var/splatter_color = "#A10808"
		var/mob/living/carbon/human/H = target
		if (istype(H) && H.species && H.species.blood_color)
			splatter_color = H.species.blood_color
		var/splatter_dir = starting ? get_dir(starting, target.loc) : dir
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(target.loc, splatter_dir, splatter_color)
	if(hit_effect)
		new hit_effect(target.loc)

	L.apply_effects(0, weaken, paralyze, 0, stutter, eyeblur, drowsy, 0, incinerate, blocked)
	L.stun_effect_act(stun, agony, def_zone, src, damage_flags)
	L.apply_damage(irradiate, IRRADIATE, damage_flags = DAM_DISPERSED) //radiation protection is handled separately from other armor types.
	return 1

//called when the projectile stops flying because it collided with something
/obj/item/projectile/proc/on_impact(var/atom/A, var/affected_limb)
	return

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != BRUTE)
		return FALSE
	return TRUE

/obj/item/projectile/proc/do_embed(var/obj/item/organ/external/organ)
	var/obj/item/SP = new shrapnel_type(organ)
	SP.edge = TRUE
	SP.sharp = TRUE
	SP.name = (name != "shrapnel") ? "[initial(name)] shrapnel" : "shrapnel"
	SP.desc += " It looks like it was fired from [shot_from]."
	SP.forceMove(organ)
	organ.embed(SP)
	return SP

/obj/item/projectile/proc/get_structure_damage()
	if(damage_type == BRUTE || damage_type == BURN)
		return damage * anti_materiel_potential
	return FALSE

//return TRUE if the projectile should be allowed to pass through after all, FALSE if not.
/obj/item/projectile/proc/check_penetrate(atom/A)
	return TRUE

/obj/item/projectile/proc/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	original = target
	def_zone = check_zone(target_zone)
	firer = user
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	preparePixelProjectile(target, user? user : get_turf(src), params, forced_spread)
	return fire(angle_override, direct_target)

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target, target_zone, mob/user, params, angle_override, forced_spread, obj/item/gun/launcher)

	shot_from = launcher.name
	silenced = launcher.silenced

	if(launcher.iff_capable && user)
		iff = get_iff_from_user(user)

	return launch_projectile(target, target_zone, user, params, angle_override, forced_spread)

/obj/item/projectile/proc/get_iff_from_user(var/mob/user)
	var/obj/item/card/id/ID = user.GetIdCard()
	if(ID)
		return ID.iff_faction
	return null

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/item/projectile/proc/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = max(15*(distance-1) - round(25*accuracy) + miss_modifier, 0)
	hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, ranged_attack=(distance > 1 || original != target_mob)) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		if(!target_mob.aura_check(AURA_TYPE_BULLET, src, def_zone))
			return TRUE
		result = target_mob.bullet_act(src, def_zone)

	switch(result)
		if(PROJECTILE_FORCE_MISS)
			if(!point_blank)
				if(!silenced)
					target_mob.visible_message("<span class='notice'>\The [src] misses [target_mob] narrowly!</span>")
					playsound(target_mob, /decl/sound_category/bulletflyby_sound, 50, 1)
				return FALSE
		if(PROJECTILE_DODGED)
			return FALSE
		if(PROJECTILE_STOPPED)
			return TRUE

	var/impacted_organ = target_mob.get_organ_name_from_zone(def_zone)
	//hit messages
	if(silenced)
		to_chat(target_mob, "<span class='danger'>You've been hit in the [impacted_organ] by \a [src]!</span>")
	else
		target_mob.visible_message("<span class='danger'>\The [target_mob] is hit by \a [src] in the [impacted_organ]!</span>", "<span class='danger'><font size=2>You are hit by \a [src] in the [impacted_organ]!</font></span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	var/no_clients = FALSE
	//admin logs
	if((!ismob(firer) || !firer.client) && !target_mob.client)
		no_clients = TRUE
		if(istype(target_mob, /mob/living/heavy_vehicle))
			var/mob/living/heavy_vehicle/HV = target_mob
			for(var/pilot in HV.pilots)
				var/mob/M = pilot
				if(M.client)
					no_clients = FALSE
					break
	if(no_clients)
		no_attack_log = TRUE
	if(!no_attack_log)
		if(ismob(firer))

			var/attacker_message = "shot with \a [src.type]"
			var/victim_message = "shot with \a [src.type]"
			var/admin_message = "shot (\a [src.type])"

			admin_attack_log(firer, target_mob, attacker_message, victim_message, admin_message)
		else
			target_mob.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[target_mob]/[target_mob.ckey]</b> with <b>\a [src]</b>"
			msg_admin_attack("UNKNOWN shot [target_mob] ([target_mob.ckey]) with \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target_mob.x];Y=[target_mob.y];Z=[target_mob.z]'>JMP</a>)",ckey=key_name(target_mob))

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return FALSE

	return TRUE

/obj/item/projectile/Collide(atom/A)
	. = ..()
	if(A == src)
		return FALSE	//no.

	if(A in permutated)
		return FALSE

	if(firer && !ignore_source_check)
		if(A == firer || (A == firer.loc)) //cannot shoot yourself or your mech
			trajectory_ignore_forcemove = TRUE
			forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			return FALSE

	var/distance = get_dist(get_turf(A), starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	var/passthrough = FALSE //if the projectile should continue flying
	if(ismob(A))
		var/mob/M = A
		if(isliving(A)) //so ghosts don't stop bullets
			if(check_iff(M))
				passthrough = TRUE
			else
				if(M.dir & get_dir(M, starting)) // only check neckgrab if they're facing in the direction the bullets came from
					//if they have a neck grab on someone, that person gets hit instead
					for(var/obj/item/grab/G in list(M.l_hand, M.r_hand))
						if(!G.affecting.lying && G.state >= GRAB_NECK)
							visible_message(SPAN_DANGER("\The [M] uses [G.affecting] as a shield!"))
							if(Collide(G.affecting))
								return //If Collide() returns 0 (keep going) then we continue on to attack M.

				passthrough = !attack_mob(M, distance)
		else
			passthrough = TRUE
	else
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/living/M in A)
				attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = TRUE
		penetrating--

	//the bullet passes through a dense object!
	if(passthrough || forcedodge)
		//move ourselves onto A so we can continue on our way.
		if(A)
			trajectory_ignore_forcemove = TRUE
			if(istype(A, /turf))
				forceMove(A)
			else
				forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			permutated.Add(A)
		return FALSE

	//stop flying
	on_impact(A, hit_zone)

	qdel(src)
	return TRUE

/obj/item/projectile/proc/check_iff(var/mob/M)
	if(isnull(iff))
		return FALSE
	var/obj/item/card/id/ID = M.GetIdCard()
	if(ID && (ID.iff_faction == iff))
		return TRUE
	return FALSE

/obj/item/projectile/ex_act(var/severity = 2.0)
	return //explosions probably shouldn't delete projectiles

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/projectile/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	starting = get_turf(source)
	original = target
	setAngle(get_projectile_angle(source, target))

/obj/item/projectile/proc/fire(angle, atom/direct_target)
	//If no angle needs to resolve it from xo/yo!
	if(direct_target)
		direct_target.bullet_act(src, def_zone)
		on_impact(direct_target, def_zone)
		qdel(src)
		return
	if(isnum(angle))
		setAngle(angle)
	// trajectory dispersion
	var/turf/starting = get_turf(src)
	if(!starting)
		return
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			crash_with("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(Clamp(starting + xo, 1, world.maxx), Clamp(starting + yo, 1, world.maxy), starting.z)
		setAngle(get_projectile_angle(src, target))
	if(dispersion)
		setAngle(Angle + rand(-dispersion, dispersion))
	original_angle = Angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	forceMove(starting)
	trajectory = new(starting.x, starting.y, starting.z, 0, 0, Angle, pixel_speed)
	last_projectile_move = world.time
	fired = TRUE
	if(hitscan)
		return process_hitscan()
	else
		if(!isprocessing)
			START_PROCESSING(SSprojectiles, src)
		pixel_move(1)	//move it now!

/obj/item/projectile/proc/preparePixelProjectile(atom/target, atom/source, params, angle_offset = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)
	forceMove(get_turf(source))
	starting = get_turf(source)
	original = target

	var/list/calculated = list(null,null,null)
	if(isliving(source) && params)
		calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]
		setAngle(calculated[1])

	else if(targloc && curloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(get_projectile_angle(src, targloc))
	else
		crash_with("WARNING: Projectile [type] fired without either mouse parameters, or a target atom to aim at!")
		qdel(src)
	if(angle_offset)
		setAngle(Angle + angle_offset)

/obj/item/projectile/proc/before_move()
	return

/obj/item/projectile/proc/after_move()
	return

/obj/item/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	..()
	if(isliving(AM) && (AM.density || AM == original) && !(pass_flags & PASSMOB))
		Collide(AM)

/obj/item/projectile/Initialize()
	. = ..()
	permutated = list()

/obj/item/projectile/damage_flags()
	return damage_flags

/obj/item/projectile/proc/pixel_move(moves, trajectory_multiplier = 1, hitscanning = FALSE)
	if(!loc || !trajectory)
		if(!QDELETED(src))
			if(loc)
				on_impact(loc)
			qdel(src)
		return

	if (QDELETED(src))
		return

	last_projectile_move = world.time
	if(!nondirectional_sprite && !hitscanning)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	trajectory.increment(trajectory_multiplier)
	var/turf/T = trajectory.return_turf()

	if (!T) // Nowhere to go. Just die.
		qdel(src)
		return

	if(T.z != loc.z)
		before_move()
		before_z_change(loc, T)
		trajectory_ignore_forcemove = TRUE
		forceMove(T)
		trajectory_ignore_forcemove = FALSE
		after_move()
		if(!hitscanning)
			pixel_x = trajectory.return_px()
			pixel_y = trajectory.return_py()
	else
		before_move()
		step_towards(src, T)
		after_move()
		if(!hitscanning)
			pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier
			pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier
	if(!hitscanning)
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	if(isturf(loc))
		hitscan_last = loc
	if(can_hit_target(original, permutated))
		Collide(original, TRUE)
	Range()

//Returns true if the target atom is on our current turf and above the right layer
/obj/item/projectile/proc/can_hit_target(atom/target, var/list/passthrough)
	return (target && ((target.layer >= TURF_LAYER + 0.3) || ismob(target)) && (loc == get_turf(target)) && (!(target in passthrough)))

/proc/calculate_projectile_angle_and_pixel_offsets(mob/user, params)
	var/list/mouse_control = params2list(params)
	var/p_x = 0
	var/p_y = 0
	var/angle = 0
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])
	if(mouse_control["screen-loc"])
		//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

		//Split X+Pixel_X up into list(X, Pixel_X)
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")

		//Split Y+Pixel_Y up into list(Y, Pixel_Y)
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32
		var/y = text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32

		//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
		if(istype(user, /mob/living/heavy_vehicle))
			var/mob/living/heavy_vehicle/H = user
			user = pick(H.pilots) //since i assume this is a list, we want only 1 person
		var/list/screenview = getviewsize(user.client.view)
		var/screenviewX = screenview[1] * world.icon_size
		var/screenviewY = screenview[2] * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = Atan2(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/item/projectile/proc/Range()
	range--
	if(range <= 0 && loc)
		on_range()

/obj/item/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	on_impact(loc)
	qdel(src)

/obj/item/projectile/proc/store_hitscan_collision(datum/point/pcache)
	beam_segments[beam_index] = pcache
	beam_index = pcache
	beam_segments[beam_index] = null

/obj/item/projectile/proc/return_predicted_turf_after_moves(moves, forced_angle)		//I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, pixel_speed)
	var/datum/point/vector/v = current.return_vector_after_increments(moves)
	return v.return_turf()

/obj/item/projectile/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return getline(current, ending)

/obj/item/projectile/proc/process_hitscan()
	var/safety = range * 3
	var/return_vector = RETURN_POINT_VECTOR_INCREMENT(src, Angle, MUZZLE_EFFECT_PIXEL_INCREMENT, 1)
	record_hitscan_start(return_vector)
	while(loc && !QDELETED(src))
		if(paused)
			stoplag(1)
			continue
		if(safety-- <= 0)
			qdel(src)
			crash_with("WARNING: [type] projectile encountered infinite recursion during hitscanning in [__FILE__]/[__LINE__]!")
			return	//Kill!
		pixel_move(1, 1, TRUE)

/obj/item/projectile/proc/record_hitscan_start(datum/point/pcache)
	beam_segments = list()	//initialize segment list with the list for the first segment
	beam_index = pcache
	beam_segments[beam_index] = null	//record start.

/obj/item/projectile/proc/vol_by_damage()
	if(src.damage)
		return Clamp((src.damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then CLAMP the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume.

/obj/item/projectile/proc/before_z_change(turf/oldloc, turf/newloc)
	var/datum/point/pcache = trajectory.copy_to()
	if(hitscan)
		store_hitscan_collision(pcache)

/obj/item/projectile/process()
	last_process = world.time
	if(!loc || !fired || !trajectory)
		fired = FALSE
		return PROCESS_KILL
	if(paused || !isturf(loc))
		last_projectile_move += world.time - last_process		//Compensates for pausing, so it doesn't become a hitscan projectile when unpaused from charged up ticks.
		return
	var/elapsed_time_deciseconds = (world.time - last_projectile_move) + time_offset
	time_offset = 0
	var/required_moves = 0
	if(speed > 0)
		required_moves = Floor(elapsed_time_deciseconds / speed, 1)
		if(required_moves > SSprojectiles.global_max_tick_moves)
			var/overrun = required_moves - SSprojectiles.global_max_tick_moves
			required_moves = SSprojectiles.global_max_tick_moves
			time_offset += overrun * speed
		time_offset += Modulus(elapsed_time_deciseconds, speed)
	else
		required_moves = SSprojectiles.global_max_tick_moves
	if(!required_moves)
		return

	for(var/i = 1; i <= required_moves && !QDELETED(src); i++)
		pixel_move(required_moves)

/obj/item/projectile/proc/setAngle(new_angle)	//wrapper for overrides.
	Angle = new_angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile/proc/redirect(x, y, starting, source)
	old_style_target(locate(x, y, z), starting? get_turf(starting) : get_turf(source))

/obj/item/projectile/forceMove(atom/target)
	. = ..()
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)

/obj/item/projectile/Destroy()
	if(hitscan)
		if(loc && trajectory)
			var/datum/point/pcache = trajectory.copy_to()
			beam_segments[beam_index] = pcache
		generate_hitscan_tracers()
	STOP_PROCESSING(SSprojectiles, src)
	return ..()

/obj/item/projectile/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 3)
	if(!length(beam_segments))
		return
	if(duration <= 0)
		return
	if(tracer_type)
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration)
	if(muzzle_type && !silenced)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		QDEL_IN(thing, duration)
	if(impact_type)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(Angle)
		thing.transform = M
		QDEL_IN(thing, duration)
	if(cleanup)
		for(var/i in beam_segments)
			qdel(i)
		beam_segments = null
		QDEL_NULL(beam_index)

/obj/item/projectile/get_print_info()
	. = "<br>"
	. += "Damage: [initial(damage)]<br>"
	. += "Damage Type: [initial(damage_type)]<br>"
	. += "Blocked by Armor Type: [initial(check_armor)]<br>"
	. += "Stuns: [initial(stun) ? "true" : "false"]<br>"
	if(initial(shrapnel_type))
		var/obj/shrapnel = new shrapnel_type
		. += "Shrapnel Type: [shrapnel.name]<br>"
	. += "Armor Penetration: [initial(armor_penetration)]%<br>"