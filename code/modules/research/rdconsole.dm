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

/obj/machinery/computer/rdconsole
	name = "R&D control console"

	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.
	var/obj/item/weapon/disk/tech_disk/t_disk = null	//Stores the technology disk.
	var/obj/item/weapon/disk/design_disk/d_disk = null	//Stores the design disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/screen = 20	//Which screen is currently showing.
	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console

	req_access = list(access_research)	//Data and setting manipulation requires scientist access.

/obj/machinery/computer/rdconsole/proc/CallMaterialName(var/ID)
	var/return_name = ID
	switch(return_name)
		if("metal")
			return_name = "Metal"
		if("glass")
			return_name = "Glass"
		if("gold")
			return_name = "Gold"
		if("silver")
			return_name = "Silver"
		if("phoron")
			return_name = "Solid Phoron"
		if("uranium")
			return_name = "Uranium"
		if("diamond")
			return_name = "Diamond"
	return return_name

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/ID)
	var/return_name = ID
	var/datum/reagent/temp_reagent
	for(var/R in (typesof(/datum/reagent) - /datum/reagent))
		temp_reagent = null
		temp_reagent = new R()
		if(temp_reagent.id == ID)
			return_name = temp_reagent.name
			qdel(temp_reagent)
			temp_reagent = null
			break
	return return_name

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(3, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer))
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/proc/griefProtection() //Have it automatically push research to the centcomm server so wild griffins can't fuck up R&D's work
	for(var/obj/machinery/r_n_d/server/centcom/C in SSmachinery.all_machines)
		for(var/datum/tech/T in files.known_tech)
			C.files.AddTech2Known(T)
		for(var/datum/design/D in files.known_designs)
			C.files.AddDesign2Known(D)
		C.files.RefreshResearch()

/obj/machinery/computer/rdconsole/Initialize()
	. = ..()
	files = new /datum/research(src) //Setup the research data holder.
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in SSmachinery.all_machines)
			S.setup()
			break
	SyncRDevices()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	//Loading a disk into it.
	if(istype(D, /obj/item/weapon/disk))
		if(t_disk || d_disk)
			user << "A disk is already loaded into the machine."
			return

		if(istype(D, /obj/item/weapon/disk/tech_disk))
			t_disk = D
		else if (istype(D, /obj/item/weapon/disk/design_disk))
			d_disk = D
		else
			user << "<span class='notice'>Machine cannot accept disks in that format.</span>"
			return
		user.drop_item()
		D.loc = src
		user << "<span class='notice'>You add \the [D] to the machine.</span>"
	else
		//The construction/deconstruction of the console code.
		..()

	src.updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/emp_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		user << "<span class='notice'>You you disable the security protocols.</span>"
		return 1

/obj/machinery/computer/rdconsole/proc/get_task()
	var/task = null
	switch(screen)
		if(10)
			task = "Updating Database..."

		if(11)
			task= "Processing and Updating Database..."

		if(13)
			task= "Constructing Prototype. Please Wait..."

		if(14)
			task = "Imprinting Circuit. Please Wait..."

		if(15)
			task = "Printing Research Information. Please Wait..."
		
	return task

/obj/machinery/computer/rdconsole/proc/screen_number2text()
	var/textscreen = null
	switch(screen)
		if(20)
			textscreen = "Main Menu"

		if(21)
			textscreen = "Research Levels Overview"

		if(22 to 23)
			textscreen = "Technology Disk Control"

		if(24 to 25)	
			textscreen = "Design Disk Control"

		if(26)
			textscreen = "Console Setings"

		if(27)
			textscreen = "Device Linking"

		if(30 to 32)
			textscreen = "Destructive Analyzer Control"
		
		if(40 to 41)
			textscreen = "Protolathe Control"

		if(42)
			textscreen = "Protolathe Chemical Control"

		if(43)
			textscreen = "Protolathe Material Control"

		if(44)
			textscreen = "Protolathe Queue Control"
		
		if(50 to 51)
			textscreen = "Circuit Imprinter Control"

		if(52)
			textscreen = "Circuit Imprinter Chemical Control"

		if(53)
			textscreen = "Circuit Imprinter Material Control"

		if(54)
			textscreen = "Circuit Imprinter Queue Control"

		if(60 to 69)
			textscreen = "Device Management"

	return textscreen

/obj/machinery/computer/rdconsole/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/task = get_task()
	var/textscreen = screen_number2text()
	var/list/knowndesigns = list()
	var/list/knowntech = list()
	var/list/linked_lathe_queue = list()
	var/list/linked_imprinter_queue = list()
	var/list/linked_destroy_iteminfo = list()
	var/list/linked_lathe_materialsinfo = list()
	var/list/linked_imprinter_materialsinfo = list()
	var/list/linked_imprinter_reagentsinfo = list()
	var/list/tdiskinfo = list()
	var/list/ddiskinfo = list()
	if(linked_lathe.materials)
		for(var/M in linked_lathe.materials)
			var/amount = linked_lathe.materials[M]
			linked_lathe_materialsinfo += list(list("MName" = "[capitalize(M)]", "Mamount" = "[amount]"))

	if(linked_imprinter.materials)
		for(var/M in linked_imprinter.materials)
			var/amount = linked_imprinter.materials[M]
			linked_imprinter_materialsinfo += list(list("MName" = "[capitalize(M)]", "Mamount" = "[amount]"))

	if(linked_imprinter.reagents)
		for(var/datum/reagent/R in linked_imprinter.reagents.reagent_list)
			linked_imprinter_reagentsinfo += list(list("CName" = "[capitalize(R)]", "Camount" = "[R.volume]"))

	if(linked_destroy)
		if(linked_destroy.loaded_item)
			for(var/T in linked_destroy.loaded_item.origin_tech)
				linked_destroy_iteminfo += list(list("OriginTech" = "[CallTechName(T)]:[linked_destroy.loaded_item.origin_tech[T]]"))

	for(var/datum/design/D in linked_lathe.queue)
		linked_lathe_queue += list(list("QName" = "[D.name]", "QID" = "[D.id]"))

	for(var/datum/design/D in linked_imprinter.queue)
		linked_imprinter_queue += list(list("IName" = "[D.name]", "IID" = "[D.id]"))

	for(var/datum/design/D in files.known_designs)
		knowndesigns += list(list("Name" = "[D.name]", "BuildType" = "[D.build_type]", "BuildPath" = "[D.build_path]", "BuildTime" = "[D.time]", "ID" = "[D.id]"))

	for(var/datum/tech/T in files.known_tech)
		knowntech += list(list("TName" = "[T.name]", "TDID" = "[T.id]", "TLvl" = "[T.level]"))

	if(t_disk)
		tdiskinfo += list(list("tdisk" = "[t_disk]", "tdisktech" = "[t_disk.stored]"))

	if(d_disk)
		ddiskinfo += list(list("ddisk" = "[d_disk]", "ddisktech" = "[d_disk.blueprint]"))

	data["screen"] = screen
	data["textscreen"] = textscreen
	data["hastdisk"] = t_disk
	data["hasddisk"] = d_disk
	data["tdisk"] = tdiskinfo
	data["ddisk"] = ddiskinfo
	data["linked_analyzer"] = linked_destroy
	data["linked_analyzer_item"] = linked_destroy.loaded_item
	data["linked_analyzer_item_tech"] = linked_destroy_iteminfo
	data["linked_lathe"] = linked_lathe
	data["linked_lathe_materials"] = linked_lathe_materialsinfo
	data["linked_lathe_queue"]	= linked_lathe_queue
	data["linked_imprinter"] = linked_imprinter
	data["linked_imprinter_chemicals"] = linked_imprinter_reagentsinfo
	data["linked_imprinter_materials"] = linked_imprinter_materialsinfo
	data["linked_imprinter_queue"]	= linked_imprinter_queue
	data["known_designs"] = knowndesigns
	data["known_tech"] = knowntech
	data["emagged"] = emagged
	data["task"] = task
	data["sync"] = sync

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)	
	if (!ui)
		ui = new(user, src, ui_key, "rdconsole.tmpl", "Research Console", 600, 600)
		ui.set_initial_data(data)		
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/rdconsole/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	usr.set_machine(src)
	if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
		var/temp_screen = text2num(href_list["menu"])
		if(temp_screen <= 21 || (40 <= temp_screen && 59 >= temp_screen) || allowed(usr) || emagged) //Unless you are making something, you need access.
			screen = temp_screen
		else
			usr << "Unauthorized Access."

	else if(href_list["updt_tech"]) //Update the research holder with information from the technology disk.
		screen = 10
		spawn(50)
			screen = 22
			files.AddTech2Known(t_disk.stored)
			updateUsrDialog()
			griefProtection() //Update centcomm too

	else if(href_list["clear_tech"]) //Erase data on the technology disk.
		t_disk.stored = null

	else if(href_list["eject_tech"]) //Eject the technology disk.
		t_disk.loc = loc
		t_disk = null
		screen = 20

	else if(href_list["copy_tech"]) //Copys some technology data from the research holder to the disk.
		for(var/datum/tech/T in files.known_tech)
			if(href_list["copy_tech"] == T.id)
				t_disk.stored = T
				break
		screen = 22

	else if(href_list["updt_design"]) //Updates the research holder with design data from the design disk.
		screen = 10
		spawn(50)
			screen = 24
			files.AddDesign2Known(d_disk.blueprint)
			updateUsrDialog()
			griefProtection() //Update centcomm too

	else if(href_list["clear_design"]) //Erases data on the design disk.
		d_disk.blueprint = null

	else if(href_list["eject_design"]) //Eject the design disk.
		d_disk.loc = loc
		d_disk = null
		screen = 20

	else if(href_list["copy_design"]) //Copy design data from the research holder to the design disk.
		for(var/datum/design/D in files.known_designs)
			if(href_list["copy_design"] == D.id)
				d_disk.blueprint = D
				break
		screen = 24

	else if(href_list["eject_item"]) //Eject the item inside the destructive analyzer.
		if(linked_destroy)
			if(linked_destroy.busy)
				usr << "<span class='notice'>The destructive analyzer is busy at the moment.</span>"

			else if(linked_destroy.loaded_item)
				linked_destroy.loaded_item.loc = linked_destroy.loc
				linked_destroy.loaded_item = null
				linked_destroy.icon_state = "d_analyzer"
				screen = 31

	else if(href_list["deconstruct"]) //Deconstruct the item in the destructive analyzer and update the research holder.
		if(linked_destroy)
			if(linked_destroy.busy)
				usr << "<span class='notice'>The destructive analyzer is busy at the moment.</span>"
			else
				if(alert("Proceeding will destroy loaded item. Continue?", "Destructive analyzer confirmation", "Yes", "No") == "No" || !linked_destroy)
					return
				linked_destroy.busy = 1
				screen = 11
				updateUsrDialog()
				flick("d_analyzer_process", linked_destroy)
				spawn(24)
					if(linked_destroy)
						linked_destroy.busy = 0
						if(!linked_destroy.loaded_item)
							usr <<"<span class='notice'>The destructive analyzer appears to be empty.</span>"
							screen = 20
							return

						for(var/T in linked_destroy.loaded_item.origin_tech)
							files.UpdateTech(T, linked_destroy.loaded_item.origin_tech[T])
						if(linked_lathe && linked_destroy.loaded_item.matter) // Also sends salvaged materials to a linked protolathe, if any.
							for(var/t in linked_destroy.loaded_item.matter)
								if(t in linked_lathe.materials)
									linked_lathe.materials[t] += min(linked_lathe.max_material_storage - linked_lathe.TotalMaterials(), linked_destroy.loaded_item.matter[t] * linked_destroy.decon_mod)

						linked_destroy.loaded_item = null
						for(var/obj/I in linked_destroy.contents)
							for(var/mob/M in I.contents)
								M.death()
								qdel(M)
							if(istype(I,/obj/item/stack/material))//Only deconsturcts one sheet at a time instead of the entire stack
								var/obj/item/stack/material/S = I
								if(S.get_amount() > 1)
									S.use(1)
									linked_destroy.loaded_item = S
								else
									qdel(S)
									linked_destroy.icon_state = "d_analyzer"
							else
								if(!(I in linked_destroy.component_parts))
									qdel(I)
									linked_destroy.icon_state = "d_analyzer"

						use_power(linked_destroy.active_power_usage)
						screen = 20
						updateUsrDialog()

	else if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(allowed(usr))
			screen = text2num(href_list["lock"])
		else
			usr << "Unauthorized Access."

	else if(href_list["sync"]) //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
		screen = 10
		if(!sync)
			usr << "<span class='notice'>You must connect to the network first.</span>"
		else
			griefProtection() //Putting this here because I dont trust the sync process
			spawn(30)
				if(src)
					for(var/obj/machinery/r_n_d/server/S in SSmachinery.all_machines)
						var/server_processed = 0
						if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in files.known_tech)
								S.files.AddTech2Known(T)
							for(var/datum/design/D in files.known_designs)
								S.files.AddDesign2Known(D)
							S.files.RefreshResearch()
							server_processed = 1
						if((id in S.id_with_download) && !istype(S, /obj/machinery/r_n_d/server/centcom))
							for(var/datum/tech/T in S.files.known_tech)
								files.AddTech2Known(T)
							for(var/datum/design/D in S.files.known_designs)
								files.AddDesign2Known(D)
							files.RefreshResearch()
							server_processed = 1
						if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
							S.produce_heat()
					screen = 60
					updateUsrDialog()

	else if(href_list["togglesync"]) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync

	else if(href_list["build"]) //Causes the Protolathe to build something.
		if(linked_lathe)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["build"])
					being_built = D
					break
			if(being_built)
				linked_lathe.addToQueue(being_built)

		screen = 41
		updateUsrDialog()

	else if(href_list["imprint"]) //Causes the Circuit Imprinter to build something.
		if(linked_imprinter)
			var/datum/design/being_built = null
			for(var/datum/design/D in files.known_designs)
				if(D.id == href_list["imprint"])
					being_built = D
					break
			if(being_built)
				linked_imprinter.addToQueue(being_built)
		screen = 51
		updateUsrDialog()

	else if(href_list["disposeI"] && linked_imprinter)  //Causes the circuit imprinter to dispose of a single reagent (all of it)
		linked_imprinter.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallI"] && linked_imprinter) //Causes the circuit imprinter to dispose of all it's reagents.
		linked_imprinter.reagents.clear_reagents()

	else if(href_list["removeI"] && linked_imprinter)
		linked_imprinter.removeFromQueue(text2num(href_list["removeI"]))

	else if(href_list["disposeP"] && linked_lathe)  //Causes the protolathe to dispose of a single reagent (all of it)
		linked_lathe.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallP"] && linked_lathe) //Causes the protolathe to dispose of all it's reagents.
		linked_lathe.reagents.clear_reagents()

	else if(href_list["removeP"] && linked_lathe)
		linked_lathe.removeFromQueue(text2num(href_list["removeP"]))

	else if(href_list["lathe_ejectsheet"] && linked_lathe) //Causes the protolathe to eject a sheet of material
		var/num_sheets = min(text2num(href_list["amount"]), round(linked_lathe.materials[href_list["lathe_ejectsheet"]] / SHEET_MATERIAL_AMOUNT))

		if(num_sheets < 1)
			return

		var/mattype = linked_lathe.getMaterialType(href_list["lathe_ejectsheet"])

		var/obj/item/stack/material/M = new mattype(linked_lathe.loc)
		M.amount = num_sheets
		linked_lathe.materials[href_list["lathe_ejectsheet"]] -= num_sheets * SHEET_MATERIAL_AMOUNT

	else if(href_list["imprinter_ejectsheet"] && linked_imprinter) //Causes the protolathe to eject a sheet of material
		var/num_sheets = min(text2num(href_list["amount"]), round(linked_imprinter.materials[href_list["imprinter_ejectsheet"]] / SHEET_MATERIAL_AMOUNT))

		if(num_sheets < 1)
			return

		var/mattype = linked_imprinter.getMaterialType(href_list["imprinter_ejectsheet"])

		var/obj/item/stack/material/M = new mattype(linked_imprinter.loc)
		M.amount = num_sheets
		linked_imprinter.materials[href_list["imprinter_ejectsheet"]] -= num_sheets * SHEET_MATERIAL_AMOUNT

	else if(href_list["find_device"]) //The R&D console looks for devices nearby to link up with.
		screen = 10
		spawn(10)
			SyncRDevices()
			screen = 60
			updateUsrDialog()

	else if(href_list["disconnect"]) //The R&D console disconnects with a specific device.
		switch(href_list["disconnect"])
			if("destroy")
				linked_destroy.linked_console = null
				linked_destroy = null
			if("lathe")
				linked_lathe.linked_console = null
				linked_lathe = null
			if("imprinter")
				linked_imprinter.linked_console = null
				linked_imprinter = null

	else if(href_list["reset"]) //Reset the R&D console's database.
		griefProtection()
		var/choice = alert("R&D Console Database Reset", "Are you sure you want to reset the R&D console's database? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			screen = 10
			qdel(files)
			files = new /datum/research(src)
			spawn(20)
				screen = 60
				updateUsrDialog()

	else if (href_list["print"]) //Print research information
		screen = 15
		spawn(20)
			var/obj/item/weapon/paper/PR = new/obj/item/weapon/paper
			var/pname = "list of researched technologies"
			var/info = "<center><b>[station_name()] Science Laboratories</b>"
			info += "<h2>[ (text2num(href_list["print"]) == 2) ? "Detailed" : ] Research Progress Report</h2>"
			info += "<i>report prepared at [worldtime2text()] station time</i></center><br>"
			if(text2num(href_list["print"]) == 2)
				info += GetResearchListInfo()
			else
				info += GetResearchLevelsInfo()

			PR.set_content_unsafe(pname, info)
			print(PR)
			spawn(10)
				screen = ((text2num(href_list["print"]) == 2) ? 5.0 : 1.1)
				updateUsrDialog()

	updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
	var/dat
	dat += "<UL>"
	for(var/datum/tech/T in files.known_tech)
		if(T.level < 1)
			continue
		dat += "<LI>"
		dat += "[T.name]"
		dat += "<UL>"
		dat +=  "<LI>Level: [T.level]"
		dat +=  "<LI>Summary: [T.desc]"
		dat += "</UL>"
	return dat

/obj/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/dat
	dat += "<UL>"
	for(var/datum/design/D in files.known_designs)
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat

/obj/machinery/computer/rdconsole/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	files.RefreshResearch()
	ui_interact(user)

/obj/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	id = 2
	req_access = list(access_robotics)

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"
	id = 1
