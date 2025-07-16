/obj/item/device/geiger
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	icon = 'icons/obj/geiger_counter.dmi'
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = WEIGHT_CLASS_SMALL
	action_button_name = "Toggle geiger counter"
	matter = list(MATERIAL_PLASTIC = 100, DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 50)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	var/scanning = 0
	var/radiation_count = 0
	var/datum/sound_token/sound_token
	var/geiger_volume = 0
	var/sound_id

/obj/item/device/geiger/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/msg = "[scanning ? "ambient" : "stored"] Radiation level: <b>[radiation_count ? radiation_count : "0"] IU/s</b>."
	if(radiation_count > RAD_LEVEL_LOW)
		. += SPAN_WARNING("[msg]")
	else
		. += SPAN_NOTICE("[msg]")

/obj/item/device/geiger/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"

/obj/item/device/geiger/proc/update_sound(playing)
	if(playing && !sound_token)
		sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'sound/items/geiger.ogg', volume = geiger_volume, range = 4, falloff = 3, prefer_mute = TRUE)
	else if(!playing && sound_token)
		QDEL_NULL(sound_token)

/obj/item/device/geiger/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)
	update_sound(0)

/obj/item/device/geiger/process()
	if(!scanning)
		return
	radiation_count = SSradiation.get_rads_at_turf(get_turf(src))
	update_icon()

/obj/item/device/geiger/attack_self(mob/user)
	scanning = !scanning
	if(scanning)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	update_icon()
	to_chat(user, SPAN_NOTICE("[icon2html(src, user)] You switch [scanning ? "on" : "off"] [src]."))

/obj/item/device/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		update_sound(0)
		return 1

	if(!sound_token) update_sound(1)

	switch(radiation_count)
		if(null) icon_state = "geiger_on_1"
		if(-INFINITY to RAD_LEVEL_LOW)
			icon_state = "geiger_on_1"
			geiger_volume = 0
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_LOW + 0.01 to RAD_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
			geiger_volume = 10
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_MODERATE + 0.1 to RAD_LEVEL_HIGH)
			icon_state = "geiger_on_3"
			geiger_volume = 25
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			icon_state = "geiger_on_4"
			geiger_volume = 40
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_VERY_HIGH + 1 to INFINITY)
			icon_state = "geiger_on_5"
			geiger_volume = 60
			sound_token.SetVolume(geiger_volume)
