// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit/storage/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["corporate black jacket"] = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	jackets["corporate brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets["black jacket"] = /obj/item/clothing/suit/storage/leather_jacket
	jackets["brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets["track jacket"] = /obj/item/clothing/suit/storage/toggle/tracksuit
	jackets["flannel jacket, green"] = /obj/item/clothing/suit/storage/toggle/flannel
	jackets["flannel jacket, red"] = /obj/item/clothing/suit/storage/toggle/flannel/red
	jackets["flannel jacket, blue"] = /obj/item/clothing/suit/storage/toggle/flannel/blue
	jackets["flannel jacket, grey"] = /obj/item/clothing/suit/storage/toggle/flannel/gray
	jackets["flannel jacket, purple"] = /obj/item/clothing/suit/storage/toggle/flannel/purple
	jackets["flannel jacket, yellow"] = /obj/item/clothing/suit/storage/toggle/flannel/yellow
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
	display_name = "hoodie, grey"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/gear/suit/hoodie/black
	display_name = "hoodie, black"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/black

/datum/gear/suit/labcoat
	display_name = "labcoat selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/New()
	..()
	var/labcoat = list()
	labcoat["labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat
	labcoat["labcoat, blue"] = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	labcoat["labcoat, green"] = /obj/item/clothing/suit/storage/toggle/labcoat/green
	labcoat["labcoat, orange"] = /obj/item/clothing/suit/storage/toggle/labcoat/orange
	labcoat["labcoat, purple"] = /obj/item/clothing/suit/storage/toggle/labcoat/purple
	labcoat["labcoat, red"] = /obj/item/clothing/suit/storage/toggle/labcoat/red
	gear_tweaks += new/datum/gear_tweak/path(labcoat)

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	
/datum/gear/suit/surgeryapron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/apron/surgery
	cost = 1
	allowed_roles = list("Scientist", "Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/poncho = list()
	poncho["poncho, tan"] = /obj/item/clothing/suit/poncho
	poncho["poncho, blue"] = /obj/item/clothing/suit/poncho/blue
	poncho["poncho, green"] = /obj/item/clothing/suit/poncho/green
	poncho["poncho, purple"] = /obj/item/clothing/suit/poncho/purple
	poncho["poncho, red"] = /obj/item/clothing/suit/poncho/red
	gear_tweaks += new/datum/gear_tweak/path(poncho)

/datum/gear/suit/blue_lawyer_jacket
	display_name = "suit jacket, blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket

/datum/gear/suit/purple_lawyer_jacket
	display_name = "suit jacket, purple"
	path = /obj/item/clothing/suit/storage/lawyer/purpjacket
	
/datum/gear/suit/trenchcoat
	display_name = "trenchcoat, brown"
	path = /obj/item/clothing/suit/storage/trench
	
/datum/gear/suit/trenchcoatgrey
	display_name = "trenchcoat, grey"
	path = /obj/item/clothing/suit/storage/trench/grey

/datum/gear/suit/ian
	display_name = "worn shirt"
	description = "A worn out, curiously comfortable t-shirt with a picture of Ian."
	path = /obj/item/clothing/suit/ianshirt

/datum/gear/suit/winter
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

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
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Paramedic", "Medical Resident", "Psychiatrist", "Chemist")

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
