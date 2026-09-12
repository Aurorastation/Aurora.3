/**
 * Server-side state and validation for the universal sprite editor UI.
 * Pixel coordinates received from tgui are zero-indexed; layer indexes are one-indexed.
 */
/datum/sprite_editor_workspace
	var/width
	var/height
	var/dirs
	var/backdrop
	var/color_mode = SPRITE_EDITOR_COLOR_MODE_RGBA
	var/config_flags = ALL
	var/tool_flags = ALL
	var/list/layers
	var/list/undo_stack = list()
	var/list/undo_names = list()
	var/list/redo_stack = list()
	var/list/redo_names = list()

/datum/sprite_editor_workspace/New(
	width = 32,
	height = 32,
	dirs = 1,
	backdrop = null,
	color_mode = SPRITE_EDITOR_COLOR_MODE_RGBA,
	config_flags = ALL,
	tool_flags = ALL,
	initial_layer_color = null)
	. = ..()
	src.width = width
	src.height = height
	src.dirs = dirs
	src.backdrop = backdrop
	src.color_mode = color_mode
	src.config_flags = config_flags
	src.tool_flags = tool_flags
	layers = list(list("name" = "Background", "visible" = TRUE, "data" = create_layer_data(initial_layer_color)))

/datum/sprite_editor_workspace/proc/direction_for_index(index)
	var/static/list/dmi_order = list(SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)
	return dmi_order[index]

/datum/sprite_editor_workspace/proc/copy(preserve_history = FALSE)
	var/datum/sprite_editor_workspace/new_workspace = new(width, height, dirs, backdrop, color_mode, config_flags, tool_flags)
	new_workspace.layers = deep_copy_list(layers)
	if(preserve_history)
		new_workspace.undo_names = undo_names.Copy()
		new_workspace.undo_stack = deep_copy_list(undo_stack)
		new_workspace.redo_names = redo_names.Copy()
		new_workspace.redo_stack = deep_copy_list(redo_stack)
	return new_workspace

/datum/sprite_editor_workspace/proc/create_layer_data(color = "#00000000")
	var/list/out = list()
	for(var/i in 1 to dirs)
		var/list/frame = list()
		for(var/y in 1 to height)
			var/list/row = list()
			for(var/x in 1 to width)
				row += color
			frame += list(row)
		out["[direction_for_index(i)]"] = frame
	return out

/datum/sprite_editor_workspace/proc/valid_layer(layer)
	return isnum(layer) && layer >= 1 && layer <= length(layers)

/datum/sprite_editor_workspace/proc/valid_direction(direction)
	for(var/i in 1 to dirs)
		if("[direction_for_index(i)]" == "[direction]")
			return TRUE
	return FALSE

/datum/sprite_editor_workspace/proc/is_valid_color(color)
	if(!istext(color))
		return FALSE
	var/list/channels = sprite_editor_split_color(color)
	if(length(channels) != 4)
		return FALSE
	switch(color_mode)
		if(SPRITE_EDITOR_COLOR_MODE_RGB)
			return channels[4] == 255
		if(SPRITE_EDITOR_COLOR_MODE_GREYSCALE)
			return channels[1] == channels[2] && channels[2] == channels[3]
	return TRUE

/datum/sprite_editor_workspace/proc/valid_points(list/points)
	if(!islist(points) || length(points) > width * height * 4)
		return FALSE
	for(var/point in points)
		if(!islist(point) || length(point) < 2 || !isnum(point[1]) || !isnum(point[2]))
			return FALSE
		if(point[1] < 0 || point[1] >= width || point[2] < 0 || point[2] >= height)
			return FALSE
	return TRUE

/datum/sprite_editor_workspace/proc/can_transact(list/transaction)
	if(!islist(transaction))
		return FALSE
	var/type = transaction["type"]
	switch(type)
		if("pencil", "eraser")
			if(!valid_layer(transaction["layer"]) || !valid_direction(transaction["dir"]) || !valid_points(transaction["points"]))
				return FALSE
			if(type == "pencil")
				return (tool_flags & SPRITE_EDITOR_TOOL_PENCIL) && is_valid_color(transaction["color"])
			return tool_flags & SPRITE_EDITOR_TOOL_ERASER
		if("bucket")
			var/list/point = transaction["point"]
			return (tool_flags & SPRITE_EDITOR_TOOL_BUCKET) && valid_layer(transaction["layer"]) && valid_direction(transaction["dir"]) && valid_points(list(point)) && is_valid_color(transaction["color"])
		if("renameLayer")
			return (config_flags & SPRITE_EDITOR_ALLOW_LAYERS) && valid_layer(transaction["layer"]) && istext(transaction["newName"]) && length(transaction["newName"]) <= 64
		if("moveLayerUp")
			return (config_flags & SPRITE_EDITOR_ALLOW_LAYERS) && valid_layer(transaction["layer"]) && transaction["layer"] < length(layers)
		if("moveLayerDown", "flattenLayer")
			return (config_flags & SPRITE_EDITOR_ALLOW_LAYERS) && valid_layer(transaction["layer"]) && transaction["layer"] > 1
		if("addLayer")
			return (config_flags & SPRITE_EDITOR_ALLOW_LAYERS) && length(layers) < 32
		if("deleteLayer")
			return (config_flags & SPRITE_EDITOR_ALLOW_LAYERS) && length(layers) > 1 && valid_layer(transaction["layer"])
	return FALSE

/datum/sprite_editor_workspace/proc/new_transaction(list/transaction)
	if(!can_transact(transaction))
		return FALSE
	preprocess_new_transaction(transaction)
	transact(transaction)
	if(config_flags & SPRITE_EDITOR_ALLOW_UNDO)
		redo_stack.Cut()
		redo_names.Cut()
		undo_stack += list(transaction)
		undo_names += transaction["name"] || transaction["type"]
	return TRUE

/datum/sprite_editor_workspace/proc/undo()
	if(!(config_flags & SPRITE_EDITOR_ALLOW_UNDO) || !length(undo_stack))
		return FALSE
	undo_names.Cut(length(undo_names), length(undo_names) + 1)
	var/list/transaction = undo_stack[length(undo_stack)]
	undo_stack.Cut(length(undo_stack), length(undo_stack) + 1)
	reverse_transact(transaction)
	redo_stack += list(transaction)
	redo_names += transaction["name"] || transaction["type"]
	return TRUE

/datum/sprite_editor_workspace/proc/redo()
	if(!(config_flags & SPRITE_EDITOR_ALLOW_UNDO) || !length(redo_stack))
		return FALSE
	redo_names.Cut(length(redo_names), length(redo_names) + 1)
	var/list/transaction = redo_stack[length(redo_stack)]
	redo_stack.Cut(length(redo_stack), length(redo_stack) + 1)
	transact(transaction)
	undo_stack += list(transaction)
	undo_names += transaction["name"] || transaction["type"]
	return TRUE

/datum/sprite_editor_workspace/proc/toggle_layer_visible(layer)
	if(!(config_flags & SPRITE_EDITOR_ALLOW_LAYERS) || !valid_layer(layer))
		return FALSE
	layers[layer]["visible"] = !layers[layer]["visible"]
	return TRUE

/datum/sprite_editor_workspace/proc/preprocess_new_transaction(list/transaction)
	switch(transaction["type"])
		if("pencil", "eraser")
			var/list/frame = layers[transaction["layer"]]["data"]["[transaction["dir"]]"]
			for(var/list/point in transaction["points"])
				point += frame[point[2] + 1][point[1] + 1]
		if("bucket")
			var/list/frame = layers[transaction["layer"]]["data"]["[transaction["dir"]]"]
			var/list/point = transaction["point"]
			transaction["points"] = sprite_editor_flood_fill(frame, point[1] + 1, point[2] + 1, width, height)
			transaction -= "point"
		if("flattenLayer")
			var/layer = transaction["layer"]
			transaction["oldTop"] = layers[layer]
			transaction["oldBottom"] = deep_copy_list(layers[layer - 1])
		if("deleteLayer")
			transaction["oldLayer"] = layers[transaction["layer"]]

/datum/sprite_editor_workspace/proc/transact(list/transaction)
	var/layer = transaction["layer"]
	switch(transaction["type"])
		if("pencil", "bucket")
			var/list/frame = layers[layer]["data"]["[transaction["dir"]]"]
			for(var/list/point in transaction["points"])
				frame[point[2] + 1][point[1] + 1] = sprite_editor_blend_color(frame[point[2] + 1][point[1] + 1], transaction["color"])
		if("eraser")
			var/list/frame = layers[layer]["data"]["[transaction["dir"]]"]
			for(var/list/point in transaction["points"])
				frame[point[2] + 1][point[1] + 1] = "#00000000"
		if("renameLayer")
			layers[layer]["name"] = transaction["newName"]
		if("moveLayerUp")
			layers.Swap(layer, layer + 1)
		if("moveLayerDown")
			layers.Swap(layer, layer - 1)
		if("flattenLayer")
			var/list/top_layer = layers[layer]
			var/list/bottom_layer = layers[layer - 1]
			for(var/i in 1 to dirs)
				var/key = "[direction_for_index(i)]"
				for(var/y in 1 to height)
					for(var/x in 1 to width)
						bottom_layer["data"][key][y][x] = sprite_editor_blend_color(bottom_layer["data"][key][y][x], top_layer["data"][key][y][x])
			layers.Cut(layer, layer + 1)
		if("addLayer")
			var/layer_name = "New Layer"
			var/dupe_count = 1
			for(var/list/existing_layer in layers)
				if(existing_layer["name"] == layer_name)
					layer_name = "New Layer [++dupe_count]"
			layers += list(list("name" = layer_name, "visible" = TRUE, "data" = create_layer_data()))
		if("deleteLayer")
			layers.Cut(layer, layer + 1)

/datum/sprite_editor_workspace/proc/reverse_transact(list/transaction)
	var/layer = transaction["layer"]
	switch(transaction["type"])
		if("pencil", "eraser", "bucket")
			var/list/frame = layers[layer]["data"]["[transaction["dir"]]"]
			for(var/list/point in transaction["points"])
				frame[point[2] + 1][point[1] + 1] = point[3]
		if("renameLayer")
			layers[layer]["name"] = transaction["oldName"]
		if("moveLayerUp")
			layers.Swap(layer, layer + 1)
		if("moveLayerDown")
			layers.Swap(layer, layer - 1)
		if("flattenLayer")
			var/bottom_index = layer - 1
			var/old_visibility = layers[bottom_index]["visible"]
			layers[bottom_index] = transaction["oldBottom"]
			layers[bottom_index]["visible"] = old_visibility
			layers.Insert(layer, transaction["oldTop"])
		if("addLayer")
			layers.Cut(length(layers), length(layers) + 1)
		if("deleteLayer")
			layers.Insert(layer, transaction["oldLayer"])

/datum/sprite_editor_workspace/proc/sprite_editor_ui_data()
	return list(
		"colorMode" = color_mode,
		"toolFlags" = tool_flags,
		"undoStack" = undo_names,
		"redoStack" = redo_names,
		"sprite" = list(
			"width" = width,
			"height" = height,
			"dirs" = dirs,
			"backdrop" = backdrop,
			"layers" = layers,
		),
	)

/datum/sprite_editor_workspace/proc/get_first_layer_pixel_data(direction = SOUTH)
	return layers[1]["data"]["[direction]"]

/// Flattens visible layers and creates a single-frame icon using rust-g.
/datum/sprite_editor_workspace/proc/to_icon()
	var/list/frame = create_layer_data()["[SOUTH]"]
	for(var/list/layer in layers)
		if(!layer["visible"])
			continue
		var/list/layer_frame = layer["data"]["[SOUTH]"]
		for(var/y in 1 to height)
			for(var/x in 1 to width)
				frame[y][x] = sprite_editor_blend_color(frame[y][x], layer_frame[y][x])
	var/pixels = ""
	for(var/y in 1 to height)
		pixels += jointext(frame[y], "")
	var/static/regex/zero_alpha = regex(@"#(?:(?!a0a0a0)([0-9a-f]){6}00)", "gi")
	pixels = replacetext(pixels, zero_alpha, "#a0a0a000")
	var/temp_path = "tmp/nanopaint_[copytext(REF(src), 2, -1)].png"
	var/result = rustg_dmi_create_png(temp_path, "[width]", "[height]", pixels)
	if(result)
		stack_trace("Failed to create NanoPaint image: [result]")
		return null
	var/icon/final_icon = icon(temp_path)
	fdel(temp_path)
	return final_icon
