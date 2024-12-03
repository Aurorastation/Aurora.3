// --- roles check the outfits BUTTERROBBER202

/singleton/role/bastion_station
	name = "Bastion Service Member"
	desc = "You are the station's services worker. You cook the meals and scrub the toliets. Hopefully in that order."
	outfit = /obj/outfit/admin/generic/bastion_station_crew

/singleton/role/bastion_station/sec
	name = "Bastion Guard"
	desc = "You are the resident military police on the station. You throw the drunks in the Brig to cool off and put bullets in anyone who'd dare board."
	outfit = /obj/outfit/admin/generic/bastion_station_crew/sec

/singleton/role/bastion_station/engi
	name = "Bastion Engineer"
	desc = "You are the engineer that keeps the air on the inside and the lights on. You're also responsible for running the powerloader exosuits that feed the station's armaments."
	outfit = /obj/outfit/admin/generic/bastion_station_crew/engi

/singleton/role/bastion_station/med
	name = "Bastion Physician"
	desc = "You are the physician that oversees the medical treatment of the crew within the station."
	outfit = /obj/outfit/admin/generic/bastion_station_crew/med

/singleton/role/bastion_station/officer
	name = "Bastion Officer"
	desc = "You are a member of the local command structure for the station. You crew the CIC and in a combat situation, man the gunnery terminals."
	outfit = /obj/outfit/admin/generic/bastion_station_crew/officer

/singleton/role/bastion_station/pilot
	name = "Bastion Fighter Pilot"
	desc = "You are a pilot for one of the two Shrike-class fighter craft within the station. Fly or die well."
	outfit = /obj/outfit/admin/generic/bastion_station_crew/officer/pilot

/singleton/role/bastion_station/captain
	name = "Bastion Captain"
	desc = "You are the commanding officer of the station. You will control the CIC and ensure that Sol's enemies suffer her wrath. "
	outfit = /obj/outfit/admin/generic/bastion_station_crew/officer/captain

// --- outfits

/obj/outfit/admin/generic/bastion_station_crew
	name = "Bastion Station Uniform"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/data
	l_pocket = /obj/item/device/radio/hailing
	r_pocket = /obj/item/portable_map_reader
	uniform = list(
		/obj/item/clothing/under/rank/sol
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
	)
	back = list(
		/obj/item/storage/backpack/satchel
	)
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
	)

/obj/outfit/admin/generic/bastion_station/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_BASTION_STATION,
	)
// --- Security
/obj/outfit/admin/generic/bastion_station_crew/sec
	name = "Bastion Station Guard Uniform"

	head = list(
		/obj/item/clothing/head/sol
	)
	belt = list(
		/obj/item/storage/belt/security/full/alt
	)
	gloves = list(
		/obj/item/clothing/gloves/swat/tactical
	)
	glasses = list(
		/obj/item/clothing/glasses/sunglasses/sechud/tactical
	)

/obj/outfit/admin/generic/bastion_station/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_BASTION_STATION, ACCESS_BASTION_STATION_SEC
	)
// --- Engineer

/obj/outfit/admin/generic/bastion_station_crew/engi
	name = "Bastion Station Engineer Uniform"

	suit = list(
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
	)
	belt = list(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/very_full,
	)
	head = list(
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat/orange,
	)
	glasses = null
	gloves = list(
		/obj/item/clothing/gloves/yellow,
	)

/obj/outfit/admin/generic/bastion_station/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_BASTION_STATION, ACCESS_BASTION_STATION_ENGI
	)
// --- Medical

/obj/outfit/admin/generic/bastion_station_crew/med
	name = "Bastion Station Medical Uniform"

	suit = list(
		/obj/item/clothing/suit/storage/toggle/labcoat/accent
	)
	glasses = list(
		/obj/item/clothing/glasses/hud/health/aviator
	)
	belt = list(
		/obj/item/storage/belt/medical/full
	)

// --- Command

/obj/outfit/admin/generic/bastion_station_crew/officer
	name = "Bastion Station Officer Uniform"

	uniform = list(
		/obj/item/clothing/under/rank/sol/dress/subofficer
	)
	head = list(
		/obj/item/clothing/head/sol
	)

/obj/outfit/admin/generic/bastion_station/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_BASTION_STATION, ACCESS_BASTION_STATION_COMMAND, ACCESS_BASTION_STATION_SEC
	)

/obj/outfit/admin/generic/bastion_station_crew/officer/pilot
	name = "Bastion Station Pilot Uniform"

	uniform = list(
		/obj/item/clothing/under/rank/sol/dress/subofficer
	)

/obj/outfit/admin/generic/bastion_station_crew/officer/captain
	name = "Bastion Station Captain Uniform"

	uniform = list(
		/obj/item/clothing/under/rank/sol/dress/officer
	)
	head = list(
		/obj/item/clothing/head/sol/dress/officer
	)
	belt = list(
		/obj/item/gun/projectile/pistol/sol
	)
