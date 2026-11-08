/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/structure/machinery/vending/vendingMachines = list()
	var/list/obj/structure/machinery/vending/infectedVendingMachines = list()
	var/obj/structure/machinery/vending/originMachine


/datum/event/brand_intelligence/announce()
	command_announcement.Announce("Rampant brand intelligence has been detected aboard the [location_name()]. The origin is believed to be \a \"[initial(originMachine.name)]\" type. Infection of other machines is likely.", "[station_name()] Machine Monitoring" , new_sound = 'sound/AI/brandintelligence.ogg', zlevels = affecting_z)


/datum/event/brand_intelligence/start()
	..()

	for(var/obj/structure/machinery/vending/V in SSmachinery.processing)
		if(!is_station_level(V.z))	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill(TRUE)
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	infectedVendingMachines.Add(originMachine)
	infect_machine(originMachine)


/datum/event/brand_intelligence/tick()
	if(!vendingMachines.len || !originMachine || originMachine.shut_up)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped
		end()
		kill()
		return

	if(IsMultiple(activeFor, 5))
		if(prob(15))
			var/obj/structure/machinery/vending/infectedMachine = pick(vendingMachines)
			vendingMachines.Remove(infectedMachine)
			infectedVendingMachines.Add(infectedMachine)
			infect_machine(infectedMachine)

			if(IsMultiple(activeFor, 12))
				originMachine.speak(pick(
										"Try our aggressive new marketing strategies!", \
										"You should buy products to feed your lifestyle obsession!", \
										"Consume!", \
										"Your money can buy happiness!", \
										"Engage direct marketing!", \
										"Advertising is legalized lying! But don't let that put you off our great deals!", \
										"You don't want to buy anything? Yeah, well I didn't want to buy your mom either."\
										)
									)

/datum/event/brand_intelligence/end(var/faked)
	..()

	for(var/obj/structure/machinery/vending/infectedMachine in infectedVendingMachines)
		infectedMachine.clear_brand_intelligence()

/// Assigns an infected vendor a weighted malfunction profile. Speech is common to every profile.
/datum/event/brand_intelligence/proc/infect_machine(obj/structure/machinery/vending/vendor)
	var/alist/malfunction_weights = alist()
	malfunction_weights[VENDING_MALFUNCTION_CATALOGUE] = 35
	malfunction_weights[VENDING_MALFUNCTION_REFUSAL] = 20
	malfunction_weights[VENDING_MALFUNCTION_MIXUP] = 15
	malfunction_weights[VENDING_MALFUNCTION_GIVEAWAY] = 15
	malfunction_weights[VENDING_MALFUNCTION_LAUNCHER] = 10
	malfunction_weights[VENDING_MALFUNCTION_ELECTRICAL] = 5
	var/malfunction = pickweight(malfunction_weights)
	vendor.apply_brand_intelligence(malfunction)
