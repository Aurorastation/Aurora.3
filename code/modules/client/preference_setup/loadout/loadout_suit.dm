// Suit slot
/datum/gear/suit
	display_name = "apron, botanist"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/colorapron
	display_name = "apron, multipurpose"
	path = /obj/item/clothing/suit/apron/colored
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/leather
	display_name = "jacket selection"
	description = "A selection of jackets."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
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
	jackets["flannel jacket, green"] = /obj/item/clothing/suit/storage/toggle/flannel
	jackets["flannel jacket, red"] = /obj/item/clothing/suit/storage/toggle/flannel/red
	jackets["flannel jacket, blue"] = /obj/item/clothing/suit/storage/toggle/flannel/blue
	jackets["flannel jacket, grey"] = /obj/item/clothing/suit/storage/toggle/flannel/gray
	jackets["flannel jacket, purple"] = /obj/item/clothing/suit/storage/toggle/flannel/purple
	jackets["flannel jacket, yellow"] = /obj/item/clothing/suit/storage/toggle/flannel/yellow
	jackets["black vest"] = /obj/item/clothing/suit/storage/toggle/leather_vest
	jackets["brown vest"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	jackets["leather coat"] = /obj/item/clothing/suit/storage/leathercoat
	jackets["puffer jacket"] = /obj/item/clothing/suit/jacket/puffer
	jackets["puffer vest"] = /obj/item/clothing/suit/jacket/puffer/vest

	gear_tweaks += new/datum/gear_tweak/path(jackets)

/datum/gear/suit/hazard_vest
	display_name = "hazard vest selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/hazard = list()
	hazard["hazard vest, orange"] = /obj/item/clothing/suit/storage/hazardvest
	hazard["hazard vest, blue"] = /obj/item/clothing/suit/storage/hazardvest/blue
	hazard["hazard vest, white"] = /obj/item/clothing/suit/storage/hazardvest/white
	hazard["hazard vest, green"] = /obj/item/clothing/suit/storage/hazardvest/green
	gear_tweaks += new/datum/gear_tweak/path(hazard)

/datum/gear/suit/hoodie
	display_name = "hoodie selection"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hoodie/New()
	..()
	var/l_hoodie = list()
	l_hoodie["hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	l_hoodie["short-sleeved hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/short
	l_hoodie["crop top hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/crop
	l_hoodie["sleeveless hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/sleeveless
	gear_tweaks += new/datum/gear_tweak/path(l_hoodie)

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/surgeryapron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/apron/surgery
	cost = 1
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Emergency Medical Technician", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/suit/iacvest
	display_name = "IAC vest"
	description = "It's a lightweight vest. Made of a dark, navy mesh with highly-reflective white material, designed to be worn by the Interstellar Aid Corps."
	path = /obj/item/clothing/suit/storage/iacvest
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Emergency Medical Technician", "Medical Resident")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/accessory/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/poncho = list()
	poncho["poncho, tan"] = /obj/item/clothing/accessory/poncho
	poncho["poncho, blue"] = /obj/item/clothing/accessory/poncho/blue
	poncho["poncho, green"] = /obj/item/clothing/accessory/poncho/green
	poncho["poncho, purple"] = /obj/item/clothing/accessory/poncho/purple
	poncho["poncho, red"] = /obj/item/clothing/accessory/poncho/red
	poncho["poncho, medical"] = /obj/item/clothing/accessory/poncho/roles/medical
	poncho["poncho, IAC"] = /obj/item/clothing/accessory/poncho/roles/iac
	poncho["poncho, engineering"] = /obj/item/clothing/accessory/poncho/roles/engineering
	poncho["poncho, science"] = /obj/item/clothing/accessory/poncho/roles/science
	poncho["poncho, cargo"] = /obj/item/clothing/accessory/poncho/roles/cargo
	gear_tweaks += new/datum/gear_tweak/path(poncho)


/datum/gear/suit/suitjacket
	display_name = "suit jacket"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/blazer
	display_name = "blazer"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket/blazer
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/trenchcoats
	display_name = "trenchcoat selection"
	description = "A selection of trenchcoats."
	path = /obj/item/clothing/suit/storage/toggle/trench

/datum/gear/suit/trenchcoats/New()
	..()
	var/coat = list()
	coat["trenchcoat, brown"] = /obj/item/clothing/suit/storage/toggle/trench
	coat["trenchcoat, grey"] = /obj/item/clothing/suit/storage/toggle/trench/grey
	coat["trenchcoat, dark brown"] = /obj/item/clothing/suit/storage/toggle/trench/alt
	coat["trenchcoat, grey alternate"] = /obj/item/clothing/suit/storage/toggle/trench/grey_alt
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/trenchcoat_colorable
	display_name = "colorable trenchcoat"
	description = "A sleek canvas trenchcoat in 167,777,216 designer colors."
	path = /obj/item/clothing/suit/storage/toggle/trench/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/det_trenchcoat
	display_name = "detective trenchcoat selection"
	description = "A selection of detective trenchcoats."
	path = /obj/item/clothing/suit/storage/toggle/det_trench
	allowed_roles = list("Detective")

/datum/gear/suit/det_trenchcoat/New()
	..()
	var/coat = list()
	coat["brown trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench
	coat["black trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench/black
	gear_tweaks += new/datum/gear_tweak/path(coat)


/datum/gear/suit/ian
	display_name = "worn shirt"
	description = "A worn out, curiously comfortable t-shirt with a picture of Ian."
	path = /obj/item/clothing/suit/ianshirt


/datum/gear/suit/winter
	display_name = "winter coat selection"
	description = "A selection of coats for the thermally challenged."
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/winter/New()
	..()
	var/wintercoat = list()
	wintercoat["winter coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat
	wintercoat["winter coat, red"] = /obj/item/clothing/suit/storage/hooded/wintercoat/red
	wintercoat["winter coat, captain"] = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	wintercoat["winter coat, security"] = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	wintercoat["winter coat, science"] = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	wintercoat["winter coat, IAC"] = /obj/item/clothing/suit/storage/hooded/wintercoat/iac
	wintercoat["winter coat, medical"] = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	wintercoat["winter coat, engineering"] = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	wintercoat["winter coat, atmospherics"] = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	wintercoat["winter coat, hydroponics"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	wintercoat["winter coat, cargo"] = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	wintercoat["winter coat, mining"] = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	gear_tweaks += new/datum/gear_tweak/path(wintercoat)

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
	display_name = "dominia coat and jacket selection"
	description = "A selection of Dominian coats and jackets."
	path = /obj/item/clothing/suit/storage/toggle/dominia
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/dominia/New()
	..()
	var/coat = list()
	coat["dominia great coat, red"] = /obj/item/clothing/suit/storage/toggle/dominia
	coat["dominia great coat, gold"] = /obj/item/clothing/suit/storage/toggle/dominia/gold
	coat["dominia great coat, black"] = /obj/item/clothing/suit/storage/toggle/dominia/black
	coat["dominian bomber jacket"] = /obj/item/clothing/suit/storage/toggle/dominia/bomber
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tcfl
	display_name = "Tau Ceti Foreign Legion jacket selection"
	description = "A selection of fine, surplus jackets of the Foreign Legion."
	path = /obj/item/clothing/suit/storage/legion
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/tcfl/New()
	..()
	var/tcfljac = list()
	tcfljac ["tcfl jacket"] = /obj/item/clothing/suit/storage/legion
	tcfljac ["tcfl jacket, flight"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion
	gear_tweaks += new/datum/gear_tweak/path(tcfljac)

/datum/gear/suit/dep_jacket
	display_name = "department jackets selection"
	description = "A selection of departmental jackets."
	path = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket

/datum/gear/suit/dep_jacket/New()
	..()
	var/jacket = list()
	jacket["department jacket, engineering"] = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	jacket["department jacket, supply"] = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	jacket["department jacket, science"] = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	jacket["department jacket, medical"] = /obj/item/clothing/suit/storage/toggle/med_dep_jacket
	jacket["department jacket, security"] = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	jacket["departmental jacket, service"] = /obj/item/clothing/suit/storage/toggle/serv_dep_jacket
	gear_tweaks += new/datum/gear_tweak/path(jacket)


/datum/gear/suit/miscellaneous/peacoat
	display_name = "peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/varsity
	display_name = "varsity jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/storage/toggle/varsity))
		var/obj/item/clothing/suit/storage/toggle/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(varsities))

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/cardigan
	display_name = "cardigan selection"
	description = "A selection of cardigans."
	path = /obj/item/clothing/suit/storage/toggle/cardigan
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/cardigan/New()
	..()
	var/cardigan = list()
	cardigan["cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan
	cardigan["sweater cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/sweater
	cardigan["argyle cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/argyle
	gear_tweaks += new/datum/gear_tweak/path(cardigan)

/datum/gear/suit/himeo
	display_name = "himean coat selection"
	path = /obj/item/clothing/suit/storage/toggle/himeo
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/himeo/New()
	..()
	var/coat = list()
	coat["brown himean bekesha"] = /obj/item/clothing/suit/storage/toggle/himeo
	coat["grey himean bekesha"] = /obj/item/clothing/suit/storage/toggle/himeo/grey
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/vysoka
	display_name = "chokha selection"
	description = "A selection of Vysokan chokhas."
	path = /obj/item/clothing/suit/storage/vysoka_m
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/vysoka/New()
	..()
	var/coat = list()
	coat["feminine chokha"] = /obj/item/clothing/suit/storage/vysoka_f
	coat["masculine chokha"] = /obj/item/clothing/suit/storage/vysoka_m
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/submariner
	display_name = "submariner jacket"
	path = /obj/item/clothing/suit/storage/toggle/overlay/submariner
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION