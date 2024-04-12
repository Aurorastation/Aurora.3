// AI and Borg screen objects be here.

/obj/screen/module
	dir = SOUTHWEST
	icon = 'icons/mob/screen/robot.dmi'
	var/mod_pos

/obj/screen/module/one
	name = "module1"
	icon_state = "inv1"
	screen_loc = ui_inv1
	mod_pos = 1

/obj/screen/module/two
	name = "module2"
	icon_state = "inv2"
	screen_loc = ui_inv2
	mod_pos = 2

/obj/screen/module/three
	name = "module3"
	icon_state = "inv3"
	screen_loc = ui_inv3
	mod_pos = 3

/obj/screen/module/Click()
	if (!istype(usr, /mob/living/silicon/robot))
		return

	ASSERT(mod_pos != null)

	var/mob/living/silicon/robot/R = usr
	R.toggle_module(mod_pos)

/obj/screen/ai
	icon = 'icons/mob/screen/ai.dmi'

/obj/screen/ai/core
	name = "AI Core"
	icon_state = "ai_core"
	screen_loc = ui_ai_core

/obj/screen/ai/core/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.view_core()

/obj/screen/ai/camera_list
	name = "Show Camera List"
	icon_state = "camera"
	screen_loc = ui_ai_camera_list

/obj/screen/ai/camera_list/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		var/camera = tgui_input_list(AI, "Select a camera.", "Show Camera List", AI.get_camera_list())
		if (camera)
			AI.ai_camera_list(camera)

/obj/screen/ai/camera_track
	name = "Track With Camera"
	icon_state = "track"
	screen_loc = ui_ai_track_with_camera

/obj/screen/ai/camera_track/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		var/target_name = tgui_input_list(AI, "Select a mob to track.", "Track With Camera", AI.trackable_mobs())
		if (target_name)
			AI.ai_camera_track(target_name)

/obj/screen/ai/camera_light
	name = "Toggle Camera Light"
	icon_state = "camera_light"
	screen_loc = ui_ai_camera_light

/obj/screen/ai/camera_light/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.toggle_camera_light()

/obj/screen/ai/crew_manifest
	name = "Show Crew Manifest"
	icon_state = "manifest"
	screen_loc = ui_ai_crew_manifest

/obj/screen/ai/crew_manifest/Click()
	if (isAI(usr))
		SSrecords.open_manifest_tgui(usr)

/obj/screen/ai/announcement
	name = "Announcement"
	icon_state = "announcement"
	screen_loc = ui_ai_announcement

/obj/screen/ai/announcement/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.ai_announcement()

/obj/screen/ai/call_shuttle
	name = "Call Evacuation"
	icon_state = "call_shuttle"
	screen_loc = ui_ai_shuttle

/obj/screen/ai/call_shuttle/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.ai_call_shuttle()

/obj/screen/ai/state_laws
	name = "State Laws"
	icon_state = "state_laws"
	screen_loc = ui_ai_state_laws

/obj/screen/ai/state_laws/Click()
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.computer.ui_interact(usr)
		AI.computer.run_program("lawmanager")

/obj/screen/ai/take_image
	name = "Take Image"
	icon_state = "take_picture"
	screen_loc = ui_ai_take_picture

/obj/screen/ai/take_image/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.ai_camera.toggle_camera_mode()

/obj/screen/ai/view_image
	name = "View Images"
	icon_state = "view_images"
	screen_loc = ui_ai_view_images

/obj/screen/ai/view_image/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.ai_camera.viewpictures()

/obj/screen/ai/sensor_aug
	name = "Set Sensor Augmentation"
	icon_state = "ai_sensor"
	screen_loc = ui_ai_sensor

/obj/screen/ai/sensor_aug/Click()
	if (isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		AI.sensor_mode()

/obj/screen/ai/remote_mech
	name = "Remote Control Shell"
	icon_state = "remote_mech"
	screen_loc = ui_ai_mech

/obj/screen/ai/remote_mech/Click()
	if(isAI(usr))
		var/mob/living/silicon/ai/AI = usr
		if(AI.anchored)
			AI.remote_control_shell()
		else
			to_chat(AI, SPAN_WARNING("You are unable to get a good connection while unanchored from the station systems."))

/obj/screen/ai/move_up
	name = "Move Up"
	icon_state = "move_up"
	screen_loc = ui_ai_move_up

/obj/screen/ai/move_up/Click()
	if (isAI(usr))
		usr.up()

/obj/screen/ai/move_down
	name = "Move Down"
	icon_state = "move_down"
	screen_loc = ui_ai_move_down

/obj/screen/ai/move_down/Click()
	if (isAI(usr))
		usr.down()
