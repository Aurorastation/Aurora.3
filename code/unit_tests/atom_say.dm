/// Capture the completed event without adding test speech to the admin log.
/obj/atom_say_test_speaker
	name = "speech test device"
	var/datum/say_message/last_message

/obj/atom_say_test_speaker/finish_say_message(datum/say_message/msg)
	last_message = msg

/obj/item/lore_radio/atom_say_test_lore_radio
	var/datum/say_message/last_message

/obj/item/lore_radio/atom_say_test_lore_radio/finish_say_message(datum/say_message/msg)
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
	var/presented = 0
	var/list/presentation_listeners

/obj/item/radio/atom_say_test_radio/present_say_message(datum/say_message/msg, list/listeners, list/hear_clients)
	presented++
	presentation_listeners = listeners.Copy()
	return ..()

/obj/item/radio/atom_say_test_radio/talk_into(atom/movable/speaker, message, channel, say_verb, datum/language/speaking, ignore_restrained, datum/say_message/say_message)
	received++
	last_message = say_message
	return TRUE

/obj/item/radio/intercom/atom_say_test_intercom
	var/received = 0
	var/datum/say_message/last_message
	var/presented = 0
	var/list/presentation_listeners
	var/datum/say_message/presented_message
	// Use existing screen art to exercise the independent scanline layer without new assets.
	overlay_screen_scanlines = "intercom_screen"

/obj/item/radio/intercom/atom_say_test_intercom/present_say_message(datum/say_message/msg, list/listeners, list/hear_clients)
	presented++
	presentation_listeners = listeners.Copy()
	presented_message = msg
	return ..()

/obj/item/radio/intercom/atom_say_test_intercom/talk_into(atom/movable/speaker, message, channel, say_verb, datum/language/speaking, ignore_restrained, datum/say_message/say_message)
	received++
	last_message = say_message
	return TRUE

/// Existing states exercise appearance transitions without adding production artwork.
/obj/item/radio/atom_say_test_shortwave
	overlay_power_on = "intercom_screen"
	overlay_power_emissive = "intercom_screen"

/mob/living/atom_say_test_listener
	var/list/messages = list()

/mob/living/atom_say_test_listener/has_chat_sink()
	return TRUE

/mob/living/atom_say_test_listener/on_hear_message(message)
	messages += message

/datum/unit_test/atom_say
	name = "SPEECH: Atom delivery, modifiers, language comprehension, and range"
	groups = list("mob", "speech")
	var/receive_activity_signals = 0
	var/list/last_radio_data

/datum/unit_test/atom_say/proc/on_radio_receive(obj/item/radio/source, list/data)
	SIGNAL_HANDLER
	receive_activity_signals++
	last_radio_data = data

/datum/unit_test/atom_say/start_test()
	var/turf/location = length(GLOB.tdome1) ? get_turf(pick(GLOB.tdome1)) : locate(/turf/simulated/floor)
	TEST_ASSERT(location, "A test turf must exist")
	var/list/fixtures = list()
	var/obj/atom_say_test_speaker/speaker = new(location)
	var/obj/atom_say_test_receiver/device = new(location)
	var/mob/living/atom_say_test_listener/listener = new(location)
	var/obj/item/radio/atom_say_test_radio/radio = new(location)
	radio.set_broadcasting(TRUE)
	var/obj/item/radio/intercom/atom_say_test_intercom/intercom = new(location)
	intercom.set_on(TRUE)
	intercom.set_broadcasting(TRUE)
	RegisterSignal(intercom, COMSIG_RADIO_RECEIVE_MESSAGE, PROC_REF(on_radio_receive))
	fixtures += list(speaker, device, listener, radio, intercom)
	listener.add_language(LANGUAGE_TCB)
	var/list/mods = list(SAY_MOD_VERB = "announces", SAY_MOD_NAME_SUFFIX = " (test)")
	var/list/speech_spans = list("notice")
	var/failures_before = GLOB.unit_tests_failures

	// Execute the real object-to-mob and object-to-device paths, including the spatial grid.
	var/said = speaker.say("speech fixture", message_mods = mods, message_range = 0, spans = speech_spans)
	if(!said || length(listener.messages) != 1 || device.received != 1)
		TEST_FAIL("Object speech must reach a nearby mob and hearing-sensitive device exactly once")
	if(!findtext(jointext(listener.messages, " "), "announces") || !findtext(jointext(listener.messages, " "), " (test)"))
		TEST_FAIL("Attribution and name suffix modifiers must reach the rendered message")
	if(speaker.last_message?.message_range != 0)
		TEST_FAIL("A caller's zero range must not be replaced with the default or pressure range")
	if(device.last_message?.speaker != speaker)
		TEST_FAIL("Devices must receive the actual object speaker and speech payload")
	if(!findtext(listener.messages[1], "class='notice'"))
		TEST_FAIL("Speech spans must reach the rendered chat message")
	speech_spans += "warning"
	if("warning" in speaker.last_message.spans)
		TEST_FAIL("A speech event must copy caller-owned span lists")
	if(radio.received != 1 || radio.last_message != speaker.last_message)
		TEST_FAIL("An open microphone must forward the object speaker's segmented message once")
	if(intercom.received != 1 || intercom.last_message != speaker.last_message)
		TEST_FAIL("An intercom must forward the object speaker's segmented message once")
	var/datum/signal/subspace/vocal/signal = new(radio, radio.get_frequency(), WEAKREF(speaker), GLOB.all_languages[LANGUAGE_TCB], "speech fixture", "announces", speaker.last_message)
	if(signal.data["name"] != speaker.name || signal.data["job"] != "Device" || signal.say_message != speaker.last_message)
		TEST_FAIL("A radio signal must retain an object identity without mob-only fields")

	// Real broadcast reception uses the shared Hear hook, deduplicating overlapping radios.
	var/device_before = device.received
	var/listener_before = length(listener.messages)
	var/original_name = speaker.name
	speaker.name = "changed after transmission"
	signal.data["compression"] = 0
	signal.broadcast()
	speaker.name = original_name
	if(device.received != device_before + 1 || length(listener.messages) != listener_before + 1)
		TEST_FAIL("Radio playback must reach mobs and hearing-sensitive objects once across overlapping radios")
	if(device.last_message?.say_mode != SAYMODE_RADIO || device.last_message?.speaker != speaker)
		TEST_FAIL("Radio playback must preserve its transport and original object speaker")
	if(!findtext(listener.messages[length(listener.messages)], original_name) || findtext(listener.messages[length(listener.messages)], "changed after transmission"))
		TEST_FAIL("Radio identity must be captured at transmission time")
	if(radio.received != 1 || intercom.received != 1)
		TEST_FAIL("Radios and intercoms must not retransmit received radio speech")
	if(radio.presented != 1 || intercom.presented != 1 || !(listener in intercom.presentation_listeners))
		TEST_FAIL("Each receiving radio and intercom must present relayed speech to nearby listeners")
	if(intercom.presented_message?.speaker != speaker || intercom.presented_message?.say_mode != SAYMODE_RADIO)
		TEST_FAIL("Intercom presentation must retain the transmitted speaker and radio transport")
	intercom.ImmediateOverlayUpdate()
	var/scanline_layers = 0
	for(var/appearance in intercom.overlays)
		if(appearance:layer == intercom.layer + 0.2)
			scanline_layers++
	if(scanline_layers != 1)
		TEST_FAIL("Intercom scanlines must be a single persistent layer above the screen content")
	if(receive_activity_signals != 1 || last_radio_data != signal.data)
		TEST_FAIL("Receiving radios must emit the TG-compatible activity signal with the transmission data")
	intercom.set_on(FALSE)
	intercom.ImmediateOverlayUpdate()
	if(length(intercom.overlays))
		TEST_FAIL("An unpowered intercom must show neither screen content nor scanlines")
	intercom.set_on(TRUE)
	intercom.on_receive_message(signal.data, intercom.presented_message, list())
	if(length(intercom.presentation_listeners))
		TEST_FAIL("Radio presentation must not expose speech to listeners excluded from the broadcast")
	var/datum/say_message/intercom_mode = speaker.last_message.copy()
	intercom_mode.message_mode = "intercom"
	intercom.Hear(intercom_mode)
	if(intercom.received != 1)
		TEST_FAIL("Explicit intercom speech must not also transmit through the open microphone")
	var/obj/atom_say_test_speaker/temporary_speaker = new(location)
	var/datum/signal/subspace/vocal/announcement = new(radio, radio.get_frequency(), WEAKREF(temporary_speaker), GLOB.all_languages[LANGUAGE_TCB], "announcement fixture", "states")
	announcement.data["name"] = "Automated announcement"
	announcement.data["compression"] = 0
	qdel(temporary_speaker)
	announcement.broadcast()
	if(!findtext(listener.messages[length(listener.messages)], "Automated announcement"))
		TEST_FAIL("Automated radio identity must survive the original speaker's deletion")
	var/device_after_radio = device.received

	// A containment relay and direct spatial delivery must not notify a device twice.
	device.Hear(speaker.last_message)
	if(device.received != device_after_radio)
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
	copied.spans += "warning"
	if("warning" in speaker.last_message.spans)
		TEST_FAIL("Copied radio events must not share mutable span lists with local speech")
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
	if(!human.say("Human fixture.", message_mods = mods, skip_edit = TRUE, message_range = 0, spans = list("notice")))
		TEST_FAIL("A human override must reach the shared speech path")
	if(device.last_message?.speaker != human || device.last_message?.to_string() != "Human fixture.")
		TEST_FAIL("Human argument forwarding must preserve identity and skip_edit")
	if(!("notice" in device.last_message.spans))
		TEST_FAIL("Human speech overrides must forward spans to the shared speech path")

	// A carried receiver would anchor its echo to the same mob as the original local speech.
	var/datum/say_message/radio_echo = device.last_message.copy()
	radio_echo.say_mode = SAYMODE_RADIO
	radio.forceMove(human)
	var/presented_before = radio.presented
	radio.on_receive_message(list(), radio_echo, list(listener, human))
	if(radio.presented != presented_before)
		TEST_FAIL("A held or worn radio must not repeat its holder's speech above that holder")
	radio.forceMove(listener)
	radio.on_receive_message(list(), radio_echo, list(listener, human))
	if(radio.presented != presented_before + 1)
		TEST_FAIL("A carried radio must still present speech from a different speaker")
	radio.forceMove(location)
	radio.on_receive_message(list(), radio_echo, list(listener, human))
	if(radio.presented != presented_before + 2)
		TEST_FAIL("A separate receiving radio must still present the transmitted speech")

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
	var/datum/signal/subspace/vocal/mixed_signal = new(radio, radio.get_frequency(), WEAKREF(speaker), GLOB.all_languages[LANGUAGE_TCB], mixed.to_string(), "says", mixed)
	mixed_signal.data["compression"] = 0
	mixed_signal.broadcast()
	if(length(device.last_message?.segments) != 2 || device.last_message?.single_language)
		TEST_FAIL("Radio playback must preserve multilingual segments instead of flattening them")
	if(mixed.say_mode == SAYMODE_RADIO || length(mixed.delivered_to))
		TEST_FAIL("Radio delivery must use its own event without mutating the local message")
	if(length(intercom.presented_message?.segments) != 2)
		TEST_FAIL("Intercom overhead speech must retain multilingual segments for comprehension")
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

	var/obj/item/radio/atom_say_test_shortwave/shortwave = new(location)
	fixtures += shortwave
	shortwave.ImmediateOverlayUpdate()
	if(!length(shortwave.overlays) || shortwave.icon_state != initial(shortwave.icon_state))
		TEST_FAIL("A powered shortwave must layer its on appearance over the unchanged off body")
	shortwave.set_on(FALSE)
	shortwave.ImmediateOverlayUpdate()
	if(length(shortwave.overlays))
		TEST_FAIL("Turning off a shortwave must remove its powered and emissive overlays")
	shortwave.set_on(TRUE)
	shortwave.ImmediateOverlayUpdate()
	if(!length(shortwave.overlays))
		TEST_FAIL("Restoring shortwave power must restore its powered and emissive overlays")
	if(shortwave.get_radio_overlay("missing-shortwave-art") || intercom.shortwave_overlays)
		TEST_FAIL("Missing artwork must be optional and intercoms must keep their own appearance handling")

	var/obj/item/lore_radio/atom_say_test_lore_radio/lore = new(location)
	fixtures += lore
	var/datum/language/sol = GLOB.all_languages[LANGUAGE_SOL_COMMON]
	var/formatted_broadcast = "<i>"
	for(var/character_index in 1 to MAX_MESSAGE_LEN)
		formatted_broadcast += "x"
	formatted_broadcast += "</i>"
	lore.low_volume = TRUE
	if(!lore.say_broadcast(formatted_broadcast, sol))
		TEST_FAIL("Lore radio broadcasts must use the shared atom speech path")
	if(lore.last_message?.single_language != sol || lore.get_default_language() != sol)
		TEST_FAIL("Lore radios must configure their language from each received broadcast")
	if(lore.last_message?.to_string() != formatted_broadcast)
		TEST_FAIL("Trusted lore broadcasts must preserve formatting and their full length")
	if(lore.last_message?.message_range != 1 || !("lore-radio" in lore.last_message.spans))
		TEST_FAIL("Low-volume lore speech must retain its styling at a one-tile range")
	if(!lore.last_message.message_mods[MODE_RELAY] || lore.last_message.font_size == FONT_SIZE_HUGE)
		TEST_FAIL("Lore broadcasts must request the radio marker without amplified presentation")
	lore.low_volume = FALSE
	lore.say_broadcast("weather fixture")
	if(lore.last_message?.single_language != GLOB.all_languages[LANGUAGE_TCB])
		TEST_FAIL("Untagged and weather broadcasts must reset the previous station language")
	if(lore.last_message?.message_range != world.view)
		TEST_FAIL("Normal-volume lore speech must restore the ordinary local range")

	for(var/atom/movable/fixture as anything in fixtures)
		qdel(fixture)
	if(GLOB.unit_tests_failures != failures_before)
		return FALSE
	TEST_PASS("Object speech preserves modifiers, comprehension, sensory checks, and localized delivery")
	return TRUE
