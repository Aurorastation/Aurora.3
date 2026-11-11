//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = WEIGHT_CLASS_SMALL
	/// The item stored in the evidence bag
	var/obj/item/stored_item
	/// The label on the evidence bag
	var/label_text = ""
	/// Who collected the item
	var/collected_by = ""
	/// Where the item was collected
	var/collected_location = ""
	/// WHen the item was collected
	var/collected_time = ""

/obj/item/evidencebag/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click drag this onto an object to put it inside."
	. += "Click it in-hand to remove an object from it."

/obj/item/evidencebag/Initialize()
	. = ..()
	AddComponent(/datum/component/base_name, name)

/obj/item/evidencebag/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	var/mob/living/carbon/human/human_user = user
	var/obj/item/I = over
	if(!istype(human_user) || !istype(I))
		return

	if (!(human_user.l_hand == src || human_user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!human_user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage))	//in a container.
			var/sdepth = I.storage_depth(human_user)
			if (sdepth == -1 || sdepth > 1)
				return	//too deeply nested to access

			var/obj/item/storage/U = I.loc
			human_user.client.screen -= I
			U.contents.Remove(I)
		else if(human_user.l_hand == I)					//in a hand
			human_user.drop_l_hand()
		else if(human_user.r_hand == I)					//in a hand
			human_user.drop_r_hand()
		else
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/evidencebag))
		to_chat(human_user, SPAN_NOTICE("You find putting a plastic bag in another plastic bag to be slightly absurd and think better of it."))
		return

	if(I.w_class > 3)
		to_chat(human_user, SPAN_NOTICE("[I] won't fit in [src]."))
		return

	if(contents.len)
		to_chat(human_user, SPAN_NOTICE("[src] already has something inside it."))
		return

	human_user.visible_message("<b>[human_user]</b> puts \the [I] into \the [src].", SPAN_NOTICE("You put \the [I] inside \the [src]."),\
	"You hear a rustle as someone puts something into a plastic bag.")
	store_item(I, user)

/obj/item/evidencebag/proc/store_item(obj/item/I, mob/user)
	icon_state = "evidence"
	var/mutable_appearance/MA = new(I)
	MA.pixel_x = 0
	MA.pixel_y = 0
	MA.layer = FLOAT_LAYER
	AddOverlays(list(MA, "evidence"))

	var/forensic = GET_SKILL_LEVEL(user, FORENSICS_SKILL_COMPONENT)
	forensic = forensic ? forensic : SKILL_LEVEL_TRAINED

	// Trained people would know to add this data
	if(forensic >= SKILL_LEVEL_FAMILIAR)
		collected_location = get_area_display_name(get_area(I))
		collected_by = user.name
		collected_time = worldtime2text()
	// And untrained people risk contaminating it
	else if (prob(25))
		I.add_fingerprint(user)
	desc = "A plastic bag containing [I]."
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class


/obj/item/evidencebag/attack_self(mob/user as mob)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("<b>[user]</b> takes \the [I] out of \the [src].", SPAN_NOTICE("You take \the [I] out of \the [src]."),\
		"You hear someone rustle around in a plastic bag, and remove something.")
		ClearOverlays()	//remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."
	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return

/obj/item/evidencebag/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(label_text)
		. += SPAN_NOTICE("It is labelled: \"[label_text]\".")

	if(collected_by)
		. += SPAN_NOTICE("Collected by: [collected_by].")

	if(collected_location)
		. += SPAN_NOTICE("Collected from: [collected_location].")

	if(collected_time)
		. += SPAN_NOTICE("Collected at: [collected_time].")

/obj/item/evidencebag/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(stored_item)
		examinate(user, stored_item, show_extended)

/obj/item/evidencebag/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_PEN || istype(attacking_item, /obj/item/flashlight/pen))
		var/static/list/evidence_label_fields = list(
			"Label text",
			"Collected by",
			"Collected location",
			"Collected time"
		)

		var/field = tgui_input_list(user, "Which evidence label field do you want to edit?", "Evidence Label", evidence_label_fields)
		if(!field)
			return

		var/current_value = get_evidence_label_value(field)

		var/new_value = tgui_input_text(
			user,
			"Enter [field] for [name]",
			"Evidence Label",
			current_value,
			MAX_NAME_LEN
		)

		if(isnull(new_value))
			return

		set_evidence_label_value(field, new_value)

		if(new_value == "")
			to_chat(user, SPAN_NOTICE("You clear [field]."))
		else
			to_chat(user, SPAN_NOTICE("You set [field] to \"[new_value]\"."))

		return

	. = ..()

/obj/item/evidencebag/proc/update_name_label(var/base_name = initial(name))
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	if(label_text == "")
		name = base_name
	else
		name = "[base_name] ([label_text])"

/obj/item/evidencebag/proc/get_evidence_label_value(var/field)
	switch(field)
		if("Label text")
			return label_text
		if("Collected by")
			return collected_by
		if("Collected location")
			return collected_location
		if("Collected time")
			return collected_time

	return ""

/obj/item/evidencebag/proc/set_evidence_label_value(var/field, var/value)
	switch(field)
		if("Label text")
			label_text = value
			update_name_label()
			return TRUE
		if("Collected by")
			collected_by = value
			return TRUE
		if("Collected location")
			collected_location = value
			return TRUE
		if("Collected time")
			collected_time = value
			return TRUE

	return FALSE
