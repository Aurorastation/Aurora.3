/client
	var/datum/map_template/selected_template
	var/list/template_markers
	var/template_load_mode = LOADMODE_NEWZ
	var/turf/template_target

/client/proc/template_create()
	set name = "Map Template - Create"
	set category = "Fun"

	if (!check_rights(R_FUN))
		return

	var/datum/map_template/template = new
	var/first_file
	while (TRUE)
		var/current_file = input("Select a file :", "Map Selection (cancel to stop)") as null|file
		if (!current_file)
			break

		if (!first_file)
			first_file = "[current_file]" || template.name

		template.map_files += current_file

	if (!template.map_files.len)
		alert("Aborted.")
		return

	if (alert("Continue? ([template.map_files.len] files selected)", null, "Yes", "No", "No") == "No")
		qdel(template)
		return

	template.preload_size(template.map_files)
	template.name = input("Template name:", "Template Name", first_file) as text

	SSatlas.known_templates[template.name] = template

	to_chat(usr, "<span class='notice'>Template '[template]' registered.</span>")

/client/proc/template_select()
	set name = "Map Template - Select"
	set category = "Fun"

	if (!check_rights(R_FUN))
		return

	if (!SSatlas.known_templates.len)
		to_chat(usr, "<span class='warning'>There isn't any templates to load!</span>")
		return

	if (selected_template)
		to_chat(usr, "<span class='warning'>Dismiss the current template before selecting another.")
		return

	var/result = input("Available Templates:", "Template Selection") as null|anything in SSatlas.known_templates

	if (!result)
		to_chat(usr, "<span class='warning'>Aborted.</span>")
		return

	to_chat(usr, "<span class='notice'>Template '[result]' selected.</span>")
	selected_template = SSatlas.known_templates[result]

	verbs |= template_verbs

/client/proc/template_confirm_load()
	set name = "Start Load (!)"
	set category = "DMMS"
	set desc = "Starts loading the currently selected map template. WARNING: This cannot be cancelled or undone once it is started!"

	if (!check_rights(R_FUN))
		// this should not happen unless someone's permissions got changed mid-load
		log_debug("WARNING: client reached confirm_load() without permissions!")
		return

	if (!selected_template)
		// ???
		to_chat(usr, "<span class='danger'>You do not have a template selected.</span>")
		verbs -= template_verbs|template_target_verbs
		return

	switch (template_load_mode)
		if (null)
			to_chat(usr, "<span class='danger'>You haven't selected a load type!</span>")
			return

		if (LOADMODE_NEWZ)
			log_and_message_admins("<span class='notice'>is loading map template '[selected_template]' on a new Z-level ([world.maxz + 1]).</span>")
			selected_template.load_new_z()

		if (LOADMODE_ORIGIN, LOADMODE_CENTER)
			if (!template_target)
				to_chat(usr, "<span class='danger'>You don't have a target location set.</span>")
				return

			log_and_message_admins("<span class='warning'>is loading map template '[selected_template]' on an existing map location.</span>")

			selected_template.load(template_target, template_load_mode == LOADMODE_CENTER)

/client/proc/template_cancel_load()
	set name = "Cancel Load"
	set category = "DMMS"
	set desc = "Dismisses the current map template so you can select another."

	if (!selected_template)
		to_chat(usr, "<span class='danger'>You don't have a map selected.</soan>")
		verbs -= /client/proc/template_cancel_load

	selected_template = null
	to_chat(usr, "<span class='danger'>Template dismissed.</span>")
	verbs -= template_verbs|template_target_verbs

/client/proc/template_set_target()
	set name = "Target - (Un)set"
	set category = "DMMS"

	if (template_target)
		template_target = null
		to_chat(usr, "<span class='notice'>Target cleared.</span>")
	else
		template_target = get_turf(mob)
		to_chat(usr, "<span class='notice'>Target set to [template_target] at [template_target.x],[template_target.y],[template_target.z].")

/client/proc/template_clear_target()
	set name = "Target - Clear"
	set category = "DMMS"

	if (!template_target)
		to_chat(usr, "<span class='notice'>No target!</span>")
	else
		template_target = null
		to_chat(usr, "<span class='notice'>Target cleared.</span>")

/client/proc/template_set_mode()
	set name = "Target - Mode"
	set category = "DMMS"
	set desc = "Sets how the map template will be placed in the game world."

	var/selection = input("Map mode?", "Load Mode") as null|anything in list("Target (0,0)", "Target (Centered)", "New Z")
	if (!selection)
		to_chat(usr, "<span class='notice'>Cancelled.</span>")
		return

	switch (selection)
		if ("Target (0,0)", "Target (Centered)")
			verbs |= template_target_verbs
			template_load_mode = selection == "Target (0,0)" ? LOADMODE_ORIGIN : LOADMODE_CENTER
		if ("New Z")
			verbs -= template_target_verbs
			template_load_mode = LOADMODE_NEWZ


var/list/template_verbs = list(
	/client/proc/template_show_preview,
	/client/proc/template_cancel_load,
	/client/proc/template_confirm_load,
	/client/proc/template_set_mode
)

var/list/template_target_verbs = list(
	/client/proc/template_set_target,
	/client/proc/template_clear_target
)

/client/proc/template_show_verbs()
	verbs |= /client/proc/template_show_preview
	verbs |= /client/proc/template_cancel_load
	verbs |= /client/proc/template_confirm_load

/client/proc/template_hide_verbs()
	verbs -= /client/proc/template_show_preview
	verbs -= /client/proc/template_cancel_load
	verbs -= /client/proc/template_confirm_load


var/image/template_preview_image

/client/proc/template_show_preview()
	set name = "Preview"
	set category = "DMMS"
	set desc = "Marks which turfs the template is going to load on."

	if (!selected_template)
		to_chat(usr, "<span class='notice'>You don't have a template selected.</span>")
		return

	if (template_load_mode == LOADMODE_NEWZ)
		to_chat(usr, "<span class='notice'>New-Z loading cannot be previewed.</span>")
		return

	if (template_markers)
		images -= template_markers
		template_markers.Cut()
	else
		template_markers = list()

	for (var/thing in selected_template.get_affected_turfs(template_target, template_load_mode == LOADMODE_CENTER))
		var/image/I = new()
		I.appearance = global.template_preview_image
		I.loc = thing
		template_markers += I

	images |= template_markers

/client/proc/template_hide_preview()
	set name = "Clear Preview"
	set category = "DMMS"

	if (template_markers)
		images -= template_markers
		template_markers = null

/proc/loadmode2text(mode)
	switch (mode)
		if (LOADMODE_NEWZ)
			return "New Z-level"
		if (LOADMODE_CENTER)
			return "Target (Centered)"
		if (LOADMODE_ORIGIN)
			return "Target"
