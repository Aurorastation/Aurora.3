/mob/abstract/ghost/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	density = 0
	canmove = 0
	blinded = 0
	anchored = 1	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	simulated = FALSE
	universal_speak = 1
	incorporeal_move = INCORPOREAL_GHOST
	mob_thinks = FALSE
	interaction_flags_atom = INTERACT_ATOM_MOUSEDROP_IGNORE_CHECKS

	/// If the ghost can re-enter their corpse.
	var/can_reenter_corpse
	/// The ghost's HUD datum.
	var/datum/hud/hud = null
	/// This variable is set to 1 when you enter the game as an observer. Remains null if you died in the game and are a ghost. Not reliable for admins; they change mobs a lot.
	var/started_as_observer
	/// If the ghost has enabled antagHUD.
	var/has_enabled_antagHUD = 0
	/// If the ghost has enabled medHUD.
	var/medHUD = 0
	/// If this is an adminghost.
	var/admin_ghosted = 0
	/// If this ghost has enabled chat anonymization.
	var/anonsay = 0
	/// This mob's ghost image, for deleting and stuff.
	var/image/ghostimage
	/// If the ghost can be seen through cult shenanigans.
	var/is_manifest = 0
	/// Cooldown for ghost abilities, such as move_item().
	var/ghost_cooldown = 0

/mob/abstract/ghost/observer/Initialize(mapload, mob/body)
	. = ..()
	if (istype(body, /mob/abstract/ghost/observer))
		return//A ghost can't become a ghost.

	set_stat(DEAD)

	ghostimage = image(src.icon,src,src.icon_state)
	SSmobs.ghost_darkness_images |= ghostimage
	updateallghostimages()

	var/turf/T
	if (ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost

		var/originaldesc = desc
		var/o_transform = transform
		appearance = body
		appearance_flags = KEEP_TOGETHER
		desc = originaldesc
		transform = o_transform

		alpha = 127
		set_invisibility(initial(invisibility))

		gender = body.gender
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
				else
					name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	if(!T)
		if(length(GLOB.latejoin))
			T = pick(GLOB.latejoin)			//Safety in case we cannot find the body's position
		else if(SSatlas.current_map.force_spawnpoint && length(GLOB.force_spawnpoints["Anyone"]))
			T = pick(GLOB.force_spawnpoints["Anyone"])
		else
			T = locate(1, 1, 1)
	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	real_name = name

/mob/abstract/ghost/observer/Destroy()
	if (ghostimage)
		SSmobs.ghost_darkness_images -= ghostimage
		qdel(ghostimage)
		ghostimage = null
		updateallghostimages()

	return ..()

/mob/abstract/ghost/observer/proc/initialise_postkey(set_timers = TRUE)
	//This function should be run after a ghost has been created and had a ckey assigned
	if (!set_timers)
		return

	//Death times are initialised if they were unset
	//get/set death_time functions are in mob_helpers.dm
	if (!get_death_time(ANIMAL))
		set_death_time(ANIMAL, world.time - RESPAWN_ANIMAL) //allow instant mouse spawning
	if (!get_death_time(MINISYNTH))
		set_death_time(MINISYNTH, world.time - RESPAWN_MINISYNTH) //allow instant drone spawning
	if (!get_death_time(CREW))
		set_death_time(CREW, world.time)

/mob/abstract/ghost/observer/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/book/tome))
		var/mob/abstract/ghost/observer/M = src
		M.manifest(user)

/mob/abstract/ghost/observer/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/abstract/ghost/observer/Life(seconds_per_tick, times_fired)
	..()
	if(!loc) return
	if(!client) return 0

	handle_hud_glasses()

	if(antagHUD)
		var/list/target_list = list()
		for(var/mob/living/target in oview(src, 14))
			if(target.mind && target.mind.special_role)
				target_list += target
		if(target_list.len)
			assess_targets(target_list, src)
	if(medHUD)
		process_medHUD(src)

/mob/abstract/ghost/observer/proc/teleport_to_spawn(var/message)
	if(!message)
		message = "You can not freely observe on this z-level."

	//Teleport them back to the ghost spawn
	var/obj/O = locate("landmark*Observer-Start")
	if(istype(O))
		to_chat(src, SPAN_NOTICE("[message]"))
		forceMove(O.loc)

/mob/abstract/ghost/observer/proc/process_medHUD(var/mob/M)
	var/client/C = M.client
	for(var/mob/living/carbon/human/patient in oview(M, 14))
		C.images += patient.hud_list[HEALTH_HUD]
		C.images += patient.hud_list[STATUS_HUD_OOC]

/mob/abstract/ghost/observer/proc/assess_targets(list/target_list, mob/abstract/ghost/observer/U)
	var/client/C = U.client
	for(var/mob/living/carbon/human/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	for(var/mob/living/silicon/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	return 1

/mob/proc/ghostize(var/can_reenter_corpse = TRUE, var/should_set_timer = TRUE)
	if(ckey)
		CutOverlays(image('icons/effects/effects.dmi', "zzz_glow")) // not very efficient but ghostize isn't called /too/ often.
		var/mob/abstract/ghost/observer/ghost = new(src, src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.stat == DEAD ? src.timeofdeath : world.time

		ghost.ckey = ckey
		ghost.initialise_postkey(should_set_timer)
		if(ghost.client)
			if(!ghost.client.holder && !GLOB.config.antag_hud_allowed)		// For new ghosts we remove the verb from even showing up if it's not allowed.
				remove_verb(ghost, /mob/abstract/ghost/observer/verb/toggle_antagHUD)	// Poor guys, don't know what they are missing!
			ghost.client.init_verbs()
		return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD)
		announce_ghost_joinleave(ghostize(1, 0))
	else
		var/response
		if(check_rights((R_MOD|R_ADMIN), 0))
			response = alert(src, "You have the ability to Admin-Ghost. The regular Ghost verb will announce your presence to dead chat. Both variants will allow you to return to your body using 'aghost'.\n\nWhat do you wish to do?", "Are you sure you want to ghost?", "Ghost", "Admin Ghost", "Stay in body")
			if(response == "Admin Ghost")
				if(!src.client)
					return
				src.client.admin_ghost()
		else
			response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to play this round for another [GLOB.config.respawn_delay] minutes! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		if(response != "Ghost")
			return
		resting = 1
		var/turf/location = get_turf(src)
		message_admins("[key_name_admin(usr)] has ghosted. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
		log_game("[key_name_admin(usr)] has ghosted.")
		var/mob/abstract/ghost/observer/ghost = ghostize(0)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		ghost.timeofdeath = world.time // Because the living mob won't have a time of death and we want the respawn timer to work properly.
		announce_ghost_joinleave(ghost)

/mob/abstract/ghost/observer/can_use_hands()
	return FALSE

/mob/abstract/ghost/observer/is_active()
	return FALSE

/mob/abstract/ghost/observer/set_stat()
	stat = DEAD // They are also always dead

/mob/abstract/ghost/observer/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!client)	return
	if(!(mind && mind.current && can_reenter_corpse))
		to_chat(src, SPAN_WARNING("You have no body."))
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, SPAN_WARNING("Another consciousness is in your body... it is resisting you."))
		return
	if(mind.current.ajourn && mind.current.stat != DEAD) //check if the corpse is astral-journeying (it's client ghosted using a cultist rune).
		var/found_rune
		for(var/obj/effect/rune/R in get_turf(mind.current)) //whilst corpse is alive, we can only reenter the body if it's on the rune
			if(R.rune.type == /datum/rune/ethereal)
				found_rune = TRUE
				break
		if(!found_rune)
			to_chat(usr, SPAN_CULT("The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you."))
			return
	QDEL_NULL(orbiting)
	mind.current.ajourn=0
	mind.current.key = key
	mind.current.teleop = null
	mind.current.client.init_verbs()
	if(!admin_ghosted)
		announce_ghost_joinleave(mind, 0, "They now occupy their body again.")
	return 1

/mob/abstract/ghost/observer/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"
	if(!client)
		return
	if(medHUD)
		medHUD = 0
		to_chat(src, SPAN_NOTICE("<B>Medical HUD Disabled</B>"))
	else
		medHUD = 1
		to_chat(src, SPAN_NOTICE("<B>Medical HUD Enabled</B>"))

/mob/abstract/ghost/observer/verb/scan_target()
	set category = "Ghost"
	set name = "Medical Scan Target"
	set desc = "Analyse the health of whatever you are following."

	if(!orbiting)
		to_chat(src, SPAN_WARNING("You aren't following anything!"))
		return

	if(isipc(orbit_target) || isrobot(orbit_target))
		robotic_analyze_mob(orbit_target, usr, TRUE)
	else if(ishuman(orbit_target))
		health_scan_mob(orbit_target, usr, TRUE, TRUE)
	else
		to_chat(src, SPAN_WARNING("This isn't a scannable target."))

/mob/abstract/ghost/observer/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"

	if(!client)
		return
	var/aux_staff = check_rights(R_MOD|R_ADMIN, 0)
	if(!GLOB.config.antag_hud_allowed && (!client.holder || aux_staff))
		to_chat(src, SPAN_WARNING("Admins have disabled this for this round."))
		return
	var/mob/abstract/ghost/observer/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		to_chat(src, SPAN_DANGER("You have been banned from using this feature"))
		return
	if(GLOB.config.antag_hud_restricted && !M.has_enabled_antagHUD && (!client.holder || aux_staff))
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.","Are you sure you want to turn this feature on?","Yes","No")
		if(response == "No") return
		M.can_reenter_corpse = 0
	if(!M.has_enabled_antagHUD && (!client.holder || aux_staff))
		M.has_enabled_antagHUD = 1
	if(M.antagHUD)
		M.antagHUD = 0
		to_chat(src, SPAN_NOTICE("<B>AntagHUD Disabled</B>"))
	else
		M.antagHUD = 1
		to_chat(src, SPAN_NOTICE("<B>AntagHUD Enabled</B>"))

/mob/proc/check_holy(var/turf/T)
	return 0

/mob/abstract/ghost/observer/check_holy(var/turf/T)
	if(check_rights(R_ADMIN|R_FUN, 0, src))
		return 0

	return (T && T.holy) && (invisibility <= SEE_INVISIBLE_LIVING || (mind in GLOB.cult.current_antagonists))

/mob/abstract/ghost/observer/verb/jumptomob(input in getmobs()) //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/abstract/ghost/observer)) //Make sure they're an observer!
		var/target = getmobs()[input]
		if(!target) return
		var/turf/T = get_turf(target) //Turf of the destination mob

		if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
			abstract_move(T)
		else
			to_chat(src, "This mob is not located in the game world.")

/mob/abstract/ghost/observer/memory()
	set hidden = 1
	to_chat(src, SPAN_WARNING("You are dead! You have no mind to store memory!"))

/mob/abstract/ghost/observer/add_memory()
	set hidden = 1
	to_chat(src, SPAN_WARNING("You are dead! You have no mind to store memory!"))

//This is called when a ghost is drag clicked to something.
/mob/abstract/ghost/observer/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(!user || !over)
		return
	if(isobserver(user) && user.client && isliving(over))
		var/mob/living/M = over
		// If they an admin, see if control can be resolved.
		if(user.client.holder && user.client.holder.cmd_ghost_drag(src, M))
			return
		// Otherwise, see if we can possess the target.
		if(user == src && try_possession(M))
			return
	if(istype(over, /obj/machinery/drone_fabricator))
		var/obj/machinery/drone_fabricator/fab = over
		if(fab.create_drone(src))
			return

	return ..()

/mob/abstract/ghost/observer/proc/try_possession(var/mob/living/M)
	if(!GLOB.config.ghosts_can_possess_animals)
		to_chat(usr, SPAN_WARNING("Ghosts are not permitted to possess animals."))
		return 0
	if(!M.can_be_possessed_by(src))
		return 0
	return M.do_possession(src)

//Used for drawing on walls with blood puddles as a spooky ghost.
/mob/abstract/ghost/observer/verb/bloody_doodle()
	set category = "Ghost"
	set name = "Write in blood"
	set desc = "If the round is sufficiently spooky, write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!(GLOB.config.cult_ghostwriter))
		to_chat(src, SPAN_WARNING("That verb is not currently permitted."))
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(!round_is_spooky())
		to_chat(src, SPAN_WARNING("The veil is not thin enough for you to do that."))
		return

	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/blood/B in view(1,src))
		if(B.amount > 0)
			choices += B

	if(!choices.len)
		to_chat(src, "<span class = 'warning'>There is no blood to use nearby.</span>")
		return

	var/obj/effect/decal/cleanable/blood/choice = input(src,"What blood would you like to use?") in null|choices

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	var/turf/simulated/T = src.loc
	if (direction != "Here")
		T = get_step(T,text2dir(direction))

	if (!istype(T))
		to_chat(src, SPAN_WARNING("You cannot doodle there."))
		return

	if(!choice || choice.amount == 0 || !(src.Adjacent(choice)))
		return

	var/doodle_color = (choice.basecolor) ? choice.basecolor : COLOR_HUMAN_BLOOD

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, SPAN_WARNING("There is no space to write on!"))
		return

	var/max_length = 50

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)

		if (length(message) > max_length)
			message += "-"
			to_chat(src, SPAN_WARNING("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		W.visible_message(SPAN_WARNING("Invisible fingers crudely paint something in blood on [T]..."))

/mob/abstract/ghost/observer/pointed(atom/pointing_at)
	. = ..()
	if(!.)
		return

	src.visible_message("<span class='deadsay'><b>[src]</b> points to [pointing_at]</span>")

/mob/abstract/ghost/observer/proc/manifest(mob/user)
	is_manifest = 0
	if(!is_manifest)
		is_manifest = 1
		add_verb(src,  /mob/abstract/ghost/observer/proc/toggle_visibility_verb)
		add_verb(src, /mob/abstract/ghost/observer/proc/ghost_whisper)
		add_verb(src,  /mob/abstract/ghost/observer/proc/move_item)

	if(src.invisibility != 0)
		user.visible_message( \
			SPAN_WARNING("\The [user] drags ghost, [src], to our plane of reality!"), \
			SPAN_WARNING("You drag [src] to our plane of reality!") \
		)
		toggle_visibility(1)
	else
		user.visible_message ( \
			SPAN_WARNING("\The [user] just tried to smash [user.get_pronoun("his")] book into that ghost!  It's not very effective."), \
			SPAN_WARNING("You get the feeling that the ghost can't become any more visible.") \
		)


/mob/abstract/ghost/observer/proc/toggle_icon(var/icon)
	if(!client)
		return

	var/iconRemoved = 0
	for(var/image/I in client.images)
		if(I.icon_state == icon)
			iconRemoved = 1
			client.images -= I
			qdel(I)

	if(!iconRemoved)
		var/image/J = image('icons/mob/mob.dmi', loc = src, icon_state = icon)
		client.images += J

/mob/abstract/ghost/observer/proc/toggle_visibility_verb()
	set category = "Ghost"
	set name = "Toggle Visibility"
	set desc = "Allows you to turn (in)visible (almost) at will."

	toggle_visibility()

/mob/abstract/ghost/observer/proc/toggle_visibility(var/forced = 0)
	var/toggled_invisible
	if(!forced && invisibility && world.time < toggled_invisible + 600)
		to_chat(src, "You must gather strength before you can turn visible again...")
		return

	if(invisibility == 0)
		toggled_invisible = world.time
		visible_message("<span class='emote'>It fades from sight...</span>", "<span class='info'>You are now invisible.</span>")
	else
		to_chat(src, "<span class='info'>You are now visible!</span>")

	set_invisibility(invisibility == INVISIBILITY_OBSERVER ? 0 : INVISIBILITY_OBSERVER)
	mouse_opacity = invisibility == INVISIBILITY_OBSERVER ? 0 : initial(mouse_opacity)
	// Give the ghost a cult icon which should be visible only to itself
	toggle_icon("cult")

/mob/abstract/ghost/observer/proc/ghost_whisper()
	set category = "Ghost"
	set name = "Spectral Whisper"

	if(is_manifest)  //Only able to whisper if it's hit with a tome.
		var/list/options = list()
		for(var/mob/living/Ms in view(src))
			options += Ms
		var/mob/living/M = input(src, "Select who to whisper to:", "Whisper to?", null) as null|mob in options
		if(!M)
			return 0
		var/msg = sanitize(input(src, "Message:", "Spectral Whisper") as text|null)
		if(msg)
			log_say("SpectralWhisper: [key_name(usr)]->[M.key] : [msg]")
			to_chat(M, SPAN_WARNING(" You hear a strange, unidentifiable voice in your head... <font color='purple'>[msg]</font>"))
			to_chat(src, SPAN_WARNING(" You said: '[msg]' to [M]."))
		else
			return
		return 1
	else
		to_chat(src, SPAN_DANGER("You have not been pulled past the veil!"))

/mob/abstract/ghost/observer/proc/move_item()
	set category = "Ghost"
	set name = "Move item"
	set desc = "Move a small item to where you are."

	if(ghost_cooldown > world.time)
		return

	if(!is_manifest)
		return

	var/turf/T = get_turf(src)

	var/list/obj/item/choices = list()
	for(var/obj/item/I in range(1))
		if(I.w_class <= 2)
			choices += I

	if(!choices.len)
		to_chat(src, SPAN_WARNING("There are no suitable items nearby."))
		return

	var/obj/item/choice = input(src, "What item would you like to pull?") as null|anything in choices
	if(!choice || !(choice in range(1)) || choice.w_class > 2)
		return

	if(!is_manifest)
		return

	if(step_to(choice, T))
		choice.visible_message(SPAN_WARNING("\The [choice] suddenly moves!"))

	ghost_cooldown = world.time + 500

/mob/abstract/ghost/observer/verb/toggle_anonsay()
	set category = "Ghost"
	set name = "Toggle Anonymous Chat"
	set desc = "Toggles showing your key in dead chat."

	src.anonsay = !src.anonsay
	if(anonsay)
		to_chat(src, "<span class='info'>Your key won't be shown when you speak in dead chat.</span>")
	else
		to_chat(src, "<span class='info'>Your key will be publicly visible again.</span>")

/mob/abstract/ghost/observer/canface()
	return 1

/mob/proc/can_admin_interact()
	return 0

/mob/abstract/ghost/observer/can_admin_interact()
	return check_rights(R_ADMIN, 0, src)

/mob/abstract/ghost/observer/update_sight()
	//if they are on a restricted level, then set the ghost vision for them.
	if(on_restricted_level())
		//On the restricted level they have the same sight as the mob
		set_sight(sight&(~SEE_TURFS)&(~SEE_MOBS)&(~SEE_OBJS))
		set_see_invisible(SEE_INVISIBLE_OBSERVER)
	else
		//Outside of the restrcited level, they have enhanced vision
		set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
		set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

		if (!see_darkness)
			set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
		else
			set_see_invisible(ghostvision ? SEE_INVISIBLE_OBSERVER : SEE_INVISIBLE_LIVING)

	updateghostimages()

/proc/updateallghostimages()
	for (var/mob/abstract/ghost/observer/O in GLOB.player_list)
		O.updateghostimages()

/mob/abstract/ghost/observer/proc/updateghostimages()
	if (!client)
		return
	if (see_darkness || !ghostvision)
		client.images -= SSmobs.ghost_darkness_images
		client.images |= SSmobs.ghost_sightless_images
	else
		//add images for the 60inv things ghosts can normally see when darkness is enabled so they can see them now
		client.images -= SSmobs.ghost_sightless_images
		client.images |= SSmobs.ghost_darkness_images
		if (ghostimage)
			client.images -= ghostimage //remove ourself

/mob/abstract/ghost/observer/MayRespawn(var/feedback = 0, var/respawn_type = null)
	if(!client)
		return 0
	if(GLOB.config.antag_hud_restricted && has_enabled_antagHUD == 1)
		if(feedback)
			to_chat(src, SPAN_WARNING("antagHUD restrictions prevent you from respawning."))
		return 0

	if (respawn_type)
		var/timedifference = world.time- get_death_time(respawn_type)
		var/respawn_time = 0
		if (respawn_type == CREW)
			respawn_time = GLOB.config.respawn_delay MINUTES
		else if (respawn_type == ANIMAL)
			respawn_time = RESPAWN_ANIMAL
		else if (respawn_type == MINISYNTH)
			respawn_time = RESPAWN_MINISYNTH

		if (respawn_time && timedifference >= respawn_time)
			return 1
		else if (feedback)
			var/timedifference_text = time2text(respawn_time - timedifference,"mm:ss")
			to_chat(src, SPAN_WARNING("You must have been dead for [respawn_time/600] minute\s to respawn. You have [timedifference_text] left."))
		return 0

	return 1

/atom/proc/extra_ghost_link()
	return

/mob/extra_ghost_link(var/atom/ghost)
	if(client && eyeobj)
		return "|\[<a href='byond://?src=[REF(ghost)];track=[REF(eyeobj)]'>E</a>\]"

/mob/abstract/ghost/observer/extra_ghost_link(var/atom/ghost)
	if(mind && mind.current)
		return "|\[<a href='byond://?src=[REF(ghost)];track=[REF(mind.current)]'>B</a>\]"

/proc/ghost_follow_link(var/atom/target, var/atom/ghost)
	if((!target) || (!ghost)) return
	. = "\[<a href='byond://?src=[REF(ghost)];track=[REF(target)]'>F</a>\]"
	. += target.extra_ghost_link(ghost)


//Opens the Ghost Spawner Menu
/mob/abstract/ghost/observer/verb/ghost_spawner()
	set category = "Ghost"
	set name = "Ghost Spawner"

	if(!ROUND_IS_STARTED)
		to_chat(usr, SPAN_DANGER("The round hasn't started yet!"))
		return

	SSghostroles.ui_interact(usr)

/mob/abstract/ghost/observer/verb/submitpai()
	set category = "Ghost"
	set name = "Submit pAI personality"
	set desc = "Submits you pAI personality to the pAI candidate pool."

	if(jobban_isbanned(src, "pAI"))
		to_chat(src, "You are job banned from the pAI position.")
		return
	SSpai.recruitWindow(src)

/mob/abstract/ghost/observer/verb/revokepai()
	set category = "Ghost"
	set name = "Revoke pAI personality"
	set desc = "Removes you from the pAI candidite pool."

	if(SSpai.revokeCandidancy(src))
		to_chat(src, "You have been removed from the pAI candidate pool.")

/mob/abstract/ghost/observer/can_hear_radio(speaker_coverage = list())
	if(client && (client.prefs.toggles & CHAT_GHOSTRADIO))
		return TRUE
	return ..()

/mob/abstract/ghost/observer/get_speech_bubble_state_modifier()
	return "ghost"
