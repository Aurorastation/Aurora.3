// Big stompy robots.
/mob/living/heavy_vehicle
	name = "exosuit"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	status_flags = PASSEMOTES
	a_intent = I_HURT
	mob_size = MOB_LARGE
	mob_push_flags = ALLMOBS
	can_be_buckled = FALSE
	accent = ACCENT_TTS
	appearance_flags = KEEP_TOGETHER
	var/decal

	var/emp_damage = 0

	// Used to offset a non-32x32 icon appropriately.
	var/offset_x = -8
	var/offset_y = 0

	var/obj/item/device/radio/exosuit/radio
	var/obj/machinery/camera/camera

	var/wreckage_path = /obj/structure/mech_wreckage

	// Access updating/container.
	var/obj/item/card/id/access_card
	var/list/saved_access = list()
	var/sync_access = TRUE

	// Mob we're currently paired with or following | the names are saved to prevent metagaming when returning diagnostics
	var/datum/weakref/leader
	var/leader_name
	var/datum/weakref/following
	var/following_name

	// Orders from our leader
	var/nickname // we'll respond to our name or our nickname
	var/follow_distance = 3

	// Mob currently piloting the mech.
	var/list/pilots
	var/list/pilot_overlays

	// Remote control stuff
	var/remote = FALSE // Spawns a robotic pilot to be remote controlled
	var/does_hardpoint_lock = TRUE
	var/mob/living/simple_animal/spiderbot/dummy // The remote controlled dummy
	var/dummy_type = /mob/living/simple_animal/spiderbot
	var/dummy_colour

	// Visible external components. Not strictly accurately named for non-humanoid machines (submarines) but w/e
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body

	// Invisible components.
	var/datum/effect/effect/system/spark_spread/sparks

	// Equipment tracking vars.
	var/obj/item/mecha_equipment/selected_system
	var/selected_hardpoint
	var/list/hardpoints = list()
	var/hardpoints_locked
	var/maintenance_protocols
	var/lockdown
	var/entry_speed = 30
	var/loudening = FALSE // whether we're increasing the speech volume of our pilot

	// Material
	var/material/material

	// Cockpit access vars.
	var/hatch_closed = FALSE
	var/hatch_locked = FALSE
	var/force_locked = FALSE // Is it possible to unlock the hatch?

	var/use_air      = FALSE

	// Interface stuff.
	var/next_mecha_move = 0
	var/list/hud_elements = list()
	var/list/hardpoint_hud_elements = list()
	var/obj/screen/mecha/health/hud_health
	var/obj/screen/mecha/toggle/hatch_open/hud_open
	var/obj/screen/mecha/power/hud_power
	var/obj/screen/mecha/toggle/power_control/hud_power_control
	//POWER
	var/power = MECH_POWER_OFF

/mob/living/heavy_vehicle/Destroy()
	unassign_leader()
	unassign_following()

	selected_system = null

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot.client)
			pilot.client.screen -= hud_elements
			pilot.client.images -= hud_elements
		pilot.forceMove(get_turf(src))
	pilots = null

	QDEL_NULL_LIST(hud_elements)

	if(remote_network)
		SSvirtualreality.remove_mech(src, remote_network)

	hardpoint_hud_elements = null

	hardpoints = null

	QDEL_NULL(access_card)
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)

	. = ..()

/mob/living/heavy_vehicle/IsAdvancedToolUser()
	return 1

/mob/living/heavy_vehicle/examine(var/mob/user)
	if(!user || !user.client)
		return
	to_chat(user, "That's \a <b>[src]</b>.")
	to_chat(user, desc)
	if(LAZYLEN(pilots) && (!hatch_closed || body.pilot_coverage < 100 || body.transparent_cabin))
		if(length(pilots) == 0)
			to_chat(user, "It has <b>no pilot</b>.")
		else
			for(var/pilot in pilots)
				if(istype(pilot, /mob))
					var/mob/M = pilot
					to_chat(user, "It is being <b>piloted</b> by <a href=?src=\ref[src];examine=\ref[M]>[M.name]</a>.")
				else
					to_chat(user, "It is being <b>piloted</b> by <b>[pilot]</b>.")
	if(hardpoints.len)
		to_chat(user, "<span class='notice'>It has the following hardpoints:</span>")
		for(var/hardpoint in hardpoints)
			var/obj/item/I = hardpoints[hardpoint]
			to_chat(user, "- <b>[hardpoint]</b>: [istype(I) ? "<span class='notice'><i>[I]</i></span>" : "nothing"].")
	else
		to_chat(user, "It has <b>no visible hardpoints</b>.")

	for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
		if(!thing)
			continue
		var/damage_string = "destroyed"
		switch(thing.damage_state)
			if(1)
				damage_string = "undamaged"
			if(2)
				damage_string = "<span class='warning'>damaged</span>"
			if(3)
				damage_string = "<span class='warning'>badly damaged</span>"
			if(4)
				damage_string = "<span class='danger'>almost destroyed</span>"
		to_chat(user, "Its <b>[thing.name]</b> [thing.gender == PLURAL ? "are" : "is"] [damage_string].")

/mob/living/heavy_vehicle/Topic(href,href_list[])
	if (href_list["examine"])
		var/mob/M = locate(href_list["examine"])
		if(!M)
			return
		usr.examinate(M, 1)

/mob/living/heavy_vehicle/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	..()

	if(!access_card) access_card = new (src)

	if(offset_x) pixel_x = offset_x
	if(offset_y) pixel_y = offset_y
	radio = new(src)

	// Grab all the supplied components.
	if(source_frame)
		if(source_frame.set_name)
			name = source_frame.set_name
		if(source_frame.arms)
			source_frame.arms.forceMove(src)
			arms = source_frame.arms
		if(source_frame.legs)
			source_frame.legs.forceMove(src)
			legs = source_frame.legs
			if(legs.hover) //Checks here if hoverthrusters
				pass_flags |= PASSRAILING
		if(source_frame.head)
			source_frame.head.forceMove(src)
			head = source_frame.head
		if(source_frame.body)
			source_frame.body.forceMove(src)
			body = source_frame.body

	updatehealth()

	// Generate hardpoint list.
	for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
		if(thing && thing.has_hardpoints.len)
			for(var/hardpoint in thing.has_hardpoints)
				hardpoints[hardpoint] = null

	if(head && head.radio)
		radio = new(src)

	if(!camera)
		camera = new /obj/machinery/camera(src, 0, TRUE, TRUE)
		camera.c_tag = name
		camera.replace_networks(list(NETWORK_MECHS))

	// Create HUD.
	instantiate_hud()

	// Build icon.
	update_icon()

	add_language(LANGUAGE_TCB)
	set_default_language(all_languages[LANGUAGE_TCB])

	. = INITIALIZE_HINT_LATELOAD

/mob/living/heavy_vehicle/LateInitialize()
	var/obj/machinery/mech_charger/MR = locate() in get_turf(src)
	if(MR)
		MR.start_charging(src)

/mob/living/heavy_vehicle/return_air()
	return (body && body.pilot_coverage >= 100 && hatch_closed) ? body.cockpit : loc.return_air()

/mob/living/heavy_vehicle/GetIdCard()
	return access_card

/mob/living/heavy_vehicle/proc/toggle_power(var/mob/user)
	if(power == MECH_POWER_TRANSITION)
		to_chat(user, SPAN_NOTICE("Power transition in progress. Please wait."))
	else if(power == MECH_POWER_ON) //Turning it off is instant
		playsound(src, 'sound/mecha/mech-shutdown.ogg', 100, 0)
		power = MECH_POWER_OFF
	else if(get_cell(TRUE))
		//Start power up sequence
		power = MECH_POWER_TRANSITION
		playsound(src, 'sound/mecha/powerup.ogg', 50, 0)
		if(do_after(user, 1.5 SECONDS) && power == MECH_POWER_TRANSITION)
			playsound(src, 'sound/mecha/nominal.ogg', 50, 0)
			power = MECH_POWER_ON
		else
			to_chat(user, SPAN_WARNING("You abort the powerup sequence."))
			power = MECH_POWER_OFF
		hud_power_control?.queue_icon_update()
	else
		to_chat(user, SPAN_WARNING("Error: No power cell was detected."))

/obj/item/device/radio/exosuit
	name = "exosuit radio"
	cell = null

/obj/item/device/radio/exosuit/get_cell()
	. = ..()
	if(!.)
		var/mob/living/heavy_vehicle/E = loc
		if(istype(E))
			return E.get_cell()

/obj/item/device/radio/exosuit/ui_host()
	var/mob/living/heavy_vehicle/E = loc
	if(istype(E))
		return E
	return null

/obj/item/device/radio/exosuit/attack_self(var/mob/user)
	var/mob/living/heavy_vehicle/exosuit = loc
	if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
		user.set_machine(src)
		interact(user)
	else
		to_chat(user, "<span class='warning'>The radio is too damaged to function.</span>")

/obj/item/device/radio/exosuit/CanUseTopic()
	. = ..()
	if(.)
		var/mob/living/heavy_vehicle/exosuit = loc
		if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
			return ..()

/obj/item/device/radio/exosuit/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = mech_state)
	. = ..()

/mob/living/heavy_vehicle/proc/become_remote()
	for(var/mob/user in pilots)
		eject(user, FALSE)

	remote = TRUE
	name = name + " \"[pick("Jaeger", "Reaver", "Templar", "Juggernaut", "Basilisk")]-[rand(0, 999)]\""
	if(!remote_network)
		remote_network = REMOTE_GENERIC_MECH
	SSvirtualreality.add_mech(src, remote_network)

	if(hatch_closed)
		hatch_closed = FALSE

	dummy = new dummy_type(get_turf(src))
	dummy.real_name = "Remote-Bot"
	dummy.name = dummy.real_name
	dummy.mmi = new /obj/item/device/mmi(dummy) // this is literally just because i luck the aesthetics - geeves
	dummy.verbs -= /mob/living/proc/ventcrawl
	dummy.verbs -= /mob/living/proc/hide
	dummy.update_icon()
	if(dummy_colour)
		dummy.color = dummy_colour
	enter(dummy, TRUE)

	if(!hatch_closed)
		hatch_closed = TRUE
	hatch_locked = TRUE
	if(does_hardpoint_lock)
		hardpoints_locked = TRUE
	force_locked = TRUE
	update_icon()

/mob/living/heavy_vehicle/is_anti_materiel_vulnerable()
	return TRUE
