/obj/item/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon = 'icons/obj/holowarrant.dmi'
	icon_state = "holowarrant"
	item_state = "holowarrant"
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTABLE

	var/datum/record/warrant/selected_warrant
	var/datum/crime_incident/fine_incident
	/// Which projector function is currently selected in the control interface.
	var/display_mode = "warrants"
	var/awaiting_payment = FALSE
	var/datum/weakref/payment_issuer
	var/payment_issuer_name
	/// Registered name captured from the recipient's ID when they are scanned.
	var/fine_recipient_name
	/// Account selected when payment is requested. This remains stable if the ID is moved out of a PDA or other holder.
	var/payment_account_number
	/// Registered ID names captured when witnesses are added, keyed by their mob.
	var/list/witness_names = list()
	var/list/fine_presentations = list()

/obj/item/holowarrant/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use this item in-hand to open its warrant and fine interface."
	. += "In the Warrants section, click on a person to display the loaded warrant to them."
	. += "In the Issue Fine section, click on a person to scan their worn ID as the recipient of a fine."
	. += "Once payment is requested, clicking a person while in the Issue Fine section displays the fine. Payment is authorized by tapping the scanned recipient ID against the projector."

/obj/item/holowarrant/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(selected_warrant)
		. += "It is displaying a [selected_warrant.wtype] warrant for '[selected_warrant.name]'."
		. += "The stated reason is: [selected_warrant.notes]"
		. += "It is authorized by: [selected_warrant.authorization]"
	if(awaiting_payment && fine_incident)
		. += "It is awaiting ID authorization for a [fine_incident.fine] credit fine to [fine_recipient_name || "an unavailable recipient"]."

/obj/item/holowarrant/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSrecords, COMSIG_RECORD_CREATED, PROC_REF(handle_warrant_created))

/obj/item/holowarrant/Destroy()
	UnregisterSignal(SSrecords, COMSIG_RECORD_CREATED)
	unload_warrant()
	clear_payment_request()
	QDEL_NULL(fine_incident)
	return ..()

/obj/item/holowarrant/attack_self(mob/living/user as mob)
	ui_interact(user)

/obj/item/holowarrant/proc/load_warrant(var/datum/record/warrant/warrant)
	if(selected_warrant == warrant)
		return
	unload_warrant()
	selected_warrant = warrant
	RegisterSignal(selected_warrant, COMSIG_QDELETING, PROC_REF(handle_warrant_delete))
	RegisterSignal(selected_warrant, COMSIG_RECORD_MODIFIED, PROC_REF(handle_warrant_modify))
	update_icon()

/obj/item/holowarrant/proc/unload_warrant()
	if(selected_warrant)
		UnregisterSignal(selected_warrant, COMSIG_QDELETING)
		UnregisterSignal(selected_warrant, COMSIG_RECORD_MODIFIED)
		selected_warrant = null
		update_icon()

/obj/item/holowarrant/proc/play_message(var/message)
	playsound(get_turf(src), 'sound/machines/ping.ogg', 40)
	audible_message(message)

/// Called when a warrant is created
/obj/item/holowarrant/proc/handle_warrant_created(datum/source, datum/record/record)
	SIGNAL_HANDLER

	if(istype(record, /datum/record/warrant))
		play_message(SPAN_NOTICE("\The [src] pings, \"New warrant on database.\""))

/// Called right before the loaded warrant is deleted
/obj/item/holowarrant/proc/handle_warrant_delete(datum/source)
	SIGNAL_HANDLER

	unload_warrant()
	play_message(SPAN_NOTICE("\The [src] pings, \"Active warrant deleted.\""))

/// Called right after the loaded warrant is modified
/obj/item/holowarrant/proc/handle_warrant_modify(datum/source)
	SIGNAL_HANDLER

	play_message(SPAN_NOTICE("\The [src] pings, \"Active warrant modified.\""))

/obj/item/holowarrant/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(display_mode == "warrants")
		if(!selected_warrant)
			to_chat(user, SPAN_WARNING("There is no warrant loaded."))
			return

		user.visible_message("<b>[user]</b> holds \the [src] up to \the [target_mob].", SPAN_NOTICE("You hold up \the [src] to \the [target_mob]."))
		show_content(target_mob)
		return

	if(awaiting_payment && fine_incident)
		user.visible_message("<b>[user]</b> holds \the [src] up to \the [target_mob].", SPAN_NOTICE("You show the pending fine on \the [src] to \the [target_mob]."))
		show_fine_content(target_mob)
		return

	var/mob/living/carbon/human/human_target = target_mob
	if(istype(human_target))
		var/obj/item/card/id/target_id = human_target.GetIdCard()
		if(istype(target_id) && target_id.registered_name)
			set_fine_target(human_target, target_id)
			to_chat(user, SPAN_NOTICE("Fine recipient set to [target_id.registered_name]."))
		else
			to_chat(user, SPAN_WARNING("Unable to locate a registered ID on [human_target]."))
	else
		to_chat(user, SPAN_WARNING("Only a person wearing a registered ID can be selected as a fine recipient."))

/obj/item/holowarrant/attackby(obj/item/attacking_item, mob/user)
	if(!awaiting_payment || !istype(attacking_item, /obj/item/card/id))
		return ..()

	var/obj/item/card/id/payment_id = attacking_item
	var/mob/living/carbon/human/recipient = fine_incident?.criminal?.resolve()
	if(!istype(recipient))
		to_chat(user, SPAN_WARNING("\The [src] buzzes, \"The scanned recipient is no longer available.\""))
		clear_payment_request()
		return TRUE
	var/mob/living/carbon/human/card_owner = payment_id.mob_id?.resolve()
	if(card_owner != recipient || !payment_account_number || payment_id.associated_account_number != payment_account_number)
		to_chat(user, SPAN_WARNING("\The [src] buzzes, \"This is not the ID registered for the pending fine.\""))
		return TRUE

	var/mob/living/issuer = payment_issuer?.resolve()
	if(!istype(issuer))
		to_chat(user, SPAN_WARNING("\The [src] buzzes, \"The issuing officer is no longer available.\""))
		clear_payment_request()
		return TRUE

	// Use the card which was physically presented. The originally scanned card may
	// have moved through a PDA or another ID holder since the recipient was set.
	fine_incident.card = WEAKREF(payment_id)
	var/list/result = fine_incident.processFine(issuer, "Warrant Projector", fine_recipient_name)
	if(result["error"])
		var/error = result["error"]
		to_chat(user, SPAN_WARNING("\The [src] buzzes, \"[error]\""))
		return TRUE

	var/recipient_name = fine_recipient_name
	var/obj/item/paper/receipt = new /obj/item/paper(get_turf(src))
	receipt.name = "fine receipt - [recipient_name]"
	receipt.set_content_unsafe("Fine Receipt", result["report"])
	play_message(SPAN_NOTICE("\The [src] pings, \"Payment authorized. [recipient_name] has been fined. Receipt printed.\""))
	clear_payment_request()
	QDEL_NULL(fine_incident)
	fine_recipient_name = null
	witness_names = list()
	return TRUE

/obj/item/holowarrant/update_icon()
	if(selected_warrant)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/holowarrant/proc/show_content(mob/user)
	if(!selected_warrant)
		return
	var/datum/warrant_presentation/presentation = new(selected_warrant)
	presentation.ui_interact(user)

/obj/item/holowarrant/proc/show_fine_content(mob/user)
	if(!fine_incident || !awaiting_payment)
		return
	var/datum/fine_presentation/presentation = new(src)
	fine_presentations += presentation
	presentation.ui_interact(user)

/obj/item/holowarrant/proc/get_security_id(mob/user)
	if(issilicon(user))
		return
	var/obj/item/card/id/id_card = user.GetIdCard()
	if(istype(id_card) && id_card.registered_name && (/datum/access/security::id in id_card.access))
		return id_card

/obj/item/holowarrant/proc/set_fine_target(mob/living/carbon/human/target, obj/item/card/id/target_id)
	clear_payment_request()
	QDEL_NULL(fine_incident)
	fine_recipient_name = target_id.registered_name
	witness_names = list()
	fine_incident = new()
	fine_incident.criminal = WEAKREF(target)
	fine_incident.card = WEAKREF(target_id)

/obj/item/holowarrant/proc/clear_payment_request()
	awaiting_payment = FALSE
	payment_issuer = null
	payment_issuer_name = null
	payment_account_number = null
	var/list/old_presentations = fine_presentations
	fine_presentations = list()
	QDEL_LIST(old_presentations)

/obj/item/holowarrant/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarrantProjector", "Warrant Projector", 850, 700)
		ui.open()

/obj/item/holowarrant/ui_data(mob/user)
	var/list/data = list()
	data["presentation"] = FALSE
	data["display_mode"] = display_mode
	data["authenticated"] = !!get_security_id(user)
	data["awaiting_payment"] = awaiting_payment
	data["payment_issuer"] = payment_issuer_name
	data["facility"] = SSatlas.current_map.station_name
	data["date"] = worlddate2text()

	var/list/warrants = list()
	for(var/datum/record/warrant/warrant in SSrecords.warrants)
		warrants += list(list(
			"id" = warrant.id,
			"name" = warrant.name,
			"notes" = warrant.notes,
			"authorization" = warrant.authorization,
			"wtype" = warrant.wtype
		))
	data["warrants"] = warrants
	data["selected_warrant"] = selected_warrant ? warrant_to_ui_data(selected_warrant) : null

	data["fine_recipient"] = null
	data["fine"] = 0
	data["fine_min"] = 0
	data["fine_max"] = 0
	data["fine_notes"] = ""
	data["fine_charges"] = list()
	data["witnesses"] = list()
	data["evidence"] = list()
	if(fine_incident)
		data["fine_recipient"] = fine_recipient_name
		data["fine"] = fine_incident.fine
		data["fine_min"] = fine_incident.getMinFine()
		data["fine_max"] = fine_incident.getMaxFine()
		data["fine_notes"] = fine_incident.notes
		var/list/fine_charges = list()
		for(var/datum/law/charge in fine_incident.charges)
			fine_charges += charge.name
		data["fine_charges"] = fine_charges

		var/list/witness_data = list()
		var/list/witnesses = fine_incident.arbiters["Witness"]
		for(var/mob/living/carbon/human/witness in witnesses)
			witness_data += list(list(
				"name" = witness_names[witness] || witness.name,
				"notes" = witnesses[witness] || "",
				"ref" = REF(witness)
			))
		data["witnesses"] = witness_data

		var/list/evidence_data = list()
		for(var/obj/item/evidence_item in fine_incident.evidence)
			evidence_data += list(list(
				"name" = evidence_item.name,
				"notes" = fine_incident.evidence[evidence_item] || "",
				"ref" = REF(evidence_item)
			))
		data["evidence"] = evidence_data

	var/list/fineable_laws = list()
	for(var/datum/law/law in SSlaw.laws)
		if(!law.can_fine() || law.felony)
			continue
		fineable_laws += list(list(
			"id" = law.id,
			"name" = law.name,
			"description" = law.desc,
			"minimum" = law.min_fine,
			"maximum" = law.max_fine,
			"selected" = fine_incident && (law in fine_incident.charges)
		))
	data["fineable_laws"] = fineable_laws
	return data

/obj/item/holowarrant/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "load_warrant")
		var/warrant_id = text2num(params["id"])
		for(var/datum/record/warrant/warrant in SSrecords.warrants)
			if(warrant.id == warrant_id)
				load_warrant(warrant)
				play_message(SPAN_NOTICE("\The [src] pings, \"Warrant loaded.\""))
				return TRUE
		return TRUE

	if(action == "unload_warrant")
		unload_warrant()
		play_message(SPAN_NOTICE("\The [src] pings, \"Warrant unloaded.\""))
		return TRUE

	if(action == "set_display_mode")
		if(params["mode"] in list("warrants", "fines"))
			display_mode = params["mode"]
		return TRUE

	var/mob/living/user = usr
	if(!istype(user))
		return TRUE

	if(action == "clear_recipient")
		if(awaiting_payment)
			to_chat(user, SPAN_WARNING("Cancel the pending payment request before clearing the recipient."))
			return TRUE
		clear_payment_request()
		QDEL_NULL(fine_incident)
		fine_recipient_name = null
		witness_names = list()
		return TRUE

	if(action == "cancel_payment")
		if(!get_security_id(user))
			to_chat(user, SPAN_WARNING("Authentication error: An ID with security access is required to cancel this payment request."))
			return TRUE
		clear_payment_request()
		play_message(SPAN_NOTICE("\The [src] pings, \"Payment request cancelled.\""))
		return TRUE

	if(!fine_incident)
		to_chat(user, SPAN_WARNING("Scan a recipient with the projector first."))
		return TRUE

	if(awaiting_payment)
		to_chat(user, SPAN_WARNING("Cancel the pending payment request before modifying the fine."))
		return TRUE

	switch(action)
		if("add_witness")
			var/obj/item/card/id/witness_id = user.get_active_hand()
			if(witness_id == src)
				witness_id = user.get_inactive_hand()
			if(!istype(witness_id))
				to_chat(user, SPAN_WARNING("Hold the witness's registered ID in your other hand."))
				return TRUE
			var/mob/living/carbon/human/witness = witness_id.mob_id?.resolve()
			if(!istype(witness))
				to_chat(user, SPAN_WARNING("The held ID is not tied to an SCC employee."))
				return TRUE
			if(!witness_id.registered_name)
				to_chat(user, SPAN_WARNING("The held ID has no registered name."))
				return TRUE
			if(witness in fine_incident.arbiters["Witness"])
				to_chat(user, SPAN_WARNING("[witness] is already listed as a witness."))
				return TRUE
			var/error = fine_incident.addArbiter(witness_id, "Witness")
			if(error)
				to_chat(user, SPAN_WARNING("\The [src] buzzes, \"[error]\""))
			else
				witness_names[witness] = witness_id.registered_name
			return TRUE

		if("remove_witness")
			var/mob/living/carbon/human/witness = locate(params["ref"])
			var/list/witnesses = fine_incident.arbiters["Witness"]
			if(witness in witnesses)
				witnesses -= witness
				witness_names -= witness
			return TRUE

		if("edit_witness_notes")
			var/mob/living/carbon/human/witness = locate(params["ref"])
			var/list/witnesses = fine_incident.arbiters["Witness"]
			if(!(witness in witnesses))
				return TRUE
			var/new_notes = tgui_input_text(user, "Summarize what the witness said.", "Witness Report", witnesses[witness], MAX_PAPER_MESSAGE_LEN, TRUE)
			if(!isnull(new_notes))
				witnesses[witness] = sanitize(new_notes, MAX_PAPER_MESSAGE_LEN, extra = 0)
			return TRUE

		if("add_evidence")
			var/obj/item/evidence_item = user.get_active_hand()
			if(evidence_item == src)
				evidence_item = user.get_inactive_hand()
			if(!istype(evidence_item) || evidence_item == src)
				to_chat(user, SPAN_WARNING("Hold the evidence item in your other hand."))
				return TRUE
			if(evidence_item in fine_incident.evidence)
				to_chat(user, SPAN_WARNING("[evidence_item] is already listed as evidence."))
				return TRUE
			fine_incident.evidence += evidence_item
			return TRUE

		if("remove_evidence")
			var/obj/item/evidence_item = locate(params["ref"])
			if(evidence_item in fine_incident.evidence)
				fine_incident.evidence -= evidence_item
			return TRUE

		if("edit_evidence_notes")
			var/obj/item/evidence_item = locate(params["ref"])
			if(!(evidence_item in fine_incident.evidence))
				return TRUE
			var/new_notes = tgui_input_text(user, "Describe the relevance of this evidence.", "Evidence Report", fine_incident.evidence[evidence_item], MAX_PAPER_MESSAGE_LEN, TRUE)
			if(!isnull(new_notes))
				fine_incident.evidence[evidence_item] = sanitize(new_notes, MAX_PAPER_MESSAGE_LEN, extra = 0)
			return TRUE

		if("toggle_charge")
			for(var/datum/law/law in SSlaw.laws)
				if(law.id != params["id"] || !law.can_fine() || law.felony)
					continue
				if(law in fine_incident.charges)
					fine_incident.charges -= law
				else
					fine_incident.charges += law
				fine_incident.refreshSentences()
				fine_incident.fine = fine_incident.getMinFine()
				break
			return TRUE

		if("set_fine")
			fine_incident.fine = round(text2num(params["fine"]), 0.01)
			return TRUE

		if("edit_notes")
			var/new_notes = tgui_input_text(user, "Briefly describe the incident.", "Fine Incident Summary", fine_incident.notes, MAX_PAPER_MESSAGE_LEN, TRUE)
			if(!isnull(new_notes))
				fine_incident.notes = sanitize(new_notes, MAX_PAPER_MESSAGE_LEN, extra = 0)
			return TRUE

		if("issue_fine")
			if(!get_security_id(user))
				to_chat(user, SPAN_WARNING("Authentication error: Unable to locate an ID with security access."))
				return TRUE
			var/obj/item/card/id/target_id = fine_incident.card?.resolve()
			if(!istype(target_id))
				to_chat(user, SPAN_WARNING("The scanned ID is no longer available."))
				return TRUE
			var/list/validation = fine_incident.validateFine()
			if(validation["error"])
				var/error = validation["error"]
				to_chat(user, SPAN_WARNING("\The [src] buzzes, \"[error]\""))
				return TRUE
			var/obj/item/card/id/issuer_id = get_security_id(user)
			payment_account_number = target_id.associated_account_number
			awaiting_payment = TRUE
			payment_issuer = WEAKREF(user)
			payment_issuer_name = "[issuer_id.registered_name] - [issuer_id.assignment ? issuer_id.assignment : "(Unknown)"]"
			play_message(SPAN_NOTICE("\The [src] pings, \"Fine prepared. Awaiting the recipient's ID authorization.\""))
			return TRUE

/obj/item/holowarrant/proc/warrant_to_ui_data(datum/record/warrant/warrant)
	return list(
		"id" = warrant.id,
		"name" = warrant.name,
		"notes" = warrant.notes,
		"authorization" = warrant.authorization,
		"wtype" = warrant.wtype
	)

/// A short-lived, read-only TGUI shown to the person being served a warrant.
/datum/warrant_presentation
	var/datum/record/warrant/warrant

/datum/warrant_presentation/New(datum/record/warrant/new_warrant)
	. = ..()
	warrant = new_warrant
	RegisterSignal(warrant, COMSIG_QDELETING, PROC_REF(handle_warrant_delete))

/datum/warrant_presentation/Destroy()
	if(warrant)
		UnregisterSignal(warrant, COMSIG_QDELETING)
		warrant = null
	return ..()

/datum/warrant_presentation/proc/handle_warrant_delete(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/warrant_presentation/ui_state(mob/user)
	return GLOB.always_state

/datum/warrant_presentation/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarrantProjector", "Digital Warrant", 700, 650)
		ui.open()

/datum/warrant_presentation/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/warrant_presentation/ui_data(mob/user)
	if(!warrant)
		return list()
	return list(
		"presentation" = TRUE,
		"facility" = SSatlas.current_map.station_name,
		"date" = worlddate2text(),
		"selected_warrant" = list(
			"id" = warrant.id,
			"name" = warrant.name,
			"notes" = warrant.notes,
			"authorization" = warrant.authorization,
			"wtype" = warrant.wtype
		)
	)

/// A short-lived, read-only TGUI showing a fine which is awaiting ID authorization.
/datum/fine_presentation
	var/obj/item/holowarrant/projector

/datum/fine_presentation/New(obj/item/holowarrant/new_projector)
	. = ..()
	projector = new_projector

/datum/fine_presentation/Destroy()
	if(projector)
		projector.fine_presentations -= src
		projector = null
	return ..()

/datum/fine_presentation/ui_state(mob/user)
	return GLOB.always_state

/datum/fine_presentation/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WarrantProjector", "Digital Fine Notice", 700, 650)
		ui.open()

/datum/fine_presentation/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/fine_presentation/ui_data(mob/user)
	if(!projector?.fine_incident || !projector.awaiting_payment)
		return list()

	var/datum/crime_incident/incident = projector.fine_incident
	var/list/charge_names = list()
	for(var/datum/law/charge in incident.charges)
		charge_names += charge.name

	return list(
		"presentation" = TRUE,
		"fine_presentation" = TRUE,
		"facility" = SSatlas.current_map.station_name,
		"date" = worlddate2text(),
		"fine_recipient" = projector.fine_recipient_name,
		"fine" = incident.fine,
		"fine_notes" = incident.notes,
		"fine_charges" = charge_names,
		"payment_issuer" = projector.payment_issuer_name
	)
