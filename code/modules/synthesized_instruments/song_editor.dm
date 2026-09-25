/datum/instrument_ui/song_editor
	name = "Song Editor"
	var/datum/synthesized_song/song
	var/show_help = 0
	var/page = 1


/datum/instrument_ui/song_editor/New(host, datum/synthesized_song/song)
	..()
	src.host = host
	src.song = song

/datum/instrument_ui/song_editor/Destroy()
	song = null
	return ..()

/datum/instrument_ui/song_editor/proc/pages()
	return Ceil(src.song.lines.len / GLOB.musical_config.song_editor_lines_per_page)


/datum/instrument_ui/song_editor/proc/current_page()
	return src.song.current_line > 0 ? Ceil(src.song.current_line / GLOB.musical_config.song_editor_lines_per_page) : min(src.page, pages())


/datum/instrument_ui/song_editor/proc/page_bounds(page_num)
	return list(
		max(min(1 + GLOB.musical_config.song_editor_lines_per_page * (page_num-1), src.song.lines.len), 1),
		min(GLOB.musical_config.song_editor_lines_per_page * page_num, src.song.lines.len))

/datum/instrument_ui/song_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SongEditor", "Song Editor")
		ui.open()

/datum/instrument_ui/song_editor/ui_data(mob/user)
	var/current_page = src.current_page()
	var/list/line_bounds = src.page_bounds(current_page)
	return list(
		"lines"          = src.song.lines.Copy(line_bounds[1], line_bounds[2]+1),
		"active_line"    = src.song.current_line,
		"max_lines"      = GLOB.musical_config.max_lines,
		"max_line_length"= GLOB.musical_config.max_line_length,
		"tick_lag"       = world.tick_lag,
		"show_help"      = src.show_help,
		"page_num"       = current_page,
		"page_offset"    = GLOB.musical_config.song_editor_lines_per_page * (current_page-1),
		"total_pages"    = src.pages()
	)

/datum/instrument_ui/song_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("newline")
			var/newline = tgui_input_text(usr, "Enter your line:", "New Line")
			if(!newline)
				return TRUE
			if(src.song.lines.len >= GLOB.musical_config.max_lines)
				return TRUE
			if(length(newline) > GLOB.musical_config.max_line_length)
				newline = copytext(newline, 1, GLOB.musical_config.max_line_length)
			src.song.lines.Add(newline)
			return TRUE

		if("deleteline")
			// This could kill the server if the synthesizer was playing, props to BeTePb
			// Impossible to do now. Dumbing down this section.
			var/num = round(text2num(params["value"]))
			if(num < 1 || num > src.song.lines.len)
				return TRUE
			src.song.lines.Cut(num, num+1)
			return TRUE

		if("modifyline")
			var/num = round(text2num(params["value"]))
			if(num < 1 || num > src.song.lines.len)
				return TRUE
			var/content = tgui_input_text(usr, "Enter your line:", "Edit Line", src.song.lines[num])
			if(!content || num < 1 || num > src.song.lines.len)
				return TRUE
			if(length(content) > GLOB.musical_config.max_line_length)
				content = copytext(content, 1, GLOB.musical_config.max_line_length)
			src.song.lines[num] = content
			return TRUE

		if("help")
			src.show_help = text2num(params["value"]) ? 1 : 0
			return TRUE

		if("next_page")
			src.page = max(min(src.page + 1, src.pages()), 1)
			return TRUE

		if("prev_page")
			src.page = max(min(src.page - 1, src.pages()), 1)
			return TRUE

		if("last_page")
			src.page = src.pages()
			return TRUE

		if("first_page")
			src.page = 1
			return TRUE
