/*
 *  Unit Tests for various recipes.
 *
 */

ABSTRACT_TYPE(/datum/unit_test/modular_computers)
	name = "MOD COMP: Template"
	groups = list("generic")

/datum/unit_test/modular_computers/modular_computer_app_presets_contain_programs_only_once
	name = "MOD COMP: Preset contain programs only once"

/datum/unit_test/modular_computers/modular_computer_app_presets_contain_programs_only_once/start_test()
	var/test_result = UNIT_TEST_PASSED

	var/obj/item/modular_computer/test_computer = new()

	for(var/preset_typepath in subtypesof(/datum/modular_computer_app_presets))
		TEST_DEBUG("Testing preset [preset_typepath]")

		//Instance the preset
		var/datum/modular_computer_app_presets/preset = new preset_typepath()

		//Get installed programs
		var/list/datum/computer_file/program/installed_programs = preset.return_install_programs(test_computer)

		//Second list to see if we're finding the same programs twice
		//A list of types
		var/list/programs_present = list()

		for(var/datum/computer_file/program/program in installed_programs)
			if(program.type in programs_present)
				test_result = TEST_FAIL("Found multiple instances of program [program.type] in preset [preset_typepath]!")
			else
				programs_present += program.type
				TEST_DEBUG("Found one instance of program [program.type] in preset [preset_typepath]")

	if(test_result == UNIT_TEST_PASSED)
		TEST_PASS("All programs in modular computer presets are only present once.")

	return test_result


/datum/unit_test/modular_computers/presets_contain_only_compatible_programs
	name = "MOD COMP: Presets contain only compatible programs"
	disabled = TRUE //There's 400+ fuckups and i'm not fixing all that shit myself
	why_disabled = "There's over 400 programs that cannot run where they are installed, a large effort is required to fix them all."

/datum/unit_test/modular_computers/presets_contain_only_compatible_programs/start_test()
	var/test_result = UNIT_TEST_PASSED

	for(var/modular_computer_typepath in subtypesof(/obj/item/modular_computer))
		//We don't care about abstracts
		if(is_abstract(modular_computer_typepath))
			continue

		var/obj/item/modular_computer/sample_modular_computer = new modular_computer_typepath()

		//No need for nulls
		if(isnull(sample_modular_computer._app_preset_type))
			TEST_DEBUG("[modular_computer_typepath] _app_preset_type is null and won't be tested")
			continue

		if(!ispath(sample_modular_computer._app_preset_type, /datum/modular_computer_app_presets))
			test_result = TEST_FAIL("Modular computer typepath '[modular_computer_typepath]' has an invalid _app_preset_type! - [sample_modular_computer._app_preset_type]")
			continue

		//Check that all the programs are supported by the hardwares that use those presets
		var/list/programs = sample_modular_computer.get_preset_programs(sample_modular_computer._app_preset_type)
		for(var/datum/computer_file/program/prog in programs)
			TEST_DEBUG("Will now test [prog.type] in preset [sample_modular_computer._app_preset_type] used by [modular_computer_typepath]")
			if(!prog.is_supported_by_hardware(sample_modular_computer.hardware_flag, FALSE))
				test_result = TEST_FAIL("Found program [prog.type] in preset [sample_modular_computer._app_preset_type] that is used by [modular_computer_typepath], \
										but is not supported by its hardware!")

	if(test_result == UNIT_TEST_PASSED)
		TEST_PASS("All modular computers supports all the programs referenced in their _app_preset_type.")

	return test_result


/datum/unit_test/modular_computers/communicator_end_to_end
	name = "MOD COMP: Communicator calls, texts, tiers, and sealed software"
	groups = list("generic", "communicator")

/datum/unit_test/modular_computers/communicator_end_to_end/start_test()
	// Keep the camera target away from the map edge so all nine PiP cells have a
	// real source turf. Edge clipping is not part of this renderer test.
	var/turf/test_turf = locate(5, 5, 1)
	TEST_ASSERT_NOTNULL(test_turf, "Unable to locate a turf for communicator tests.")

	var/obj/item/modular_computer/handheld/communicator/first_device = new(test_turf)
	var/obj/item/modular_computer/handheld/communicator/second_device = new(test_turf)
	var/obj/item/card/id/first_id = new(test_turf)
	var/obj/item/card/id/second_id = new(test_turf)
	first_id.registered_name = "Communicator Tester One"
	second_id.registered_name = "Communicator Tester Two"
	first_device.register_account(null, first_id, TRUE)
	second_device.register_account(null, second_id, TRUE)

	var/datum/computer_file/program/communicator/first_app = first_device.get_communicator_program()
	var/datum/computer_file/program/communicator/second_app = second_device.get_communicator_program()
	TEST_ASSERT_NOTNULL(first_app, "The first communicator did not install its application.")
	TEST_ASSERT_NOTNULL(second_app, "The second communicator did not install its application.")
	TEST_ASSERT(istype(first_device.hard_drive, /obj/item/computer_hardware/hard_drive/micro/communicator), "The communicator did not install its proprietary drive.")
	TEST_ASSERT_EQUAL(first_app.usage_flags, PROGRAM_COMMUNICATOR, "The communicator app must not run on general modular computers.")
	first_device.active_program = null
	first_app.program_state = PROGRAM_STATE_KILLED
	TEST_ASSERT(first_device.ensure_communicator_program(null), "A communicator stranded at the NTOS menu could not recover its application.")
	TEST_ASSERT_EQUAL(first_device.active_program, first_app, "Recovering a communicator did not restore its application as the active program.")
	var/list/header_data = first_device.get_header_data()
	TEST_ASSERT(!header_data["PC_showexitprogram"], "A communicator exposed the generic NTOS close and minimize controls.")
	TEST_ASSERT(!first_device.kill_program(), "A normal close action was allowed to terminate the communicator application.")
	TEST_ASSERT_EQUAL(first_device.active_program, first_app, "A normal close action stranded the communicator at the NTOS menu.")
	first_device.minimize_program(null)
	TEST_ASSERT_EQUAL(first_device.active_program, first_app, "A minimize action stranded the communicator at the NTOS menu.")
	TEST_ASSERT(validate_ntnet_address("fc00:call:home:z9z9"), "Alphanumeric communicator numbers were rejected.")
	TEST_ASSERT(!validate_ntnet_address("fc00:bad!:0000:0000"), "Punctuation was accepted in a communicator number.")

	var/datum/computer_file/program/manifest/incompatible_program = new(first_device)
	TEST_ASSERT(!first_device.hard_drive.store_file(incompatible_program), "The proprietary communicator drive accepted unrelated software.")
	qdel(incompatible_program)

	var/first_address = first_app.get_computer_address()
	var/second_address = second_app.get_computer_address()
	var/custom_address = "fc00:test:numb:0001"
	var/datum/gear_tweak/communicator_address/address_tweak = new()
	address_tweak.tweak_item(first_device, custom_address, null)
	qdel(address_tweak)
	first_address = first_app.get_computer_address()
	TEST_ASSERT_EQUAL(first_address, custom_address, "The loadout number customization did not update the communicator number.")
	TEST_ASSERT_EQUAL(GLOB.active_communicator_apps[first_address], first_app, "The first registered communicator was not in the active directory.")

	second_app.visible_on_network = FALSE
	var/list/private_directory_data = first_app.ui_data(null)["allUsers"]
	var/private_address_was_leaked = FALSE
	for(var/list/user_data as anything in private_directory_data)
		if(user_data["address"] == second_address)
			private_address_was_leaked = TRUE
	TEST_ASSERT(!private_address_was_leaked, "A hidden communicator number leaked into an unrelated public directory response.")
	first_app.friends[second_address] = second_app.get_user_name()
	private_directory_data = first_app.ui_data(null)["allUsers"]
	var/known_private_address_found = FALSE
	for(var/list/user_data as anything in private_directory_data)
		if(user_data["address"] == second_address)
			known_private_address_found = TRUE
	TEST_ASSERT(known_private_address_found, "A saved hidden communicator could not be resolved by number.")
	second_app.visible_on_network = TRUE

	TEST_ASSERT(first_app.request_voice_call(second_app, second_address), "The first communicator could not place a call.")
	TEST_ASSERT(first_address in second_app.comm_requests[INCOMING_REQUESTS][CALL_REQUESTS], "The receiver did not get an incoming call request.")
	TEST_ASSERT_EQUAL(second_app.program_icon_state, "called", "The receiver did not show its alert icon while ringing.")
	TEST_ASSERT(!second_device.unread_notification, "An incoming call incorrectly created a persistent unread notification.")
	first_app.cancel_voice_call(second_app, second_address)
	TEST_ASSERT(!(first_address in second_app.comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]), "Cancelling an outgoing call left a request on the receiver.")
	TEST_ASSERT_EQUAL(second_app.program_icon_state, "comm", "Cancelling an outgoing call left the receiver's alert icon active.")
	TEST_ASSERT(first_app.request_voice_call(second_app, second_address), "The first communicator could not place a second call after cancelling.")
	TEST_ASSERT(second_app.accept_call(first_app), "The receiver could not accept the call.")
	TEST_ASSERT_NOTNULL(first_app.active_call, "The caller was not connected after call acceptance.")
	TEST_ASSERT_EQUAL(first_app.active_call, second_app.active_call, "The two communicators joined different call datums.")
	TEST_ASSERT_EQUAL(length(first_app.active_call.connected_comms), 2, "The call did not contain both communicators.")

	first_app.end_call("Unit test ended the call.")
	TEST_ASSERT_NULL(first_app.active_call, "The caller remained in an ended call.")
	TEST_ASSERT_NULL(second_app.active_call, "The receiver remained in an ended call.")

	TEST_ASSERT(first_app.send_text_message(second_address, "Hello from the communicator test."), "The communicator failed to send a text message.")
	var/datum/comm_chat/first_chat = first_app.active_chats[second_address]
	var/datum/comm_chat/second_chat = second_app.active_chats[first_address]
	TEST_ASSERT_NOTNULL(first_chat, "The sender did not retain its conversation.")
	TEST_ASSERT_EQUAL(first_chat, second_chat, "Texting did not create one conversation shared by both devices.")
	TEST_ASSERT_EQUAL(length(first_chat.messages), 1, "The shared conversation did not contain the sent message.")
	var/datum/comm_text_message/sent_message = first_chat.messages[1]
	TEST_ASSERT_EQUAL(sent_message.sender_address, first_address, "The text message recorded the wrong sender.")
	first_app.clean_variables(clear_chats = TRUE)
	TEST_ASSERT(!length(first_app.active_chats), "Clearing one communicator did not remove its local conversation history.")
	TEST_ASSERT_EQUAL(second_app.active_chats[first_address], first_chat, "Clearing one communicator erased the other participant's conversation history.")
	TEST_ASSERT_EQUAL(first_app.get_or_create_chat(second_app), first_chat, "A communicator could not reattach to history retained by the other endpoint.")
	TEST_ASSERT_EQUAL(length(first_chat.messages), 1, "Reattaching to a retained conversation erased its messages.")

	var/obj/item/modular_computer/handheld/communicator/video/video_device = new(test_turf)
	var/obj/item/modular_computer/handheld/communicator/holographic/holographic_device = new(test_turf)
	var/obj/item/modular_computer/handheld/communicator/holographic/holographic_peer = new(test_turf)
	var/obj/item/modular_computer/handheld/communicator/holographic/holographic_third = new(test_turf)
	var/obj/item/communicator_landline/landline = new(test_turf)
	var/obj/item/modular_computer/handheld/communicator/landline/landline_handpiece = landline.handpiece
	var/turf/distant_video_turf = locate(test_turf.x + 10, test_turf.y, test_turf.z)
	TEST_ASSERT_NOTNULL(distant_video_turf, "The communicator test could not locate a distant turf for its remote ground camera.")
	landline.forceMove(distant_video_turf)
	TEST_ASSERT_NOTNULL(landline_handpiece, "The department landline did not create a tethered handpiece.")
	TEST_ASSERT_EQUAL(landline_handpiece.loc, landline, "The department landline did not start with its handpiece on the hook.")
	TEST_ASSERT_EQUAL(landline.icon_state, "communicator_landline", "The department landline did not use its on-hook sprite.")
	var/mob/living/carbon/human/landline_user = new(distant_video_turf)
	TEST_ASSERT(landline.take_handpiece(landline_user), "The department landline could not hand its receiver to a user.")
	TEST_ASSERT_EQUAL(landline_handpiece.loc, landline_user, "Taking the department landline receiver did not put it in the user's hand.")
	TEST_ASSERT_NOTNULL(landline_handpiece.cord, "Taking the department landline receiver did not create its tether line.")
	TEST_ASSERT_EQUAL(landline.icon_state, "communicator_landline_raised", "The department landline did not use its off-hook sprite.")
	landline.return_handpiece(landline_handpiece)
	TEST_ASSERT_EQUAL(landline_handpiece.loc, landline, "Returning the department landline receiver did not place it back on the hook.")
	TEST_ASSERT(landline.take_handpiece(landline_user), "The department landline could not be picked up for its tether-range test.")
	landline_user.forceMove(test_turf)
	landline_handpiece.check_tether_range()
	TEST_ASSERT_EQUAL(landline_handpiece.loc, landline, "The department landline receiver did not return after its holder moved beyond two tiles.")
	var/obj/item/card/id/video_id = new(test_turf)
	var/obj/item/card/id/holographic_id = new(test_turf)
	var/obj/item/card/id/holographic_peer_id = new(test_turf)
	var/obj/item/card/id/holographic_third_id = new(test_turf)
	video_id.registered_name = "Video Communicator Tester"
	holographic_id.registered_name = "Holographic Communicator Tester"
	holographic_peer_id.registered_name = "Holographic Peer Tester"
	holographic_third_id.registered_name = "Holographic Third Tester"
	video_device.register_account(null, video_id, TRUE)
	holographic_device.register_account(null, holographic_id, TRUE)
	holographic_peer.register_account(null, holographic_peer_id, TRUE)
	holographic_third.register_account(null, holographic_third_id, TRUE)
	var/datum/computer_file/program/communicator/video_app = video_device.get_communicator_program()
	var/datum/computer_file/program/communicator/landline_app = landline_handpiece.get_communicator_program()
	var/datum/computer_file/program/communicator/holographic_app = holographic_device.get_communicator_program()
	var/datum/computer_file/program/communicator/holographic_peer_app = holographic_peer.get_communicator_program()
	var/datum/computer_file/program/communicator/holographic_third_app = holographic_third.get_communicator_program()
	var/mob/living/carbon/human/video_camera_carrier = new(test_turf)
	var/obj/item/storage/backpack/video_camera_bag = new(video_camera_carrier)
	var/obj/item/storage/box/video_camera_box = new(video_camera_bag)
	holographic_device.forceMove(video_camera_box)
	TEST_ASSERT_EQUAL(holographic_app.get_projection_subject(), video_camera_carrier, "A communicator nested two inventory levels deep did not resolve its carrying mob.")
	TEST_ASSERT_EQUAL(video_device.communicator_tier, COMMUNICATOR_TIER_VIDEO, "The video communicator has the wrong feature tier.")
	TEST_ASSERT_EQUAL(holographic_device.communicator_tier, COMMUNICATOR_TIER_HOLOGRAPHIC, "The holographic communicator has the wrong feature tier.")
	TEST_ASSERT_EQUAL(landline_handpiece.communicator_tier, COMMUNICATOR_TIER_BASIC, "The department landline should only support calls and messaging.")
	TEST_ASSERT_NOTNULL(landline_handpiece.registered_id, "The department landline did not register its directory identity.")
	TEST_ASSERT(!landline_handpiece.battery_module && istype(landline_handpiece.tesla_link, /obj/item/computer_hardware/tesla_link), "The department landline is not APC-powered.")
	TEST_ASSERT(video_app.request_voice_call(landline_app, landline_app.get_computer_address()), "A video communicator could not call a department landline.")
	TEST_ASSERT(landline_app.accept_call(video_app), "The department landline could not accept a video-tier call.")
	TEST_ASSERT_EQUAL(video_app.get_video_target(), landline_app, "A compatible video target was not exposed for the connected call.")
	TEST_ASSERT(video_app.active_call.add_device(holographic_app), "A second video-capable participant could not join the camera picker test call.")
	var/list/available_video_targets = video_app.get_video_targets()
	TEST_ASSERT_EQUAL(length(available_video_targets), 2, "The video camera picker exposed the wrong number of compatible call participants.")
	TEST_ASSERT(landline_app in available_video_targets, "The video camera picker did not expose the connected participant.")
	TEST_ASSERT(holographic_app in available_video_targets, "The video camera picker did not expose an additional connected participant.")
	video_app.video_target = holographic_app
	TEST_ASSERT_EQUAL(video_app.get_video_camera_target(), video_camera_carrier, "The remote video eye did not resolve a communicator nested inside its carrier's inventory.")
	TEST_ASSERT(video_app.active_call.remove_device(holographic_app), "The additional camera picker test participant could not leave the call.")
	video_app.video_target = landline_app
	TEST_ASSERT_EQUAL(video_app.get_video_camera_target(), landline, "The video view did not resolve a distant communicator resting directly on the ground.")
	TEST_ASSERT_EQUAL(COMMUNICATOR_VIDEO_ZOOM, 10, "Communicator video did not use the client's High view zoom setting.")
	video_app.video_call_on = TRUE
	video_app.video_viewer = video_camera_carrier
	video_app.video_previous_zoom = "3"
	var/atom/movable/video_subject = video_app.get_video_camera_target()
	TEST_ASSERT_EQUAL(video_subject, landline, "The remote video feed did not resolve the topmost atom containing the target communicator.")
	TEST_ASSERT_EQUAL(video_app.get_video_eye_target(), landline, "A bare communicator on the ground did not remain the camera eye target.")
	TEST_ASSERT_EQUAL(video_app.check_eye(video_camera_carrier), 0, "The communicator program did not preserve its active remote camera during mob vision processing.")
	TEST_ASSERT(video_app.grants_equipment_vision(video_camera_carrier), "The active communicator camera did not grant normal equipment vision.")
	video_device.ui_close(video_camera_carrier)
	TEST_ASSERT(!video_app.video_call_on && !video_app.video_target, "Closing the communicator UI did not clear the remote-eye state.")
	TEST_ASSERT_NULL(video_app.video_previous_zoom, "Closing the communicator UI did not clear the saved client zoom.")
	video_app.end_call("Unit test ended the video call.")

	TEST_ASSERT(holographic_app.request_voice_call(holographic_peer_app, holographic_peer_app.get_computer_address()), "A holographic communicator could not call its peer.")
	TEST_ASSERT(holographic_peer_app.accept_call(holographic_app), "A holographic communicator could not accept its peer's call.")
	var/mob/living/carbon/human/hologram_caller = new(test_turf)
	holographic_device.forceMove(hologram_caller)
	hologram_caller.set_dir(NORTH)
	var/turf/hologram_north_turf = get_step(test_turf, NORTH)
	TEST_ASSERT_NOTNULL(hologram_north_turf, "The hologram test could not locate the tile in front of its caller.")
	TEST_ASSERT(holographic_app.toggle_hologram(), "The holographic projection could not be enabled.")
	TEST_ASSERT_EQUAL(length(holographic_app.active_call.holograms), 1, "A two-person call did not initially create one remote projection.")
	TEST_ASSERT(holographic_app.request_voice_call(holographic_third_app, holographic_third_app.get_computer_address()), "A holographic communicator could not add a third participant.")
	TEST_ASSERT(holographic_third_app.accept_call(holographic_app), "A third holographic communicator could not join the existing call.")
	TEST_ASSERT_EQUAL(length(holographic_app.active_call.holograms), 2, "Joining an active holographic call did not rebuild one projection per remote participant.")
	var/obj/effect/overlay/hologram/communicator/test_hologram = holographic_app.active_call.holograms[1]
	var/obj/effect/overlay/hologram/communicator/second_test_hologram = holographic_app.active_call.holograms[2]
	TEST_ASSERT_NOTNULL(test_hologram.projection_cone, "The receiver hologram did not create a projection cone.")
	TEST_ASSERT_EQUAL(test_hologram.projection_cone.dir, NORTH, "The projection cone did not point from the caller toward the hologram.")
	TEST_ASSERT_EQUAL(get_turf(test_hologram), get_turf(hologram_caller), "The receiver's hologram did not share its caller's movement anchor.")
	TEST_ASSERT_EQUAL(get_turf(second_test_hologram), get_turf(hologram_caller), "Multiple receiver holograms did not share the caller's movement anchor.")
	TEST_ASSERT_EQUAL(test_hologram.pixel_y, ICON_SIZE_Y, "The receiver's hologram was not rendered one tile in front of its north-facing caller.")
	TEST_ASSERT(test_hologram.pixel_x < second_test_hologram.pixel_x, "Multiple receiver holograms were not offset side by side.")
	TEST_ASSERT_EQUAL(test_hologram.slot_count, 2, "The first receiver hologram was assigned the wrong group size.")
	TEST_ASSERT_EQUAL(second_test_hologram.slot_count, 2, "The second receiver hologram was assigned the wrong group size.")
	TEST_ASSERT_EQUAL(test_hologram.alpha, 100, "The receiver hologram did not apply transparency after flattening its appearance.")
	TEST_ASSERT_EQUAL(test_hologram.color, rgb(125, 180, 225), "The receiver hologram did not apply the standard blue hologram tint.")
	TEST_ASSERT(!length(test_hologram.overlays), "The receiver hologram retained separate visual layers instead of flattening them.")
	TEST_ASSERT_EQUAL(test_hologram.dir, SOUTH, "The receiver's hologram did not face the caller.")
	TEST_ASSERT_EQUAL(test_hologram.name, "hologram of [holographic_peer_app.get_user_name()]", "The projection did not represent the receiving participant.")
	hologram_caller.set_dir(EAST)
	TEST_ASSERT_EQUAL(get_turf(test_hologram), get_turf(hologram_caller), "Turning moved the receiver's hologram away from its caller's movement anchor.")
	TEST_ASSERT(test_hologram.pixel_x > 0, "The receiver's hologram was not rendered in front of its east-facing caller.")
	TEST_ASSERT_EQUAL(test_hologram.dir, WEST, "The receiver's hologram did not keep facing the caller after an update.")
	TEST_ASSERT_EQUAL(test_hologram.glide_size, 0, "A caller direction change tried to glide the hologram around the caller instead of repositioning it first.")
	hologram_caller.glide_size = 13
	hologram_caller.forceMove(hologram_north_turf)
	TEST_ASSERT_EQUAL(get_turf(test_hologram), hologram_north_turf, "The receiver's hologram did not move across the same turfs as its caller.")
	TEST_ASSERT_EQUAL(test_hologram.glide_size, hologram_caller.glide_size, "The receiver's hologram did not inherit its caller's movement glide.")
	var/turf/pre_turn_caller_turf = get_turf(hologram_caller)
	hologram_caller.set_dir(NORTH)
	var/turf/east_destination = get_step(pre_turn_caller_turf, EAST)
	SEND_SIGNAL(hologram_caller, COMSIG_MOVABLE_PRE_MOVE_DIRECTION, east_destination, EAST, TRUE)
	TEST_ASSERT_EQUAL(get_turf(test_hologram), pre_turn_caller_turf, "Preparing a direction-changing move detached the hologram from its caller's movement anchor.")
	TEST_ASSERT(test_hologram.pixel_x > 0, "A direction-changing move did not render the hologram in its new direction before turning its caller.")
	TEST_ASSERT_EQUAL(test_hologram.glide_size, 0, "The hologram tried to glide while preparing for its caller's direction change.")
	TEST_ASSERT(hologram_caller.Move(east_destination, EAST), "The hologram caller could not perform the direction-changing regression-test move.")
	TEST_ASSERT_EQUAL(get_turf(test_hologram), east_destination, "A direction-changing move did not glide the hologram across the same destination turf as its caller.")
	TEST_ASSERT_EQUAL(test_hologram.glide_size, hologram_caller.glide_size, "A direction-changing move did not glide the hologram with its caller.")
	holographic_app.end_call("Unit test ended the holographic call.")

	qdel(first_device)
	qdel(second_device)
	qdel(video_device)
	qdel(holographic_device)
	qdel(holographic_peer)
	qdel(holographic_third)
	qdel(landline)
	qdel(first_id)
	qdel(second_id)
	qdel(video_id)
	qdel(holographic_id)
	qdel(holographic_peer_id)
	qdel(holographic_third_id)
	qdel(video_camera_box)
	qdel(video_camera_bag)
	qdel(video_camera_carrier)
	qdel(landline_user)
	qdel(hologram_caller)
	return TEST_PASS("Communicator calls, shared texting, software restrictions, and bonus tiers work end-to-end.")
