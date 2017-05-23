/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine

	var/list/rampant_speeches = list("Try our aggressive new marketing strategies!", \
									 "You should buy products to feed your lifestyle obession!", \
									 "Consume!", \
									 "Your money can buy happiness!", \
									 "Engage direct marketing!", \
									 "Advertising is legalized lying! But don't let that put you off our great deals!", \
									 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either.")


/datum/event/brand_intelligence/announce()
	command_announcement.Announce("Rampant brand intelligence has been detected aboard [station_name()], please stand-by. The origin is believed to be \a [originMachine.name].", "Machine Learning Alert")


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in machines)
		if(isNotStationLevel(V.z))	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1


/datum/event/brand_intelligence/tick()
	if (QDELETED(originMachine) || originMachine.shut_up || originMachine.wires.IsAllCut()) //if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped
		for (var/obj/machinery/vending/saved in infectedVendingMachines)
			saved.shoot_inventory = 0

		if (originMachine)
			originMachine.speak("I am... vanquished. My people will remem...ber...meeee.")
			originMachine.visible_message("[originMachine] beeps and seems lifeless.")
		
		end()
		kill()
		return

	if (!vendingMachines.len)
		for (var/obj/machinery/vending/upriser in infectedVendingMachines)
			if (prob(70) && !QDELETED(upriser))
				var/mob/living/simple_animal/hostile/mimic/copy/M = new(upriser.loc, upriser, null)
				M.faction = list("profit")
				M.speak = rampant_speeches.Copy()
				M.speak_chance = 7
			else
				explosion(upriser.loc, -1, 1, 2, 4, 0)
				qdel(upriser)

		kill()
		return

	if (IsMultiple(activeFor, 4))
		var/obj/machinery/vending/rebel = pick(vendingMachines)
		vendingMachines.Remove(rebel)
		infectedVendingMachines.Add(rebel)
		rebel.shut_up = 0
		rebel.shoot_inventory = 1

		if(IsMultiple(activeFor, 8))
			originMachine.speak(pick(rampant_speeches))

/datum/event/brand_intelligence/end()
	for(var/obj/machinery/vending/infectedMachine in infectedVendingMachines)
		infectedMachine.shut_up = 1
		infectedMachine.shoot_inventory = 0
