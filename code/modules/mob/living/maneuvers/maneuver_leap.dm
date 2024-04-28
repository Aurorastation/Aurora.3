/singleton/maneuver/leap
	name = "leap"
	stamina_cost = 10
	charge_cost = 500
	reflexive_modifier = 1.5

/singleton/maneuver/leap/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	. = ..()
	if(.)
		var/old_pass_flags = user.pass_flags
		user.pass_flags |= PASSTABLE
		user.visible_message(SPAN_DANGER("\The [user] takes a flying leap!"))
		strength = max(2, strength * user.get_jump_distance())
		if(reflexively)
			strength *= reflexive_modifier
		animate(user, pixel_z = 16, time = 3, easing = SINE_EASING | EASE_IN)
		animate(pixel_z = 0, time = 3, easing = SINE_EASING | EASE_OUT)
		user.throw_at(get_turf(target), strength, 1, user, FALSE)
		end_leap(user, target, old_pass_flags)

/singleton/maneuver/leap/proc/end_leap(var/mob/living/user, var/atom/target, var/pass_flag)
	SHOULD_NOT_SLEEP(TRUE)
	user.pass_flags = pass_flag
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.mob_size > 10)
			var/turf/T = get_turf(target)
			var/damage_mod = 1
			var/from_above = FALSE
			if(H.can_fall(GET_BELOW(T)))
				from_above = TRUE
				if(isopenspace(T))
					while(isopenspace(T))
						T = GET_BELOW(T)
						damage_mod += 1
			if(isturf(T))
				T.visible_message(SPAN_DANGER("[H] lands on \the [T] with a quake!"))
				playsound(get_turf(T), 'sound/effects/bangtaper.ogg', 80)
				for(var/mob/living/L in range(2, T))
					shake_camera(L, 2, 4)
				for(var/mob/living/rebecca in T)
					if(rebecca.lying || from_above)
						rebecca.apply_damage(40 * damage_mod, DAMAGE_BRUTE, pick(BP_ALL_LIMBS), used_weapon = "landing", armor_pen = 30) //so true choomfie
						T.visible_message(SPAN_DANGER("<font size=4>[H] lands on [rebecca]!</font>"))
						to_chat(H, SPAN_DANGER("<font size=4>You land on [rebecca]!</font>")) //since the mob won't be on the turf yet
	user.post_maneuver()

/singleton/maneuver/leap/show_initial_message(var/mob/living/user, var/atom/target)
	user.visible_message(SPAN_WARNING("\The [user] crouches, preparing for a leap!"))

/singleton/maneuver/leap/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	. = ..()
	if(.)
		var/can_leap_distance = user.get_jump_distance() * user.get_acrobatics_multiplier()
		if (can_leap_distance <= 0)
			if (!silent)
				to_chat(user, SPAN_WARNING("You can't leap in your current state."))
			return FALSE
		if (!istype(target))
			if (!silent)
				to_chat(user, SPAN_WARNING("That is not a valid leap target."))
			return FALSE
		if (get_dist(user, target) > can_leap_distance)
			if (!silent)
				to_chat(user, SPAN_WARNING("You can't leap that far."))
			return FALSE
		return TRUE

/singleton/maneuver/leap/spider
	stamina_cost = 0

/singleton/maneuver/leap/spider/show_initial_message(var/mob/living/user, var/atom/target)
	user.visible_message(SPAN_WARNING("\The [user] reels back and prepares to launch itself at \the [target]!"))

/singleton/maneuver/leap/grab/end_leap(mob/living/user, atom/target, pass_flag)
	. = ..()
	if(ishuman(user) && !user.lying && ismob(target) && user.Adjacent(target))
		var/mob/living/carbon/human/H = user
		var/use_hand = "left"
		if(H.l_hand)
			if(H.r_hand)
				to_chat(H, SPAN_DANGER("You need to have one hand free to grab someone."))
				return
			else
				use_hand = "right"
		var/obj/item/grab/G = new(H, target)
		if(use_hand == "left")
			H.l_hand = G
		else
			H.r_hand = G

		G.state = GRAB_PASSIVE
		G.icon_state = "grabbed1"
		G.synch()

/singleton/maneuver/leap/industrial
	cooldown = 8 SECONDS

/singleton/maneuver/leap/zenghu
	cooldown = 4 SECONDS
	charge_cost = 1500

/singleton/maneuver/leap/bulwark
	cooldown = 10 SECONDS //bigger than industrials = more cooldown

/singleton/maneuver/leap/tajara
	cooldown = 4 SECONDS
	delay = 2 SECONDS
	stamina_cost = 25

/singleton/maneuver/leap/tajara/msai
	delay = 1 SECOND
	cooldown = 4 SECONDS

/singleton/maneuver/leap/tesla_body
	cooldown = 20 SECONDS
	delay = 4 SECONDS
	stamina_cost = 30

/singleton/maneuver/leap/areagrab
	cooldown = 5 MINUTES
	delay = 3 SECONDS
	stamina_cost = 50

/singleton/maneuver/leap/areagrab/show_initial_message(mob/living/user, atom/target)
	. = ..()
	user.balloon_alert_to_viewers("OUUGUGUUUUUUUUUUUGBHGH", "OUUGUGUUUUUUUUUUUGBHGH")

	//Let them hear, let them fear
	for(var/mob/living/carbon/human/person_in_range in get_hearers_in_LOS(world.view+5))
		to_chat(person_in_range,
			SPAN_HIGHDANGER("OUUGUGUUUUUUUUUUUGBHGH!!!")
			)

/singleton/maneuver/leap/areagrab/end_leap(var/mob/living/user, var/atom/target, pass_flag)
	. = ..()

	var/list/mob/living/affected_mobs = list()

	for(var/mob/living/subject in range(1))
		affected_mobs += subject

	affected_mobs -= user //Exclude ourself from it

	if(length(affected_mobs))
		var/mob/living/very_unlucky_guy = pick(affected_mobs)

		for(var/mob/living/subject as anything in (affected_mobs - very_unlucky_guy))
			INVOKE_ASYNC(subject, TYPE_PROC_REF(/atom/movable, throw_at_random), FALSE, 3, THROWNOBJ_KNOCKBACK_SPEED)
			INVOKE_ASYNC(subject, TYPE_PROC_REF(/mob/living, Weaken), 5)

		if(ismob(very_unlucky_guy) && user.Adjacent(very_unlucky_guy))

			var/obj/item/grab/G = new(user, user, very_unlucky_guy)

			user.put_in_active_hand(G)

			G.state = GRAB_NECK
			G.icon_state = "grabbed+1"
			G.synch()
			G.update_icon()
			G.hud.icon_state = "kill"
			G.hud.name = "kill"

