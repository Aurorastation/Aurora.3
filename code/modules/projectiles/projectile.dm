#define MOVES_HITSCAN -1 //Not actually hitscan but close as we get without actual hitscan.
#define MUZZLE_EFFECT_PIXEL_INCREMENT 17 //How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.

/obj/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = TRUE
	unacidable = TRUE
	anchored = TRUE				//There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASSTABLE|PASSRAILING
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/hitsound_wall = ""
	var/projectile_type = /obj/projectile
	var/ping_effect = "ping_b" //Effect displayed when a bullet hits a barricade. See atom/proc/bullet_ping.

	var/def_zone = ""	//Aiming at
	var/hit_zone		// The place that actually got hit
	var/atom/movable/firer = null//Who shot it
	var/datum/fired_from = null // the thing that the projectile was fired from (gun, turret, spell)
	var/suppressed = FALSE	//Attack message

	// var/shot_from = "" // name of the object which shot us

	var/accuracy = 0
	var/dispersion = 0.0

	//used for shooting at blank range, you shouldn't be able to miss
	var/point_blank = FALSE

	//Homing
	var/homing = FALSE
	var/atom/homing_target
	var/homing_turn_speed = 10 //Angle per tick.
	var/homing_inaccuracy_min = 0 //in pixels for these. offsets are set once when setting target.
	var/homing_inaccuracy_max = 0
	var/homing_offset_x = 0
	var/homing_offset_y = 0

	//Effects
	var/damage = 10
	var/damage_type = DAMAGE_BRUTE		//DAMAGE_BRUTE, DAMAGE_BURN, DAMAGE_TOXIN, DAMAGE_OXY, DAMAGE_CLONE, DAMAGE_PAIN are the only things that should be in here
	var/damage_flags = DAMAGE_FLAG_BULLET
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

	var/impact_effect_type //what type of impact effect to show when hitting something
	var/log_override = FALSE //is this type spammed enough to not log? (KAs)
	/// If true, the projectile won't cause any logging. Used for hallucinations and shit.
	var/do_not_log = FALSE

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

	/// If objects are below this layer, we pass through them
	var/hit_threshhold = PROJECTILE_HIT_THRESHHOLD_LAYER

	/// During each fire of SSprojectiles, the number of deciseconds since the last fire of SSprojectiles
	/// is divided by this var, and the result truncated to the next lowest integer is
	/// the number of times the projectile's `pixel_move` proc will be called.
	var/speed = 0.2

	/// This var is multiplied by SSprojectiles.global_pixel_speed to get how many pixels
	/// the projectile moves during each iteration of the movement loop
	///
	/// If you want to make a fast-moving projectile, you should keep this equal to 1 and
	/// reduce the value of `speed`. If you want to make a slow-moving projectile, make
	/// `speed` a modest value like 1 and set this to a low value like 0.2.
	var/pixel_speed_multiplier = 1

	var/pixel_speed = 33	//pixels per move - DO NOT FUCK WITH THIS UNLESS YOU ABSOLUTELY KNOW WHAT YOU ARE DOING OR UNEXPECTED THINGS /WILL/ HAPPEN!
	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/spread = 0 //amount (in degrees) of projectile spread
	animate_movement = NO_STEPS //Use SLIDE_STEPS in conjunction with legacy
	/// how many times we've ricochet'd so far (instance variable, not a stat)
	var/ricochets = 0
	/// how many times we can ricochet max
	var/ricochets_max = 0
	/// how many times we have to ricochet min (unless we hit an atom we can ricochet off)
	var/min_ricochets = 0
	/// 0-100 (or more, I guess), the base chance of ricocheting, before being modified by the atom we shoot and our chance decay
	var/ricochet_chance = 0
	/// 0-1 (or more, I guess) multiplier, the ricochet_chance is modified by multiplying this after each ricochet
	var/ricochet_decay_chance = 0.7
	/// 0-1 (or more, I guess) multiplier, the projectile's damage is modified by multiplying this after each ricochet
	var/ricochet_decay_damage = 0.7
	/// On ricochet, if nonzero, we consider all mobs within this range of our projectile at the time of ricochet to home in on like Revolver Ocelot, as governed by ricochet_auto_aim_angle
	var/ricochet_auto_aim_range = 0
	/// On ricochet, if ricochet_auto_aim_range is nonzero, we'll consider any mobs within this range of the normal angle of incidence to home in on, higher = more auto aim
	var/ricochet_auto_aim_angle = 30
	/// the angle of impact must be within this many degrees of the struck surface, set to 0 to allow any angle
	var/ricochet_incidence_leeway = 40
	/// Can our ricochet autoaim hit our firer?
	var/ricochet_shoots_firer = TRUE

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
	/// We already impacted these things, do not impact them again. Used to make sure we can pierce things we want to pierce. Lazylist, typecache style (object = TRUE) for performance.
	var/list/impacted = list()

	/// We are flagged PHASING temporarily to not stop moving when we Bump something but want to keep going anyways.
	var/temporary_unstoppable_movement = FALSE

	var/range = 50 //This will de-increment every step. When 0, it will deletze the projectile.
	var/aoe = 0 //For KAs, really

	//Hitscan
	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	var/list/beam_segments	//assoc list of datum/point or datum/point/vector, start = end. Used for hitscan effect generation.
	/// Last turf an angle was changed in for hitscan projectiles.
	var/turf/last_angle_set_hitscan_store
	var/datum/point/beam_index
	var/turf/hitscan_last	//last turf touched during hitscanning.
	var/tracer_type
	var/muzzle_type
	var/impact_type

	//Fancy hitscan lighting effects!
	var/hitscan_light_intensity = 1.5
	var/hitscan_light_range = 0.75
	var/hitscan_light_color_override
	var/muzzle_flash_intensity = 3
	var/muzzle_flash_range = 1.5
	var/muzzle_flash_color_override
	var/impact_light_intensity = 3
	var/impact_light_range = 2
	var/impact_light_color_override

	var/anti_materiel_potential = 1 //how much the damage of this bullet is increased against mechs

	var/iff // identify friend or foe. will check mob's IDs to see if they match, if they do, won't hit

	///If the projectile launches a secondary projectile in addition to itself.
	var/secondary_projectile

	/// If true directly targeted turfs can be hit
	var/can_hit_turfs = FALSE

/obj/projectile/Initialize()
	. = ..()
	permutated = list()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/projectile/proc/Range()
	range--
	SEND_SIGNAL(src, COMSIG_PROJECTILE_RANGE)
	if(range <= 0 && loc)
		on_range()

/obj/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	SEND_SIGNAL(src, COMSIG_PROJECTILE_RANGE_OUT)
	qdel(src)

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/projectile/proc/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	SHOULD_CALL_PARENT(TRUE)

	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_ON_HIT, firer, target, Angle, def_zone, blocked)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_SELF_ON_HIT, firer, target, Angle, def_zone, blocked)

	if(QDELETED(src)) // in case one of the above signals deleted the projectile for whatever reason
		return BULLET_ACT_BLOCK
	var/turf/target_turf = get_turf(target)

	var/hitx
	var/hity
	if(target == original)
		hitx = target.pixel_x + p_x - 16
		hity = target.pixel_y + p_y - 16
	else
		hitx = target.pixel_x + rand(-8, 8)
		hity = target.pixel_y + rand(-8, 8)

	if(isturf(target_turf) && hitsound_wall)
		var/volume = clamp(vol_by_damage() + 20, 0, 100)
		if(suppressed)
			volume = 5
		playsound(loc, hitsound_wall, volume, TRUE, -1)

	if(blocked >= 100)	//Full block
		return BULLET_ACT_BLOCK

	if(damage_type == DAMAGE_BRUTE && damage > 5) //weak hits shouldn't make you gush blood
		var/splatter_color = COLOR_HUMAN_BLOOD
		var/mob/living/carbon/human/H = target
		if (istype(H) && H.species && H.get_blood_color())
			splatter_color = H.get_blood_color()
		var/splatter_dir = starting ? get_dir(starting, target.loc) : dir
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(target.loc, splatter_dir, splatter_color)

	if(!isliving(target))
		if(impact_effect_type && !hitscan)
			new impact_effect_type(target_turf, hitx, hity)
		return BULLET_ACT_HIT

	var/mob/living/living_target = target

	living_target.apply_effects(0, weaken, paralyze, 0, stutter, eyeblur, drowsy, 0, incinerate, blocked)
	living_target.stun_effect_act(stun, agony, def_zone, src, damage_flags)
	living_target.apply_damage(irradiate, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED) //radiation protection is handled separately from other armor types.
	return BULLET_ACT_HIT

/obj/projectile/proc/vol_by_damage()
	if(src.damage)
		return clamp((src.damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then CLAMP the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume

/obj/projectile/proc/on_ricochet(atom/A)
	if(!ricochet_auto_aim_angle || !ricochet_auto_aim_range)
		return

	var/mob/living/unlucky_sob
	var/best_angle = ricochet_auto_aim_angle
	// if(firer && HAS_TRAIT(firer, TRAIT_NICE_SHOT))
	// 	best_angle += NICE_SHOT_RICOCHET_BONUS
	for(var/mob/living/L in range(ricochet_auto_aim_range, src.loc))
		if(L.stat == DEAD || !is_in_sight(src, L) || (!ricochet_shoots_firer && L == firer))
			continue
		var/our_angle = abs(closer_angle_difference(Angle, get_angle(src.loc, L.loc)))
		if(our_angle < best_angle)
			best_angle = our_angle
			unlucky_sob = L

	if(unlucky_sob)
		set_angle(get_angle(src, unlucky_sob.loc))

/obj/projectile/proc/store_hitscan_collision(datum/point/point_cache)
	beam_segments[beam_index] = point_cache
	beam_index = point_cache
	beam_segments[beam_index] = null

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != DAMAGE_BRUTE)
		return FALSE
	return TRUE

//return TRUE if the projectile should be allowed to pass through after all, FALSE if not.
/obj/projectile/proc/check_penetrate(atom/A)
	return TRUE

/obj/projectile/Collide(atom/A)
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	if(!can_hit_target(A, A == original, TRUE, TRUE))
		return
	Impact(A)


/obj/projectile/proc/Impact(atom/A)
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

/obj/projectile/ex_act(var/severity = 2.0)
	return //explosions probably shouldn't delete projectiles

/obj/projectile/proc/fire(angle, atom/direct_target)
	LAZYINITLIST(impacted)
	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_BEFORE_FIRE, src, original)
	if(firer)
		SEND_SIGNAL(firer, COMSIG_PROJECTILE_FIRER_BEFORE_FIRE, src, fired_from, original)
	if(!log_override && firer && original && !do_not_log)
		log_combat(firer, original, "fired at", src, "from [get_area_name(src, TRUE)]")
			//note: mecha projectile logging is handled in /obj/item/mecha_parts/mecha_equipment/weapon/action(). try to keep these messages roughly the sameish just for consistency's sake.
	if(direct_target && (get_dist(direct_target, get_turf(src)) <= 1)) // point blank shots
		// process_hit(get_turf(direct_target), direct_target)
		if(QDELETED(src))
			return
	var/turf/starting = get_turf(src)
	if(isnum(angle))
		set_angle(angle)
	else if(isnull(Angle)) //Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(clamp(starting + xo, 1, world.maxx), clamp(starting + yo, 1, world.maxy), starting.z)
		set_angle(get_angle(src, target))
	if(spread)
		set_angle(Angle + (rand() - 0.5) * spread)
	original_angle = Angle
	trajectory_ignore_forcemove = TRUE
	forceMove(starting)
	trajectory_ignore_forcemove = FALSE
	trajectory = new(starting.x, starting.y, starting.z, pixel_x, pixel_y, Angle, SSprojectiles.global_pixel_speed)
	last_projectile_move = world.time
	fired = TRUE
	// play_fov_effect(starting, 6, "gunfire", dir = NORTH, angle = Angle)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_FIRE)
	if(hitscan)
		process_hitscan()
		if(QDELETED(src))
			return
	if(!(datum_flags & DF_ISPROCESSING))
		START_PROCESSING(SSprojectiles, src)
	pixel_move(pixel_speed_multiplier, FALSE) //move it now!

/obj/projectile/set_angle(new_angle) //wrapper for overrides.
	. = ..()

	if(!nondirectional_sprite)
		transform = transform.TurnTo(Angle, new_angle)
	Angle = new_angle
	if(trajectory)
		trajectory.set_angle(new_angle)
	if(fired && hitscan && isloc(loc) && (loc != last_angle_set_hitscan_store))
		last_angle_set_hitscan_store = loc
		var/datum/point/point_cache = new (src)
		point_cache = trajectory.copy_to()
		store_hitscan_collision(point_cache)
	return TRUE

/// Same as set_angle, but the reflection continues from the center of the object that reflects it instead of the side
/obj/projectile/proc/set_angle_centered(new_angle)
	if(!nondirectional_sprite)
		transform = transform.TurnTo(Angle, new_angle)
	Angle = new_angle
	if(trajectory)
		trajectory.set_angle(new_angle)

	var/list/coordinates = trajectory.return_coordinates()
	trajectory.set_location(coordinates[1], coordinates[2], coordinates[3]) // Sets the trajectory to the center of the tile it bounced at

	if(fired && hitscan && isloc(loc) && (loc != last_angle_set_hitscan_store)) // Handles hitscan projectiles
		last_angle_set_hitscan_store = loc
		var/datum/point/point_cache = new (src)
		point_cache.initialize_location(coordinates[1], coordinates[2], coordinates[3]) // Take the center of the hitscan collision tile
		store_hitscan_collision(point_cache)
	return TRUE



/obj/projectile/forceMove(atom/target)
	if(!isloc(target) || !isloc(loc) || !z)
		return ..()
	var/zc = target.z != z
	var/old = loc
	if(zc)
		before_z_change(old, target)
	. = ..()
	if(QDELETED(src)) // we coulda bumped something
		return
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		// if(hitscan)
		// 	finalize_hitscan_and_generate_tracers(FALSE)
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)
		if(hitscan)
			record_hitscan_start(RETURN_PRECISE_POINT(src))
	if(zc)
		after_z_change(old, target)

/obj/projectile/proc/after_z_change(atom/olcloc, atom/newloc)

/obj/projectile/proc/before_z_change(turf/oldloc, turf/newloc)
	var/datum/point/pcache = trajectory.copy_to()
	if(hitscan)
		store_hitscan_collision(pcache)

/obj/projectile/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, Angle))
			set_angle(var_value)
			return TRUE
		else
			return ..()

/obj/projectile/proc/set_pixel_speed(new_speed)
	if(trajectory)
		trajectory.set_speed(new_speed)
		return TRUE
	return FALSE

/obj/projectile/proc/record_hitscan_start(datum/point/point_cache)
	if(point_cache)
		beam_segments = list()
		beam_index = point_cache
		beam_segments[beam_index] = null //record start.

/obj/projectile/proc/process_hitscan()
	var/safety = range * 10
	record_hitscan_start(RETURN_POINT_VECTOR_INCREMENT(src, Angle, MUZZLE_EFFECT_PIXEL_INCREMENT, 1))
	while(loc && !QDELETED(src))
		if(paused)
			stoplag(1)
			continue
		if(safety-- <= 0)
			if(loc)
				Collide(loc) // Bump(loc)
			if(!QDELETED(src))
				qdel(src)
			return //Kill!
		pixel_move(1, TRUE)
		// No kevinz I do not care that this is a hitscan weapon, it is not allowed to travel 100 turfs in a tick
		if(CHECK_TICK && QDELETED(src))
			return

/obj/projectile/proc/pixel_move(trajectory_multiplier, hitscanning = FALSE)
	if(!loc || !trajectory)
		return
	last_projectile_move = world.time
	if(homing)
		process_homing()
	var/forcemoved = FALSE
	for(var/i in 1 to SSprojectiles.global_iterations_per_move)
		if(QDELETED(src))
			return
		trajectory.increment(trajectory_multiplier)
		var/turf/T = trajectory.return_turf()
		if(!istype(T))
			// step back to the last valid turf before we Destroy
			trajectory.increment(-trajectory_multiplier)
			qdel(src)
			return
		if (T == loc)
			continue
		if (T.z == loc.z)
			step_towards(src, T)
			hitscan_last = loc
			SEND_SIGNAL(src, COMSIG_PROJECTILE_PIXEL_STEP)
			continue
		var/old = loc
		before_z_change(loc, T)
		trajectory_ignore_forcemove = TRUE
		forceMove(T)
		trajectory_ignore_forcemove = FALSE
		after_z_change(old, loc)
		if(!hitscanning)
			pixel_x = trajectory.return_px()
			pixel_y = trajectory.return_py()
		forcemoved = TRUE
		hitscan_last = loc
		SEND_SIGNAL(src, COMSIG_PROJECTILE_PIXEL_STEP)
	if(QDELETED(src)) //deleted on last move
		return
	if(!hitscanning && !forcemoved)
		pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	Range()

/obj/projectile/proc/process_homing() //may need speeding up in the future performance wise.
	if(!homing_target)
		return FALSE
	var/datum/point/PT = RETURN_PRECISE_POINT(homing_target)
	PT.x += clamp(homing_offset_x, 1, world.maxx)
	PT.y += clamp(homing_offset_y, 1, world.maxy)
	var/angle = closer_angle_difference(Angle, angle_between_points(RETURN_PRECISE_POINT(src), PT))
	set_angle(Angle + clamp(angle, -homing_turn_speed, homing_turn_speed))

/obj/projectile/proc/set_homing_target(atom/A)
	if(!A || (!isturf(A) && !isturf(A.loc)))
		return FALSE
	homing = TRUE
	homing_target = A
	homing_offset_x = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	homing_offset_y = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	if(prob(50))
		homing_offset_x = -homing_offset_x
	if(prob(50))
		homing_offset_y = -homing_offset_y

/**
 * Aims the projectile at a target.
 *
 * Must be passed at least one of a target or a list of click parameters.
 * If only passed the click modifiers the source atom must be a mob with a client.
 *
 * Arguments:
 * - [target][/atom]: (Optional) The thing that the projectile will be aimed at.
 * - [source][/atom]: The initial location of the projectile or the thing firing it.
 * - [modifiers][/list]: (Optional) A list of click parameters to apply to this operation.
 * - deviation: (Optional) How the trajectory should deviate from the target in degrees.
 *   - //Spread is FORCED!
 */
/obj/projectile/proc/preparePixelProjectile(atom/target, atom/source, list/modifiers = null, deviation = 0)
	if(!(isnull(modifiers) || islist(modifiers)))
		stack_trace("WARNING: Projectile [type] fired with non-list modifiers, likely was passed click params.")
		modifiers = null

	var/turf/source_loc = get_turf(source)
	var/turf/target_loc = get_turf(target)
	if(isnull(source_loc))
		stack_trace("WARNING: Projectile [type] fired from nullspace.")
		qdel(src)
		return FALSE

	trajectory_ignore_forcemove = TRUE
	forceMove(source_loc)
	trajectory_ignore_forcemove = FALSE

	starting = source_loc
	// Find the last atom movable in our loc chain, or if we're a turf use us
	var/atom/source_position = get_highest_loc(source, /atom/movable) || source
	pixel_x = source_position.pixel_x
	pixel_y = source_position.pixel_y
	pixel_w = source_position.pixel_w
	pixel_z = source_position.pixel_z
	original = target
	if(length(modifiers))
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source_position, target_loc && target, modifiers)

		p_x = calculated[2]
		p_y = calculated[3]
		set_angle(calculated[1] + deviation)
		return TRUE

	if(target_loc)
		yo = target_loc.y - source_loc.y
		xo = target_loc.x - source_loc.x
		set_angle(get_angle(src, target_loc) + deviation)
		return TRUE

	stack_trace("WARNING: Projectile [type] fired without a target or mouse parameters to aim with.")
	qdel(src)
	return FALSE


/**
 * Calculates the pixel offsets and angle that a projectile should be launched at.
 *
 * Arguments:
 * - [source][/atom]: The thing that the projectile is being shot from.
 * - [target][/atom]: (Optional) The thing that the projectile is being shot at.
 *   - If this is not provided the  source atom must be a mob with a client.
 * - [modifiers][/list]: A list of click parameters used to modify the shot angle.
 */
/proc/calculate_projectile_angle_and_pixel_offsets(atom/source, atom/target, modifiers)
	var/angle = 0
	var/p_x = LAZYACCESS(modifiers, ICON_X) ? text2num(LAZYACCESS(modifiers, ICON_X)) : world.icon_size / 2 // ICON_(X|Y) are measured from the bottom left corner of the icon.
	var/p_y = LAZYACCESS(modifiers, ICON_Y) ? text2num(LAZYACCESS(modifiers, ICON_Y)) : world.icon_size / 2 // This centers the target if modifiers aren't passed.

	if(target)
		var/turf/source_loc = get_turf(source)
		var/turf/target_loc = get_turf(target)
		var/dx = ((target_loc.x - source_loc.x) * world.icon_size) + (target.pixel_x - source.pixel_x) + (p_x - (world.icon_size / 2))
		var/dy = ((target_loc.y - source_loc.y) * world.icon_size) + (target.pixel_y - source.pixel_y) + (target.pixel_z - source.pixel_z) + (p_y - (world.icon_size / 2))
		angle = ATAN2(dy, dx)
		return list(angle, p_x, p_y)

	if(!ismob(source) || !LAZYACCESS(modifiers, SCREEN_LOC))
		CRASH("Can't make trajectory calculations without a target or click modifiers and a client.")

	var/mob/user = source
	if(!user.client)
		CRASH("Can't make trajectory calculations without a target or click modifiers and a client.")

	//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
	var/list/screen_loc_params = splittext(LAZYACCESS(modifiers, SCREEN_LOC), ",")
	//Split X+Pixel_X up into list(X, Pixel_X)
	var/list/screen_loc_X = splittext(screen_loc_params[1],":")
	//Split Y+Pixel_Y up into list(Y, Pixel_Y)
	var/list/screen_loc_Y = splittext(screen_loc_params[2],":")

	var/tx = (text2num(screen_loc_X[1]) - 1) * world.icon_size + text2num(screen_loc_X[2])
	// We are here trying to lower our target location by the firing source's visual offset
	// So visually things make a nice straight line while properly accounting for actual physical position
	var/ty = (text2num(screen_loc_Y[1]) - 1) * world.icon_size + text2num(screen_loc_Y[2]) - source.pixel_z

	//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
	var/list/screenview = view_to_pixels(user.client.view)

	var/ox = round(screenview[1] / 2) - user.client.pixel_x //"origin" x
	var/oy = round(screenview[2] / 2) - user.client.pixel_y - source.pixel_z //"origin" y
	angle = ATAN2(tx - oy, ty - ox)
	return list(angle, p_x, p_y)

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/projectile/proc/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE, cross_failed = FALSE)
	if(QDELETED(target) || impacted[target.weak_reference])
		return FALSE
	if(!ignore_loc && (loc != target.loc) && !(can_hit_turfs && direct_target && loc == target))
		return FALSE
	// if pass_flags match, pass through entirely - unless direct target is set.
	if((target.pass_flags_self & pass_flags) && !direct_target)
		return FALSE
	// if(HAS_TRAIT(target, TRAIT_UNHITTABLE_BY_PROJECTILES))
	// 	if(!HAS_TRAIT(target, TRAIT_BLOCKING_PROJECTILES) && isliving(target))
	// 		var/mob/living/living_target = target
	// 		living_target.block_projectile_effects()
	// 	return FALSE
	if(target.density || cross_failed) //This thing blocks projectiles, hit it regardless of layer/mob stuns/etc.
		return TRUE
	if(!isliving(target))
		if(isturf(target)) // non dense turfs
			return can_hit_turfs && direct_target
		if(target.layer < hit_threshhold)
			return FALSE
		else if(!direct_target) // non dense objects do not get hit unless specifically clicked
			return FALSE
	// else
	// 	var/mob/living/living_target = target
	// 	if(direct_target)
	// 		return TRUE
	// 	if(living_target.stat == DEAD)
	// 		return FALSE
	// 	if(HAS_TRAIT(living_target, TRAIT_IMMOBILIZED) && HAS_TRAIT(living_target, TRAIT_FLOORED) && HAS_TRAIT(living_target, TRAIT_HANDS_BLOCKED))
	// 		return FALSE
	// 	if(hit_prone_targets)
	// 		var/mob/living/buckled_to = living_target.lowest_buckled_mob()
	// 		if((decayedRange - range) <= MAX_RANGE_HIT_PRONE_TARGETS) // after MAX_RANGE_HIT_PRONE_TARGETS tiles, auto-aim hit for mobs on the floor turns off
	// 			return TRUE
	// 		if(ignore_range_hit_prone_targets) // doesn't apply to projectiles that must hit the target in combat mode or something else, no matter what
	// 			return TRUE
	// 		if(buckled_to.density) // Will just be us if we're not buckled to another mob
	// 			return TRUE
	// 		return FALSE
	// 	else if(living_target.body_position == LYING_DOWN)
	// 		return FALSE
	return (target && (loc == get_turf(target)))

/**
 * Scan if we should hit something and hit it if we need to
 * The difference between this and handling in Impact is
 * In this we strictly check if we need to Impact() something in specific
 * If we do, we do
 * We don't even check if it got hit already - Impact() does that
 * In impact there's more code for selecting WHAT to hit
 * So this proc is more of checking if we should hit something at all BY having an atom cross us.
 */
/obj/projectile/proc/scan_crossed_hit(atom/movable/A)
	if(can_hit_target(A, direct_target = (A == original)))
		Impact(A)

/**
 * Scans if we should hit something on the turf we just moved to if we haven't already
 *
 * This proc is a little high in overhead but allows us to not snowflake CanPass in living and other things.
 */
/obj/projectile/proc/scan_moved_turf()
	// Optimally, we scan: mobs --> objs --> turf for impact
	// but, overhead is a thing and 2 for loops every time it moves is a no-go.
	// realistically, since we already do select_target in impact, we can not do that
	// and hope projectiles get refactored again in the future to have a less stupid impact detection system
	// that hopefully won't also involve a ton of overhead
	if(can_hit_target(original, TRUE, FALSE))
		Impact(original) // try to hit thing clicked on
	// else, try to hit mobs
	else // because if we impacted original and pierced we'll already have select target'd and hit everything else we should be hitting
		for(var/mob/M in loc) // so I guess we're STILL doing a for loop of mobs because living movement would otherwise have snowflake code for projectile CanPass
			// so the snowflake vs performance is pretty arguable here
			if(can_hit_target(M, M == original, TRUE))
				Impact(M)
				break

/**
 * Projectile crossed: When something enters a projectile's tile, make sure the projectile hits it if it should be hitting it.
 */
/obj/projectile/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	scan_crossed_hit(AM)

/**
 * Projectile can pass through
 * Used to not even attempt to Bump() or fail to Cross() anything we already hit.
 *
 * This was called CanPassThrough() on TG but we don't have it yet
 */
/obj/projectile/CanPass(atom/blocker, movement_dir, blocker_opinion)
	return ..() || impacted[blocker.weak_reference]

/**
 * Projectile moved:
 *
 * If not fired yet, do not do anything. Else,
 *
 * If temporary unstoppable movement used for piercing through things we already hit (impacted list) is set, unset it.
 * Scan turf we're now in for anything we can/should hit. This is useful for hitting non dense objects the user
 * directly clicks on, as well as for PHASING projectiles to be able to hit things at all as they don't ever Bump().
 */
/obj/projectile/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(!fired)
		return
	if(temporary_unstoppable_movement)
		temporary_unstoppable_movement = FALSE
		// movement_type &= ~PHASING
	scan_moved_turf() //mostly used for making sure we can hit a non-dense object the user directly clicked on, and for penetrating projectiles that don't bump

/obj/projectile/proc/return_predicted_turf_after_moves(moves, forced_angle) //I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, SSprojectiles.global_pixel_speed)
	var/datum/point/vector/v = current.return_vector_after_increments(moves * SSprojectiles.global_iterations_per_move)
	return v.return_turf()

/obj/projectile/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return get_line(current, ending)

/obj/projectile/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	return TRUE //Bullets don't drift in space

/obj/projectile/process()
	last_process = world.time
	if(!loc || !fired || !trajectory)
		fired = FALSE
		return PROCESS_KILL
	if(paused || !isturf(loc))
		last_projectile_move += world.time - last_process //Compensates for pausing, so it doesn't become a hitscan projectile when unpaused from charged up ticks.
		return
	var/elapsed_time_deciseconds = (world.time - last_projectile_move) + time_offset
	time_offset = 0
	var/required_moves = speed > 0? FLOOR(elapsed_time_deciseconds / speed, 1) : MOVES_HITSCAN //Would be better if a 0 speed made hitscan but everyone hates those so I can't make it a universal system :<
	if(required_moves == MOVES_HITSCAN)
		required_moves = SSprojectiles.global_max_tick_moves
	else
		if(required_moves > SSprojectiles.global_max_tick_moves)
			var/overrun = required_moves - SSprojectiles.global_max_tick_moves
			required_moves = SSprojectiles.global_max_tick_moves
			time_offset += overrun * speed
		time_offset += MODULUS(elapsed_time_deciseconds, speed)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_BEFORE_MOVE)
	for(var/i in 1 to required_moves)
		pixel_move(pixel_speed_multiplier, FALSE)

/obj/projectile/Destroy()
	if(hitscan)
		finalize_hitscan_and_generate_tracers()
	STOP_PROCESSING(SSprojectiles, src)
	cleanup_beam_segments()
	if(trajectory)
		QDEL_NULL(trajectory)
	return ..()

/obj/projectile/proc/cleanup_beam_segments()
	QDEL_LIST_ASSOC(beam_segments)
	beam_segments = list()
	QDEL_NULL(beam_index)

/obj/projectile/proc/finalize_hitscan_and_generate_tracers(impacting = TRUE)
	if(trajectory && beam_index)
		var/datum/point/point_cache = trajectory.copy_to()
		beam_segments[beam_index] = point_cache
	generate_hitscan_tracers(null, null, impacting)

/obj/projectile/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 3, impacting = TRUE)
	if(!length(beam_segments))
		return
	if(tracer_type)
		var/tempref = REF(src)
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity, tempref)
	if(muzzle_type && duration > 0)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/matrix = new
		matrix.Turn(original_angle)
		thing.transform = matrix
		thing.color = color
		thing.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override? muzzle_flash_color_override : color)
		QDEL_IN(thing, duration)
	if(impacting && impact_type && duration > 0)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		p.move_atom_to_src(thing)
		var/matrix/matrix = new
		matrix.Turn(Angle)
		thing.transform = matrix
		thing.color = color
		thing.set_light(impact_light_range, impact_light_intensity, impact_light_color_override? impact_light_color_override : color)
		QDEL_IN(thing, duration)
	if(cleanup)
		cleanup_beam_segments()



/*##############################
	AURORA SNOWFLAKE SECTION
##############################*/


/obj/projectile/damage_flags()
	return damage_flags

/obj/projectile/proc/before_move()
	return

/obj/projectile/proc/after_move()
	return

/obj/projectile/proc/check_iff(var/mob/M)
	if(isnull(iff))
		return FALSE
	var/obj/item/card/id/ID = M.GetIdCard()
	if(ID && (ID.iff_faction == iff))
		return TRUE
	return FALSE

/obj/projectile/proc/get_structure_damage()
	if(damage_type == DAMAGE_BRUTE || damage_type == DAMAGE_BURN)
		return damage * anti_materiel_potential
	return FALSE

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/projectile/proc/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = max(15*(distance-1) - round(25*accuracy) + miss_modifier, 0)
	hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, (distance > 1 || original != target_mob), point_blank) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		if(!target_mob.aura_check(AURA_TYPE_BULLET, src, def_zone))
			return TRUE
		result = target_mob.bullet_act(src, def_zone)

	switch(result)
		if(PROJECTILE_FORCE_MISS)
			if(!point_blank)
				if(!suppressed)
					target_mob.visible_message(SPAN_NOTICE("\The [src] misses [target_mob] narrowly!"))
					playsound(target_mob, /singleton/sound_category/bulletflyby_sound, 50, 1)
				return FALSE
		if(PROJECTILE_DODGED)
			return FALSE
		if(PROJECTILE_STOPPED)
			return TRUE

	var/impacted_organ = target_mob.get_organ_name_from_zone(def_zone)
	//hit messages
	if(suppressed)
		to_chat(target_mob, SPAN_DANGER("You've been hit in the [impacted_organ] by \a [src]!"))
	else
		target_mob.visible_message(SPAN_DANGER("\The [target_mob] is hit by \a [src] in the [impacted_organ]!"),
									SPAN_DANGER("<font size=2>You are hit by \a [src] in the [impacted_organ]!</font>"))//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	var/no_clients = FALSE
	//admin logs
	if((!ismob(firer) || !(ismob(firer) && firer:client)) && !target_mob.client)
		no_clients = TRUE
		if(istype(target_mob, /mob/living/heavy_vehicle))
			var/mob/living/heavy_vehicle/HV = target_mob
			for(var/pilot in HV.pilots)
				var/mob/M = pilot
				if(M.client)
					no_clients = FALSE
					break
	if(!no_clients)
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

/obj/projectile/proc/do_embed(var/obj/item/organ/external/organ)
	var/obj/item/SP = new shrapnel_type(organ)
	SP.edge = TRUE
	SP.sharp = TRUE
	SP.name = (name != "shrapnel") ? "[initial(name)] shrapnel" : "shrapnel"
	SP.desc += " It looks like it was fired from [fired_from]."
	SP.forceMove(organ)
	organ.embed(SP)
	return SP

//called when the projectile stops flying because it collided with something
/obj/projectile/proc/on_impact(var/atom/A, var/affected_limb)
	return

/// Fire a projectile from this atom at another atom
/atom/proc/fire_projectile(projectile_type, atom/target, sound, firer, list/ignore_targets = list())
	if (!isnull(sound))
		playsound(src, sound, vol = 100, vary = TRUE)

	var/turf/startloc = get_turf(src)
	var/obj/projectile/bullet = new projectile_type(startloc)
	bullet.starting = startloc
	// for (var/atom/thing as anything in ignore_targets)
	// 	bullet.impacted[WEAKREF(thing)] = TRUE
	bullet.firer = firer || src
	bullet.fired_from = src
	bullet.yo = target.y - startloc.y
	bullet.xo = target.x - startloc.x
	bullet.original = target
	bullet.preparePixelProjectile(target, src)
	bullet.fire()
	return bullet

/obj/projectile/proc/get_iff_from_user(var/mob/user)
	var/obj/item/card/id/ID = user.GetIdCard()
	if(ID)
		return ID.iff_faction
	return null

/obj/projectile/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	starting = get_turf(source)
	original = target
	setAngle(get_projectile_angle(source, target))

/obj/projectile/proc/setAngle(new_angle)	//wrapper for overrides.
	Angle = new_angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/projectile/proc/redirect(x, y, starting, source)
	old_style_target(locate(x, y, z), starting? get_turf(starting) : get_turf(source))

/obj/projectile/proc/get_print_info()
	. = "<br>"
	. += "Damage: [initial(damage)]<br>"
	. += "Damage Type: [initial(damage_type)]<br>"
	. += "Blocked by Armor Type: [initial(check_armor)]<br>"
	. += "Stuns: [initial(stun) ? "true" : "false"]<br>"
	if(initial(shrapnel_type))
		var/obj/shrapnel = new shrapnel_type
		. += "Shrapnel Type: [shrapnel.name]<br>"
	. += "Armor Penetration: [initial(armor_penetration)]%<br>"

/obj/projectile/proc/generate_muzzle_flash(duration = 3)
	if(duration <= 0)
		return
	if(!muzzle_type || suppressed)
		return
	var/datum/point/p = trajectory
	var/atom/movable/thing = new muzzle_type
	p.move_atom_to_src(thing)
	var/matrix/M = new
	M.Turn(original_angle)
	thing.transform = M
	QDEL_IN(thing, duration)


//This is where the bullet bounces off.
/atom/proc/bullet_ping(obj/projectile/P, var/pixel_x_offset, var/pixel_y_offset)
	if(!P || !P.ping_effect)
		return

	var/image/I = image('icons/obj/projectiles.dmi', src,P.ping_effect,10, pixel_x = pixel_x_offset, pixel_y = pixel_y_offset)
	var/angle = (P.firer && prob(60)) ? round(Get_Angle(P.firer,src)) : round(rand(1,359))
	I.pixel_x += rand(-6,6)
	I.pixel_y += rand(-6,6)

	var/matrix/rotate = matrix()
	rotate.Turn(angle)
	I.transform = rotate
	// Need to do this in order to prevent the ping from being deleted
	addtimer(CALLBACK(I, TYPE_PROC_REF(/image, flick_overlay), src, 3), 1)


/image/proc/flick_overlay(var/atom/A, var/duration)
	A.overlays.Add(src)
	addtimer(CALLBACK(src, PROC_REF(flick_remove_overlay), A), duration)

/image/proc/flick_remove_overlay(var/atom/A)
	if(A)
		A.overlays.Remove(src)

#undef MOVES_HITSCAN
#undef MUZZLE_EFFECT_PIXEL_INCREMENT
