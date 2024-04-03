/mob/living/silicon
	// Speaking
	gender = NEUTER
	voice_name = "Synthesized Voice"
	accent = ACCENT_TTS
	var/list/speech_synthesizer_langs = list() //which languages can be vocalized by the speech synthesizer
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"

	// Description
	var/pose //Yes, now AIs can pose too.

	// Bad Guy Stuff
	var/syndicate = FALSE

	// Laws
	var/datum/ai_laws/laws
	var/law_channel = DEFAULT_LAW_CHANNEL
	var/list/additional_law_channels = list("State" = "")
	var/list/stating_laws = list() // Channels laws are currently being stated on
	var/obj/item/device/radio/common_radio // Used to determine default channels

	// Hud Stuff
	var/list/hud_list[10]
	var/sensor_mode = 0 //Determines the current HUD.

	// Alarms
	var/register_alarms = TRUE
	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	// Internal Computer
	var/obj/item/modular_computer/silicon/computer
	var/list/silicon_subsystems = list(
		/mob/living/silicon/verb/computer_interact,
		/mob/living/silicon/verb/silicon_mimic_accent
	)

	// Utility
	var/obj/item/device/camera/siliconcam/ai_camera //photography

	// ID and Access
	var/list/access_rights
	var/obj/item/card/id/id_card
	var/id_card_type = /obj/item/card/id/synthetic

	// ACCENT_ALL_IPC with the added consideration that this selection can be used by the ship AI itself, and should not look bad for the SCC. No dregs, Himeans, Trinarists, etc.
	var/list/possible_accents = list(ACCENT_CETI, ACCENT_TTS, ACCENT_XANU, ACCENT_COC, ACCENT_ELYRA, ACCENT_ERIDANI, ACCENT_SOL, ACCENT_SILVERSUN_EXPATRIATE, ACCENT_SILVERSUN_ORIGINAL,
	ACCENT_PHONG, ACCENT_MARTIAN, ACCENT_KONYAN, ACCENT_LUNA, ACCENT_GIBSON_OVAN, ACCENT_GIBSON_UNDIR, ACCENT_VYSOKA, ACCENT_VENUS, ACCENT_VENUSJIN, ACCENT_JUPITER, ACCENT_CALLISTO,
	ACCENT_EUROPA, ACCENT_EARTH, ACCENT_ASSUNZIONE, ACCENT_VISEGRAD, ACCENT_SANCOLETTE, ACCENT_VALKYRIE, ACCENT_MICTLAN, ACCENT_PERSEPOLIS, ACCENT_MEDINA, ACCENT_NEWSUEZ, ACCENT_AEMAQ, ACCENT_DAMASCUS)

	var/can_hear_hivenet = TRUE

	// Misc
	uv_intensity = 175 //Lights cast by robots have reduced effect on diona
	mob_thinks = FALSE

	var/can_speak_basic = TRUE

/mob/living/silicon/Initialize()
	GLOB.silicon_mob_list |= src
	. = ..()
	add_language(LANGUAGE_TCB, can_speak_basic)
	init_id()

	var/datum/language/L = locate(/datum/language/common) in languages
	default_language = L

	init_subsystems()

/mob/living/silicon/Destroy()
	GLOB.silicon_mob_list -= src
	QDEL_NULL(computer)
	QDEL_NULL(computer)
	QDEL_NULL(id_card)
	QDEL_NULL(common_radio)
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.unregister_alarm(src)

	QDEL_LIST_ASSOC_VAL(hud_list)

	return ..()

/mob/living/silicon/proc/init_id()
	if(id_card)
		return
	id_card = new id_card_type(src)
	set_id_info(id_card)

/mob/living/silicon/proc/SetName(pickedName as text)
	real_name = pickedName
	name = real_name
	if(istype(id_card))
		if(!istype(id_card.chat_user))
			id_card.InitializeChatUser()
		id_card.chat_user.username = real_name

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_item()
	return

/mob/living/silicon/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			src.take_organ_damage(0, 20, emp = TRUE)
			Stun(rand(5, 10))
		if(EMP_LIGHT)
			src.take_organ_damage(0, 10, emp = TRUE)
			Stun(rand(1, 5))
	flash_act(affect_silicon = TRUE)
	to_chat(src, SPAN_DANGER("BZZZT"))
	to_chat(src, SPAN_WARNING("Warning: Electromagnetic pulse detected."))

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon, var/damage_flags)
	return	//immune

/mob/living/silicon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0, var/def_zone = null, tesla_shock = FALSE, ground_zero)
	if(istype(source, /obj/machinery/containment_field))
		spark(loc, 5, GLOB.alldirs)

		shock_damage *= 0.75	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message(SPAN_WARNING("\The [src] was shocked by \the [source]!"), \
			SPAN_DANGER("Energy pulse detected, system damaged!"), \
			SPAN_WARNING("You hear an electrical crack."))
		if(prob(20))
			Stun(2)
		return

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return TRUE

/mob/living/silicon/bullet_act(obj/item/projectile/Proj)
	if(!Proj.nodamage)
		switch(Proj.damage_type)
			if(DAMAGE_BRUTE)
				adjustBruteLoss(Proj.damage)
			if(DAMAGE_BURN)
				adjustFireLoss(Proj.damage)

	Proj.on_hit(src, 100)
	updatehealth()
	return 100

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return FALSE

/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return FALSE
	if(bot.connected_ai == ai)
		return TRUE
	return FALSE
// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return FALSE

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(evacuation_controller)
		var/eta_status = evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/get_status_tab_items()
	. = ..()
	if(!stat)
		. += "System Integrity: [round((health/maxHealth)*100)]%"
	else
		. += "System Integrity: NON-FUNCTIONAL"
		show_malf_ai()

//can't inject synths
/mob/living/silicon/can_inject(mob/user, error_msg)
	if(error_msg)
		to_chat(user, SPAN_ALERT("The armored plating is too tough."))
	return 0

//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs) //need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	var/datum/language/added_language = GLOB.all_languages[language]
	if(!added_language)
		return

	. = ..(language)
	if(can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return TRUE

/mob/living/silicon/remove_language(var/rem_language)
	var/datum/language/removed_language = GLOB.all_languages[rem_language]
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b>[synth ? default_str : null]<br/>Speech Synthesizer: <i>[synth ? "YES" : "NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = tgui_input_list(src, "Please select sensor type.", "Sensor Integration", list("Security", "Medical", "Disable"))
	switch(sensor_type)
		if("Security")
			sensor_mode = SEC_HUD
			to_chat(src, SPAN_NOTICE("Security records overlay enabled."))
		if("Medical")
			sensor_mode = MED_HUD
			to_chat(src, SPAN_NOTICE("Life signs monitor overlay enabled."))
		if("Disable")
			sensor_mode = NO_HUD
			to_chat(src, SPAN_NOTICE("Sensor augmentations disabled."))

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose = sanitize(input(usr, "This is [src]. It...", "Pose", null) as text)

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text = sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null) as text)

/mob/living/silicon/binarycheck()
	return TRUE

/mob/living/silicon/ex_act(severity)
	if(!blinded)
		flash_act(affect_silicon = TRUE)

	var/brute
	var/burn
	switch(severity)
		if(1.0)
			brute = 400
			burn = 100
		if(2.0)
			brute = 60
			burn = 60
		if(3.0)
			brute = 30

	apply_damage(brute, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_EXPLODE)
	apply_damage(burn, DAMAGE_BURN, damage_flags = DAMAGE_FLAG_EXPLODE)

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler, var/datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = FALSE
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					if(!reported)
						reported = TRUE
						to_chat(src, SPAN_WARNING("--- [AH.category] Detected ---"))
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = FALSE
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = TRUE
						to_chat(src, SPAN_NOTICE("--- [AH.category] Cleared ---"))
					to_chat(src, "\The [A.alarm_name()].")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	to_chat(src, "[A.alarm_name()]!")

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"
	to_chat(src, "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])")


/mob/living/silicon/proc/is_traitor()
	return mind && (mind in traitors.current_antagonists)

/mob/living/silicon/proc/is_malf()
	return mind && (mind in malf.current_antagonists)

/mob/living/silicon/proc/is_malf_or_traitor()
	return is_traitor() || is_malf()

/mob/living/silicon/flash_act(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, ignore_inherent = FALSE, type = /obj/screen/fullscreen/flash, length = 2.5 SECONDS)
	if(affect_silicon)
		return ..()

/mob/living/silicon/is_blind()
	return FALSE

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	..()
	if(cameraFollow)
		cameraFollow = null

/mob/living/silicon/seizure()
	flash_act(affect_silicon = TRUE)

/mob/living/silicon/Move(newloc, direct)
	. = ..()
	if(underdoor)
		underdoor = FALSE
		if((layer == UNDERDOOR))//if this is false, then we must have used hide, or had our layer changed by something else. We wont do anymore checks for this move proc
			for(var/obj/machinery/door/D in loc)
				if(D.hashatch)
					underdoor = TRUE
					break
			if(!underdoor)
				spawn(3)//A slight delay to let us finish walking out from under the door
					layer = initial(layer)

/mob/living/silicon/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/silicon/get_radio()
	return common_radio

/mob/living/silicon/get_speech_bubble_state_modifier()
	return "robot"
