/datum/gear/cane
	display_name = "cane"

/datum/gear/dice
	display_name = "pack of dice"

/datum/gear/dicegaming
	display_name = "pack of gaming dice"

/datum/gear/cards
	display_name = "deck of cards"

/datum/gear/tarot
	display_name = "deck of tarot cards"

/datum/gear/holder
	display_name = "card holder"

/datum/gear/cardemon_pack
	display_name = "cardemon booster pack"

/datum/gear/spaceball_pack
	display_name = "spaceball booster pack"

/datum/gear/flask
	display_name = "flask"

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	sortTim(lunchboxes, /proc/cmp_text_asc)
	gear_tweaks += new/datum/gear_tweak/path(lunchboxes)
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/banner
	display_name = "banner selection"

/datum/gear/banner/New()
	..()
	var/banners = list()
	gear_tweaks += new/datum/gear_tweak/path(banners)

/datum/gear/flag
	display_name = "flag selection"
	cost = 2

/datum/gear/flag/New()
	..()
	var/flags = list()
	gear_tweaks += new/datum/gear_tweak/path(flags)

