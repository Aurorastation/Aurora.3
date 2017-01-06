// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/clientmanager
    filename = "clientmanager"
    filedesc = "NTOS Client Manager"
    extended_desc = "This program allows configuration of computer's software"
    program_icon_state = "generic"
    unsendable = 1
    undeletable = 1
    size = 4
    available_on_ntnet = 0
    requires_ntnet = 0
    nanomodule_path = /datum/nano_module/program/clientmanager/
    var/_dev_type = 1 //1 - Company Device ,2 - Private device

/datum/nano_module/program/clientmanager
    name = "NTOS Client Manager"
    var/obj/item/modular_computer/movable = null

/datum/computer_file/program/clientmanager/Topic(href, href_list)
    if(..())
        return 1

    if(href_list["PRG_dev_type"])
        _dev_type = text2num(href_list["PRG_dev_type"])
        return 1

    if(href_list["PRG_enroll"])
        if(_dev_type == 1)
            enroll_company_device()
            return 1
        if(_dev_type == 2)
            enroll_private_device()
            return 1
        return 0

//Set´s up the computer with the file manager and the downloader and removes the lock
/datum/computer_file/program/clientmanager/proc/enroll_private_device()
    if(!computer)
        return 0
    computer.enrolled = 2 // private devices
    computer.hard_drive.store_file(new/datum/computer_file/program/filemanager())
    computer.hard_drive.store_file(new/datum/computer_file/program/ntnetdownload())
    return 1

//Set´s up the programs from the preset
/datum/computer_file/program/clientmanager/proc/enroll_company_device()
    if(!computer)
        return 0
    //Somehow integrate the preset selection
    //Then deploy the preset
    return 1


/datum/nano_module/program/clientmanager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
    var/list/data = list()
    if(program)
        movable = program.computer
        data = program.get_header_data()
    if(!istype(movable))
        movable = null

    var/datum/computer_file/program/clientmanager/PRG = program
    // For now limited to execution by the downloader program
    // No computer connection, we can't get data from that.
    if(!PRG || !istype(PRG) || !movable )
        return 0

    data["status_enrollment"] = movable.enrolled
    data["status_compliance"] = 1 // 0 - Not Complaint 1 - Compliant //For now. TODO-IT: Run actual compliance checks
    data["status_remote"] = 1 // 0 - Disabled 1 - Enabled //For now. TODO-IT: ability to enable and disable remote control

    if(!movable.enrolled)
        data["dev_type"] = PRG._dev_type

    ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
    if (!ui)
        ui = new(user, src, ui_key, "ntnet_clientmanager.tmpl", "NTOS Configuration Utility", 575, 700, state = state)
        ui.auto_update_layout = 1
        ui.set_initial_data(data)
        ui.open()
