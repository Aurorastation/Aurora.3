/*
Research and Development (R&D) Console

This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder with all the known/possible technology paths and device designs.

Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.

The imprinting and construction menus do NOT require toxins access to access but all the other menus do. However, if you leave it
on a menu, nothing is to stop the person from using the options on that menu (although they won't be able to change to a different
one). You can also lock the console on the settings menu if you're feeling paranoid and you don't want anyone messing with it who
doesn't have toxins access.

When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there are two ways around
this dire fate:
- The easiest way is to go to the settings menu and select "Sync Database with Network." That causes it to upload (but not download)
it's data to every other device in the game. Each console has a "disconnect from network" option that'll will cause data base sync
operations to skip that console. This is useful if you want to make a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this method is that you have
to have physical access to the other console to send data back. Note: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
- The second method is with Technology Disks and Design Disks. Each of these disks can hold a single technology or design datum in
it's entirety. You can then take the disk to any R&D console and upload it's data to it. This method is a lot more secure (since it
won't update every console in existence) but it's more of a hassle to do. Also, the disks can be stolen.
*/

/obj/structure/machinery/computer/rdconsole
	name = "R&D control console"

	icon_screen = "rdcomp"
	icon_keyboard = "purple_key"
	icon_keyboard_emis = "purple_key_mask"
	light_color = LIGHT_COLOR_PURPLE

	manufacturer = "nanotrasen"

	circuit = /obj/item/circuitboard/rdconsole
	//Stores all the collected research data.
	var/datum/research/files
	//Stores the technology disk.
	var/obj/item/disk/tech_disk/t_disk = null
	//Stores the design disk.
	var/obj/item/disk/design_disk/d_disk = null

	/// All fabrication machinery connected to this console.
	var/list/obj/structure/machinery/r_n_d/fabricator/linked_fabricators = list()

	/// Console-owned production queues.
	var/list/datum/research_fabrication_job/protolathe_queue = list()
	var/list/datum/research_fabrication_job/imprinter_queue = list()
	var/list/datum/research_fabrication_job/mechfab_queue = list()

	//Linked Destructive Analyzer
	var/obj/structure/machinery/r_n_d/destructive_analyzer/linked_destroy = null
	//Shared material storage
	var/obj/structure/machinery/r_n_d/material_silo/linked_silo = null

	var/selected_mech_manufacturer

	var/device_sync_range = 7

	var/allow_analyzer = TRUE
	var/allow_lathe = TRUE
	var/allow_imprinter = TRUE
	var/allow_mechfab = TRUE
	var/allow_silo = TRUE

	//Which screen is currently showing.
	var/screen = 1.0
	//ID of the computer (for server restrictions).
	var/id = 0
	//If sync = 0, it doesn't show up on Server Control Console
	var/sync = 1
	/// Number of copies to queue when adding a design.
	var/queue_amount = 1
	/// Message displayed while a delayed console action is processing.
	var/busy_message = "Processing request. Please wait."

	var/protolathe_category = "All"
	var/imprinter_category = "All"

	var/ref_for_ui

	//Data and setting manipulation requires scientist access.
	req_access = list(ACCESS_TOX)

/datum/research_fabrication_job
	/// Design being produced.
	var/datum/design/design

	/// Machine currently producing this job.
	var/obj/structure/machinery/assigned_machine

	/// Manufacturer selected for mech-fabricator products.
	var/manufacturer

	/// Materials removed from the silo and reserved for this job.
	var/list/reserved_materials = list()

/datum/research_fabrication_job/New(datum/design/new_design, new_manufacturer)
	. = ..()

	design = new_design
	manufacturer = new_manufacturer

/datum/research_fabrication_job/Destroy()
	design = null
	assigned_machine = null
	reserved_materials = null
	return ..()

/obj/structure/machinery/computer/rdconsole/proc/CallMaterialName(var/ID)
	return SSmaterials.material_display_name(ID)

/obj/structure/machinery/computer/rdconsole/proc/CallReagentName(ID)
	var/singleton/reagent/R = GET_SINGLETON(ID)
	return R ? R.name : "(none)"

/obj/structure/machinery/computer/rdconsole/proc/SyncRDevices()
	linked_fabricators ||= list()

	for(var/obj/structure/machinery/r_n_d/device in range(device_sync_range, src))
		if(device.panel_open)
			continue

		if(istype(device, /obj/structure/machinery/r_n_d/destructive_analyzer) && allow_analyzer)
			if(!linked_destroy && !device.linked_console)
				linked_destroy = device
				device.linked_console = src
		else if(istype(device, /obj/structure/machinery/r_n_d/material_silo) && allow_silo)
			if(!linked_silo && !device.linked_console)
				linked_silo = device
				device.linked_console = src
		else if(istype(device, /obj/structure/machinery/r_n_d/fabricator))
			var/obj/structure/machinery/r_n_d/fabricator/fabricator = device
			if(!fabricator_type_allowed(fabricator))
				continue
			if(fabricator.linked_console && fabricator.linked_console != src)
				continue
			fabricator.linked_console = src
			linked_fabricators |= fabricator

	cleanup_fabricators()
	dispatch_fabrication_jobs()
	return

/obj/structure/machinery/computer/rdconsole/proc/fabricator_type_allowed(obj/structure/machinery/r_n_d/fabricator/fabricator)
	if(fabricator.build_type & PROTOLATHE)
		return allow_lathe
	if(fabricator.build_type & IMPRINTER)
		return allow_imprinter
	if(fabricator.build_type & MECHFAB)
		return allow_mechfab
	return FALSE

/obj/structure/machinery/computer/rdconsole/proc/cleanup_fabricators()
	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_fabricators.Copy())
		if(QDELETED(fabricator) || fabricator.linked_console != src)
			linked_fabricators -= fabricator

/obj/structure/machinery/computer/rdconsole/proc/remove_fabricator(obj/structure/machinery/r_n_d/fabricator/fabricator)
	if(!fabricator)
		return
	linked_fabricators -= fabricator
	if(fabricator.assigned_job)
		fabricator.assigned_job.assigned_machine = null
		fabricator.assigned_job = null
		fabricator.current_design = null
	SStgui.update_uis(src)
	dispatch_fabrication_jobs()

/obj/structure/machinery/computer/rdconsole/proc/get_fabricators(build_flag)
	var/list/result = list()
	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_fabricators)
		if(fabricator.build_type & build_flag)
			result += fabricator
	return result

/obj/structure/machinery/computer/rdconsole/proc/get_primary_fabricator(build_flag)
	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_fabricators)
		if(fabricator.build_type & build_flag)
			return fabricator
	return null

/obj/structure/machinery/computer/rdconsole/proc/disconnect_fabricators(build_flag)
	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_fabricators.Copy())
		if(fabricator.build_type & build_flag)
			fabricator.disconnect_console()

/obj/structure/machinery/computer/rdconsole/proc/SyncTechs()
	var/turf/turf = get_turf(src)
	for(var/obj/structure/machinery/r_n_d/server/S in SSmachinery.machinery)
		var/turf/ST = get_turf(S)
		if(ST && !AreConnectedZLevels(ST.z, turf.z))
			continue
		var/server_processed = 0
		if((id in S.id_with_upload) || istype(S, /obj/structure/machinery/r_n_d/server/centcom))
			for(var/tech_id in files.known_tech)
				var/datum/tech/T = files.known_tech[tech_id]
				S.files.AddTech2Known(T)
			S.files.RefreshResearch()
			server_processed = 1
		files.known_tech = S.files.known_tech.Copy()
		if(!istype(S, /obj/structure/machinery/r_n_d/server/centcom) && server_processed)
			S.produce_heat()
	screen = 1.6
	updateUsrDialog()

//Have it automatically push research to the centcomm server so wild griffins can't fuck up R&D's work
/obj/structure/machinery/computer/rdconsole/proc/griefProtection()
	for(var/obj/structure/machinery/r_n_d/server/centcom/C in SSmachinery.machinery)
		for(var/tech_id in files.known_tech)
			var/datum/tech/T = files.known_tech[tech_id]
			C.files.AddTech2Known(files.known_tech[T])
		C.files.RefreshResearch()

/obj/structure/machinery/computer/rdconsole/proc/dispatch_fabrication_jobs()
	cleanup_fabricators()
	dispatch_queue_to_machines(protolathe_queue, PROTOLATHE)
	dispatch_queue_to_machines(imprinter_queue, IMPRINTER)
	dispatch_queue_to_machines(mechfab_queue, MECHFAB)
	SStgui.update_uis(src)

/obj/structure/machinery/computer/rdconsole/proc/dispatch_queue_to_machines(list/job_queue, build_flag)
	if(!length(job_queue))
		return

	for(var/datum/research_fabrication_job/job as anything in job_queue)
		if(job.assigned_machine)
			continue
		for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_fabricators)
			if(!(fabricator.build_type & build_flag) || !fabricator.is_available())
				continue
			if(!fabricator.can_produce_job(job))
				continue
			if(fabricator.begin_console_job(job))
				break

/obj/structure/machinery/computer/rdconsole/proc/get_job_queue(build_flag)
	if(build_flag & PROTOLATHE)
		return protolathe_queue
	if(build_flag & IMPRINTER)
		return imprinter_queue
	if(build_flag & MECHFAB)
		return mechfab_queue
	return null

/obj/structure/machinery/computer/rdconsole/proc/refund_job_materials(datum/research_fabrication_job/job)
	if(!job || !length(job.reserved_materials) || !linked_silo)
		return

	for(var/material_id in job.reserved_materials)
		SSmaterials.add_material_amount(linked_silo.materials, material_id, job.reserved_materials[material_id])

	job.reserved_materials.Cut()
	linked_silo.update_linked_uis()

/obj/structure/machinery/computer/rdconsole/proc/refund_all_queued_materials()
	for(var/datum/research_fabrication_job/job as anything in protolathe_queue)
		refund_job_materials(job)
	for(var/datum/research_fabrication_job/job as anything in imprinter_queue)
		refund_job_materials(job)
	for(var/datum/research_fabrication_job/job as anything in mechfab_queue)
		refund_job_materials(job)

/obj/structure/machinery/computer/rdconsole/proc/remove_fabrication_job(list/job_queue, index)
	if(index < 1 || index > length(job_queue))
		return FALSE
	var/datum/research_fabrication_job/job = job_queue[index]
	if(job.assigned_machine)
		return FALSE
	refund_job_materials(job)
	job_queue.Cut(index, index + 1)
	qdel(job)
	dispatch_fabrication_jobs()
	return TRUE

/obj/structure/machinery/computer/rdconsole/proc/finish_fabrication_job(datum/research_fabrication_job/job)
	if(!job)
		return
	if(job in protolathe_queue)
		protolathe_queue -= job
	else if(job in imprinter_queue)
		imprinter_queue -= job
	else if(job in mechfab_queue)
		mechfab_queue -= job
	qdel(job)
	SStgui.update_uis(src)

/obj/structure/machinery/computer/rdconsole/Initialize()
	..()
	files = new /datum/research(src) //Setup the research data holder.
	selected_mech_manufacturer = GLOB.basic_robolimb.company
	if(!id)
		for(var/obj/structure/machinery/r_n_d/server/centcom/S in SSmachinery.machinery)
			S.setup()
			break
	SyncRDevices()
	ref_for_ui = "[REF(src)]"
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/computer/rdconsole/LateInitialize()
	. = ..()
	SyncTechs()
	screen = 1.0

/obj/structure/machinery/computer/rdconsole/Destroy()
	refund_all_queued_materials()
	if(linked_destroy)
		linked_destroy.linked_console = null
	if(linked_silo)
		linked_silo.linked_console = null
	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_fabricators.Copy())
		fabricator.linked_console = null
	linked_fabricators.Cut()
	return ..()

/obj/structure/machinery/computer/rdconsole/attackby(obj/item/attacking_item, mob/user)
	//Loading a disk into it.
	if(istype(attacking_item, /obj/item/disk))
		if(t_disk || d_disk)
			to_chat(user, "A disk is already loaded into the machine.")
			return

		if(istype(attacking_item, /obj/item/disk/tech_disk))
			t_disk = attacking_item
		else if (istype(attacking_item, /obj/item/disk/design_disk))
			d_disk = attacking_item
		else
			to_chat(user, SPAN_NOTICE("Machine cannot accept disks in that format."))
			return
		user.drop_from_inventory(attacking_item, src)
		to_chat(user, SPAN_NOTICE("You add \the [attacking_item] to the machine."))
	else
		//The construction/deconstruction of the console code.
		..()

	SStgui.update_uis(src)
	return

/obj/structure/machinery/computer/rdconsole/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()

	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(usr, SPAN_NOTICE("You disable the security protocols."))
		return 1

/obj/structure/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
	var/dat
	dat += "<UL>"
	for(var/tech_id in files.known_tech)
		var/datum/tech/T = files.known_tech[tech_id]
		if(T.level < 1)
			continue
		dat += "<LI>"
		dat += "<u><b>[T.name]</b></u>"
		dat += "<UL>"
		dat +=  "<LI>Level: [T.level]"
		if(T.level == 15)
			dat +=  "<LI>Progress: Complete"
		else
			dat +=  "<LI>Progress: [T.next_level_progress]/[T.next_level_threshold]"
		dat +=  "<LI>Summary: [T.desc]"
		dat += "</UL>"
	return dat

/obj/structure/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/dat
	dat += "<UL>"
	for(var/path in files.known_designs)
		var/datum/design/D = files.known_designs[path]
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat

/obj/structure/machinery/computer/rdconsole/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/structure/machinery/computer/rdconsole/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResearchConsole", "Research and Development Console", 1200, 800)
		ui.open()

/obj/structure/machinery/computer/rdconsole/proc/tgui_screen_name()
	switch(screen)
		if(0.0 to 0.9)
			return "busy"
		if(1.1)
			return "levels"
		if(1.2)
			return "tech_disk"
		if(1.4)
			return "design_disk"
		if(1.6, 1.7)
			return "settings"
		if(2.0 to 2.9)
			return "analyzer"
		if(3.0 to 3.9)
			return "protolathe"
		if(4.0 to 4.9)
			return "imprinter"
		if(5.0)
			return "designs"
		if(6.0 to 6.9)
			return "mechfab"
	return "main"

/obj/structure/machinery/computer/rdconsole/proc/tgui_screen_number(screen_name)
	switch(screen_name)
		if("main")
			return 1.0
		if("levels")
			return 1.1
		if("tech_disk")
			return 1.2
		if("design_disk")
			return 1.4
		if("settings")
			return 1.6
		if("analyzer")
			return linked_destroy?.loaded_item ? 2.2 : 2.1
		if("protolathe")
			return length(get_fabricators(PROTOLATHE)) ? 3.1 : 3.0
		if("imprinter")
			return length(get_fabricators(IMPRINTER)) ? 4.1 : 4.0
		if("mechfab")
			return length(get_fabricators(MECHFAB)) ? 6.1 : 6.0
		if("designs")
			return 5.0
	return 1.0

/obj/structure/machinery/computer/rdconsole/proc/can_open_tgui_screen(screen_name, mob/user)
	if(screen_name in list("main", "levels", "designs", "protolathe", "imprinter", "mechfab"))
		return TRUE
	return allowed(user) || emagged

/obj/structure/machinery/computer/rdconsole/proc/get_technology_tgui_data()
	var/list/result = list()
	for(var/tech_id in files.known_tech)
		var/datum/tech/T = files.known_tech[tech_id]
		if(T.level < 1)
			continue
		result += list(list(
			"id" = tech_id,
			"name" = T.name,
			"description" = T.desc,
			"level" = T.level,
			"progress" = T.next_level_progress,
			"threshold" = T.next_level_threshold,
			"complete" = T.level >= 15
		))
	return result

/obj/structure/machinery/computer/rdconsole/proc/get_design_category(datum/design/D, build_flag = 0)
	if((build_flag & MECHFAB) && D.category)
		return D.category
	if(D.p_category)
		return D.p_category
	if(D.category)
		return D.category
	return "Misc"

/obj/structure/machinery/computer/rdconsole/proc/get_design_tgui_data()
	var/list/result = list()
	for(var/path in files.known_designs)
		var/datum/design/D = files.known_designs[path]
		if(!D.build_path)
			continue
		result += list(list(
			"path" = "[D.type]",
			"name" = D.name,
			"description" = D.desc,
			"category" = get_design_category(D)
		))
	return result

/obj/structure/machinery/computer/rdconsole/proc/get_analyzer_tgui_data()
	var/list/result = list("linked" = !!linked_destroy)
	if(!linked_destroy)
		return result
	result["busy"] = linked_destroy.busy
	if(!linked_destroy.loaded_item)
		return result
	result["item"] = list(
		"name" = linked_destroy.loaded_item.name,
		"stack" = istype(linked_destroy.loaded_item, /obj/item/stack),
		"technologies" = list()
	)
	var/list/techs = result["item"]["technologies"]
	for(var/tech_id in linked_destroy.loaded_item.origin_tech)
		var/datum/tech/T = files.known_tech[tech_id]
		if(!T)
			continue
		techs += list(list(
			"name" = T.name,
			"item_level" = linked_destroy.loaded_item.origin_tech[tech_id],
			"current_level" = T.level,
			"progress" = T.next_level_progress,
			"threshold" = T.next_level_threshold
		))
	return result

/obj/structure/machinery/computer/rdconsole/proc/get_stored_reagent_amount(datum/reagents/reagent_holder, reagent_id)
	if(!reagent_holder || !reagent_id)
		return 0

	var/list/reagent_volumes = reagent_holder.reagent_volumes

	if(!islist(reagent_volumes))
		return 0

	/*
	 * Use keys obtained directly from reagent_volumes. This avoids attempting
	 * to index the list with a design chemical identifier that may not be in
	 * precisely the same representation as the holder's key.
	 */
	for(var/stored_reagent_id in reagent_volumes)
		if(stored_reagent_id == reagent_id || "[stored_reagent_id]" == "[reagent_id]")
			return reagent_volumes[stored_reagent_id] || 0

	return 0

/obj/structure/machinery/computer/rdconsole/proc/get_research_fabricator_data(build_flag)
	var/list/fabricators = get_fabricators(build_flag)
	if(!length(fabricators))
		return null

	var/obj/structure/machinery/r_n_d/fabricator/primary = fabricators[1]
	var/list/job_queue = get_job_queue(build_flag)
	var/list/stored_materials = linked_silo?.materials || list()
	var/datum/reagents/reagent_holder = primary.uses_reagents ? primary.reagents : null
	var/list/data = list(
		"linked" = TRUE,
		"materials" = list(),
		"reagents" = list(),
		"recipes" = list(),
		"categories" = list("All"),
		"queue" = list(),
		"sheet_material_amount" = SHEET_MATERIAL_AMOUNT,
		"maximum_material_storage" = linked_silo?.max_material_storage || 0,
		"maximum_reagent_volume" = reagent_holder?.maximum_volume || 0,
		"reagent_volume" = reagent_holder?.total_volume || 0,
		"supports_manufacturers" = build_flag & MECHFAB,
		"manufacturers" = list(),
		"selected_manufacturer" = selected_mech_manufacturer,
		"supports_reagents" = FALSE
	)

	SSmaterials.normalize_material_amounts(stored_materials)
	for(var/material in stored_materials)
		data["materials"] += list(list(
			"id" = "[material]",
			"name" = CallMaterialName(material),
			"amount" = stored_materials[material],
			"maximum" = linked_silo?.max_material_storage || 0
		))

	if(reagent_holder)
		for(var/reagent_type in reagent_holder.reagent_volumes)
			data["reagents"] += list(list(
				"id" = "[reagent_type]",
				"name" = CallReagentName(reagent_type),
				"amount" = reagent_holder.reagent_volumes[reagent_type]
			))

	if(build_flag & MECHFAB)
		for(var/manufacturer_id in GLOB.fabricator_robolimbs)
			var/datum/robolimb/robolimb = GLOB.fabricator_robolimbs[manufacturer_id]
			data["manufacturers"] += list(list("id" = manufacturer_id, "name" = robolimb.company))

	for(var/path in files.known_designs)
		var/datum/design/design = files.known_designs[path]
		if(!design.build_path || !(design.build_type & build_flag))
			continue

		var/category = get_design_category(design, build_flag)
		data["categories"] |= category
		var/list/resources = list()
		var/list/requirements = list()

		for(var/material_id in design.materials)
			var/material_path = SSmaterials.material_to_path(material_id, FALSE)
			if(!material_path)
				material_path = material_id
			var/required_material = primary.get_required_material_amount(design, material_id)
			var/stored_material = stored_materials[material_path] || 0
			var/material_name = CallMaterialName(material_id)
			resources += "[required_material] [material_name]"
			requirements += list(list("name" = material_name, "required" = required_material, "stored" = stored_material, "missing" = stored_material < required_material, "type" = "material"))

		if(primary.uses_reagents && length(design.chemicals))
			data["supports_reagents"] = TRUE
			for(var/reagent_id in design.chemicals)
				var/required_reagent = primary.get_required_reagent_amount(design, reagent_id)
				var/stored_reagent = get_stored_reagent_amount(reagent_holder, reagent_id)
				var/reagent_name = CallReagentName(reagent_id)
				resources += "[required_reagent] [reagent_name]"
				requirements += list(list("name" = reagent_name, "required" = required_reagent, "stored" = stored_reagent, "missing" = stored_reagent < required_reagent, "type" = "reagent"))

		var/can_build_anywhere = FALSE
		var/fastest_time = null
		for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in fabricators)
			can_build_anywhere ||= fabricator.can_build(design)
			var/machine_time = round(design.time / fabricator.production_speed)
			if(isnull(fastest_time) || machine_time < fastest_time)
				fastest_time = machine_time

		data["recipes"] += list(list(
			"name" = design.name,
			"description" = design.desc,
			"design" = "[path]",
			"category" = category,
			"resources" = english_list(resources),
			"requirements" = requirements,
			"can_build" = can_build_anywhere,
			"build_time" = fastest_time || design.time
		))

	var/index = 1
	for(var/datum/research_fabrication_job/job as anything in job_queue)
		var/obj/structure/machinery/r_n_d/fabricator/machine = job.assigned_machine
		var/build_time = machine ? round(job.design.time / machine.production_speed) : round(job.design.time / primary.production_speed)
		var/remaining_time = machine?.build_callback_timer ? max(0, timeleft(machine.build_callback_timer)) : 0
		data["queue"] += list(list(
			"index" = index,
			"name" = job.design.name,
			"build_time" = build_time,
			"active" = !!machine,
			"machine" = machine?.name,
			"remaining_time" = remaining_time
		))
		index++

	return data

/obj/structure/machinery/computer/rdconsole/proc/validate_fabricator_screen()
	cleanup_fabricators()
	switch(tgui_screen_name())
		if("protolathe")
			if(!length(get_fabricators(PROTOLATHE)))
				screen = 1.0
		if("imprinter")
			if(!length(get_fabricators(IMPRINTER)))
				screen = 1.0
		if("mechfab")
			if(!length(get_fabricators(MECHFAB)))
				screen = 1.0

/obj/structure/machinery/computer/rdconsole/ui_data(mob/user)
	validate_fabricator_screen()
	files.RefreshResearch()
	var/list/data = list(
		"manufacturer" = manufacturer,
		"screen" = tgui_screen_name(),
		"authorized" = allowed(user) || emagged,
		"emagged" = emagged,
		"network_sync" = sync,
		"busy_message" = busy_message,
		"loaded_disk" = null,
		"queue_amount" = queue_amount,
		"devices" = list(
			"analyzer" = linked_destroy ? 1 : 0,
			"protolathe" = length(get_fabricators(PROTOLATHE)),
			"imprinter" = length(get_fabricators(IMPRINTER)),
			"mechfab" = length(get_fabricators(MECHFAB)),
			"silo" = linked_silo ? 1 : 0
		)
	)
	if(t_disk)
		data["loaded_disk"] = list("type" = "technology", "name" = t_disk.name, "stored_name" = t_disk.stored?.name, "stored_description" = t_disk.stored?.desc, "stored_level" = t_disk.stored?.level)
	else if(d_disk)
		data["loaded_disk"] = list("type" = "design", "name" = d_disk.name, "stored_name" = d_disk.blueprint?.name, "stored_description" = d_disk.blueprint?.desc)
	switch(data["screen"])
		if("levels")
			data["technologies"] = get_technology_tgui_data()
		if("designs")
			data["designs"] = get_design_tgui_data()
		if("tech_disk")
			data["technologies"] = get_technology_tgui_data()
		if("design_disk")
			data["designs"] = get_design_tgui_data()
		if("analyzer")
			data["analyzer"] = get_analyzer_tgui_data()
		if("protolathe")
			data["fabricator"] = get_research_fabricator_data(PROTOLATHE)
		if("imprinter")
			data["fabricator"] = get_research_fabricator_data(IMPRINTER)
		if("mechfab")
			data["fabricator"] = get_research_fabricator_data(MECHFAB)
	return data

/obj/structure/machinery/computer/rdconsole/proc/eject_fabricator_material(obj/structure/machinery/r_n_d/machine, material_id, requested_sheets)
	return linked_silo?.eject_material(material_id, requested_sheets)

/obj/structure/machinery/computer/rdconsole/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)
	usr.set_machine(src)
	switch(action)
		if("set_screen")
			var/new_screen = params["screen"]
			if(!can_open_tgui_screen(new_screen, usr))
				to_chat(usr, SPAN_WARNING("Unauthorized access."))
				return
			screen = tgui_screen_number(new_screen)
			. = TRUE
		if("back")
			screen = 1.0
			. = TRUE
		if("upload_disk")
			if(t_disk?.stored)
				files.AddTech2Known(t_disk.stored)
				griefProtection()
				. = TRUE
			else if(d_disk?.blueprint)
				files.AddDesign2Known(d_disk.blueprint)
				griefProtection()
				. = TRUE
		if("clear_disk")
			if(t_disk)
				t_disk.stored = null
				. = TRUE
			else if(d_disk)
				d_disk.blueprint = null
				. = TRUE
		if("eject_disk")
			var/obj/item/disk/disk = t_disk || d_disk
			if(disk)
				disk.forceMove(loc)
				usr.put_in_hands(disk)
				t_disk = null
				d_disk = null
				screen = 1.0
				. = TRUE
		if("copy_tech")
			if(t_disk)
				t_disk.stored = files.known_tech[params["id"]]
				. = TRUE
		if("copy_design")
			if(d_disk)
				var/path = text2path(params["design"])
				d_disk.blueprint = files.known_designs[path]
				. = TRUE
		if("analyzer_eject")
			if(linked_destroy && !linked_destroy.busy && linked_destroy.loaded_item)
				linked_destroy.loaded_item.forceMove(linked_destroy.loc)
				if(linked_destroy.Adjacent(usr))
					usr.put_in_hands(linked_destroy.loaded_item)
				linked_destroy.loaded_item = null
				linked_destroy.icon_state = "d_analyzer"
				. = TRUE
		if("analyzer_deconstruct")
			if(linked_destroy && !linked_destroy.busy && linked_destroy.loaded_item)
				linked_destroy.busy = TRUE
				screen = 0.1
				flick("d_analyzer_process", linked_destroy)
				addtimer(CALLBACK(src, PROC_REF(finish_analyzer_deconstruction)), 24)
				. = TRUE
		if("fabricator_build")
			var/design_text = params["design"]
			if(!design_text)
				return FALSE

			var/path = text2path(design_text)
			var/datum/design/design = files.known_designs[path]

			if(!design)
				to_chat(usr, SPAN_WARNING("The selected design could not be found in the research database."))
				return FALSE

			switch(tgui_screen_name())
				if("protolathe")
					if(!(design.build_type & PROTOLATHE))
						return FALSE

					for(var/i in 1 to queue_amount)
						protolathe_queue += new /datum/research_fabrication_job(design)

				if("imprinter")
					if(!(design.build_type & IMPRINTER))
						return FALSE

					for(var/i in 1 to queue_amount)
						imprinter_queue += new /datum/research_fabrication_job(design)

				if("mechfab")
					if(!(design.build_type & MECHFAB))
						return FALSE

					for(var/i in 1 to queue_amount)
						mechfab_queue += new /datum/research_fabrication_job(design, selected_mech_manufacturer)

				else
					return FALSE

			dispatch_fabrication_jobs()
			. = TRUE
		if("fabricator_remove")
			var/index = text2num(params["index"])
			switch(tgui_screen_name())
				if("protolathe")
					. = remove_fabrication_job(protolathe_queue, index)
				if("imprinter")
					. = remove_fabrication_job(imprinter_queue, index)
				if("mechfab")
					. = remove_fabrication_job(mechfab_queue, index)
		if("fabricator_eject")
			var/amount = text2num(params["amount"])
			. = linked_silo?.eject_material(params["material"], amount)
		if("fabricator_eject_custom")
			if(!linked_silo)
				return FALSE
			var/material_id = params["material"]
			var/available_sheets = floor(linked_silo.get_material_amount(material_id) / SHEET_MATERIAL_AMOUNT)
			if(available_sheets < 1)
				return FALSE
			var/amount = input(usr, "How many sheets should be ejected?", "Material Ejection", 1) as null|num
			if(isnull(amount))
				return TRUE
			amount = clamp(round(amount), 1, available_sheets)
			. = linked_silo.eject_material(material_id, amount)
		if("fabricator_purge")
			var/build_flag = tgui_screen_name() == "protolathe" ? PROTOLATHE : IMPRINTER
			var/obj/structure/machinery/r_n_d/fabricator/fabricator = get_primary_fabricator(build_flag)
			if(fabricator?.reagents)
				fabricator.reagents.del_reagent(params["reagent"])
				. = TRUE
		if("fabricator_purge_all")
			var/build_flag = tgui_screen_name() == "protolathe" ? PROTOLATHE : IMPRINTER
			var/obj/structure/machinery/r_n_d/fabricator/fabricator = get_primary_fabricator(build_flag)
			if(fabricator?.reagents)
				fabricator.reagents.clear_reagents()
				. = TRUE
		if("fabricator_manufacturer")
			var/manufacturer_id = params["manufacturer"]
			if(manufacturer_id in GLOB.fabricator_robolimbs)
				var/datum/robolimb/robolimb = GLOB.fabricator_robolimbs[manufacturer_id]
				selected_mech_manufacturer = robolimb.company
				. = TRUE
		if("set_queue_amount")
			var/new_amount = clamp(text2num(params["amount"]), 1, 100)
			if(new_amount in list(1, 5, 10))
				queue_amount = new_amount
			return TRUE
		if("set_custom_queue_amount")
			var/new_amount = input(usr, "How many copies should be queued at once?", "Queue Amount", queue_amount) as null|num
			if(isnull(new_amount))
				return TRUE
			queue_amount = clamp(round(new_amount), 1, 100)
			return TRUE
		if("find_devices")
			if(allowed(usr) || emagged)
				busy_message = "Scanning for nearby research devices..."
				screen = 0.2
				addtimer(CALLBACK(src, PROC_REF(finish_find_devices)), 5)
				. = TRUE
		if("disconnect")
			switch(params["device"])
				if("analyzer")
					if(linked_destroy)
						linked_destroy.linked_console = null
						linked_destroy = null
				if("protolathe")
					disconnect_fabricators(PROTOLATHE)
				if("imprinter")
					disconnect_fabricators(IMPRINTER)
				if("mechfab")
					disconnect_fabricators(MECHFAB)
				if("silo")
					linked_silo?.disconnect_console()
			. = TRUE
		if("toggle_sync")
			if(allowed(usr) || emagged)
				sync = !sync
				. = TRUE
		if("sync_network")
			if((allowed(usr) || emagged) && sync)
				griefProtection()
				busy_message = "Synchronizing research database with the network..."
				screen = 0.3
				addtimer(CALLBACK(src, PROC_REF(finish_network_sync)), 30)
				. = TRUE
		if("reset_database")
			if(allowed(usr) || emagged)
				griefProtection()
				qdel(files)
				files = new /datum/research(src)
				. = TRUE
		if("print_research")
			var/detailed = !!params["detailed"]
			var/obj/item/paper/PR = new /obj/item/paper
			var/info = "<center><b>[station_name()] Science Laboratories</b><h2>[detailed ? "Detailed" : ""] Research Progress Report</h2><i>report prepared at [worldtime2text()] station time</i></center><br>"
			info += detailed ? GetResearchListInfo() : GetResearchLevelsInfo()
			PR.set_content_unsafe("list of researched technologies", info)
			print(PR, user = usr)
			. = TRUE
	if(.)
		SStgui.update_uis(src)


/obj/structure/machinery/computer/rdconsole/proc/finish_find_devices()
	SyncRDevices()
	busy_message = "Processing request. Please wait."
	screen = 1.6
	SStgui.update_uis(src)

/obj/structure/machinery/computer/rdconsole/proc/finish_network_sync()
	SyncTechs()
	busy_message = "Processing request. Please wait."
	screen = 1.6
	SStgui.update_uis(src)

/obj/structure/machinery/computer/rdconsole/proc/finish_analyzer_deconstruction()
	if(!linked_destroy)
		screen = 1.0
		return
	linked_destroy.busy = FALSE
	if(!linked_destroy.loaded_item)
		screen = 1.0
		SStgui.update_uis(src)
		return
	for(var/T in linked_destroy.loaded_item.origin_tech)
		files.UpdateTech(T, linked_destroy.loaded_item.origin_tech[T])
	if(linked_silo && linked_destroy.loaded_item.matter)
		for(var/t in linked_destroy.loaded_item.matter)
			linked_silo.add_material(t, linked_destroy.loaded_item.matter[t] * linked_destroy.decon_mod)
	linked_destroy.loaded_item = null
	for(var/obj/I in linked_destroy.contents)
		for(var/mob/M in I.contents)
			M.death()
			qdel(M)
		if(istype(I, /obj/item/stack/material))
			var/obj/item/stack/material/S = I
			if(S.get_amount() > 1)
				S.use(1)
				linked_destroy.loaded_item = S
			else
				qdel(S)
		else if(!(I in linked_destroy.component_parts))
			qdel(I)
	linked_destroy.icon_state = linked_destroy.loaded_item ? linked_destroy.icon_state : "d_analyzer"
	use_power_oneoff(linked_destroy.active_power_usage)
	griefProtection()
	screen = 1.0
	SStgui.update_uis(src)

/obj/structure/machinery/computer/rdconsole/robotics
	name = "robotics R&D console"
	id = 1
	req_access = list(ACCESS_ROBOTICS)
	allow_analyzer = FALSE
	manufacturer = "hephaestus"
	circuit = /obj/item/circuitboard/robotics_console

/obj/structure/machinery/computer/rdconsole/robotics/terminal
	name = "robotics R&D terminal"
	icon = 'icons/obj/modular_computers/modular_terminal.dmi'
	icon_screen = "mecha"
	icon_keyboard = "power_key"
	icon_keyboard_emis = "power_key_mask"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/structure/machinery/computer/rdconsole/core
	name = "core R&D console"
	desc = "A console which is used to operate various research devices. It is the backbone of any megacorporate research division."
	id = 1
