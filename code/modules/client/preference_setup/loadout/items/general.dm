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
	sortTim(lunchboxes, GLOBAL_PROC_REF(cmp_text_asc))
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
	coffeecups["San Colette coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/sancolette
	coffeecups["Europa coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/europa
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
	coffeecups["shumaila coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/shumaila
	coffeecups["nated coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/nated
	coffeecups["vahzirthaamro coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/kingazunja
	coffeecups["hadii coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/hadii
	coffeecups["njarir coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/njarir
	coffeecups["m'sai coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/msai
	coffeecups["hharar coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/hharar
	coffeecups["zhan coffee cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/zhan
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

/datum/gear/teacup
	display_name = "tea cups"
	description = "Tea cups in various designs."
	cost = 1
	path = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup

/datum/gear/teacup/New()
	..()
	var/list/teacups = list()
	teacups["plain tea cup"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup
	teacups["clay yunomi"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang
	teacups["grey yunomi"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/grey
	teacups["glazed pattern yunomi"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/pattern
	teacups["manila pattern yunomi"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/manila
	teacups["nature pattern yunomi"] = /obj/item/reagent_containers/food/drinks/drinkingglass/newglass/konyang/nature

	gear_tweaks += new /datum/gear_tweak/path(teacups)
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/teacup/spawn_item(var/location, var/metadata)
	. = ..()
	var/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup/spawned_cup = .
	if(istype(spawned_cup) && spawned_cup.reagents)
		spawned_cup.reagents.set_temperature(T0C + 45)

/datum/gear/chatins
	display_name = "konyang-cha tins"
	description = "Tins of tea leaves made by Konyang-cha."
	cost = 1
	path = /obj/item/storage/box/tea

/datum/gear/chatins/New()
	..()
	var/list/chatins = list()
	chatins["sencha cha-tin"] = /obj/item/storage/box/tea
	chatins["tieguanyin cha-tin"] = /obj/item/storage/box/tea/tieguanyin
	chatins["jaekseol cha-tin"] = /obj/item/storage/box/tea/jaekseol
	gear_tweaks += new /datum/gear_tweak/path(chatins)

/datum/gear/teapots
	display_name = "teapots"
	description = "A selection of teapots."
	cost = 1
	path = /obj/item/reagent_containers/glass/beaker/teapot

/datum/gear/teapots/New()
	..()
	var/list/teapots = list()
	teapots["teapot"] = /obj/item/reagent_containers/glass/beaker/teapot
	teapots["gaiwan"] = /obj/item/reagent_containers/glass/beaker/teapot/lidded
	teapots["kyusu"] = /obj/item/reagent_containers/glass/beaker/teapot/lidded/kyusu
	gear_tweaks += new /datum/gear_tweak/path(teapots)

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
	banners["banner, Ouerea"] = /obj/item/flag/ouerea
	banners["banner, Old Ouerea"] = /obj/item/flag/ouerea/old
	banners["banner, Nralakk"] = /obj/item/flag/nralakk
	banners["banner, Traverse"] = /obj/item/flag/traverse
	banners["banner, NanoTrasen"] = /obj/item/flag/nanotrasen
	banners["banner, Eridani Fed"] = /obj/item/flag/eridani
	banners["banner, Sedantis"] = /obj/item/flag/sedantis
	banners["banner, People's Republic of Adhomai"] = /obj/item/flag/pra
	banners["banner, Democratic People's Republic of Adhomai"] = /obj/item/flag/dpra
	banners["banner, New Kingdom of Adhomai"] = /obj/item/flag/nka
	banners["banner, Free Tajaran Council"] = /obj/item/flag/ftc
	banners["banner, Republic of Biesel"] = /obj/item/flag/biesel
	banners["banner, Solarian Colonial Mandate of Tau Ceti"] = /obj/item/flag/biesel/antique
	banners["banner, CT-EUM"] = /obj/item/flag/cteum
	banners["banner, Trinary Perfection"] = /obj/item/flag/trinaryperfection
	banners["banner, Hephaestus Industries"] = /obj/item/flag/heph
	banners["banner, Idris Incorporated"] = /obj/item/flag/idris
	banners["banner, Zenghu Pharmaceuticals"] = /obj/item/flag/zenghu
	banners["banner, Zavodskoi Interstellar"] = /obj/item/flag/zavodskoi
	banners["banner, Coalition of Colonies"] = /obj/item/flag/coalition
	banners["banner, All-Xanu Republic"] = /obj/item/flag/xanu
	banners["banner, Confederate States of Fisanduh"] = /obj/item/flag/fisanduh
	banners["banner, Gadpathur"] = /obj/item/flag/gadpathur
	banners["banner, Vysoka"] = /obj/item/flag/vysoka
	banners["banner, Konyang"] = /obj/item/flag/konyang
	banners["banner, Red Coalition"] = /obj/item/flag/red_coalition
	banners["banner, Private Military Contracting Group"] = /obj/item/flag/pmcg
	banners["banner, United Syndicates of Himeo"] = /obj/item/flag/himeo
	banners["banner, Republic of Assunzione"] = /obj/item/flag/assunzione
	banners["banner, New Gibson"] = /obj/item/flag/newgibson
	banners["banner, Visegrad"] = /obj/item/flag/visegrad
	banners["banner, Union of Port Antillia"] = /obj/item/flag/portantillia
	banners["banner, Sovereign Solarian Republic of San Colette"] = /obj/item/flag/sancolette
	banners["banner, Old Sovereign Solarian Republic of San Colette"] = /obj/item/flag/sancolette/old
	banners["banner, Mictlan"] = /obj/item/flag/mictlan
	banners["banner, New Hai Phong"] = /obj/item/flag/nhp
	banners["banner, Silversun"] = /obj/item/flag/silversun
	banners["banner, Luna"] = /obj/item/flag/luna
	banners["banner, Persepolis"] = /obj/item/flag/persepolis
	banners["banner, Damascus"] = /obj/item/flag/damascus
	banners["banner, Medina"] = /obj/item/flag/medina
	banners["banner, Aemaq"] = /obj/item/flag/aemaq
	banners["banner, New Suez"] = /obj/item/flag/newsuez
	banners["banner, Hive Zo'ra"] = /obj/item/flag/zora
	banners["banner, Hive K'lax"] = /obj/item/flag/klax
	banners["banner, Hive C'thur"] = /obj/item/flag/cthur
	banners["banner, Orion Express"] = /obj/item/flag/orion_express
	banners["banner, Imperial Frontier"] = /obj/item/flag/imperial_frontier
	banners["banner, Scarab Fleet"] = /obj/item/flag/scarab
	banners["banner, Federal Technocracy of Galatea"] = /obj/item/flag/galatea_government
	banners["banner, Galatea"] = /obj/item/flag/galatea
	banners["banner, Tsukuyomi"] = /obj/item/flag/tsukuyomi
	banners["banner, Svarog"] = /obj/item/flag/svarog
	banners["banner, Empyrean"] = /obj/item/flag/empyrean
	banners["banner, Traditinalist Coalition"] = /obj/item/flag/traditionalist
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
	standards["standard, Kazhkz"] = /obj/item/flag/kazhkz
	standards["standard, Han'san"] = /obj/item/flag/hansan
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
	flags["flag, Ouerea"] = /obj/item/flag/ouerea/l
	flags["flag, Old Ouerea"] = /obj/item/flag/ouerea/old/l
	flags["flag, Nralakk"] = /obj/item/flag/nralakk/l
	flags["flag, Traverse"] = /obj/item/flag/traverse/l
	flags["flag, NanoTrasen"] = /obj/item/flag/nanotrasen/l
	flags["flag, Eridani Fed"] = /obj/item/flag/eridani/l
	flags["flag, Sedantis"] = /obj/item/flag/sedantis/l
	flags["flag, People's Republic of Adhomai"] = /obj/item/flag/pra/l
	flags["flag, Democratic People's Republic of Adhomai"] = /obj/item/flag/dpra/l
	flags["flag, New Kingdom of Adhomai"] = /obj/item/flag/nka/l
	flags["flag, Free Tajaran Council"] = /obj/item/flag/ftc/l
	flags["flag, Republic of Biesel"] = /obj/item/flag/biesel/l
	flags["flag, Solarian Colonial Mandate of Tau Ceti"] = /obj/item/flag/biesel/antique/l
	flags["flag, Trinary Perfection"] = /obj/item/flag/trinaryperfection/l
	flags["flag, Hephaestus Industries"] = /obj/item/flag/heph/l
	flags["flag, Idris Incorporated"] = /obj/item/flag/idris/l
	flags["flag, Zeng-Hu Pharmaceuticals"] = /obj/item/flag/zenghu/l
	flags["flag, Zavodskoi Interstellar"] = /obj/item/flag/zavodskoi/l
	flags["flag, Coalition of Colonies"] = /obj/item/flag/coalition/l
	flags["flag, All-Xanu Republic"] = /obj/item/flag/xanu/l
	flags["flag, Confederate States of Fisanduh"] = /obj/item/flag/fisanduh/l
	flags["flag, Gadpathur"] = /obj/item/flag/gadpathur/l
	flags["flag, Vysoka"] = /obj/item/flag/vysoka/l
	flags["flag, Konyang"] = /obj/item/flag/konyang/l
	flags["flag, Red Coalition"] = /obj/item/flag/red_coalition/l
	flags["flag, Private Military Contracting Group"] = /obj/item/flag/pmcg/l
	flags["flag, United Syndicates of Himeo"] = /obj/item/flag/himeo/l
	flags["flag, Republic of Assunzione"] = /obj/item/flag/assunzione/l
	flags["flag, Union of Port Antillia"] = /obj/item/flag/portantillia/l
	flags["flag, Sovereign Solarian Republic of San Colette"] = /obj/item/flag/sancolette/l
	flags["flag, Old Sovereign Solarian Republic of San Colette"] = /obj/item/flag/sancolette/old/l
	flags["flag, Mictlan"] = /obj/item/flag/mictlan/l
	flags["flag, New Hai Phong"] = /obj/item/flag/nhp/l
	flags["flag, Silversun"] = /obj/item/flag/silversun/l
	flags["flag, Luna"] = /obj/item/flag/luna/l
	flags["flag, Persepolis"] = /obj/item/flag/persepolis/l
	flags["flag, Damascus"] = /obj/item/flag/damascus/l
	flags["flag, Medina"] = /obj/item/flag/medina/l
	flags["flag, Aemaq"] = /obj/item/flag/aemaq/l
	flags["flag, New Suez"] = /obj/item/flag/newsuez/l
	flags["flag, Hive Zo'ra"] = /obj/item/flag/zora/l
	flags["flag, Hive K'lax"] = /obj/item/flag/klax/l
	flags["flag, Hive C'thur"] = /obj/item/flag/cthur/l
	flags["flag, Orion Express"] = /obj/item/flag/orion_express/l
	flags["flag, Imperial Frontier"] = /obj/item/flag/imperial_frontier/l
	flags["flag, Scarab Fleet"] = /obj/item/flag/scarab/l
	flags["flag, Federal Technocracy of Galatea"] = /obj/item/flag/galatea_government/l
	flags["flag, Galatea"] = /obj/item/flag/galatea/l
	flags["flag, Tsukuyomi"] = /obj/item/flag/tsukuyomi/l
	flags["flag, Svarog"] = /obj/item/flag/svarog/l
	flags["flag, Empyrean"] = /obj/item/flag/empyrean/l
	flags["flag, Traditionalist Coalition"] = /obj/item/flag/traditionalist/l
	gear_tweaks += new /datum/gear_tweak/path(flags)

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/handkerchief
	display_name = "handkerchief"
	path = /obj/item/reagent_containers/glass/rag/handkerchief
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

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
	comics["dominian witchfinder novel"] = /obj/item/toy/comic/witchfinder
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
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/gear/aurora_miniature
	display_name = "aurora miniature"
	description = "A commemorative miniature of the NSS Aurora."
	path = /obj/item/toy/aurora
