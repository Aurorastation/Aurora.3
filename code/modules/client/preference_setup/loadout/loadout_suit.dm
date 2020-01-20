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

/datum/gear/suit/colorapron/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/leather
	display_name = "jacket selection"
	description = "A selection of jackets."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["dominian bomber jacket"] = /obj/item/clothing/suit/storage/toggle/dominia/bomber
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
	display_name = "hoodie"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie

/datum/gear/suit/hoodie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/datum/gear/suit/overalls/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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
	poncho["poncho, engineering"] = /obj/item/clothing/accessory/poncho/roles/engineering
	poncho["poncho, science"] = /obj/item/clothing/accessory/poncho/roles/science
	poncho["poncho, cargo"] = /obj/item/clothing/accessory/poncho/roles/cargo
	gear_tweaks += new/datum/gear_tweak/path(poncho)

/datum/gear/suit/roles/poncho/cloak/cmo
	display_name = "cloak, chief medical officer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/roles/poncho/cloak/ce
	display_name = "cloak, chief engineer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/roles/poncho/cloak/rd
	display_name = "cloak, research director"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/roles/poncho/cloak/qm
	display_name = "cloak, quartermaster"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list("Quartermaster")

/datum/gear/suit/roles/poncho/cloak/captain
	display_name = "cloak, captain"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list("Captain")

/datum/gear/suit/roles/poncho/cloak/hop
	display_name = "cloak, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/suit/roles/poncho/cloak/hos
	display_name = "cloak, head of security"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hos
	allowed_roles = list("Head of Security")

/datum/gear/suit/roles/poncho/cloak/cargo
	display_name = "cloak, cargo"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo
	allowed_roles = list("Cargo Technician","Quartermaster")

/datum/gear/suit/roles/poncho/cloak/mining
	display_name = "cloak, mining"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/suit/roles/poncho/cloak/service
	display_name = "cloak, service"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/service
	allowed_roles = list("Head of Personnel","Bartender","Gardener","Janitor","Chef","Librarian")

/datum/gear/suit/roles/poncho/cloak/engineer
	display_name = "cloak, engineer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/engineer
	allowed_roles = list("Station Engineer", "Chief Engineer", "Engineering Apprentice")

/datum/gear/suit/roles/poncho/cloak/atmos
	display_name = "cloak, atmos"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/suit/roles/poncho/cloak/research
	display_name = "cloak, science"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/research
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/roles/poncho/cloak/medical
	display_name = "cloak, medical"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/medical
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Paramedic", "Medical Resident", "Psychiatrist", "Chemist")

/datum/gear/suit/roles/poncho/cloak/security
	display_name = "cloak, security"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/security
	allowed_roles = list("Security Officer", "Warden", "Head of Security","Detective", "Forensic Technician", "Security Cadet")

/datum/gear/suit/suitjacket
	display_name = "suit jacket"
	path = /obj/item/clothing/suit/storage/toggle/suitjacket

/datum/gear/suit/suitjacket/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice



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
	coat["technicolor trenchcoat (Detective)"] = /obj/item/clothing/suit/storage/toggle/det_trench/technicolor
	gear_tweaks += new/datum/gear_tweak/path(coat)


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

/datum/gear/suit/dominia
	display_name = "dominia great coat selection"
	description = "A selection of Dominian coats."
	path = /obj/item/clothing/suit/storage/toggle/dominia

/datum/gear/suit/dominia/New()
	..()
	var/coat = list()
	coat["dominia great coat, red"] = /obj/item/clothing/suit/storage/toggle/dominia
	coat["dominia great coat, gold"] = /obj/item/clothing/suit/storage/toggle/dominia/gold
	coat["dominia great coat, black"] = /obj/item/clothing/suit/storage/toggle/dominia/black
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tcfl
	display_name = "Tau Ceti Foreign Legion jacket selection"
	description = "A selection of fine, surplus jackets of the Foreign Legion."
	path = /obj/item/clothing/suit/storage/legion

/datum/gear/suit/tcfl/New()
	..()
	var/tcfljac = list()
	tcfljac ["tcfl jacket"] = /obj/item/clothing/suit/storage/legion
	tcfljac ["tcfl jacket, flight"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion
	gear_tweaks += new/datum/gear_tweak/path(tcfljac)

/datum/gear/suit/dep_jacket
	display_name = "department jackets selection"
	description = "A selection of department jackets."
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

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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

/datum/gear/suit/puffer_coat
	display_name = "puffer coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/puffer_vest
	display_name = "puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/greenjacket
	display_name = "green suit jacket"
	path = /obj/item/clothing/suit/storage/toggle/greengov

/datum/gear/suit/cardigan
	display_name = "cardigan"
	path = /obj/item/clothing/suit/cardigan
	cost = 1 // has no pockets or any use whatsoever anyway

/datum/gear/suit/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
