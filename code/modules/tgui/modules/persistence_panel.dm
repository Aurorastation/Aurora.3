/datum/tgui_module/persistence_panel/ui_interact(mob/user, var/datum/tgui/ui)
	if(!can_use_persistence_panel(user))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PersistencePanel", "Persistence Panel", 900, 700)
		ui.open()

/datum/tgui_module/persistence_panel/ui_data(mob/user)
	var/list/data = list()
	data["status_initialized"] = SSpersistence.init_success
	data["saving_active"] = !SSpersistence.prevent_saving
	data["objects_tracked"] = length(SSpersistence.object_track_register)
	data["records_cached"] = SSpersistence.history_cache_count
	data["generics_cached"] = length(SSpersistence.generic_cache)
	data["is_admin"] = check_rights(R_ADMIN, 0, user)

	return data

/datum/tgui_module/persistence_panel/ui_static_data(mob/user)
	var/list/data = list()

	var/list/objects = list()
	for(var/obj/track in SSpersistence.object_track_register)
		objects += list(list(
			"ref" = REF(track), // Needed for VV action
			"type" = "[track.type]",
			"name" = track.name,
			"x" = track.x,
			"y" = track.y,
			"z" = track.z,
			"created_at" = track.persistent_objects_created_at,
			"expires_at" = track.persistent_objects_expires_at
		))
	data["objects"] = objects

	var/list/history_types = typesof(/singleton/persistent_type/history) - list(/singleton/persistent_type/history, /singleton/persistent_type/history/character)
	var/list/records = list()
	for(var/type_path in history_types)
		var/singleton/persistent_type/history/type_instance = GET_SINGLETON(type_path)
		if(!type_instance)
			continue

		var/list/type_attribute_groups = SSpersistence.historyGetAllRecordsForAllAttributes(type_instance, TRUE)
		if(!type_attribute_groups)
			type_attribute_groups = list()

		var/list/attribute_groups_history = list()
		for(var/attribute_group in type_attribute_groups)
			var/attribute = attribute_group["attribute"]
			var/list/attribute_records = attribute_group["records"] || list()

			var/list/record_items = list()
			for(var/datum/persistent_record/record in attribute_records)
				record_items += list(list(
					"created_at" = record.created_at,
					"game_id" = record.game_id,
					"value" = "[record.value]"
				))

			var/attribute_value = attribute
			if(istype(type_instance, /singleton/persistent_type/history/character))
				// Character history is a special case, we want to show the character name instead of the ID
				attribute_value = SSpersistence.historyGetCharnameByID(attribute)

			attribute_groups_history += list(list(
				"attribute" = attribute_value,
				"records" = record_items
			))

		var/list/type_parts = return_typenames(type_instance.type)
		var/type_value
		if(istype(type_instance, /singleton/persistent_type/history/character))
			type_value = "Character - [type_parts[length(type_parts)]]"
		else
			type_value = type_parts[length(type_parts)]

		records += list(list(
			"type" = type_value,
			"title" = type_instance.title,
			"description" = type_instance.description,
			"requires_attribute" = type_instance.requires_attribute,
			"attributes" = attribute_groups_history
		))
	data["records"] = records

	var/list/generics_by_type = list()

	var/custom_types = typesof(/singleton/persistent_type/generic) - /singleton/persistent_type/generic
	for(var/type_path in custom_types)
		var/singleton/persistent_type/type_instance = GET_SINGLETON(type_path)
		if(!type_instance)
			continue

		var/type_key = "[type_instance.type]"
		if(!generics_by_type[type_key])
			var/list/type_parts = return_typenames(type_instance.type)
			generics_by_type[type_key] = list(
				"type" = type_parts[length(type_parts)],
				"title" = type_instance.title,
				"description" = type_instance.description,
				"requires_attribute" = type_instance.requires_attribute,
				"attributes" = list()
			)

		var/list/attribute_groups_generic = generics_by_type[type_key]["attributes"]
		if(type_instance.requires_attribute)
			var/list/attributes = SSpersistence.genericGetAllAttributesForType(type_instance)
			for(var/attribute in attributes)
				var/datum/persistent_generic/generic_entry = SSpersistence.genericLoad(type_instance, attribute, TRUE)
				if(!generic_entry)
					continue
				attribute_groups_generic += list(list(
					"attribute" = attribute,
					"json" = json_encode(generic_entry.content)
				))
		else
			var/datum/persistent_generic/generic_entry = SSpersistence.genericLoad(type_instance, null, TRUE)
			if(generic_entry)
				attribute_groups_generic += list(list(
					"attribute" = null,
					"json" = json_encode(generic_entry.content)
				))

	var/list/generics = list()
	for(var/type_key in generics_by_type)
		generics += list(generics_by_type[type_key])
	data["generics"] = generics

	return data

/datum/tgui_module/persistence_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// Instead of return TRUE for a regular update, return FALSE and call ui.send_update() before.
	// Returning TRUE will cause static_ui_data to be sent, which in this panel is costly.

	if(!can_use_persistence_panel(ui.user))
		return FALSE

	if(action == "toggle_saving")
		if(!check_rights(R_ADMIN))
			return FALSE

		var/message = ""
		var/options = list()
		if(SSpersistence.prevent_saving)
			message = "The persistence subsystem will NOT save at the end of the round. Do you want to re-enable it?"
			options = list("Re-enable saving", "Cancel")
		else
			message = "The persistence subsystem will save at the end of the round. Do you want to prevent this? This can be un-done before the round ends."
			options = list("Prevent saving", "Cancel")

		var/confirm = tgui_alert(usr, message, "Toggle Persistence Saving", options)
		if(confirm == "Prevent saving")
			SSpersistence.prevent_saving = TRUE
			to_world(FONT_LARGE(EXAMINE_BLOCK_RED("Persistence saving at the end of the round has been [SPAN_BOLD(SPAN_WARNING("disabled"))] by an administrator.")))
			log_and_message_admins("has toggled persistence saving at round end, it is now disabled", usr)
		else if (confirm == "Re-enable saving")
			SSpersistence.prevent_saving = FALSE
			to_world(FONT_LARGE(EXAMINE_BLOCK_RED("Persistence saving at the end of the round has been [SPAN_BOLD(SPAN_GOOD("re-enabled"))] by an administrator.")))
			log_and_message_admins("has toggled persistence saving at round end, it is now re-enabled", usr)

		ui.send_update()
		return FALSE

	if(action == "refresh")
		return TRUE

	if(action == "edit")
		var/client/C = ui.user?.client
		if(!C)
			return FALSE

		var/atom/target = locate(params["ref"])
		if(!target || !istype(target))
			to_chat(ui.user, SPAN_WARNING("That object can no longer be found."))
			return FALSE

		C.debug_variables(target)
		return FALSE

	return FALSE

/datum/tgui_module/persistence_panel/proc/can_use_persistence_panel(var/mob/user)
	return check_rights(R_ADMIN|R_MOD|R_DEV, 0, user)
