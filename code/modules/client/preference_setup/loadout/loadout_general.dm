/datum/gear/cane
	display_name = "cane"
	path = /obj/item/cane

/datum/gear/cane/white
	display_name = "cane, white"
	path = /obj/item/cane/white

/datum/gear/cane/white2
	display_name = "cane, white telescopic"
	path = /obj/item/cane/white/collapsible

/datum/gear/crutch
	display_name = "crutch"
	path = /obj/item/cane/crutch

/datum/gear/dice
	display_name = "pack of dice"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/cup
	display_name = "dice cup and dice"
	path = /obj/item/weapon/storage/dicecup/loaded

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

/datum/gear/cahwhite
	display_name = "Cards Against The Galaxy (white deck)"
	path = /obj/item/weapon/deck/cah
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."

/datum/gear/cahblack
	display_name = "Cards Against The Galaxy (black deck)"
	path = /obj/item/weapon/deck/cah/black
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."

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
	display_name = "lunchbox (selection)"
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
	display_name = "banner (selection)"
	path = /obj/item/flag

/datum/gear/banner/New()
	..()
	var/banners = list()
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
	banners["banner, Coalition of Colonies"] = /obj/item/flag/coalition
	gear_tweaks += new/datum/gear_tweak/path(banners)

/datum/gear/flag
	display_name = "flag (selection)"
	cost = 2
	path = /obj/item/flag

/datum/gear/flag/New()
	..()
	var/flags = list()
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
	flags["flag, Coalition of Colonies"] = /obj/item/flag/coalition/l
	gear_tweaks += new/datum/gear_tweak/path(flags)

/datum/gear/towel
	display_name = "towel (colourable)"
	path = /obj/item/towel
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/checkers
	display_name = "checkers game kit"
	path = /obj/item/storage/box/checkers_kit

/datum/gear/chess
	display_name = "chess game kit"
	path = /obj/item/storage/box/chess_kit

/datum/gear/battlemonsters
	display_name = "battlemonsters starter deck"
	path = /obj/item/battle_monsters/wrapped

/datum/gear/toothpaste
	display_name = "toothpaste and toothbrush (selection)"
	path = /obj/item/storage/box/toothpaste

/datum/gear/toothpaste/New()
	..()
	var/toothpaste = list()
	toothpaste["toothpaste and blue toothbrush"] = /obj/item/storage/box/toothpaste
	toothpaste["toothpaste and green toothbrush"] = /obj/item/storage/box/toothpaste/green
	toothpaste["toothpaste and red toothbrush"] = /obj/item/storage/box/toothpaste/red
	gear_tweaks += new/datum/gear_tweak/path(toothpaste)

/datum/gear/figure
	display_name = "action figure (selection)"
	description = "A \"Space Life\" brand action figure."
	path = /obj/item/toy/figure

/datum/gear/figure/New()
	..()
	var/list/figures = list()
	for(var/figure in typesof(/obj/item/toy/figure/) - /obj/item/toy/figure)
		var/obj/item/toy/figure/figure_type = figure
		figures[initial(figure_type.name)] = figure_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(figures))

/datum/gear/plushie
	display_name = "plushie (selection)"
	path = /obj/item/toy/plushie/

/datum/gear/plushie/New()
	..()
	var/list/plushies = list()
	for(var/plushie in subtypesof(/obj/item/toy/plushie/) - /obj/item/toy/plushie/therapy)
		var/obj/item/toy/plushie/plushie_type = plushie
		plushies[initial(plushie_type.name)] = plushie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(plushies))

/datum/gear/toy
	display_name = "toy (selection)"
	description = "Choose from a number of toys."
	path = /obj/item/toy/

/datum/gear/toy/New()
	..()
	var/toytype = list()
	toytype["blink toy"] = /obj/item/toy/blink
	toytype["gravitational singularity"] = /obj/item/toy/spinningtoy
	toytype["water flower"] = /obj/item/weapon/reagent_containers/spray/waterflower
	toytype["bosun's whistle"] = /obj/item/toy/bosunwhistle
	toytype["magic 8 ball"] = /obj/item/toy/eightball
	toytype["magic conch shell"] = /obj/item/toy/eightball/conch
	toytype["stick horse"] = /obj/item/toy/stickhorse
	toytype["inflatable duck"] = /obj/item/inflatable_duck
	toytype["xmas tree"] = /obj/item/toy/xmastree
	gear_tweaks += new/datum/gear_tweak/path(toytype)

/datum/gear/characterbox
	display_name = "\improper TTRPG figurine box"
	path = /obj/item/weapon/storage/box/characters

/datum/gear/bouquet
	display_name = "bouquet of flowers (selection)"
	path = /obj/item/toy/bouquet

/datum/gear/bouquet/New()
	..()
	var/bouquettype = list()
	bouquettype["real bouquet of flowers"] = /obj/item/toy/bouquet
	bouquettype["fake bouquet of flowers"] = /obj/item/toy/bouquet/fake
	gear_tweaks += new/datum/gear_tweak/path(bouquettype)
