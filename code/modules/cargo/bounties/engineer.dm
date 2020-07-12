/datum/bounty/item/engineer/comfy_chair
	name = "Comfy Chairs"
	description = "%PERSONNAME is unhappy with their chair. They claim it hurts their back. Have engineers craft some alternatives and ship them out to humor them."
	reward_low = 24
	reward_high = 39
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/structure/bed/chair/comfy)

/datum/bounty/item/engineer/smes_coil
	name = "Superconductive magnetic coil"
	description = "A xenobotanist from the NSS Upsilon sent us a gigantic lemon. We're turning it into a battery; send us an SMES coil so we can contain its power."
	reward_low = 40
	reward_high = 45
	wanted_types = list(/obj/item/smes_coil)

/datum/bounty/item/engineer/solar
	name = "Solar Assemblies or Trackers"
	description = "A meteor shower ruined some backup solar arrays on the %DOCKNAME; ship us some assemblies or tracker electronics so we can expedite repairs."
	reward_low = 75
	reward_high = 97
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/solar_assembly, /obj/item/tracker_electronics)

/datum/bounty/item/engineer/eshield
	name = "Emergency Shields"
	description = "Another station is requesting emergency energy shields. Apparently there was a baby carp migration and they want to set up a safe play area for them. Treat this as urgent."
	reward_low = 75
	reward_high = 90
	required_count = 2
	wanted_types = list(/obj/machinery/shield)

/datum/bounty/item/engineer/firesuit
	name = "Firesuits"
	description = "I'm about to drop my mixtape in our next meeting. Send some suits to protect management from this straight FIRE. - %PERSONNAME"
	reward_low = 20
	reward_high = 32
	required_count = 2
	random_count = 1
	wanted_types = list(/obj/item/clothing/suit/fire)

/datum/bounty/item/engineer/fuel_tank
	name = "Fuel Tank"
	description = "After some observations of the Aurora, we think it's best if you send us a few of those fuel tanks so nobody hurts themselves."
	reward_low = 25
	reward_high = 35
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/bounty/item/engineer/fuel_tank/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/reagent_dispensers/fueltank/F = O
	if(F && F.reagents.get_reagent_amount(/datum/reagent/fuel) >= 750)
		return TRUE
	return FALSE

/datum/bounty/item/engineer/phoron_tank/
	name = "Full Tank of Phoron"
	description = "Another station has requested supplies to test a new engine. In particular, they request a full tank of phoron. Please don't send a whole canister; they'll get... ideas."
	reward_low = 22
	reward_high = 32
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but we give some leeway.

/datum/bounty/item/engineer/phoron_tank/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/tank/T = O
	if(T)
		if(!T.air_contents.gas["phoron"])
			return FALSE
		return T.air_contents.gas["phoron"] >= moles_required
	return FALSE

/datum/bounty/item/engineer/vending
	name = "Vending Machines"
	description = "We're researching the cause of the widespread brand intelligence virus. Send us some vending machines of any kind from your station so we can examine them. Just get permission, first."
	reward_low = 35
	reward_high = 50
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/machinery/vending)

/datum/bounty/item/engineer/coffin
	name = "Coffins"
	description = "%PERSONNAME is holding a funeral service for some brave maintenance drones. Kind of weird, but they're a nice person and willing to put up for a bounty. Ship us some urns or wooden coffins to humor them."
	reward_low = 25
	reward_high = 30
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/structure/closet/coffin, /obj/item/material/urn)

/datum/bounty/item/engineer/pap
	name = "Portable Air Pumps"
	description = "After a breach, some employees have been opening emergency shutters with no regard for their safety. Send us some pumps with at least 5,000kpa of air mix to get this taken care of quickly."
	reward_low = 72
	reward_high = 88
	required_count = 3
	wanted_types = list(/obj/machinery/portable_atmospherics/powered/pump)

/datum/bounty/item/engineer/pap/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/machinery/portable_atmospherics/powered/pump/P = O
	if(P?.holding.air_contents.return_pressure() >= 5000)
		return TRUE
	return FALSE

/datum/bounty/item/engineer/spaceac
	name = "Space A/C"
	description = "The A/C is out in our offices, and everyone's talking about ice cream. I'm authorizing a bounty for some actual A/C units, since that will actually solve the issue. - %PERSONNAME"
	reward_low = 50
	reward_high = 65
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/machinery/space_heater)

/datum/bounty/item/engineer/pipe
	name = "Atmospheric Pipe Dispenser"
	description = "We need another pipe dispenser to help expedite an atmospherics project. The station will get a bonus if you send us a pipe dispenser."
	reward_low = 50
	reward_high = 57
	wanted_types = list(/obj/machinery/pipedispenser)
	exclude_types = list(/obj/machinery/pipedispenser/disposal)

/datum/bounty/item/engineer/disposal
	name = "Disposal Pipe Dispenser"
	description = "The %DOCKSHORT is undergoing an overhaul of its mail delivery chutes. Lend us a dispenser to help expedite it for a bonus."
	reward_low = 50
	reward_high = 57
	wanted_types = list(/obj/machinery/pipedispenser/disposal)

	/datum/bounty/item/engineer/bookcase
	name = "Bookcases"
	description = "We're showing some love to one of the libraries on the %DOCKSHORT. A bonus will be paid to any station who has some skilled engineers build some for us."
	reward_low = 65
	reward_high = 75
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/structure/bookcase)