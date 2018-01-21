/datum/hud/proc/ai_hud()
	other = list()

	adding = list(
		new /obj/screen/ai/core,
		new /obj/screen/ai/camera_list,
		new /obj/screen/ai/camera_track,
		new /obj/screen/ai/camera_light,
		new /obj/screen/ai/crew_monitoring,
		new /obj/screen/ai/crew_manifest,
		new /obj/screen/ai/alerts,
		new /obj/screen/ai/announcement,
		new /obj/screen/ai/call_shuttle,
		new /obj/screen/ai/state_laws,
		new /obj/screen/ai/pda_msg,
		new /obj/screen/ai/pda_log,
		new /obj/screen/ai/take_image,
		new /obj/screen/ai/view_image,
		new /obj/screen/ai/sensor_aug,
		new /obj/screen/ai/move_up,
		new /obj/screen/ai/move_down
	)

	mymob.client.screen += adding + other
