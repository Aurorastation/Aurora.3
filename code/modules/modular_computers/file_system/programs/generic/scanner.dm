/datum/computer_file/program/scanner
	size = 2
	program_type = PROGRAM_SERVICE
	available_on_ntnet = FALSE
	usage_flags = PROGRAM_ALL_HANDHELD
	var/mode = null

/datum/computer_file/program/scanner/service_activate()
	. = ..()
	if(!computer.scan_mode)
		computer.scan_mode = mode
		return TRUE
	else
		computer.visible_message(SPAN_WARNING("Cannot activate [filedesc]: Another scanner is already active!"))
		return FALSE

/datum/computer_file/program/scanner/service_deactivate()
	. = ..()
	computer.scan_mode = null

/datum/computer_file/program/scanner/medical
	filename = "med_scanner"
	filedesc = "Medical Analyzer"
	extended_desc = "A scanning suite capable of detecting major medical problems in individuals."
	available_on_ntnet = TRUE
	required_access_run = access_medical
	required_access_download = access_medical
	mode = SCANNER_MEDICAL

/datum/computer_file/program/scanner/science
	filename = "sci_scanner"
	filedesc = "Reagent Analyzer"
	extended_desc = "A scanning suite capable of detecting active chemical reagents."
	available_on_ntnet = TRUE
	required_access_run = access_research
	required_access_download = access_research
	mode = SCANNER_REAGENT

/datum/computer_file/program/scanner/gas
	filename = "gas_scanner"
	filedesc = "Gas Analyzer"
	extended_desc = "A scanning suite capable of detecting and parsing gaseous conditions within a closed atmospheric system."
	available_on_ntnet = TRUE
	required_access_run = list(access_atmospherics, access_research)
	required_access_download = list(access_atmospherics, access_research)
	mode = SCANNER_GAS
