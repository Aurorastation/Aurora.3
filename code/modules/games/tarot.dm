/* this is a playing card deck based off of the Rider-Waite Tarot Deck.
*/

/obj/item/deck/tarot
	name = "deck of tarot cards"
	desc = "For all your occult needs!"
	icon_state = "deck_tarot"
	hand_type = /obj/item/hand/tarot

/obj/item/hand/tarot
	deck_type = /obj/item/deck/tarot

/obj/item/deck/tarot/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Fool","Magician","High Priestess","Empress","Emperor","Hierophant","Lovers","Chariot","Strength","Hermit","Wheel of Fortune","Justice","Hanged Man","Death","Temperance","Devil","Tower","Star","Moon","Sun","Judgement","World"))
		P = new()
		P.name = "[name]"
		P.card_icon = "tarot_major"
		P.back_icon = "card_back_tarot"
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))
		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","page","knight","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "tarot_[suit]"
			P.back_icon = "card_back_tarot"
			cards += P

/obj/item/deck/tarot/AltClick(var/mob/user as mob)
	var/list/newcards = list()
	while(cards.len)
		var/datum/playingcard/P = pick(cards)
		P.name = replacetext(P.name," reversed","")
		if(prob(50))
			P.name += " reversed"
		newcards += P
		cards -= P
	cards = newcards
	playsound(src.loc, 'sound/items/cards/cardshuffle.ogg', 100, 1, -4)
	user.visible_message("\The [user] shuffles \the [src].")


/obj/item/deck/tarot/adhomai
	name = "adhomian divination cards deck"
	desc = "An adhomian deck of divination cards, used to read the one's fortune or play games."
	icon_state = "deck_adhomai"
	hand_type = /obj/item/hand/tarot/adhomai

/obj/item/hand/tarot/adhomai
	deck_type = /obj/item/deck/tarot/adhomai

/obj/item/deck/tarot/adhomai/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("D'as'ral Massacre","Mystic","Suns' Sister","Queen","King","Father of the Parivara","S'rendal'Matir","Tank","Enforcer","Kraszarrumalkarii","Rredouane's Dice","Great Revolution","Assassin","Assassination","Dymtris Line",
	"Rrak'narrr","Steeple","Messa","Raskara","S'rendarr","Kazarrhaldiye","Adhomai"))
		P = new()
		P.name = "[name]"
		P.card_icon = "adhomai_major"
		P.back_icon = "card_back_adhomai"
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))


		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","serf","soldier","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "adhomai_[suit]"
			P.back_icon = "card_back_adhomai"
			cards += P

/obj/item/deck/tarot/nralakk
	name = "qwei'paqui homeworld deck"
	desc = "A Skrellian deck of tarot cards depicting the main constellations of Nralakk."
	icon_state = "deck_nralakk"

/obj/item/deck/tarot/nralakk/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Island","Hatching Egg","Star Chanter","Jiu'x'klua","Stormcloud","Gnarled Tree","Poet","Bloated Toad","Void","Qu'Poxii","Fisher","Mountain","Sraso","Nioh"))
		P = new()
		P.name = "[name]"
		var/suit = "nralakk"
		switch(name)
			if("Island")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Loneliness. Introspection. Earth. Rising above or Sinking beneath. Reality."
			if("Hatching Egg")
				name = "egg"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with New beginnings. A fresh start. Youth. Life. Excitement. Ignorance. Foolishness. Joy."
			if("Star Chanter")
				name = "chanter"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Wisdom. Spirituality. Connection with the stars. Connection to history. Aloofness. A rigid path. Air."
			if("Jiu'x'klua")
				name = "klua"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Art. Creation. Loss. Sadness. Longing. Communication. The imaginary."
			if("Stormcloud")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Conflict. Shock. Surprises. Tension. Endurance. Strength. Force. Fire."
			if("Gnarled Tree")
				name = "gnarledtree"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Age. Wisdom. Sickness. Frailty, or, in certain orientations, toughness. Rigidity. Tradition. Plantlife. Balance."
			if("Poet")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Communication. Progress. Science. Advancement. Longing. Art. Expression. Loneliness. Contentment. Dreams."
			if("Bloated Toad")
				name = "bloatedtoad"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Greed. Arrogance. Wealth. Success. Smugness. Laziness. Accomplishment. Adulthood."
			if("Void")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Death. Endings. Mystery. The unknown. Fear. Danger. Creation."
			if("Qu'Poxii")
				name = "qupoxii"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Love. Friendship. Company. Opposites. Teamwork. Happiness. The material. Safety. Progress. Support."
			if("Fisher")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with  Hard work. Stagnation. Embarrassment. Water. Patience. A long, but productive wait."
			if("Mountain")
				suit = "aweiji"
				P.desc = "One of the local constellations on the planet Aweiji. It is associated with Self-analysis. Feelings of accomplishment. Clearer view."
			if("Sraso")
				suit = "aweiji"
				P.desc = "One of the local constellations on the planet Aweiji. It is associated with Sustainability. Growth. Safety."
			if("Nioh")
				suit = "aweiji"
				P.desc = "One of the local constellations on the planet Aweiji. It is associated with Trust. Reliance. Perseverance. Survival."
		P.card_icon = "[suit]_[lowertext(name)]"
		P.back_icon = "card_off_[suit]"
		cards += P

/obj/item/deck/tarot/nonnralakk
	name = "qwei'paqui colonist deck"
	desc = "A Skrellian deck of tarot cards depicting the local constellations of planets outside Nralakk."
	icon_state = "deck_nonnralakk"
	hand_type = /obj/item/hand/tarot/nonnralakk

/obj/item/hand/tarot/nonnralakk
	deck_type = /obj/item/deck/tarot/nonnralakk

/obj/item/deck/tarot/nonnralakk/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Shell","Wave","Trident","Palm Tree","Pulque","Eel","Iqi Star","Sky-Grazer","Dyn"))
		P = new()
		P.name = "[name]"
		var/suit = "slz"
		switch(name)
			if("Shell")
				P.desc = "One of the local constellations revered by the Skrell of Mendell City's Starlight Zone. It is associated with Home, Family (Severson). Refuge, Safety (Lekan)."
			if("Wave")
				P.desc = "One of the local constellations revered by the Skrell of Mendell City's Starlight Zone. It is associated with Pilgrimage, Journey (Severson). Escape, Freedom (Lekan)."
			if("Trident")
				P.desc = "One of the local constellations revered by the Skrell of Mendell City's Starlight Zone. It is associated with Protection, Security (Severson). Oppression, Subjugation (Lekan)."
			if("Palm Tree")
				name = "palm"
				suit = "mict"
				P.desc = "One of the local constellations on the planet Mictlan. It is associated with Tranquility. Agitation. Anxiety. Peace."
			if("Pulque")
				suit = "mict"
				P.desc = "One of the local constellations on the planet Mictlan. It is associated with Togetherness. Comraderie. Overindulgence. Celebration."
			if("Eel")
				suit = "mict"
				P.desc = "One of the local constellations on the planet Mictlan. It is associated with Turncoat. The unanticipated. Intrigue. Forthcoming."
			if("Iqi Star")
				name = "iqi"
				suit = "newgib"
				P.desc = "One of the local constellations on the planet New Gibson. It is associated with Self-Advancement. Social standing. Success."
			if("Sky-Grazer")
				name = "skygrazer"
				suit = "newgib"
				P.desc = "One of the local constellations on the planet New Gibson. It is associated with Expressiveness. Freedom. Adventure."
			if("Dyn")
				suit = "newgib"
				P.desc = "One of the local constellations on the planet New Gibson. It is associated with Survival. Generosity. Community."
		P.card_icon = "[suit]_[lowertext(name)]"
		P.back_icon = "card_off_[suit]"
		cards += P

/obj/item/deck/tarot/lyodii
	name = "lyodii fatesayer cards deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod."
	desc_extended = "These 'cards' are actually rectangular pieces of bone, engraved with different religious imagery. They are then painted with soot or blood-ink. Usually made by tribal shamans in \
	agonizingly difficult work, these are hand-crafted by each tribe - thus some imagery can deviate from one another. A deck consists of 36 pieces, divided as follows: Spirits, Beasts, Winds and Paths \
	each having eight cards in their stack and Bones, with four cards. Traditionally a Bone card is drawn, then one each of the rest. The Bone cards put the other four cards into perspective so one's fate \
	can be determined. More modern iterations of these Fatesayer decks are also made by the few permanent settlements in the Lyod, to sell them off. They are not using real bone and the imagery is usually more \
	refined and detailed, since they are machine-made."
	icon_state = "deck_lyodii"
	deck_type = /obj/item/hand/tarot/lyodii

/obj/item/deck/tarot/lyodii/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("The Chieftain","The Shaman","The Crown of Ice", "The Dreaming Girl", "The Flamewalker", "The Tall Stranger","The Mother","The Hollowed Man","The Tenelote","The Arctic Fox","The Bisumoi","The Prejoroub",
	"The Yastr","The Ptarmigan","The Reindeer","The Snow Hare","The North Wind","The South Wind","The East Wind","The West Wind","The Windless Day","The Black Gale","The Whisper Breeze","The Stormcry","The Frozen Footprint",
	"The Shared Fire","The Broken Edict","The Silent Hunt","The Lost Tribe","The Marked Bone","The Buried Blade","The Icebound Oath","The Bone of Birth","The Bone of Death","The Bone of Choice","The Goddess"))
	P = new()
	P.name = "[name]"
	var/suit = "lyodii"
	switch(name)
		if("The Chieftain")
