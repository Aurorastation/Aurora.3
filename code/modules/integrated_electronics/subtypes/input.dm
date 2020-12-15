/obj/item/integrated_circuit/input
	var/can_be_asked_input = 0
	category_text = "Input"
	power_draw_per_use = 5

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
	to_chat(user, "<span class='notice'>You press the button labeled '[src.name]'.</span>")
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
	to_chat(user, "<span class='notice'>You toggle the button labeled '[src.name]' [get_pin_data(IC_OUTPUT, 1) ? "on" : "off"].</span>")

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
	power_draw_per_use = 4

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
	power_draw_per_use = 4

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
	power_draw_per_use = 4

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
		"total health %" = IC_PINTYPE_NUMBER,
		"total missing health" = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return
	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		var/total_health = round(H.health/H.getMaxHealth(), 0.01)*100
		var/missing_health = H.getMaxHealth() - H.health

		set_pin_data(IC_OUTPUT, 1, total_health)
		set_pin_data(IC_OUTPUT, 2, missing_health)

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
		"total health %"       = IC_PINTYPE_NUMBER,
		"total missing health" = IC_PINTYPE_NUMBER,
		"brute damage"         = IC_PINTYPE_NUMBER,
		"burn damage"          = IC_PINTYPE_NUMBER,
		"tox damage"           = IC_PINTYPE_NUMBER,
		"oxy damage"           = IC_PINTYPE_NUMBER,
		"clone damage"         = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 4)
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/adv_med_scanner/do_work()
	var/mob/living/carbon/human/H = get_pin_data_as_type(IC_INPUT, 1, /mob/living/carbon/human)
	if(!istype(H)) //Invalid input
		return
	if(H.Adjacent(get_turf(src))) // Like normal analysers, it can't be used at range.
		var/total_health = round(H.health/H.getMaxHealth(), 0.01)*100
		var/missing_health = H.getMaxHealth() - H.health

		set_pin_data(IC_OUTPUT, 1, total_health)
		set_pin_data(IC_OUTPUT, 2, missing_health)
		set_pin_data(IC_OUTPUT, 3, H.getBruteLoss())
		set_pin_data(IC_OUTPUT, 4, H.getFireLoss())
		set_pin_data(IC_OUTPUT, 5, H.getToxLoss())
		set_pin_data(IC_OUTPUT, 6, H.getOxyLoss())
		set_pin_data(IC_OUTPUT, 7, H.getCloneLoss())

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
		"occupied turf"			= IC_PINTYPE_REF
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT, "not scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 4)
	power_draw_per_use = 80

/obj/item/integrated_circuit/input/examiner/do_work()
	var/atom/H = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/turf/T = get_turf(src)
	if(!istype(H)) //Invalid input
		return

	if(H in view(T)) // This is a camera. It can't examine thngs,that it can't see.


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
		push_data()
		activate_pin(2)
	else
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
	power_draw_per_use = 20

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
	power_draw_per_use = 30

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
	power_draw_per_use = 30
	var/radius = 1

/obj/item/integrated_circuit/input/advanced_locator/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)
	if(isnum(rad))
		rad = Clamp(rad, 0, 7)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
	var/turf/T = get_turf(src)
	var/list/nearby_things = view(radius, T)
	var/list/valid_things = list()
	var/I = get_pin_data(IC_INPUT, 1)
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
	power_draw_idle = 5
	power_draw_per_use = 40

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

	for(var/mob/O in hearers(1, get_turf(src)))
		O.show_message(text("[icon2html(src, viewers(get_turf(src)))] *beep* *beep*"), 3, "*beep* *beep*", 2)

//This circuit gives information on where the machine is.
/obj/item/integrated_circuit/input/gps
	name = "global positioning system"
	desc = "This allows you to easily know the position of a machine containing this device."
	extended_desc = "The GPS's coordinates it gives is absolute, not relative."
	icon_state = "gps"
	complexity = 4
	inputs = list()
	outputs = list(
		"X"= IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER,
		"Z" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"get coordinates" = IC_PINTYPE_PULSE_IN,
		"on get coordinates" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/input/gps/do_work()
	var/turf/T = get_turf(src)

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	if(!T)
		return

	set_pin_data(IC_OUTPUT, 1, T.x)
	set_pin_data(IC_OUTPUT, 2, T.y)
	set_pin_data(IC_OUTPUT, 3, T.z)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people or for voice activated machines."
	extended_desc = "This will automatically translate most languages it hears to Tau Ceti Basic.  \
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
	power_draw_per_use = 15

/obj/item/integrated_circuit/input/microphone/Initialize()
	. = ..()
	listening_objects |= src

/obj/item/integrated_circuit/input/microphone/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(mob/living/M, msg, var/verb="says", datum/language/speaking=null)
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
	power_draw_per_use = 120

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
		"pressure"       = IC_PINTYPE_NUMBER,
		"temperature"    = IC_PINTYPE_NUMBER,
		GAS_OXYGEN         = IC_PINTYPE_NUMBER,
		GAS_NITROGEN       = IC_PINTYPE_NUMBER,
		GAS_CO2 		   = IC_PINTYPE_NUMBER,
		GAS_PHORON         = IC_PINTYPE_NUMBER,
		GAS_HYDROGEN	   = IC_PINTYPE_NUMBER,
		"other"          = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 60

/obj/item/integrated_circuit/input/internalbm
	name = "internal battery monitor"
	desc = "This monitors the charge level of an internal battery."
	icon_state = "internalbm"
	extended_desc = "This circuit will give you values of charge, max charge and percentage of the internal battery on demand."
	w_class = ITEMSIZE_TINY
	complexity = 1
	inputs = list()
	outputs = list(
		"cell charge" = IC_PINTYPE_NUMBER,
		"max charge" = IC_PINTYPE_NUMBER,
		"percentage" = IC_PINTYPE_NUMBER,
		"refference to assembly" = IC_PINTYPE_REF
		)
	activators = list("read" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_POWER = 4, TECH_MAGNET = 3)
	power_draw_per_use = 1

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

/obj/item/integrated_circuit/input/externalbm
	name = "external battery monitor"
	desc = "This can help watch the battery level of any device in range."
	icon_state = "externalbm"
	extended_desc = "This circuit will give you values of charge, max charge and percentage of any device or battery in view"
	w_class = ITEMSIZE_TINY
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
	power_draw_per_use = 1

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
				push_data()
				set_pin_data(IC_OUTPUT, 1, cell.charge)
				set_pin_data(IC_OUTPUT, 2, cell.maxcharge)
				set_pin_data(IC_OUTPUT, 3, cell.percent())
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/atmo_scanner/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	if (total_moles)
		var/o2_level = environment.gas[GAS_OXYGEN]/total_moles
		var/n2_level = environment.gas[GAS_NITROGEN]/total_moles
		var/co2_level = environment.gas[GAS_CO2]/total_moles
		var/phoron_level = environment.gas[GAS_PHORON]/total_moles
		var/hydrogen_level = environment.gas[GAS_HYDROGEN]/total_moles
		var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)
		set_pin_data(IC_OUTPUT, 1, pressure)
		set_pin_data(IC_OUTPUT, 2, round(environment.temperature-T0C,0.1))
		set_pin_data(IC_OUTPUT, 3, round(o2_level*100,0.1))
		set_pin_data(IC_OUTPUT, 4, round(n2_level*100,0.1))
		set_pin_data(IC_OUTPUT, 5, round(co2_level*100,0.1))
		set_pin_data(IC_OUTPUT, 6, round(phoron_level*100,0.01))
		set_pin_data(IC_OUTPUT, 7, round(hydrogen_level*100,0.01))
		set_pin_data(IC_OUTPUT, 8, round(unknown_level, 0.01))
	else
		set_pin_data(IC_OUTPUT, 1, 0)
		set_pin_data(IC_OUTPUT, 2, -273.15)
		set_pin_data(IC_OUTPUT, 3, 0)
		set_pin_data(IC_OUTPUT, 4, 0)
		set_pin_data(IC_OUTPUT, 5, 0)
		set_pin_data(IC_OUTPUT, 6, 0)
		set_pin_data(IC_OUTPUT, 7, 0)
		set_pin_data(IC_OUTPUT, 8, 0)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/pressure_sensor
	name = "pressure sensor"
	desc = "A tiny pressure sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"pressure"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/pressure_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	if (total_moles)
		set_pin_data(IC_OUTPUT, 1, pressure)
	else
		set_pin_data(IC_OUTPUT, 1, 0)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/temperature_sensor
	name = "temperature sensor"
	desc = "A tiny temperature sensor module similar to that found in a PDA atmosphere analyser."
	icon_state = "medscan_adv"
	complexity = 3
	inputs = list()
	outputs = list(
		"temperature"       = IC_PINTYPE_NUMBER
	)
	activators = list("scan" = IC_PINTYPE_PULSE_IN, "on scanned" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 20

/obj/item/integrated_circuit/input/temperature_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/total_moles = environment.total_moles

	if (total_moles)
		set_pin_data(IC_OUTPUT, 1, round(environment.temperature-T0C,0.1))
	else
		set_pin_data(IC_OUTPUT, 1, -273.15)
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
	power_draw_per_use = 20

	var/gas_name = GAS_OXYGEN
	var/gas_display_name = GAS_OXYGEN

/obj/item/integrated_circuit/input/gas_sensor/Initialize()
	name = "[gas_display_name] sensor"
	displayed_name = "[gas_display_name] sensor"
	desc = "A tiny [gas_display_name] sensor module similar to that found in a PDA atmosphere analyser."
	outputs = list(
		gas_name = IC_PINTYPE_NUMBER
	)
	. = ..()

/obj/item/integrated_circuit/input/gas_sensor/do_work()
	var/turf/T = get_turf(src)
	if(!istype(T)) //Invalid input
		return
	var/datum/gas_mixture/environment = T.return_air()

	var/total_moles = environment.total_moles

	if (total_moles)
		var/gas_level = environment.gas[gas_name]/total_moles
		set_pin_data(IC_OUTPUT, 1, round(gas_level*100,0.1))
	else
		set_pin_data(IC_OUTPUT, 1, 0)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/input/gas_sensor/co2
	gas_name = GAS_CO2
	gas_display_name = "carbon dioxide"

/obj/item/integrated_circuit/input/gas_sensor/nitrogen
	gas_name = GAS_NITROGEN
	gas_display_name = "nitrogen"

/obj/item/integrated_circuit/input/gas_sensor/phoron
	gas_name = GAS_PHORON
	gas_display_name = GAS_PHORON

/obj/item/integrated_circuit/input/gas_sensor/hydrogen_level
	gas_name = GAS_HYDROGEN
	gas_display_name = GAS_HYDROGEN

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
	power_draw_per_use = 40

/obj/item/integrated_circuit/input/turfpoint/do_work()
	if(!assembly)
		activate_pin(3)
		return
	var/turf/T = get_turf(assembly)
	var/target_x = Clamp(get_pin_data(IC_INPUT, 1), 0, world.maxx)
	var/target_y = Clamp(get_pin_data(IC_INPUT, 2), 0, world.maxy)
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
		"area"				= IC_PINTYPE_STRING
		)
	activators = list(
		"scan" = IC_PINTYPE_PULSE_IN,
		"on scanned" = IC_PINTYPE_PULSE_OUT,
		"not scanned" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/turfscan/do_work()
	var/turf/scanned_turf = get_pin_data_as_type(IC_INPUT, 1, /turf)
	var/turf/circuit_turf = get_turf(src)
	var/area_name = get_area_name(scanned_turf)
	if(!istype(scanned_turf)) //Invalid input
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
		var/list/St = new()
		for(var/obj/effect/decal/cleanable/crayon/I in scanned_turf)
			St.Add(I.icon_state)
		if(St.len)
			set_pin_data(IC_OUTPUT, 2, jointext(St, ",", 1, 0))
		push_data()
		activate_pin(2)
	else
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
	outputs = list("located ref" = IC_PINTYPE_LIST)
	activators = list("locate" = IC_PINTYPE_PULSE_IN,"found" = IC_PINTYPE_PULSE_OUT,"not found" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30
	var/radius = 1
	cooldown_per_use = 10

/obj/item/integrated_circuit/input/advanced_locator_list/on_data_written()
	var/rad = get_pin_data(IC_INPUT, 2)

	if(isnum(rad))
		rad = Clamp(rad, 0, 8)
		radius = rad

/obj/item/integrated_circuit/input/advanced_locator_list/do_work()
	set_pin_data(IC_OUTPUT, 1, null)
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
	power_draw_per_use = 120

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
	power_draw_per_use = 20

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
	to_chat(user, "<span class='notice'>You let [assembly] scan [A].</span>")
	activate_pin(1)
	return TRUE

/obj/item/integrated_circuit/input/card_reader
	name = "ID card reader" //To differentiate it from the data card reader
	desc = "A circuit that can read the registred name, assignment, and PassKey string from an ID card."
	icon_state = "card_reader"

	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"enable credential cache" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"registered name" = IC_PINTYPE_STRING,
		"assignment" = IC_PINTYPE_STRING,
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
		set_pin_data(IC_OUTPUT, 1, card.registered_name)
		set_pin_data(IC_OUTPUT, 2, card.assignment)

	else if(length(access))	// A non-card object that has access levels.
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)

	else
		return FALSE

	set_pin_data(IC_OUTPUT, 3, access)

	push_data()
	activate_pin(1)
	return TRUE
