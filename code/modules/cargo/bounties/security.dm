/datum/bounty/item/security/headset
	name = "Security Headset"
	description = "%COMPNAME wants to ensure that their encryption is working correctly. Ship them a security headset so that they can check."
	reward_low = 700
	reward_high = 1200
	random_count = 1
	wanted_types = list(/obj/item/device/radio/headset/headset_sec , /obj/item/device/radio/headset/heads/hos)

/datum/bounty/item/security/securitybelt
	name = "Security Belt"
	description = "%BOSSNAME is having difficulties with their security belts. Ship one from the facility to receive compensation."
	reward_low = 700
	reward_high = 1200
	random_count = 1
	wanted_types = list(/obj/item/storage/belt/security)

/datum/bounty/item/security/sechuds
	name = "Security HUDSunglasses"
	description = "%BOSSNAME screwed up and ordered the wrong type of security sunglasses. They request the vessel ship some of theirs."
	reward_low = 700
	reward_high = 1200
	wanted_types = list(/obj/item/clothing/glasses/sunglasses/sechud)

/datum/bounty/item/security/voidsuit
	name = "Security Voidsuit"
	description = "The %DOCKSHORT has misplaced one of its security voidsuits, and a training exercise is about to begin. Ship a spare for a bonus. Don't forget the helmet."
	reward_low = 2500
	reward_high = 4500
	wanted_types = list(/obj/item/clothing/suit/space/void/security)

/datum/bounty/item/security/voidsuit/applies_to(var/obj/item/clothing/suit/space/void/security/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(O.helmet)
		return TRUE
	return FALSE

/datum/bounty/item/security/maglight
	name = "Maglights"
	description = "Some civil protection agents lost their flashlights, and think the plastic ones are too lame. Send some maglights to appease their picky tastes."
	reward_low = 2200
	reward_high = 3000
	required_count = 2
	random_count = 1
	wanted_types = list(/obj/item/device/flashlight/maglight)

/datum/bounty/item/security/handcuffs
	name = "Handcuffs"
	description = "A large influx of criminals have arrived at %BOSSNAME for processing and transfer. Now is the perfect time to ship out spare handcuffs."
	reward_low = 1200
	reward_high = 1900
	required_count = 4
	random_count = 2
	wanted_types = list(/obj/item/handcuffs)

/datum/bounty/item/security/teargas
	name = "Teargas Grenades"
	description = "We're training some new civil protection officers, but our order for tear gas is running behind. Ship some for a bonus to your vessel's account."
	reward_low = 2000
	reward_high = 3000
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/grenade/chem_grenade/teargas)

/datum/bounty/item/security/smoke
	name = "Smoke Grenades"
	description = "We need a few extra smoke grenades to restock the ERT. Any vessel that ships spares will be compensated."
	reward_low = 2200
	reward_high = 3200
	required_count = 3
	random_count = 1
	wanted_types = list(/obj/item/grenade/chem_grenade/gas)

/datum/bounty/item/security/pepper
	name = "Pepper Spray"
	description = "Time to help some civil protection troopers toughen their response to being pepper sprayed. Any facility that helps will be compensated. I love this job. -%PERSONNAME"
	reward_low = 1200
	reward_high = 2200
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/reagent_containers/spray/pepper)

/datum/bounty/item/security/pepper/applies_to(var/obj/item/reagent_containers/spray/pepper/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(REAGENT_VOLUME(O.reagents, /decl/reagent/capsaicin/condensed) >= 25)
		return TRUE
	return FALSE

/datum/bounty/item/security/flash
	name = "Flashes"
	description = "The %DOCKSHORT has a few more new recruits than expected; we'll compensate any vessel that helps us provide some basic equipment. Right now, we need flashes."
	reward_low = 1200
	reward_high = 2200
	required_count = 4
	random_count = 1
	wanted_types = list(/obj/item/device/flash)
	include_subtypes = FALSE

/datum/bounty/item/security/flash/applies_to(var/obj/item/device/flash/O)
	if(!..())
		return FALSE
	if(!istype(O))
		return FALSE
	if(!O.broken)
		return TRUE
	return FALSE
