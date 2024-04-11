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
	icon_keyboard = "purple_key"
	light_color = LIGHT_COLOR_PURPLE

	circuit = /obj/item/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.
	var/obj/item/disk/tech_disk/t_disk = null	//Stores the technology disk.
	var/obj/item/disk/design_disk/d_disk = null	//Stores the design disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/allow_analyzer = TRUE
	var/allow_lathe = TRUE
	var/allow_imprinter = TRUE

	var/screen = 1.0	//Which screen is currently showing.
	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console

	var/protolathe_category = "All"
	var/imprinter_category = "All"

	req_access = list(ACCESS_TOX)	//Data and setting manipulation requires scientist access.

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
		if("plasteel")
			return_name = "Plasteel"
	return return_name

/obj/machinery/computer/rdconsole/proc/CallReagentName(ID)
	var/singleton/reagent/R = GET_SINGLETON(ID)
	return R ? R.name : "(none)"

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(3, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer) && allow_analyzer)
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe) && allow_lathe)
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter) && allow_imprinter)
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/proc/SyncTechs()
	var/turf/turf = get_turf(src)
	for(var/obj/machinery/r_n_d/server/S in SSmachinery.machinery)
		var/turf/ST = get_turf(S)
		if(ST && !AreConnectedZLevels(ST.z, turf.z))
			continue
		var/server_processed = 0
		if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
			for(var/tech_id in files.known_tech)
				var/datum/tech/T = files.known_tech[tech_id]
				S.files.AddTech2Known(T)
			S.files.RefreshResearch()
			server_processed = 1
		files.known_tech = S.files.known_tech.Copy()
		if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
			S.produce_heat()
	screen = 1.6
	updateUsrDialog()

/obj/machinery/computer/rdconsole/proc/griefProtection() //Have it automatically push research to the centcomm server so wild griffins can't fuck up R&D's work
	for(var/obj/machinery/r_n_d/server/centcom/C in SSmachinery.machinery)
		for(var/tech_id in files.known_tech)
			var/datum/tech/T = files.known_tech[tech_id]
			C.files.AddTech2Known(files.known_tech[T])
		C.files.RefreshResearch()

/obj/machinery/computer/rdconsole/Initialize()
	..()
	files = new /datum/research(src) //Setup the research data holder.
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in SSmachinery.machinery)
			S.setup()
			break
	SyncRDevices()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/rdconsole/LateInitialize()
	SyncTechs()
	screen = 1.0

/obj/machinery/computer/rdconsole/Destroy()
	if(linked_destroy != null)
		linked_destroy.linked_console = null
	if(linked_lathe != null)
		linked_lathe.linked_console = null
	if(linked_imprinter != null)
		linked_imprinter.linked_console = null
	return ..()

/obj/machinery/computer/rdconsole/attackby(obj/item/attacking_item, mob/user)
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
			to_chat(user, "<span class='notice'>Machine cannot accept disks in that format.</span>")
			return
		user.drop_from_inventory(attacking_item, src)
		to_chat(user, "<span class='notice'>You add \the [attacking_item] to the machine.</span>")
	else
		//The construction/deconstruction of the console code.
		..()

	src.updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/emp_act(severity)
	. = ..()

	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(usr, "<span class='notice'>You you disable the security protocols.</span>")
		return 1

/obj/machinery/computer/rdconsole/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	usr.set_machine(src)
	if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
		var/temp_screen = text2num(href_list["menu"])
		if(temp_screen <= 1.1 || (3 <= temp_screen && 4.9 >= temp_screen) || allowed(usr) || emagged) //Unless you are making something, you need access.
			screen = temp_screen
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list["updt_tech"]) //Update the research holder with information from the technology disk.
		screen = 0.0
		spawn(50)
			screen = 1.2
			files.AddTech2Known(t_disk.stored)
			updateUsrDialog()
			griefProtection() //Update centcomm too

	else if(href_list["clear_tech"]) //Erase data on the technology disk.
		t_disk.stored = null

	else if(href_list["eject_tech"]) //Eject the technology disk.
		t_disk.forceMove(loc)
		usr.put_in_hands(t_disk)
		t_disk = null
		screen = 1.0

	else if(href_list["copy_tech"]) //Copys some technology data from the research holder to the disk.
		var/datum/tech/T = files.known_tech[href_list["copy_tech_sent"]]
		t_disk.stored = T
		screen = 1.2

	else if(href_list["updt_design"]) //Updates the research holder with design data from the design disk.
		screen = 0.0
		spawn(50)
			screen = 1.4
			files.AddDesign2Known(d_disk.blueprint)
			updateUsrDialog()
			griefProtection() //Update centcomm too

	else if(href_list["clear_design"]) //Erases data on the design disk.
		d_disk.blueprint = null

	else if(href_list["eject_design"]) //Eject the design disk.
		d_disk.forceMove(loc)
		usr.put_in_hands(d_disk)
		d_disk = null
		screen = 1.0

	else if(href_list["copy_design"]) //Copy design data from the research holder to the design disk.
		var/path = text2path(href_list["copy_design_sent"])
		var/datum/design/D = files.known_designs[path]
		d_disk.blueprint = D
		screen = 1.4

	else if(href_list["eject_item"]) //Eject the item inside the destructive analyzer.
		if(linked_destroy)
			if(linked_destroy.busy)
				to_chat(usr, "<span class='notice'>The destructive analyzer is busy at the moment.</span>")

			else if(linked_destroy.loaded_item)
				linked_destroy.loaded_item.forceMove(linked_destroy.loc)
				if(linked_destroy.Adjacent(usr))
					usr.put_in_hands(linked_destroy.loaded_item)
				linked_destroy.loaded_item = null
				linked_destroy.icon_state = "d_analyzer"
				screen = 2.1

	else if(href_list["deconstruct"]) //Deconstruct the item in the destructive analyzer and update the research holder.
		if(linked_destroy)
			if(linked_destroy.busy)
				to_chat(usr, "<span class='notice'>The destructive analyzer is busy at the moment.</span>")
			else
				if(alert("Proceeding will destroy loaded item. Continue?", "Destructive analyzer confirmation", "Yes", "No") == "No" || !linked_destroy)
					return
				linked_destroy.busy = 1
				screen = 0.1
				updateUsrDialog()
				flick("d_analyzer_process", linked_destroy)
				spawn(24)
					if(linked_destroy)
						linked_destroy.busy = 0
						if(!linked_destroy.loaded_item)
							to_chat(usr, "<span class='notice'>The destructive analyzer appears to be empty.</span>")
							screen = 1.0
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

						use_power_oneoff(linked_destroy.active_power_usage)
						screen = 1.0
						updateUsrDialog()

	else if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(allowed(usr))
			screen = text2num(href_list["lock"])
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list["sync"]) //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
		screen = 0.0
		if(!sync)
			to_chat(usr, "<span class='notice'>You must connect to the network first.</span>")
		else
			griefProtection() //Putting this here because I dont trust the sync process
			addtimer(CALLBACK(src, PROC_REF(SyncTechs)), 30)

	else if(href_list["togglesync"]) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync

	else if(href_list["protolathe_category"])
		var/choice = tgui_input_list(usr, "Which category do you wish to display?", "Protolathe Categories", GLOB.designs_protolathe_categories+"All")
		if(!choice)
			return
		protolathe_category = choice
		updateUsrDialog()

	else if(href_list["imprinter_category"])
		var/choice = tgui_input_list(usr, "Which category do you wish to display?", "Printer Categories", GLOB.designs_imprinter_categories+"All")
		if(!choice)
			return
		imprinter_category = choice
		updateUsrDialog()

	else if(href_list["build"]) //Causes the Protolathe to build something.
		if(linked_lathe)
			var/path = text2path(href_list["build"])
			var/datum/design/D = files.known_designs[path]
			linked_lathe.addToQueue(D)
		screen = 3.1
		updateUsrDialog()

	else if(href_list["imprint"]) //Causes the Circuit Imprinter to build something.
		if(linked_imprinter)
			var/path = text2path(href_list["imprint"])
			var/datum/design/D = files.known_designs[path]
			linked_imprinter.addToQueue(D)
		screen = 4.1
		updateUsrDialog()

	else if(href_list["disposeI"] && linked_imprinter)  //Causes the circuit imprinter to dispose of a single reagent (all of it)
		linked_imprinter.reagents.del_reagent(href_list["dispose"])

	else if(href_list["disposeallI"] && linked_imprinter) //Causes the circuit imprinter to dispose of all it's reagents.
		linked_imprinter.reagents.clear_reagents()

	else if(href_list["removeI"] && linked_lathe)
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
		screen = 0.0
		spawn(10)
			SyncRDevices()
			screen = 1.7
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
			screen = 0.0
			qdel(files)
			files = new /datum/research(src)
			spawn(20)
				screen = 1.6
				updateUsrDialog()

	else if (href_list["print"]) //Print research information
		screen = 0.5
		spawn(20)
			var/obj/item/paper/PR = new/obj/item/paper
			var/pname = "list of researched technologies"
			var/info = "<center><b>[station_name()] Science Laboratories</b>"
			info += "<h2>[ (text2num(href_list["print"]) == 2) ? "Detailed" : null] Research Progress Report</h2>"
			info += "<i>report prepared at [worldtime2text()] station time</i></center><br>"
			if(text2num(href_list["print"]) == 2)
				info += GetResearchListInfo()
			else
				info += GetResearchLevelsInfo()

			PR.set_content_unsafe(pname, info)
			print(PR, user = usr)
			spawn(10)
				screen = ((text2num(href_list["print"]) == 2) ? 5.0 : 1.1)
				updateUsrDialog()

	updateUsrDialog()
	return

/obj/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
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

/obj/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/dat
	dat += "<UL>"
	for(var/path in files.known_designs)
		var/datum/design/D = files.known_designs[path]
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat

/obj/machinery/computer/rdconsole/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	user.set_machine(src)
	var/dat = ""
	files.RefreshResearch()
	switch(screen) //A quick check to make sure you get the right screen when a device is disconnected.
		if(2 to 2.9)
			if(linked_destroy == null)
				screen = 2.0
			else if(linked_destroy.loaded_item == null)
				screen = 2.1
			else
				screen = 2.2
		if(3 to 3.9)
			if(linked_lathe == null)
				screen = 3.0
		if(4 to 4.9)
			if(linked_imprinter == null)
				screen = 4.0

	switch(screen)

		//////////////////////R&D CONSOLE SCREENS//////////////////
		if(0.0)
			dat += "Updating Database..."

		if(0.1)
			dat += "Processing and Updating Database..."

		if(0.2)
			dat += "SYSTEM LOCKED<BR><BR>"
			dat += "<A href='?src=\ref[src];lock=1.6'>Unlock</A>"

		if(0.3)
			dat += "Constructing Prototype. Please Wait..."

		if(0.4)
			dat += "Imprinting Circuit. Please Wait..."

		if(0.5)
			dat += "Printing Research Information. Please Wait..."

		if(1.0) //Main Menu
			dat += "<b><u>Main Menu:</b></u><HR><div class='menu'>"
			dat += "Loaded disk: "
			dat += (t_disk || d_disk) ? (t_disk ? "technology storage disk" : "design storage disk") : "None"
			dat += "<HR><UL>"
			dat += "<LI><A href='?src=\ref[src];menu=1.1'>Current Research Levels</A>"
			dat += "<LI><A href='?src=\ref[src];menu=5.0'>View Researched Technologies</A>"
			if(t_disk)
				dat += "<LI><A href='?src=\ref[src];menu=1.2'>Disk Operations</A>"
			else if(d_disk)
				dat += "<LI><A href='?src=\ref[src];menu=1.4'>Disk Operations</A>"
			else
				dat += "<LI><div class='no-build'>Disk Operations</div>"
			if(linked_destroy)
				dat += "<LI><A href='?src=\ref[src];menu=2.2'>Destructive Analyzer Menu</A>"
			if(linked_lathe)
				dat += "<LI><A href='?src=\ref[src];menu=3.1'>Protolathe Construction Menu</A>"
			if(linked_imprinter)
				dat += "<LI><A href='?src=\ref[src];menu=4.1'>Circuit Construction Menu</A>"
			dat += "<LI><A href='?src=\ref[src];menu=1.6'>Settings</A>"
			dat += "</UL>"
			dat += "</div>"

		if(1.1) //Research viewer
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];print=1'>Print This Page</A><HR>"
			dat += "<b><u>Current Research Levels:</u></b><HR>"
			dat += GetResearchLevelsInfo()
			dat += "</UL>"

		if(1.2) //Technology Disk Menu

			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "Disk Contents: (Technology Data Disk)<BR><BR>"
			dat += "<div class='menu'>"
			if(t_disk.stored == null)
				dat += "The disk has no data stored on it.<HR>"
				dat += "Operations: "
				dat += "<A href='?src=\ref[src];menu=1.3'>Load Tech to Disk</A> || "
			else
				dat += "Name: [t_disk.stored.name]<BR>"
				dat += "Level: [t_disk.stored.level]<BR>"
				dat += "Description: [t_disk.stored.desc]<HR>"
				dat += "Operations: "
				dat += "<A href='?src=\ref[src];updt_tech=1'>Upload to Database</A> || "
				dat += "<A href='?src=\ref[src];clear_tech=1'>Clear Disk</A> || "
			dat += "<A href='?src=\ref[src];eject_tech=1'>Eject Disk</A>"
			dat += "</div>"

		if(1.3) //Technology Disk submenu
			dat += "<BR><A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.2'>Return to Disk Operations</A><HR>"
			dat += "<div class='menu'>"
			dat += "Load Technology to Disk:<BR><BR>"
			dat += "<UL>"
			for(var/tech_id in files.known_tech)
				var/datum/tech/T = files.known_tech[tech_id]
				dat += "<LI>[T.name] "
				dat += "\[<A href='?src=\ref[src];copy_tech=1;copy_tech_sent=[T.id]'>copy to disk</A>\]"
			dat += "</UL>"
			dat += "</div>"

		if(1.4) //Design Disk menu.
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "<div class='menu'>"
			if(d_disk.blueprint == null)
				dat += "The disk has no data stored on it.<HR>"
				dat += "Operations: "
				dat += "<A href='?src=\ref[src];menu=1.5'>Load Design to Disk</A> || "
			else
				dat += "Name: [d_disk.blueprint.name]<BR>"
				switch(d_disk.blueprint.build_type)
					if(IMPRINTER) dat += "Lathe Type: Circuit Imprinter<BR>"
					if(PROTOLATHE) dat += "Lathe Type: Proto-lathe<BR>"
				dat += "Required Materials:<BR>"
				for(var/M in d_disk.blueprint.materials)
					if(copytext(M, 1, 2) == "$") dat += "* [copytext(M, 2)] x [d_disk.blueprint.materials[M]]<BR>"
					else dat += "* [M] x [d_disk.blueprint.materials[M]]<BR>"
				dat += "<HR>Operations: "
				dat += "<A href='?src=\ref[src];updt_design=1'>Upload to Database</A> || "
				dat += "<A href='?src=\ref[src];clear_design=1'>Clear Disk</A> || "
			dat += "<A href='?src=\ref[src];eject_design=1'>Eject Disk</A>"
			dat += "</div>"

		if(1.5) //Technology disk submenu
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.4'>Return to Disk Operations</A><HR>"
			dat += "<div class='menu'>"
			dat += "Load Design to Disk:<BR><BR>"
			dat += "<UL>"
			for(var/path in files.known_designs)
				var/datum/design/D = files.known_designs[path]
				if(D.build_path)
					dat += "<LI>[D.name] "
					dat += "<A href='?src=\ref[src];copy_design=1;copy_design_sent=[D.type]'>\[copy to disk\]</A>"
			dat += "</UL>"
			dat += "</div>"

		if(1.6) //R&D console settings
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "<b><u>R&D Console Setting:</u></b><HR>"
			dat += "<div class='menu'>"
			dat += "<UL>"
			if(sync)
				dat += "<LI><A href='?src=\ref[src];sync=1'>Sync Database with Network</A><BR>"
				dat += "<LI><A href='?src=\ref[src];togglesync=1'>Disconnect from Research Network</A><BR>"
			else
				dat += "<LI><A href='?src=\ref[src];togglesync=1'>Connect to Research Network</A><BR>"
			dat += "<LI><A href='?src=\ref[src];menu=1.7'>Device Linkage Menu</A><BR>"
			dat += "<LI><A href='?src=\ref[src];lock=0.2'>Lock Console</A><BR>"
			dat += "<LI><A href='?src=\ref[src];reset=1'>Reset R&D Database</A><BR>"
			dat += "<UL>"
			dat += "</div>"

		if(1.7) //R&D device linkage
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.6'>Settings Menu</A><HR>"
			dat += "<b><u>R&D Console Device Linkage Menu:</u></b><HR>"
			dat += "<div class='menu'>"
			dat += "<A href='?src=\ref[src];find_device=1'>Re-sync with Nearby Devices</A><HR>"
			dat += "Linked Devices:"
			dat += "<UL>"

			if(allow_analyzer)
				if(linked_destroy)
					dat += "<LI>Destructive Analyzer <A href='?src=\ref[src];disconnect=destroy'>Disconnect</A>"
				else
					dat += "<LI>(No Destructive Analyzer Linked)"

			if(allow_lathe)
				if(linked_lathe)
					dat += "<LI>Protolathe <A href='?src=\ref[src];disconnect=lathe'>Disconnect</A>"
				else
					dat += "<LI>(No Protolathe Linked)"

			if(allow_imprinter)
				if(linked_imprinter)
					dat += "<LI>Circuit Imprinter <A href='?src=\ref[src];disconnect=imprinter'>Disconnect</A>"
				else
					dat += "<LI>(No Circuit Imprinter Linked)"
				dat += "</UL>"
			dat += "</div>"

		////////////////////DESTRUCTIVE ANALYZER SCREENS////////////////////////////
		if(2.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "NO DESTRUCTIVE ANALYZER LINKED TO CONSOLE<BR><BR>"

		if(2.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "No Item Loaded. Standing-by...<BR><HR>"

		if(2.2)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "<b><u>Deconstruction Menu</u></b><HR>"
			dat += "Name: [linked_destroy.loaded_item.name]<BR>"
			dat += "Origin Tech:"
			dat += "<UL>"
			for(var/tech_id in linked_destroy.loaded_item.origin_tech)
				var/datum/tech/T = files.known_tech[tech_id]
				dat += "<LI>[capitalize_first_letters(T.name)]: \[Level: [linked_destroy.loaded_item.origin_tech[tech_id]] || Progress Contribution: [files.get_level_value(linked_destroy.loaded_item.origin_tech[tech_id])]\]"
				dat += " (Current Level: [T.level] || Current Progress: [T.next_level_progress]/[T.next_level_threshold])"
			dat += "</UL>"
			if(!istype(linked_destroy.loaded_item, /obj/item/stack))
				dat += "<HR><A href='?src=\ref[src];deconstruct=1'>Deconstruct Item</A> || "
			else
				dat += "<HR><A href='?src=\ref[src];deconstruct=1'>Deconstruct One In Stack</A> || "
			dat += "<A href='?src=\ref[src];eject_item=1'>Eject Item</A>"

		/////////////////////PROTOLATHE SCREENS/////////////////////////
		if(3.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "NO PROTOLATHE LINKED TO CONSOLE<BR><BR>"

		if(3.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.4'>View Queue</A> || "
			dat += "<A href='?src=\ref[src];menu=3.2'>Material Storage</A> || "
			dat += "<A href='?src=\ref[src];menu=3.3'>Chemical Storage</A><HR>"
			dat += "<b><u>Protolathe Menu:</u></b><HR>"
			dat += "<B>Material Amount:</B> [linked_lathe.TotalMaterials()] cm<sup>3</sup> (MAX: [linked_lathe.max_material_storage])<BR>"
			dat += "<B>Chemical Volume:</B> [linked_lathe.reagents.total_volume] (MAX: [linked_lathe.reagents.maximum_volume])<HR>"
			dat += "<font size='3'; color='#5c87a8'><b>Category:</b></font> <a href='?src=\ref[src];protolathe_category=1'>[protolathe_category]</a><hr>"
			dat += "<div class='rdconsole-build'>"
			dat += "<ul>"
			var/last_category = ""
			for(var/path in files.known_designs)
				var/datum/design/D = files.known_designs[path]
				if(!D.build_path || !(D.build_type & PROTOLATHE))
					continue
				if(protolathe_category != "All" && D.p_category != protolathe_category)
					continue
				if(protolathe_category == "All" && D.p_category != last_category)
					last_category = D.p_category
					dat += "<li><h3>[last_category]</h3>"
				var/temp_dat
				for(var/M in D.materials)
					temp_dat += ", [D.materials[M]] [CallMaterialName(M)]"
				for(var/T in D.chemicals)
					temp_dat += ", [D.chemicals[T]*linked_imprinter.mat_efficiency] [CallReagentName(T)]"
				if(temp_dat)
					temp_dat = " \[[copytext(temp_dat, 3)]\]"
				if(linked_lathe.canBuild(D))
					dat += "<li class='highlight'><b><a href='?src=\ref[src];build=[D.type]'>[capitalize_first_letters(D.name)]</a></b>"
				else
					dat += "<li class='highlight'><b><div class='no-build'>[capitalize_first_letters(D.name)]</div></b>"
				dat += "[temp_dat]<br><i>[D.desc]</i>"
			dat += "</ul>"
			dat += "</div>"

		if(3.2) //Protolathe Material Storage Sub-menu
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Protolathe Menu</A><HR>"
			dat += "<b><u>Material Storage</u></b><BR><HR>"
			dat += "<UL>"
			for(var/M in linked_lathe.materials)
				var/amount = linked_lathe.materials[M]
				dat += "<LI><B>[capitalize(M)]</B>: [amount] cm<sup>3</sup>"
				if(amount >= SHEET_MATERIAL_AMOUNT)
					dat += " || Eject "
					for (var/C in list(1, 3, 5, 10, 15, 20, 25, 30, 40))
						if(amount < C * SHEET_MATERIAL_AMOUNT)
							break
						dat += "[C > 1 ? ", " : ""]<A href='?src=\ref[src];lathe_ejectsheet=[M];amount=[C]'>[C]</A> "

					dat += " or <A href='?src=\ref[src];lathe_ejectsheet=[M];amount=50'>max</A> sheets"
				dat += ""
			dat += "</UL>"

		if(3.3) //Protolathe Chemical Storage Submenu
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Protolathe Menu</A><HR>"
			dat += "<b><u>Chemical Storage</u></b><BR><HR>"
			for(var/_R in linked_lathe.reagents.reagent_volumes)
				var/singleton/reagent/R = GET_SINGLETON(_R)
				dat += "Name: [R.name] | Units: [linked_lathe.reagents.reagent_volumes[_R]] "
				dat += "<A href='?src=\ref[src];disposeP=[_R]'>(Purge)</A><BR>"
				dat += "<A href='?src=\ref[src];disposeallP=1'><U>Disposal All Chemicals in Storage</U></A><BR>"

		if(3.4) // Protolathe queue
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=3.1'>Protolathe Menu</A><HR>"
			dat += "<b><u>Queue</u></b><BR><HR>"
			if(!linked_lathe.queue.len)
				dat += "Empty"
			else
				var/tmp = 1
				for(var/datum/design/D in linked_lathe.queue)
					if(tmp == 1)
						if(linked_lathe.busy)
							dat += "<B>1: [D.name]</B><BR>"
						else
							dat += "<B>1: [D.name]</B> (Awaiting materials) <A href='?src=\ref[src];removeP=[tmp]'>Remove</A><BR>"
					else
						dat += "[tmp]: [D.name] <A href='?src=\ref[src];removeP=[tmp]'>Remove</A><BR>"
					++tmp

		///////////////////CIRCUIT IMPRINTER SCREENS////////////////////
		if(4.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "NO CIRCUIT IMPRINTER LINKED TO CONSOLE<BR><BR>"

		if(4.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.4'>View Queue</A> || "
			dat += "<A href='?src=\ref[src];menu=4.3'>Material Storage</A> || "
			dat += "<A href='?src=\ref[src];menu=4.2'>Chemical Storage</A><HR>"
			dat += "<b><u>Circuit Imprinter Menu:</u></b><BR><HR>"
			dat += "Material Amount: [linked_imprinter.TotalMaterials()] cm<sup>3</sup><BR>"
			dat += "Chemical Volume: [linked_imprinter.reagents.total_volume]<HR>"
			dat += "<font size='3'; color='#5c87a8'><b>Category:</b></font> <a href='?src=\ref[src];imprinter_category=1'>[imprinter_category]</a><hr>"
			dat += "<div class='rdconsole-build'>"
			dat += "<ul>"
			var/last_category = ""
			for(var/path in files.known_designs)
				var/datum/design/D = files.known_designs[path]
				if(!D.build_path || !(D.build_type & IMPRINTER))
					continue
				if(imprinter_category != "All" && D.p_category != imprinter_category)
					continue
				if(imprinter_category == "All" && D.p_category != last_category)
					last_category = D.p_category
					dat += "<li><h3>[last_category]</h3>"
				var/temp_dat
				for(var/M in D.materials)
					temp_dat += ", [D.materials[M]*linked_imprinter.mat_efficiency] [CallMaterialName(M)]"
				for(var/T in D.chemicals)
					temp_dat += ", [D.chemicals[T]*linked_imprinter.mat_efficiency] [CallReagentName(T)]"
				if(temp_dat)
					temp_dat = " \[[copytext(temp_dat,3)]\]"
				if(linked_imprinter.canBuild(D))
					dat += "<li class='highlight'><b><a href='?src=\ref[src];imprint=[D.type]'>[D.name]</a></b>"
				else
					dat += "<li class='highlight'><b><div class='no-build'>[D.name]</div></b>"
				dat += "[temp_dat]<br><i>[D.desc]</i>"
			dat += "</ul>"
			dat += "</div>"

		if(4.2)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Imprinter Menu</A><HR>"
			dat += "<b><u>Chemical Storage</u></b><BR><HR>"
			for(var/_R in linked_imprinter.reagents.reagent_volumes)
				var/singleton/reagent/R = GET_SINGLETON(_R)
				dat += "Name: [R.name] | Units: [linked_imprinter.reagents.reagent_volumes[_R]] "
				dat += "<A href='?src=\ref[src];disposeI=[_R]'>(Purge)</A><BR>"
				dat += "<A href='?src=\ref[src];disposeallI=1'><U>Disposal All Chemicals in Storage</U></A><BR>"

		if(4.3)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Circuit Imprinter Menu</A><HR>"
			dat += "<b><u>Material Storage</u></b><BR><HR>"
			dat += "<UL>"
			for(var/M in linked_imprinter.materials)
				var/amount = linked_imprinter.materials[M]
				dat += "<LI><B>[capitalize(M)]</B>: [amount] cm<sup>3</sup>"
				if(amount >= SHEET_MATERIAL_AMOUNT)
					dat += " || Eject: "
					for (var/C in list(1, 3, 5, 10, 15, 20, 25, 30, 40))
						if(amount < C * SHEET_MATERIAL_AMOUNT)
							break
						dat += "[C > 1 ? ", " : ""]<A href='?src=\ref[src];imprinter_ejectsheet=[M];amount=[C]'>[C]</A> "

					dat += " or <A href='?src=\ref[src];imprinter_ejectsheet=[M];amount=50'>max</A> sheets"
				dat += ""
			dat += "</UL>"

		if(4.4)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=4.1'>Circuit Imprinter Menu</A><HR>"
			dat += "<b><u>Queue</u></b><BR><HR>"
			if(linked_imprinter.queue.len == 0)
				dat += "Empty"
			else
				var/tmp = 1
				for(var/datum/design/D in linked_imprinter.queue)
					if(tmp == 1)
						dat += "<B>1: [D.name]</B><BR>"
					else
						dat += "[tmp]: [D.name] <A href='?src=\ref[src];removeI=[tmp]'>Remove</A><BR>"
					++tmp

		///////////////////Research Information Browser////////////////////
		if(5.0)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];print=2'>Print This Page</A><HR>"
			dat += "<b><u>List of Researched Technologies and Designs:</u></b><HR>"
			dat += GetResearchListInfo()

	var/datum/browser/rdconsole = new(user, "rdconsole", "Research and Development Console", 850, 600)
	rdconsole.add_stylesheet("rdconsole", 'html/browser/rdconsole.css')
	rdconsole.set_content(dat)
	rdconsole.open()

/obj/machinery/computer/rdconsole/robotics
	name = "robotics R&D console"
	id = 1
	req_access = list(ACCESS_ROBOTICS)
	allow_analyzer = FALSE

/obj/machinery/computer/rdconsole/core
	name = "core R&D console"
	desc = "A console which is used to operate various research devices. It is the backbone of any megacorporate research division."
	id = 1
