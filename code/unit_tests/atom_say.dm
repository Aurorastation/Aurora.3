/// Capture the completed event without adding test speech to the admin log.
/obj/atom_say_test_speaker
	name = "speech test device"
	var/datum/say_message/last_message

/obj/atom_say_test_speaker/finish_say_message(datum/say_message/msg)
	last_message = msg

/obj/atom_say_test_receiver
	var/received = 0
	var/datum/say_message/last_message

/obj/atom_say_test_receiver/Initialize(mapload, ...)
	. = ..()
	become_hearing_sensitive()

/obj/atom_say_test_receiver/hear_talk(atom/movable/speaker, text, verb, datum/language/speaking, datum/say_message/msg)
	received++
	last_message = msg

/// Exercise the open-microphone adapter without sending a network transmission.
/obj/item/radio/atom_say_test_radio
	var/received = 0
	var/datum/say_message/last_message

/obj/item/radio/atom_say_test_radio/talk_into(atom/movable/speaker, message, channel, say_verb, datum/language/speaking, ignore_restrained, datum/say_message/say_message)
	received++
	last_message = say_message
	return TRUE

/mob/living/atom_say_test_listener
	var/list/messages = list()

/mob/living/atom_say_test_listener/has_chat_sink()
	return TRUE

/mob/living/atom_say_test_listener/on_hear_message(message)
	messages += message

/datum/unit_test/atom_say
	name = "SPEECH: Atom delivery, modifiers, language comprehension, and range"
	groups = list("mob", "speech")

/datum/unit_test/atom_say/start_test()
	var/turf/location = length(GLOB.tdome1) ? get_turf(pick(GLOB.tdome1)) : locate(/turf/simulated/floor)
	TEST_ASSERT(location, "A test turf must exist")
	var/list/fixtures = list()
	var/obj/atom_say_test_speaker/speaker = new(location)
	var/obj/atom_say_test_receiver/device = new(location)
	var/mob/living/atom_say_test_listener/listener = new(location)
	var/obj/item/radio/atom_say_test_radio/radio = new(location)
	radio.broadcasting = TRUE
	radio.become_hearing_sensitive()
	fixtures += list(speaker, device, listener, radio)
	listener.add_language(LANGUAGE_TCB)
	var/list/mods = list(SAY_MOD_VERB = "announces", SAY_MOD_NAME_SUFFIX = " (test)")
	var/failures_before = GLOB.unit_tests_failures

	// Execute the real object-to-mob and object-to-device paths, including the spatial grid.
	var/said = speaker.say("speech fixture", message_mods = mods, message_range = 0)
	if(!said || length(listener.messages) != 1 || device.received != 1)
		TEST_FAIL("Object speech must reach a nearby mob and hearing-sensitive device exactly once")
	if(!findtext(jointext(listener.messages, " "), "announces") || !findtext(jointext(listener.messages, " "), " (test)"))
		TEST_FAIL("Attribution and name suffix modifiers must reach the rendered message")
	if(speaker.last_message?.message_range != 0)
		TEST_FAIL("A caller's zero range must not be replaced with the default or pressure range")
	if(device.last_message?.speaker != speaker)
		TEST_FAIL("Devices must receive the actual object speaker and speech payload")
	if(radio.received != 1 || radio.last_message != speaker.last_message)
		TEST_FAIL("An open microphone must forward the object speaker's segmented message once")
	var/datum/signal/subspace/vocal/signal = new(radio, radio.frequency, WEAKREF(speaker), GLOB.all_languages[LANGUAGE_TCB], "speech fixture", "announces", speaker.last_message)
	if(signal.data["name"] != speaker.name || signal.data["job"] != "Device" || signal.say_message != speaker.last_message)
		TEST_FAIL("A radio signal must retain an object identity without mob-only fields")

	// A containment relay and direct spatial delivery must not notify a device twice.
	device.Hear(speaker.last_message)
	if(device.received != 1)
		TEST_FAIL("The same local event must not be dispatched twice to a device")
	var/obj/structure/closet/container = new(location)
	var/obj/atom_say_test_receiver/contained_device = new(container)
	fixtures += list(contained_device, container)
	var/datum/say_message/relayed = speaker.last_message.copy()
	container.Hear(relayed)
	contained_device.Hear(relayed)
	if(contained_device.received != 1)
		TEST_FAIL("Containment relays and direct delivery must share duplicate protection")
	var/datum/say_message/copied = speaker.last_message.copy()
	copied.message_mods[SAY_MOD_VERB] = "changed"
	if(mods[SAY_MOD_VERB] != "announces" || speaker.last_message.message_mods[SAY_MOD_VERB] != "announces")
		TEST_FAIL("Message construction and copying must not mutate caller-owned modifiers")

	var/obj/atom_say_test_receiver/distant = new(get_step(location, NORTH))
	fixtures += distant
	speaker.say("limited", message_range = 0)
	if(distant.received)
		TEST_FAIL("A device on another turf must not hear range-zero speech")
	var/mob/living/carbon/human/human = new(location)
	fixtures += human
	human.add_language(LANGUAGE_TCB)
	human.default_language = GLOB.all_languages[LANGUAGE_TCB]
	human.stuttering = 100
	if(!human.say("Human fixture.", message_mods = mods, skip_edit = TRUE, message_range = 0))
		TEST_FAIL("A human override must reach the shared speech path")
	if(device.last_message?.speaker != human || device.last_message?.to_string() != "Human fixture.")
		TEST_FAIL("Human argument forwarding must preserve identity and skip_edit")

	// Understanding is computed independently for each language segment and listener.
	var/mob/living/atom_say_test_listener/other = new(location)
	fixtures += other
	other.add_language(LANGUAGE_SOL_COMMON)
	var/datum/say_message/mixed = new
	mixed.speaker = speaker
	mixed.segments = list(new /datum/say_segment("cetiword", GLOB.all_languages[LANGUAGE_TCB]), new /datum/say_segment("solword", GLOB.all_languages[LANGUAGE_SOL_COMMON]))
	var/list/ceti_pieces = mixed.render_pieces(listener)
	var/list/sol_pieces = mixed.render_pieces(other)
	if(!findtext(ceti_pieces[1][1], "Cetiword") || findtext(ceti_pieces[2][1], "solword"))
		TEST_FAIL("The Ceti listener must understand only the Ceti segment")
	if(findtext(sol_pieces[1][1], "cetiword") || !findtext(sol_pieces[2][1], "solword"))
		TEST_FAIL("The Sol listener must understand only the Sol segment")
	other.ear_deaf = TRUE
	if(other.get_clarity(mixed, feedback = FALSE) != CLARITY_NONE)
		TEST_FAIL("Object speech must respect listener deafness")

	// An attribution string alone is not a request for amplified presentation.
	speaker.say("ordinary", message_mods = list(SAY_MOD_VERB = "broadcasts"))
	if(speaker.last_message.font_size == FONT_SIZE_HUGE)
		TEST_FAIL("The verb broadcasts must not implicitly enable amplification")
	speaker.say("amplified", message_mods = list(SAY_MOD_VERB = "broadcasts", MODE_AMPLIFIED = TRUE))
	if(speaker.last_message.font_size != FONT_SIZE_HUGE)
		TEST_FAIL("Explicit amplification must retain its presentation")
	if(speaker.say("", message_range = 0) || speaker.say("invalid range", message_range = -1))
		TEST_FAIL("Empty speech and negative ranges must be rejected")
	var/datum/language/private_language = GLOB.all_languages[LANGUAGE_BORER_HIVEMIND]
	speaker.speech_language = LANGUAGE_BORER_HIVEMIND
	if(speaker.say("private channel", speaking = private_language))
		TEST_FAIL("A normal object must not acquire private language broadcasting")

	for(var/atom/movable/fixture as anything in fixtures)
		qdel(fixture)
	if(GLOB.unit_tests_failures != failures_before)
		return FALSE
	TEST_PASS("Object speech preserves modifiers, comprehension, sensory checks, and localized delivery")
	return TRUE
