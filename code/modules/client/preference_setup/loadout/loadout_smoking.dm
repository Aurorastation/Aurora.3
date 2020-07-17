/datum/gear/smoking
	display_name = "matchbook"
	path = /obj/item/storage/box/matches
	sort_category = "Smoking"

/datum/gear/smoking/zippo
	display_name = "zippo"
	path = /obj/item/flame/lighter/zippo

/datum/gear/smoking/lighter
	display_name = "cheap lighter"
	path = /obj/item/flame/lighter

/datum/gear/smoking/cigarcase
	display_name = "cigar case"
	path = /obj/item/storage/fancy/cigarettes/cigar
	cost = 2

/datum/gear/smoking/cigarettes
	display_name = "cigarette packet selection"
	description = "A selection of cigarette packets."
	path = /obj/item/storage/fancy/cigarettes
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/cigarettes/New()
	..()
	var/cigarettes = list()
	cigarettes["Lucky Strike cigarette packet"] = /obj/item/storage/fancy/cigarettes/rugged
	cigarettes["Trans-Stellar Duty Free cigarette packet"] = /obj/item/storage/fancy/cigarettes
	cigarettes["DromedaryCo cigarette packet"] = /obj/item/storage/fancy/cigarettes/dromedaryco
	cigarettes["Nico-Tine cigarette packet"] = /obj/item/storage/fancy/cigarettes/nicotine
	cigarettes["Working Tajara cigarette packet"] = /obj/item/storage/fancy/cigarettes/pra
	cigarettes["Shastar Leaves cigarette packet"] = /obj/item/storage/fancy/cigarettes/dpra
	cigarettes["Royal Choice cigarette packet"] = /obj/item/storage/fancy/cigarettes/nka
	gear_tweaks += new/datum/gear_tweak/path(cigarettes)

/datum/gear/smoking/chew
	display_name = "chewing tobacco selection"
	description = "A selection of chewing tobacco."
	path = /obj/item/storage/chewables/tobacco
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/chew/New()
	..()
	var/chews = list()
	chews["Rredouane Cuts chewing tobacco"] = /obj/item/storage/chewables/tobacco/bad
	chews["Mendell Smooth chewing tobacco"] = /obj/item/storage/chewables/tobacco
	chews["Taba-Kamu chewing tobacco"] = /obj/item/storage/chewables/tobacco/fine
	chews["box of Nico-Tine gum"] = /obj/item/storage/fancy/chewables/tobacco/nico
	gear_tweaks += new/datum/gear_tweak/path(chews)

/datum/gear/smoking/leaves
	display_name = "tobacco leaf selection"
	description = "A selection of tobacco leaves."
	path = /obj/item/storage/chewables/rollable
	cost = 2
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/smoking/leaves/New()
	..()
	var/leaves = list()
	leaves["S'th Kasavakh tobacco leaves"] = /obj/item/storage/chewables/rollable/bad
	leaves["Agyre Lake tobacco leaves"] = /obj/item/storage/chewables/rollable
	leaves["Excelsior Epsilon tobacco leaves"] = /obj/item/storage/chewables/rollable/fine
	leaves["Golden Sol tobacco leaves"] = /obj/item/storage/chewables/rollable/nico
	gear_tweaks += new/datum/gear_tweak/path(leaves)

/datum/gear/smoking/pipe
	display_name = "pipe selection"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/smoking/pipe/New()
	..()
	var/pipe = list()
	pipe["smoking pipe"] = /obj/item/clothing/mask/smokable/pipe
	pipe["smoking pipe, corn"] = /obj/item/clothing/mask/smokable/pipe/cobpipe
	gear_tweaks += new/datum/gear_tweak/path(pipe)

/datum/gear/smoking/cigfilters
	display_name = "cigarette filters"
	path = /obj/item/storage/cigfilters

/datum/gear/smoking/cigpaper
	display_name = "cigarette paper selection"
	description = "A selection of cigarette papers."
	path = /obj/item/storage/fancy/cigpaper

/datum/gear/smoking/cigpaper/New()
	..()
	var/cigpaper = list()
	cigpaper["Gen. Eric cigarette paper"] = /obj/item/storage/fancy/cigpaper
	cigpaper["Trident cigarette paper"] = /obj/item/storage/fancy/cigpaper/fine
	gear_tweaks += new/datum/gear_tweak/path(cigpaper)
