/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine


/datum/event/brand_intelligence/announce()
	command_announcement.Announce("Rampant brand intelligence has been detected aboard [station_name()], please stand-by.", "Machine Learning Alert", new_sound = 'sound/AI/brandintelligence.ogg')


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in SSmachinery.processing_machines)
		if(isNotStationLevel(V.z))	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill(TRUE)
		return
