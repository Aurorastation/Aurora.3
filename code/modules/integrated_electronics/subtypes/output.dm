/*
 * subtypes/output.dm
 * Output circuits that speak, display, signal, pulse, transmit, or otherwise emit circuit results into the game world.
 */

/// output: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output
	category_text = "Output"

/// small screen: Displays one value when the assembly is examined closely.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/screen
	name = "small screen"
	desc = "Displays one value when the assembly is examined closely."
	icon_state = "screen"
	inputs = list("displayed data" = IC_PINTYPE_ANY)
	outputs = list()
	activators = list("load data" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 100
	// Stores `stuff_to_display` state used by this integrated electronics object.
	var/stuff_to_display = null

/// Implements `disconnect_all` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/screen/disconnect_all()
	..()
	stuff_to_display = null

/// Implements `any_examine` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/screen/any_examine(mob/user)
	. = ..()
	if (displayed_name)
		. += "There is a little screen labeled '[displayed_name]', which displays [!isnull(stuff_to_display) ? "'[stuff_to_display]'" : "nothing"]."
	else
		. += "There is an unlabelled little screen, which displays [!isnull(stuff_to_display) ? "'[stuff_to_display]'" : "nothing"]."

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/screen/do_work()
	// Stores `I` state used by this integrated electronics object.
	var/datum/integrated_io/I = inputs[1]
	if(isweakref(I.data))
		var/datum/d = I.data_as_type(/datum)
		if(d)
			stuff_to_display = "[d]"
	else
		stuff_to_display = I.data

/// screen: Displays data to the person holding the device.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/screen/medium
	name = "screen"
	desc = "Displays data to the person holding the device."
	icon_state = "screen_medium"
	power_draw_per_use = 200

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/screen/medium/do_work()
	..()
	var/list/nearby_things = range(0, get_turf(src))
	for(var/mob/M in nearby_things)
		var/obj/O = assembly ? assembly : src
		to_chat(M, SPAN_NOTICE("[icon2html(O, viewers(get_turf(src)))] [stuff_to_display]"))

/// large screen: Displays data to nearby viewers who can see the device.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/screen/large
	name = "large screen"
	desc = "Displays data to nearby viewers who can see the device."
	icon_state = "screen_large"
	power_draw_per_use = 400

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/screen/large/do_work()
	..()
	var/obj/O = assembly ? loc : assembly
	O.visible_message(SPAN_NOTICE("[icon2html(O, viewers(get_turf(src)))] [stuff_to_display]"))

/// light: Turns a light on or off when pulsed.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/light
	name = "light"
	desc = "Turns a light on or off when pulsed."
	icon_state = "light"
	complexity = 4
	inputs = list()
	outputs = list()
	activators = list("toggle light" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	// Stores `light_toggled` state used by this integrated electronics object.
	var/light_toggled = FALSE
	// Stores `light_brightness` state used by this integrated electronics object.
	var/light_brightness = 3
	// Stores `light_rgb` state used by this integrated electronics object.
	var/light_rgb = COLOR_WHITE
	power_draw_idle = 0 // Adjusted based on brightness.

	light_system = MOVABLE_LIGHT

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/light/do_work()
	light_toggled = !light_toggled
	update_lighting()

/// Updates `lighting` after related circuit or assembly state changes.
/obj/item/integrated_circuit/output/light/proc/update_lighting()
	if(assembly)
		var/atom/movable/atom_holder = assembly.get_assembly_holder()
		if(istype(atom_holder))
			if(light_toggled)
				atom_holder.set_light_on(FALSE) //make sure the atom holder has movable_light set
			else
				atom_holder.set_light_on(TRUE)
			power_draw_idle = light_toggled ? light_brightness * 2 : 0

/// Implements `disconnect_all` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/light/disconnect_all()
	..()
	light_toggled = FALSE
	update_lighting()

/// Updates `lighting` after related circuit or assembly state changes.
/obj/item/integrated_circuit/output/light/advanced/update_lighting()
	// Stores `new_color` state used by this integrated electronics object.
	var/new_color = get_pin_data(IC_INPUT, 1)
	// Stores `brightness` state used by this integrated electronics object.
	var/brightness = get_pin_data(IC_INPUT, 2)

	if(new_color && isnum(brightness))
		brightness = clamp(brightness, 0, 6)
		light_rgb = new_color
		light_brightness = brightness

	// Stores `atom_holder` state used by this integrated electronics object.
	var/atom/movable/atom_holder = assembly.get_assembly_holder()
	if(istype(atom_holder))
		atom_holder.set_light_range_power_color(light_brightness, light_brightness, light_rgb)

	..()

/obj/item/integrated_circuit/output/light/power_fail() // Turns off the flashlight if there's no power left.
	light_toggled = FALSE
	update_lighting()

/// advanced light: Turns a configurable colored light on or off when pulsed.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/light/advanced
	name = "advanced light"
	desc = "Turns a configurable colored light on or off when pulsed."
	icon_state = "light_adv"
	complexity = 8
	inputs = list(
		"color" = IC_PINTYPE_COLOR,
		"brightness" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/light/advanced/on_data_written()
	update_lighting()

/// speaker circuit: Plays sounds from the assembly.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/sound
	name = "speaker circuit"
	desc = "Plays sounds from the assembly."
	icon_state = "speaker"
	complexity = 8
	cooldown_per_use = 1 SECOND
	inputs = list(
		"sound ID" = IC_PINTYPE_STRING,
		"volume" = IC_PINTYPE_NUMBER,
		"frequency" = IC_PINTYPE_BOOLEAN
	)
	outputs = list()
	activators = list("play sound" = IC_PINTYPE_PULSE_IN)
	power_draw_per_use = 200
	// Stores `sounds` state used by this integrated electronics object.
	var/list/sounds = list()

/// text-to-speech circuit: Plays sounds from the assembly. Converts valid text input into spoken audio.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/text_to_speech
	name = "text-to-speech circuit"
	desc = "Plays sounds from the assembly."
	extended_desc = "Converts valid text input into spoken audio."
	icon_state = "speaker"
	complexity = 12
	cooldown_per_use = 1 SECOND
	inputs = list("text" = IC_PINTYPE_STRING)
	outputs = list()
	activators = list("to speech" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 600

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/text_to_speech/do_work()
	// Stores `text` state used by this integrated electronics object.
	var/text = get_pin_data(IC_INPUT, 1)

	if(isnull(text))
		return

	/*
	 * If this TTS circuit is inside an electronic radio headset,
	 * output privately to the headset wearer only.
	 */
	var/obj/item/electronic_assembly/clothing/A = loc

	if(istype(A))
		var/obj/item/radio/headset/circuitry/H = A.clothing

		if(istype(H))
			H.private_tts_output(text)
			return

	/*
	 * Fallback behavior for every TTS circuit outside the electronic radio headset.
	 */
	var/obj/O = loc ? loc : src
	audible_message("[icon2html(O, viewers(get_turf(O)))] \The [O.name] states, \"[text]\"")

/// Initializes runtime state after the parent type is constructed.
/obj/item/integrated_circuit/output/sound/Initialize()
	. = ..()
	extended_desc = list()
	extended_desc += "The first input pin determines which sound is used. The choices are; "
	extended_desc += jointext(sounds, ", ")
	extended_desc += ". The second pin determines the volume of sound that is played"
	extended_desc += ", and the third determines if the frequency of the sound will vary with each activation."
	extended_desc = jointext(extended_desc, null)

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/sound/do_work()
	// Stores `ID` state used by this integrated electronics object.
	var/ID = get_pin_data(IC_INPUT, 1)
	// Stores `vol` state used by this integrated electronics object.
	var/vol = get_pin_data(IC_INPUT, 2)
	// Stores `freq` state used by this integrated electronics object.
	var/freq = get_pin_data(IC_INPUT, 3)
	if(!isnull(ID) && !isnull(vol))
		var/selected_sound = sounds[ID]
		if(!selected_sound)
			return
		vol = between(0, vol, 100)
		playsound(get_turf(src), selected_sound, vol, freq, -1)

/// beeper circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/sound/beeper
	name = "beeper circuit"
	desc = "Plays sounds from the assembly.  This is often used in the construction of motherboards, which use \
	the speaker to tell the user if something goes very wrong when booting up.  It can also do other similar synthetic sounds such \
	as buzzing, pinging, chiming, and more."
	sounds = list(
		"beep"         = 'sound/machines/twobeep.ogg',
		"chime"        = 'sound/machines/chime.ogg',
		"buzz sigh"    = 'sound/machines/buzz-sigh.ogg',
		"buzz twice"   = 'sound/machines/buzz-two.ogg',
		"ping"         = 'sound/machines/ping.ogg',
		"synth yes"    = 'sound/machines/synth_yes.ogg',
		"synth no"     = 'sound/machines/synth_no.ogg',
		"warning buzz" = 'sound/machines/warning-buzzer.ogg'
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// securitron sound circuit: Plays alert tones or warning sounds.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/sound/beepsky
	name = "securitron sound circuit"
	desc = "A miniature speaker that plays alert tones or warning sounds."
	sounds = list(
		"creep"        = 'sound/voice/bcreep.ogg',
		"criminal"     = 'sound/voice/bcriminal.ogg',
		"freeze"       = 'sound/voice/bfreeze.ogg',
		"god"          = 'sound/voice/bgod.ogg',
		"i am the law" = 'sound/voice/biamthelaw.ogg',
		"radio"        = 'sound/voice/bradio.ogg',
		"secure day"   = 'sound/voice/bsecureday.ogg'
	)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)

/// medibot sound circuit: A miniature speaker that plays medical bot audio cues.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/sound/medbot
	name = "medibot sound circuit"
	desc = "A miniature speaker that plays medical bot audio cues."
	sounds = list(
		"surgeon"     = 'sound/voice/medbot/msurgeon.ogg',
		"radar"       = 'sound/voice/medbot/mradar.ogg',
		"feel better" = 'sound/voice/medbot/mfeelbetter.ogg',
		"patched up"  = 'sound/voice/medbot/mpatchedup.ogg',
		"injured"     = 'sound/voice/medbot/minjured.ogg',
		"coming"      = 'sound/voice/medbot/mcoming.ogg',
		"help"        = 'sound/voice/medbot/mhelp.ogg',
		"live"        = 'sound/voice/medbot/mlive.ogg',
		"lost"        = 'sound/voice/medbot/mlost.ogg',
		"flies"       = 'sound/voice/medbot/mflies.ogg',
		"catch"       = 'sound/voice/medbot/mcatch.ogg',
		"delicious"   = 'sound/voice/medbot/mdelicious.ogg',
		"apple"       = 'sound/voice/medbot/mapple.ogg',
		"no"          = 'sound/voice/medbot/mno.ogg'
	)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 1)

/// video camera circuit: Creates a camera feed from the assembly's position. Creates a camera feed. It uses the Research camera network by default, but the network can be changed.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/video_camera
	name = "video camera circuit"
	desc = "Creates a camera feed from the assembly's position."
	extended_desc = "Creates a camera feed. It uses the Research camera network by default, but the network can be changed."
	icon_state = "video_camera"
	w_class = WEIGHT_CLASS_SMALL
	complexity = 10
	inputs = list(
		"camera name" = IC_PINTYPE_STRING,
		"camera network" = IC_PINTYPE_STRING,
		"camera active" = IC_PINTYPE_BOOLEAN
	)
	inputs_default = list("1" = "video camera circuit",
						"2" = "Research")
	outputs = list()
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_idle = 5 // Raises to 200 when on.
	// Stores `camera` state used by this integrated electronics object.
	var/obj/machinery/camera/network/research/camera

/// Initializes runtime state after the parent type is constructed.
/obj/item/integrated_circuit/output/video_camera/Initialize()
	. = ..()
	camera = new(src, 0, TRUE, TRUE)
	on_data_written()

/// Releases owned objects and clears references before parent deletion runs.
/obj/item/integrated_circuit/output/video_camera/Destroy()
	QDEL_NULL(camera)
	return ..()

/// Sets `camera_status` and performs any required follow-up bookkeeping.
/obj/item/integrated_circuit/output/video_camera/proc/set_camera_status(var/status)
	if(camera)
		camera.set_status(status)
		power_draw_idle = camera.status ? 200 : 5
		if(camera.status) // Ensure that there's actually power.
			if(!draw_idle_power())
				power_fail()

/// Sets `camera_network` and performs any required follow-up bookkeeping.
/obj/item/integrated_circuit/output/video_camera/proc/set_camera_network(var/network)
	if(camera)
		camera.network = list(network)
		camera.update_coverage()

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/video_camera/on_data_written()
	if(camera)
		var/cam_name = get_pin_data(IC_INPUT, 1)
		var/cam_network = get_pin_data(IC_INPUT, 2)
		var/cam_active = get_pin_data(IC_INPUT, 3)
		if(!isnull(cam_name))
			camera.c_tag = cam_name
		set_camera_network(cam_network)
		set_camera_status(cam_active)

/// Implements `power_fail` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/video_camera/power_fail()
	if(camera)
		set_camera_status(0)
		set_pin_data(IC_INPUT, 3, FALSE)
		push_data()

/// light-emitting diode: This LED lights while its input contains TRUE-equivalent data. TRUE values include non-empty text, non-zero numbers, valid refs, and populated lists. FALSE values include null, 0, and empty text.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led
	name = "light-emitting diode"
	desc = "This LED lights while its input contains TRUE-equivalent data."
	extended_desc = "TRUE values include non-empty text, non-zero numbers, valid refs, and populated lists. FALSE values include null, 0, and empty text."
	complexity = 0.1
	icon_state = "led"
	inputs = list("lit" = IC_PINTYPE_BOOLEAN)
	outputs = list()
	activators = list()
	power_draw_idle = 0 // Raises to 10 when lit.
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	// Stores `led_color` state used by this integrated electronics object.
	var/led_color
	// Stores `color_name` state used by this integrated electronics object.
	var/color_name

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/led/on_data_written()
	power_draw_idle = get_pin_data(IC_INPUT, 1) ? 10 : 0

/// Implements `power_fail` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/led/power_fail()
	set_pin_data(IC_INPUT, 1, FALSE)
	push_data()

/// Implements `any_examine` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/led/any_examine(mob/user)
	. = ..()
	var/text_output = list()
	// Stores `initial_name` state used by this integrated electronics object.
	var/initial_name = initial(name)

	// Doing all this work just to have a color-blind friendly output.
	text_output += "There is "
	if(name == initial_name)
		text_output += "\an [name]"
	else
		text_output += "\an ["\improper[initial_name]"] labeled '[name]'"
	text_output += " which is currently [get_pin_data(IC_INPUT, 1) ? "lit <font color=[led_color]>[color_name]</font>" : "unlit."]"
	. += jointext(text_output,null)

/// red LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/red
	name = "red LED"
	led_color = COLOR_RED
	color_name = "red"

/// orange LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/orange
	name = "orange LED"
	led_color = COLOR_ORANGE
	color_name = "orange"

/// yellow LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/yellow
	name = "yellow LED"
	led_color = COLOR_YELLOW
	color_name = "yellow"

/// green LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/green
	name = "green LED"
	led_color = COLOR_GREEN
	color_name = "green"

/// blue LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/blue
	name = "blue LED"
	led_color = COLOR_BLUE
	color_name = "blue"

/// purple LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/purple
	name = "purple LED"
	led_color = COLOR_PURPLE
	color_name = "purple"

/// cyan LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/cyan
	name = "cyan LED"
	led_color = COLOR_CYAN
	color_name = "cyan"

/// white LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/white
	name = "white LED"
	led_color = COLOR_WHITE
	color_name = "white"

/// pink LED: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/led/pink
	name = "pink LED"
	led_color = COLOR_PINK
	color_name = "pink"

/// printer: Prints text to paper. If the eject input is enabled, or if the paper is full, the paper is ejected after printing..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/output/printer
	name = "printer"
	desc = "Prints text to paper. If the eject input is enabled, or if the paper is full, the paper is ejected after printing."
	icon_state = "screen"
	inputs = list("printed data" = IC_PINTYPE_ANY, "paper source" = IC_PINTYPE_REF, "eject sheet" = IC_PINTYPE_BOOLEAN)
	outputs = list()
	activators = list("print page" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 200
	w_class = WEIGHT_CLASS_NORMAL
	size = 5
	// Stores `stuff_to_print` state used by this integrated electronics object.
	var/stuff_to_print = null

/// Implements `disconnect_all` behavior for this integrated electronics type.
/obj/item/integrated_circuit/output/printer/disconnect_all()
	..()
	stuff_to_print = null

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/output/printer/do_work()
	// Stores `paper_source` state used by this integrated electronics object.
	var/obj/item/integrated_circuit/insert_slot/paper_tray/paper_source = get_pin_data_as_type(IC_INPUT, 2, /obj/item/)
	// Stores `paper_sheet` state used by this integrated electronics object.
	var/obj/item/paper/paper_sheet = null
	// Stores `eject` state used by this integrated electronics object.
	var/eject = get_pin_data(IC_INPUT, 3)
	// Stores `info` state used by this integrated electronics object.
	var/datum/integrated_io/info = inputs[1]
	// Stores `using_tray` state used by this integrated electronics object.
	var/using_tray = istype(paper_source)
	if(isweakref(info.data))
		stuff_to_print = "[get_pin_data_as_type(IC_INPUT, 1, /datum/)]"
	else
		stuff_to_print = info.data
	if(using_tray)
		paper_sheet = paper_source.get_item(FALSE)
	if(istype(paper_source, /obj/item/paper))
		paper_sheet = paper_source
	if(paper_sheet)
		stuff_to_print = paper_sheet.info + stuff_to_print
		while(stuff_to_print)
			paper_sheet.set_content(null, copytext(stuff_to_print, 1, MAX_PAPER_MESSAGE_LEN))
			stuff_to_print = copytext(stuff_to_print, MAX_PAPER_MESSAGE_LEN)
			if(stuff_to_print || eject)
				paper_sheet = paper_source.get_item(TRUE)
				audible_message(SPAN_NOTICE("\The [src] buzzes and spits out a sheet of paper."))
				paper_sheet.forceMove(get_turf(src))
				if(using_tray)
					paper_sheet = paper_source.get_item(FALSE)
					if(!paper_sheet)
						audible_message(SPAN_NOTICE("\The [src] beeps, out of paper."))
						return
	else
		audible_message(SPAN_NOTICE("\The [src] beeps, out of paper."))
