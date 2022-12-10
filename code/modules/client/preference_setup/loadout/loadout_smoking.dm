/datum/gear/smoking
	display_name = "matchbox"
	path = /obj/item/storage/box/fancy/matches
	sort_category = "Smoking"

/datum/gear/smoking/zippo
	display_name = "zippo lighter selection"
	path = /obj/item/flame/lighter/zippo

/datum/gear/smoking/zippo/New()
	..()
	var/list/zippolighters = list()
	zippolighters["regular zippo"] = /obj/item/flame/lighter/zippo
	zippolighters["nanotrasen zippo"] = /obj/item/flame/lighter/zippo/nt
	zippolighters["black zippo"] = /obj/item/flame/lighter/zippo/black
	zippolighters["black cross zippo"] = /obj/item/flame/lighter/zippo/black/cross
	zippolighters["golden zippo"] = /obj/item/flame/lighter/zippo/gold
	zippolighters["royal zippo"] = /obj/item/flame/lighter/zippo/royal
	zippolighters["dominian zippo"] = /obj/item/flame/lighter/zippo/dominia
	zippolighters["fisanduhian zippo"] = /obj/item/flame/lighter/zippo/fisanduh
	zippolighters["coalition zippo"] = /obj/item/flame/lighter/zippo/coalition
	zippolighters["solarian zippo"] = /obj/item/flame/lighter/zippo/sol
	zippolighters["bieselite zippo"] = /obj/item/flame/lighter/zippo/tcfl
	zippolighters["himeo zippo"] = /obj/item/flame/lighter/zippo/himeo
	zippolighters["europan zippo"] = /obj/item/flame/lighter/zippo/europa
	zippolighters["gadpathurian zippo"] = /obj/item/flame/lighter/zippo/gadpathur
	zippolighters["luceian zippo"] = /obj/item/flame/lighter/zippo/luceian
	zippolighters["asoral jet lighter"] = /obj/item/flame/lighter/zippo/asoral
	gear_tweaks += new /datum/gear_tweak/path(zippolighters)

/datum/gear/smoking/lighter
	display_name = "cheap lighter"
	path = /obj/item/flame/lighter/colourable
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/smoking/cigarcase
	display_name = "cigar case"
	path = /obj/item/storage/box/fancy/cigarettes/cigar
	cost = 2

/datum/gear/smoking/cigarettes
	display_name = "cigarette packet selection"
	description = "A selection of cigarette packets."
	path = /obj/item/storage/box/fancy/cigarettes
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/cigarettes/New()
	..()
	var/list/cigarettes = list()
	cigarettes["Laissez-Faires cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/rugged
	cigarettes["Trans-Stellar Duty Free cigarette packet"] = /obj/item/storage/box/fancy/cigarettes
	cigarettes["DromedaryCo cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/dromedaryco
	cigarettes["Nico-Tine cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/nicotine
	cigarettes["Working Tajara cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/pra
	cigarettes["Shastar Leaves cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/dpra
	cigarettes["Royal Choice cigarette packet"] = /obj/item/storage/box/fancy/cigarettes/nka
	gear_tweaks += new /datum/gear_tweak/path(cigarettes)

/datum/gear/smoking/chew
	display_name = "chewing tobacco selection"
	description = "A selection of chewing tobacco."
	path = /obj/item/storage/chewables/tobacco
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/chew/New()
	..()
	var/list/chews = list()
	chews["Rredouane Cuts chewing tobacco"] = /obj/item/storage/chewables/tobacco/bad
	chews["Mendell Smooth chewing tobacco"] = /obj/item/storage/chewables/tobacco
	chews["Taba-Kamu chewing tobacco"] = /obj/item/storage/chewables/tobacco/fine
	chews["box of Nico-Tine gum"] = /obj/item/storage/box/fancy/chewables/tobacco/nico
	gear_tweaks += new /datum/gear_tweak/path(chews)

/datum/gear/smoking/leaves
	display_name = "tobacco leaf selection"
	description = "A selection of tobacco leaves."
	path = /obj/item/storage/chewables/rollable
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/leaves/New()
	..()
	var/list/leaves = list()
	leaves["S'th Kasavakh tobacco leaves"] = /obj/item/storage/chewables/rollable/unathi
	leaves["Agyre Lake tobacco leaves"] = /obj/item/storage/chewables/rollable
	leaves["Excelsior Epsilon tobacco leaves"] = /obj/item/storage/chewables/rollable/fine
	leaves["Golden Sol tobacco leaves"] = /obj/item/storage/chewables/rollable/nico
	gear_tweaks += new /datum/gear_tweak/path(leaves)

/datum/gear/smoking/pipe
	display_name = "pipe selection"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/smoking/pipe/New()
	..()
	var/list/pipe = list()
	pipe["smoking pipe"] = /obj/item/clothing/mask/smokable/pipe
	pipe["smoking pipe, corn"] = /obj/item/clothing/mask/smokable/pipe/cobpipe
	gear_tweaks += new /datum/gear_tweak/path(pipe)

/datum/gear/smoking/bonepipe
	display_name = "Europan bone pipe"
	path = /obj/item/clothing/mask/smokable/pipe/bonepipe
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/cigfilters
	display_name = "cigarette filters"
	path = /obj/item/storage/cigfilters

/datum/gear/smoking/cigpaper
	display_name = "cigarette paper selection"
	description = "A selection of cigarette papers."
	path = /obj/item/storage/box/fancy/cigpaper

/datum/gear/smoking/cigpaper/New()
	..()
	var/list/cigpaper = list()
	cigpaper["Gen. Eric cigarette paper"] = /obj/item/storage/box/fancy/cigpaper
	cigpaper["Trident cigarette paper"] = /obj/item/storage/box/fancy/cigpaper/fine
	gear_tweaks += new /datum/gear_tweak/path(cigpaper)

/datum/gear/smoking/ecig
	display_name = "electronic cigarette selection"
	description = "A selection of electronic cigarettes."
	path = /obj/item/clothing/mask/smokable/ecig

/datum/gear/smoking/ecig/New()
	..()
	var/list/ecig = list()
	ecig["cheap electronic cigarette"] = /obj/item/clothing/mask/smokable/ecig/simple
	ecig["ordinary electronic cigarette"] = /obj/item/clothing/mask/smokable/ecig/util
	ecig["deluxe electronic cigarette"] = /obj/item/clothing/mask/smokable/ecig/deluxe
	gear_tweaks += new /datum/gear_tweak/path(ecig)
