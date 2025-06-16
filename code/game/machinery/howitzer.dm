/**
 * # Howitzer
 *
 * Howitzers are a field weapon capable of delivering artillery fire to a location
 */
ABSTRACT_TYPE(/obj/machinery/howitzer)
	name = "howitzer"

	icon = 'icons/obj/machinery/howitzer/howitzer.dmi'
	icon_state = "howitzer_deployed"
	dir = NORTH

	//Big thing
	w_class = WEIGHT_CLASS_HUGE

	//Can't pass through it
	density = TRUE

	//Can't move it around
	anchored = TRUE

	//Align the icon with the turf
	pixel_x = -16

	/**
	 * List of allowed ammo types that this howitzer will accept
	 */
	var/allowed_ammo_types = list(/obj/item/ammo_casing)

	///The targeted horizontal angle requested to this howitzer
	var/horizontal_angle = 0

	///The targeted vertical angle requested to this howitzer
	var/vertical_angle = 0

	///The deciseconds it takes for the howitzer to rotate by one degree, horizontally
	var/decisecond_per_degree_horizontal_rotation = 1

	///The deciseconds it takes for the howitzer to change the barrel elevation by one degree, vertically
	var/decisecond_per_degree_vertical_rotation = 1.5

	///The shot that is currently loaded into this howitzer
	var/obj/item/ammo_casing/howitzer/loaded_shot

	///The sound to play when the howitzer fire, a string
	var/fire_sound = 'sound/machines/howitzer/fire.ogg'

	///If the howitzer is ready to fire, handled internally
	VAR_PRIVATE/ready_to_fire = FALSE

	///A list of `/obj/item/howitzer_pellet` that are currently loaded into this howitzer
	var/list/obj/item/howitzer_pellet/loaded_howitzer_pellets = list()


	/* START ROTATION INTERNALS */

	///The sound this howitzer will emit while rotating
	var/rotation_looping_sound_type = /datum/looping_sound/clanking

	///The looping sound used during the howitzer rotation
	VAR_PRIVATE/datum/looping_sound/rotation_looping_sound

	///The timerid of the rotation
	VAR_PRIVATE/rotation_timerid

	/* END ROTATION INTERNALS */

/obj/machinery/howitzer/Initialize(mapload, d, populate_components, is_internal)
	. = ..()
	if(!anchored)
		icon_state = "howitzer"

	set_dir(NORTH)

/obj/machinery/howitzer/attack_hand(mob/user)
		ui_interact(user)

/obj/machinery/howitzer/AltClick(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/user_human = user

		if(loaded_shot)
			//Remove the pellets first, the projectile last
			if(length(loaded_howitzer_pellets))
				var/obj/item/howitzer_pellet/pellet = loaded_howitzer_pellets[length(loaded_howitzer_pellets)]
				pellet.forceMove(src)
				user_human.put_in_hands(pellet)
				loaded_howitzer_pellets -= pellet

			else
				loaded_shot.forceMove(src)
				user_human.put_in_hands(loaded_shot)
				loaded_shot = null
			return


/obj/machinery/howitzer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Howitzer", ui_x=500, ui_y=380)
		ui.open()

/obj/machinery/howitzer/ui_data(mob/user)
	var/list/data = list()
	data["loaded_shot"] = loaded_shot ? TRUE : FALSE
	data["horizontal_angle"] = horizontal_angle
	data["vertical_angle"] = vertical_angle

	return data

/obj/machinery/howitzer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_horizontal_angle")
			change_horizontal_angle(params["horizontal_angle"])
		if("set_vertical_angle")
			change_vertical_angle(params["vertical_angle"])

		if("fire")
			fire(ui.user)

/obj/machinery/howitzer/attackby(obj/item/attacking_item, mob/user)
	. = ..()

	if(istype(attacking_item, /obj/item/ammo_casing))
		//Check if the ammo is allowed
		if(!is_type_in_list(attacking_item, allowed_ammo_types))
			to_chat(user, SPAN_WARNING("This howitzer does not accept this type of ammo."))
			return

		//Only one shot at a time
		if(loaded_shot)
			to_chat(user, SPAN_WARNING("You cannot load another ammo into this howitzer while it is already loaded."))
			return

		//Take a little bit to load the ammo
		if(!do_after(user, 10 SECONDS, src))
			return

		loaded_shot = attacking_item
		user.drop_item(attacking_item)
		attacking_item.forceMove(src)

	else if(istype(attacking_item, /obj/item/howitzer_pellet))
		if(!loaded_shot)
			to_chat(user, SPAN_WARNING("You cannot load a pellet into the howitzer without the ammunition first."))
			return

		//Take a little bit to load the pellets
		if(!do_after(user, 1 SECONDS, src))
			return

		user.drop_item(attacking_item)
		attacking_item.forceMove(src)
		loaded_howitzer_pellets += attacking_item


/**
 * Takes care of changing the horizontal angle of the howitzer
 *
 * * angle - The angle to set, a number
 */
/obj/machinery/howitzer/proc/change_horizontal_angle(angle)
	if(angle > 360 || angle < 0)
		stack_trace("Invalid horizontal angle!")
		return

	if(rotation_timerid)
		balloon_alert_to_viewers("The howitzer is already doing an alignment!")
		return

	//Not the same angle we are at, we have to rotate
	if(horizontal_angle != angle)
		//Adjust the howitzer direction based on the angle
		var/wanted_dir
		if(angle > 315 || angle <= 45)
			wanted_dir = NORTH
		if(angle > 45 && angle <= 135)
			wanted_dir = EAST
		if(angle > 135 && angle <= 225)
			wanted_dir = SOUTH
		if(angle > 225 && angle <= 315)
			wanted_dir = WEST

		ready_to_fire = FALSE

		var/degrees_to_rotate = abs((horizontal_angle % 360)-(angle % 360))
		if(degrees_to_rotate > 180)
			degrees_to_rotate = 360 - degrees_to_rotate

		balloon_alert_to_viewers("The howitzer starts to rotate!")

		//Start the rotation looping sound
		rotation_looping_sound = new rotation_looping_sound_type(src)
		rotation_looping_sound.start()

		var/duration_of_rotation = (degrees_to_rotate * decisecond_per_degree_horizontal_rotation)

		rotation_timerid = addtimer(CALLBACK(src, PROC_REF(set_horizontal_angle), angle, wanted_dir), duration_of_rotation, TIMER_STOPPABLE|TIMER_UNIQUE)

///Sets the horizontal angle and dir, internal use only, do not call this directly
/obj/machinery/howitzer/proc/set_horizontal_angle(angle, wanted_dir)
	PROTECTED_PROC(TRUE)

	rotation_timerid = null

	horizontal_angle = angle
	set_dir(wanted_dir)

	balloon_alert_to_viewers("The howitzer stops rotating!")
	rotation_looping_sound.stop()
	QDEL_NULL(rotation_looping_sound)

	ready_to_fire = TRUE

/**
 * Takes care of changing the vertical angle of the howitzer
 *
 * * angle - The angle to set, a number
 */
/obj/machinery/howitzer/proc/change_vertical_angle(angle)
	if(angle > 90 || angle < 0)
		stack_trace("Invalid vertical angle!")
		return

	if(rotation_timerid)
		balloon_alert_to_viewers("The howitzer is already doing an alignment!")
		return

	if(vertical_angle != angle)

		ready_to_fire = FALSE

		var/degrees_to_change = abs((vertical_angle % 360)-(angle % 360))
		if(degrees_to_change > 180) //Yes this shouldn't happen, copy paste anyways
			degrees_to_change = 360 - degrees_to_change

		balloon_alert_to_viewers("The howitzer starts to change the elevation!")

		rotation_looping_sound = new rotation_looping_sound_type(src)
		rotation_looping_sound.start()

		rotation_timerid = addtimer(CALLBACK(src, PROC_REF(set_vertical_angle), angle), (degrees_to_change * decisecond_per_degree_vertical_rotation), TIMER_STOPPABLE|TIMER_UNIQUE)

///Sets the vertical angle and dir, internal use only, do not call this directly
/obj/machinery/howitzer/proc/set_vertical_angle(angle)
	PROTECTED_PROC(TRUE)

	rotation_timerid = null

	vertical_angle = angle

	balloon_alert_to_viewers("The howitzer steadies the barrel at the requested elevation!")
	rotation_looping_sound.stop()
	QDEL_NULL(rotation_looping_sound)

	ready_to_fire = TRUE

/**
 * Fires the projectile to the target
 *
 * * user - The `/mob` that requested to fire the projectile
 */
/obj/machinery/howitzer/proc/fire(mob/user)
	if(!anchored)
		balloon_alert_to_viewers("The howitzer is not anchored down!")
		to_chat(user, SPAN_WARNING("The howitzer is not anchored down!"))
		return

	if(horizontal_angle > 360 || vertical_angle > 90)
		return

	if(!ready_to_fire)
		balloon_alert_to_viewers("The howitzer is not ready to fire, it's adjusting the aim!")
		to_chat(user, SPAN_WARNING("The howitzer is not ready to fire, it's adjusting the aim!"))
		return

	if(!loaded_shot)
		balloon_alert_to_viewers("The barrel is empty!")
		to_chat(user, SPAN_WARNING("The barrel is empty!"))
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	//Calculate how much power the pellets add to the shot
	var/fire_power = 10
	for(var/obj/item/howitzer_pellet/pellet in loaded_howitzer_pellets)
		fire_power += pellet.power

	var/datum/projectile_data/shot_data = projectile_trajectory(T.x, T.y, horizontal_angle, vertical_angle, fire_power)

	//Use the projectile and the pellets
	var/obj/projectile/shot_projectile = loaded_shot.expend()
	QDEL_LIST(loaded_howitzer_pellets)

	//Casing already expended, nothing to shoot
	if(!shot_projectile)
		to_chat(user, SPAN_WARNING("The ammunition is already expended."))
		return

	//Clamp the target so we don't aim to invalid locations
	if(shot_data.dest_x < 1)
		shot_data.dest_x = 1
	if(shot_data.dest_x > world.maxx)
		shot_data.dest_x = world.maxx

	if(shot_data.dest_y < 1)
		shot_data.dest_y = 1
	if(shot_data.dest_y > world.maxy)
		shot_data.dest_y = world.maxy

	var/turf/target = locate(shot_data.dest_x, shot_data.dest_y, src.z)

	//If somehow the target does not exist, stop here
	if(!target)
		stack_trace("Unable to locate the target, somehow.")
		return

	shot_projectile.preparePixelProjectile(target, get_turf(src))
	shot_projectile.firer = src
	shot_projectile.fired_from = src
	shot_projectile.fire()

	flick((icon_state + "_fire"), src)

	//Play fire sound, smoke effect
	playsound(src, fire_sound, 100, TRUE)

	//Move the smoke forward a little
	var/turf/smoke_position = get_turf(src)
	for(var/_ in 1 to 2)
		var/turf/tmp_smoke_position = get_step(smoke_position, dir)
		if(istype(tmp_smoke_position))
			smoke_position = tmp_smoke_position
		else
			break

	new /obj/effect/smoke(smoke_position, 2 SECONDS)

	for(var/mob/living/carbon/human/H in range(3, src))
		if(H.client)
			shake_camera(H, 0.5 SECONDS, 2)


/*####################################
	AMMUNITIONS ABSTRACT TYPES
####################################*/

/**
 * # Howitzer Ammo Casing
 *
 * Howitzer ammo casing is a type of ammo casing that can be loaded into howitzers.
 */
ABSTRACT_TYPE(/obj/item/ammo_casing/howitzer)
	name = "howitzer ammo casing"
	icon = 'icons/obj/machinery/howitzer/howitzer_ammo.dmi'
	icon_state = "howitzer_ammo"
	spent_icon = "howitzer_ammo" //We don't have the sprite, just keep the default one

	//We're reusing the PEAC sounds because I can't seem to find a better one
	drop_sound = 'sound/items/drop/shell_drop.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'

	projectile_type = /obj/projectile/howitzer

/obj/item/ammo_casing/howitzer/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "\A [name], to be used in a howitzer."
	if(!BB && distance < 4)
		. += "This one is spent."


/**
 * # Howitzer Ammo
 *
 * Howitzer ammo is a type of ammo that can be used in howitzers.
 */
ABSTRACT_TYPE(/obj/projectile/howitzer)
	name = "howitzer ammo"
	icon = 'icons/obj/machinery/howitzer/howitzer_ammo.dmi'
	icon_state = "howitzer_ammo"
	damage = 0
	range = 999 //Follow what the path says, not range

/obj/projectile/howitzer/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE, cross_failed = FALSE)
	if(target == original)
		return TRUE
	else
		return FALSE

//We have to handle collisions like the snowflake projectile we are. Or rewrite the projectile logic, you can do that if you want, I do not
/obj/projectile/howitzer/Collide(atom/A)
	if(A == original)
		on_hit(A)
		qdel(src)

/obj/projectile/howitzer/on_hit(atom/target, blocked, def_zone)
	. = ..()

	if(target == original)
		terminal_effect(get_turf(target))

/**
 * Takes care of performing the terminal effect of the projectile
 *
 * * impacted_turf - The `/turf` that the projectile landed on
 */
/obj/projectile/howitzer/proc/terminal_effect(turf/impacted_turf)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(QDELETED(impacted_turf))
		return FALSE

	return TRUE

/*
	High Explosive
*/
ABSTRACT_TYPE(/obj/item/ammo_casing/howitzer/high_explosive)
	name = "high explosive howitzer ammo"
	projectile_type = /obj/projectile/howitzer/high_explosive

/**
 * # High Explosive howitzer ammo
 *
 * Big boom, many fragments
 */
ABSTRACT_TYPE(/obj/projectile/howitzer/high_explosive)
	name = "high explosive howitzer ammo"

	///The minimum number of fragments this HE shell will create
	var/fragment_minimum = 80
	///The maximum number of fragments this HE shell will create
	var/fragment_maximum = 100
	///The range in which the explosion will do light impact damage
	var/light_impact_damage_range = 7
	///The range in which the explosion will do flash damage
	var/flash_damage_range = 7
	///The damage the fragments will do, each
	var/fragment_damage = 10
	///The range in which the fragments will travel, the projectile will lose a pellet each time it travels this distance. Can be a non-integer.
	var/fragment_lost_per_step = 7
	///The range in which the fragments will travel
	var/fragment_range = 7
	///Boolean, if people can cover from the explosion
	var/can_cover = TRUE

/obj/projectile/howitzer/high_explosive/terminal_effect(turf/impacted_turf)
	. = ..()
	if(!.)
		return

	impacted_turf.hotspot_expose(1 KILO, 100)

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(fragem), impacted_turf, fragment_minimum, fragment_maximum, \
														light_impact_damage_range, flash_damage_range, fragment_damage, \
														fragment_lost_per_step, can_cover, fragment_range)


/*####################################
		GUNPOWDER PELLETS
####################################*/
ABSTRACT_TYPE(/obj/item/howitzer_pellet)
	name = "howitzer pellet"
	desc = "A pellet that can be used in a howitzer to propel the projectile."

	icon = 'icons/obj/machinery/howitzer/powder_pellets.dmi'
	icon_state = "powder"

	///How much power this pellet adds to the howitzer
	var/power = 0

	///How much precise is the value, in percentage, supposed to represent the powder quality
	var/precision = 80

/obj/item/howitzer_pellet/Initialize(mapload, ...)
	. = ..()

	//Calculate the purity of the powder at initialization
	var/lower_bound = power - (power * (100-precision) / 100)
	var/upper_bound = power + (power * (100-precision) / 100)
	power = rand(lower_bound, upper_bound)

/obj/item/howitzer_pellet/small
	name = "small howitzer pellet"

	power = 5

/obj/item/howitzer_pellet/medium
	name = "medium howitzer pellet"

	power = 15

/obj/item/howitzer_pellet/large
	name = "large howitzer pellet"
	icon_state = "hungrypowder"

	power = 20

/*#####################################
		ACTUAL HOWITZERS TO USE
#####################################*/

/obj/machinery/howitzer/gadpathur_105mm
	name = "gadpathur 105mm light field howitzer"
	desc = "A 105mm light field howitzer, in service with the Gadpathur Planetary Defense Council."

/obj/item/ammo_casing/howitzer/high_explosive/gadpathur_105mm
	name = "gadpathur 105mm light field howitzer HE ammo"
	desc = "A 105mm light field howitzer ammo, designed with the idea of obliterating any Solarian that might put foot on the surface of the planet."
	projectile_type = /obj/projectile/howitzer/high_explosive/gadpathur_105mm

/obj/projectile/howitzer/high_explosive/gadpathur_105mm
	name = "gadpathur 105mm light field howitzer HE projectile"
	fragment_minimum = 30
	fragment_maximum = 50
	light_impact_damage_range = 3
	flash_damage_range = 5
