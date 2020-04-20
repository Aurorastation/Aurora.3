/datum/gear/augment
	display_name = "integrated PDA"
	description = "An augment that allows the user to access a remote PDA system."
	path = /obj/item/organ/internal/augment/pda
	augment = TRUE
	cost = 3
	sort_category = "Augments"
	whitelisted = list("Human", "Off-Worlder Human", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara", "Aut'akh Unathi", "Skrell", "Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/time
	display_name = "integrated timepiece"
	description = "An augment that allows the user to consult the time anywhere."
	path = /obj/item/organ/internal/augment/timepiece
	cost = 1

/datum/gear/augment/eye_sensors
	display_name = "integrated eye sensors"
	description = "An eye augment that allows the user to deploy medical or security sensors."
	path = /obj/item/organ/internal/augment/eye_sensors
	cost = 4

/datum/gear/augment/cyber_hair
	display_name = "synthetic hair extensions"
	description = "A hair augment that allows the user to change the shape and color of their hair."
	path = /obj/item/organ/internal/augment/cyber_hair
	cost = 2

/datum/gear/augment/combitool
	display_name = "retractable combitool"
	description = "An augment that allows the user to deploy a robotic combitool."
	path = /obj/item/organ/internal/augment/tool/combitool
	cost = 5

/datum/gear/augment/combitool/New()
	..()
	var/augs = list()
	augs["retractable combitool, right hand"] = /obj/item/organ/internal/augment/tool/combitool
	augs["retractable combitool, left hand"] = /obj/item/organ/internal/augment/tool/combitool/left
	gear_tweaks += new /datum/gear_tweak/path(augs)


/datum/gear/augment/pen
	display_name = "retractable combipen"
	description = "An augment that allows the user to deploy a simple combipen."
	path = /obj/item/organ/internal/augment/tool/pen
	cost = 2

/datum/gear/augment/pen/New()
	..()
	var/augs = list()
	augs["retractable combipen, right hand"] = /obj/item/organ/internal/augment/tool/combitool
	augs["retractable combipen, left hand"] = /obj/item/organ/internal/augment/tool/pen/left
	gear_tweaks += new/datum/gear_tweak/path(augs)

/datum/gear/augment/lighter
	display_name = "retractable lighter"
	description = "An augment that allows the user to deploy a lighter."
	path = /obj/item/organ/internal/augment/tool/lighter
	cost = 2

/datum/gear/augment/lighter/New()
	..()
	var/augs = list()
	augs["retractable lighter, right hand"] = /obj/item/organ/internal/augment/tool/lighter
	augs["retractable lighter, left hand"] = /obj/item/organ/internal/augment/tool/lighter/left
	gear_tweaks += new/datum/gear_tweak/path(augs)

/datum/gear/augment/health_scanner
	display_name = "integrated health scanner"
	description = "An augment that allows the user scan their own health condition."
	path = /obj/item/organ/internal/augment/health_scanner
	cost = 3

/datum/gear/augment/suspension
	display_name = "calf suspension"
	description = "An augment that reduces the damage from falling down."
	path = /obj/item/organ/internal/augment/suspension
	cost = 4

/datum/gear/augment/taste_boosters
	display_name = "taste booster selection"
	description = "A selection of augments that modify the user's taste sensitivity."
	path = /obj/item/organ/internal/augment/taste_booster
	cost = 3

/datum/gear/augment/taste_boosters/New()
	..()
	var/augs = list()
	augs["taste booster"] = /obj/item/organ/internal/augment/taste_booster
	augs["taste duller"] = /obj/item/organ/internal/augment/taste_booster/dull
	gear_tweaks += new/datum/gear_tweak/path(augs)

/datum/gear/augment/radio
	display_name = "integrated radio"
	description = "An augment that allows the user to interact with an integrated radio."
	path = /obj/item/organ/internal/augment/radio
	cost = 5

/datum/gear/augment/fuel_cell
	display_name = "integrated fuel cell"
	description = "An augment that allows the user to synthetize welding fuel into nutrients."
	path = /obj/item/organ/internal/augment/fuel_cell
	cost = 3

/datum/gear/augment/air_analyzer
	display_name = "integrated air analyzer"
	description = "An augment that allows the user to analyzer the air around them."
	path = /obj/item/organ/internal/augment/air_analyzer
	cost = 3
