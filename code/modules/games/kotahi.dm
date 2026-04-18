/obj/item/deck/kotahi
	name = "\improper KOTAHI deck"
	desc = "A deck of kotahi cards. House rules to argue over not included."
	icon_state = "deck_kotahi"
	hand_type = /obj/item/hand/kotahi

/obj/item/hand/kotahi
	deck_type = /obj/item/deck/kotahi

/obj/item/deck/kotahi/generate_deck()
	var/datum/playingcard/P
	for(var/colour in list("red","yellow","green","blue"))
		P = new()
		P.name = "[colour] zero"
		P.card_icon = "kotahi_[colour]_zero"
		P.back_icon = "kotahi_back"
		cards += P //kotahi decks have only one colour of each 0, weird huh?
		for(var/number in list("skip","reverse","draw 2","one","two","three","four","five","six","seven","eight","nine")) //two of each colour of number
			P = new()
			P.name = "[colour] [number]"
			P.card_icon = "kotahi_[colour]_[number]"
			P.back_icon = "kotahi_back"
			cards += P
			cards += P

	for(var/i = 0,i<4,i++) //4 wilds and draw 4s
		P = new()
		P.name = "wildcard"
		P.card_icon = "kotahi_wild"
		P.back_icon = "kotahi_back"
		cards += P

	for(var/i = 0,i<4,i++)
		P = new()
		P.name = "draw 4"
		P.card_icon = "kotahi_draw4"
		P.back_icon = "kotahi_back"
		cards += P
