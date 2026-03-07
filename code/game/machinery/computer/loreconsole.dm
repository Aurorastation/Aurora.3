/datum/lore_console_entry
	var/title
	var/body

/datum/lore_console_entry/New(title_ = "", body_)
	title = title_
	body = body_

/**
 * A useful object to convey the lore of your away_site maps, opposed to papers
 * How to use it?
 * * Create `new/datum/lore_console_entry(title, body)` instances in the `entries` list
 * * This list can contain multiple datum entries, each entry represents a page
 */
ABSTRACT_TYPE(/obj/machinery/computer/terminal/loreconsole)
	icon_screen = "loreconsole"
	icon_keyboard = "power_key"
	light_power_on = 2
	var/list/entries = list()

/obj/machinery/computer/terminal/loreconsole/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/terminal/loreconsole/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/terminal/loreconsole/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoreConsole", name)
		ui.open()

/obj/machinery/computer/terminal/loreconsole/ui_static_data(mob/user)
	var/list/data = list()
	data["entries"] = list()
	for(var/datum/lore_console_entry/entry as anything in entries)
		data["entries"] += list(list("title" = entry.title, "body" = entry.body))

	return data

ABSTRACT_TYPE(/obj/machinery/computer/terminal/loreconsole/always_powered)
	interact_offline = TRUE

