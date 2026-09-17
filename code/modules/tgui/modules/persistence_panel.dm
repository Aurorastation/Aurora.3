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
	data["objects"] = get_tracked_objects_data()
	data["records"] = get_history_records_data()
	data["generics"] = get_generic_records_data()

	return data

/datum/tgui_module/persistence_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// Instead of return TRUE for a regular update, return FALSE and call ui.send_update() before.
	// Returning TRUE will cause static_ui_data to be sent, which in this panel is costly.

	if(!can_use_persistence_panel(ui.user)) // Code behind permissions check
		return FALSE

	if(action == "toggle_saving") // Toggle persistence saving at round end
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

	if(action == "refresh") // Full data pull
		return TRUE

	if (action == "jump") // Object jump
		var/atom/target = locate(params["ref"])
		if(!target || !istype(target))
			to_chat(ui.user, SPAN_WARNING("Object can no longer be found."))
			return FALSE

		var/turf/T = get_turf(target)
		if(!T)
			to_chat(ui.user, SPAN_WARNING("Object can no longer be found."))
			return FALSE

		var/client/C = ui.user?.client
		if(!C)
			return FALSE
		if(!isghost(usr))
			C.admin_ghost()
		C.jumptocoord(T.x, T.y, T.z)
		return FALSE

	if(action == "edit") // Object VV
		var/client/C = ui.user?.client
		if(!C)
			return FALSE

		var/atom/target = locate(params["ref"])
		if(!target || !istype(target))
			to_chat(ui.user, SPAN_WARNING("object can no longer be found."))
			return FALSE

		C.debug_variables(target)
		return FALSE

	return FALSE

/datum/tgui_module/persistence_panel/proc/get_tracked_objects_data()
	var/list/objects = list()
	for(var/obj/track in SSpersistence.object_track_register)
		var/turf/T = get_turf(track)
		objects += list(list(
			"ref" = REF(track), // Needed for VV action
			"type" = "[track.type]",
			"name" = track.name,
			"x" = T?.x || 0,
			"y" = T?.y || 0,
			"z" = T?.z || 0,
			"created_at" = track.persistent_objects_created_at,
			"expires_at" = track.persistent_objects_expires_at
		))
	return objects

/datum/tgui_module/persistence_panel/proc/get_history_records_data()
	var/list/history_types = typesof(/singleton/persistent_type/history) - list(/singleton/persistent_type/history, /singleton/persistent_type/history/character)
	var/list/records = list()

	for(var/type_path in history_types)
		var/singleton/persistent_type/history/type_instance = GET_SINGLETON(type_path)
		if(!type_instance)
			continue

		records += list(build_history_type_data(type_instance))

	return records

/datum/tgui_module/persistence_panel/proc/build_history_type_data(var/singleton/persistent_type/history/type_instance)
	var/list/type_attribute_groups = SSpersistence.historyGetAllRecordsForAllAttributes(type_instance, TRUE)
	if(!type_attribute_groups)
		type_attribute_groups = list()

	var/list/attribute_groups_history = list()
	for(var/attribute_group in type_attribute_groups)
		attribute_groups_history += list(build_history_attribute_group_data(type_instance, attribute_group))

	return list(
		"type" = get_persistent_type_display_name(type_instance),
		"title" = type_instance.title,
		"description" = type_instance.description,
		"requires_attribute" = type_instance.requires_attribute,
		"attributes" = attribute_groups_history
	)

/datum/tgui_module/persistence_panel/proc/build_history_attribute_group_data(var/singleton/persistent_type/history/type_instance, var/list/attribute_group)
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

	return list(
		"attribute" = attribute_value,
		"records" = record_items
	)

/datum/tgui_module/persistence_panel/proc/get_generic_records_data()
	var/list/generics_by_type = list()
	var/custom_types = typesof(/singleton/persistent_type/generic) - /singleton/persistent_type/generic

	for(var/type_path in custom_types)
		var/singleton/persistent_type/generic/type_instance = GET_SINGLETON(type_path)
		if(!type_instance)
			continue

		var/type_key = "[type_instance.type]"
		if(!generics_by_type[type_key])
			generics_by_type[type_key] = build_generic_type_data(type_instance)

		append_generic_attribute_data(type_instance, generics_by_type[type_key]["attributes"])

	var/list/generics = list()
	for(var/type_key in generics_by_type)
		generics += list(generics_by_type[type_key])

	return generics

/datum/tgui_module/persistence_panel/proc/build_generic_type_data(var/singleton/persistent_type/generic/type_instance)
	var/list/type_parts = return_typenames(type_instance.type)
	return list(
		"type" = type_parts[length(type_parts)],
		"title" = type_instance.title,
		"description" = type_instance.description,
		"requires_attribute" = type_instance.requires_attribute,
		"attributes" = list()
	)

/datum/tgui_module/persistence_panel/proc/append_generic_attribute_data(var/singleton/persistent_type/generic/type_instance, var/list/attribute_groups_generic)
	if(type_instance.requires_attribute)
		var/list/attributes = SSpersistence.genericGetAllAttributesForType(type_instance)
		for(var/attribute in attributes)
			var/datum/persistent_generic/generic_entry = SSpersistence.genericLoad(type_instance, attribute, TRUE)
			if(!generic_entry)
				continue

			attribute_groups_generic += list(list(
				"attribute" = attribute,
				"created_at" = generic_entry.created_at,
				"expires_at" = generic_entry.expires_at,
				"json" = json_encode(generic_entry.content)
			))
		return

	var/datum/persistent_generic/generic_entry = SSpersistence.genericLoad(type_instance, null, TRUE)
	if(generic_entry)
		attribute_groups_generic += list(list(
			"attribute" = null,
			"created_at" = generic_entry.created_at,
			"expires_at" = generic_entry.expires_at,
			"json" = json_encode(generic_entry.content)
		))

/datum/tgui_module/persistence_panel/proc/get_persistent_type_display_name(var/singleton/persistent_type/type_instance)
	var/list/type_parts = return_typenames(type_instance.type)
	var/type_name = type_parts[length(type_parts)]
	if(istype(type_instance, /singleton/persistent_type/history/character))
		return "Character - [type_name]"

	return type_name

/datum/tgui_module/persistence_panel/proc/can_use_persistence_panel(var/mob/user)
	return check_rights(R_ADMIN|R_MOD|R_DEV, 0, user)
