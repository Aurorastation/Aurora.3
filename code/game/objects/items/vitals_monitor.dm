/obj/item/vitals_monitor
	name = "vitals monitor"
	desc = "A vitals monitor, used to track a patient's vitality. It needs to be attached to a rollerbed to function."
	icon = 'icons/obj/item/vitals_monitor.dmi'
	icon_state = "vitals_monitor"
	item_state = "vitals_monitor"
	contained_sprite = TRUE

	var/obj/structure/bed/roller/bed
	var/reported_critical = FALSE

/obj/item/vitals_monitor/Destroy()
	bed = null
	return ..()

/obj/item/vitals_monitor/process()
	if(!bed)
		return

	var/mob/living/carbon/human/H
	if(bed?.buckled)
		if(ishuman(bed.buckled))
			H = bed.buckled
		else if(istype(bed.buckled, /obj/structure/closet))
			H = locate() in bed.buckled.contents

	if(!H)
		return

	if(H.is_asystole())
		if(!reported_critical)
			bed.visible_message(SPAN_WARNING("\The [src] flashes red!"))
			playsound(bed.loc, 'sound/machines/airalarm.ogg', 70)
			reported_critical = TRUE
			update_icon()
	else if(reported_critical)
		bed.visible_message(SPAN_NOTICE("\The [src] returns to a normal green."))
		reported_critical = FALSE
		update_icon()

/obj/item/vitals_monitor/proc/update_monitor()
	if(bed)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
		reported_critical = FALSE
	update_icon()

/obj/item/vitals_monitor/update_icon()
	if(bed)
		if(bed.density)
			icon_state = "[initial(icon_state)]-bb"
			layer = bed.buckled.layer + 0.1
		else
			icon_state = "[initial(icon_state)]-b"
			layer = bed.layer + 0.1
	else
		icon_state = initial(icon_state)
		layer = initial(layer)
	if(reported_critical)
		color = color_rotation(-120)
	else
		color = null

/obj/item/vitals_monitor/CtrlClick(var/mob/user)
	if(bed)
		return bed.CtrlClick(user)
	return ..()

/obj/item/vitals_monitor/Click() // attack_hand doesn't work here because it's inside the rollerbed
	if(bed && bed.Adjacent(usr))
		ui_interact(usr)
		return
	return ..()

/obj/item/vitals_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VitalsMonitor", "Vitals Monitor", 480, 300)
		ui.open()

/obj/item/vitals_monitor/ui_status(mob/user, datum/ui_state/state)
	return (bed && bed.Adjacent(user)) ? UI_INTERACTIVE : UI_UPDATE

/obj/item/vitals_monitor/ui_data(mob/user)
	var/list/data = list()

	var/mob/living/carbon/human/H
	if(bed?.buckled)
		if(ishuman(bed.buckled))
			H = bed.buckled
		else if(istype(bed.buckled, /obj/structure/closet))
			H = locate() in bed.buckled.contents

	var/has_occupant = !isnull(H)
	data["has_occupant"] = has_occupant

	if(has_occupant)
		var/displayed_stat = H.stat
		var/blood_oxygenation = H.get_blood_oxygenation()
		if(H.status_flags & FAKEDEATH)
			displayed_stat = DEAD
			blood_oxygenation = min(blood_oxygenation, BLOOD_VOLUME_SURVIVE)

		var/pulse_result
		if(H.should_have_organ(BP_HEART))
			var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
			if(!heart)
				pulse_result = 0
			else if(BP_IS_ROBOTIC(heart))
				pulse_result = -2
			else if(H.status_flags & FAKEDEATH)
				pulse_result = 0
			else
				pulse_result = H.get_pulse(GETPULSE_TOOL)
		else
			pulse_result = -1
		if(pulse_result == ">250")
			pulse_result = -3

		data["stat"] = displayed_stat
		data["brain_activity"] = H.get_brain_result()
		data["blood_pressure"] = H.get_blood_pressure()
		data["blood_pressure_level"] = H.get_blood_pressure_alert()
		data["blood_volume"] = H.get_blood_volume()
		data["blood_o2"] = blood_oxygenation

	return data
