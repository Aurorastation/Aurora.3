/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	mob_list -= src
	dead_mob_list -= src
	living_mob_list -= src
	unset_machine()
	QDEL_NULL(hud_used)
	if(client)
		for(var/obj/screen/movable/spell_master/spell_master in spell_masters)
			qdel(spell_master)
		remove_screen_obj_references()
		for(var/atom/movable/AM in client.screen)
			qdel(AM)
		client.screen = list()
		client.cleanup_parallax_references()
	if (mind)
		mind.handle_mob_deletion(src)
	for(var/infection in viruses)
		qdel(infection)
	for(var/cc in client_colors)
		qdel(cc)
	client_colors = null
	viruses.Cut()

	//Added this to prevent nonliving mobs from ghostising
	//The only non 'living' mobs are:
		//observers (ie ghosts),
		//new_player, an abstraction used to handle people who are sitting in the lobby
		//Freelook, an abstraction used to handle the AI looking through cameras, and possibly remote viewing mutation

	//None of these mobs can 'die' in any sense, and none of them should be able to become ghosts.
	//Ghosts are the only ones that even technically 'exist' and aren't just an abstraction using mob code for convenience
	if (istype(src, /mob/living))
		ghostize()

	if (istype(src.loc, /atom/movable))
		var/atom/movable/AM = src.loc
		LAZYREMOVE(AM.contained_mobs, src)

	MOB_STOP_THINKING(src)

	return ..()


/mob/proc/remove_screen_obj_references()
	flash = null
	blind = null
	hands = null
	pullin = null
	purged = null
	internals = null
	oxygen = null
	i_select = null
	m_select = null
	toxin = null
	fire = null
	bodytemp = null
	healths = null
	throw_icon = null
	nutrition_icon = null
	hydration_icon = null
	pressure = null
	damageoverlay = null
	pain = null
	item_use_icon = null
	gun_move_icon = null
	gun_setting_icon = null
	spell_masters = null
	zone_sel = null

/mob/Initialize()
	. = ..()
	mob_list += src
	if(stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src

	if (!ckey && mob_thinks)
		MOB_START_THINKING(src)

/mob/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

	if(!client)	return

	if (type)
		if(type & 1 && (sdisabilities & BLIND || blinded || paralysis) )//Vision related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if (type & 2 && isdeaf(src))//Hearing related
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & 1 && sdisabilities & BLIND))
					return
	// Added voice muffling for Issue 41.
	if(stat == UNCONSCIOUS || sleeping > 0)
		to_chat(src, "<I>... You can almost hear someone talking ...</I>")
	else
		to_chat(src, msg)
	return

// Show a message to all mobs and objects in sight of this one
// This would be for visible actions by the src mob
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"

/mob/visible_message(var/message, var/self_message, var/blind_message, var/range = world.view)
	var/list/messageturfs = list() //List of turfs we broadcast to.
	var/list/messagemobs = list() //List of living mobs nearby who can hear it, and distant ghosts who've chosen to hear it
	for (var/turf in view(range, get_turf(src)))
		messageturfs += turf

	for(var/A in player_list)
		var/mob/M = A
		if (QDELETED(M))
			warning("Null or QDELETED object [DEBUG_REF(M)] found in player list! Removing.")
			player_list -= M
			continue
		if (!M.client || istype(M, /mob/abstract/new_player))
			continue
		if((get_turf(M) in messageturfs) || (isobserver(M) && (M.client.prefs.toggles & CHAT_GHOSTSIGHT)))
			messagemobs += M

	for(var/A in messagemobs)
		var/mob/M = A
		if(isobserver(M))
			M.show_message("[ghost_follow_link(src, M)] [message]", 1)
			continue
		if(self_message && M == src)
			M.show_message(self_message, 1, blind_message, 2)
		else if(M.see_invisible < invisibility)  // Cannot view the invisible, but you can hear it.
			if(blind_message)
				M.show_message(blind_message, 2)
		else
			M.show_message(message, 1, blind_message, 2)

// Designed for mobs contained inside things, where a normal visible message wont actually be visible
// Useful for visible actions by pAIs, and held mobs
// Broadcaster is the place the action will be seen/heard from, mobs in sight of THAT will see the message. This is generally the object or mob that src is contained in
// message is the message output to anyone who can see e.g. "[src] does something!"
// self_message (optional) is what the src mob sees  e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
//This is obsolete now
/mob/proc/contained_visible_message(var/atom/broadcaster, var/message, var/self_message, var/blind_message)
	var/self_served = 0
	for(var/mob/M in viewers(broadcaster))
		if(self_message && M==src)
			M.show_message(self_message, 1, blind_message, 2)
			self_served = 1
		else if(M.see_invisible < invisibility)  // Cannot view the invisible, but you can hear it.
			if(blind_message)
				M.show_message(blind_message, 2)
		else
			M.show_message(message, 1, blind_message, 2)

	if (!self_served)
		src.show_message(self_message, 1, blind_message, 2)

// Returns an amount of power drawn from the object (-1 if it's not viable).
// If drain_check is set it will not actually drain power, just return a value.
// If surge is set, it will destroy/damage the recipient and not return any power.
// Not sure where to define this, so it can sit here for the rest of time.
/atom/proc/drain_power(var/drain_check,var/surge, var/amount = 0)
	return -1

// Show a message to all mobs and objects in earshot of this one
// This would be for audible actions by the src mob
// message is the message output to anyone who can hear.
// self_message (optional) is what the src mob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/mob/audible_message(var/message, var/deaf_message, var/hearing_distance, var/self_message)

	var/range = world.view
	if(hearing_distance)
		range = hearing_distance

	var/turf/T = get_turf(src)

	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, range, mobs, objs)


	for(var/m in mobs)
		var/mob/M = m
		if(self_message && M==src)
			M.show_message(self_message,2,deaf_message,1)
			continue

		M.show_message(message,2,deaf_message,1)

	for(var/o in objs)
		var/obj/O = o
		O.show_message(message,2,deaf_message,1)

/mob/proc/findname(msg)
	for(var/mob/M in mob_list)
		if (M.real_name == text("[]", msg))
			return M
	return 0

/mob/proc/movement_delay()
	return 0

/mob/proc/Life()
	return

#define UNBUCKLED 0
#define PARTIALLY_BUCKLED 1
#define FULLY_BUCKLED 2
/mob/proc/buckled()
	// Preliminary work for a future buckle rewrite,
	// where one might be fully restrained (like an elecrical chair), or merely secured (shuttle chair, keeping you safe but not otherwise restrained from acting)
	if(!buckled)
		return UNBUCKLED
	return restrained() ? FULLY_BUCKLED : PARTIALLY_BUCKLED

/mob/proc/is_physically_disabled()
	return incapacitated(INCAPACITATION_DISABLED)

/mob/proc/cannot_stand()
	return incapacitated(INCAPACITATION_KNOCKDOWN)

/mob/proc/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)

	if ((incapacitation_flags & INCAPACITATION_STUNNED) && stunned)
		return 1

	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (weakened || resting))
		return 1

	if ((incapacitation_flags & INCAPACITATION_KNOCKOUT) && (stat || paralysis || sleeping || (status_flags & FAKEDEATH)))
		return 1

	if((incapacitation_flags & INCAPACITATION_RESTRAINED) && restrained())
		return 1

	if((incapacitation_flags & (INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		var/buckling = buckled()
		if(buckling >= PARTIALLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_PARTIALLY))
			return 1
		if(buckling == FULLY_BUCKLED && (incapacitation_flags & INCAPACITATION_BUCKLED_FULLY))
			return 1

	return 0

#undef UNBUCKLED
#undef PARTIALLY_BUCKLED
#undef FULLY_BUCKLED

/mob/proc/restrained()
	return

/mob/proc/reset_view(atom/A)
	if (client)
		A = A ? A : eyeobj
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
	return


/mob/proc/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view())
	set name = "Examine"
	set category = "IC"
	if(!A)
		return
	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
		return 1

	face_atom(A)
	A.examine(src)

/mob/var/obj/effect/decal/point/pointing_effect = null//Spam control, can only point when the previous pointer qdels

/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in range(world.view, get_turf(src))))
		return 0
	if(istype(A, /obj/effect/decal/point) || pointing_effect)
		return 0

	var/tile = get_turf(A)
	if (!tile)
		return 0

	pointing_effect = new /obj/effect/decal/point(tile)
	pointing_effect.invisibility = invisibility
	addtimer(CALLBACK(src, .proc/clear_point), 20)

	face_atom(A)
	return 1

/mob/proc/clear_point()
	QDEL_NULL(pointing_effect)

/datum/mobl	// I have no idea what the fuck this is, but it's better for it to be a datum than an /obj/effect.
	var/list/container = list()
	var/master

/mob/proc/ret_grab(datum/mobl/L, flag)
	if ((!( istype(l_hand, /obj/item/grab) ) && !( istype(r_hand, /obj/item/grab) )))
		if (!( L ))
			return null
		else
			return L.container
	else
		if (!( L ))
			L = new /datum/mobl
			L.container += src
			L.master = src
		if (istype(l_hand, /obj/item/grab))
			var/obj/item/grab/G = l_hand
			if (!(L.container.Find(G.affecting)))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if (istype(r_hand, /obj/item/grab))
			var/obj/item/grab/G = r_hand
			if (!(L.container.Find(G.affecting)))
				L.container += G.affecting
				if (G.affecting)
					G.affecting.ret_grab(L, 1)
		if (!( flag ))
			if (L.master == src)
				var/list/temp = L.container.Copy()
				qdel(L)
				return temp
			else
				return L.container
	return

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(hand)
		var/obj/item/W = l_hand
		if (W)
			W.attack_self(src)
			update_inv_l_hand()
		else
			attack_empty_hand(BP_L_HAND)
	else
		var/obj/item/W = r_hand
		if (W)
			W.attack_self(src)
			update_inv_r_hand()
		else
			attack_empty_hand(BP_R_HAND)

/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	if(mind)
		mind.show_memory(src)
	else
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	if (!mind)
		to_chat(src, "The game appears to have misplaced your mind datum, so we can't show you your notes.")
		return

	if (length(mind.memory) >= MAX_PAPER_MESSAGE_LEN)
		to_chat(src, "<span class='danger'>You have exceeded the alotted text size for memories.</span>")
		return

	msg = sanitize(msg)

	if (length(mind.memory + msg) >= MAX_PAPER_MESSAGE_LEN)
		to_chat(src, "<span class='danger'>Your input would exceed the alotted text size for memories. Try again with a shorter message.</span>")
		return

	mind.store_memory(msg)

/mob/proc/update_flavor_text()
	set src in usr
	if(usr != src)
		to_chat(usr, "No.")
	var/msg = sanitize(input(usr,"Set the flavor text in your 'examine' verb. Can also be used for OOC notes about your character.","Flavor Text",html_decode(flavor_text)) as message|null, extra = 0)

	if(msg != null)
		flavor_text = msg

/mob/proc/warn_flavor_changed()
	if(flavor_text && flavor_text != "") // don't spam people that don't use it!
		to_chat(src, "<h2 class='alert'>OOC Warning:</h2>")
		to_chat(src, "<span class='alert'>Your flavor text is likely out of date! <a href='byond://?src=\ref[src];flavor_change=1'>Change</a></span>")

/mob/proc/print_flavor_text()
	if (flavor_text && flavor_text != "")
		var/msg = replacetext(flavor_text, "\n", " ")
		if(length(msg) <= 40)
			return "<span class='notice'>[msg]</span>"
		else
			return "<span class='notice'>[copytext_preserve_html(msg, 1, 37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a></span>"

/*
/mob/verb/help()
	set name = "Help"
	src << browse('html/help.html', "window=help")
	return
*/

/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	if (!client)
		return//This shouldnt happen

	if (!( config.abandon_allowed ))
		to_chat(usr, "<span class='notice'>Respawn is disabled.</span>")
		return
	if (stat != DEAD)
		to_chat(usr, "<span class='notice'><B>You must be dead to use this!</B></span>")
		return
	if (SSticker.mode && SSticker.mode.deny_respawn) //BS12 EDIT
		to_chat(usr, "<span class='notice'>Respawn is disabled for this roundtype.</span>")
		return
	else if(!MayRespawn(1, CREW))
		return

	to_chat(usr, "You can respawn now, enjoy your new life!")

	log_game("[usr.name]/[usr.key] used abandon mob.",ckey=key_name(usr))

	to_chat(usr, "<span class='notice'><B>Make sure to play a different character, and please roleplay correctly!</B></span>")

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.",ckey=key_name(usr))
		return
	client.screen.Cut()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.",ckey=key_name(usr))
		return

	announce_ghost_joinleave(client, 0)

	// Run this here to null out death timers for the next go.

	var/mob/abstract/new_player/M = new /mob/abstract/new_player()

	M.reset_death_timers()

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.",ckey=key_name(usr))
		qdel(M)
		return

	M.key = key
	if(M.mind)
		M.mind.reset()
	return

/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	var/datum/asset/changelog = get_asset_datum(/datum/asset/simple/changelog)
	changelog.send(src)
	send_theme_resources(src)
	src << browse(enable_ui_theme(src, file2text("html/changelog.html"), file2text("html/templates/changelog_extra_header.html")), "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if(client.holder && (client.holder.rights & R_ADMIN))
		is_admin = 1
	else if(stat != DEAD || istype(src, /mob/abstract/new_player))
		to_chat(usr, "<span class='notice'>You must be observing to use this!</span>")
		return

	if(is_admin && stat == DEAD)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for(var/obj/O in world)				//EWWWWWWWWWWWWWWWWWWWWWWWW ~needs to be optimised
		if(!O.loc)
			continue
		if(istype(O, /obj/item/disk/nuclear))
			var/name = "Nuclear Disk"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/singularity))
			var/name = "Singularity"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O

		if(istype(O, /obj/machinery/bot))
			var/name = "BOT: [O.name]"
			if (names.Find(name))
				namecounts[name]++
				name = "[name] ([namecounts[name]])"
			else
				names.Add(name)
				namecounts[name] = 1
			creatures[name] = O


	for(var/mob/M in sortAtom(mob_list))
		var/name = M.name
		if (names.Find(name))
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		creatures[name] = M


	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	var/ok = "[is_admin ? "Admin Observe" : "Observe"]"
	eye_name = input("Please, select a player!", ok, null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/mob_eye = creatures[eye_name]

	if(client && mob_eye)
		client.eye = mob_eye
		if (is_admin)
			client.adminobs = 1
			if(mob_eye == client.mob || client.eye == client.mob)
				client.adminobs = 0

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	unset_machine()
	reset_view(null)

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", name, replacetext(flavor_text, "\n", "<BR>")), text("window=[];size=500x200", name))
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
//	..()
	return


/mob/proc/pull_damage()
	return 0

/mob/living/carbon/human/pull_damage()
	if(!lying || getBruteLoss() + getFireLoss() < 100)
		return 0
	for(var/thing in organs)
		var/obj/item/organ/external/e = thing
		if(!e || e.is_stump())
			continue
		if((e.status & ORGAN_BROKEN) && !(e.status & ORGAN_SPLINTED))
			return 1
		if(e.status & ORGAN_BLEEDING)
			return 1
	return 0

/mob/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(istype(M,/mob/living/silicon/ai)) return
	show_inv(usr)


/mob/verb/stop_pulling()

	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		pulling.pulledby = null
		pulling = null
		if(pullin)
			pullin.icon_state = "pull0"

/mob/proc/start_pulling(var/atom/movable/AM)

	if ( !AM || !usr || src==AM || !isturf(src.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored)
		to_chat(src, "<span class='warning'>It won't budge!</span>")
		return

	var/mob/M = null
	if(ismob(AM))
		M = AM
		if(!can_pull_mobs || !can_pull_size)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		if((mob_size < M.mob_size) && (can_pull_mobs != MOB_PULL_LARGER))
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		if((mob_size == M.mob_size) && (can_pull_mobs == MOB_PULL_SMALLER))
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		// If your size is larger than theirs and you have some
		// kind of mob pull value AT ALL, you will be able to pull
		// them, so don't bother checking that explicitly.

		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = WEAKREF(usr)

	else if(isobj(AM))
		var/obj/I = AM
		if(!can_pull_size || can_pull_size < I.w_class)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

	if(pulling)
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	if(pullin)
		pullin.icon_state = "pull1"

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.pull_damage())
			to_chat(src, "<span class='danger'>Pulling \the [H] in their current condition would probably be a bad idea.</span>")

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(M)
		var/mob/pulled = AM
		pulled.inertia_dir = 0

/mob/proc/can_use_hands()
	return

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_dead()
	return stat == DEAD

/mob/proc/is_mechanical()
	return FALSE

/mob/living/silicon/is_mechanical()
	return TRUE

/mob/living/carbon/human/is_mechanical()
	return species && (species.flags & IS_MECHANICAL)

/mob/proc/is_ready()
	return client && !!mind

/mob/proc/get_gender()
	return gender

/mob/proc/see(message)
	if(!is_active())
		return 0
	to_chat(src, message)
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/mob/Stat()
	..()
	. = (is_client_active(10 MINUTES))

	if(.)
		if(statpanel("Status") && SSticker.current_state != GAME_STATE_PREGAME)
			stat("Game ID", game_id)
			stat("Map", current_map.full_name)
			stat("Station Time", worldtime2text())
			stat("Round Duration", get_round_duration_formatted())
			stat("Last Transfer Vote", SSvote.last_transfer_vote ? time2text(SSvote.last_transfer_vote, "hh:mm") : "Never")

		if(client.holder)
			if(statpanel("Status"))
				stat("Location:", "([x], [y], [z]) [loc]")
				if (LAZYLEN(client.holder.watched_processes))
					for (var/datum/controller/ctrl in client.holder.watched_processes)
						if (!ctrl)
							LAZYREMOVE(client.holder.watched_processes, ctrl)
						else
							ctrl.stat_entry()

			if(statpanel("MC"))
				stat("CPU:", world.cpu)
				stat("Tick Usage:", world.tick_usage)
				stat("Instances:", num2text(world.contents.len, 7))
				if (config.fastboot)
					stat(null, "FASTBOOT ENABLED")
				if(Master)
					Master.stat_entry()
				else
					stat("Master Controller:", "ERROR")
				if(Failsafe)
					Failsafe.stat_entry()
				else
					stat("Failsafe Controller:", "ERROR")
				if (Master)
					stat(null, "- Subsystems -")
					for(var/datum/controller/subsystem/SS in Master.subsystems)
						if (!Master.initializing && SS.flags & SS_NO_DISPLAY)
							continue

						SS.stat_entry()

		if(listed_turf && client)
			if(!TurfAdjacent(listed_turf))
				listed_turf = null
			else
				if(statpanel("Turf"))
					stat("Turf:", listed_turf)
					for(var/atom/A in listed_turf)
						if(!A.mouse_opacity)
							continue
						if(A.invisibility > see_invisible)
							continue
						if(is_type_in_typecache(A, shouldnt_see))
							continue
						stat(A)


// facing verbs
/mob/proc/canface()
	if(!canmove)						return 0
	if(stat)							return 0
	if(anchored)						return 0
	if(transforming)						return 0
	return 1

// Not sure what to call this. Used to check if humans are wearing an AI-controlled exosuit and hence don't need to fall over yet.
/mob/proc/can_stand_overridden()
	return 0

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
/mob/proc/update_canmove()

	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
		canmove = 1
	else
		if(istype(buckled, /obj/vehicle))
			var/obj/vehicle/V = buckled
			if(is_physically_disabled())
				lying = 1
				canmove = 0
				pixel_y = V.mob_offset_y - 5
			else
				if(buckled.buckle_lying != -1) lying = buckled.buckle_lying
				canmove = 1
				pixel_y = V.mob_offset_y
		else if(buckled)
			anchored = 1
			canmove = 0
			if(istype(buckled))
				if(buckled.buckle_lying != -1)
					lying = buckled.buckle_lying
				if(buckled.buckle_movable)
					anchored = 0
					canmove = 1
		else if(captured)
			anchored = 1
			canmove = 0
			lying = 0
		else
			lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			canmove = !incapacitated(INCAPACITATION_DISABLED)

	if(lying)
		density = 0
		if(l_hand) unEquip(l_hand)
		if(r_hand) unEquip(r_hand)
	else
		density = initial(density)

	for(var/obj/item/grab/G in grabbed_by)
		if(G.state >= GRAB_AGGRESSIVE)
			canmove = 0
			break

	//Temporarily moved here from the various life() procs
	//I'm fixing stuff incrementally so this will likely find a better home.
	//It just makes sense for now. ~Carn
	if( update_icon )	//forces a full overlay update
		update_icon = 0
		regenerate_icons()
	else if( lying != lying_prev )
		update_icon()

	return canmove


/mob/proc/facedir(var/ndir)
	if(!canface() || (client && client.moving) || (client && world.time < client.move_delay))
		return 0
	set_dir(ndir)
	if(buckled && buckled.buckle_movable)
		buckled.set_dir(ndir)
	if (client)//Fixing a ton of runtime errors that came from checking client vars on an NPC
		client.move_delay += movement_delay()
	return 1


/mob/verb/eastface()
	set hidden = 1
	return facedir(client.client_dir(EAST))


/mob/verb/westface()
	set hidden = 1
	return facedir(client.client_dir(WEST))


/mob/verb/northface()
	set hidden = 1
	return facedir(client.client_dir(NORTH))


/mob/verb/southface()
	set hidden = 1
	return facedir(client.client_dir(SOUTH))


//This might need a rename but it should replace the can this mob use things check
/mob/proc/IsAdvancedToolUser()
	return 0

/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		facing_dir = null
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
	return

/mob/proc/Weaken(amount)
	if(status_flags & CANWEAKEN)
		facing_dir = null
		weakened = max(max(weakened,amount),0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustWeakened(amount)
	if(status_flags & CANWEAKEN)
		weakened = max(weakened + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/Paralyse(amount)
	if(status_flags & CANPARALYSE)
		facing_dir = null
		paralysis = max(max(paralysis,amount),0)
	return

/mob/proc/SetParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(amount,0)
	return

/mob/proc/AdjustParalysis(amount)
	if(status_flags & CANPARALYSE)
		paralysis = max(paralysis + amount,0)
	return

/mob/proc/Sleeping(amount)
	facing_dir = null
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Resting(amount)
	facing_dir = null
	resting = max(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	return

/mob/proc/get_species(var/reference = 0)
	return ""

/mob/proc/get_pressure_weakness()
	return 1

/mob/proc/flash_weak_pain()
	flick("weak_pain", pain)

/mob/living/carbon/human/flash_weak_pain()
	if(can_feel_pain())
		flick("weak_pain", pain)

/mob/living/proc/flash_strong_pain()
	return

/mob/living/carbon/human/flash_strong_pain()
	if(can_feel_pain())
		flick("strong_pain", pain)

/mob/proc/Jitter(amount)
	jitteriness = max(jitteriness,amount,0)

/mob/proc/get_visible_implants(var/class = 0)
	var/list/visible_implants = list()
	for(var/obj/item/O in embedded)
		if(O.w_class > class)
			visible_implants += O
	return visible_implants

/mob/proc/embedded_needs_process()
	return (embedded.len > 0)

/mob/proc/remove_implant(var/obj/item/implant, var/surgical_removal = FALSE)
	if(!LAZYLEN(get_visible_implants(0))) //Yanking out last object - removing verb.
		verbs -= /mob/proc/yank_out_object
	for(var/obj/item/O in pinned)
		if(O == implant)
			pinned -= O
		if(!pinned.len)
			anchored = 0
	implant.dropInto(loc)
	implant.add_blood(src)
	implant.update_icon()
	if(istype(implant,/obj/item/implant))
		var/obj/item/implant/imp = implant
		imp.removed()
	. = TRUE

/mob/living/carbon/human/remove_implant(var/obj/item/implant, var/surgical_removal = FALSE, var/obj/item/organ/external/affected)
	if(!affected) //Grab the organ holding the implant.
		for(var/obj/item/organ/external/organ in organs)
			for(var/obj/item/O in organ.implants)
				if(O == implant)
					affected = organ
					break
	if(affected)
		affected.implants -= implant
		if(!surgical_removal)
			shock_stage += 20
			apply_damage((implant.w_class * 7), BRUTE, affected)
			if(!BP_IS_ROBOTIC(affected) && prob(implant.w_class * 5) && affected.sever_artery()) //I'M SO ANEMIC I COULD JUST -DIE-.
				custom_pain("Something tears wetly in your [affected.name] as [implant] is pulled free!", 50, affecting = affected)
	. = ..()

/mob/proc/yank_out_object()
	set category = "Object"
	set name = "Yank out object"
	set desc = "Remove an embedded item at the cost of bleeding and pain."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return
	usr.setClickCooldown(20)

	if(usr.stat == 1)
		to_chat(usr, "You are unconscious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/list/valid_objects = list()
	var/self = null

	if(S == U)
		self = 1 // Removing object from yourself.

	valid_objects = get_visible_implants(0)
	if(!valid_objects.len)
		if(self)
			to_chat(src, "You have nothing stuck in your body that is large enough to remove.")
		else
			to_chat(U, "[src] has nothing stuck in their wounds that is large enough to remove.")
		return

	var/obj/item/selection = input("What do you want to yank out?", "Embedded objects") in valid_objects

	if(self)
		to_chat(src, "<span class='warning'>You attempt to get a good grip on [selection] in your body.</span>")
	else
		to_chat(U, "<span class='warning'>You attempt to get a good grip on [selection] in [S]'s body.</span>")

	if(!do_after(U, 30))
		return
	if(!selection || !S || !U)
		return

	if(self)
		visible_message("<span class='warning'><b>[src] rips [selection] out of their body!</b></span>","<span class='warning'><b>You rip [selection] out of your body!</b></span>")
	else
		visible_message("<span class='warning'><b>[usr] rips [selection] out of [src]'s body!</b></span>","<span class='warning'><b>[usr] rips [selection] out of your body!</b></span>")
	valid_objects = get_visible_implants(0)

	remove_implant(selection)
	selection.forceMove(get_turf(src))
	if(!(U.l_hand && U.r_hand))
		U.put_in_hands(selection)
	if(ishuman(U))
		var/mob/living/carbon/human/human_user = U
		human_user.bloody_hands(src)
	return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_tarded()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		weakened = max(weakened-1,0)
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/living/proc/handle_tarded()
	if(tarded)
		tarded = max(tarded-1, 0)
	return tarded

/mob/living/proc/handle_paralysed() // Currently only used by simple_animal.dm, treated as a special case in other mobs
	if(paralysis)
		AdjustParalysis(-1)
	return paralysis

//Check for brain worms in head.
/mob/proc/has_brain_worms()

	for(var/I in contents)
		if(istype(I,/mob/living/simple_animal/borer))
			return I

	return null

/mob/proc/Released()
	//This is called when the mob is let out of a holder
	//Override for mob-specific functionality
	return

/mob/verb/face_direction()
	set name = "Face Direction"
	set category = "IC"
	set src = usr

	set_face_dir(dir)

	if(!facing_dir)
		to_chat(usr, "You are now not facing anything.")
	else
		to_chat(usr, "You are now facing [dir2text(facing_dir)].")

/mob/proc/set_face_dir(var/newdir)
	if(newdir == facing_dir)
		facing_dir = null
	else if(newdir)
		set_dir(newdir)
		facing_dir = newdir
	else if(facing_dir)
		facing_dir = null
	else
		set_dir(dir)
		facing_dir = dir

/mob/set_dir(ndir)
	if(facing_dir)
		if(!canface() || lying || buckled || restrained())
			facing_dir = null
		else if(dir != facing_dir)
			return ..(facing_dir)
	else
		return ..(ndir)

/mob/forceMove(atom/dest)
	var/atom/movable/AM
	if (dest != loc && istype(dest, /atom/movable))
		AM = dest
		LAZYADD(AM.contained_mobs, src)

	if (istype(loc, /atom/movable))
		AM = loc
		LAZYREMOVE(AM.contained_mobs, src)

	. = ..()

	if (!contained_mobs)	// If this is true, the parent will have already called the client hook.
		update_client_hook(loc)

/mob/Move()
	. = ..()
	if (. && !contained_mobs && client)
		update_client_hook(loc)

/mob/verb/northfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(NORTH))

/mob/verb/southfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(SOUTH))

/mob/verb/eastfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(EAST))

/mob/verb/westfaceperm()
	set hidden = 1
	set_face_dir(client.client_dir(WEST))

/mob/proc/adjustEarDamage()
	return

/mob/proc/setEarDamage()
	return

//Throwing stuff

/mob/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/proc/throw_mode_off()
	src.in_throw_mode = 0
	if(src.throw_icon) //in case we don't have the HUD and we use the hotkey
		src.throw_icon.icon_state = "act_throw_off"

/mob/proc/throw_mode_on()
	src.in_throw_mode = 1
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"

//Admin helpers
/mob/proc/wind_mob(var/mob/admin)
	if (!admin)
		return

	if (!check_rights((R_MOD|R_ADMIN), 1, admin))
		return

	if (alert(admin, "Wind [src]?",,"Yes","No")!="Yes")
		return

	SetWeakened(200)
	visible_message("<font color='#002eb8'><b>OOC Information:</b></font> <font color='red'>[src] has been winded by a member of staff! Please freeze all roleplay involving their character until the matter is resolved! Adminhelp if you have further questions.</font>", "<font color='red'><b>You have been winded by a member of staff! Please stand by until they contact you!</b></font>")
	log_admin("[key_name(admin)] winded [key_name(src)]!",admin_key=key_name(admin),ckey=key_name(src))
	message_admins("[key_name_admin(admin)] winded [key_name_admin(src)]!", 1)

	feedback_add_details("admin_verb", "WIND")

	return

/mob/proc/unwind_mob(var/mob/admin)
	if (!admin)
		return

	if (!check_rights((R_MOD|R_ADMIN), 1, admin))
		return

	SetWeakened(0)
	visible_message("<font color='#002eb8'><b>OOC Information:</b></font> <font color='green'>[src] has been unwinded by a member of staff!</font>", "<font color='red'><b>You have been unwinded by a member of staff!</b></font>")
	log_admin("[key_name(admin)] unwinded [key_name(src)]!",admin_key=key_name(admin),ckey=key_name(src))
	message_admins("[key_name_admin(admin)] unwinded [key_name_admin(src)]!", 1)

	feedback_add_details("admin_verb", "UNWIND")

	return


/mob/proc/is_clumsy()
	if(CLUMSY in mutations)
		return TRUE

	return FALSE

//Helper proc for figuring out if the active hand (or given hand) is usable.
/mob/proc/can_use_hand()
	return 1

/client/proc/check_has_body_select()
	return mob && mob.hud_used && istype(mob.zone_sel, /obj/screen/zone_sel)

/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = 1
	toggle_zone_sel(list(BP_HEAD,BP_EYES,BP_MOUTH))

/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = 1
	toggle_zone_sel(list(BP_R_ARM,BP_R_HAND))

/client/verb/body_l_arm()
 	set name = "body-l-arm"
 	set hidden = 1
 	toggle_zone_sel(list(BP_L_ARM,BP_L_HAND))

/client/verb/body_chest()
 	set name = "body-chest"
 	set hidden = 1
 	toggle_zone_sel(list(BP_CHEST))

/client/verb/body_groin()
 	set name = "body-groin"
 	set hidden = 1
 	toggle_zone_sel(list(BP_GROIN))

/client/verb/body_r_leg()
 	set name = "body-r-leg"
 	set hidden = 1
 	toggle_zone_sel(list(BP_R_LEG,BP_R_FOOT))

/client/verb/body_l_leg()
 	set name = "body-l-leg"
 	set hidden = 1
 	toggle_zone_sel(list(BP_L_LEG,BP_L_FOOT))

/client/proc/toggle_zone_sel(list/zones)
	if(!check_has_body_select())
		return
	var/obj/screen/zone_sel/selector = mob.zone_sel
	selector.set_selected_zone(next_in_list(mob.zone_sel.selecting,zones))
