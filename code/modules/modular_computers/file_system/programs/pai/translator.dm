/datum/computer_file/program/pai_translator
	filename = "translator"
	filedesc = "pAI Universal Translator"
	extended_desc = "This service enables the integrated universal translation systems."
	size = 12
	program_type = PROGRAM_SERVICE
	available_on_ntnet = 1
	usage_flags = PROGRAM_SILICON_PAI

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

/datum/computer_file/program/pai_translator/service_deactivate()
	. = ..()
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	if(host.translator_on)
		host.remove_language(LANGUAGE_UNATHI)
		host.remove_language(LANGUAGE_SIIK_MAAS)
		host.remove_language(LANGUAGE_SKRELLIAN)
		host.remove_language(LANGUAGE_ROOTSONG)
	host.translator_on = FALSE
