/datum/lore_console_entry
	var/title
	var/body

/datum/lore_console_entry/New(title_ = "", body_)
	title = title_
	body = body_

/**
 * A fancy alternative to papers, for your lore enjoyers!
 * How to use it?
 * * Create `new/datum/lore_console_entry(title, body)` instances in the `entries` list
 * * This list can contain multiple datum entries, each entry represents a page
 */
/obj/structure/machinery/computer/loreconsole
	name = "information console"
	desc = "A holographic console in idle state, displaying a series of log entries."
	icon_screen = "loreconsole"
	icon_keyboard = "black_key"
	icon_keyboard_emis = "black_key_mask"
	light_power_on = 2
	light_color = LIGHT_COLOR_DECAYED
	var/list/entries = list()

/obj/structure/machinery/computer/loreconsole/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/machinery/computer/loreconsole/ui_state(mob/user)
	return GLOB.default_state

/obj/structure/machinery/computer/loreconsole/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoreConsole", name)
		ui.open()

/obj/structure/machinery/computer/loreconsole/ui_static_data(mob/user)
	var/list/data = list()
	data["entries"] = list()
	for(var/datum/lore_console_entry/entry as anything in entries)
		data["entries"] += list(list("title" = entry.title, "body" = entry.body))

	return data

// Allows storytellers and ghosts with admin perms edit entries.
/obj/structure/machinery/computer/loreconsole/attack_ghost(mob/user)
	if(isstoryteller(user) || check_rights(R_ADMIN|R_FUN, TRUE, user))

		var/choice = tgui_input_list(user, "Would you like to add, edit or remove entries?", "Manage Entries", list("Add", "Edit", "Remove"))
		if(choice)
			var/list/entry_titles
			if(length(entries))
				for(var/datum/lore_console_entry/E in entries)
					LAZYADDASSOC(entry_titles, E.title, E) // title is key, entry datum is its value

			switch(choice)
				if("Add")
					var/new_title = tgui_input_text(user, "Enter the title of the entry", "Entry Title")
					var/new_body = tgui_input_text(user, "Enter the body of the entry", "Entry Body", multiline = TRUE)
					if(!new_title || !new_body) // no info, no entries
						return

					entries += new/datum/lore_console_entry(new_title, new_body)
					to_chat(user, SPAN_NOTICE("A new entry has been added."))
					return

				if("Edit")
					if(!length(entries))
						to_chat(user, SPAN_WARNING("There are no entries to edit!"))
						return

					var/edit_choice = tgui_input_list(user, "Choose an entry to edit.", "Manage Entries", entry_titles)
					if(!edit_choice)
						return

					var/datum/lore_console_entry/edit_datum = entry_titles[edit_choice]
					edit_datum.title = tgui_input_text(user, "Enter the title of the entry", "Entry Title", default = edit_datum.title)
					edit_datum.body = tgui_input_text(user, "Enter the body of the entry", "Entry Body", default = edit_datum.body, multiline = TRUE)
					to_chat(user, SPAN_NOTICE("An entry has been edited."))
					return

				if("Remove")
					if(!length(entries))
						to_chat(user, SPAN_WARNING("There are no entries to remove!"))
						return

					var/remove_choice = tgui_input_list(user, "Choose an entry to remove.", "Manage Entries", entry_titles)
					if(!remove_choice)
						return

					var/datum/lore_console_entry/remove_datum = entry_titles[remove_choice]
					entries -= remove_datum
					to_chat(user, SPAN_NOTICE("An entry has been removed."))
					return

	..()

/obj/structure/machinery/computer/loreconsole/always_powered
	interact_offline = TRUE

// ---- Terminal variant
/obj/structure/machinery/computer/loreconsole/terminal
	name = "information terminal"
	desc = "An old-school terminal in idle state, displaying a series of log entries."
	icon = 'icons/obj/modular_computers/modular_terminal.dmi'
	icon_keyboard = "black_key"
	icon_keyboard_emis = "black_key_mask"

/obj/structure/machinery/computer/loreconsole/terminal/always_powered
	interact_offline = TRUE

// ---- Skrell variant
/obj/structure/machinery/computer/loreconsole/skrell
	name = "convoluted console"
	desc = "A holographic console of an alien technology, seemingly opens to an interface with a series of log entries."
	icon_screen = "skrell"
	icon_keyboard = "skrell_key"
	icon_keyboard_emis = "skrell_key_mask"
	light_color = LIGHT_COLOR_PURPLE

/obj/structure/machinery/computer/loreconsole/skrell/always_powered
	interact_offline = TRUE
