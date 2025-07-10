/datum/gear/toy
	display_name = "pack of dice"
	path = /obj/item/storage/pill_bottle/dice
	sort_category = "Toys"

/datum/gear/toy/dicegaming
	display_name = "pack of gaming dice"
	path = /obj/item/storage/pill_bottle/dice/gaming

/datum/gear/toy/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/toy/kotahi
	display_name = "KOTAHI cards"
	path = /obj/item/deck/kotahi

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
	plushies["plushie, herring gull"] = /obj/item/toy/plushie/herring_gull
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
	plushies["plushie, jeweler cockatoo"] = /obj/item/toy/plushie/cockatoo
	plushies["plushie, Norinori"] = /obj/item/toy/plushie/norinori
	plushies["plushie, space carp"] = /obj/item/toy/plushie/carp
	plushies["plushie, Domadice"] = /obj/item/toy/plushie/domadice
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

/datum/gear/toy/stressball
	display_name = "stress ball"
	description = "A small, squishy stress ball. This one has a squeaker inside."
	path = /obj/item/toy/stressball
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/toy/stickersheet
	display_name = "sticker sheet selection"
	description = "A selection of various sticker sheets."
	cost = 1
	path = /obj/item/storage/stickersheet

/datum/gear/toy/stickersheet/New()
	..()
	var/list/stickersheet = list()
	stickersheet["Generic sticker sheet"] = /obj/item/storage/stickersheet/generic
	stickersheet["Heart sticker sheet"] = /obj/item/storage/stickersheet/hearts
	stickersheet["Religious sticker sheet"] = /obj/item/storage/stickersheet/religion
	stickersheet["Domadice sticker sheet"] = /obj/item/storage/stickersheet/domadice
	stickersheet["Republic of Biesel sticker sheet"] = /obj/item/storage/stickersheet/biesel
	stickersheet["Republic of Elyra sticker sheet"] = /obj/item/storage/stickersheet/elyra
	stickersheet["Solarian Alliance sticker sheet"] = /obj/item/storage/stickersheet/sol
	stickersheet["Coalition of Colonies sticker sheet"] = /obj/item/storage/stickersheet/coc
	stickersheet["Empire of Dominia sticker sheet"] = /obj/item/storage/stickersheet/dominia
	stickersheet["Nralakk Federation sticker sheet"] = /obj/item/storage/stickersheet/nralakk
	stickersheet["Tajaran Governments sticker sheet"] = /obj/item/storage/stickersheet/adhomai
	stickersheet["Hieroaetheria sticker sheet"] = /obj/item/storage/stickersheet/hieroaetheria
	stickersheet["Uueoa-Esa sticker sheet"] = /obj/item/storage/stickersheet/hegemony
	stickersheet["Anti-Establishment sticker sheet"] = /obj/item/storage/stickersheet/resistance
	gear_tweaks += new /datum/gear_tweak/path(stickersheet)

/datum/gear/toy/stickersheet_custom
	display_name = "sticker sheet (custom)"
	description = "A sticker sheet that can hold a variety of stickers."
	cost = 1
	path = /obj/item/storage/stickersheet

/datum/gear/toy/stickersheet_custom/New()
	..()
	var/list/stickersheet = list()

	for(var/sticker as anything in subtypesof(/obj/item/sticker))
		var/obj/O = sticker
		stickersheet[initial(O.name)] = sticker
	gear_tweaks += new /datum/gear_tweak/contents/stickersheet(stickersheet,stickersheet,stickersheet,stickersheet)

// Same as contents/tweak_item except it adds 3 of each item into the stickersheet (4 * 3 = 12)
/datum/gear_tweak/contents/stickersheet/tweak_item(var/obj/item/storage/stickersheet/sheet, var/list/metadata, var/mob/living/carbon/human/H)
	if(length(metadata) != length(valid_contents))
		return
	for(var/i = 1 to length(valid_contents))
		var/path
		var/list/contents = valid_contents[i]
		if(metadata[i] == "Random")
			path = pick(contents)
			path = contents[path]
		else if(metadata[i] == "None")
			continue
		else
			path = 	contents[metadata[i]]
		if(path) // repeat 3 times for each item
			for(i = 0, i < 3, ++i)
				new path(sheet)

/datum/gear/toy/football
	display_name = "football"
	description = "A classic, black and white football for kicking. Also known as a soccerball on Biesel and some parts of Earth for some reason."
	cost = 1
	allowed_roles = list("Off-Duty Crew Member", "Passenger")
	path = /obj/item/toy/football
