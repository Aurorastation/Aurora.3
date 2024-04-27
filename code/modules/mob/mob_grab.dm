//This is called from human_attackhand.dm before grabbing happens.
//IT is called when grabber tries to grab this mob
//Override this for special grab behaviour.
//Returning 0 will make grab fail, returning 1 will suceed
/mob/living/proc/attempt_grab(var/mob/living/grabber)
	return 1

//As above, but called when someone tries to pull this mob
/mob/living/proc/attempt_pull(var/mob/living/grabber)
	return 1


/obj/item/grab
	name = "grab"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "reinforce"
	atom_flags = 0
	var/obj/screen/grab/hud = null
	var/mob/living/affecting = null
	var/mob/living/carbon/human/assailant = null
	var/state = GRAB_PASSIVE

	var/allow_upgrade = 1
	var/last_action = 0
	var/last_hit_zone = 0
	var/force_down //determines if the affecting mob will be pinned to the ground
	var/dancing //determines if assailant and affecting keep looking at each other. Basically a wrestling position
	var/has_choked = FALSE //Used as a counter for choking people.

	var/obj/item/grab/linked_grab
	var/wielded = FALSE

	layer = HUD_ABOVE_ITEM_LAYER
	abstract = 1
	item_state = "nothing"
	w_class = ITEMSIZE_HUGE
	throw_range = 5

	drop_sound = null
	pickup_sound = null
	equip_sound = null

/obj/item/grab/Initialize(mapload, mob/user, mob/victim)
	. = ..()
	assailant = user
	affecting = victim

	if(affecting.anchored || !assailant.Adjacent(victim))
		return INITIALIZE_HINT_QDEL

	affecting.grabbed_by += src

	hud = new /obj/screen/grab(src)
	hud.icon_state = "reinforce"
	icon_state = "grabbed"
	hud.name = "reinforce grab"
	hud.master = src

	//check if assailant is grabbed by victim as well
	if(assailant.grabbed_by)
		for (var/obj/item/grab/G in assailant.grabbed_by)
			if(G.assailant == affecting && G.affecting == assailant)
				G.dancing = 1
				G.adjust_position()
				dancing = 1
	adjust_position()

//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/grab/proc/throw_held()
	if(affecting)
		if(affecting.buckled_to && affecting.buckled_to != assailant) // can't throw in fireman carries atm, but future proofing
			return null
		if(state >= GRAB_AGGRESSIVE)
			animate(affecting, pixel_x = affecting.get_standard_pixel_x(), pixel_y = affecting.get_standard_pixel_y(), 4, 1)
			return affecting
	return null


//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/grab/proc/synch()
	if(affecting)
		if(assailant.r_hand == src)
			hud.screen_loc = ui_rhand
		else
			hud.screen_loc = ui_lhand

/obj/item/grab/process()
	if(QDELING(src)) // GC is trying to delete us, we'll kill our processing so we can cleanly GC
		return PROCESS_KILL

	confirm()
	if(!assailant)
		qdel(src) // Same here, except we're trying to delete ourselves.
		return PROCESS_KILL

	if(assailant.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		if(!assailant.species.can_double_fireman_carry())
			//disallow upgrading if we're grabbing more than one person
			if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/grab)))
				var/obj/item/grab/G = assailant.l_hand
				if(G.affecting != affecting)
					allow_upgrade = 0
			if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/grab)))
				var/obj/item/grab/G = assailant.r_hand
				if(G.affecting != affecting)
					allow_upgrade = 0

		//disallow upgrading past aggressive if we're being grabbed aggressively
		for(var/obj/item/grab/G in affecting.grabbed_by)
			if(G == src) continue
			if(G.state >= GRAB_AGGRESSIVE)
				allow_upgrade = 0

		if(allow_upgrade)
			if(state < GRAB_AGGRESSIVE)
				hud.icon_state = "reinforce"
			else
				hud.icon_state = "reinforce1"
		else
			hud.icon_state = "!reinforce"

	if(state >= GRAB_AGGRESSIVE)
		if(iscarbon(affecting))
			handle_eye_mouth_covering(affecting, assailant, assailant.zone_sel.selecting)

		if(force_down)
			if(affecting.loc != assailant.loc)
				force_down = 0
			else
				affecting.Weaken(4)

	if(state >= GRAB_NECK)
		affecting.drop_l_hand()
		affecting.drop_r_hand()
		affecting.Stun(3)
		if(isliving(affecting))
			var/mob/living/L = affecting
			L.adjustOxyLoss(1)

	if(state >= GRAB_KILL)
		affecting.stuttering = max(affecting.stuttering, 5) //It will hamper your voice, being choked and all.
		affecting.Weaken(7)	//Should keep you down unless you get help.
		if(ishuman(affecting))
			var/mob/living/carbon/human/A = affecting
			var/obj/item/clothing/C = A.head
			if(C && (C.item_flags & ITEM_FLAG_THICK_MATERIAL))
				return
			if(!(A.species.flags & NO_BREATHE))
				A.losebreath = max(A.losebreath + 3, 5)
				A.adjustOxyLoss(3)
				if(affecting.stat == CONSCIOUS)
					if(do_mob(assailant, affecting, 150))
						A.visible_message(SPAN_WARNING("[A] falls unconscious..."), FONT_LARGE(SPAN_DANGER("The world goes dark as you fall unconscious...")))
						A.Paralyse(20)
		else if(istype(affecting, /mob/living/simple_animal))
			if(affecting.stat != DEAD)
				affecting.health -= 1

	adjust_position()

/obj/item/grab/proc/handle_eye_mouth_covering_wrapper()
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(handle_eye_mouth_covering), affecting, assailant, assailant.zone_sel.selecting)

/obj/item/grab/proc/handle_eye_mouth_covering(mob/living/carbon/target, mob/user, var/target_zone)
	var/announce = (target_zone != last_hit_zone) //only display messages when switching between different target zones
	last_hit_zone = target_zone

	switch(target_zone)
		if(BP_MOUTH)
			if(announce)
				user.visible_message(SPAN_WARNING("\The [user] covers [target]'s face!"), SPAN_WARNING("You cover [target]'s face!"))
			if(target.silent < 3)
				target.silent = 3
		if(BP_EYES)
			if(announce)
				assailant.visible_message(SPAN_WARNING("[assailant] covers [affecting]'s eyes!"), SPAN_WARNING("You cover [target]'s eyes!"))
			if(affecting.eye_blind < 3)
				affecting.eye_blind = 3

/obj/item/grab/attack_self()
	return s_click(hud)


//Updating pixelshift, position and direction
//Gets called on process, when the grab gets upgraded or the assailant moves
/obj/item/grab/proc/adjust_position()
	if(!affecting)
		return
	if(affecting.buckled_to && affecting.buckled_to != assailant)
		animate(affecting, pixel_x = affecting.get_standard_pixel_x(), pixel_y = affecting.get_standard_pixel_y(), 4, 1, LINEAR_EASING)
		return
	if(affecting.lying || force_down || wielded)
		affecting.update_canmove()
		var/shift_amount = wielded ? 6 : 0
		animate(affecting, pixel_x = affecting.get_standard_pixel_x(), pixel_y = affecting.get_standard_pixel_y() + shift_amount, 5, 1, LINEAR_EASING)
		var/set_dir = wielded ? assailant.dir : SOUTH
		affecting.set_dir(set_dir)
		if(wielded)
			if(assailant.dir != NORTH)
				affecting.layer = assailant.layer - 0.1
			else
				affecting.layer = assailant.layer + 0.1
		return
	var/shift = 0
	var/adir = get_dir(assailant, affecting)
	affecting.layer = 4
	switch(state)
		if(GRAB_PASSIVE)
			shift = 8
			if(dancing) //look at partner
				shift = 10
				assailant.set_dir(get_dir(assailant, affecting))
		if(GRAB_AGGRESSIVE)
			shift = 12
		if(GRAB_NECK, GRAB_UPGRADING)
			shift = -10
			adir = assailant.dir
			affecting.update_canmove()
			affecting.set_dir(assailant.dir)
			affecting.forceMove(assailant.loc)
		if(GRAB_KILL)
			shift = 0
			adir = 1
			affecting.update_canmove()
			affecting.set_dir(SOUTH) //face up
			affecting.forceMove(assailant.loc)

	switch(adir)
		if(NORTH)
			animate(affecting, pixel_x = affecting.get_standard_pixel_x(), pixel_y =-shift, 5, 1, LINEAR_EASING)
			affecting.layer = 3.9
		if(SOUTH)
			animate(affecting, pixel_x = affecting.get_standard_pixel_x(), pixel_y = shift, 5, 1, LINEAR_EASING)
		if(WEST)
			animate(affecting, pixel_x = shift, pixel_y = affecting.get_standard_pixel_y(), 5, 1, LINEAR_EASING)
		if(EAST)
			animate(affecting, pixel_x =-shift, pixel_y = affecting.get_standard_pixel_y(), 5, 1, LINEAR_EASING)

/obj/item/grab/proc/s_click(obj/screen/S)
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(wielded)
		return
	if(!assailant.canClick())
		return
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return

	var/grab_coeff = 1
	if(ishuman(affecting))
		var/mob/living/carbon/human/H = affecting
		if(H.species)
			grab_coeff = H.species.grab_mod

	if(world.time < (last_action + (UPGRADE_COOLDOWN * grab_coeff)))
		return

	last_action = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		if(!affecting.lying)
			assailant.visible_message(SPAN_DANGER("[assailant] grabs [affecting] aggressively by the hands!"), SPAN_DANGER("You grab [affecting] aggressively by the hands!"))
		else
			assailant.visible_message(SPAN_DANGER("[assailant] pins [affecting] down to the ground by the hands!"), SPAN_DANGER("You pin [affecting] down to the ground by the hands!"))
			apply_pinning(affecting, assailant)

		state = GRAB_AGGRESSIVE
		icon_state = "grabbed1"
		hud.icon_state = "reinforce1"
		RegisterSignal(assailant, COMSIG_MOB_ZONE_SEL_CHANGE, PROC_REF(handle_eye_mouth_covering_wrapper))
		handle_eye_mouth_covering(affecting, assailant, assailant.zone_sel.selecting)
	else if(state < GRAB_NECK)
		if(isslime(affecting))
			assailant.visible_message(SPAN_WARNING("[assailant] tries to squeeze [affecting], but [assailant.get_pronoun("his")] hands sink right through!"), SPAN_WARNING("You try to squeeze [affecting], but your hands sink right through!"))
			return
		playsound(loc, /singleton/sound_category/grab_sound, 50, FALSE, -1)
		assailant.visible_message(SPAN_DANGER("[assailant] reinforces [assailant.get_pronoun("his")] grip on [affecting]'s neck!"), SPAN_DANGER("You reinforce your grip on [affecting]'s neck!"))
		state = GRAB_NECK
		icon_state = "grabbed+1"
		affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [assailant.name] ([assailant.ckey])</font>"
		assailant.attack_log += "\[[time_stamp()]\] <span class='warning'>Grabbed the neck of [affecting.name] ([affecting.ckey])</span>"
		msg_admin_attack("[key_name_admin(assailant)] grabbed the neck of [key_name_admin(affecting)]",ckey=key_name(assailant),ckey_target=key_name(affecting))
		hud.icon_state = "kill"
		hud.name = "kill"
		affecting.Stun(10) //10 ticks of ensured grab
	else if(state < GRAB_UPGRADING)
		if(ishuman(affecting))
			var/mob/living/carbon/human/H = affecting
			if(H.head && (H.head.item_flags & ITEM_FLAG_AIRTIGHT))
				assailant.visible_message(SPAN_WARNING("[affecting]'s headgear prevents [assailant] from choking them out!"), SPAN_WARNING("[affecting]'s headgear prevents you from choking them out!"))
				return
		hud.icon_state = "kill1"
		hud.name = "loosen"
		state = GRAB_KILL
		playsound(loc, /singleton/sound_category/grab_sound, 50, FALSE, -1)
		assailant.visible_message(SPAN_DANGER("[assailant] starts strangling [affecting]!"), SPAN_DANGER("You start strangling [affecting]!"))

		affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>is being strangled by [assailant.name] ([assailant.ckey])</font>"
		assailant.attack_log += "\[[time_stamp()]\] <span class='warning'>is strangling [affecting.name] ([affecting.ckey])</span>"
		msg_admin_attack("[key_name_admin(assailant)] is strangling [key_name_admin(affecting)]",ckey=key_name(assailant),ckey_target=key_name(affecting))

		affecting.setClickCooldown(10)
		if(ishuman(affecting))
			var/mob/living/carbon/human/A = affecting
			if (!(A.species.flags & NO_BREATHE))
				A.losebreath += 4
				var/obj/item/organ/external/O = A.get_organ(BP_HEAD)
				O.add_autopsy_data("Strangling")
		affecting.set_dir(WEST)
	else if(state == GRAB_KILL)
		hud.icon_state = "kill"
		hud.name = "kill"
		state = GRAB_NECK
		assailant.visible_message(SPAN_WARNING("[assailant] stops strangling [affecting]!"), SPAN_WARNING("You stop strangling [affecting]!"))
	adjust_position()

//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/grab/proc/confirm()
	if(!assailant || !affecting || QDELETED(affecting))
		qdel(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) || assailant.z != affecting.z )
			qdel(src)
			return 0

	return 1

/obj/item/grab/attack(mob/M, mob/living/user, var/target_zone)
	if(!affecting)
		return

	if(world.time < (last_action + 20))
		return

	last_action = world.time
	reset_kill_state() //using special grab moves will interrupt choking them

	if(M == affecting) //clicking on the victim while grabbing them
		if(ishuman(affecting))
			var/hit_zone = target_zone
			flick(hud.icon_state, hud)
			switch(assailant.a_intent)
				if(I_HELP)
					if(force_down)
						assailant.visible_message(SPAN_WARNING("[assailant] is no longer pinning [affecting] to the ground."), SPAN_WARNING("You are no longer pinning [affecting] to the ground."))
						force_down = 0
						return
					inspect_organ(affecting, assailant, hit_zone)

				if(I_GRAB)
					jointlock(affecting, assailant, hit_zone)

				if(I_HURT)
					if(hit_zone == BP_EYES)
						attack_eye(affecting, assailant)
					else if(hit_zone == BP_HEAD)
						headbutt(affecting, assailant)
					else
						dislocate(affecting, assailant, hit_zone)

				if(I_DISARM)
					if(hit_zone != BP_HEAD)
						pin_down(affecting, assailant)
					if(hit_zone == BP_HEAD)
						hair_pull(affecting, assailant)

	//clicking on yourself while grabbing them
	else if(M == assailant && assailant.a_intent == I_GRAB && state >= GRAB_AGGRESSIVE)
		devour(affecting, assailant)

/obj/item/grab/dropped()
	. = ..()
	loc = null
	if(!destroying)
		qdel(src)

/obj/item/grab/proc/reset_kill_state()
	if(state == GRAB_KILL)
		assailant.visible_message(SPAN_DANGER("[assailant] stops strangling [affecting] to move."), SPAN_DANGER("You stop strangling [affecting] to move."))
		hud.icon_state = "kill"
		state = GRAB_NECK

/obj/item/grab
	var/destroying = 0

/obj/item/grab/Destroy()
	if(!QDELETED(linked_grab))
		qdel(linked_grab)

	UnregisterSignal(assailant, COMSIG_MOB_ZONE_SEL_CHANGE)

	if(wielded)
		if(affecting.buckled_to == assailant)
			affecting.buckled_to = null
			affecting.update_canmove()
			affecting.anchored = FALSE
		GLOB.moved_event.unregister(assailant, src, PROC_REF(move_affecting))

	animate(affecting, pixel_x = affecting.get_standard_pixel_x(), pixel_y = affecting.get_standard_pixel_y(), 4, 1, LINEAR_EASING)
	affecting.layer = initial(affecting.layer)
	if(affecting)
		ADD_FALLING_ATOM(affecting) // Makes the grabbee check if they can fall.
		affecting.grabbed_by -= src
		affecting = null
	if(assailant)
		if(assailant.client)
			assailant.client.screen -= hud
		assailant = null
	qdel(hud)
	hud = null
	destroying = 1 // stops us calling qdel(src) on dropped()
	return ..()

/obj/item/grab/MouseDrop(mob/living/carbon/human/H)
	if(wielded || affecting.buckled_to || !istype(H) || assailant != H || H.get_active_hand() != src)
		return
	if(!ishuman(affecting))
		to_chat(H, SPAN_WARNING("You can only fireman carry humanoids!"))
		return
	var/mob/living/carbon/human/affected_human = affecting
	if(affected_human.species.mob_size > 25)
		to_chat(H, SPAN_WARNING("\The [affected_human] is way too big to fireman carry!"))
		return
	if(state < GRAB_AGGRESSIVE)
		to_chat(H, SPAN_WARNING("You need an aggressive grab before you can fireman carry someone!"))
		return
	if(H.get_inactive_hand() && !H.species.can_double_fireman_carry())
		to_chat(H, SPAN_WARNING("Your other hand must be empty to fireman carry someone!"))
		return

	H.visible_message("<b>[H]</b> starts lifting \the [affecting] onto their shoulders...", SPAN_NOTICE("You start lifting \the [affecting] onto your shoulders..."))

	if(!do_after(H, 1 SECONDS, affecting))
		return

	if(affecting.buckled_to)
		return

	if(H.get_inactive_hand() && !H.species.can_double_fireman_carry())
		to_chat(H, SPAN_WARNING("Your other hand must be empty to fireman carry someone!"))
		return

	if(H.species.can_double_fireman_carry())
		set_wielding()
	else
		var/obj/item/grab/offhand/OH = new /obj/item/grab/offhand(H, H, affecting, src)
		H.put_in_hands(OH)

	H.visible_message("<b>[H]</b> lifts \the [affecting] onto their shoulders!", SPAN_NOTICE("You lift \the [affecting] onto your shoulders!"))

	affecting.buckled_to = assailant
	affecting.forceMove(H.loc)
	adjust_position()
	GLOB.moved_event.register(assailant, src, PROC_REF(move_affecting))

/obj/item/grab/proc/set_wielding()
	wielded = TRUE
	state = GRAB_AGGRESSIVE
	icon_state = "!reinforce"
	hud.icon_state = "!reinforce"

/obj/item/grab/proc/move_affecting()
	if(affecting && assailant.Adjacent(affecting)) // Only move if it's near us.
		affecting.forceMove(assailant.loc)

/obj/item/grab/can_swap_hands(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_double_fireman_carry())
			return TRUE
	if(wielded)
		return FALSE
	return ..()

/obj/item/grab/proc/get_grab_type()
	if(wielded)
		return MOB_GRAB_FIREMAN
	return MOB_GRAB_NORMAL

/obj/item/grab/offhand
	icon_state = "!reinforce"

/obj/item/grab/offhand/Initialize(mapload, mob/user, mob/victim, var/obj/item/grab/linked)
	. = ..()

	set_wielding()
	linked_grab = linked
	linked.linked_grab = src
	linked_grab.set_wielding()

/obj/item/grab/offhand/process()
	return

/obj/item/grab/offhand/adjust_position()
	return
