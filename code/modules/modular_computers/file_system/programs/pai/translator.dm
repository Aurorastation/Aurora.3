/datum/computer_file/program/pai_translator
	filename = "translator"
	filedesc = "pAI Universal Translator"
	extended_desc = "This program is for enabling universal translation."
	size = 10

/datum/computer_file/program/pai_translator/service_activate()
	. = ..()
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

    if(!host.translator_on)
        host.add_language(LANGUAGE_UNATHI)
        host.add_language(LANGUAGE_SIIK_MAAS)
        host.add_language(LANGUAGE_SKRELLIAN)
        host.add_language(LANGUAGE_ROOTSONG)
    host.translator_on = TRUE

/datum/computer_file/program/pai_translator/service_decactivate()
	. = ..()
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	if(host.translator_on)
        user.remove_language(LANGUAGE_UNATHI)
        user.remove_language(LANGUAGE_SIIK_MAAS)
        user.remove_language(LANGUAGE_SKRELLIAN)
        user.remove_language(LANGUAGE_ROOTSONG)
    host.translator_on = FALSE