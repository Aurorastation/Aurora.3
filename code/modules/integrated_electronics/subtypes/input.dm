/obj/item/integrated_circuit/input
	var/can_be_asked_input = 0
	category_text = "Input"
	power_draw_per_use = 50

/obj/item/integrated_circuit/input/proc/ask_for_input(mob/user)
	return

/obj/item/integrated_circuit/input/button
	name = "button"
	desc = "This tiny button must do something, right?"
	icon_state = "button"
	complexity = 1
	can_be_asked_input = 1
	inputs = list()
	outputs = list()
	activators = list("on pressed" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/button/ask_for_input(mob/user) //Bit misleading name for this specific use.
	to_chat(user, SPAN_NOTICE("You press the button labeled '[src.name]'."))
	activate_pin(1)

/obj/item/integrated_circuit/input/toggle_button
	name = "toggle button"
	desc = "It toggles on, off, on, off..."
	icon_state = "toggle_button"
	complexity = 1
	can_be_asked_input = 1
	inputs = list()
	outputs = list("on" = IC_PINTYPE_BOOLEAN)
	activators = list("on toggle" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/toggle_button/ask_for_input(mob/user) // Ditto.
	set_pin_data(IC_OUTPUT, 1, !get_pin_data(IC_OUTPUT, 1))
	push_data()
	activate_pin(1)
	to_chat(user, SPAN_NOTICE("You toggle the button labeled '[src.name]' [get_pin_data(IC_OUTPUT, 1) ? "on" : "off"]."))

/obj/item/integrated_circuit/input/numberpad
	name = "number pad"
	desc = "This small number pad allows someone to input a number into the system."
	icon_state = "numberpad"
	complexity = 2
	can_be_asked_input = 1
	inputs = list()
	outputs = list("number entered" = IC_PINTYPE_NUMBER)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/numberpad/ask_for_input(mob/user)
	var/new_input = input(user, "Enter a number, please.","Number pad") as null|num
	if(isnum(new_input) && assembly.check_interactivity(user))
		set_pin_data(IC_OUTPUT, 1, new_input)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/textpad
	name = "text pad"
	desc = "This small text pad allows someone to input a string into the system."
	icon_state = "textpad"
	complexity = 2
	can_be_asked_input = 1
	inputs = list()
	outputs = list("string entered" = IC_PINTYPE_STRING)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/textpad/ask_for_input(mob/user)
	var/new_input = sanitize(input(user, "Enter some words, please.","Number pad") as null|text, MAX_MESSAGE_LEN, 1, 0, 1)
	if(istext(new_input) && assembly.check_interactivity(user))
		set_pin_data(IC_OUTPUT, 1, new_input)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/colorpad
	name = "color pad"
	desc = "This small color pad allows someone to input a hexadecimal color into the system."
	icon_state = "colorpad"
	complexity = 2
	can_be_asked_input = 1
	inputs = list()
	outputs = list("color entered" = IC_PINTYPE_COLOR)
	activators = list("on entered" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/colorpad/ask_for_input(mob/user)
	var/new_color = input(user, "Enter a color, please.", "Color pad", get_pin_data(IC_OUTPUT, 1)) as color|null
	if(new_color && assembly.check_interactivity(user))
		set_pin_data(IC_OUTPUT, 1, new_color)
		push_data()
		activate_pin(1)

/obj/item/integrated_circuit/input/med_scanner
	name = "integrated medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is."
	icon_state = "medscan"
	complexity = 4
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		// Basic medical analyser stuff
		"brain activity" = IC_PINTYPE_NUMBER,
		"heart pulse" = IC_PINTYPE_NUMBER,
		"blood pressure" = IC_PINTYPE_LIST,
		"blood oxygenation" = IC_PINTYPE_NUMBER,
		"body temperature" = IC_PINTYPE_NUMBER,
		"in cardiac arrest?" = IC_PINTYPE_BOOLEAN,
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	power_draw_per_use = 400

/obj/item/integrated_circuit/input/med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return

	if(H.isSynthetic() || H.is_diona()) // incompatible anatomy
		return

	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		// Basic medical analyser stuff
		set_pin_data(IC_OUTPUT, 1, H.get_brain_result())
		set_pin_data(IC_OUTPUT, 2, H.get_pulse_as_number(GETPULSE_TOOL))
		set_pin_data(IC_OUTPUT, 3, H.blood_pressure())
		set_pin_data(IC_OUTPUT, 4, H.get_blood_oxygenation())
		set_pin_data(IC_OUTPUT, 5, H.bodytemperature-273.15)
		set_pin_data(IC_OUTPUT, 6, H.is_asystole())

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/adv_med_scanner
	name = "integrated advanced medical analyser"
	desc = "A very small version of the common medical analyser.  This allows the machine to know how healthy someone is.  \
	This type is much more precise, allowing the machine to know much more about the target than a normal analyzer."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		// Basic medical analyser stuff
		"brain activity" = IC_PINTYPE_NUMBER,
		"heart pulse" = IC_PINTYPE_NUMBER,
		"blood pressure" = IC_PINTYPE_LIST,
		"blood oxygenation" = IC_PINTYPE_NUMBER,
		"body temperature" = IC_PINTYPE_NUMBER,
		"in cardiac arrest?" = IC_PINTYPE_BOOLEAN,
		// Advanced
		"brute damage" = IC_PINTYPE_STRING,
		"burn damage" = IC_PINTYPE_STRING,
		"toxin damage" = IC_PINTYPE_STRING,
		"radiation dose" = IC_PINTYPE_STRING,
		"genetic instability" = IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 4)
	power_draw_per_use = 800

/obj/item/integrated_circuit/input/adv_med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return

	if(H.isSynthetic() || H.is_diona()) // incompatible anatomy
		return

	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		// Basic medical analyser stuff
		set_pin_data(IC_OUTPUT, 1, H.get_brain_result())
		set_pin_data(IC_OUTPUT, 2, H.get_pulse_as_number(GETPULSE_TOOL))
		set_pin_data(IC_OUTPUT, 3, H.blood_pressure())
		set_pin_data(IC_OUTPUT, 4, H.get_blood_oxygenation())
		set_pin_data(IC_OUTPUT, 5, H.bodytemperature-273.15)
		set_pin_data(IC_OUTPUT, 6, H.is_asystole())
		// Advanced
		set_pin_data(IC_OUTPUT, 7, get_severity(H.getBruteLoss(), TRUE))
		set_pin_data(IC_OUTPUT, 8, get_severity(H.getFireLoss(), TRUE))
		set_pin_data(IC_OUTPUT, 9, get_severity(H.getToxLoss(), TRUE))
		set_pin_data(IC_OUTPUT, 10, get_severity(H.total_radiation, TRUE))
		set_pin_data(IC_OUTPUT, 11, get_severity(H.getCloneLoss(), TRUE))

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/examiner
	name = "examiner"
	desc = "It's a little machine vision system. It can return the name, description, distance,\
	relative coordinates, total amount of reagents, and maximum amount of reagents of the referenced object."
	icon_state = "video_camera"
	complexity = 6
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"name"	            	= IC_PINTYPE_STRING,
		"description"       	= IC_PINTYPE_STRING,
		"X"         			= IC_PINTYPE_NUMBER,
		"Y"			            = IC_PINTYPE_NUMBER,
		"distance"			    = IC_PINTYPE_NUMBER,
		"max reagents"			= IC_PINTYPE_NUMBER,
		"amount of reagents"    = IC_PINTYPE_NUMBER,
		"density"				= IC_PINTYPE_BOOLEAN,
		"opacity"				= IC_PINTYPE_BOOLEAN,
		"occupied turf"			= IC_PINTYPE_REF,
		"target"				= IC_PINTYPE_REF,
		"absolute X"			= IC_PINTYPE_NUMBER,
		"absolute Y"			= IC_PINTYPE_NUMBER,
		"absolute Z"			= IC_PINTYPE_NUMBER,
		"valid"					= IC_PINTYPE_BOOLEAN,
		"status"				= IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT, "not scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 4)
	power_draw_per_use = 800

/obj/item/integrated_circuit/input/examiner/do_work()
	var/atom/H = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/turf/T = get_turf(src)
	if(!istype(H)) //Invalid input
		set_pin_data(IC_OUTPUT, 15, FALSE)
		set_pin_data(IC_OUTPUT, 16, "Invalid target.")
		push_data()
		activate_pin(3)
		return

	if((H in view(T)) || (get_turf(H) == T))


		set_pin_data(IC_OUTPUT, 1, H.name)
		set_pin_data(IC_OUTPUT, 2, H.desc)
		set_pin_data(IC_OUTPUT, 3, H.x-T.x)
		set_pin_data(IC_OUTPUT, 4, H.y-T.y)
		set_pin_data(IC_OUTPUT, 5, sqrt((H.x-T.x)*(H.x-T.x)+ (H.y-T.y)*(H.y-T.y)))
		var/mr = 0
		var/tr = 0
		if(H.reagents)
			mr = H.reagents.maximum_volume
			tr = H.reagents.total_volume
		set_pin_data(IC_OUTPUT, 6, mr)
		set_pin_data(IC_OUTPUT, 7, tr)
		set_pin_data(IC_OUTPUT, 8, H.density)
		set_pin_data(IC_OUTPUT, 9, H.opacity)
		set_pin_data(IC_OUTPUT, 10, get_turf(H))
		set_pin_data(IC_OUTPUT, 11, H)
		set_pin_data(IC_OUTPUT, 12, H.x)
		set_pin_data(IC_OUTPUT, 13, H.y)
		set_pin_data(IC_OUTPUT, 14, H.z)
		set_pin_data(IC_OUTPUT, 15, TRUE)
		set_pin_data(IC_OUTPUT, 16, "Scanned.")
		push_data()
		activate_pin(2)
	else
		set_pin_data(IC_OUTPUT, 15, FALSE)
		set_pin_data(IC_OUTPUT, 16, "Target out of scanner view.")
		push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/local_locator
	name = "local locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is holding the machine containing it."
	inputs = list()
	outputs = list(
		"located ref" = IC_PINTYPE_REF
	)
	activators = list(
		"locate" = IC_PINTYPE_PULSE_IN,
		"on locate" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 200

/obj/item/integrated_circuit/input/local_locator/do_work()
	if(assembly && istype(assembly.loc, /mob/living))
		set_pin_data(IC_OUTPUT, 1, assembly.loc)
	else
		set_pin_data(IC_OUTPUT, 1, null)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/adjacent_locator
	name = "adjacent locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon.  This type only locates something \
	that is standing a meter away from the machine."
	extended_desc = "The first pin requires a ref to a kind of object that you want the locator to acquire.  This means that it will \
	give refs to nearby objects that are similar.  If more than one valid object is found nearby, it will choose one of them at \
	random."
	inputs = list("desired type ref" = IC_PINTYPE_REF)
	outputs = list("located ref" = IC_PINTYPE_REF)
	activators = list("locate" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 300

/obj/item/integrated_circuit/input/adjacent_locator/do_work()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)
	if(!A)
		set_pin_data(IC_OUTPUT, 1, null)
		push_data()
		return
	var/desired_type = A.type

	var/list/nearby_things = range(1, get_turf(src))
	var/list/valid_things = list()
	for(var/atom/thing in nearby_things)
		if(thing.type != desired_type)
			continue
		valid_things += thing

	if(valid_things.len)
		set_pin_data(IC_OUTPUT, 1, pick(valid_things))
		push_data()

/obj/item/integrated_circuit/input/advanced_locator
	complexity = 6
	name = "advanced locator"
	desc = "This is needed for certain devices that demand a reference for a target to act upon. This type locates something that is standing in given radius of up to 7 meters."
	extended_desc = "The first pin requires a ref to a kind of object that you want the locator to acquire. This means that it will give refs to nearby objects that are similar to given sample. If this pin is a string, the locator will search for item by matching desired text in name + description. If more than one valid object is found nearby, it will choose one of them at random. The second pin is a radius."
	inputs = list("desired type" = IC_PINTYPE_ANY, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_REF )
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 300
	var/radius = 1

/obj/item/integrated_circuit/input/advanced_locator/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)
	if(isnum(rad))
		rad = clamp(rad, 0, 7)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	var/turf/T = get_turf(src)
	var/list/nearby_things = view(radius, T)
	var/list/valid_things = list()
	var/I = get_pin_data(IC_INPUT, 1, FALSE)
	if(isweakref(I))
		var/datum/weakref/WR = I
		var/atom/A = WR.resolve()
		var/desired_type = A?.type
		if(desired_type)
			for(var/atom/thing in nearby_things)
				if(thing.type == desired_type)
					valid_things.Add(thing)
	else if(istext(I))
		var/DT = I
		for(var/atom/thing in nearby_things)
			if(findtext(addtext(thing.name, " ", thing.desc), DT, 1, 0))
				valid_things.Add(thing)
	if(valid_things.len)
		set_pin_data(IC_OUTPUT, 1, pick(valid_things))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/input/signaler
	name = "integrated signaler"
	desc = "Signals from a signaler can be received with this, allowing for remote control.  Additionally, it can send signals as well."
	extended_desc = "When a signal is received from another signaler, the 'on signal received' activator pin will be pulsed.  \
	The two input pins are to configure the integrated signaler's settings.  Note that the frequency should not have a decimal in it.  \
	Meaning the default frequency is expressed as 1457, not 145.7.  To send a signal, pulse the 'send signal' activator pin."
	icon_state = "signal"
	complexity = 4
	inputs = list(
		"frequency" = IC_PINTYPE_NUMBER,
		"code" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	activators = list(
		"send signal" = IC_PINTYPE_PULSE_IN,
		"on signal sent" = IC_PINTYPE_PULSE_OUT,
		"on signal received" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_MAGNET = 2)
	power_draw_idle = 50
	power_draw_per_use = 400

	var/frequency = 1457
	var/code = 30
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_circuit/input/signaler/Initialize()
	. = ..()
	set_frequency(frequency)
	// Set the pins so when someone sees them, they won't show as null
	set_pin_data(IC_INPUT, 1, frequency)
	set_pin_data(IC_INPUT, 2, code)

/obj/item/integrated_circuit/input/signaler/Destroy()
	SSradio.remove_object(src,frequency)
	frequency = 0
	. = ..()

/obj/item/integrated_circuit/input/signaler/on_data_written()
	var/new_freq = get_pin_data(IC_INPUT, 1)
	var/new_code = get_pin_data(IC_INPUT, 2)
	if(isnum(new_freq) && new_freq > 0)
		set_frequency(new_freq)
	if(isnum(new_code))
		code = new_code


/obj/item/integrated_circuit/input/signaler/do_work() // Sends a signal.
	if(!radio_connection)
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	radio_connection.post_signal(src, signal)
	activate_pin(2)

/obj/item/integrated_circuit/input/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)

/obj/item/integrated_circuit/input/signaler/receive_signal(datum/signal/signal)
	var/new_code = get_pin_data(IC_INPUT, 2)
	var/code = 0

	if(isnum(new_code))
		code = new_code
	if(!signal)
		return 0
	if(signal.encryption != code)
		return 0
	if(signal.source == src) // Don't trigger ourselves.
		return 0

	activate_pin(3)

	var/turf/T = get_turf(src)
	var/list/viewing = viewers(T)
	for(var/mob/O in hearers(1, T))
		O.show_message("[icon2html(src, viewing)] *beep* *beep*", 3, "*beep* *beep*", 2)

//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/input/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	extended_desc = "The GPS outputs absolute map coordinates, not coordinates relative to the assembly."
	icon = 'icons/obj/item/gps.dmi'
	icon_state = "gps"
	item_state = "radio"
	contained_sprite = TRUE
	complexity = 4
	inputs = list()
	outputs = list(
		"X"= IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER,
		"Z" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list(
		"get coordinates" = IC_PINTYPE_PULSE_IN,
		"on get coordinates" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 300

/obj/item/integrated_circuit/input/gps/do_work()
	var/turf/T = get_turf(src)

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, FALSE)
	set_pin_data(IC_OUTPUT, 5, "No turf.")
	if(!T)
		push_data()
		return

	set_pin_data(IC_OUTPUT, 1, T.x)
	set_pin_data(IC_OUTPUT, 2, T.y)
	set_pin_data(IC_OUTPUT, 3, T.z)
	set_pin_data(IC_OUTPUT, 4, TRUE)
	set_pin_data(IC_OUTPUT, 5, "Coordinates acquired.")

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Detects nearby speech and outputs the speaker and message text."
	extended_desc = "When triggered by speech it can hear, this circuit outputs the speaker and message text, translated to Tau Ceti Basic when possible.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Tau Ceti Basic."
	icon_state = "recorder"
	complexity = 8
	inputs = list()
	outputs = list(
		"speaker" = IC_PINTYPE_STRING,
		"message" = IC_PINTYPE_STRING
	)
	activators = list(
		"on message received" = IC_PINTYPE_PULSE_OUT,
		"on translation" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 150

/obj/item/integrated_circuit/input/microphone/Initialize()
	. = ..()
	become_hearing_sensitive()

/obj/item/integrated_circuit/input/microphone/Destroy()
	return ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(mob/living/M, msg, var/verb = "says", datum/language/speaking = null)
	receive_radio_message(M, msg, null, speaking)

/obj/item/integrated_circuit/input/microphone/proc/receive_radio_message(mob/living/M, msg, channel = null, datum/language/speaking = null)
	/*
	 * Shared microphone intake.
	 *
	 * Local speech enters through hear_talk().
	 * Radio speech enters when /obj/item/radio/headset/circuitry relays it.
	 */
	if(isanimal(M))
		if(!M.universal_speak)
			return

	var/translated = FALSE
	if(M && msg)
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			if(!istype(speaking, /datum/language/common))
				translated = TRUE
		set_pin_data(IC_OUTPUT, 1, M.GetVoice())
		set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)
	if(translated)
		activate_pin(2)

/obj/item/integrated_circuit/input/microphone/proc/receive_radio_text(speaker_name, msg, channel = null, language_name = null)
	/*
	 * Text-only fallback for radio relay hooks that do not expose mob/language datums.
	 * This cannot perform real datum-based translation because no datum/language is provided.
	 */
	if(!msg)
		return

	set_pin_data(IC_OUTPUT, 1, speaker_name ? speaker_name : "Unknown")
	set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)

	if(language_name && language_name != "Tau Ceti Basic" && language_name != "Common")
		activate_pin(2)

/obj/item/integrated_circuit/input/sensor
	name = "sensor"
	desc = "Scans and obtains a reference for any objects or persons near you.  All you need to do is shove the machine in their face."
	extended_desc = "If 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	icon_state = "recorder"
	complexity = 12
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1200

/obj/item/integrated_circuit/input/sensor/proc/sense(var/atom/A, mob/user)
	if(!user.Adjacent(A))
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags)
		if(istype(A, /obj/item/storage))
			return FALSE

	set_pin_data(IC_OUTPUT, 1, A)
	push_data()
	activate_pin(1)
	user.visible_message(SPAN_NOTICE("[user] waves [assembly] around [A]."), SPAN_NOTICE("You scan [A] with [assembly]."))
	return TRUE

/obj/item/integrated_circuit/input/atmo_scanner
	name = "atmospheric analyser"
	desc = "The same atmospheric analysis module that is integrated into PDAs.  \
	This allows the machine to know the composition, temperature and pressure of the surrounding atmosphere."
	icon_state = "medscan_adv"
	complexity = 9
	inputs = list()
	outputs = list(
		"pressure"			= IC_PINTYPE_NUMBER,
		"temperature"		= IC_PINTYPE_NUMBER,
		GAS_OXYGEN			= IC_PINTYPE_NUMBER,
		GAS_NITROGEN		= IC_PINTYPE_NUMBER,
		GAS_CO2				= IC_PINTYPE_NUMBER,
		GAS_PHORON			= IC_PINTYPE_NUMBER,
		GAS_N2O				= IC_PINTYPE_NUMBER,
		GAS_HYDROGEN		= IC_PINTYPE_NUMBER,
		GAS_DEUTERIUM		= IC_PINTYPE_NUMBER,
		GAS_TRITIUM			= IC_PINTYPE_NUMBER,
		GAS_HELIUM			= IC_PINTYPE_NUMBER,
		GAS_HELIUMFUEL		= IC_PINTYPE_NUMBER,
		GAS_SULFUR			= IC_PINTYPE_NUMBER,
		GAS_NO2				= IC_PINTYPE_NUMBER,
		GAS_CHLORINE		= IC_PINTYPE_NUMBER,
		GAS_WATERVAPOR		= IC_PINTYPE_NUMBER,
		"other"				= IC_PINTYPE_NUMBER,
		"total moles"		= IC_PINTYPE_NUMBER,
		"valid"				= IC_PINTYPE_BOOLEAN,
		"status"			= IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 600

/obj/item/integrated_circuit/input/internalbm
	name = "internal battery monitor"
	desc = "This monitors the charge level of an internal battery."
	icon_state = "internalbm"
	extended_desc = "When pulsed, this circuit reports the assembly battery charge, maximum charge, and charge percentage."
	w_class = WEIGHT_CLASS_TINY
	complexity = 1
	inputs = list()
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER,
		"reference to assembly" = IC_PINTYPE_REF
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_POWER = 4, TECH_MAGNET = 3)
	power_draw_per_use = 10

/obj/item/integrated_circuit/input/internalbm/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, assembly)
	if(assembly)
		if(assembly.battery)

			set_pin_data(IC_OUTPUT, 1, assembly.battery.charge)
			set_pin_data(IC_OUTPUT, 2, assembly.battery.maxcharge)
			set_pin_data(IC_OUTPUT, 3, 100*assembly.battery.charge/assembly.battery.maxcharge)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/assembly_state
	name = "assembly state monitor"
	desc = "Reports basic state for the assembly containing this circuit."
	icon_state = "internalbm"
	extended_desc = "Reports assembly charge, maximum charge, charge percentage, open state, and holder reference. It only reads the current assembly."
	w_class = WEIGHT_CLASS_TINY
	complexity = 2
	inputs = list()
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER,
		"opened" = IC_PINTYPE_BOOLEAN,
		"holder ref" = IC_PINTYPE_REF,
		"valid" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"read" = IC_PINTYPE_PULSE_IN,
		"on read" = IC_PINTYPE_PULSE_OUT,
		"on invalid" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/assembly_state/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, FALSE)
	set_pin_data(IC_OUTPUT, 5, null)
	set_pin_data(IC_OUTPUT, 6, FALSE)

	if(!assembly)
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 4, assembly.opened)
	set_pin_data(IC_OUTPUT, 5, assembly.get_assembly_holder())
	set_pin_data(IC_OUTPUT, 6, TRUE)

	if(assembly.battery)
		set_pin_data(IC_OUTPUT, 1, assembly.battery.charge)
		set_pin_data(IC_OUTPUT, 2, assembly.battery.maxcharge)
		set_pin_data(IC_OUTPUT, 3, assembly.battery.maxcharge ? 100 * assembly.battery.charge / assembly.battery.maxcharge : 0)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/externalbm
	name = "external battery monitor"
	desc = "This can help watch the battery level of any device in range."
	icon_state = "externalbm"
	extended_desc = "When pulsed, this circuit reports the charge, maximum charge, and charge percentage of a visible power cell or powered device."
	w_class = WEIGHT_CLASS_TINY
	complexity = 2
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_POWER = 4, TECH_MAGNET = 3)
	power_draw_per_use = 10

/obj/item/integrated_circuit/input/externalbm/do_work()

	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	if(AM)


		var/obj/item/cell/cell = null
		if(istype(AM, /obj/item/cell)) // Is this already a cell?
			cell = AM
		else // If not, maybe there's a cell inside it?
			for(var/obj/item/cell/C in AM.contents)
				if(C) // Find one cell to charge.
					cell = C
					break
		if(cell)

			var/turf/A = get_turf(src)
			if(AM in view(A))
				set_pin_data(IC_OUTPUT, 1, cell.charge)
				set_pin_data(IC_OUTPUT, 2, cell.maxcharge)
				set_pin_data(IC_OUTPUT, 3, cell.percent())
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/atmo_scanner/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		set_pin_data(IC_OUTPUT, 18, FALSE)
		set_pin_data(IC_OUTPUT, 19, "No turf.")
		push_data()
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/pressure = XGM_PRESSURE(environment)
	var/total_moles = environment.total_moles

	if (total_moles)
		var/o2_level = environment.gas[GAS_OXYGEN]/total_moles
		var/n2_level = environment.gas[GAS_NITROGEN]/total_moles
		var/co2_level = environment.gas[GAS_CO2]/total_moles
		var/phoron_level = environment.gas[GAS_PHORON]/total_moles
		var/n2o_level = environment.gas[GAS_N2O]/total_moles
		var/hydrogen_level = environment.gas[GAS_HYDROGEN]/total_moles
		var/deuterium_level = environment.gas[GAS_DEUTERIUM]/total_moles
		var/tritium_level = environment.gas[GAS_TRITIUM]/total_moles
		var/helium_level = environment.gas[GAS_HELIUM]/total_moles
		var/helium3_level = environment.gas[GAS_HELIUMFUEL]/total_moles
		var/sulfurdioxide_level = environment.gas[GAS_SULFUR]/total_moles
		var/nitrogendioxide_level = environment.gas[GAS_NO2]/total_moles
		var/chlorine_level = environment.gas[GAS_CHLORINE]/total_moles
		var/watervapor_level = environment.gas[GAS_WATERVAPOR]/total_moles
		var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)
		set_pin_data(IC_OUTPUT, 1, pressure)
		set_pin_data(IC_OUTPUT, 2, round(environment.temperature-T0C,0.1))
		set_pin_data(IC_OUTPUT, 3, round(o2_level*100,0.1))
		set_pin_data(IC_OUTPUT, 4, round(n2_level*100,0.1))
		set_pin_data(IC_OUTPUT, 5, round(co2_level*100,0.1))
		set_pin_data(IC_OUTPUT, 6, round(phoron_level*100,0.01))
		set_pin_data(IC_OUTPUT, 6, round(n2o_level*100,0.01))
		set_pin_data(IC_OUTPUT, 7, round(hydrogen_level*100,0.01))
		set_pin_data(IC_OUTPUT, 8, round(deuterium_level*100,0.01))
		set_pin_data(IC_OUTPUT, 9, round(tritium_level*100,0.01))
		set_pin_data(IC_OUTPUT, 10, round(helium_level*100,0.01))
		set_pin_data(IC_OUTPUT, 11, round(helium3_level*100,0.01))
		set_pin_data(IC_OUTPUT, 12, round(sulfurdioxide_level*100,0.01))
		set_pin_data(IC_OUTPUT, 13, round(nitrogendioxide_level*100,0.01))
		set_pin_data(IC_OUTPUT, 14, round(chlorine_level*100,0.01))
		set_pin_data(IC_OUTPUT, 15, round(watervapor_level*100,0.01))
		set_pin_data(IC_OUTPUT, 16, round(unknown_level, 0.01))
		set_pin_data(IC_OUTPUT, 17, round(total_moles, 0.01))
		set_pin_data(IC_OUTPUT, 18, TRUE)
		set_pin_data(IC_OUTPUT, 19, "Atmosphere scanned.")
	else
		set_pin_data(IC_OUTPUT, 1, 0)
		set_pin_data(IC_OUTPUT, 2, -273.15)
		set_pin_data(IC_OUTPUT, 3, 0)
		set_pin_data(IC_OUTPUT, 4, 0)
		set_pin_data(IC_OUTPUT, 5, 0)
		set_pin_data(IC_OUTPUT, 6, 0)
		set_pin_data(IC_OUTPUT, 7, 0)
		set_pin_data(IC_OUTPUT, 8, 0)
		set_pin_data(IC_OUTPUT, 9, 0)
		set_pin_data(IC_OUTPUT, 10, 0)
		set_pin_data(IC_OUTPUT, 11, 0)
		set_pin_data(IC_OUTPUT, 12, 0)
		set_pin_data(IC_OUTPUT, 13, 0)
		set_pin_data(IC_OUTPUT, 14, 0)
		set_pin_data(IC_OUTPUT, 15, 0)
		set_pin_data(IC_OUTPUT, 16, 0)
		set_pin_data(IC_OUTPUT, 17, 0)
		set_pin_data(IC_OUTPUT, 18, TRUE)
		set_pin_data(IC_OUTPUT, 19, "Vacuum scanned.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/pressure_sensor
	name = "pressure sensor"
	desc = "A tiny pressure sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"pressure"       = IC_PINTYPE_NUMBER,
		"valid"          = IC_PINTYPE_BOOLEAN,
		"status"         = IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 200

/obj/item/integrated_circuit/input/pressure_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "No turf.")
		push_data()
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/pressure = XGM_PRESSURE(environment)
	var/total_moles = environment.total_moles

	if (total_moles)
		set_pin_data(IC_OUTPUT, 1, pressure)
	else
		set_pin_data(IC_OUTPUT, 1, 0)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "Pressure scanned.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/temperature_sensor
	name = "temperature sensor"
	desc = "A tiny temperature sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"temperature"       = IC_PINTYPE_NUMBER,
		"valid"             = IC_PINTYPE_BOOLEAN,
		"status"            = IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 200

/obj/item/integrated_circuit/input/temperature_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "No turf.")
		push_data()
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/total_moles = environment.total_moles

	if (total_moles)
		set_pin_data(IC_OUTPUT, 1, round(environment.temperature-T0C,0.1))
	else
		set_pin_data(IC_OUTPUT, 1, -273.15)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "Temperature scanned.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/gas_sensor
	name = "oxygen sensor"
	desc = "A tiny oxygen sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 200

	var/gas_name = GAS_OXYGEN
	var/gas_display_name = GAS_OXYGEN

/obj/item/integrated_circuit/input/gas_sensor/Initialize()
	outputs = list(
		gas_name = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	. = ..()

/obj/item/integrated_circuit/input/gas_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "No turf.")
		push_data()
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/total_moles = environment.total_moles

	if (total_moles)
		var/gas_level = environment.gas[gas_name]/total_moles
		set_pin_data(IC_OUTPUT, 1, round(gas_level*100,0.1))
	else
		set_pin_data(IC_OUTPUT, 1, 0)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "[gas_display_name] scanned.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/gas_sensor/co2
	name = "carbon dioxide sensor"
	displayed_name = "carbon dioxide sensor"
	desc = "A tiny carbon dioxide sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_CO2
	gas_display_name = "carbon dioxide"

/obj/item/integrated_circuit/input/gas_sensor/nitrogen
	name = "nitrogen sensor"
	displayed_name = "nitrogen sensor"
	desc = "A tiny nitrogen sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_NITROGEN
	gas_display_name = "nitrogen"

/obj/item/integrated_circuit/input/gas_sensor/phoron
	name = "phoron sensor"
	displayed_name = "phoron sensor"
	desc = "A tiny phoron sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_PHORON
	gas_display_name = GAS_PHORON

/obj/item/integrated_circuit/input/gas_sensor/hydrogen_level
	name = "hydrogen sensor"
	displayed_name = "hydrogen sensor"
	desc = "A tiny hydrogen sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_HYDROGEN
	gas_display_name = GAS_HYDROGEN

/obj/item/integrated_circuit/input/gas_sensor/deuterium_level
	name = "deuterium sensor"
	displayed_name = "deuterium sensor"
	desc = "A tiny deuterium sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_DEUTERIUM
	gas_display_name = GAS_DEUTERIUM

/obj/item/integrated_circuit/input/gas_sensor/tritium_level
	name = "tritium sensor"
	displayed_name = "tritium sensor"
	desc = "A tiny tritium sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_TRITIUM
	gas_display_name = GAS_TRITIUM

/obj/item/integrated_circuit/input/gas_sensor/helium_level
	name = "helium sensor"
	displayed_name = "helium sensor"
	desc = "A tiny helium sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_HELIUM
	gas_display_name = GAS_HELIUM

/obj/item/integrated_circuit/input/gas_sensor/helium3_level
	name = "helium-3 sensor"
	displayed_name = "helium-3 sensor"
	desc = "A tiny helium-3 sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_HELIUMFUEL
	gas_display_name = GAS_HELIUMFUEL

/obj/item/integrated_circuit/input/gas_sensor/sulfurdioxide_level
	name = "sulphur dioxide sensor"
	displayed_name = "sulphur dioxide sensor"
	desc = "A tiny sulphur dioxide sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_SULFUR
	gas_display_name = GAS_SULFUR

/obj/item/integrated_circuit/input/gas_sensor/nitrogendioxide_level
	name = "nitrogen dioxide sensor"
	displayed_name = "nitrogen dioxide sensor"
	desc = "A tiny nitrogen dioxide sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_NO2
	gas_display_name = GAS_NO2

/obj/item/integrated_circuit/input/gas_sensor/chlorine_level
	name = "chlorine sensor"
	displayed_name = "chlorine sensor"
	desc = "A tiny chlorine sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_CHLORINE
	gas_display_name = GAS_CHLORINE

/obj/item/integrated_circuit/input/gas_sensor/watervapor_level
	name = "water vapour sensor"
	displayed_name = "water vapour sensor"
	desc = "A tiny water vapour sensor module similar to that found in a PDA atmosphere analyser."
	gas_name = GAS_WATERVAPOR
	gas_display_name = GAS_WATERVAPOR

/obj/item/integrated_circuit/input/turfpoint
	name = "tile pointer"
	desc = "This circuit will get a tile ref with the provided absolute coordinates."
	extended_desc = "If the machine	cannot see the target, it will not be able to calculate the correct direction.\
	This circuit only works while inside an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list("X" = IC_PINTYPE_NUMBER,"Y" = IC_PINTYPE_NUMBER)
	outputs = list("tile" = IC_PINTYPE_REF)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT,"not calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 400

/obj/item/integrated_circuit/input/turfpoint/do_work()
	if(!assembly)
		activate_pin(3)
		return
	var/turf/T = get_turf(assembly)
	var/target_x = clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
	var/target_y = clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
	var/turf/A = locate(target_x, target_y, T.z)
	set_pin_data(IC_OUTPUT, 1, null)
	if(!A || !(A in view(T)))
		activate_pin(3)
		return
	else
		set_pin_data(IC_OUTPUT, 1, A)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/turfscan
	name = "tile analyzer"
	desc = "This circuit can analyze the contents of the scanned turf, and can read letters on the turf."
	icon_state = "video_camera"
	complexity = 5
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"located ref" 		= IC_PINTYPE_LIST,
		"Written letters" 	= IC_PINTYPE_STRING,
		"area"				= IC_PINTYPE_STRING,
		"target X"			= IC_PINTYPE_NUMBER,
		"target Y"			= IC_PINTYPE_NUMBER,
		"target Z"			= IC_PINTYPE_NUMBER,
		"content count"		= IC_PINTYPE_NUMBER,
		"valid"				= IC_PINTYPE_BOOLEAN,
		"status"			= IC_PINTYPE_STRING
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 400
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/turfscan/do_work()
	var/turf/scanned_turf = get_pin_data_as_type(IC_INPUT, 1, /turf)
	var/turf/circuit_turf = get_turf(src)
	var/area_name = get_area_name(scanned_turf)
	if(!istype(scanned_turf)) //Invalid input
		set_pin_data(IC_OUTPUT, 8, FALSE)
		set_pin_data(IC_OUTPUT, 9, "Invalid turf.")
		push_data()
		activate_pin(3)
		return

	if(scanned_turf in view(circuit_turf)) // This is a camera. It can't examine things that it can't see.
		var/list/turf_contents = new()
		for(var/obj/U in scanned_turf)
			turf_contents += WEAKREF(U)
		for(var/mob/U in scanned_turf)
			turf_contents += WEAKREF(U)
		set_pin_data(IC_OUTPUT, 1, turf_contents)
		set_pin_data(IC_OUTPUT, 3, area_name)
		set_pin_data(IC_OUTPUT, 4, scanned_turf.x)
		set_pin_data(IC_OUTPUT, 5, scanned_turf.y)
		set_pin_data(IC_OUTPUT, 6, scanned_turf.z)
		set_pin_data(IC_OUTPUT, 7, length(turf_contents))
		set_pin_data(IC_OUTPUT, 8, TRUE)
		set_pin_data(IC_OUTPUT, 9, "Tile scanned.")
		var/list/St = new()
		for(var/obj/effect/decal/cleanable/crayon/I in scanned_turf)
			St.Add(I.icon_state)
		if(St.len)
			set_pin_data(IC_OUTPUT, 2, jointext(St, ",", 1, 0))
		push_data()
		activate_pin(2)
	else
		set_pin_data(IC_OUTPUT, 8, FALSE)
		set_pin_data(IC_OUTPUT, 9, "Target out of scanner view.")
		push_data()
		activate_pin(3)

/obj/item/integrated_circuit/input/advanced_locator_list
	complexity = 6
	name = "list advanced locator"
	desc = "This is needed for certain devices that demand list of names for a target to act upon. This type locates something \
	that is standing in given radius of up to 8 meters. Output is non-associative. Input will only consider keys if associative."
	extended_desc = "The first pin requires a list of the kinds of objects that you want the locator to acquire. It will locate nearby objects by name and description, \
	and will then provide a list of all found objects which are similar. \
	The second pin is a radius."
	inputs = list("desired type ref list" = IC_PINTYPE_LIST, "radius" = IC_PINTYPE_NUMBER)
	outputs = list("located ref" = IC_PINTYPE_LIST, "count" = IC_PINTYPE_NUMBER)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 300
	var/radius = 1
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/advanced_locator_list/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)

	if(isnum(rad))
		rad = clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator_list/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, 0)
	var/list/input_list = list()
	input_list = get_pin_data(IC_INPUT, 1)
	if(length(input_list))	//if there is no input don't do anything.
		var/turf/T = get_turf(src)
		var/list/nearby_things = view(radius,T)
		var/list/valid_things = list()
		for(var/item in input_list)
			if(!isnull(item) && !isnum(item))
				if(istext(item))
					for(var/i in nearby_things)
						var/atom/thing = i
						if(ismob(thing) && !isliving(thing))
							continue
						if(findtext(addtext(thing.name," ",thing.desc), item, 1, 0) )
							valid_things.Add(WEAKREF(thing))
				else
					var/atom/A = item
					var/desired_type = A.type
					for(var/i in nearby_things)
						var/atom/thing = i
						if(thing.type != desired_type)
							continue
						if(ismob(thing) && !isliving(thing))
							continue
						valid_things.Add(WEAKREF(thing))
		if(valid_things.len)
			set_pin_data(IC_OUTPUT, 1, valid_things)
			set_pin_data(IC_OUTPUT, 2, length(valid_things))
			activate_pin(2)
		else
			activate_pin(3)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/input/sensor/ranged
	name = "ranged sensor"
	desc = "Scans and obtains a reference for any objects or persons in range. All you need to do is point the machine towards the target."
	extended_desc = "If the 'ignore storage' pin is set to true, the sensor will disregard scanning various storage containers such as backpacks."
	icon_state = "recorder"
	complexity = 36
	inputs = list("ignore storage" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1200

/obj/item/integrated_circuit/input/sensor/ranged/sense(atom/A, mob/user)
	if(!user || (!istype(A)  && !isliving(A)))
		return FALSE
	if(user.client)
		if(!(A in view(user.client)))
			return FALSE
	else
		if(!(A in view(user)))
			return FALSE
	if(!check_then_do_work())
		return FALSE
	var/ignore_bags = get_pin_data(IC_INPUT, 1)
	if(ignore_bags)
		if(istype(A, /obj/item/storage))
			return FALSE
	set_pin_data(IC_OUTPUT, 1, A)
	push_data()
	user.visible_message(SPAN_NOTICE("[user] points [assembly] at [A]."), SPAN_NOTICE("You scan [A] with [assembly]."))
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/obj_scanner
	name = "scanner"
	desc = "Scans and obtains a reference for any objects you use on the assembly."
	extended_desc = "If the 'put down' pin is set to true, the assembly will take the scanned object from your hands to its location. \
	Useful for interaction with the grabber. The scanner only works using the help intent."
	icon_state = "recorder"
	complexity = 4
	inputs = list("put down" = IC_PINTYPE_BOOLEAN)
	outputs = list("scanned" = IC_PINTYPE_REF)
	activators = list("on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 200

/obj/item/integrated_circuit/input/obj_scanner/attackby_react(var/atom/A,var/mob/user,intent)
	if(intent!=I_HELP)
		return FALSE
	if(!check_then_do_work())
		return FALSE
	var/pu = get_pin_data(IC_INPUT, 1)
	if(pu)
		user.drop_from_inventory(A)
	set_pin_data(IC_OUTPUT, 1, A)
	push_data()
	to_chat(user, SPAN_NOTICE("You let [assembly] scan [A]."))
	activate_pin(1)
	return TRUE

/proc/ic_split_assignment(raw_assignment)
	var/list/result = list(
		"job title" = null,
		"corporation" = null
	)

	if(!istext(raw_assignment) || !length(raw_assignment))
		return result

	var/assignment = trim(raw_assignment)
	var/open_paren = findtext(assignment, "(")
	var/close_paren = findtext(assignment, ")", open_paren + 1)

	if(open_paren && close_paren && close_paren > open_paren)
		result["job title"] = trim(copytext(assignment, 1, open_paren))
		result["corporation"] = trim(copytext(assignment, open_paren + 1, close_paren))
	else
		result["job title"] = assignment

	return result


/obj/item/integrated_circuit/input/card_reader
	name = "ID card reader" // To differentiate it from the data card reader.
	desc = "A circuit that can read the registered name, assignment, job title, corporation, and PassKey string from an ID card."
	icon_state = "card_reader"

	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"enable credential cache" = IC_PINTYPE_BOOLEAN
	)

	outputs = list(
		"registered name" = IC_PINTYPE_STRING,
		"assignment" = IC_PINTYPE_STRING,
		"job title" = IC_PINTYPE_STRING,
		"corporation" = IC_PINTYPE_STRING,
		"passkey" = IC_PINTYPE_LIST
	)

	activators = list(
		"on read" = IC_PINTYPE_PULSE_OUT
	)


/obj/item/integrated_circuit/input/card_reader/attackby_react(obj/item/I, mob/living/user, intent)
	var/obj/item/card/id/card = I.GetID()
	var/list/access = I.GetAccess()

	if(!access)
		return

	if(get_pin_data(IC_INPUT, 1))
		assembly?.access_card.access |= access

	if(card) // An ID card.
		var/list/split_assignment = ic_split_assignment(card.assignment)

		set_pin_data(IC_OUTPUT, 1, card.registered_name)
		set_pin_data(IC_OUTPUT, 2, card.assignment)
		set_pin_data(IC_OUTPUT, 3, split_assignment["job title"])
		set_pin_data(IC_OUTPUT, 4, split_assignment["corporation"])

	else if(length(access)) // A non-card object that has access levels.
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		set_pin_data(IC_OUTPUT, 4, null)

	else
		return FALSE

	set_pin_data(IC_OUTPUT, 5, access)

	push_data()
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/radiation_sensor
	name = "radiation sensor"
	desc = "A tiny radiation sensor module similar to that found in a geiger counter."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"radiation" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 200

/obj/item/integrated_circuit/input/radiation_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "No turf.")
		push_data()
		return

	var/radiation_count = SSradiation.get_rads_at_turf(get_turf(src))

	if(radiation_count)
		set_pin_data(IC_OUTPUT, 1, round(radiation_count,0.1))
	else
		set_pin_data(IC_OUTPUT, 1, 0)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "Radiation scanned.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/light_sensor
	name = "light sensor"
	desc = "A tiny light sensor module."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"lumens" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 200

/obj/item/integrated_circuit/input/light_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "No turf.")
		push_data()
		return

	var/lumens = T.get_lumcount(0, 3) * 5
	if(lumens)
		set_pin_data(IC_OUTPUT, 1, round(lumens,0.1))
	else
		set_pin_data(IC_OUTPUT, 1, 0)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "Light scanned.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/face_scanner
	name = "face scanner"
	desc = "A complex camera and in-built scanner, similar to an examiner but specifically for people.\
	It can identify species type, height and eye colour, and it can estimate age (to the half-decade).\
	It also provides a short description of the person and their face (if able)."
	icon_state = "video_camera"
	complexity = 12
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list(
		"name" = IC_PINTYPE_STRING,
		"description (general)" = IC_PINTYPE_STRING,
		"description (face)" = IC_PINTYPE_STRING,
		"species" = IC_PINTYPE_STRING,
		"height" = IC_PINTYPE_NUMBER,
		"estimated age" = IC_PINTYPE_NUMBER,
		"eye colour" = IC_PINTYPE_COLOR
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT, "not scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 5)
	power_draw_per_use = 1000

/obj/item/integrated_circuit/input/face_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return

	if(H in view(get_turf(src))) // This is a camera. It can't examine things that it can't see.
		set_pin_data(IC_OUTPUT, 1, H.name)
		set_pin_data(IC_OUTPUT, 2, H.flavor_texts["general"])
		set_pin_data(IC_OUTPUT, 3, H.flavor_texts["face"])
		set_pin_data(IC_OUTPUT, 4, H.species.name)
		set_pin_data(IC_OUTPUT, 5, H.height)
		set_pin_data(IC_OUTPUT, 6, round(H.age, 5))
		set_pin_data(IC_OUTPUT, 7, rgb(H.r_eyes, H.g_eyes, H.b_eyes))
		push_data()
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/input/anomaly_scanner
	name = "alden-saraspova counter"
	desc = "A miniaturized Alden-Saraspova counter, used to detected anomalous readings. Often used by xenoarchaeologists."
	extended_desc = "It can only scan a 14x14 area and has a built-in 15 second cooldown."
	icon_state = "medscan_adv"
	complexity = 12
	outputs = list(
		"exotic particle type" = IC_PINTYPE_STRING,
		"range detected at" = IC_PINTYPE_NUMBER,
		"target turf" = IC_PINTYPE_REF,
		"target X" = IC_PINTYPE_NUMBER,
		"target Y" = IC_PINTYPE_NUMBER,
		"target Z" = IC_PINTYPE_NUMBER,
		"direction" = IC_PINTYPE_DIR,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "anomaly found" = IC_PINTYPE_PULSE_OUT, "nothing found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_MAGNET = 6, TECH_BLUESPACE = 4)
	power_draw_per_use = 2000
	cooldown_per_use = 15 SECONDS // sizeable cooldown to prevent view spam

/obj/item/integrated_circuit/input/anomaly_scanner/do_work()
	if(!SSxenoarch)
		set_pin_data(IC_OUTPUT, 8, FALSE)
		set_pin_data(IC_OUTPUT, 9, "Xenoarchaeology subsystem unavailable.")
		push_data()
		activate_pin(3)
		return

	var/turf/our_turf = get_turf(src)
	var/found_anomaly = FALSE
	for(var/turf/simulated/mineral/scanned_turf in view(our_turf)) // Restrict range to only visible tiles, instead of the entire Z-level like standalone AS counters
		if(scanned_turf.artifact_find)
			found_anomaly = TRUE
			if(scanned_turf.artifact_find.artifact_id)
				set_pin_data(IC_OUTPUT, 1, scanned_turf.artifact_find.artifact_id)
			else
				set_pin_data(IC_OUTPUT, 1, "Exotic Particles (Various)")
			set_pin_data(IC_OUTPUT, 2, get_dist(our_turf, scanned_turf))
			set_pin_data(IC_OUTPUT, 3, scanned_turf)
			set_pin_data(IC_OUTPUT, 4, scanned_turf.x)
			set_pin_data(IC_OUTPUT, 5, scanned_turf.y)
			set_pin_data(IC_OUTPUT, 6, scanned_turf.z)
			set_pin_data(IC_OUTPUT, 7, get_dir(our_turf, scanned_turf))
			set_pin_data(IC_OUTPUT, 8, TRUE)
			set_pin_data(IC_OUTPUT, 9, "Anomaly found.")
			push_data()
			activate_pin(2)
			break
	if(!found_anomaly)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, null)
		set_pin_data(IC_OUTPUT, 4, null)
		set_pin_data(IC_OUTPUT, 5, null)
		set_pin_data(IC_OUTPUT, 6, null)
		set_pin_data(IC_OUTPUT, 7, null)
		set_pin_data(IC_OUTPUT, 8, FALSE)
		set_pin_data(IC_OUTPUT, 9, "No anomaly found.")
		push_data()
		activate_pin(3)
	..()

/obj/item/integrated_circuit/input/depth_scanner
	name = "depth scanner"
	desc = "A miniaturized depth analysis scanner, used to read xenoarchaeological depth and clearance data from scanned mineral turfs."
	extended_desc = "Feed it a scanned turf reference. If the turf contains a find, it outputs required depth, clearance, current depth, safe depth, material, and coordinates."
	icon_state = "medscan_adv"
	complexity = 12
	inputs = list(
		"target turf" = IC_PINTYPE_REF
	)
	outputs = list(
		"target turf" = IC_PINTYPE_REF,
		"required depth" = IC_PINTYPE_NUMBER,
		"clearance" = IC_PINTYPE_NUMBER,
		"current depth" = IC_PINTYPE_NUMBER,
		"safe depth" = IC_PINTYPE_NUMBER,
		"material" = IC_PINTYPE_STRING,
		"coordinates" = IC_PINTYPE_STRING,
		"status" = IC_PINTYPE_STRING,
		"target X" = IC_PINTYPE_NUMBER,
		"target Y" = IC_PINTYPE_NUMBER,
		"target Z" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"find detected" = IC_PINTYPE_PULSE_OUT,
		"nothing detected" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4, TECH_MAGNET = 4)
	power_draw_per_use = 1000
	cooldown_per_use = 5 SECONDS

/obj/item/integrated_circuit/input/depth_scanner/do_work()
	var/turf/simulated/mineral/scanned_turf = get_pin_data_as_type(IC_INPUT, 1, /turf/simulated/mineral)

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, null)
	set_pin_data(IC_OUTPUT, 5, null)
	set_pin_data(IC_OUTPUT, 6, null)
	set_pin_data(IC_OUTPUT, 7, null)
	set_pin_data(IC_OUTPUT, 8, "No valid mineral turf scanned.")
	set_pin_data(IC_OUTPUT, 9, null)
	set_pin_data(IC_OUTPUT, 10, null)
	set_pin_data(IC_OUTPUT, 11, null)
	set_pin_data(IC_OUTPUT, 12, FALSE)

	if(!istype(scanned_turf))
		push_data()
		activate_pin(3)
		return

	var/turf/circuit_turf = get_turf(src)
	if(!(scanned_turf in view(circuit_turf)))
		set_pin_data(IC_OUTPUT, 8, "Target turf is out of scanner range.")
		push_data()
		activate_pin(3)
		return

	if(!(scanned_turf.finds && scanned_turf.finds.len) && !scanned_turf.artifact_find)
		set_pin_data(IC_OUTPUT, 1, scanned_turf)
		set_pin_data(IC_OUTPUT, 7, "[scanned_turf.x], [scanned_turf.y], [scanned_turf.z]")
		set_pin_data(IC_OUTPUT, 8, "No subsurface find detected.")
		set_pin_data(IC_OUTPUT, 9, scanned_turf.x)
		set_pin_data(IC_OUTPUT, 10, scanned_turf.y)
		set_pin_data(IC_OUTPUT, 11, scanned_turf.z)
		set_pin_data(IC_OUTPUT, 12, TRUE)
		push_data()
		activate_pin(3)
		return

	var/required_depth = 0
	var/clearance = 0
	var/current_depth = scanned_turf.excavation_level * 2
	var/material = scanned_turf.mineral ? scanned_turf.mineral.display_name : "Rock"

	if(scanned_turf.finds && scanned_turf.finds.len)
		var/datum/find/F = scanned_turf.finds[1]
		required_depth = F.excavation_required * 2
		clearance = F.clearance_range * 2
		material = get_responsive_reagent(F.find_type)
	else if(scanned_turf.artifact_find)
		required_depth = rand(75, 100)
		clearance = rand(5, 25)
		material = "Unknown anomaly"

	var/safe_depth = max(required_depth - clearance, 0)

	set_pin_data(IC_OUTPUT, 1, scanned_turf)
	set_pin_data(IC_OUTPUT, 2, required_depth)
	set_pin_data(IC_OUTPUT, 3, clearance)
	set_pin_data(IC_OUTPUT, 4, current_depth)
	set_pin_data(IC_OUTPUT, 5, safe_depth)
	set_pin_data(IC_OUTPUT, 6, material)
	set_pin_data(IC_OUTPUT, 7, "[scanned_turf.x], [scanned_turf.y], [scanned_turf.z]")
	set_pin_data(IC_OUTPUT, 8, "Find detected.")
	set_pin_data(IC_OUTPUT, 9, scanned_turf.x)
	set_pin_data(IC_OUTPUT, 10, scanned_turf.y)
	set_pin_data(IC_OUTPUT, 11, scanned_turf.z)
	set_pin_data(IC_OUTPUT, 12, TRUE)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/ref_validator
	name = "reference validator"
	desc = "Checks whether a reference is valid and identifies its general type."
	icon_state = "video_camera"
	complexity = 4
	inputs = list(
		"reference" = IC_PINTYPE_REF
	)
	outputs = list(
		"valid" = IC_PINTYPE_BOOLEAN,
		"name" = IC_PINTYPE_STRING,
		"type path" = IC_PINTYPE_STRING,
		"is mob" = IC_PINTYPE_BOOLEAN,
		"is item" = IC_PINTYPE_BOOLEAN,
		"is machinery" = IC_PINTYPE_BOOLEAN,
		"is turf" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"validate" = IC_PINTYPE_PULSE_IN,
		"valid" = IC_PINTYPE_PULSE_OUT,
		"invalid" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/ref_validator/do_work()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)

	set_pin_data(IC_OUTPUT, 1, FALSE)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, FALSE)
	set_pin_data(IC_OUTPUT, 5, FALSE)
	set_pin_data(IC_OUTPUT, 6, FALSE)
	set_pin_data(IC_OUTPUT, 7, FALSE)

	if(!A)
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, TRUE)
	set_pin_data(IC_OUTPUT, 2, A.name)
	set_pin_data(IC_OUTPUT, 3, "[A.type]")
	set_pin_data(IC_OUTPUT, 4, ismob(A))
	set_pin_data(IC_OUTPUT, 5, isitem(A))
	set_pin_data(IC_OUTPUT, 6, istype(A, /obj/structure/machinery))
	set_pin_data(IC_OUTPUT, 7, isturf(A))

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/distance_checker
	name = "distance checker"
	desc = "Checks distance and adjacency between two references. If reference B is empty, it checks the tile in front of reference A."
	extended_desc = "Compares reference A against reference B and outputs the distance, whether they are adjacent, whether they are on the same tile, and whether they are on the same z-level. If reference B is empty, the circuit uses the turf directly in front of reference A instead. This is useful for checking whether an assembly is facing a nearby object, wall, turf, or target location without needing a second reference input."
	icon_state = "video_camera"
	complexity = 4
	inputs = list(
		"reference A" = IC_PINTYPE_REF,
		"reference B" = IC_PINTYPE_REF
	)
	outputs = list(
		"distance" = IC_PINTYPE_NUMBER,
		"adjacent" = IC_PINTYPE_BOOLEAN,
		"same tile" = IC_PINTYPE_BOOLEAN,
		"same z-level" = IC_PINTYPE_BOOLEAN,
		"delta X" = IC_PINTYPE_NUMBER,
		"delta Y" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list(
		"check" = IC_PINTYPE_PULSE_IN,
		"checked" = IC_PINTYPE_PULSE_OUT,
		"not checked" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/distance_checker/do_work()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/atom/B = get_pin_data_as_type(IC_INPUT, 2, /atom)

	if(!A)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, FALSE)
		set_pin_data(IC_OUTPUT, 4, FALSE)
		set_pin_data(IC_OUTPUT, 7, FALSE)
		set_pin_data(IC_OUTPUT, 8, "Invalid reference A.")
		push_data()
		activate_pin(3)
		return

	var/turf/TA = get_turf(A)
	var/turf/TB = null
	if(TA)
		TB = B ? get_turf(B) : get_step(TA, A.dir)

	if(!TA || !TB)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, FALSE)
		set_pin_data(IC_OUTPUT, 4, FALSE)
		set_pin_data(IC_OUTPUT, 7, FALSE)
		set_pin_data(IC_OUTPUT, 8, "Reference has no turf.")
		push_data()
		activate_pin(3)
		return

	var/same_z = TA.z == TB.z
	var/distance = same_z ? get_dist(TA, TB) : null

	set_pin_data(IC_OUTPUT, 1, distance)
	set_pin_data(IC_OUTPUT, 2, same_z && distance <= 1)
	set_pin_data(IC_OUTPUT, 3, TA == TB)
	set_pin_data(IC_OUTPUT, 4, same_z)
	set_pin_data(IC_OUTPUT, 5, TB.x - TA.x)
	set_pin_data(IC_OUTPUT, 6, TB.y - TA.y)
	set_pin_data(IC_OUTPUT, 7, TRUE)
	set_pin_data(IC_OUTPUT, 8, "Distance checked.")

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/direction_to_ref
	name = "direction to reference"
	desc = "Calculates the direction from one reference to another."
	icon_state = "video_camera"
	complexity = 4
	inputs = list(
		"source" = IC_PINTYPE_REF,
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"direction" = IC_PINTYPE_NUMBER,
		"direction text" = IC_PINTYPE_STRING,
		"delta X" = IC_PINTYPE_NUMBER,
		"delta Y" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list(
		"calculate" = IC_PINTYPE_PULSE_IN,
		"calculated" = IC_PINTYPE_PULSE_OUT,
		"not calculated" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/direction_to_ref/do_work()
	var/atom/source = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/atom/target = get_pin_data_as_type(IC_INPUT, 2, /atom)

	if(!source || !target)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 5, FALSE)
		set_pin_data(IC_OUTPUT, 6, "Invalid source or target.")
		push_data()
		activate_pin(3)
		return

	var/direction = get_dir(source, target)
	var/turf/source_turf = get_turf(source)
	var/turf/target_turf = get_turf(target)
	if(!source_turf || !target_turf)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 5, FALSE)
		set_pin_data(IC_OUTPUT, 6, "Source or target has no turf.")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, direction)
	set_pin_data(IC_OUTPUT, 2, dir2text(direction))
	set_pin_data(IC_OUTPUT, 3, target_turf.x - source_turf.x)
	set_pin_data(IC_OUTPUT, 4, target_turf.y - source_turf.y)
	set_pin_data(IC_OUTPUT, 5, TRUE)
	set_pin_data(IC_OUTPUT, 6, "Direction calculated.")

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/area_scanner
	name = "area scanner"
	desc = "Returns the area of a referenced object."
	icon_state = "video_camera"
	complexity = 3
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"area name" = IC_PINTYPE_STRING,
		"area ref" = IC_PINTYPE_REF
	)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/area_scanner/do_work()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)

	if(!A)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		push_data()
		activate_pin(3)
		return

	var/area/AR = get_area(A)

	if(!AR)
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, AR.name)
	set_pin_data(IC_OUTPUT, 2, AR)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/input/access_checker
	name = "access checker"
	desc = "Checks whether an access list contains required access."
	icon_state = "card_reader"
	complexity = 4
	inputs = list(
		"access list" = IC_PINTYPE_LIST,
		"required access" = IC_PINTYPE_LIST
	)
	outputs = list(
		"allowed" = IC_PINTYPE_BOOLEAN,
		"missing access" = IC_PINTYPE_LIST
	)
	activators = list(
		"check" = IC_PINTYPE_PULSE_IN,
		"allowed" = IC_PINTYPE_PULSE_OUT,
		"denied" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/input/access_checker/do_work()
	var/list/access_list = get_pin_data(IC_INPUT, 1)
	var/list/required_access = get_pin_data(IC_INPUT, 2)
	var/list/missing_access = list()

	if(!islist(access_list))
		access_list = list()

	if(!islist(required_access))
		required_access = list()

	for(var/access in required_access)
		if(!(access in access_list))
			missing_access += access

	var/allowed = !length(missing_access)

	set_pin_data(IC_OUTPUT, 1, allowed)
	set_pin_data(IC_OUTPUT, 2, missing_access)

	push_data()
	activate_pin(allowed ? 2 : 3)


/obj/item/integrated_circuit/input/radio_command_receiver
	name = "radio command receiver"
	desc = "Receives radio-style command text relayed through an inserted radio."
	extended_desc = "This circuit receives relayed radio text and exposes the speaker, message, channel, command, arguments, and payload. If a radio reference is provided, only messages relayed from that radio will be accepted."
	icon_state = "recorder"
	complexity = 10
	inputs = list(
		"radio reference" = IC_PINTYPE_REF
	)
	outputs = list(
		"speaker" = IC_PINTYPE_STRING,
		"message" = IC_PINTYPE_STRING,
		"channel" = IC_PINTYPE_STRING,
		"command" = IC_PINTYPE_STRING,
		"argument 1" = IC_PINTYPE_STRING,
		"argument 2" = IC_PINTYPE_STRING,
		"argument list" = IC_PINTYPE_LIST,
		"payload" = IC_PINTYPE_STRING
	)
	activators = list(
		"on command received" = IC_PINTYPE_PULSE_OUT
	)
	power_draw_per_use = 150
	spawn_flags = null


/obj/item/integrated_circuit/input/radio_command_receiver/proc/receive_radio_command(speaker_name, message, channel, obj/item/radio/source_radio = null)
	if(!check_then_do_work())
		return

	var/obj/item/radio/required_radio = get_pin_data_as_type(IC_INPUT, 1, /obj/item/radio)

	if(required_radio && !source_radio)
		return

	if(required_radio && source_radio != required_radio)
		return

	if(!istext(message) || !length(message))
		return

	var/list/parts = splittext(message, " ")
	var/list/clean_parts = list()

	for(var/part in parts)
		if(istext(part) && length(part))
			clean_parts += part

	if(!length(clean_parts))
		return

	var/list/arguments = list()
	for(var/i = 2 to length(clean_parts))
		arguments += clean_parts[i]

	var/list/payload_parts = list()
	for(var/i = 2 to length(clean_parts))
		payload_parts += clean_parts[i]

	var/payload = jointext(payload_parts, " ")

	set_pin_data(IC_OUTPUT, 1, speaker_name ? "[speaker_name]" : "Unknown")
	set_pin_data(IC_OUTPUT, 2, message)
	set_pin_data(IC_OUTPUT, 3, channel ? "[channel]" : null)
	set_pin_data(IC_OUTPUT, 4, lowertext(clean_parts[1]))
	set_pin_data(IC_OUTPUT, 5, length(clean_parts) >= 2 ? clean_parts[2] : null)
	set_pin_data(IC_OUTPUT, 6, length(clean_parts) >= 3 ? clean_parts[3] : null)
	set_pin_data(IC_OUTPUT, 7, arguments)
	set_pin_data(IC_OUTPUT, 8, payload)

	push_data()
	activate_pin(1)
