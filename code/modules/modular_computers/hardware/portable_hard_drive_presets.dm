/obj/item/computer_hardware/hard_drive/portable/super/preset/all/Initialize()
	. = ..()
	add_programs()

/obj/item/computer_hardware/hard_drive/portable/super/preset/all/proc/add_programs()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		// Invalid type (shouldn't be possible but just in case), invalid filetype (not executable program) or invalid filename (unset program)
		if(!prog || !istype(prog) || prog.filename == "UnknownProgram" || prog.filetype != "PRG")
			continue
		// Check whether the program should be available for station/antag download, if yes, add it to lists.
		if(prog.available_on_ntnet)
			store_file(prog)

/obj/item/computer_hardware/hard_drive/portable/backup
	var/_program			//Change that far to the file name of the backup program you would like to spawn
	origin_tech = list()	//Nope, no research levels from backup disks

/obj/item/computer_hardware/hard_drive/portable/backup/New(loc, var/prog_name)
	. = ..()
	_program = prog_name
	add_program()

/obj/item/computer_hardware/hard_drive/portable/backup/proc/add_program()
	if(_program == null)
		qdel(src) //Delete itself if no program is set
		return
	var/datum/computer_file/program/PRG = ntnet_global.find_ntnet_file_by_name(_program)
	if(!PRG)
		qdel(src) //Delete itself it no matching program is found
		return
	max_capacity = PRG.size // Set the capacity of the backup disk to the capacity of the program
	store_file(PRG)
	read_only = TRUE
	desc = "A read-only backup storage crystal containing a backup of the following software: [PRG.filedesc]"
	name = "[PRG.filedesc] backup crystal"

/obj/structure/closet/crate/software_backup
	desc = "A crate containing a backup of all the NT Software available."
	name = "Backup Software Crate"

/obj/structure/closet/crate/software_backup/Initialize()
	. = ..()
	for(var/F in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		// Invalid type (shouldn't be possible but just in case), invalid filetype (not executable program) or invalid filename (unset program)
		if(!prog || !istype(prog) || prog.filename == "UnknownProgram" || prog.filetype != "PRG")
			continue
		// Check whether the program should be available for station/antag download, if yes, add it to lists.
		if(prog.available_on_ntnet)
			new /obj/item/computer_hardware/hard_drive/portable/backup(src, prog.filename)