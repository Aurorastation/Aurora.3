/obj/item/geiger
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "geiger_off"
	item_state = "geiger"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	action_button_name = "Toggle geiger counter"
	matter = list(MATERIAL_PLASTIC = 100, DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 50)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	var/scanning = 0
	var/radiation_count = 0
	var/datum/sound_token/sound_token
	var/geiger_volume = 0
	var/sound_id

/obj/item/geiger/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance > 1)
		return
	var/msg = "[scanning ? "ambient" : "stored"] Radiation level: <b>[radiation_count ? radiation_count : "0"] IU/s</b>."
	if(radiation_count > RAD_LEVEL_VERY_LOW)
		. += SPAN_WARNING("[msg]")
	else
		. += SPAN_NOTICE("[msg]")

/obj/item/geiger/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"

/obj/item/geiger/proc/update_sound(playing)
	if(playing && !sound_token)
		sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'sound/items/geiger.ogg', volume = geiger_volume, range = 4, falloff = 3, prefer_mute = TRUE)
	else if(!playing && sound_token)
		QDEL_NULL(sound_token)

/obj/item/geiger/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	update_sound(0)
	return ..()

/obj/item/geiger/process()
	if(!scanning)
		return
	radiation_count = SSradiation.get_rads_at_turf(get_turf(src))
	update_icon()

/obj/item/geiger/attack_self(mob/user)
	scanning = !scanning
	if(scanning)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	update_icon()
	to_chat(user, SPAN_NOTICE("[icon2html(src, user)] You switch [scanning ? "on" : "off"] [src]."))

/obj/item/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		update_sound(0)
		return 1

	if(!sound_token) update_sound(1)

	switch(radiation_count)
		if(null) icon_state = "geiger_on_1"
		if(-INFINITY to RAD_LEVEL_VERY_LOW)
			icon_state = "geiger_on_1"
			geiger_volume = 0
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_VERY_LOW + 0.01 to RAD_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
			geiger_volume = 10
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_MODERATE + 0.1 to RAD_LEVEL_HIGH)
			icon_state = "geiger_on_3"
			geiger_volume = 25
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_EXTREME)
			icon_state = "geiger_on_4"
			geiger_volume = 40
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_EXTREME + 1 to INFINITY)
			icon_state = "geiger_on_5"
			geiger_volume = 60
			sound_token.SetVolume(geiger_volume)

/obj/item/geiger/dosimeter
	name = "combination dosimeter"
	desc = "A wrist-worn device for keeping track of recieved radiation doses."
	desc_extended = "This advanced radiation monitor will count up the total radiation it has received, in addition to functioning as a normal geiger counter. For it to accurately account for any protective gear, it must be worn beneath it in the wrist slot. Turn it off to reset the count."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "dosimeter_off"
	item_state = "dosimeter"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_WRISTS
	action_button_name = "Toggle dosimeter counter"
	matter = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 50)
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)

	///The amount of rads the dosimeter has detected after armor mitigation.
	var/current_rate_after_armor = 0
	///The amount of rads the dosimeter had recorded the last time it checked, used to calculate how many new rads have been absorbed since then.
	var/previous_dose = 0
	///The number of rads the dosimeter has recieved, human max is 1000, but the dosimeter will keep counting.
	var/total_dose = 0
	///Counts up as radiation thresholds are reached, giving the user a warning each time.
	var/warning_threshold = 0

/obj/item/geiger/dosimeter/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/msg = "current Dose rate: <b>[round(current_rate_after_armor,1)] IU/s</b>."
	if(current_rate_after_armor > 3)
		. += SPAN_WARNING("[msg]")
	else if (current_rate_after_armor > 10)
		. += SPAN_DANGER("[msg]")
	else
		. += SPAN_NOTICE("[msg]")

	msg = "total absorbed Dose: <b>[round(total_dose,1)] mGy</b>."
	if(total_dose > 250 && total_dose < 500)
		. += SPAN_WARNING("[msg]")
	else if (total_dose > 500)
		. += SPAN_DANGER("[msg]")
	else
		. += SPAN_NOTICE("[msg]")

/obj/item/geiger/dosimeter/attack_self(mob/user)
	scanning = !scanning
	if(scanning)
		START_PROCESSING(SSprocessing, src)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			previous_dose = H.total_radiation
	else
		STOP_PROCESSING(SSprocessing, src)
		total_dose = 0
		warning_threshold = 0
		previous_dose = 0

	to_chat(user, SPAN_NOTICE("[icon2html(src, user)] You switch [src] [scanning ? "on, starting the count" : "off, resetting the count"]."))
	update_icon(user)

/obj/item/geiger/dosimeter/process()
	. = ..()

	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.wrists == src)
			current_rate_after_armor = max(0, H.total_radiation - previous_dose)
			total_dose += current_rate_after_armor //Done this way so we're not making an expensive call to check armour every tick, when apply_damage already does it.
			previous_dose = total_dose
		else
			total_dose += radiation_count
			current_rate_after_armor = radiation_count
	else
		total_dose += radiation_count
		current_rate_after_armor = radiation_count

	switch(total_dose)
		if (100 to 249) //Minor Dose
			if (warning_threshold < 1)
				warning_threshold++
				visible_message(SPAN_NOTICE("\The [src] chimes a notice: Minor dose recieved."), range = 1)
				playsound(src, 'sound/machines/buzz-two.ogg', vol = 20, falloff_exponent = 2)
		if (250 to 499) //Moderate Dose
			if (warning_threshold < 2)
				warning_threshold++
				visible_message(SPAN_WARNING("\The [src] chimes a warning: Moderate dose recieved. Exit radiological zone."), range = 2)
				playsound(src, 'sound/machines/buzz-two.ogg', vol = 40, falloff_exponent = 2)
		if (500 to 749) //Major Dose
			if (warning_threshold < 3)
				warning_threshold++
				visible_message(SPAN_WARNING("\The [src] beeps an alert: Major dose recieved. Exit radiological zone promptly, seek medical attention."), range = 3)
				playsound(src, 'sound/machines/buzz-two.ogg', vol = 60, falloff_exponent = 2)
		if (750 to 998) //Deadly Dose
			if (warning_threshold < 4)
				warning_threshold++
				visible_message(SPAN_DANGER("\The [src] buzzes urgently: Extreme dose recieved! Exit radiological zone immediately, seek urgent medical attention!" ), range = 5)
				playsound(src, 'sound/machines/airalarm.ogg', vol = 60, falloff_exponent = 2)
		if (999 to INFINITY) //Max Dose
			if (warning_threshold < 5)
				warning_threshold++
				visible_message(SPAN_DANGER("\The [src]'s siren screams: FATAL DOSE RECIEVED! RUN FROM RADIOLOGICAL ZONE! LIFE EXPECTANCY WITHOUT TREATMENT IS MINUTES!"), range = 7)
				playsound(src, 'sound/machines/airalarm.ogg', vol = 80, falloff_exponent = 2)

/obj/item/geiger/dosimeter/update_icon()
	if(!scanning)
		icon_state = "dosimeter_off"
		update_sound(0)
		return 1

	if(!sound_token)
		update_sound(1)

	switch(current_rate_after_armor) //Only plays the sound if you are actually taking radiation through your armour.
		if(-INFINITY to RAD_LEVEL_LOW + 1) //You heal 1 rad per second, so this dose isn't dangerous.
			geiger_volume = 0
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_LOW + 1.01 to RAD_LEVEL_MODERATE)
			geiger_volume = 5
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_MODERATE + 0.1 to RAD_LEVEL_HIGH)
			geiger_volume = 10
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH)
			geiger_volume = 20
			sound_token.SetVolume(geiger_volume)
		if(RAD_LEVEL_VERY_HIGH + 1 to INFINITY)
			geiger_volume = 40
			sound_token.SetVolume(geiger_volume)

	switch(total_dose)
		if (-INFINITY to 99)  //Negligable dose
			icon_state = "dosimeter_on_1"
		if (100 to 249) //Minor Dose
			icon_state = "dosimeter_on_2"
		if (250 to 499) //Moderate Dose
			icon_state = "dosimeter_on_3"
		if (500 to 749) //Major Dose
			icon_state = "dosimeter_on_4"
		if (750 to INFINITY) //Deadly Dose
			icon_state = "dosimeter_on_5"
