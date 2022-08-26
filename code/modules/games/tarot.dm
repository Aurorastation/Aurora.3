/* this is a playing card deck based off of the Rider-Waite Tarot Deck.
*/

/obj/item/deck/tarot
	name = "deck of tarot cards"
	desc = "For all your occult needs!"
	icon_state = "deck_tarot"

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

/obj/item/deck/tarot/attack_self(var/mob/user as mob)
	var/list/newcards = list()
	while(cards.len)
		var/datum/playingcard/P = pick(cards)
		P.name = replacetext(P.name," reversed","")
		if(prob(50))
			P.name += " reversed"
		newcards += P
		cards -= P
	cards = newcards
	playsound(src.loc, 'sound/items/cardshuffle.ogg', 100, 1, -4)
	user.visible_message("\The [user] shuffles [src].")


/obj/item/deck/tarot/adhomai
	name = "adhomian divination cards deck"
	desc = "An adhomian deck of divination cards, used to read the one's fortune or play games."
	icon_state = "deck_adhomai"

/obj/item/deck/tarot/adhomai/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("D'as'ral Massacre","Mystic","Suns' Sister","Queen","King","Father of the Parivara","S'rendal'Matir","Tank","Royal Grenadier","Kraszarrumalkarii","Hand of Fate","Great Revolution","Assassin","Assassination","Dymtris Line",
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

/obj/item/deck/tarot/jargon
	name = "qwei'paqui homeworld deck"
	desc = "A Skrellian deck of tarot cards depicting the main constellations of Nralakk."
	icon_state = "deck_nralakk"

/obj/item/deck/tarot/jargon/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Island","Hatching Egg","Star Chanter","Jiu'x'klua","Stormcloud","Gnarled Tree","Poet","Bloated Toad","Void","Qu'Poxii","Fisher","Mountain","Sraso","Nioh"))
		P = new()
		P.name = "[name]"
		var/suit = "jargon"
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

/obj/item/deck/tarot/nonjargon
	name = "qwei'paqui colonist deck"
	desc = "A Skrellian deck of tarot cards depicting the local constellations of planets outside Nralakk."
	icon_state = "deck_nonnralakk"

/obj/item/deck/tarot/nonjargon/generate_deck()
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

