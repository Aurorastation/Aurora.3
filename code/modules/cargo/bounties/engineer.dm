/datum/bounty/item/engineer/comfy_chair
	name = "Padded Chairs"
	description = "%PERSONNAME is unhappy with their chair. They claim it hurts their back. Have engineers craft some alternatives and ship them out to humor them."
	reward_low = 2400
	reward_high = 3900
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/structure/bed/stool/chair/padded)

/datum/bounty/item/engineer/smes_coil
	name = "Superconductive magnetic coil"
	description = "A xenobotanist from the NSS Upsilon sent us a gigantic lemon. We're turning it into a battery; send us an SMES coil so we can contain its power."
	reward_low = 4000
	reward_high = 4500
	wanted_types = list(/obj/item/smes_coil)

/datum/bounty/item/engineer/solar
	name = "Solar Assemblies or Trackers"
	description = "A meteor shower ruined some backup solar arrays on the %DOCKNAME; ship us some assemblies or tracker electronics so we can expedite repairs."
	reward_low = 6500
	reward_high = 8700
	required_count = 6
	random_count = 2
	wanted_types = list(/obj/item/solar_assembly, /obj/item/tracker_electronics)

/datum/bounty/item/engineer/eshield
	name = "Emergency Shields"
	description = "Another station is requesting emergency energy shields. Apparently there was a baby carp migration and they want to set up a safe play area for them. Treat this as urgent."
	reward_low = 7500
	reward_high = 9000
	required_count = 2
	wanted_types = list(/obj/machinery/shield)

/datum/bounty/item/engineer/firesuit
	name = "Firesuits"
	description = "I'm about to drop my mixtape in our next meeting. Send some suits to protect management from this straight FIRE. - %PERSONNAME"
	reward_low = 2000
	reward_high = 3200
	required_count = 2
	random_count = 1
	wanted_types = list(/obj/item/clothing/suit/fire)

/datum/bounty/item/engineer/fuel_tank
	name = "Fuel Tank"
	description = "After observing your engineering staff, we think it's best if you send us a few of those fuel tanks so nobody hurts themselves."
	reward_low = 2500
	reward_high = 3500
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/bounty/item/engineer/fuel_tank/applies_to(var/obj/structure/reagent_dispensers/fueltank/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(REAGENT_VOLUME(O.reagents, /singleton/reagent/fuel) >= 750)
		return TRUE
	return FALSE

/datum/bounty/item/engineer/phoron_tank
	name = "Full Tank of Phoron"
	description = "Another station has requested supplies to test a new engine. In particular, they request a full tank of phoron. Please don't send a whole canister; they'll get... ideas."
	reward_low = 2200
	reward_high = 3200
	wanted_types = list(/obj/item/tank)
	var/moles_required = 20 // A full tank is 28 moles, but we give some leeway.

/datum/bounty/item/engineer/phoron_tank/applies_to(var/obj/item/tank/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(!O.air_contents.gas["phoron"])
		return FALSE
	return O.air_contents.gas["phoron"] >= moles_required


/datum/bounty/item/engineer/vending
	name = "Vending Machines"
	description = "We're researching the cause of the widespread brand intelligence virus. Send us some vending machines of any kind from your station so we can examine them. Just get permission, first."
	reward_low = 3500
	reward_high = 5000
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/machinery/vending)

/datum/bounty/item/engineer/coffin
	name = "Coffins"
	description = "%PERSONNAME is holding a funeral service for some brave maintenance drones. Kind of weird, but they're a nice person and willing to put up for a bounty. Ship us some urns or wooden coffins to humor them."
	reward_low = 2500
	reward_high = 3000
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/structure/closet/crate/coffin, /obj/item/material/urn)

/datum/bounty/item/engineer/pap
	name = "Portable Air Pumps"
	description = "After a breach, some employees have been opening emergency shutters with no regard for their safety. Send us some pumps with at least 5,000kpa of air mix to get this taken care of quickly."
	reward_low = 7200
	reward_high = 8800
	required_count = 3
	wanted_types = list(/obj/machinery/portable_atmospherics/powered/pump)

/datum/bounty/item/engineer/pap/applies_to(var/obj/machinery/portable_atmospherics/powered/pump/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(O.air_contents.return_pressure() >= 5000)
		return TRUE
	return FALSE

/datum/bounty/item/engineer/spaceac
	name = "Space A/C"
	description = "The A/C is out in our offices, and everyone's talking about ice cream. I'm authorizing a bounty for some actual A/C units, since that will actually solve the issue. - %PERSONNAME"
	reward_low = 5000
	reward_high = 6500
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/machinery/space_heater)

/datum/bounty/item/engineer/pipe
	name = "Atmospheric Pipe Dispenser"
	description = "We need another pipe dispenser to help expedite an atmospherics project. The station will get a bonus if you send us a pipe dispenser."
	reward_low = 5000
	reward_high = 5700
	wanted_types = list(/obj/machinery/pipedispenser)
	exclude_types = list(/obj/machinery/pipedispenser/disposal)

/datum/bounty/item/engineer/disposal
	name = "Disposal Pipe Dispenser"
	description = "The %DOCKSHORT is undergoing an overhaul of its mail delivery chutes. Lend us a dispenser to help expedite it for a bonus."
	reward_low = 5000
	reward_high = 5700
	wanted_types = list(/obj/machinery/pipedispenser/disposal)

/datum/bounty/item/engineer/bookcase
	name = "Bookcases"
	description = "We're showing some love to one of the libraries on the %DOCKSHORT. A bonus will be paid to any station who has some skilled engineers build some for us."
	reward_low = 6000
	reward_high = 7000
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/structure/bookcase)

/datum/bounty/item/engineer/generator
	name = "Portable Generators"
	description = "Another station reported some engine troubles, and needs a few portable generators to maintain critical operations. Ship any type of portable generators to receive a bonus."
	reward_low = 5000
	reward_high = 6200
	required_count = 2
	random_count = 1
	wanted_types = list(/obj/machinery/power/portgen/basic)

/datum/bounty/item/engineer/crossbow
	name = "Powered Crossbow"
	description = "Mictlanian Democratic Forces require weaponry to assist the TCFL in quelling the unrest following peaceful takeover, please ship us some powered crossbows."
	reward_low = 5000
	reward_high = 7500
	required_count = 2
	wanted_types = list(/obj/item/gun/launcher/crossbow)
