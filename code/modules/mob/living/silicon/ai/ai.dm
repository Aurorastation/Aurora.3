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
	/mob/living/silicon/ai/proc/ai_help,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/remote_control_shell,
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
	var/mob/holo_icon // an abstract mob used to store icon info
	var/hologram_follow = TRUE //This is used for the AI eye, to determine if a holopad's hologram should follow it or not

	// Equipment
	var/list/network = list("Station")
	var/obj/machinery/camera/camera
	var/list/cameraRecords = list() //For storing what is shown to the cameras
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
	var/custom_sprite = FALSE 				// Whether the selected icon is custom

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

	SetName(pickedName)
	anchored = TRUE
	canmove = FALSE
	density = TRUE

	set_hologram_unique(icon('icons/mob/AI.dmi', "default"))

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
	add_language(LANGUAGE_ELYRAN_STANDARD, FALSE)
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
					B.brainobj.prepared = TRUE

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
	QDEL_NULL(ai_multi)
	QDEL_NULL(ai_radio)
	QDEL_NULL(psupply)
	QDEL_NULL(ai_camera)
	QDEL_NULL(holo_icon)
	ai_list -= src
	destroy_eyeobj()
	return ..()

/mob/living/silicon/ai/proc/on_mob_init()
	to_chat(src, "<h3>You are playing the ship's AI.</h3>")
	to_chat(src, "<strong><a href='?src=\ref[src];view_ai_help=1'>\[View help\]</a></strong> (or use OOC command <code>AI-Help</code> at any time)<br>")

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
	update_icon()

/mob/living/silicon/ai/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return FALSE

/mob/living/silicon/ai/SetName(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.name = "[pickedName] (AI Eye)"

	//Set the ID Name
	if(id_card)
		id_card.registered_name = pickedName
		id_card.assignment = "AI"
		id_card.access = get_all_station_access()
		id_card.access += access_synth
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
	use_power = POWER_USE_ACTIVE
	power_channel = EQUIP
	var/mob/living/silicon/ai/powered_ai
	invisibility = 100

/obj/machinery/ai_powersupply/New(var/mob/living/silicon/ai/ai)
	powered_ai = ai
	powered_ai.psupply = src
	forceMove(powered_ai.loc)

	..()
	use_power_oneoff(1) // Just incase we need to wake up the power system.

/obj/machinery/ai_powersupply/Destroy()
	. = ..()
	powered_ai = null

/obj/machinery/ai_powersupply/process()
	if(!powered_ai || powered_ai.stat == DEAD)
		qdel(src)
		return
	if(powered_ai.psupply != src) // For some reason, the AI has different powersupply object. Delete this one, it's no longer needed.
		qdel(src)
		return
	if(powered_ai.APU_power)
		update_use_power(POWER_USE_OFF)
		return
	if(!powered_ai.anchored)
		loc = powered_ai.loc
		update_use_power(POWER_USE_OFF)
		use_power_oneoff(50000) // Less optimalised but only called if AI is unwrenched. This prevents usage of wrenching as method to keep AI operational without power. Intellicard is for that.
	if(powered_ai.anchored)
		update_use_power(POWER_USE_ACTIVE)

/mob/living/silicon/ai/rejuvenate()
	return 	// TODO: Implement AI rejuvination

/mob/living/silicon/ai/proc/ai_help()
	set category = "OOC"
	set name = "AI Help"

	var/radio_keys = jointext(src.get_radio_keys(), "<br>")
	var/dat = "\
		<h1>AI Basics</h1>\
		<p>You are playing the vessel's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</p>\
		<p>Familiarize yourself with the GUI buttons in world view. They are shortcuts to running commands for camera tracking, displaying alerts, moving up and down and such.</p>\
		<p>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc. \
			To use something, simply click on it.</p>\
		<h2>AI Shell</h2>\
		<p>As an AI, you have access to an unique, inhabitable AI shell that spawns behind your core.\
			 This construct can be used in a variety of ways, but its primary function is to be a <strong>role play tool</strong> to give you the ability to have an actual physical presence on the ship.\
			 The shell is an extension of you, which means <strong>your laws apply to it aswell.</strong>\
		</p>\
		<h2>OOC Notes</h2>\
		<p>Please remember that as an AI <strong>you can heavily skew the game in your (and thus usually the crew's) favour</strong>. \
			You are extremely effective at identifying and stopping threats, which unfortunately also means that \
			<strong>you are potentially very effective at ruining everyone's fun</strong>.</p>\
		<p>Don't forget to <strong>give <em>all</em> players some leeway</strong>; you don't have to report every crime as it happens with complete accuracy, \
			call out every suspect or provide unfallible evidence, especially when nobody is asking for it.</p>\
		<p>Your role is supposed to be supportive and assistive, not assertive. \
			Try to enhance the game for other players, don't mindlessly shut it down.</p>\
		<h2>Built-in radio</h2>\
		<p>You have a built-in radio. The following channels are available:\
			<div class='block' style='padding-left: 2rem'>[radio_keys]</div>\
			Use these like any other radio with the <code>Say</code> command. \
			Recall the channel list at any time by calling <code>Radio-Settings</code> under <em>AI Commands</em>.\
		</p>\
		"
	usr << browse(enable_ui_theme(usr, dat), "window=aihelp,size=520x700")

/mob/living/silicon/ai/proc/pick_icon()
	set category = "AI Commands"
	set name = "Set AI Core Display"
	if(stat || ai_restore_power_routine)
		return

	if (!custom_sprite)
		var/new_sprite = input("Select an icon!", "AI", selected_sprite) as null|anything in ai_icons
		if(new_sprite) selected_sprite = new_sprite
	update_icon()

// this verb lets the ai see the stations manifest
/mob/living/silicon/ai/proc/ai_roster()
	set category = "AI Commands"
	set name = "Show Crew Manifest"
	SSrecords.open_manifest_vueui(usr)

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
	set name = "Make Ship-wide Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one minute to pass between announcements.")
		return
	var/input = input(usr, "Please write a message to announce to the ship crew.", "A.I. Announcement") as null|message
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
	set name = "Call Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to call the evacuation?", "Confirm Evacuation", "Yes", "No")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		call_shuttle_proc(src)

	post_display_status("shuttle")

/mob/living/silicon/ai/proc/ai_recall_shuttle()
	set category = "AI Commands"
	set name = "Cancel Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to cancel the evacuation?", "Confirm Cancel", "Yes", "No")
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
	if(href_list["view_ai_help"])
		src.ai_help()
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
// now im the icon meister and it's performant lick my nuts fefore - geeves
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Commands"

	if(check_unable())
		return

	var/input
	if(alert(usr, "Would you like to select a hologram based on a humanoids within camera view or switch to a unique avatar?",,"Humanoids","Unique") == "Humanoids")
		var/list/selectable_humans = list()
		for(var/mob/living/carbon/human/H in view(usr.client))
			if(H.near_camera())
				selectable_humans[H.name] = H
		if(length(selectable_humans))
			var/chosen_human = input(usr, "Select the humanoid whose form you wish to emulate.", "Hologram Select") as null|anything in selectable_humans
			if(!chosen_human)
				return
			var/mob/living/carbon/human/H = selectable_humans[chosen_human]
			holo_icon.appearance = H.appearance
		else
			to_chat(usr, SPAN_WARNING("There are no humanoids within camera view to base your hologram on."))
	else
		input = input("Please select a hologram:") as null|anything in list("default", "floating face", "carp", "loadout character", "custom")
		if(input)
			switch(input)
				if("custom")
					if(custom_sprite)
						var/datum/custom_synth/sprite = robot_custom_icons[name]
						if(istype(sprite) && sprite.synthckey == ckey && sprite.aiholoicon)
							set_hologram_unique(icon("icons/mob/custom_synths/customhologram.dmi", "[sprite.aiholoicon]"))
					else
						to_chat(src, SPAN_WARNING("You do not have a custom sprite!"))
				if("loadout character")
					var/mob/living/carbon/human/H = SSmob.get_mannequin(usr.client.ckey)
					holo_icon.appearance = H.appearance
				else
					set_hologram_unique(icon('icons/mob/AI.dmi', input))

/mob/living/silicon/ai/proc/set_hologram_unique(var/icon/I)
	QDEL_NULL(holo_icon)
	holo_icon = new /mob/abstract(src)
	holo_icon.invisibility = 0
	holo_icon.icon = I

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
			if(!W.use_tool(src, user, 40, volume = 50))
				user.visible_message("<span class='notice'>\The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes unfastening \the [src]!</span>")
			anchored = FALSE
			exit_vr()
			return
		else
			user.visible_message("<span class='notice'>\The [user] starts to bolt \the [src] to the plating.</span>..")
			if(!W.use_tool(src, user, 40, volume = 50))
				user.visible_message("<span class='notice'>\The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes fastening down \the [src]!</span>")
			anchored = 1
			return
	else
		return ..()

/mob/living/silicon/ai/proc/get_radio_keys()
	var/list/L = list()
	var/datum/language/binary/b = new
	L += "[get_language_prefix()][b.key] - [b.name] (speak to cyborgs in binary)"
	qdel(b)
	var/holopad_key = get_radio_key_from_channel("department")
	L += "[holopad_key] - Speak from an active Holopad"
	for(var/i = 1 to src.common_radio.channels.len)
		var/channel = src.common_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		L += "[key] - [channel]"

	return L

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "AI Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.ai_radio)
		var/radio_keys = jointext(src.get_radio_keys(), ", ")
		to_chat(src, "Radio keys: [radio_keys]")
		src.ai_radio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "AI Commands"
	set desc = "Augment visual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/remote_control_shell()
	set name = "Remote Control Shell"
	set category = "AI Commands"
	set desc = "Remotely control any active shells on your AI shell network."

	if(check_unable(AI_CHECK_WIRELESS))
		return
	SSvirtualreality.bound_selection(src, REMOTE_AI_ROBOT)

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

/mob/living/silicon/ai/update_icon()
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
