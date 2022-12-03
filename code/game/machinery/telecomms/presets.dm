// ### Preset machines  ###
//HUB

/obj/machinery/telecomms/hub/preset_map
	var/preset_name

/obj/machinery/telecomms/hub/preset_map/Initialize()
	if(preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Hub"
		network = "tcomm_[name_lower]"
		autolinkers = list(
			"[name_lower]_broadcaster",
			"[name_lower]_hub",
			"[name_lower]_receiver",
			"[name_lower]_server"
		)

	return ..()

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "science", "medical", "supply", "service", "common", "command", "engineering", "security", "unused",
	"receiverA", "broadcasterA")

/obj/machinery/telecomms/hub/preset_cent
	id = "CentComm Hub"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("hub_cent", "centcomm", "receiverCent", "broadcasterCent")

//Receivers

/obj/machinery/telecomms/receiver/preset_map
	var/preset_name
	var/use_common = FALSE

/obj/machinery/telecomms/receiver/preset_map/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Receiver"
		network = "tcomm_[name_lower]"
		freq_listening += list(assign_away_freq(preset_name), HAIL_FREQ)
		if (use_common)
			freq_listening += PUB_FREQ
		autolinkers = list(
			"[name_lower]_receiver"
		)

	return ..()

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA")
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ)

//Common and other radio frequencies for people to freely use
/obj/machinery/telecomms/receiver/preset_right/Initialize()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		freq_listening |= i
	. = ..()

/obj/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	produces_heat = FALSE
	autolinkers = list("receiverCent")
	freq_listening = list(ERT_FREQ, DTH_FREQ)


//Buses
/obj/machinery/telecomms/bus/preset_map
	var/preset_name
	var/use_common = FALSE

/obj/machinery/telecomms/bus/preset_map/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Bus"
		network = "tcomm_[name_lower]"
		freq_listening += list(assign_away_freq(preset_name), HAIL_FREQ)
		if (use_common)
			freq_listening += PUB_FREQ
		autolinkers = list(
			"[name_lower]_processor",
			"[name_lower]_server"
		)

	return ..()

/obj/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ)
	autolinkers = list("processor1", "science", "medical")

/obj/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(SUP_FREQ, SRV_FREQ)
	autolinkers = list("processor2", "supply", "service", "unused")

/obj/machinery/telecomms/bus/preset_two/Initialize()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == PUB_FREQ || i == ENT_FREQ)
			continue
		freq_listening |= i
	return ..()

/obj/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(SEC_FREQ, COMM_FREQ)
	autolinkers = list("processor3", "security", "command")

/obj/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	freq_listening = list(ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ, HAIL_FREQ)
	autolinkers = list("processor4", "engineering", "common")

/obj/machinery/telecomms/bus/preset_cent
	id = "CentComm Bus"
	network = "tcommsat"
	freq_listening = list(ERT_FREQ, DTH_FREQ, ENT_FREQ)
	produces_heat = FALSE
	autolinkers = list("processorCent", "centcomm")

//Processors
/obj/machinery/telecomms/processor/preset_map
	var/preset_name

/obj/machinery/telecomms/processor/preset_map/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Processor"
		network = "tcomm_[name_lower]"
		autolinkers = list(
			"[name_lower]_processor"
		)

	return ..()

/obj/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/machinery/telecomms/processor/preset_cent
	id = "CentComm Processor"
	network = "tcommsat"
	produces_heat = FALSE
	autolinkers = list("processorCent")

//Servers
/obj/machinery/telecomms/server/preset_map
	var/preset_name
	var/use_common = FALSE

/obj/machinery/telecomms/server/preset_map/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Server"
		network = "tcomm_[name_lower]"
		freq_listening += list(
			assign_away_freq(preset_name),
			HAIL_FREQ
		)
		if(use_common)
			freq_listening += PUB_FREQ
		autolinkers = list(
			"[name_lower]_server"
		)

	return ..()

/obj/machinery/telecomms/server/presets
	network = "tcommsat"

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(SCI_FREQ)
	autolinkers = list("science")

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(MED_FREQ)
	autolinkers = list("medical")

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(SUP_FREQ)
	autolinkers = list("supply")

/obj/machinery/telecomms/server/presets/service
	id = "Service Server"
	freq_listening = list(SRV_FREQ)
	autolinkers = list("service")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list(PUB_FREQ, AI_FREQ, ENT_FREQ, MED_I_FREQ, SEC_I_FREQ, HAIL_FREQ) // AI Private, Common, and Dept. Intercoms
	autolinkers = list("common")

// "Unused" channels, AKA all others.
/obj/machinery/telecomms/server/presets/unused
	id = "Unused Server"
	freq_listening = list()
	autolinkers = list("unused")

/obj/machinery/telecomms/server/presets/unused/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ || i == ENT_FREQ || i == MED_I_FREQ || i == SEC_I_FREQ || i == HAIL_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(COMM_FREQ)
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ)
	autolinkers = list("engineering")

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	autolinkers = list("security")

/obj/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(ERT_FREQ, DTH_FREQ)
	produces_heat = 0
	autolinkers = list("centcomm")


//Broadcasters

//--PRESET LEFT--//

/obj/machinery/telecomms/broadcaster/preset_map
	var/preset_name

/obj/machinery/telecomms/broadcaster/preset_map/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Broadcaster"
		network = "tcomm_[name_lower]"
		autolinkers = list(
			"[name_lower]_broadcaster"
		)

	return ..()

/obj/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

/obj/machinery/telecomms/broadcaster/preset_cent
	id = "CentComm Broadcaster"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("broadcasterCent")
