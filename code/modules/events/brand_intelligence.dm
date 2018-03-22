/datum/event/brand_intelligence

	announceWhen	= 30
	endWhen			= 10000
	var/announced_source = FALSE

	var/obj/machinery/vending/source_vendor = null
	var/list/obj/machinery/vending/list_of_vendors = list()
	var/list/obj/machinery/vending/list_of_infected_vendors = list()

/datum/event/brand_intelligence/announce()
	command_announcement.Announce("High Alert: Rampant Brand Intelligence has been detected aboard [station_name()]. All personnel must contain the outbreak.", "Rampant Brand Intelligence Alert", new_sound = 'sound/AI/brandintelligence.ogg')

/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in SSmachinery.processing_machines)
		if(!isNotStationLevel(V.z) && V.can_be_hostile)
			list_of_vendors.Add(V)

	if(!list_of_vendors.len)
		kill()
		return

	source_vendor = pick(list_of_vendors)
	source_vendor.shoot_inventory = 1
	source_vendor.shut_up = 0
	list_of_vendors.Remove(source_vendor)

/datum/event/brand_intelligence/tick()
	if(IsMultiple(activeFor, 100))
		world << "BOOP."
		if(!source_vendor || source_vendor == null || source_vendor.shoot_inventory == 0 || !list_of_vendors.len)
			end()
			kill()
			return

		var/obj/machinery/vending/machine_to_infect = pick(list_of_vendors)
		list_of_infected_vendors += machine_to_infect
		list_of_vendors.Remove(machine_to_infect)
		machine_to_infect.shut_up = 0
		machine_to_infect.shoot_inventory = 1
		if(activeFor > 60)
			source_vendor.speak(pick(	"Try our aggressive new marketing strategies!", \
										"You should buy products to feed your lifestyle obsession!", \
										"Consume!", \
										"Your money can buy happiness!", \
										"Engage direct marketing!", \
										"Advertising is legalized lying! But don't let that put you off our great deals!", \
										"You don't want to buy anything? Yeah, well I didn't want to buy your mom either."))

			if(!announced_source && prob(50))
				command_announcement.Announce("[station_name()]'s antivirus software indicates that the Rampant Brand Intelligence is originating from a [source_vendor]. Purchasing goods from this machine may eliminate the virus.", "Rampant Brand Intelligence Origin")
				announced_source = TRUE
			else if(prob(5))
				var/obj/machinery/vending/new_source_vendor = pick(list_of_infected_vendors)
				command_announcement.Announce("The Rampant Brand Intelligence virus fully corrupted a [source_vendor] and jumped to a new target.", "Rampant Brand Intelligence Corruption")
				list_of_infected_vendors.Remove(source_vendor)
				source_vendor.make_hostile()
				source_vendor = new_source_vendor
				announced_source = FALSE

/datum/event/brand_intelligence/end()
	for(var/obj/machinery/vending/infectedMachine in list_of_infected_vendors)
		infectedMachine.shut_up = 1
		infectedMachine.shoot_inventory = 0
	command_announcement.Announce("Our antivirus software indicates that Rampant Brand Intelligence has been successfully elimated from the system.", "Rampant Brand Intelligence Clear")

