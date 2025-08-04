/datum/hud/proc/ai_hud()
	other = list()

	var/mob/living/silicon/ai/myai = mymob
	myai.computer.screen_loc = ui_ai_crew_monitor
	myai.computer.layer = HUD_BASE_LAYER

	adding = list(
		new /atom/movable/screen/ai/core,
		new /atom/movable/screen/ai/camera_list,
		new /atom/movable/screen/ai/camera_track,
		new /atom/movable/screen/ai/camera_light,
		new /atom/movable/screen/ai/crew_manifest,
		new /atom/movable/screen/ai/announcement,
		new /atom/movable/screen/ai/call_shuttle,
		new /atom/movable/screen/ai/state_laws,
		new /atom/movable/screen/ai/take_image,
		new /atom/movable/screen/ai/view_image,
		new /atom/movable/screen/ai/sensor_aug,
		new /atom/movable/screen/ai/remote_mech,
		new /atom/movable/screen/ai/move_up,
		new /atom/movable/screen/ai/move_down,
		myai.computer
	)

	mymob.client.screen += adding + other
