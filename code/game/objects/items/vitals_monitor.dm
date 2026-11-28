/obj/item/vitals_monitor
	name = "vitals monitor"
	desc = "A vitals monitor, used to track a patient's vitality. It needs to be attached to a rollerbed to function."
	icon = 'icons/obj/item/vitals_monitor.dmi'
	icon_state = "vitals_monitor"
	item_state = "vitals_monitor"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_HUGE

	var/obj/structure/bed/roller/bed
	var/reported_critical = FALSE
	var/obj/item/vitals_monitor_offhand/offhand_grip
	var/next_ui_update = 0

/obj/item/vitals_monitor/Initialize()
	. = ..()
	LoadComponent(/datum/component/health_analyzer/vitals)

/obj/item/vitals_monitor/Destroy()
	bed = null
	clear_offhand_grip()
	return ..()

/obj/item/vitals_monitor/proc/clear_offhand_grip()
	var/obj/item/vitals_monitor_offhand/grip = offhand_grip
	offhand_grip = null
	if(grip)
		grip.linked = null
		if(!QDELETED(grip))
			qdel(grip)

/obj/item/vitals_monitor/proc/get_patient()
	if(ishuman(bed?.buckled))
		return bed.buckled
	if(istype(bed?.buckled, /obj/structure/closet))
		return locate(/mob/living/carbon/human) in bed.buckled.contents

/obj/item/vitals_monitor/process()
	if(!bed)
		return PROCESS_KILL

	var/mob/living/carbon/human/H = get_patient()
	var/datum/component/health_analyzer/vitals/analyzer = GetComponent(/datum/component/health_analyzer/vitals)
	if(world.time >= next_ui_update && LAZYLEN(analyzer.open_uis))
		next_ui_update = world.time + 2 SECONDS
		SStgui.update_uis(analyzer)

	if(!H)
		if(reported_critical)
			reported_critical = FALSE
			update_icon()
		return

	if(H.is_asystole())
		if(!reported_critical)
			bed.visible_message(SPAN_WARNING("\The [src] flashes red!"), visible_message_flags = LOCAL_MESSAGE)
			playsound(bed.loc, 'sound/machines/airalarm.ogg', 70)
			reported_critical = TRUE
			update_icon()
	else if(reported_critical)
		bed.visible_message(SPAN_NOTICE("\The [src] returns to a normal green."), visible_message_flags = LOCAL_MESSAGE)
		reported_critical = FALSE
		update_icon()

/obj/item/vitals_monitor/proc/update_monitor()
	if(bed)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
		reported_critical = FALSE
		next_ui_update = 0
		var/datum/component/health_analyzer/vitals/analyzer = GetComponent(/datum/component/health_analyzer/vitals)
		analyzer.clear_scan()
		SStgui.close_uis(analyzer)
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
		var/datum/component/health_analyzer/vitals/analyzer = GetComponent(/datum/component/health_analyzer/vitals)
		analyzer.ui_interact(usr)
		return
	return ..()

/obj/item/vitals_monitor/do_additional_pickup_checks(mob/user)
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You need two hands to lift \the [src]!"))
		return FALSE
	if(user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need your other hand to be empty to lift \the [src]!"))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/external/inactive_hand = H.get_organ(user.hand ? BP_L_HAND : BP_R_HAND)
	if(!inactive_hand || !inactive_hand.is_usable())
		to_chat(user, SPAN_WARNING("You need two usable hands to lift \the [src]!"))
		return FALSE
	return TRUE

/obj/item/vitals_monitor/pickup(mob/user)
	. = ..()
	var/obj/item/vitals_monitor_offhand/grip = new(user)
	grip.name = "[name] - second hand"
	grip.desc = "Your second grip on \the [name]."
	grip.linked = src
	user.put_in_inactive_hand(grip)
	offhand_grip = grip

/obj/item/vitals_monitor/dropped(mob/user)
	clear_offhand_grip()
	return ..()

/obj/item/vitals_monitor/can_swap_hands(mob/user)
	return !offhand_grip

/obj/item/vitals_monitor_offhand
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	name = "second hand"
	drop_sound = null
	pickup_sound = null
	equip_sound = null
	var/obj/item/vitals_monitor/linked

/obj/item/vitals_monitor_offhand/dropped(mob/user)
	. = ..()
	var/obj/item/vitals_monitor/monitor = linked
	linked = null
	if(monitor)
		monitor.offhand_grip = null
		if(user)
			user.drop_from_inventory(monitor)
	if(!QDELETED(src))
		qdel(src)
