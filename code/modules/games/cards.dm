/datum/playingcard
	var/name = "playing card"
	var/card_icon = "card_back"
	var/back_icon = "card_back"

/obj/item/deck
	w_class = 2
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()

/obj/item/deck/proc/generate_deck() //the procs that creates the cards
	return

/obj/item/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/deck/Initialize()
	. = ..()
	generate_deck()

/obj/item/deck/cards/generate_deck()
	var/datum/playingcard/P
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		var/colour
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]num"
			P.back_icon = "card_back"
			cards += P

		for(var/number in list("jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P


	for(var/i = 0,i<2,i++)
		P = new()
		P.name = "joker"
		P.card_icon = "joker"
		cards += P

/obj/item/deck/attack_hand(mob/user)
	if(cards.len && (user.l_hand == src || user.r_hand == src))
		draw_card(user, FALSE)
	else
		..()

/obj/item/deck/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/hand))
		var/obj/item/hand/H = O
		for(var/datum/playingcard/P in H.cards)
			cards += P
		qdel(O)
		to_chat(user, SPAN_NOTICE("You place your cards at the bottom of \the [src]."))
		return
	..()

/obj/item/deck/verb/draw_card()
	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	select_card(usr)

/obj/item/deck/proc/select_card(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!cards.len)
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	var/obj/item/hand/H
	if(user.l_hand && istype(user.l_hand,/obj/item/hand))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/hand))
		H = user.r_hand
	else
		H = new /obj/item/hand(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user)
		return

	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/discarding = input(user, "Which card do you wish to draw?", "Deck of Cards") as null|anything in to_discard
	if(!discarding || !to_discard[discarding] || !user || !src)
		return

	var/datum/playingcard/P = to_discard[discarding]
	H.cards += P
	cards -= P
	H.update_icon()
	user.visible_message("<b>\The [user]</b> draws a card.", SPAN_NOTICE("You draw the [P.name]."))

/obj/item/deck/verb/deal_card()
	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr))
		return

	if(!cards.len)
		to_chat(usr, SPAN_WARNING("There are no cards in the deck."))
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player

	var/mob/living/M = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || !src || !M) return

	deal_at(usr, M)

/obj/item/deck/proc/deal_at(mob/user, mob/target)
	var/obj/item/hand/H = new(get_step(user, user.dir))

	H.cards += cards[1]
	cards -= cards[1]
	H.concealed = 1
	H.update_icon()
	if(user==target)
		user.visible_message("<b>\The [user]</b> deals a card to \himself.")
	else
		user.visible_message("<b>\The [user]</b> deals a card to \the [target].")
	H.throw_at(get_step(target,target.dir),10,1,H)

/obj/item/hand/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/hand))
		var/obj/item/hand/H = O
		user.visible_message("<b>\The [user]</b> adds \the [H] to their hand.", SPAN_NOTICE("You add \the [H] to your hand."))
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		qdel(src)
		H.update_icon()
		return
	..()

/obj/item/deck/attack_self(var/mob/user as mob)

	var/list/newcards = list()
	while(cards.len)
		var/datum/playingcard/P = pick(cards)
		newcards += P
		cards -= P
	cards = newcards
	playsound(src.loc, 'sound/items/cardshuffle.ogg', 100, 1, -4)
	user.visible_message("<b>\The [user]</b> shuffles [src].")

/obj/item/deck/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	if(!ishuman(over) || !(over in viewers(3))) return

	if(!cards.len)
		to_chat(usr, SPAN_WARNING("There are no cards in the deck."))
		return

	deal_at(usr, over)

/obj/item/pack/
	name = "card pack"
	desc = "For those with disposible income."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "card_pack"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = 1
	var/list/cards = list()


/obj/item/pack/attack_self(var/mob/user as mob)
	user.visible_message("<b>\The [user]</b> rips open \the [src]!")
	var/obj/item/hand/H = new()

	H.cards += cards
	cards.Cut();
	user.drop_from_inventory(src,get_turf(src))
	H.update_icon()
	user.put_in_active_hand(H)
	qdel(src)

/obj/item/hand
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = null
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = 1

	var/concealed = 0
	var/list/cards = list()

/obj/item/hand/MouseEntered(location, control, params)
	. = ..()
	if(cards.len == 1 && (!concealed || Adjacent(usr)))
		var/datum/playingcard/P = cards[1]
		openToolTip(usr, src, params, P.name)

/obj/item/hand/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/hand/verb/discard()
	set category = "Object"
	set name = "Discard"
	set desc = "Place a card from your hand in front of you."

	draw_card(usr)

/obj/item/hand/proc/draw_card(var/mob/user, var/deploy_in_front = TRUE)
	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/input_text = "Which card do you wish to [deploy_in_front ? "put down" : "draw"]?"
	var/discarding = input(user, input_text, "Hand of Cards") as null|anything in to_discard
	if(!discarding || !to_discard[discarding] || !user || !src)
		return

	var/datum/playingcard/card = to_discard[discarding]
	qdel(to_discard)

	var/obj/item/hand/H = new /obj/item/hand(src.loc)
	H.cards += card
	cards -= card
	H.concealed = FALSE
	H.update_icon()
	src.update_icon()
	if(deploy_in_front)
		user.visible_message("<b>\The [user]</b> plays \the [discarding].")
		H.forceMove(get_step(usr, usr.dir))
	else
		to_chat(user, SPAN_NOTICE("You draw \the [discarding]."))
		user.put_in_hands(H)

	if(!cards.len)
		qdel(src)

/obj/item/hand/attack_hand(mob/user)
	if(cards.len > 1 && (user.l_hand == src || user.r_hand == src))
		draw_card(user, FALSE)
	else
		..()

/obj/item/hand/attack_self(var/mob/user as mob)
	concealed = !concealed
	update_icon()
	user.visible_message("\The [user] [concealed ? "conceals" : "reveals"] their hand.")

/obj/item/hand/examine(mob/user)
	..(user)
	if((!concealed || src.loc == user) && cards.len)
		to_chat(user, "It contains: ")
		for(var/datum/playingcard/P in cards)
			to_chat(user, "The [P.name].")

/obj/item/hand/update_icon(var/direction = 0)

	if(!cards.len)
		qdel(src)
		return
	else if(cards.len > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else
		name = "playing card"
		desc = "A playing card."

	cut_overlays()

	if(cards.len == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		add_overlay(I)
		return

	var/offset = Floor(20/cards.len)

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Translate( 0,  0)
			if(SOUTH)
				M.Translate( 0,  4)
			if(WEST)
				M.Turn(90)
				M.Translate( 3,  0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2,  0)
	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		//I.pixel_x = origin+(offset*i)
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.transform = M
		add_overlay(I)
		i++

/obj/item/hand/dropped(mob/user as mob)
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)
	else
		update_icon()

/obj/item/hand/pickup(mob/user as mob)
	..()
	src.update_icon()