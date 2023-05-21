// Suit slot
/datum/gear/suit
	display_name = "san colette bridge crew jacket"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/scc/sancol
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 1

/datum/gear/suit/colorvest
	display_name = "colorable vest"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/leather
	display_name = "jacket selection"
	description = "A selection of jackets."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/list/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["NanoTrasen black jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	jackets["NanoTrasen brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets["black jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket
	jackets["brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets["biker jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/biker
	jackets["cropped leather jacket"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/midriff
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
	jackets["high visibility jacket"] = /obj/item/clothing/suit/storage/toggle/highvis
	jackets["high visibility jacket, alt"] = /obj/item/clothing/suit/storage/toggle/highvis_alt
	jackets["black vest"] = /obj/item/clothing/suit/storage/toggle/leather_vest
	jackets["brown vest"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	jackets["leather coat"] = /obj/item/clothing/suit/storage/leathercoat
	jackets["puffer jacket"] = /obj/item/clothing/suit/jacket/puffer
	jackets["puffer vest"] = /obj/item/clothing/suit/jacket/puffer/vest

	gear_tweaks += new /datum/gear_tweak/path(jackets)

/datum/gear/suit/hazard_vest
	display_name = "hazard vest selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/list/hazard = list()
	hazard["hazard vest, orange"] = /obj/item/clothing/suit/storage/hazardvest
	hazard["hazard vest, white"] = /obj/item/clothing/suit/storage/hazardvest/white
	hazard["hazard vest, nanotrasen navy blue"] = /obj/item/clothing/suit/storage/hazardvest/nblue
	hazard["hazard vest, zavodskoi red"] = /obj/item/clothing/suit/storage/hazardvest/red
	hazard["hazard vest, zeng-hu purple"] = /obj/item/clothing/suit/storage/hazardvest/purple
	hazard["hazard vest, PMCG blue"] = /obj/item/clothing/suit/storage/hazardvest/blue
	hazard["hazard vest, idris teal"] = /obj/item/clothing/suit/storage/hazardvest/teal
	hazard["hazard vest, hephaestus green"] = /obj/item/clothing/suit/storage/hazardvest/green
	gear_tweaks += new /datum/gear_tweak/path(hazard)

/datum/gear/suit/hoodie
	display_name = "hoodie selection"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hoodie/New()
	..()
	var/list/l_hoodie = list()
	l_hoodie["hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	l_hoodie["short-sleeved hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/short
	l_hoodie["crop top hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/crop
	l_hoodie["sleeveless hoodie"] = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/sleeveless
	gear_tweaks += new /datum/gear_tweak/path(l_hoodie)

/datum/gear/suit/mars
	display_name = "martian hoodie"
	description = "An orange hoodie, typically worn in solidarity with Mars' recent misfortunes."
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/mars

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/cmo_labcoats
	display_name = "chief medical officer labcoats selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	allowed_roles = list("Chief Medical Officer")
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/suit/cmo_labcoats/New()
	..()
	var/list/cmo_labcoats = list()
	cmo_labcoats["chief medical officer labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	cmo_labcoats["chief medical officer labcoat, alt"] = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	cmo_labcoats["chief medical officer labcoat, alt 2"] = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt2
	gear_tweaks += new /datum/gear_tweak/path(cmo_labcoats)

/datum/gear/suit/surgeryapron
	display_name = "surgical apron"
	path = /obj/item/clothing/accessory/apron/surgery
	cost = 1
	allowed_roles = list("Scientist", "Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "First Responder", "Medical Intern", "Xenobiologist", "Research Director", "Investigator")

/datum/gear/suit/medical_outerwear
	display_name = "medical outerwear (jackets, vests, rigs)"
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "First Responder", "Medical Intern")

/datum/gear/suit/medical_outerwear/New()
	..()
	var/list/medical_outerwear = list()
	medical_outerwear["medical chest-rig"] = /obj/item/clothing/suit/storage/medical_chest_rig
	medical_outerwear["first responder jacket"] = /obj/item/clothing/suit/storage/toggle/fr_jacket
	gear_tweaks += new /datum/gear_tweak/path(medical_outerwear)

/datum/gear/suit/iac_outerwear
	display_name = "IAC outerwear (jackets, vests, rigs)"
	path = /obj/item/clothing/suit/storage/hazardvest/iac
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "First Responder", "Medical Intern")
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/iac_outerwear/New()
	..()
	var/list/iac_outerwear = list()
	iac_outerwear["IAC hazard vest"] = /obj/item/clothing/suit/storage/hazardvest/iac
	iac_outerwear["IAC labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/iac
	gear_tweaks += new /datum/gear_tweak/path(iac_outerwear)

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/accessory/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/list/poncho = list()
	poncho["poncho, tan"] = /obj/item/clothing/accessory/poncho
	poncho["poncho, blue"] = /obj/item/clothing/accessory/poncho/blue
	poncho["poncho, green"] = /obj/item/clothing/accessory/poncho/green
	poncho["poncho, purple"] = /obj/item/clothing/accessory/poncho/purple
	poncho["poncho, red"] = /obj/item/clothing/accessory/poncho/red
	poncho["poncho, medical"] = /obj/item/clothing/accessory/poncho/roles/medical
	poncho["poncho, IAC"] = /obj/item/clothing/accessory/poncho/roles/iac
	poncho["poncho, engineering"] = /obj/item/clothing/accessory/poncho/roles/engineering
	poncho["poncho, science"] = /obj/item/clothing/accessory/poncho/roles/science
	poncho["poncho, operations"] = /obj/item/clothing/accessory/poncho/roles/cargo
	gear_tweaks += new /datum/gear_tweak/path(poncho)


/datum/gear/suit/suitjacket
	display_name = "suit jacket"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/blazer
	display_name = "blazer selection"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket/blazer
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/blazer/New()
	..()
	var/list/blazers = list()
	blazers["blazer"] = /obj/item/clothing/suit/storage/toggle/suitjacket/blazer
	blazers["long blazer"] = /obj/item/clothing/suit/storage/toggle/suitjacket/blazer/long
	gear_tweaks += new /datum/gear_tweak/path(blazers)

/datum/gear/suit/trenchcoats
	display_name = "trenchcoat selection"
	description = "A selection of trenchcoats."
	path = /obj/item/clothing/suit/storage/toggle/trench

/datum/gear/suit/trenchcoats/New()
	..()
	var/list/coat = list()
	coat["trenchcoat, brown"] = /obj/item/clothing/suit/storage/toggle/trench
	coat["trenchcoat, grey"] = /obj/item/clothing/suit/storage/toggle/trench/grey
	coat["trenchcoat, dark brown"] = /obj/item/clothing/suit/storage/toggle/trench/alt
	coat["trenchcoat, grey alternate"] = /obj/item/clothing/suit/storage/toggle/trench/grey_alt
	coat["trenchcoat, green"] = /obj/item/clothing/suit/storage/toggle/trench/green
	coat["brown trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench
	coat["black trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench/black
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/trenchcoat_colorable
	display_name = "colorable trenchcoat"
	description = "A sleek canvas trenchcoat in 167,777,216 designer colors."
	path = /obj/item/clothing/suit/storage/toggle/trench/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

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
	var/list/wintercoat = list()
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
	wintercoat["winter coat, operations"] = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	wintercoat["winter coat, mining"] = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	gear_tweaks += new /datum/gear_tweak/path(wintercoat)

/datum/gear/suit/winter_colorable
	display_name = "colorable winter coat"
	description = "A colorable winter coat for the thermally challenged."
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/highloft_colorable
	display_name = "colorable high loft jacket"
	description = "An upper arms and back bands colorable high loft jacket."
	path = /obj/item/clothing/suit/storage/toggle/highloft
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/dominia_cape
	display_name = "dominian cape"
	path = /obj/item/clothing/accessory/poncho/dominia_cape
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dominia, /singleton/origin_item/culture/dominian_unathi, /singleton/origin_item/culture/diona_dominia)

/datum/gear/suit/dominia_cape/New()
	..()
	var/list/dominiacape = list()
	dominiacape["dominian cape"] = /obj/item/clothing/accessory/poncho/dominia_cape
	dominiacape["white dominian cape"] = /obj/item/clothing/accessory/poncho/dominia_cape/white
	dominiacape["dominian cape, strelitz"] = /obj/item/clothing/accessory/poncho/dominia_cape/strelitz
	dominiacape["white dominian cape, strelitz"] = /obj/item/clothing/accessory/poncho/dominia_cape/strelitz/white
	dominiacape["dominian cape, volvalaad"] = /obj/item/clothing/accessory/poncho/dominia_cape/volvalaad
	dominiacape["white dominian cape, volvalaad"] = /obj/item/clothing/accessory/poncho/dominia_cape/volvalaad/white
	dominiacape["dominian cape, kazhkz"] = /obj/item/clothing/accessory/poncho/dominia_cape/kazhkz
	dominiacape["white dominian cape, kazhkz"] = /obj/item/clothing/accessory/poncho/dominia_cape/kazhkz/white
	dominiacape["dominian cape, caladius"] = /obj/item/clothing/accessory/poncho/dominia_cape/caladius
	dominiacape["white dominian cape, caladius"] = /obj/item/clothing/accessory/poncho/dominia_cape/caladius/white
	dominiacape["dominian cape, zhao"] = /obj/item/clothing/accessory/poncho/dominia_cape/zhao
	dominiacape["white dominian cape, zhao"] = /obj/item/clothing/accessory/poncho/dominia_cape/zhao/white
	gear_tweaks += new /datum/gear_tweak/path(dominiacape)

/datum/gear/suit/dominia
	display_name = "dominia coat and jacket selection"
	description = "A selection of Dominian coats and jackets."
	path = /obj/item/clothing/suit/storage/toggle/dominia
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dominia, /singleton/origin_item/culture/dominian_unathi, /singleton/origin_item/culture/diona_dominia)

/datum/gear/suit/dominia/New()
	..()
	var/list/coat = list()
	coat["dominian coat, red"] = /obj/item/clothing/suit/storage/dominia/coat
	coat["dominian coat, gold"] = /obj/item/clothing/suit/storage/dominia/coat/gold
	coat["dominian coat, black"] = /obj/item/clothing/suit/storage/dominia/coat/black
	coat["dominian great coat, red"] = /obj/item/clothing/suit/storage/dominia
	coat["dominian great coat, gold"] = /obj/item/clothing/suit/storage/dominia/gold
	coat["dominian great coat, black"] = /obj/item/clothing/suit/storage/dominia/black
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/dominia_consular
	display_name = "dominian consular officer coat selection"
	description = "A selection of coats belonging to the Diplomatic Service."
	path = /obj/item/clothing/suit/storage/dominia/consular
	allowed_roles = list("Consular Officer")
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dominia, /singleton/origin_item/culture/dominian_unathi, /singleton/origin_item/culture/diona_dominia)

/datum/gear/suit/dominia_consular/New()
	..()
	var/list/coat = list()
	coat["dominian consular's greatcoat"] = /obj/item/clothing/suit/storage/dominia/consular
	coat["dominian consular's coat"] = /obj/item/clothing/suit/storage/dominia/consular/coat
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/fisanduhian_bomber
	display_name = "fisanduhian bomber jacket selection"
	description = "A selection of Fisanduhian jackets."
	path = /obj/item/clothing/suit/storage/toggle/dominia/bomber
	flags = GEAR_HAS_DESC_SELECTION
	culture_restriction = list(/singleton/origin_item/culture/dominia, /singleton/origin_item/culture/dominian_unathi)

/datum/gear/suit/fisanduhian_bomber/New()
	..()
	var/list/coat = list()
	coat["fisanduhian bomber jacket"] = /obj/item/clothing/suit/storage/toggle/dominia/bomber
	coat["long fisanduhian bomber jacket"] = /obj/item/clothing/suit/storage/toggle/dominia/bomber/long
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/tcfl
	display_name = "Tau Ceti Foreign Legion jacket selection"
	description = "A selection of fine, surplus jackets of the Foreign Legion."
	path = /obj/item/clothing/suit/storage/legion
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/tcfl/New()
	..()
	var/list/tcfljac = list()
	tcfljac ["tcfl jacket"] = /obj/item/clothing/suit/storage/legion
	tcfljac ["tcfl jacket, flight"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion
	gear_tweaks += new /datum/gear_tweak/path(tcfljac)

/datum/gear/suit/dep_jacket
	display_name = "department jackets selection"
	description = "A selection of departmental jackets."
	path = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket

/datum/gear/suit/dep_jacket/New()
	..()
	var/list/jacket = list()
	jacket["department jacket, engineering"] = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	jacket["department jacket, operations"] = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	jacket["department jacket, science"] = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	jacket["department jacket, medical"] = /obj/item/clothing/suit/storage/toggle/med_dep_jacket
	jacket["department jacket, security"] = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	jacket["departmental jacket, service"] = /obj/item/clothing/suit/storage/toggle/serv_dep_jacket
	gear_tweaks += new /datum/gear_tweak/path(jacket)


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
	gear_tweaks += new /datum/gear_tweak/path(sortAssoc(varsities))

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new /datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/cardigan
	display_name = "cardigan selection"
	description = "A selection of cardigans."
	path = /obj/item/clothing/suit/storage/toggle/cardigan
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/cardigan/New()
	..()
	var/list/cardigan = list()
	cardigan["cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan
	cardigan["sweater cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/sweater
	cardigan["argyle cardigan"] = /obj/item/clothing/suit/storage/toggle/cardigan/argyle
	gear_tweaks += new /datum/gear_tweak/path(cardigan)

/datum/gear/suit/asymmetriccoat
	display_name = "asymmetric coat"
	path = /obj/item/clothing/suit/storage/toggle/asymmetriccoat
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/himeo
	display_name = "himean coat selection"
	path = /obj/item/clothing/suit/storage/toggle/himeo
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/himeo, /singleton/origin_item/origin/ipc_himeo, /singleton/origin_item/origin/free_council)

/datum/gear/suit/himeo/New()
	..()
	var/list/coat = list()
	coat["brown himean bekesha"] = /obj/item/clothing/suit/storage/toggle/himeo
	coat["grey himean bekesha"] = /obj/item/clothing/suit/storage/toggle/himeo/grey
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/vysoka
	display_name = "chokha selection"
	description = "A selection of Vysokan chokhas."
	path = /obj/item/clothing/suit/storage/vysoka
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/vysoka, /singleton/origin_item/origin/ipc_vysoka)

/datum/gear/suit/vysoka/New()
	..()
	var/list/coat = list()
	coat["feminine chokha"] = /obj/item/clothing/suit/storage/vysoka/f
	coat["feminine chokha, purple"] = /obj/item/clothing/suit/storage/vysoka/f/purple
	coat["feminine chokha, blue"] = /obj/item/clothing/suit/storage/vysoka/f/blue
	coat["feminine chokha, red"] = /obj/item/clothing/suit/storage/vysoka/f/red
	coat["masculine chokha"] = /obj/item/clothing/suit/storage/vysoka
	coat["masculine chokha, purple"] = /obj/item/clothing/suit/storage/vysoka/purple
	coat["masculine chokha, blue"] = /obj/item/clothing/suit/storage/vysoka/blue
	coat["masculine chokha, red"] = /obj/item/clothing/suit/storage/vysoka/red
	coat["heavy feminine chokha"] = /obj/item/clothing/suit/storage/vysoka/f/winter
	coat["heavy feminine chokha, purple"] = /obj/item/clothing/suit/storage/vysoka/f/winter/purple
	coat["heavy feminine chokha, blue"] = /obj/item/clothing/suit/storage/vysoka/f/winter/blue
	coat["heavy feminine chokha, red"] = /obj/item/clothing/suit/storage/vysoka/f/winter/red
	coat["heavy masculine chokha"] = /obj/item/clothing/suit/storage/vysoka/winter
	coat["heavy masculine chokha, purple"] = /obj/item/clothing/suit/storage/vysoka/winter/purple
	coat["heavy masculine chokha, blue"] = /obj/item/clothing/suit/storage/vysoka/winter/blue
	coat["heavy masculine chokha, red"] = /obj/item/clothing/suit/storage/vysoka/winter/red
	gear_tweaks += new /datum/gear_tweak/path(coat)

/datum/gear/suit/submariner
	display_name = "submariner jacket"
	path = /obj/item/clothing/suit/storage/toggle/overlay/submariner
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/konyang
	display_name = "konyanger outerwear selection"
	description = "A selection of jackets and coats from the wind-beaten shores of Konyang."
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/konyang
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/suit/konyang/New()
	..()
	var/list/konyangcoat = list()
	konyangcoat["konyang village coat"] = /obj/item/clothing/suit/storage/hooded/wintercoat/konyang
	konyangcoat["red konyanger jacket"] = /obj/item/clothing/suit/storage/toggle/konyang
	konyangcoat["red short-sleeved konyanger jacket"] = /obj/item/clothing/suit/storage/toggle/konyang/akira
	konyangcoat["red konyanger jumpjacket"] = /obj/item/clothing/suit/storage/toggle/konyang/pants
	konyangcoat["orange konyanger jumpjacket"] = /obj/item/clothing/suit/storage/toggle/konyang/orange
	konyangcoat["blue konyanger jumpjacket"] = /obj/item/clothing/suit/storage/toggle/konyang/blue
	konyangcoat["biege double-breasted Konyanger jacket"] = /obj/item/clothing/suit/storage/toggle/konyang/dbjacket
	konyangcoat["black double-breasted Konyanger jacket"] = /obj/item/clothing/suit/storage/toggle/konyang/dbjacket/black
	konyangcoat["blue double-breasted Konyanger jacket"] = /obj/item/clothing/suit/storage/toggle/konyang/dbjacket/blue
	gear_tweaks += new /datum/gear_tweak/path(konyangcoat)

/datum/gear/suit/gadpathur
	display_name = "gadpathurian coat selection"
	path = /obj/item/clothing/suit/storage/gadpathur
	flags = GEAR_HAS_DESC_SELECTION
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/gear/suit/gadpathur/New()
	..()
	var/list/gadpathur_coat = list()
	gadpathur_coat["gadpathurian overcoat"] = /obj/item/clothing/suit/storage/gadpathur
	gadpathur_coat["gadpathurian trenchcoat"] = /obj/item/clothing/suit/storage/toggle/trench/gadpathur
	gadpathur_coat["gadpathurian leather coat"] = /obj/item/clothing/suit/storage/toggle/trench/gadpathur/leather
	gadpathur_coat["thermal coat"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/gadpathur
	gear_tweaks += new /datum/gear_tweak/path(gadpathur_coat)

// Apron
/datum/gear/suit/apron_colourable
	display_name = "apron (colourable)"
	path = /obj/item/clothing/accessory/apron
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

// Overalls Selection
/datum/gear/suit/overalls
	display_name = "overalls selection (colourable)"
	path = /obj/item/clothing/accessory/overalls
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/overalls/New()
	..()
	var/list/overalls = list()

	// Overalls
	overalls["overalls"] = /obj/item/clothing/accessory/overalls
	overalls["overalls, high back"] = /obj/item/clothing/accessory/overalls/high_back
	overalls["overalls, x-shaped back"] = /obj/item/clothing/accessory/overalls/x_shaped_back

	// Overall Shorts
	overalls["overall shorts"] = /obj/item/clothing/accessory/overalls/shorts
	overalls["overall shorts, high back"] = /obj/item/clothing/accessory/overalls/shorts/high_back
	overalls["overall shorts, x-shaped back"] = /obj/item/clothing/accessory/overalls/shorts/x_shaped_back

	// Overall Skirts
	overalls["overall skirt"] = /obj/item/clothing/accessory/overalls/skirt
	overalls["overall skirt, high back"] = /obj/item/clothing/accessory/overalls/skirt/high_back
	overalls["overall skirt, x-shaped back"] = /obj/item/clothing/accessory/overalls/skirt/x_shaped_back

	gear_tweaks += new /datum/gear_tweak/path(overalls)

/datum/gear/suit/ponczo
	display_name = "visegradi ponczo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/colorable/ponczo
	flags = GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
