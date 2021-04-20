/datum/gear/cane
	display_name = "cane"
	path = /obj/item/cane

/datum/gear/cane/crutch
	display_name = "crutch"
	path = /obj/item/cane/crutch

/datum/gear/cane/white
	display_name = "white cane"
	path = /obj/item/cane/white

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

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_alcohol_reagents())

/datum/gear/vacflask_cold
	display_name = "cold vacuum-flask"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask_cold/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/vacflask_cold/spawn_item(var/location, var/metadata)
	. = ..()
	var/obj/item/reagent_containers/food/drinks/flask/vacuumflask/spawned_flask = .
	if(istype(spawned_flask) && spawned_flask.reagents)
		spawned_flask.reagents.set_temperature(T0C + 5)

/datum/gear/vacflask_hot
	display_name = "hot vacuum-flask"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask_hot/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

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
	gear_tweaks += new/datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/banner
	display_name = "banner selection"
	path = /obj/item/flag
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/banner/New()

	..()
	var/banners = list()
	banners["banner, Stellar Corporate Conglomerate"] = /obj/item/flag/scc
	banners["banner, SolGov"] = /obj/item/flag/sol
	banners["banner, Dominia"] = /obj/item/flag/dominia
	banners["banner, Elyra"] = /obj/item/flag/elyra
	banners["banner, Hegemony"] = /obj/item/flag/hegemony
	banners["banner, Jargon"] = /obj/item/flag/jargon
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
	gear_tweaks += new/datum/gear_tweak/path(banners)

/datum/gear/standard
	display_name = "dominian great house standard selection"
	path = /obj/item/flag
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/standard/New()
	..()
	var/standards = list()
	standards["standard, Strelitz"] = /obj/item/flag/strelitz
	standards["standard, Volvalaad"] = /obj/item/flag/volvalaad
	standards["standard, Kazkhz"] = /obj/item/flag/kazkhz
	standards["standard, Caladius"] = /obj/item/flag/caladius
	standards["standard, Zhao"] = /obj/item/flag/zhao
	gear_tweaks += new/datum/gear_tweak/path(standards)

/datum/gear/flag
	display_name = "flag selection"
	cost = 2
	path = /obj/item/flag
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/flag/New()
	..()
	var/flags = list()
	flags["flag, Stellar Corporate Conglomerate"] = /obj/item/flag/scc/l
	flags["flag, SolGov"] = /obj/item/flag/sol/l
	flags["flag, Dominia"] = /obj/item/flag/dominia/l
	flags["flag, Elyra"] = /obj/item/flag/elyra/l
	flags["flag, Hegemony"] = /obj/item/flag/hegemony/l
	flags["flag, Jargon"] = /obj/item/flag/jargon/l
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
	gear_tweaks += new/datum/gear_tweak/path(flags)

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel
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
	path = /obj/item/toy/plushie

/datum/gear/plushie/New()
	..()
	var/plushies = list()
	plushies["plushie, nymph"] = /obj/item/toy/plushie/nymph
	plushies["plushie, mouse"] = /obj/item/toy/plushie/mouse
	plushies["plushie, kitten"] = /obj/item/toy/plushie/kitten
	plushies["plushie, lizard"] = /obj/item/toy/plushie/lizard
	plushies["plushie, spider"] = /obj/item/toy/plushie/spider
	plushies["plushie, farwa"] = /obj/item/toy/plushie/farwa
	plushies["plushie, bear"] = /obj/item/toy/plushie/bear
	plushies["plushie, firefighter bear"] = /obj/item/toy/plushie/bearfire
	plushies["plushie, random squid"] = /obj/item/toy/plushie/squid //if someone can figure out how to make color work with these, good luck lmao
	plushies["plushie, bee"] = /obj/item/toy/plushie/bee
	plushies["plushie, schlorrgo"] = /obj/item/toy/plushie/schlorrgo
	plushies["plushie, cool schlorrgo"] = /obj/item/toy/plushie/coolschlorrgo
	plushies["plushie, slime"] = /obj/item/toy/plushie/slime
	plushies["plushie, penny"] = /obj/item/toy/plushie/pennyplush
	gear_tweaks += new/datum/gear_tweak/path(plushies)

/datum/gear/toothpaste
	display_name = "toothpaste and toothbrush"
	path = /obj/item/storage/box/toothpaste

/datum/gear/toothpaste/New()
	..()
	var/toothpaste = list()
	toothpaste["toothpaste and blue toothbrush"] = /obj/item/storage/box/toothpaste
	toothpaste["toothpaste and green toothbrush"] = /obj/item/storage/box/toothpaste/green
	toothpaste["toothpaste and red toothbrush"] = /obj/item/storage/box/toothpaste/red
	gear_tweaks += new/datum/gear_tweak/path(toothpaste)

/datum/gear/photo
	display_name = "photo"
	path =  /obj/item/photo
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/gadbook
	display_name = "gadpathurian morale manual"
	path = /obj/item/device/litanybook/gadpathur
