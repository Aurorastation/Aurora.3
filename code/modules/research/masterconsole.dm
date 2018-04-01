/obj/machinery/computer/masterconsole
	name = "Master reseach control console"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "masterconsole"
	var/nanoui_menu = 1
	var/itemviewmode = 1
	var/list/nanoui_data = new
	req_access = list(access_rd)	//RD only.

/obj/machinery/computer/masterconsole/Initialize()
	. = ..()
	SSresearch.masterconsole = src
	nanoui_data = list()

/obj/machinery/computer/masterconsole/attack_hand(mob/user as mob)
	if(..())
		return

	ui_interact(user)

/obj/machinery/computer/masterconsole/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1
	data["nanomenu"] = nanoui_menu
	data["itemmode"] = itemviewmode
	data += nanoui_data

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "masterconsole.tmpl", "NT Research Console", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/masterconsole/proc/update_nano_data()
	if(nanoui_menu == 2)
		var/concepts[0]
		for(var/datum/research_concepts/concept in SSresearch.concepts)
			concepts[++concepts.len] = list("name" = concept.name, "id" = concept.id, "level" = concept.level, "progress" = concept.progress, "maxprogress" = concept.max_progress, "desc" = concept.get_tech_desc(concept.level))
		nanoui_data["concepts"] = concepts
	if(nanoui_menu == 3)
		var/items[0]
		for(var/datum/research_items/item in SSresearch.techitems)
			items[++items.len] = list("name" = item.name, "id" = item.id,  "desc" = item.desc, "unlocked" = item.unlocked, "cost" = item.rmpcost, "canbuy" = item.canbuy())
		nanoui_data["items"] = items

/obj/machinery/computer/masterconsole/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)
	if(href_list["menuswap"])
		nanoui_menu = round(text2num(href_list["menuswap"]), 1)
	
	if(href_list["outsource"])
		for(var/datum/research_concepts/concept in SSresearch.concepts)
			if(href_list["outsource"] == concept.id)
				concept.outsourceprogress()
	
	if(href_list["itemmode"])
		itemviewmode = round(text2num(href_list["itemmode"]), 1)
		for(var/datum/research_items/item in SSresearch.techitems)
			if(href_list["itemmode"] == item.id)
				if(item.canbuy())
					item.unlock()

	update_nano_data()
	updateUsrDialog()
