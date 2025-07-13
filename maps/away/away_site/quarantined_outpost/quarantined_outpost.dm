// Global lists for this ruin
GLOBAL_LIST_EMPTY(light_group_1)
GLOBAL_LIST_EMPTY(light_group_2)
GLOBAL_LIST_EMPTY(light_group_3)


// map_template and archetype

/datum/map_template/ruin/away_site/quarantined_outpost
	name = "quarantined outpost"
	description = "quarantined outpost."

	prefix = "away_site/quarantined_outpost/"
	suffix = "quarantined_outpost.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED // delete this
	//sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM)
	spawn_weight = 1
	spawn_cost = 1
	id = "quarantined_outpost"

	unit_test_groups = list(1)

/singleton/submap_archetype/quarantined_outpost
	map = "quarantined outpost"
	descriptor = "quarantined outpost."

// overmap visitable

/obj/effect/overmap/visitable/sector/quarantined_outpost
	name = "degraded distress signal"
	desc = "\
		Scans reveal a facility carved inside an asteroid, not registered in the current starmap. Systems indicate minimal power activity. \
		Handshake protocols are unresponsive. Failed to communicate with docking hangar subsystems. \
		Outpost transponders are connected to an auxiliary power source and are transmitting a corrupted distress signal, details unknown. \
		The facility has been under quarantine protocols for \[unknown\] amount of time. \
		Multiple unidentified life forms are detected within. \
		Caution is advised.\
		"
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost2"
	color = "#D6D9DD"

	initial_generic_waypoints = list(

	)

/**
 * Storytelling Holograms
 * Compatible to use in any maps. Ported and adapted from Paradise Station.
 *
 * How does it work?
 * * Once a player crosses a '/obj/abstract/player_detector', it activates any holopads in perimeter of 7 tiles.
 * * Hologram repeats the things written in 'list/things_to_say' in a loop.
 * * Detector object deletes every detector of its kind in a 3 tiles radius to avoid signal spam.
 */
/obj/structure/environmental_storytelling_holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon = 'icons/obj/holopad.dmi'
	icon_state = "holopad0"
	anchored = TRUE
	layer = ABOVE_TILE_LAYER
	/// Have we been activated? If we have, we do not activate again.
	var/activated = FALSE
	/// Tied effect to kill when we die.
	var/obj/effect/overlay/our_holo
	/// Name of who we are speaking as.
	var/speaking_name = "placeholder"
	/// Appearance of the hologram.
	var/mob/holo_icon
	/// List of things to say.
	var/list/things_to_say = list("Hi future coders.", "Welcome to real lore hologram hours.", "People should have fun with these!")
	/// The sounds our hologram makes when it speaks. Use singleton sound categories. Null by default.
	var/list/soundblock = "/singleton/sound_category/hivebot_wail" //change this
	/// How long do we sleep between messages? 5 seconds by default.
	var/loop_sleep_time = 5 SECONDS
	/// Seconds integer. If set, the hologram will wait the set amount of seconds before making its speech. This applied only once and is null by default.
	var/sleep_before_speak = 5 SECONDS
	/// Should the hologram turn off once it's done its speech? True by default.
	var/turn_off_after_speech = TRUE

/obj/structure/environmental_storytelling_holopad/Destroy()
	QDEL_NULL(our_holo)
	return ..()

/obj/structure/environmental_storytelling_holopad/proc/start_message()
	if(activated)
		return

	activated = TRUE
	holo_icon = new /mob/abstract(src)
	holo_icon.set_invisibility(0)
	holo_icon.icon = icon('icons/mob/AI.dmi', "schlorrgo")
	icon_state = "holopad2"
	update_icon()
	var/obj/effect/overlay/hologram = new(get_turf(src))
	our_holo = hologram
	hologram.appearance = holo_icon.appearance
	hologram.alpha = 100
	hologram.color = rgb(214, 217, 221)
	hologram.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	hologram.layer = FLY_LAYER
	hologram.anchored = TRUE
	hologram.set_light(2, 1, rgb(214, 217, 221))
	hologram.pixel_y = 16
	hologram.name = speaking_name
	var/sound_to_play
	if(!sound_to_play && soundblock)
		sound_to_play = text2path(soundblock)
	var/datum/asset/spritesheet/S = get_asset_datum(/datum/asset/spritesheet/chat)
	var/datum/accent/a = SSrecords.accents[ACCENT_SOL]
	var/final_icon = "accent-[a.tag_icon]"
	for(var/I in things_to_say)
		if(sleep_before_speak)
			sleep(sleep_before_speak)
			sleep_before_speak = null
		hologram.langchat_speech("[I]", get_hearers_in_view(7, src), skip_language_check = TRUE)
		to_chat(get_hearers_in_view(7, src), "[{"<span onclick="window.location.href='byond://?src=[REF(src)];accent_tag=[url_encode(SSrecords.accents[ACCENT_SOL])]'">[S.icon_tag(final_icon)]</span>"} + " "]<span class='game say'><span class='name'>[speaking_name]</span> says, <span class='message'><span class='body'>\"[I]\"</span></span></span>")
		if(soundblock)
			playsound(loc, soundblock, 100, FALSE, 7)
		sleep(loop_sleep_time)
	if(turn_off_after_speech)
		QDEL_NULL(our_holo)
		icon_state = "holopad0"

/// Runs a proc when a player steps on it. Useful for mapping!
/obj/effect/player_detector
	name = "player detector"

/obj/effect/player_detector/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

	AddElement(/datum/element/connect_loc, loc_connections)
	RegisterSignal(src, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))

/obj/effect/player_detector/proc/on_entered(datum/source, atom/movable/entered)
	SIGNAL_HANDLER

/**
 * Ruin stuff
 */

//---- Lights
/obj/machinery/light/small/decayed/quarantined_outpost
	brightness_range = 6
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_DECAYED
	randomize_color = FALSE

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic // Used in this ruin for "dramatic" intoruction

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/Initialize()
	. = ..()
	stat |= POWEROFF

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/group_1

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/group_1/Initialize(mapload)
	. = ..()
	GLOB.light_group_1 += src

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/group_2

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/group_2/Initialize(mapload)
	. = ..()
	GLOB.light_group_2 += src

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/group_3

/obj/machinery/light/small/decayed/quarantined_outpost/dramatic/group_3/Initialize(mapload)
	. = ..()
	GLOB.light_group_3 += src

//---- Main player detector

/obj/effect/player_detector/quarantined_outpost
	name = "main player detector"
	var/started = FALSE

/obj/effect/player_detector/quarantined_outpost/main
	name = "main player detector"

/obj/effect/player_detector/quarantined_outpost/main/on_entered(datum/source, atom/movable/entered)
	. = ..()
	if(ishuman(entered) || isrobot(entered))
		for(var/obj/structure/environmental_storytelling_holopad/H in range(3, src.loc))
			INVOKE_ASYNC(H, TYPE_PROC_REF(/obj/structure/environmental_storytelling_holopad, start_message))
		for(var/obj/effect/player_detector/quarantined_outpost/D in range(7, loc))
			//if(D.started)
				//continue
			qdel(D)
		qdel(src)
	return

//---- Reactor room stuff

/obj/effect/player_detector/quarantined_outpost/briefer
	name = "briefer player detector"

/obj/effect/player_detector/quarantined_outpost/briefer/on_entered(datum/source, atom/movable/entered)
	. = ..()
	if(ishuman(entered) || isrobot(entered))
		INVOKE_ASYNC(src, PROC_REF(dramatic_lights))
	return

/obj/effect/player_detector/quarantined_outpost/briefer/proc/dramatic_lights()
	if(started)
		return
	started = TRUE
	for(var/obj/effect/player_detector/quarantined_outpost/D in range(7, loc))
		if(D.started)
			continue
		qdel(D)
	var/target_list
	var/I = 1

	loop_again:
	sleep(2 SECONDS)
	switch(I)
		if(1)
			target_list = GLOB.light_group_1
		if(2)
			target_list = GLOB.light_group_2
		if(3)
			target_list = GLOB.light_group_3

	for(var/obj/machinery/light/small/decayed/quarantined_outpost/O in target_list)
		O.stat &= ~POWEROFF
		O.update()
	I++
	playsound(src.loc, 'sound/effects/light_heavy_on.ogg', 50)
	if(I <= 3)
		goto loop_again
	sleep(2 SECONDS)
	for(var/obj/structure/environmental_storytelling_holopad/reactor/H in range(3, src.loc))
		H.start_message()
	qdel(src)

/obj/structure/environmental_storytelling_holopad/reactor
	speaking_name = "Strom's #1 Fan"
	things_to_say = list("Hey gamers.", "Today we'll talk about why Sol is the best origin.", "Thank you for coming to my Ted Talk!")

//---- Bluespace portal

/obj/structure/bluespace_portal_device
	name = "\improper Unknown Machine"
	desc = "A contraption of dubious purpose. Its screens and indicators are blank, standing lifeless."
	icon = 'icons/obj/structure/bluespace_portal.dmi'
	icon_state = "bluespace_tap"
	pixel_x = -32
	pixel_y = -32

/obj/structure/bluespace_portal_device/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/multitile, list(
		list(1, 1,		   1),
		list(1, MACH_CENTER, 1),
		list(1, 0,		   1),
	))

// Used by multitile component
/obj/structure/filler
	name = "big machinery part"
	density = TRUE
	anchored = TRUE
	invisibility = 101

/obj/structure/filler/ex_act()
	return

