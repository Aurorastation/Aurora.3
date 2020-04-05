#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2

var/list/ai_list = list()
var/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/ai_announcement,
	/mob/living/silicon/ai/proc/ai_call_shuttle,
	/mob/living/silicon/ai/proc/ai_emergency_message,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_roster,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/ai_checklaws,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_acceleration,
	/mob/living/silicon/ai/proc/toggle_camera_light,
	/mob/living/silicon/ai/proc/ai_examine,
	/mob/living/silicon/ai/proc/multitool_mode,
	/mob/living/silicon/ai/proc/toggle_hologram_movement
)

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client && M.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use

/mob/living/silicon/ai
	// Look and feel
	name = "AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"

	// Interaction
	anchored = TRUE // -- TLE
	density = TRUE
	status_flags = CANSTUN|CANPARALYSE|CANPUSH
	var/carded

	// Holopad and holograms
	var/icon/holo_icon
	var/hologram_follow = TRUE //This is used for the AI eye, to determine if a holopad's hologram should follow it or not

	// Equipment
	var/list/network = list("Station")
	var/obj/machinery/camera/camera
	var/list/cameraRecords = list() //For storing what is shown to the cameras
	var/obj/item/device/pda/ai/ai_pda
	var/obj/item/device/multitool/ai_multi
	var/obj/item/device/radio/headset/heads/ai_integrated/ai_radio
	var/datum/announcement/priority/announcement
	var/obj/machinery/ai_powersupply/psupply

	// Borgs
	var/list/connected_robots = list()

	// Damage variables
	var/fireloss = 0
	var/bruteloss = 0
	var/oxyloss = 0

	// Misc variables
	var/last_announcement = ""
	var/ai_restore_power_routine = FALSE
	var/view_alerts = FALSE
	var/camera_light_on = FALSE //Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track
	var/control_disabled = FALSE
	var/multitool_mode = FALSE

	// Malf variables
	var/malfunctioning = FALSE					// Master var that determines if AI is malfunctioning.
	var/datum/malf_hardware/hardware			// Installed piece of hardware.
	var/datum/malf_research/research			// Malfunction research datum.
	var/obj/machinery/power/apc/hack			// APC that is currently being hacked.
	var/list/hacked_apcs = list()				// List of all hacked APCs
	var/APU_power = FALSE						// If set to 1 AI runs on APU power
	var/hacking = FALSE							// Set to 1 if AI is hacking APC, cyborg, other AI, or running system override.
	var/system_override = FALSE					// Set to 1 if system override is initiated, 2 if succeeded.
	var/synthetic_takeover = FALSE				// 1 is started, 2 is complete.
	var/hack_can_fail = TRUE					// If 0, all abilities have zero chance of failing.
	var/hack_fails = 0							// This increments with each failed hack, and determines the warning message text.
	var/errored = FALSE							// Set to 1 if runtime error occurs. Only way of this happening i can think of is admin fucking up with varedit.
	var/bombing_core = FALSE					// Set to 1 if core auto-destruct is activated
	var/bombing_station = FALSE					// Set to 1 if station nuke auto-destruct is activated
	var/bombing_time = 1200						// How much time is remaining for the nuke
	var/override_CPUStorage = 0					// Bonus/Penalty CPU Storage. For use by admins/testers.
	var/override_CPURate = 0					// Bonus/Penalty CPU generation rate. For use by admins/testers.

	// Sprites
	var/datum/ai_icon/selected_sprite			// The selected icon set
	var/custom_sprite 	= FALSE 				// Whether the selected icon is custom

/mob/living/silicon/ai/proc/add_ai_verbs()
	src.verbs |= ai_verbs_default
	src.verbs |= silicon_subsystems

/mob/living/silicon/ai/proc/remove_ai_verbs()
	src.verbs -= ai_verbs_default
	src.verbs -= silicon_subsystems

/mob/living/silicon/ai/Initialize(mapload, datum/ai_laws/L, obj/item/device/mmi/B, safety = 0)
	shouldnt_see = typecacheof(/obj/effect/rune)
	announcement = new()
	announcement.title = "A.I. Announcement"
	announcement.announcement_type = "A.I. Announcement"
	announcement.newscast = TRUE

	var/list/possibleNames = ai_names

	var/pickedName
	while(!pickedName)
		pickedName = pick(ai_names)
		for(var/mob/living/silicon/ai/A in mob_list)
			if(A.real_name == pickedName && length(possibleNames) > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	ai_pda = new/obj/item/device/pda/ai(src)
	SetName(pickedName)
	anchored = TRUE
	canmove = FALSE
	density = TRUE

	holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))

	if(L && istype(L, /datum/ai_laws))
		laws = L
	else
		laws = new base_law_type

	ai_multi = new(src)
	ai_radio = new(src)
	common_radio = ai_radio
	ai_radio.myAi = src
	additional_law_channels["Holopad"] = ":h"

	ai_camera = new/obj/item/device/camera/siliconcam/ai_camera(src)

	if(istype(loc, /turf))
		add_ai_verbs(src)

	//Languages
	add_language(LANGUAGE_ROBOT, TRUE)
	add_language(LANGUAGE_TCB, TRUE)
	add_language(LANGUAGE_SOL_COMMON, FALSE)
	add_language(LANGUAGE_UNATHI, FALSE)
	add_language(LANGUAGE_SIIK_MAAS, FALSE)
	add_language(LANGUAGE_SKRELLIAN, FALSE)
	add_language(LANGUAGE_TRADEBAND, TRUE)
	add_language(LANGUAGE_GUTTER, FALSE)
	add_language(LANGUAGE_VAURCA, FALSE)
	add_language(LANGUAGE_ROOTSONG, FALSE)
	add_language(LANGUAGE_EAL, TRUE)
	add_language(LANGUAGE_YA_SSA, FALSE)
	add_language(LANGUAGE_DELVAHII, FALSE)


	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if(!B)//If there is no player/brain inside.
			empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(get_turf(src))//New empty terminal.
			qdel(src) //Delete AI.
			return
		else
			if(B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)
				if(B.brainobj)
					B.brainobj.lobotomized = TRUE

			on_mob_init()

	addtimer(CALLBACK(src, .proc/create_powersupply), 5)

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[LIFE_HUD] 		  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[ID_HUD]          = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")

	ai_list += src
	return ..()

/mob/living/silicon/ai/Destroy()
	QDEL_NULL(ai_pda)
	QDEL_NULL(ai_multi)
	QDEL_NULL(ai_radio)
	QDEL_NULL(psupply)
	QDEL_NULL(ai_camera)
	ai_list -= src
	destroy_eyeobj()
	return ..()

/mob/living/silicon/ai/proc/on_mob_init()
	to_chat(src, "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
	to_chat(src, "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>")
	to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(src, "To use something, simply click on it.")
	to_chat(src, "Use say [get_language_prefix()]b to speak to your cyborgs through binary. Use say :h to speak from an active holopad.")
	to_chat(src, "For department channels, use the following say commands:")

	var/radio_text = ""
	for(var/i = 1 to common_radio.channels.len)
		var/channel = common_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != common_radio.channels.len)
			radio_text += ", "

	to_chat(src, radio_text)

	if(malf && !(mind in malf.current_antagonists))
		show_laws()
		to_chat(src, "<b>These laws may be changed by other players, or by you if you are malfunctioning.</b>")

	job = "AI"
	if(client)
		setup_icon()
	eyeobj.possess(src)

/mob/living/silicon/ai/getFireLoss()
	return fireloss

/mob/living/silicon/ai/getBruteLoss()
	return bruteloss

/mob/living/silicon/ai/getOxyLoss()
	return oxyloss

/mob/living/silicon/ai/adjustFireLoss(var/amount)
	if(status_flags & GODMODE)
		return
	fireloss = max(0, fireloss + min(amount, health))

/mob/living/silicon/ai/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE)
		return
	bruteloss = max(0, bruteloss + min(amount, health))

/mob/living/silicon/ai/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)
		return
	oxyloss = max(0, oxyloss + min(amount, maxHealth - oxyloss))

/mob/living/silicon/ai/setFireLoss(var/amount)
	if(status_flags & GODMODE)
		fireloss = 0
		return
	fireloss = max(0, amount)

/mob/living/silicon/ai/setOxyLoss(var/amount)
	if(status_flags & GODMODE)
		oxyloss = 0
		return
	oxyloss = max(0, amount)

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		setOxyLoss(0)
	else
		health = maxHealth - getFireLoss() - getBruteLoss() // Oxyloss is not part of health as it represents AIs backup power. AI is immune against ToxLoss as it is machine.

/mob/living/silicon/ai/proc/setup_icon()
	var/datum/custom_synth/sprite = robot_custom_icons[name]
	if(istype(sprite) && sprite.synthckey == ckey)
		custom_sprite = TRUE
		icon = CUSTOM_ITEM_SYNTH
		selected_sprite = new/datum/ai_icon("Custom", "[sprite.aichassisicon]", "4", "[sprite.aichassisicon]-crash", "#FFFFFF", "#FFFFFF", "#FFFFFF")
	else
		selected_sprite = default_ai_icon
	updateicon()

/mob/living/silicon/ai/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return FALSE

/mob/living/silicon/ai/SetName(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.name = "[pickedName] (AI Eye)"

	// Set ai pda name
	if(ai_pda)
		ai_pda.ownjob = "AI"
		ai_pda.owner = pickedName
		ai_pda.name = pickedName + " (" + ai_pda.ownjob + ")"

	//Set the ID Name
	if(id_card)
		id_card.registered_name = pickedName
		id_card.assignment = "AI"
		id_card.update_name()

	if(client)
		setup_icon() //this is because the ai custom name is related to the ai name, so, we just call the setup icon after someone named their ai
	SSrecords.reset_manifest()

/*
	The AI Power supply is a dummy object used for powering the AI since only machinery should be using power.
	The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_powersupply
	name = "power supply"
	active_power_usage = 50000 // Station AIs use significant amounts of power. This, when combined with charged SMES should mean AI lasts for 1hr without external power.
	use_power = 2
	power_channel = EQUIP
	var/mob/living/silicon/ai/powered_ai
	invisibility = 100

/obj/machinery/ai_powersupply/New(var/mob/living/silicon/ai/ai)
	powered_ai = ai
	powered_ai.psupply = src
	forceMove(powered_ai.loc)

	..()
	use_power(1) // Just incase we need to wake up the power system.

/obj/machinery/ai_powersupply/Destroy()
	. = ..()
	powered_ai = null

/obj/machinery/ai_powersupply/machinery_process()
	if(!powered_ai || powered_ai.stat == DEAD)
		qdel(src)
		return
	if(powered_ai.psupply != src) // For some reason, the AI has different powersupply object. Delete this one, it's no longer needed.
		qdel(src)
		return
	if(powered_ai.APU_power)
		use_power = 0
		return
	if(!powered_ai.anchored)
		loc = powered_ai.loc
		use_power = 0
		use_power(50000) // Less optimalised but only called if AI is unwrenched. This prevents usage of wrenching as method to keep AI operational without power. Intellicard is for that.
	if(powered_ai.anchored)
		use_power = 2

/mob/living/silicon/ai/rejuvenate()
	return 	// TODO: Implement AI rejuvination

/mob/living/silicon/ai/proc/pick_icon()
	set category = "AI Commands"
	set name = "Set AI Core Display"
	if(stat || ai_restore_power_routine)
		return

	if (!custom_sprite)
		var/new_sprite = input("Select an icon!", "AI", selected_sprite) as null|anything in ai_icons
		if(new_sprite) selected_sprite = new_sprite
	updateicon()

// this verb lets the ai see the stations manifest
/mob/living/silicon/ai/proc/ai_roster()
	set category = "AI Commands"
	set name = "Show Crew Manifest"
	show_station_manifest()

//AI Examine code
/mob/living/silicon/ai/proc/ai_examine(atom/A as mob|obj|turf in view(src.eyeobj))
	set category = "AI Commands"
	set name = "Examine"

	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Your optical sensors appear to be malfunctioning.</span>")
		return 1

	face_atom(A)
	A.examine(src)

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "AI Commands"
	set name = "Make Station Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one minute to pass between announcements.")
		return
	var/input = input(usr, "Please write a message to announce to the station crew.", "A.I. Announcement") as null|message
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/proc/ai_call_shuttle()
	set category = "AI Commands"
	set name = "Call Emergency Shuttle"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to call the shuttle?", "Confirm Shuttle Call", "Yes", "No")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		call_shuttle_proc(src)

	if(emergency_shuttle.online())
		post_display_status("shuttle")

/mob/living/silicon/ai/proc/ai_recall_shuttle()
	set category = "AI Commands"
	set name = "Recall Emergency Shuttle"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to recall the shuttle?", "Confirm Shuttle Recall", "Yes", "No")
	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		cancel_call_proc(src)

/mob/living/silicon/ai/var/emergency_message_cooldown = 0
/mob/living/silicon/ai/proc/ai_emergency_message()
	set category = "AI Commands"
	set name = "Send Emergency Message"

	if(check_unable(AI_CHECK_WIRELESS))
		return
	if(!is_relay_online())
		to_chat(usr, "<span class='warning'>No Emergency Bluespace Relay detected. Unable to transmit message.</span>")
		return
	if(emergency_message_cooldown)
		to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
		return
	var/input = sanitize(input(usr, "Please choose a message to transmit to [current_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", ""))
	if(!input)
		return
	Centcomm_announce(input, usr)
	to_chat(usr, "<span class='notice'>Message transmitted.</span>")
	log_say("[key_name(usr)] has made an AI [current_map.boss_short] announcement: [input]",ckey=key_name(usr))
	emergency_message_cooldown = 1
	spawn(300)
		emergency_message_cooldown = 0


/mob/living/silicon/ai/check_eye(var/mob/user as mob)
	if (!camera)
		return -1
	return 0

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	if (prob(30))
		view_core()
	icon_state = "ai-fuzz"
	..()

/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	if(..())
		return
	if (href_list["mach_close"])
		if (href_list["mach_close"] == "aialerts")
			view_alerts = 0
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)
	if (href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in cameranet.cameras
	if (href_list["showalerts"])
		subsystem_alarm_monitor()
	//Carn: holopad requests
	if (href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				to_chat(src, "<span class='notice'>Unable to locate the holopad.</span>")

	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in mob_list

		if(target && (!istype(target, /mob/living/carbon/human) || html_decode(href_list["trackname"]) == target:get_face_name()))
			ai_actual_track(target)
		else
			to_chat(src, "<span class='warning'>System error. Cannot locate [html_decode(href_list["trackname"])].</span>")
		return
	if (href_list["readcapturedpaper"]) //Yep stolen from admin faxes
		var/entry = text2num(href_list["readcapturedpaper"])
		if(!entry || !cameraRecords.len) return
		if(!cameraRecords[entry])
			to_chat(src, "<span class='notice'>Unable to locate visual entry.</span>")
			return
		var/info = cameraRecords[entry]
		src << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", info[1], info[2]), text("window=[]", html_encode(info[1])))
		return

	return

/mob/living/silicon/ai/ex_act(severity)
	if (health > 0)
		adjustBruteLoss(min(30/severity, health))
		updatehealth()
	return

/mob/living/silicon/ai/reset_view(atom/A)
	if(camera)
		camera.set_light(0)
	if(istype(A,/obj/machinery/camera))
		camera = A
	..()
	if(istype(A,/obj/machinery/camera))
		if(camera_light_on)	A.set_light(AI_CAMERA_LUMINOSITY)
		else				A.set_light(0)


/mob/living/silicon/ai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/cancel_camera()
	set category = "AI Commands"
	set name = "Cancel Camera View"

	//src.cameraFollow = null
	src.view_core()

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/get_camera_network_list()
	if(check_unable())
		return

	var/list/cameralist = new()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		var/list/tempnetwork = difflist(C.network,restricted_camera_networks,1)
		for(var/i in tempnetwork)
			cameralist[i] = i

	sortTim(cameralist, /proc/cmp_text_asc)
	return cameralist

/mob/living/silicon/ai/proc/ai_network_change(var/network in get_camera_network_list())
	set category = "AI Commands"
	set name = "Jump To Network"
	unset_machine()

	if(!network)
		return

	if(!eyeobj)
		view_core()
		return

	src.network = network

	for(var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		if(network in C.network)
			eyeobj.setLoc(get_turf(C))
			break
	to_chat(src, "<span class='notice'>Switched to [network] camera network.</span>")
//End of code by Mord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "AI Commands"
	set name = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	set_ai_status_displays(src)
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Commands"

	if(check_unable())
		return

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()
		var/current_mobs = list()

		for(var/mob/living/carbon/human/H in human_mob_list)
			current_mobs[H.real_name] = H
		for(var/datum/record/general/t in SSrecords.records_locked)//Look in data core locked.
			personnel_list["[t.name]: [t.rank]"] = t.photo_front //Pull names, rank, and image.
			if(current_mobs[t.name])
				personnel_list["[t.name]: [t.rank]"] = list("mob" = current_mobs[t.name], "image" = t.photo_front)

		if(personnel_list.len)
			input = input("Select a crew member:") as null|anything in personnel_list
			var/selection = personnel_list[input]
			var/icon/character_icon
			if(selection && istype(selection, /list))
				var/mob/living/carbon/human/H = selection["mob"]
				if (H.near_camera())
					character_icon = new('icons/mob/human.dmi', "blank")
					for(var/renderdir in cardinal)
						character_icon.Insert(getHologramIcon(getFlatIcon(H, renderdir, always_use_defdir=1)), dir = renderdir)
				else
					character_icon = getHologramIcon(icon(selection["image"]))
			if(selection && istype(selection, /icon))
				character_icon = getHologramIcon(icon(selection))
			if(character_icon)
				qdel(holo_icon) // Clear old icon so we're not storing it in memory.
				holo_icon = character_icon
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list[] = list(
		"default",
		"floating face",
		"carp",
		"custom"
		)
		input = input("Please select a hologram:") as null|anything in icon_list
		if(input)
			qdel(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo2"))
				if("carp")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo4"))
				if("custom")
					if(custom_sprite)
						var/datum/custom_synth/sprite = robot_custom_icons[name]
						if(istype(sprite) && sprite.synthckey == ckey && sprite.aiholoicon)
							holo_icon = getHologramIcon(icon("icons/mob/custom_synths/customhologram.dmi","[sprite.aiholoicon]"))
					else
						to_chat(src, "You do not have a custom sprite!")
						return
	return

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "AI Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights [camera_light_on ? "activated" : "deactivated"].")
	if(!camera_light_on)
		if(camera)
			camera.set_light(0)
			camera = null
	else
		lightNearbyCamera()



// Handled camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(src.camera)
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && src.camera != camera)
				src.camera.set_light(0)
				if(!camera.light_disabled)
					src.camera = camera
					src.camera.set_light(AI_CAMERA_LUMINOSITY)
				else
					src.camera = null
			else if(isnull(camera))
				src.camera.set_light(0)
				src.camera = null
		else
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && !camera.light_disabled)
				src.camera = camera
				src.camera.set_light(AI_CAMERA_LUMINOSITY)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.


/mob/living/silicon/ai/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/aicard))

		var/obj/item/aicard/card = W
		card.grab_ai(src, user)

	else if(W.iswrench())
		if(anchored)
			user.visible_message("<span class='notice'>\The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!do_after(user,40/W.toolspeed))
				user.visible_message("<span class='notice'>\The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes unfastening \the [src]!</span>")
			anchored = 0
			return
		else
			user.visible_message("<span class='notice'>\The [user] starts to bolt \the [src] to the plating.</span>..")
			if(!do_after(user,40/W.toolspeed))
				user.visible_message("<span class='notice'>\The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes fastening down \the [src]!</span>")
			anchored = 1
			return
	else
		return ..()

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "AI Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.ai_radio)
		src.ai_radio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "AI Commands"
	set desc = "Augment visual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/toggle_hologram_movement()
	set name = "Toggle Hologram Movement"
	set category = "AI Commands"
	set desc = "Toggles hologram movement based on moving with your virtual eye."

	hologram_follow = !hologram_follow
	to_chat(usr, "<span class='info'>Your hologram will now [hologram_follow ? "follow" : "no longer follow"] you.</span>")

/mob/living/silicon/ai/proc/check_unable(var/flags = 0, var/feedback = 1)
	if(stat == DEAD)
		if(feedback) to_chat(src, "<span class='warning'>You are dead!</span>")
		return 1

	if(ai_restore_power_routine)
		if(feedback)
			to_chat(src, "<span class='warning'>You lack power!</span>")
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		if(feedback) to_chat(src, "<span class='warning'>Wireless control is disabled!</span>")
		return 1
	if((flags & AI_CHECK_RADIO) && src.ai_radio.disabledAi)
		if(feedback) to_chat(src, "<span class='warning'>System Error - Transceiver Disabled!</span>")
		return 1
	return 0

/mob/living/silicon/ai/proc/is_in_chassis()
	return istype(loc, /turf)


/mob/living/silicon/ai/ex_act(var/severity)
	if(severity == 1.0)
		qdel(src)
		return
	..()

/mob/living/silicon/ai/proc/multitool_mode()
	set name = "Toggle Multitool Mode"
	set category = "AI Commands"

	multitool_mode = !multitool_mode
	to_chat(src, "<span class='notice'>Multitool mode: [multitool_mode ? "E" : "Dise"]ngaged</span>")

/mob/living/silicon/ai/updateicon()
	if(!selected_sprite) selected_sprite = default_ai_icon

	if(stat == DEAD)
		icon_state = selected_sprite.dead_icon
		set_light(3, 1, selected_sprite.dead_light)
	else if(ai_restore_power_routine)
		icon_state = selected_sprite.nopower_icon
		set_light(1, 1, selected_sprite.nopower_light)
	else
		icon_state = selected_sprite.alive_icon
		set_light(1, 1, selected_sprite.alive_light)

// Pass lying down or getting up to our pet human, if we're in a rig.
/mob/living/silicon/ai/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = 0
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.force_rest(src)

/mob/living/silicon/ai/proc/addCameraRecord(var/itemName,var/info)
	if(!itemName || !info)
		return -1

	if(!cameraRecords)
		cameraRecords = list()

	//Didn't really want to loop here
	for(var/i = 1, i <= cameraRecords.len, i++)
		if(cameraRecords[i][1] == itemName && cameraRecords[i][2] == info)
			return i

	var/s = list(itemName,info)
	cameraRecords += list(s)
	return cameraRecords.len

/mob/living/silicon/ai/proc/has_power()
	return (ai_restore_power_routine == 0)

#undef AI_CHECK_WIRELESS
#undef AI_CHECK_RADIO
