/datum/gear/toy
	display_name = "holo board game"
	path = /obj/item/board
	sort_category = "Toys"

/datum/gear/toy/dice
	display_name = "pack of dice"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/toy/dicegaming
	display_name = "pack of gaming dice"
	path = /obj/item/storage/pill_bottle/dice/gaming

/datum/gear/toy/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/toy/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/datum/gear/toy/holder
	display_name = "card holder"
	path = /obj/item/storage/card

/datum/gear/toy/cardemon_pack
	display_name = "cardemon booster pack"
	path = /obj/item/pack/cardemon

/datum/gear/toy/spaceball_pack
	display_name = "spaceball booster pack"
	path = /obj/item/pack/spaceball

/datum/gear/toy/gamehelm
	display_name = "handheld video game console"
	description = "A selection of various Game-Helm consoles."
	cost = 1
	path = /obj/item/gamehelm

/datum/gear/toy/gamehelm/New()
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

/datum/gear/toy/battlemonsters
	display_name = "battlemonsters starter deck"
	path = /obj/item/battle_monsters/wrapped

/datum/gear/toy/squidplushie
	display_name = "colourable squid plushie"
	path = /obj/item/toy/plushie/squidcolour
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/toy/plushie
	display_name = "plushie selection"
	description = "A selection of plush toys."
	path = /obj/item/toy/plushie

/datum/gear/toy/plushie/New()
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

/datum/gear/toy/mecha
	display_name = "toy mecha selection"
	description = "A selection of mecha toys."
	path = /obj/item/toy/mech

/datum/gear/toy/mecha/New()
	..()
	var/list/mechas = list()
	for(var/obj/item/toy/mech/mecha as anything in subtypesof(/obj/item/toy/mech))
		mechas[initial(mecha.name)] = mecha
	gear_tweaks += new /datum/gear_tweak/path(mechas)
