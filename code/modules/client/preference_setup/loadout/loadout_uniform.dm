// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/iacjumpsuit
	display_name = "IAC Jumpsuit"
	path = /obj/item/clothing/under/rank/iacjumpsuit
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Paramedic", "Medical Resident")

/datum/gear/uniform/jumpsuit
	display_name = "generic jumpsuits"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/jumpsuit = list()
	jumpsuit["grey jumpsuit"] = /obj/item/clothing/under/color/grey
	jumpsuit["black jumpsuit"] = /obj/item/clothing/under/color/black
	jumpsuit["blue jumpsuit"] = /obj/item/clothing/under/color/blue
	jumpsuit["green jumpsuit"] = /obj/item/clothing/under/color/green
	jumpsuit["orange jumpsuit"] = /obj/item/clothing/under/color/orange
	jumpsuit["pink jumpsuit"] = /obj/item/clothing/under/color/pink
	jumpsuit["red jumpsuit"] = /obj/item/clothing/under/color/red
	jumpsuit["white jumpsuit"] = /obj/item/clothing/under/color/white
	jumpsuit["yellow jumpsuit"] = /obj/item/clothing/under/color/yellow
	jumpsuit["light blue jumpsuit"] = /obj/item/clothing/under/lightblue
	jumpsuit["aqua jumpsuit"] = /obj/item/clothing/under/aqua
	jumpsuit["purple jumpsuit"] = /obj/item/clothing/under/purple
	jumpsuit["light purple jumpsuit"] = /obj/item/clothing/under/lightpurple
	jumpsuit["light green jumpsuit"] = /obj/item/clothing/under/lightgreen
	jumpsuit["brown jumpsuit"] = /obj/item/clothing/under/brown
	jumpsuit["light brown jumpsuit"] = /obj/item/clothing/under/lightbrown
	jumpsuit["yellow green jumpsuit"] = /obj/item/clothing/under/yellowgreen
	jumpsuit["light red jumpsuit"] = /obj/item/clothing/under/lightred
	jumpsuit["dark red jumpsuit"] = /obj/item/clothing/under/darkred
	jumpsuit["rainbow jumpsuit"] = /obj/item/clothing/under/rainbow
	gear_tweaks += new/datum/gear_tweak/path(jumpsuit)

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt/

/datum/gear/uniform/skirt/New()
	..()
	var/skirts = list()
	skirts["casual skirt"] = /obj/item/clothing/under/skirt/casual
	skirts["long skirt"] = /obj/item/clothing/under/skirt/long
	skirts["pencil skirt"] = /obj/item/clothing/under/skirt/pencil
	skirts["swept skirt"] = /obj/item/clothing/under/skirt/swept
	gear_tweaks += new/datum/gear_tweak/path(skirts)
	gear_tweaks += list(gear_tweak_free_color_choice)

/datum/gear/uniform/suit
	display_name = "suit selection"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits["amish suit"] = /obj/item/clothing/under/sl_suit
	suits["black suit"] = /obj/item/clothing/under/suit_jacket
	suits["blue suit"] = /obj/item/clothing/under/lawyer/blue
	suits["burgundy suit"] = /obj/item/clothing/under/suit_jacket/burgundy
	suits["charcoal suit"] = /obj/item/clothing/under/suit_jacket/charcoal
	suits["checkered suit"] = /obj/item/clothing/under/suit_jacket/checkered
	suits["executive suit"] = /obj/item/clothing/under/suit_jacket/really_black
	suits["female executive suit"] = /obj/item/clothing/under/suit_jacket/female
	suits["gentleman suit"] = /obj/item/clothing/under/gentlesuit
	suits["navy suit"] = /obj/item/clothing/under/suit_jacket/navy
	suits["old man suit"] = /obj/item/clothing/under/lawyer/oldman
	suits["purple suit"] = /obj/item/clothing/under/lawyer/purpsuit
	suits["red suit"] = /obj/item/clothing/under/suit_jacket/red
	suits["red lawyer suit"] = /obj/item/clothing/under/lawyer/red
	suits["shiny black suit"] = /obj/item/clothing/under/lawyer/black
	suits["tan suit"] = /obj/item/clothing/under/suit_jacket/tan
	suits["white suit"] = /obj/item/clothing/under/scratch
	suits["white-blue suit"] = /obj/item/clothing/under/lawyer/bluesuit
	gear_tweaks += new/datum/gear_tweak/path(suits)

/datum/gear/uniform/scrubs
	display_name = "scrubs selection"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Scientist","Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Paramedic", "Medical Resident", "Xenobiologist", "Roboticist", "Research Director", "Forensic Technician")

/datum/gear/uniform/scrubs/New()
	..()
	var/scrubs = list()
	scrubs["scrubs, black"] = /obj/item/clothing/under/rank/medical/black
	scrubs["scrubs, blue"] = /obj/item/clothing/under/rank/medical/blue
	scrubs["scrubs, green"] = /obj/item/clothing/under/rank/medical/green
	scrubs["scrubs, purple"] = /obj/item/clothing/under/rank/medical/purple
	gear_tweaks += new/datum/gear_tweak/path(scrubs)

/datum/gear/uniform/dress
	display_name = "dress selection"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/dress/New()
	..()
	var/dress = list()
	dress["sundress"] = /obj/item/clothing/under/sundress
	dress["sundress, white"] = /obj/item/clothing/under/sundress_white
	dress["dress, flame"] = /obj/item/clothing/under/dress/dress_fire
	dress["dress, green"] = /obj/item/clothing/under/dress/dress_green
	dress["dress, orange"] = /obj/item/clothing/under/dress/dress_orange
	dress["dress, pink"] = /obj/item/clothing/under/dress/dress_pink
	dress["dress, yellow"] = /obj/item/clothing/under/dress/dress_yellow
	dress["dress, white"] = /obj/item/clothing/under/dress/white
	dress["dress, stripped"] = /obj/item/clothing/under/dress/stripeddress
	dress["dress, sailor"] = /obj/item/clothing/under/dress/sailordress
	dress["dress, red swept"] = /obj/item/clothing/under/dress/red_swept_dress
	dress["dress, western bustle"] = /obj/item/clothing/under/dress/westernbustle
	dress["dress, black tango"] = /obj/item/clothing/under/dress/blacktango
	dress["dress, black tango alternative"] = /obj/item/clothing/under/dress/blacktango/alt
	dress["cheongsam, white"] = /obj/item/clothing/under/cheongsam
	dress["cheongsam, red"] = /obj/item/clothing/under/cheongsam/red
	dress["cheongsam, blue"] = /obj/item/clothing/under/cheongsam/blue
	dress["cheongsam, green"] = /obj/item/clothing/under/cheongsam/green
	dress["cheongsam, purple"] = /obj/item/clothing/under/cheongsam/purple
	gear_tweaks += new/datum/gear_tweak/path(dress)

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Captain")

/datum/gear/uniform/customdress
	display_name = "Evening gown"
	path = /obj/item/clothing/under/dress/dress_evening

/datum/gear/uniform/customdress/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet")

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navyblue (Security Officer)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer", "Head of Security", "Warden")

/datum/gear/uniform/navysecsuit_warden
	display_name = "uniform, navyblue (Warden)"
	path = /obj/item/clothing/under/rank/warden/navyblue
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/uniform/navysecsuit_hos
	display_name = "uniform, navyblue (Head of Security)"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue
	allowed_roles = list("Head of Security")

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants

/datum/gear/uniform/pants/New()
	..()
	var/pants = list()
	pants["jeans"] = /obj/item/clothing/under/pants
	pants["classic jeans"] = /obj/item/clothing/under/pants/classic
	pants["must hang jeans"] = /obj/item/clothing/under/pants/musthang
	pants["black jeans"] = /obj/item/clothing/under/pants/jeansblack
	pants["young folks jeans"] = /obj/item/clothing/under/pants/youngfolksjeans
	pants["white pants"] = /obj/item/clothing/under/pants/white
	pants["black pants"] = /obj/item/clothing/under/pants/black
	pants["red pants"] = /obj/item/clothing/under/pants/red
	pants["tan pants"] = /obj/item/clothing/under/pants/tan
	pants["khaki pants"] = /obj/item/clothing/under/pants/khaki
	pants["track pants"] = /obj/item/clothing/under/pants/track
	pants["blue track pants"] = /obj/item/clothing/under/pants/track/blue
	pants["green track pants"] = /obj/item/clothing/under/pants/track/green
	pants["white track pants"] = /obj/item/clothing/under/pants/track/white
	pants["red track pants"] = /obj/item/clothing/under/pants/track/red
	pants["camo pants"] = /obj/item/clothing/under/pants/camo
	pants["athletic shorts, black"] = /obj/item/clothing/under/shorts
	pants["athletic shorts, red"] = /obj/item/clothing/under/shorts/red
	pants["athletic shorts, green"] = /obj/item/clothing/under/shorts/green
	pants["athletic shorts, black"] = /obj/item/clothing/under/shorts/black
	pants["athletic shorts, grey"] = /obj/item/clothing/under/shorts/grey
	pants["jean shorts"] = /obj/item/clothing/under/shorts/jeans
	pants["jean short shorts"] = /obj/item/clothing/under/shorts/jeans/female
	pants["classic jeans shorts"] = /obj/item/clothing/under/shorts/jeans/classic
	pants["classic jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/classic/female
	pants["mustang jeans shorts"] = /obj/item/clothing/under/shorts/jeans/mustang
	pants["mustang jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/mustang/female
	pants["young folks jeans shorts"] = /obj/item/clothing/under/shorts/jeans/youngfolks
	pants["young folks jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/youngfolks/female
	pants["black jeans shorts"] = /obj/item/clothing/under/shorts/jeans/black
	pants["black jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans/black/female
	pants["grey jeans shorts"] = /obj/item/clothing/under/shorts/jeans/grey
	pants["grey jeans shorts shorts"] = /obj/item/clothing/under/shorts/jeans
	pants["khaki shorts"] = /obj/item/clothing/under/shorts/khaki
	pants["khaki shorts shorts"] = /obj/item/clothing/under/shorts/khaki/female
	gear_tweaks += new/datum/gear_tweak/path(pants)

/datum/gear/uniform/turtleneck
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool

/datum/gear/uniform/dominia
	display_name = "dominia suit selection"
	path = /obj/item/clothing/under/dominia

/datum/gear/uniform/dominia/New()
	..()
	var/suit = list()
	suit["dominia suit"] = /obj/item/clothing/under/dominia
	suit["dominia suit, black"] = /obj/item/clothing/under/dominia/black
	suit["lyodsuit"] = /obj/item/clothing/under/dom_thermal
	gear_tweaks += new/datum/gear_tweak/path(suit)

/datum/gear/uniform/miscellaneous/kimono
	display_name = "kimono"
	path = /obj/item/clothing/under/kimono

/datum/gear/uniform/miscellaneous/kimono/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/miscellaneous/greensuit
	display_name = "green formal uniform"
	path = /obj/item/clothing/under/gov