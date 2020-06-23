// Suit slot
/datum/gear/suit
	display_name = "apron, botanist"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/colorapron
	display_name = "apron, multipurpose (colourable)"
	path = /obj/item/clothing/suit/apron/colored
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/leather
	display_name = "jacket (selection)"
	description = "A selection of jackets."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["bomber jacket 2"] = /obj/item/clothing/suit/storage/bomber/alt
	jackets["pilot bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	jackets["corporate black jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	jackets["corporate brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets["black jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket
	jackets["brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets["biker jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/biker
	jackets["designer leather jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/designer
	jackets["designer leather jacket, black"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black
	jackets["designer leather jacket, red"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/designer/red
	jackets["flight jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight
	jackets["flight jacket, green"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green
	jackets["flight jacket, white"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white
	jackets["military jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military
	jackets["military jacket, tan"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan
	jackets["old military jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old
	jackets["old military jacket, badge"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/alt
	jackets["old military jacket, green"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/green
	jackets["old military jacket, tan"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/tan
	jackets["old military jacket, white"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/white
	jackets["old military jacket, navy"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/navy
	jackets["old military jacket, grey"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/grey
	jackets["old military jacket, black"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/black
	jackets["black vest"] = /obj/item/clothing/suit/storage/toggle/leather_vest
	jackets["brown vest"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	jackets["leather coat"] = /obj/item/clothing/suit/storage/leathercoat

	gear_tweaks += new/datum/gear_tweak/path(jackets)

/datum/gear/suit/flannel_shirt
	display_name = "flannel shirt (selection)"
	description = "A selection of flannel shirts."
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/leather/New()
	..()
	var/flannels = list()
	flannels["black flannel shirt"] = /obj/item/clothing/storage/flannel
	flannels["grey flannel shirt"] = /obj/item/clothing/storage/flannel/grey
	flannels["red flannel shirt"] = /obj/item/clothing/storage/flannel/red
	flannels["brown flannel shirt"] = /obj/item/clothing/storage/flannel/brown
	flannels["yellow flannel shirt"] = /obj/item/clothing/storage/flannel/yellow
	flannels["green flannel shirt"] = /obj/item/clothing/storage/flannel/green
	flannels["yellow flannel shirt"] = /obj/item/clothing/storage/flannel/yellow
	flannels["aqua flannel shirt"] = /obj/item/clothing/storage/flannel/aqua
	flannels["blue flannel shirt"] = /obj/item/clothing/storage/flannel/blue
	flannels["purple flannel shirt"] = /obj/item/clothing/storage/flannel/purple
	gear_tweaks += new/datum/gear_tweak/path(flannels)

/datum/gear/suit/hazard_vest
	display_name = "hazard vest (selection)"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/hazard = list()
	hazard["orange hazard vest"] = /obj/item/clothing/suit/storage/hazardvest
	hazard["blue hazard vest"] = /obj/item/clothing/suit/storage/hazardvest/blue
	hazard["white hazard vest"] = /obj/item/clothing/suit/storage/hazardvest/white
	hazard["green hazard vest"] = /obj/item/clothing/suit/storage/hazardvest/green
	gear_tweaks += new/datum/gear_tweak/path(hazard)

/datum/gear/suit/hoodie
	display_name = "hoodie (selection, colourable)"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hoodie/New()
	..()
	var/l_hoodie = list()
	l_hoodie["hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	l_hoodie["short-sleeved hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/short
	l_hoodie["crop top hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/crop
	gear_tweaks += new/datum/gear_tweak/path(l_hoodie)

/datum/gear/suit/hoodie/alt
	display_name = "hoodie, alt (colourable)"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hoodie/altmisc
	display_name = "hoodie (selection)"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/cti

/datum/gear/suit/hoodie/altmisc/New()
	..()
	var/hoodie_misc = list()
	hoodie_misc["CTI hoodie"] = /obj/item/clothing/suit/storage/toggle/hoodie/cti
	hoodie_misc["MU hoodie"] = /obj/item/clothing/suit/storage/toggle/hoodie/mu
	hoodie_misc["NT hoodie"] = /obj/item/clothing/suit/storage/toggle/hoodie/nt
	hoodie_misc["Space Mountain Wind hoodie"] = /obj/item/clothing/suit/storage/toggle/hoodie/smw
	hoodie_misc["NRTI hoodie"] = /obj/item/clothing/suit/storage/toggle/hoodie/nrti
	gear_tweaks += new/datum/gear_tweak/path(hoodie_misc)

/datum/gear/suit/labcoat
	display_name = "labcoat (colourable)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/overalls
	display_name = "overalls (colourable)"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/surgeryapron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/apron/surgery
	cost = 1
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Geneticist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/suit/iacvest
	display_name = "IAC vest"
	description = "It's a lightweight vest. Made of a dark, navy mesh with highly-reflective white material, designed to be worn by the Interstellar Aid Corps."
	path = /obj/item/clothing/suit/storage/iacvest
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Paramedic", "Medical Resident")

/datum/gear/suit/poncho
	display_name = "poncho (selection)"
	path = /obj/item/clothing/accessory/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/poncho = list()
	poncho["tan poncho"] = /obj/item/clothing/accessory/poncho
	poncho["blue poncho"] = /obj/item/clothing/accessory/poncho/blue
	poncho["green poncho"] = /obj/item/clothing/accessory/poncho/green
	poncho["purple poncho"] = /obj/item/clothing/accessory/poncho/purple
	poncho["red poncho"] = /obj/item/clothing/accessory/poncho/red
	poncho["black-red poncho"] = /obj/item/clothing/accessory/poncho/blackred
	poncho["medical poncho"] = /obj/item/clothing/accessory/poncho/roles/medical
	poncho["engineering poncho"] = /obj/item/clothing/accessory/poncho/roles/engineering
	poncho["science poncho"] = /obj/item/clothing/accessory/poncho/roles/science
	poncho["cargo poncho"] = /obj/item/clothing/accessory/poncho/roles/cargo
	poncho["security poncho"] = /obj/item/clothing/accessory/poncho/roles/security
	gear_tweaks += new/datum/gear_tweak/path(poncho)


/datum/gear/suit/suitjacket
	display_name = "suit jacket (colourable)"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/blazer
	display_name = "blazer (colourable)"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket/blazer
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/trenchcoats
	display_name = "trenchcoat (selection)"
	description = "A selection of trenchcoats."
	path = /obj/item/clothing/suit/storage/toggle/trench

/datum/gear/suit/trenchcoats/New()
	..()
	var/coat = list()
	coat["brown trenchcoat"] = /obj/item/clothing/suit/storage/toggle/trench
	coat["grey trenchcoat"] = /obj/item/clothing/suit/storage/toggle/trench/grey
	coat["grey alternate trenchcoat"] = /obj/item/clothing/suit/storage/toggle/trench/grey_alt
	coat["dark brown trenchcoat"] = /obj/item/clothing/suit/storage/toggle/trench/alt
	gear_tweaks += new/datum/gear_tweak/path(coat)


/datum/gear/suit/det_trenchcoat
	display_name = "detective trenchcoat (selection)"
	description = "A selection of detective trenchcoats."
	path = /obj/item/clothing/suit/storage/toggle/det_trench
	allowed_roles = list("Detective")

/datum/gear/suit/det_trenchcoat/New()
	..()
	var/coat = list()
	coat["brown trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench
	coat["black trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench/black
	coat["technicolor trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench/technicolor
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/forensic_jacket
	display_name = "forensic technician jacket (selection)
	description = "A selection of forensic technician jackets."
	path = /obj/item/clothing/suit/storage/forensics
	allowed_roles = list("Forensic Technician")

/datum/gear/suit/forensic_jacket/New()
	..()
	var/forensicjackets = list()
	forensicjackets["red jacket"] = /obj/item/clothing/suit/storage/forensics/red
	forensicjackets["red long jacket"] = /obj/item/clothing/suit/storage/forensics/red/long
	forensicjackets["blue jacket"] = /obj/item/clothing/suit/storage/forensics/blue
	forensicjackets["blue long jacket"] = /obj/item/clothing/suit/storage/forensics/blue/long
	gear_tweaks += new/datum/gear_tweak/path(forensicjackets)

/datum/gear/suit/ian
	display_name = "worn shirt"
	description = "A worn out, curiously comfortable t-shirt with a picture of Ian."
	path = /obj/item/clothing/suit/ianshirt

/datum/gear/suit/winter
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/winter/red
	display_name = "winter coat, red"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/red

/datum/gear/suit/winter/captain
	display_name = "winter coat, captain"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list("Captain")

/datum/gear/suit/winter/security
	display_name = "winter coat, security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/suit/winter/science
	display_name = "winter coat, science"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Lab Assistant", "Geneticist")

/datum/gear/suit/winter/medical
	display_name = "winter coat, medical"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Paramedic", "Medical Resident", "Psychiatrist", "Pharmacist")

/datum/gear/suit/winter/engineering
	display_name = "winter coat, engineering"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list("Station Engineer", "Chief Engineer", "Engineering Apprentice")

/datum/gear/suit/winter/atmos
	display_name = "winter coat, atmospherics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list("Atmospheric Technician", "Chief Engineer")

/datum/gear/suit/winter/hydro
	display_name = "winter coat, hydroponics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list("Head of Personnel", "Gardener")

/datum/gear/suit/winter/cargo
	display_name = "winter coat, cargo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list("Cargo Technician", "Quartermaster", "Head of Personnel")

/datum/gear/suit/winter/mining
	display_name = "winter coat, mining"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list("Quartermaster", "Head of Personnel", "Shaft Miner")

/datum/gear/suit/secjacket
	display_name = "navy security jacket (Security Officer)"
	path = /obj/item/clothing/suit/security/navyofficer
	allowed_roles = list("Security Officer", "Head of Security", "Warden")

/datum/gear/suit/secjacketwarden
	display_name = "navy security jacket (Warden)"
	path = /obj/item/clothing/suit/security/navywarden
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/suit/secjackethos
	display_name = "navy security jacket (Head of Security)"
	path = /obj/item/clothing/suit/security/navyhos
	allowed_roles = list("Head of Security")

/datum/gear/suit/dominia_cape
	display_name = "dominia cape"
	path = /obj/item/clothing/accessory/poncho/dominia_cape
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/dominia
	display_name = "dominia coat and jacket (selection)"
	description = "A selection of Dominian coats and jackets."
	path = /obj/item/clothing/suit/storage/toggle/dominia
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/dominia/New()
	..()
	var/coat = list()
	coat["red dominia great coat"] = /obj/item/clothing/suit/storage/toggle/dominia
	coat["gold dominia great coat"] = /obj/item/clothing/suit/storage/toggle/dominia/gold
	coat["black dominia great coat"] = /obj/item/clothing/suit/storage/toggle/dominia/black
	coat["dominian bomber jacket"] = /obj/item/clothing/suit/storage/toggle/dominia/bomber
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tcfl
	display_name = "Tau Ceti Foreign Legion jacket (selection)"
	description = "A selection of fine, surplus jackets of the Foreign Legion."
	path = /obj/item/clothing/suit/storage/legion
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/tcfl/New()
	..()
	var/tcfljac = list()
	tcfljac ["TCFL jacket"] = /obj/item/clothing/suit/storage/legion
	tcfljac ["TCFL flight jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion
	gear_tweaks += new/datum/gear_tweak/path(tcfljac)

/datum/gear/suit/dep_jacket
	display_name = "department jackets (selection)"
	description = "A selection of department jackets."
	path = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket

/datum/gear/suit/dep_jacket/New()
	..()
	var/jacket = list()
	jacket["engineering department jacket"] = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	jacket["supply department jacket"] = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	jacket["science department jacket"] = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	jacket["medical department jacket"] = /obj/item/clothing/suit/storage/toggle/med_dep_jacket
	jacket["security department jacket"] = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	jacket["service departmental jacket"] = /obj/item/clothing/suit/storage/toggle/serv_dep_jacket
	gear_tweaks += new/datum/gear_tweak/path(jacket)

/datum/gear/suit/duster
	display_name = "cowboy duster (colourable)"
	path = /obj/item/clothing/suit/storage/duster
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/miscellaneous/peacoat
	display_name = "peacoat (colourable)"
	path = /obj/item/clothing/suit/storage/toggle/peacoat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/varsity
	display_name = "varsity jacket (selection)"
	path = /obj/item/clothing/suit/storage/toggle/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/storage/toggle/varsity))
		var/obj/item/clothing/suit/storage/toggle/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(varsities))

/datum/gear/suit/track
	display_name = "track jacket (selection)"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/puffer_coat
	display_name = "puffer coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/puffer_vest
	display_name = "puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/cardigan
	display_name = "cardigan (selection, colourable)"
	description = "A selection of cardigans."
	path = /obj/item/clothing/suit/storage/toggle/cardigan
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/cardigan/New()
	..()
	var/cardigan = list()
	cardigan["cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan
	cardigan["sweater cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/sweater
	cardigan["argyle cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/argyle
	cardigan["crop top cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/croptop
	gear_tweaks += new/datum/gear_tweak/path(cardigan)

/datum/gear/suit/denim_jacket
	display_name = "denim jacket (selection)"
	description = "A selection of denim jackets."
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/New()
	..()
	var/denimjackets = list()
	denimjackets["denim jacket"] = /obj/item/clothing/suit/storage/toggle/denim_jacket
	denimjackets["denim jacket, corporate"] = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen
	denimjackets["denim vest"] = /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless
	denimjackets["denim vest, corporate"] = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless
	gear_tweaks += new/datum/gear_tweak/path(denimjackets)

/datum/gear/suit/greatcoat
	display_name = "greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/gear/suit/snowsuit
	display_name = "snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit

/datum/gear/suit/snowsuit/command
	display_name = "snowsuit, command"
	path = /obj/item/clothing/suit/storage/snowsuit/command
	allowed_roles = list("Captain","Research Director","Head of Personnel","Head of Security","Chief Engineer",)

/datum/gear/suit/snowsuit/security
	display_name = "snowsuit, security"
	path = /obj/item/clothing/suit/storage/snowsuit/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective", "Forensic Technician", "Security Cadet")

/datum/gear/suit/snowsuit/medical
	display_name = "snowsuit, medical"
	path = /obj/item/clothing/suit/storage/snowsuit/medical
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Paramedic", "Medical Resident", "Psychiatrist", "Pharmacist")

/datum/gear/suit/snowsuit/science
	display_name = "snowsuit, science"
	path = /obj/item/clothing/suit/storage/snowsuit/science
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Lab Assistant", "Geneticist")

/datum/gear/suit/snowsuit/engineering
	display_name = "snowsuit, engineering"
	path = /obj/item/clothing/suit/storage/snowsuit/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer", "Engineering Apprentice")

/datum/gear/suit/snowsuit/cargo
	display_name = "snowsuit, supply"
	path = /obj/item/clothing/suit/storage/snowsuit/cargo
	allowed_roles = list("Quartermaster","Shaft Miner","Cargo Technician","Head of Personnel")
