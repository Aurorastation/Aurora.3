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

	/// Cached static fabrication catalogue data, keyed by build type.
	var/list/fabricator_catalogue_cache = list()

	var/protolathe_category = "All"
	var/imprinter_category = "All"

	var/ref_for_ui

	//Data and setting manipulation requires scientist access.
	req_access = list(/datum/access/tox::id)

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

/datum/research_console_device_tgui_data
	/// Number of linked destructive analyzers.
	var/analyzer = 0
	/// Number of linked protolathes.
	var/protolathe = 0
	/// Number of linked circuit imprinters.
	var/imprinter = 0
	/// Number of linked synthetic fabricators.
	var/mechfab = 0
	/// Number of linked material silos.
	var/silo = 0

/datum/research_console_device_tgui_data/proc/to_list()
	return list(
		"analyzer" = analyzer,
		"protolathe" = protolathe,
		"imprinter" = imprinter,
		"mechfab" = mechfab,
		"silo" = silo
	)

/datum/research_console_disk_tgui_data
	/// Disk type exposed to TGUI. Either "technology" or "design".
	var/design_type
	/// Display name of the inserted disk.
	var/name
	/// Display name of the datum currently stored on the disk.
	var/stored_name
	/// Description of the datum currently stored on the disk.
	var/stored_description
	/// Stored technology level, when this is a technology disk.
	var/stored_level

/datum/research_console_disk_tgui_data/proc/to_list()
	return list(
		"type" = design_type,
		"name" = name,
		"stored_name" = stored_name,
		"stored_description" = stored_description,
		"stored_level" = stored_level
	)

/datum/research_console_tgui_data
	/// Manufacturer theme used by the ResearchConsole TGUI.
	var/manufacturer
	/// Name of the screen currently being displayed.
	var/screen
	/// Whether the current user can perform restricted console actions.
	var/authorized = FALSE
	/// Whether the console's access restrictions have been emagged.
	var/emagged = FALSE
	/// Whether this console participates in research network synchronization.
	var/network_sync = FALSE
	/// Text displayed while a delayed console operation is running.
	var/busy_message
	/// Information about the disk currently inserted into the console.
	var/datum/research_console_disk_tgui_data/loaded_disk
	/// Number of copies added by a fabrication queue action.
	var/queue_amount = 1
	/// Counts of machinery currently linked to the console.
	var/datum/research_console_device_tgui_data/devices
	/// Available research data points.
	var/research_points = 0
	/// Technology nodes displayed by tech tree screens.
	var/list/tech_nodes
	/// Technology rows displayed by technology-related screens.
	var/list/technologies
	/// Design rows displayed by design-related screens.
	var/list/designs
	/// Live destructive-analyzer payload.
	var/list/analyzer
	/// Live payload for the fabricator screen currently being displayed.
	var/list/fabricator

/datum/research_console_tgui_data/New()
	. = ..()
	devices = new

/datum/research_console_tgui_data/Destroy()
	QDEL_NULL(loaded_disk)
	QDEL_NULL(devices)
	tech_nodes = null
	technologies = null
	designs = null
	analyzer = null
	fabricator = null
	return ..()

/datum/research_console_tgui_data/proc/to_list()
	return list(
		"manufacturer" = manufacturer,
		"screen" = screen,
		"authorized" = authorized,
		"emagged" = emagged,
		"network_sync" = network_sync,
		"busy_message" = busy_message,
		"loaded_disk" = loaded_disk?.to_list(),
		"queue_amount" = queue_amount,
		"devices" = devices.to_list(),
		"research_points" = research_points,
		"tech_nodes" = tech_nodes,
		"technologies" = technologies,
		"designs" = designs,
		"analyzer" = analyzer,
		"fabricator" = fabricator
	)

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
	invalidate_fabricator_catalogues()
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
	invalidate_fabricator_catalogues()
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
	invalidate_fabricator_catalogues()

/obj/structure/machinery/computer/rdconsole/proc/SyncTechs()
	var/turf/turf = get_turf(src)
	var/list/available_servers = list()
	for(var/obj/structure/machinery/r_n_d/server/S in SSmachinery.machinery)
		var/turf/ST = get_turf(S)
		if(ST && !AreConnectedZLevels(ST.z, turf.z))
			continue
		available_servers += S

	// Away sites use their own research server when one is present. Otherwise,
	// NTNet coverage allows them to fall back to the Horizon's research server.
	if(!length(available_servers) && GLOB.ntnet_global)
		var/list/reachable_z_levels = GLOB.ntnet_global.get_reachable_z_levels_for_endpoint(src)
		for(var/obj/structure/machinery/r_n_d/server/S in SSmachinery.machinery)
			var/turf/ST = get_turf(S)
			if(!ST || !is_station_level(ST.z) || !(ST.z in reachable_z_levels))
				continue
			if(istype(S, /obj/structure/machinery/r_n_d/server/centcom))
				continue
			available_servers += S

	for(var/obj/structure/machinery/r_n_d/server/S as anything in available_servers)
		var/server_processed = 0
		if((id in S.id_with_upload) || istype(S, /obj/structure/machinery/r_n_d/server/centcom))
			for(var/tech_id in files.known_tech)
				var/datum/tech/T = files.known_tech[tech_id]
				S.files.AddTech2Known(T)
			S.files.research_points = max(S.files.research_points, files.research_points)
			S.files.unlocked_nodes |= files.unlocked_nodes
			for(var/nid in files.invested_points)
				S.files.invested_points[nid] = max(S.files.invested_points[nid] || 0, files.invested_points[nid])
			S.files.RefreshResearch()
			server_processed = 1
		files.known_tech = S.files.known_tech.Copy()
		files.research_points = max(files.research_points, S.files.research_points)
		files.unlocked_nodes |= S.files.unlocked_nodes
		for(var/nid in S.files.invested_points)
			files.invested_points[nid] = max(files.invested_points[nid] || 0, S.files.invested_points[nid])
		if(!istype(S, /obj/structure/machinery/r_n_d/server/centcom) && server_processed)
			S.produce_heat()
	files.RefreshResearch()
	invalidate_fabricator_catalogues()
	screen = 1.6
	updateUsrDialog()

//Have it automatically push research to the centcomm server so wild griffins can't fuck up R&D's work
/obj/structure/machinery/computer/rdconsole/proc/griefProtection()
	for(var/obj/structure/machinery/r_n_d/server/centcom/C in SSmachinery.machinery)
		for(var/tech_id in files.known_tech)
			var/datum/tech/T = files.known_tech[tech_id]
			C.files.AddTech2Known(T)
		C.files.research_points = max(C.files.research_points, files.research_points)
		C.files.unlocked_nodes |= files.unlocked_nodes
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
	fabricator_catalogue_cache = null
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
		else if (istype(attacking_item, /obj/item/disk/survey_data))
			to_chat(user, SPAN_NOTICE("\The [src] displays a prompt: \"Planetary survey data must be analyzed via the Destructive Analyzer or exported via Cargo.\""))
			return
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
	dat += "<center><b>Available Research Data Points:</b> [files.research_points]</center><br>"
	dat += "<h3>Researched Technology Nodes</h3><UL>"
	for(var/node_id in files.unlocked_nodes)
		var/datum/tech_node/node = GLOB.tech_nodes[node_id]
		if(node)
			dat += "<LI><b>[node.name]</b> ([node.branch] - Tier [node.tier]): [node.desc]</LI>"
	dat += "</UL>"
	dat += "<h3>Underlying Technology Fields</h3><UL>"
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

/obj/structure/machinery/computer/rdconsole/proc/get_tech_nodes_tgui_data()
	var/list/result = list()
	for(var/node_id in GLOB.tech_nodes)
		var/datum/tech_node/N = GLOB.tech_nodes[node_id]
		if(N.antag_tech && !emagged)
			continue
		var/is_unlocked = (node_id in files.unlocked_nodes)
		var/can_unlock = files.can_unlock_node(node_id)
		var/can_afford = (files.research_points >= N.cost)
		var/invested = N.starts_unlocked ? 0 : (files.invested_points[node_id] || 0)
		var/is_outermost = is_unlocked && files.is_outermost_node(node_id)
		var/needs_maintenance = is_unlocked && !N.starts_unlocked && N.cost > 0 && invested < N.cost

		var/list/unlocks = list()
		for(var/design_path in N.unlocked_designs)
			var/datum/design/D = GLOB.designs[design_path]
			if(D)
				unlocks += D.name

		result += list(list(
			"id" = N.id,
			"name" = N.name,
			"description" = N.desc,
			"branch" = N.branch,
			"corporation" = N.corporation,
			"tier" = N.tier,
			"cost" = N.cost,
			"prereqs" = N.prereq_ids.Copy(),
			"unlocks" = unlocks,
			"icon" = N.icon,
			"unlocked" = is_unlocked,
			"can_unlock" = can_unlock,
			"can_afford" = can_afford,
			"invested" = invested,
			"is_outermost" = is_outermost,
			"needs_maintenance" = needs_maintenance
		))
	return result

/obj/structure/machinery/computer/rdconsole/proc/get_analyzer_tgui_data()
	var/list/result = list(
		"linked" = !!linked_destroy,
		"bounty_rerolls" = files.bounty_rerolls
	)
	var/list/bounties_data = list()
	for(var/datum/research_bounty/B in files.active_bounties)
		bounties_data += list(B.to_tgui_data(linked_destroy?.loaded_item))
	result["bounties"] = bounties_data

	if(!linked_destroy)
		return result
	result["busy"] = linked_destroy.busy
	if(!linked_destroy.loaded_item)
		return result

	var/obj/loaded = linked_destroy.loaded_item
	var/estimated_points = 0
	var/matched_title = null

	var/list/item_data = list(
		"name" = loaded.name,
		"stack" = istype(loaded, /obj/item/stack),
		"is_prototype" = FALSE,
		"is_seed" = FALSE,
		"is_slime_core" = FALSE,
		"is_circuit" = FALSE,
		"is_survey_disk" = FALSE,
		"is_artifact" = FALSE,
		"technologies" = list()
	)

	if(istype(loaded, /obj/item/gun/energy/laser/prototype))
		var/obj/item/gun/energy/laser/prototype/P = loaded
		item_data["is_prototype"] = TRUE

		var/l_modified_damage = 1 / max(1, P.burst - 1)
		var/l_modified_max_shots = 1
		for(var/obj/item/laser_components/l_component in list(P.capacitor, P.focusing_lens, P.modulator) + P.gun_mods)
			if(l_component.damage != 0)
				l_modified_damage *= l_component.damage
			if(l_component.shots != 0)
				l_modified_max_shots *= l_component.shots

		var/obj/projectile/proj = P.projectile_type
		item_data["specs"] = list(
			"damage" = round(min(60, l_modified_damage), 1),
			"max_shots" = max(P.max_shots, round(l_modified_max_shots)),
			"burst" = P.burst,
			"fire_delay" = P.fire_delay,
			"reliability" = round(P.reliability, 1),
			"self_recharge" = !!P.self_recharge,
			"mods_count" = length(P.gun_mods),
			"armor_penetration" = proj ? initial(proj.armor_penetration) : 0,
			"stun" = proj ? (initial(proj.stun) > 0) : FALSE
		)

		var/datum/research_bounty/matched = files.get_matching_bounty(P)
		if(matched)
			matched_title = matched.title
			estimated_points = round(matched.reward_points * (1 + linked_destroy.decon_mod * 0.25))
		else
			estimated_points = 150
	else if(istype(loaded, /obj/item/seeds))
		var/obj/item/seeds/seed_pkt = loaded
		item_data["is_seed"] = TRUE
		var/datum/seed/S = seed_pkt.seed
		if(S)
			var/list/traits_list = list()
			if(GET_SEED_TRAIT(S, TRAIT_HARVEST_REPEAT) >= 1)
				traits_list += "Perennial"
			if(GET_SEED_TRAIT(S, TRAIT_BIOLUM) >= 1)
				traits_list += "Bioluminescent"
			if(GET_SEED_TRAIT(S, TRAIT_PRODUCES_POWER) >= 1)
				traits_list += "Produces Power"
			if(GET_SEED_TRAIT(S, TRAIT_TELEPORTING) >= 1)
				traits_list += "Bluespace / Teleporting"
			if(GET_SEED_TRAIT(S, TRAIT_EXPLOSIVE) >= 1)
				traits_list += "Explosive"
			if(GET_SEED_TRAIT(S, TRAIT_CARNIVOROUS) >= 1)
				traits_list += "Carnivorous"
			if(GET_SEED_TRAIT(S, TRAIT_SPREAD) >= 1)
				traits_list += "Spreading"
			if(GET_SEED_TRAIT(S, TRAIT_SPOROUS) >= 1)
				traits_list += "Sporous"
			if(GET_SEED_TRAIT(S, TRAIT_STINGS) >= 1)
				traits_list += "Stinging"

			item_data["seed_specs"] = list(
				"species" = S.display_name || S.seed_name || loaded.name,
				"potency" = GET_SEED_TRAIT(S, TRAIT_POTENCY),
				"yield" = GET_SEED_TRAIT(S, TRAIT_YIELD),
				"endurance" = GET_SEED_TRAIT(S, TRAIT_ENDURANCE),
				"maturation" = GET_SEED_TRAIT(S, TRAIT_MATURATION),
				"production" = GET_SEED_TRAIT(S, TRAIT_PRODUCTION),
				"toxins_tolerance" = GET_SEED_TRAIT(S, TRAIT_TOXINS_TOLERANCE),
				"heat_tolerance" = GET_SEED_TRAIT(S, TRAIT_HEAT_TOLERANCE),
				"special_traits" = traits_list
			)
		var/datum/research_bounty/matched = files.get_matching_bounty(seed_pkt)
		if(matched)
			matched_title = matched.title
			estimated_points = round(matched.reward_points * (1 + linked_destroy.decon_mod * 0.25))
		else
			estimated_points = 100
	else if(istype(loaded, /obj/item/slime_extract))
		var/obj/item/slime_extract/E = loaded
		item_data["is_slime_core"] = TRUE
		item_data["slime_specs"] = list(
			"uses" = E.uses,
			"enhanced" = !!E.enhanced
		)
		var/datum/research_bounty/matched = files.get_matching_bounty(E)
		if(matched)
			matched_title = matched.title
			estimated_points = round(matched.reward_points * (1 + linked_destroy.decon_mod * 0.25))
		else
			estimated_points = 100
	else if(istype(loaded, /obj/item/electronic_assembly))
		var/obj/item/electronic_assembly/A = loaded
		item_data["is_circuit"] = TRUE
		var/num_pads = 0
		var/txt_pads = 0
		var/btns = 0
		var/toggles = 0
		var/scrs = 0
		var/comp_count = 0
		for(var/obj/item/integrated_circuit/IC in A.contents)
			comp_count++
			if(istype(IC, /obj/item/integrated_circuit/input/numberpad))
				num_pads++
			else if(istype(IC, /obj/item/integrated_circuit/input/textpad))
				txt_pads++
			else if(istype(IC, /obj/item/integrated_circuit/input/button))
				btns++
			else if(istype(IC, /obj/item/integrated_circuit/input/toggle_button))
				toggles++
			else if(istype(IC, /obj/item/integrated_circuit/output/screen))
				scrs++
		item_data["circuit_specs"] = list(
			"components" = comp_count,
			"numberpads" = num_pads,
			"textpads" = txt_pads,
			"buttons" = btns,
			"toggles" = toggles,
			"screens" = scrs
		)
		var/datum/research_bounty/matched = files.get_matching_bounty(A)
		if(matched)
			matched_title = matched.title
			estimated_points = round(matched.reward_points * (1 + linked_destroy.decon_mod * 0.25))
		else
			estimated_points = 100
	else if(istype(loaded, /obj/item/disk/survey_data))
		var/obj/item/disk/survey_data/SD = loaded
		item_data["is_survey_disk"] = TRUE
		item_data["survey_specs"] = list(
			"planet" = SD.planet_name,
			"survey_type" = SD.survey_type ? capitalize(SD.survey_type) : "General"
		)
		var/datum/research_bounty/matched = files.get_matching_bounty(SD)
		if(matched)
			matched_title = matched.title
			estimated_points = round(matched.reward_points * (1 + linked_destroy.decon_mod * 0.25))
		else
			for(var/tech_id in SD.origin_tech)
				estimated_points += SD.origin_tech[tech_id] * 200
			estimated_points = round(estimated_points * (1 + linked_destroy.decon_mod))
	else if(istype(loaded, /obj/structure/machinery/artifact))
		var/obj/structure/machinery/artifact/A = loaded
		item_data["is_artifact"] = TRUE
		var/trig_label = "Unknown"
		var/eff_label = "Unknown"
		if(A.my_effect)
			if(A.my_effect.trigger >= 0 && A.my_effect.trigger <= 4)
				trig_label = "Physical / Touch"
			else if(A.my_effect.trigger >= 5 && A.my_effect.trigger <= 8)
				trig_label = "Energetic"
			else if(A.my_effect.trigger >= 9 && A.my_effect.trigger <= 12)
				trig_label = "Atmospheric / Thermal"
			switch(A.my_effect.effect_type)
				if(1)
					eff_label = "Concentrated Energy"
				if(2)
					eff_label = "Psionic Wavefront"
				if(3)
					eff_label = "Electromagnetic"
				if(4)
					eff_label = "Particle Field"
				if(5)
					eff_label = "Bio-Reactive"
				if(6)
					eff_label = "Bluespace Phasing"
				if(7)
					eff_label = "Atomic Synthesis"
		item_data["artifact_specs"] = list(
			"artifact_id" = A.my_effect?.artifact_id || "Unknown",
			"trigger_type" = trig_label,
			"effect_type" = eff_label,
			"has_secondary" = !!A.secondary_effect
		)
		var/datum/research_bounty/matched = files.get_matching_bounty(A)
		if(matched)
			matched_title = matched.title
			estimated_points = round(matched.reward_points * (1 + linked_destroy.decon_mod * 0.25))
		else
			estimated_points = 200
	else if(istype(loaded, /obj/item))
		var/obj/item/I_loaded = loaded
		for(var/tech_id in I_loaded.origin_tech)
			estimated_points += I_loaded.origin_tech[tech_id] * 200
		estimated_points = round(estimated_points * (1 + linked_destroy.decon_mod))

	item_data["points"] = estimated_points
	item_data["matched_bounty"] = matched_title
	result["item"] = item_data
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

/obj/structure/machinery/computer/rdconsole/proc/invalidate_fabricator_catalogues()
	fabricator_catalogue_cache = list()

/obj/structure/machinery/computer/rdconsole/proc/get_research_fabricator_catalogue(build_flag)
	var/cache_key = "[build_flag]"
	var/list/cached = fabricator_catalogue_cache[cache_key]
	if(cached)
		return cached

	var/list/fabricators = get_fabricators(build_flag)
	if(!length(fabricators))
		return null

	var/obj/structure/machinery/r_n_d/fabricator/primary = fabricators[1]
	var/list/catalogue = list(
		"recipes" = list(),
		"categories" = list("All"),
		"supports_manufacturers" = !!(build_flag & MECHFAB),
		"manufacturers" = list(),
		"supports_reagents" = FALSE
	)

	if(build_flag & MECHFAB)
		for(var/manufacturer_id in GLOB.fabricator_robolimbs)
			var/datum/robolimb/robolimb = GLOB.fabricator_robolimbs[manufacturer_id]
			catalogue["manufacturers"] += list(list("id" = manufacturer_id, "name" = robolimb.company))

	for(var/path in files.known_designs)
		var/datum/design/design = files.known_designs[path]
		if(!design.build_path || !(design.build_type & build_flag))
			continue

		var/category = get_design_category(design, build_flag)
		catalogue["categories"] |= category
		var/list/resources = list()
		var/list/requirements = list()

		var/list/design_materials = design.GetFabricationMaterials(primary)
		for(var/material_id in design_materials)
			var/material_path = SSmaterials.material_to_path(material_id, FALSE)
			if(!material_path)
				material_path = material_id
			var/required_material = primary.get_required_material_amount(design, material_id)
			var/material_name = CallMaterialName(material_id)
			resources += "[required_material] [material_name]"
			requirements += list(list("id" = "[material_path]", "name" = material_name, "required" = required_material, "type" = "material"))

		if(primary.uses_reagents && length(design.chemicals))
			catalogue["supports_reagents"] = TRUE
			for(var/reagent_id in design.chemicals)
				var/required_reagent = primary.get_required_reagent_amount(design, reagent_id)
				var/reagent_name = CallReagentName(reagent_id)
				resources += "[required_reagent] [reagent_name]"
				requirements += list(list("id" = "[reagent_id]", "name" = reagent_name, "required" = required_reagent, "type" = "reagent"))

		var/fastest_time = null
		for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in fabricators)
			var/machine_time = round(design.time / fabricator.production_speed)
			if(isnull(fastest_time) || machine_time < fastest_time)
				fastest_time = machine_time

		catalogue["recipes"] += list(list(
			"name" = design.GetFabricationName(primary),
			"description" = design.GetFabricationDesc(primary),
			"design" = "[path]",
			"category" = category,
			"resources" = english_list(resources),
			"requirements" = requirements,
			"build_time" = fastest_time || design.time
		))

	fabricator_catalogue_cache[cache_key] = catalogue
	return catalogue

/obj/structure/machinery/computer/rdconsole/proc/get_research_fabricator_live_data(build_flag)
	var/list/fabricators = get_fabricators(build_flag)
	if(!length(fabricators))
		return null

	var/list/catalogue = get_research_fabricator_catalogue(build_flag)
	if(!catalogue)
		return null

	var/obj/structure/machinery/r_n_d/fabricator/primary = fabricators[1]
	var/list/job_queue = get_job_queue(build_flag)
	var/list/stored_materials = linked_silo?.materials || list()
	SSmaterials.normalize_material_amounts(stored_materials)
	var/datum/reagents/reagent_holder = primary.uses_reagents ? primary.reagents : null
	var/list/data = list(
		"linked" = TRUE,
		"materials" = list(),
		"reagents" = list(),
		"reagent_stores" = list(),
		"recipes" = catalogue["recipes"],
		"categories" = catalogue["categories"],
		"queue" = list(),
		"sheet_material_amount" = SHEET_MATERIAL_AMOUNT,
		"maximum_material_storage" = linked_silo?.max_material_storage || 0,
		"maximum_reagent_volume" = reagent_holder?.maximum_volume || 0,
		"reagent_volume" = reagent_holder?.total_volume || 0,
		"supports_manufacturers" = catalogue["supports_manufacturers"],
		"manufacturers" = catalogue["manufacturers"],
		"selected_manufacturer" = selected_mech_manufacturer,
		"supports_reagents" = catalogue["supports_reagents"]
	)

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

	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in fabricators)
		if(!fabricator.uses_reagents || !fabricator.reagents)
			continue
		var/list/store = list("reagents" = list())
		for(var/reagent_type in fabricator.reagents.reagent_volumes)
			store["reagents"] += list(list(
				"id" = "[reagent_type]",
				"amount" = fabricator.reagents.reagent_volumes[reagent_type]
			))
		data["reagent_stores"] += list(store)

	var/index = 1
	for(var/datum/research_fabrication_job/job as anything in job_queue)
		var/obj/structure/machinery/r_n_d/fabricator/machine = job.assigned_machine
		var/obj/structure/machinery/r_n_d/fabricator/display_machine = machine ? machine : primary
		var/build_time = machine ? round(job.design.time / machine.production_speed) : round(job.design.time / primary.production_speed)
		var/remaining_time = machine?.build_callback_timer ? max(0, timeleft(machine.build_callback_timer)) : 0
		data["queue"] += list(list(
			"index" = index,
			"name" = job.design.GetFabricationName(display_machine),
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

	var/datum/research_console_tgui_data/data = new
	data.manufacturer = manufacturer
	data.screen = tgui_screen_name()
	data.authorized = allowed(user) || emagged
	data.emagged = emagged
	data.network_sync = sync
	data.busy_message = busy_message
	data.queue_amount = queue_amount
	data.research_points = files.research_points
	data.tech_nodes = get_tech_nodes_tgui_data()

	data.devices.analyzer = linked_destroy ? 1 : 0
	data.devices.protolathe = length(get_fabricators(PROTOLATHE))
	data.devices.imprinter = length(get_fabricators(IMPRINTER))
	data.devices.mechfab = length(get_fabricators(MECHFAB))
	data.devices.silo = linked_silo ? 1 : 0

	if(t_disk)
		data.loaded_disk = new
		data.loaded_disk.design_type = "technology"
		data.loaded_disk.name = t_disk.name
		data.loaded_disk.stored_name = t_disk.stored?.name
		data.loaded_disk.stored_description = t_disk.stored?.desc
		data.loaded_disk.stored_level = t_disk.stored?.level
	else if(d_disk)
		data.loaded_disk = new
		data.loaded_disk.design_type = "design"
		data.loaded_disk.name = d_disk.name
		data.loaded_disk.stored_name = d_disk.blueprint?.name
		data.loaded_disk.stored_description = d_disk.blueprint?.desc

	switch(data.screen)
		if("levels")
			data.technologies = get_technology_tgui_data()
		if("designs")
			data.designs = get_design_tgui_data()
		if("tech_disk")
			data.technologies = get_technology_tgui_data()
		if("design_disk")
			data.designs = get_design_tgui_data()
		if("analyzer")
			data.analyzer = get_analyzer_tgui_data()
		if("protolathe")
			data.fabricator = get_research_fabricator_live_data(PROTOLATHE)
		if("imprinter")
			data.fabricator = get_research_fabricator_live_data(IMPRINTER)
		if("mechfab")
			data.fabricator = get_research_fabricator_live_data(MECHFAB)

	var/list/result = data.to_list()
	qdel(data)
	return result

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
		if("unlock_node")
			if(!allowed(usr) && !emagged)
				to_chat(usr, SPAN_WARNING("Unauthorized access."))
				return FALSE
			var/node_id = params["id"]
			if(!node_id)
				return FALSE
			if(files.unlock_node(node_id))
				playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)
				var/datum/tech_node/node = GLOB.tech_nodes[node_id]
				to_chat(usr, SPAN_NOTICE("Technology unlocked: [node?.name]!"))
				invalidate_fabricator_catalogues()
				griefProtection()
				. = TRUE
			else
				playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
				to_chat(usr, SPAN_WARNING("Unable to unlock technology node."))
				return FALSE
		if("maintain_node")
			if(!allowed(usr) && !emagged)
				to_chat(usr, SPAN_WARNING("Unauthorized access."))
				return FALSE
			var/node_id = params["id"]
			if(!node_id)
				return FALSE
			var/spent = files.maintain_node(node_id)
			if(spent > 0)
				playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)
				var/datum/tech_node/node = GLOB.tech_nodes[node_id]
				to_chat(usr, SPAN_NOTICE("Reinvested [spent] research data points into [node?.name]."))
				griefProtection()
				. = TRUE
			else
				playsound(src, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
				to_chat(usr, SPAN_WARNING("Unable to reinvest points into this technology node."))
				return FALSE
		if("upload_disk")
			if(t_disk?.stored)
				files.AddTech2Known(t_disk.stored)
				files.RefreshResearch()
				invalidate_fabricator_catalogues()
				griefProtection()
				. = TRUE
			else if(d_disk?.blueprint)
				files.AddDesign2Known(d_disk.blueprint)
				invalidate_fabricator_catalogues()
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
				if(istype(linked_destroy.loaded_item, /obj/item) && linked_destroy.Adjacent(usr))
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
		if("reroll_bounty")
			if(!allowed(usr) && !emagged)
				to_chat(usr, SPAN_WARNING("Unauthorized access."))
				return FALSE
			if(files.bounty_rerolls <= 0)
				to_chat(usr, SPAN_WARNING("No contract rerolls remaining. Complete a bounty to earn another reroll."))
				return FALSE
			var/bounty_id = params["id"]
			if(bounty_id && files.reroll_bounty(bounty_id))
				playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)
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
				files.RefreshResearch()
				invalidate_fabricator_catalogues()
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
	var/awarded_points = 0
	var/obj/loaded = linked_destroy.loaded_item
	if(istype(loaded, /obj/item/gun/energy/laser/prototype) || istype(loaded, /obj/item/seeds) || istype(loaded, /obj/item/slime_extract) || istype(loaded, /obj/item/electronic_assembly) || istype(loaded, /obj/item/disk/survey_data) || istype(loaded, /obj/structure/machinery/artifact))
		var/datum/research_bounty/matched = files.get_matching_bounty(loaded)
		if(matched)
			var/corp = matched.corporation
			var/bounty_title = matched.title
			var/base_reward = files.complete_bounty(matched)
			awarded_points = round(base_reward * (1 + linked_destroy.decon_mod * 0.25))
			files.add_research_points(awarded_points)
			visible_message(SPAN_NOTICE("\The [src] chimes: \"Corporate contract '[bounty_title]' fulfilled for [corp]! +[awarded_points] research data points awarded.\""))
		else
			awarded_points = istype(loaded, /obj/structure/machinery/artifact) ? 200 : (istype(loaded, /obj/item/gun/energy/laser/prototype) ? 150 : 100)
			files.add_research_points(awarded_points)
			visible_message(SPAN_NOTICE("\The [src] chimes: \"Baseline telemetry recorded (+[awarded_points] research data points).\""))
	else if(istype(loaded, /obj/item))
		var/obj/item/I_loaded = loaded
		for(var/T in I_loaded.origin_tech)
			files.UpdateTech(T, I_loaded.origin_tech[T])
			awarded_points += I_loaded.origin_tech[T] * 200
		if(awarded_points)
			awarded_points = round(awarded_points * (1 + linked_destroy.decon_mod))
			files.add_research_points(awarded_points)
			visible_message(SPAN_NOTICE("\The [src] chimes: \"Survey telemetry processed! +[awarded_points] research data points awarded.\""))
	files.RefreshResearch()
	invalidate_fabricator_catalogues()
	if(linked_silo && istype(loaded, /obj/item))
		var/obj/item/I_mat = loaded
		if(I_mat.matter)
			for(var/t in I_mat.matter)
				linked_silo.add_material(t, I_mat.matter[t] * linked_destroy.decon_mod)
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
	req_access = list(/datum/access/robotics::id)
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
