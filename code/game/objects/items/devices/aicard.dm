/obj/item/aicard
	name = "intelliCard"
	icon = 'icons/obj/pai.dmi'
	icon_state = "aicard" // aicard-full
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	var/flush = null
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)

	var/mob/living/silicon/ai/carded_ai

/obj/item/aicard/examine(mob/user)
	..()
	var/message = "Status of [carded_ai] is: "
	if(!carded_ai)
		message = "There is no AI loaded to the card."
	else if(carded_ai.stat == DEAD)
		message += SPAN_DANGER("terminated.")
	else if(!carded_ai.client)
		message += SPAN_NOTICE("active.")
	else
		message += SPAN_WARNING("inactive.")
	to_chat(user, message)

/obj/item/aicard/attack(mob/living/silicon/decoy/M as mob, mob/user as mob, var/target_zone)
	if (!istype (M, /mob/living/silicon/decoy))
		return ..()
	else
		M.death()
		to_chat(user, "<b>ERROR ERROR ERROR</b>")

/obj/item/aicard/attack_self(mob/user)
	ui_interact(user)

/obj/item/aicard/ui_interact(mob/user, datum/topic_state/state = inventory_state)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)

	if (!ui)
		ui = new(user, src, "devices-aicard", 600, 400, "[name]", state = state)
		ui.auto_update_content = TRUE

	ui.open()

/obj/item/aicard/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = list(
		"has_ai" = FALSE,
		"name" = null,
		"hardware_integrity" = null,
		"backup_capacitor" = null,
		"radio" = null,
		"wireless" = null,
		"operational" = null,
		"flushing" = FALSE,
		"laws" = null,
		"has_laws" = null
	)

	data["has_ai"] = carded_ai != null
	if (carded_ai)
		data["name"] = carded_ai.name
		data["hardware_integrity"] = carded_ai.hardware_integrity()
		data["backup_capacitor"] = carded_ai.backup_capacitor()
		data["radio"] = !carded_ai.ai_radio?.disabledAi
		data["wireless"] = !carded_ai.control_disabled
		data["operational"] = carded_ai.stat != DEAD
		data["flushing"] = flush

		var/list/laws = list()
		for(var/datum/ai_law/AL in carded_ai.laws.all_laws())
			laws[++laws.len] = list("index" = AL.get_index(), "law" = sanitize(AL.law))
		data["laws"] = laws
		data["has_laws"] = !!laws.len

	return data

/obj/item/aicard/Topic(href, href_list, state)
	if (..())
		return 1

	if (!carded_ai)
		return 1

	if (href_list["wipe"])
		var/confirm = alert("Are you sure you want to wipe this card's memory? This cannot be undone once started.", "Confirm Wipe", "Yes", "No")
		if(confirm == "Yes" && (CanUseTopic(usr, state) == STATUS_INTERACTIVE))
			admin_attack_log(usr, carded_ai, "Wiped using \the [src.name]", "Was wiped with \the [src.name]", "used \the [src.name] to wipe")
			flush = 1
			to_chat(carded_ai, "Your core files are being wiped!")
			while (carded_ai && carded_ai.stat != DEAD)
				carded_ai.adjustOxyLoss(2)
				carded_ai.updatehealth()
				sleep(10)
			flush = 0
	if (!isnull(href_list["radio"]))
		carded_ai.ai_radio.disabledAi = text2num(href_list["radio"])
		to_chat(carded_ai, "<span class='warning'>Your Subspace Transceiver has been [carded_ai.ai_radio.disabledAi ? "disabled" : "enabled"]!</span>")
		to_chat(usr, "<span class='notice'>You [carded_ai.ai_radio.disabledAi ? "disable" : "enable"] the AI's Subspace Transceiver.</span>")
	if (!isnull(href_list["wireless"]))
		carded_ai.control_disabled = text2num(href_list["wireless"])
		to_chat(carded_ai, "<span class='warning'>Your wireless interface has been [carded_ai.control_disabled ? "disabled" : "enabled"]!</span>")
		to_chat(usr, "<span class='notice'>You [carded_ai.control_disabled ? "disable" : "enable"] the AI's wireless interface.</span>")
		update_icon()
	return 1

/obj/item/aicard/update_icon()
	cut_overlays()
	if(carded_ai)
		if (!carded_ai.control_disabled)
			add_overlay("aicard-on")
		if(carded_ai.stat)
			icon_state = "aicard-404"
		else
			icon_state = "aicard-full"
	else
		icon_state = "aicard"

/obj/item/aicard/proc/grab_ai(var/mob/living/silicon/ai/ai, var/mob/living/user)
	if(!ai.client)
		to_chat(user, "<span class='danger'>ERROR:</span> AI [ai.name] is offline. Unable to download.")
		return 0

	if(carded_ai)
		to_chat(user, "<span class='danger'>Transfer failed:</span> Existing AI found on remote terminal. Remove existing AI to install a new one.")
		return 0

	if(ai.is_malf() && ai.stat != DEAD)
		to_chat(user, "<span class='danger'>ERROR:</span> Remote transfer interface disabled.")
		return 0

	if(istype(ai.loc, /turf/))
		new /obj/structure/AIcore/deactivated(get_turf(ai))

	ai.carded = 1
	admin_attack_log(user, ai, "Carded with [src.name]", "Was carded with [src.name]", "used the [src.name] to card")
	src.name = "[initial(name)] - [ai.name]"

	ai.forceMove(src)
	ai.destroy_eyeobj(src)
	ai.cancel_camera()
	ai.control_disabled = 1
	ai.ai_restore_power_routine = 0
	carded_ai = ai

	if(ai.client)
		to_chat(ai, "You have been downloaded to a mobile storage device. Remote access lost.")
	if(user.client)
		to_chat(user, "<span class='notice'><b>Transfer successful:</b></span> [ai.name] ([rand(1000,9999)].exe) removed from host terminal and stored within local memory.")

	ai.canmove = 1
	update_icon()
	return 1

/obj/item/aicard/proc/clear()
	if(carded_ai && istype(carded_ai.loc, /turf))
		carded_ai.canmove = 0
		carded_ai.carded = 0
	name = initial(name)
	carded_ai = null
	update_icon()

/obj/item/aicard/see_emote(mob/living/M, text)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[text]</span>"
		carded_ai.show_message(rendered, 2)
	..()

/obj/item/aicard/show_message(msg, type, alt, alt_type)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		carded_ai.show_message(rendered, type)
	..()

/obj/item/aicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)
