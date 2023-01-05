/datum/gear/cane
	display_name = "cane"
	path = /obj/item/cane

/datum/gear/cane/New()
	..()
	var/list/cane = list()
	cane["cane"] = /obj/item/cane
	cane["telescopic cane"] = /obj/item/cane/telecane
	cane["crutch"] = /obj/item/cane/crutch
	cane["white cane"] = /obj/item/cane/white
	gear_tweaks += new /datum/gear_tweak/path(cane)

/datum/gear/dice
	display_name = "pack of dice"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dicegaming
	display_name = "pack of gaming dice"
	path = /obj/item/storage/pill_bottle/dice/gaming

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/storage/card

/datum/gear/cardemon_pack
	display_name = "cardemon booster pack"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "spaceball booster pack"
	path = /obj/item/pack/spaceball

/datum/gear/gamehelm
	display_name = "handheld video game console"
	description = "A selection of various Game-Helm consoles."
	cost = 1
	path = /obj/item/gamehelm

/datum/gear/gamehelm/New()
	..()
	var/list/gamehelm = list()
	gamehelm["red game-helm"] = /obj/item/gamehelm/red
	gamehelm["blue game-helm"] = /obj/item/gamehelm/blue
	gamehelm["green game-helm"] = /obj/item/gamehelm/green
	gamehelm["yellow game-helm"] = /obj/item/gamehelm/yellow
	gamehelm["pink game-helm"] = /obj/item/gamehelm/pink
	gamehelm["black game-helm"] = /obj/item/gamehelm/black
	gamehelm["weathered game-helm"] = /obj/item/gamehelm/weathered
	gamehelm["brown game-helm"] = /obj/item/gamehelm/brown
	gamehelm["turquoise game-helm"] = /obj/item/gamehelm/turquoise
	gamehelm["white game-helm"] = /obj/item/gamehelm
	gamehelm["purple game-helm"] = /obj/item/gamehelm/purple
	gear_tweaks += new /datum/gear_tweak/path(gamehelm)

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_all_drink_reagents())

/datum/gear/vacflask_cold
	display_name = "cold vacuum flask"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask_cold/New()
	..()
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_all_drink_reagents())

/datum/gear/vacflask_cold/spawn_item(var/location, var/metadata)
	. = ..()
	var/obj/item/reagent_containers/food/drinks/flask/vacuumflask/spawned_flask = .
	if(istype(spawned_flask) && spawned_flask.reagents)
		spawned_flask.reagents.set_temperature(T0C + 5)

/datum/gear/vacflask_hot
	display_name = "hot vacuum flask"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask_hot/New()
	..()
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_all_drink_reagents())

/datum/gear/vacflask_hot/spawn_item(var/location, var/metadata)
	. = ..()
	var/obj/item/reagent_containers/food/drinks/flask/vacuumflask/spawned_flask = .
	if(istype(spawned_flask) && spawned_flask.reagents)
		spawned_flask.reagents.set_temperature(T0C + 45)

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/toolbox/lunchbox))
		var/obj/item/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	sortTim(lunchboxes, /proc/cmp_text_asc)
	gear_tweaks += new /datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new /datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks(), lunchables_utensil())

/datum/gear/coffeecup
	display_name = "coffee cups"
	description = "A coffee cup in various designs."
	cost = 1
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup

/datum/gear/coffeecup/New()
	..()
	var/list/coffeecups = list()
	coffeecups["plain coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup
	coffeecups["sol coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/sol
	coffeecups["dominian coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/dom
	coffeecups["NKA coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/nka
	coffeecups["PRA coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/pra
	coffeecups["DPRA coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/dpra
	coffeecups["Sedantis coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/sedantis
	coffeecups["CoC coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/coc
	coffeecups["Eridani coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/eridani
	coffeecups["Elyra coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/elyra
	coffeecups["Hegemony coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/hegemony
	coffeecups["Nralakk coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/nralakk
	coffeecups["NT coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/nt
	coffeecups["Hephaestus coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal/hepht
	coffeecups["Idris coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/idris
	coffeecups["Zeng-Hu coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/zeng
	coffeecups["TCFL coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tcfl
	coffeecups["#1 coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/one
	coffeecups["#1 monkey coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/puni
	coffeecups["heart coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/heart
	coffeecups["pawn coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/pawn
	coffeecups["diona coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/diona
	coffeecups["british coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/britcup
	coffeecups["black coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/black
	coffeecups["green coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/green
	coffeecups["dark green coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/green/dark
	coffeecups["rainbow coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/rainbow
	coffeecups["metal coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/metal
	coffeecups["glass coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/glass
	coffeecups["tall coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall
	coffeecups["tall black coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/black
	coffeecups["tall metal coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/metal
	coffeecups["tall rainbow coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/tall/rainbow
	gear_tweaks += new /datum/gear_tweak/path(coffeecups)
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/coffeecup/spawn_item(var/location, var/metadata)
	. = ..()
	var/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/spawned_cup = .
	if(istype(spawned_cup) && spawned_cup.reagents)
		spawned_cup.reagents.set_temperature(T0C + 45)

/datum/gear/banner
	display_name = "banner selection"
	path = /obj/item/flag
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/banner/New()
	..()
	var/list/banners = list()
	banners["banner, Stellar Corporate Conglomerate"] = /obj/item/flag/scc
	banners["banner, Sol Alliance"] = /obj/item/flag/sol
	banners["banner, Dominia"] = /obj/item/flag/dominia
	banners["banner, Elyra"] = /obj/item/flag/elyra
	banners["banner, Hegemony"] = /obj/item/flag/hegemony
	banners["banner, Nralakk"] = /obj/item/flag/nralakk
	banners["banner, Traverse"] = /obj/item/flag/traverse
	banners["banner, NanoTrasen"] = /obj/item/flag/nanotrasen
	banners["banner, Eridani Fed"] = /obj/item/flag/eridani
	banners["banner, Sedantis"] = /obj/item/flag/vaurca
	banners["banner, People's Republic of Adhomai"] = /obj/item/flag/pra
	banners["banner, Democratic People's Republic of Adhomai"] = /obj/item/flag/dpra
	banners["banner, New Kingdom of Adhomai"] = /obj/item/flag/nka
	banners["banner, Republic of Biesel"] = /obj/item/flag/biesel
	banners["banner, Dominian Diona"] = /obj/item/flag/diona
	banners["banner, Trinary Perfection"] = /obj/item/flag/trinaryperfection
	banners["banner, Hephaestus Industries"] = /obj/item/flag/heph
	banners["banner, Idris Incorporated"] = /obj/item/flag/idris
	banners["banner, Zenghu Pharmaceuticals"] = /obj/item/flag/zenghu
	banners["banner, Zavodskoi Interstellar"] = /obj/item/flag/zavodskoi
	banners["banner, Coalition of Colonies"] = /obj/item/flag/coalition
	banners["banner, Confederate States of Fisanduh"] = /obj/item/flag/fisanduh
	banners["banner, Gadpathur"] = /obj/item/flag/gadpathur
	banners["banner, Vysoka"] = /obj/item/flag/vysoka
	banners["banner, Konyang"] = /obj/item/flag/konyang
	gear_tweaks += new /datum/gear_tweak/path(banners)

/datum/gear/standard
	display_name = "dominian great house standard selection"
	path = /obj/item/flag
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/standard/New()
	..()
	var/list/standards = list()
	standards["standard, Strelitz"] = /obj/item/flag/strelitz
	standards["standard, Volvalaad"] = /obj/item/flag/volvalaad
	standards["standard, Kazkhz"] = /obj/item/flag/kazkhz
	standards["standard, Caladius"] = /obj/item/flag/caladius
	standards["standard, Zhao"] = /obj/item/flag/zhao
	gear_tweaks += new /datum/gear_tweak/path(standards)

/datum/gear/flag
	display_name = "flag selection"
	cost = 2
	path = /obj/item/flag
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/flag/New()
	..()
	var/list/flags = list()
	flags["flag, Stellar Corporate Conglomerate"] = /obj/item/flag/scc/l
	flags["flag, Sol Alliance"] = /obj/item/flag/sol/l
	flags["flag, Dominia"] = /obj/item/flag/dominia/l
	flags["flag, Elyra"] = /obj/item/flag/elyra/l
	flags["flag, Hegemony"] = /obj/item/flag/hegemony/l
	flags["flag, Nralakk"] = /obj/item/flag/nralakk/l
	flags["flag, Traverse"] = /obj/item/flag/traverse/l
	flags["flag, NanoTrasen"] = /obj/item/flag/nanotrasen/l
	flags["flag, Eridani Fed"] = /obj/item/flag/eridani/l
	flags["flag, Sedantis"] = /obj/item/flag/vaurca/l
	flags["flag, People's Republic of Adhomai"] = /obj/item/flag/pra/l
	flags["flag, Democratic People's Republic of Adhomai"] = /obj/item/flag/dpra/l
	flags["flag, New Kingdom of Adhomai"] = /obj/item/flag/nka/l
	flags["flag, Republic of Biesel"] = /obj/item/flag/biesel/l
	flags["flag, Trinary Perfection"] = /obj/item/flag/trinaryperfection/l
	flags["flag, Hephaestus Industries"] = /obj/item/flag/heph/l
	flags["flag, Idris Incorporated"] = /obj/item/flag/idris/l
	flags["flag, Zeng-Hu Pharmaceuticals"] = /obj/item/flag/zenghu/l
	flags["flag, Zavodskoi Interstellar"] = /obj/item/flag/zavodskoi/l
	flags["flag, Coalition of Colonies"] = /obj/item/flag/coalition/l
	flags["flag, Confederate States of Fisanduh"] = /obj/item/flag/fisanduh/l
	flags["flag, Gadpathur"] = /obj/item/flag/gadpathur/l
	flags["flag, Vysoka"] = /obj/item/flag/vysoka/l
	flags["flag, Konyang"] = /obj/item/flag/konyang/l
	gear_tweaks += new /datum/gear_tweak/path(flags)

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/handkerchief
	display_name = "handkerchief"
	path = /obj/item/reagent_containers/glass/rag/handkerchief
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/gameboard
	display_name = "holo board game"
	path = /obj/item/board

/datum/gear/battlemonsters
	display_name = "battlemonsters starter deck"
	path = /obj/item/battle_monsters/wrapped

/datum/gear/squidplushie
	display_name = "colourable squid plushie"
	path = /obj/item/toy/plushie/squidcolour
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/plushie
	display_name = "plushie selection"
	description = "A selection of plush toys."
	path = /obj/item/toy/plushie

/datum/gear/plushie/New()
	..()
	var/list/plushies = list()
	plushies["plushie, nymph"] = /obj/item/toy/plushie/nymph
	plushies["plushie, mouse"] = /obj/item/toy/plushie/mouse
	plushies["plushie, kitten"] = /obj/item/toy/plushie/kitten
	plushies["plushie, lizard"] = /obj/item/toy/plushie/lizard
	plushies["plushie, spider"] = /obj/item/toy/plushie/spider
	plushies["plushie, farwa"] = /obj/item/toy/plushie/farwa
	plushies["plushie, bear"] = /obj/item/toy/plushie/bear
	plushies["plushie, firefighter bear"] = /obj/item/toy/plushie/bearfire
	plushies["plushie, random squid"] = /obj/item/toy/plushie/squid //if someone can figure out how to make color work with these, good luck lmao
	plushies["plushie, red fox"] = /obj/item/toy/plushie/fox
	plushies["plushie, black fox"] = /obj/item/toy/plushie/fox/black
	plushies["plushie, marble fox"] = /obj/item/toy/plushie/fox/marble
	plushies["plushie, blue fox"] = /obj/item/toy/plushie/fox/blue
	plushies["plushie, orange fox"] = /obj/item/toy/plushie/fox/orange
	plushies["plushie, coffee fox"] = /obj/item/toy/plushie/fox/coffee
	plushies["plushie, pink fox"] = /obj/item/toy/plushie/fox/pink
	plushies["plushie, purple fox"] = /obj/item/toy/plushie/fox/purple
	plushies["plushie, crimson fox"] = /obj/item/toy/plushie/fox/crimson
	plushies["plushie, random fox"] = /obj/item/toy/plushie/fox/random
	plushies["plushie, bee"] = /obj/item/toy/plushie/bee
	plushies["plushie, shark"] = /obj/item/toy/plushie/shark
	plushies["plushie, schlorrgo"] = /obj/item/toy/plushie/schlorrgo
	plushies["plushie, cool schlorrgo"] = /obj/item/toy/plushie/coolschlorrgo
	plushies["plushie, slime"] = /obj/item/toy/plushie/slime
	plushies["plushie, penny"] = /obj/item/toy/plushie/pennyplush
	plushies["plushie, greimorian"] = /obj/item/toy/plushie/greimorian
	plushies["plushie, Axic"] = /obj/item/toy/plushie/axic
	plushies["plushie, Qill"] = /obj/item/toy/plushie/qill
	plushies["plushie, Xana"] = /obj/item/toy/plushie/xana
	plushies["plushie, Aphy"] = /obj/item/toy/plushie/ipc
	gear_tweaks += new /datum/gear_tweak/path(plushies)

/datum/gear/comic
	display_name = "comic selection"
	description = "A selection of comics, manga, and magazines from across the Spur."
	path = /obj/item/toy/comic

/datum/gear/comic/New()
	..()
	var/list/comics = list()
	comics["comic book"] = /obj/item/toy/comic
	comics["inspector 404 manga"] = /obj/item/toy/comic/inspector
	comics["stormman manga"] = /obj/item/toy/comic/stormman
	comics["outlandish tales magazine"] = /obj/item/toy/comic/outlandish_tales
	comics["az'marian comic, issue 1"] = /obj/item/toy/comic/azmarian/issue_1
	comics["az'marian comic, issue 2"] = /obj/item/toy/comic/azmarian/issue_2
	comics["az'marian comic, issue 3"] = /obj/item/toy/comic/azmarian/issue_3
	comics["az'marian comic, issue 4"] = /obj/item/toy/comic/azmarian/issue_4
	comics["az'marian comic, issue 5"] = /obj/item/toy/comic/azmarian/issue_5
	comics["az'marian comic, issue 6"] = /obj/item/toy/comic/azmarian/issue_6
	comics["az'marian comic, issue 7"] = /obj/item/toy/comic/azmarian/issue_7
	comics["az'marian comic, issue 8"] = /obj/item/toy/comic/azmarian/issue_8
	gear_tweaks += new /datum/gear_tweak/path(comics)

/datum/gear/toothpaste
	display_name = "toothpaste and toothbrush"
	path = /obj/item/storage/box/toothpaste

/datum/gear/toothpaste/New()
	..()
	var/list/toothpaste = list()
	toothpaste["toothpaste and blue toothbrush"] = /obj/item/storage/box/toothpaste
	toothpaste["toothpaste and green toothbrush"] = /obj/item/storage/box/toothpaste/green
	toothpaste["toothpaste and red toothbrush"] = /obj/item/storage/box/toothpaste/red
	gear_tweaks += new /datum/gear_tweak/path(toothpaste)

/datum/gear/photo
	display_name = "photo"
	path =  /obj/item/photo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/photo_album
	display_name = "photo album"
	path =  /obj/item/storage/photo_album
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/knitting_set
	display_name = "knitting set"
	path =  /obj/item/storage/box/knitting
	description = "A box of knitting supplies."
	flags = null

/datum/gear/yarn_box
	display_name = "knitting supplies"
	path =  /obj/item/storage/box/yarn
	description = "A box containing yarn."
	flags = null

/datum/gear/gadbook
	display_name = "gadpathurian morale manual"
	path = /obj/item/device/versebook/gadpathur
	origin_restriction = list(/decl/origin_item/origin/gadpathur)

/datum/gear/aurora_miniature
	display_name = "aurora miniature"
	description = "A commemorative miniature of the NSS Aurora."
	path = /obj/item/toy/aurora
