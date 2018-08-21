/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane

/datum/gear/dice
	display_name = "pack of dice"
	path = /obj/item/weapon/storage/pill_bottle/dice

/datum/gear/dicegaming
	display_name = "pack of gaming dice"
	path = /obj/item/weapon/storage/pill_bottle/dice/gaming

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/weapon/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/weapon/deck/holder

/datum/gear/cardemon_pack
	display_name = "cardemon booster pack"
	path = /obj/item/weapon/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "spaceball booster pack"
	path = /obj/item/weapon/pack/spaceball

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_alcohol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/weapon/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/weapon/storage/toolbox/lunchbox))
		var/obj/item/weapon/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	sortTim(lunchboxes, /proc/cmp_text_asc)
	gear_tweaks += new/datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/banner
	display_name = "banner selection"
	path = /obj/item/weapon/flag

/datum/gear/banner/New()
	..()
	var/banners = list()
	banners["banner, SolGov"] = /obj/item/weapon/flag/sol
	banners["banner, Dominia"] = /obj/item/weapon/flag/dominia
	banners["banner, Elyra"] = /obj/item/weapon/flag/elyra
	banners["banner, Hegemony"] = /obj/item/weapon/flag/hegemony
	banners["banner, Jargon"] = /obj/item/weapon/flag/jargon
	banners["banner, NanoTrasen"] = /obj/item/weapon/flag/nanotrasen
	banners["banner, Eridani Fed"] = /obj/item/weapon/flag/eridani
	banners["banner, Sedantis"] = /obj/item/weapon/flag/vaurca
	banners["banner, People's Republic of Adhomai"] = /obj/item/weapon/flag/pra
	banners["banner, Democratic People's Republic of Adhomai"] = /obj/item/weapon/flag/dpra
	gear_tweaks += new/datum/gear_tweak/path(banners)

/datum/gear/flag
	display_name = "flag selection"
	cost = 2
	path = /obj/item/weapon/flag

/datum/gear/flag/New()
	..()
	var/flags = list()
	flags["flag, SolGov"] = /obj/item/weapon/flag/sol/l
	flags["flag, Dominia"] = /obj/item/weapon/flag/dominia/l
	flags["flag, Elyra"] = /obj/item/weapon/flag/elyra/l
	flags["flag, Hegemony"] = /obj/item/weapon/flag/hegemony/l
	flags["flag, Jargon"] = /obj/item/weapon/flag/jargon/l
	flags["flag, NanoTrasen"] = /obj/item/weapon/flag/nanotrasen/l
	flags["flag, Eridani Fed"] = /obj/item/weapon/flag/eridani/l
	flags["flag, Sedantis"] = /obj/item/weapon/flag/vaurca/l
	flags["flag, People's Republic of Adhomai"] = /obj/item/weapon/flag/pra/l
	flags["flag, Democratic People's Republic of Adhomai"] = /obj/item/weapon/flag/dpra/l
	gear_tweaks += new/datum/gear_tweak/path(flags)


/datum/gear/towel
	display_name = "towel"
	path = /obj/item/weapon/towel

/datum/gear/towel/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/checkers
	display_name = "checkers game kit"
	path = /obj/item/weapon/storage/box/checkers_kit

/datum/gear/chess
	display_name = "chess game kit"
	path = /obj/item/weapon/storage/box/chess_kit