/datum/playingcard
	var/name = "playing card"
	var/desc = null
	var/card_icon = "card_back"
	var/back_icon = "card_back"

/obj/item/deck
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/item/playing_cards.dmi'
	var/list/cards = list()
	var/shuffle_sound = 'sound/items/cards/cardshuffle.ogg'
	var/hand_type

/obj/item/deck/attack(mob/living/target_mob, mob/living/user, target_zone)
	if (user.a_intent == I_HURT)
		. = ..()
	if(length(cards))
		if(target_mob == user)
			attack_self(user)
		else
			deal_card(user, target_mob)

/obj/item/deck/attack_self(mob/user, modifiers)
	if(length(cards))
		deal_card(user, user)
	. = ..()

/obj/item/deck/proc/generate_deck() //the procs that creates the cards
	return

/obj/item/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	hand_type = /obj/item/hand/cards

/obj/item/deck/cards/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "CTRL-click to draw/deal."
	. += "ALT-click to shuffle."

/obj/item/deck/Initialize()
	. = ..()
	generate_deck()

/obj/item/deck/cards/generate_deck()
	var/datum/playingcard/P
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten", "jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[number]_[suit]"
			P.back_icon = "card_back"
			cards += P

	for(var/i = 0,i<2,i++)
		P = new()
		P.name = "joker"
		P.card_icon = "joker"
		cards += P

/obj/item/deck/attack_hand(mob/user)
	if(length(cards) && (user.l_hand == src || user.r_hand == src))
		deal_card(user, user)
	else
		..()

/obj/item/deck/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/hand))
		var/obj/item/hand/H = attacking_item
		for(var/datum/playingcard/P in H.cards)
			cards += P
		qdel(attacking_item)
		return
	..()

/obj/item/deck/verb/drawcard()
	set category = "Object.Cards"
	set name = "Deck - Draw"
	set desc = "Draw a card from the deck."
	set src in view(1)

	draw_card(usr)

/obj/item/deck/proc/draw_card(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	var/obj/item/hand/H
	if(user.l_hand && istype(user.l_hand, /obj/item/hand))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand, /obj/item/hand))
		H = user.r_hand
	else
		H = new hand_type(get_turf(src))
		H.concealed = TRUE
		if(!user.put_in_hands(H))
			return

	if(!H || !user)
		return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.update_icon()
	balloon_alert_to_viewers("draws a card")
	if(!length(cards))
		qdel(src)

/obj/item/deck/verb/pickcard()
	set category = "Object.Cards"
	set name = "Deck - Pick"
	set desc = "Pick a card from the deck."
	set src in view(1)

	pick_card(usr)

/obj/item/deck/proc/pick_card(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	var/obj/item/hand/H
	if(user.l_hand && istype(user.l_hand,/obj/item/hand))
		H = user.l_hand
	else if(user.r_hand && istype(user.r_hand,/obj/item/hand))
		H = user.r_hand
	else
		H = new hand_type(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user)
		return

	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/discarding = tgui_input_list(user, "Which card do you wish to pick?", "Deck of Cards", to_discard)
	if(!discarding || !to_discard[discarding] || !user || !src)
		return

	var/datum/playingcard/P = to_discard[discarding]
	H.cards += P
	cards -= P
	H.update_icon()
	balloon_alert_to_viewers("picks out a card")
	if(!length(cards))
		qdel(src)

/obj/item/deck/verb/dealcard()
	set category = "Object.Cards"
	set name = "Deck - Deal"
	set desc = "Deal a card from the deck."
	set src in view(1)

	deal_card(usr, FALSE)

/obj/item/deck/proc/deal_card(mob/user, mob/living/target)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return

	if(!target)
		var/list/players = list()
		for(var/mob/living/player in viewers(3))
			if(!player.stat)
				players += player

		target = tgui_input_list(usr, "Who do you wish to deal a card?", "Deal", players)

	if(target == user)
		draw_card(user)
		return

	if((istype(get_step(target,target.dir), /obj/machinery/door/window) || istype(get_step(target,target.dir), /obj/structure/window)) && target.density)
		return // should stop you from dragging through windows

	if(!length(cards))
		to_chat(user, SPAN_WARNING("There are no cards in the deck."))
		return

	var/obj/item/hand/H = new hand_type(user.loc)

	H.randpixel = 6
	H.randpixel_xy()

	H.cards += cards[1]
	cards -= cards[1]
	H.concealed = TRUE
	H.update_icon()
	user.do_attack_animation(src, null)
	balloon_alert_to_viewers("deals a card")
	H.throw_at(get_step(target,target.dir), 10, 1, user, FALSE)
	if(!length(cards))
		qdel(src)

/obj/item/hand/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/hand))
		var/obj/item/hand/H = attacking_item
		user.visible_message("<b>\The [user]</b> adds \the [H] to their hand.", SPAN_NOTICE("You add \the [H] to your hand."))
		for(var/datum/playingcard/P in cards)
			H.cards += P
		H.concealed = src.concealed
		qdel(src)
		H.update_icon()
		return
	if(istype(attacking_item, /obj/item/deck))
		var/obj/item/deck/D = attacking_item
		for(var/datum/playingcard/P in cards)
			D.cards += P
		qdel(src)
		return
	..()

/obj/item/deck/afterattack(obj/target, mob/user, proximity)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(target == user)
		return
	if (H in range(user, 3))
		deal_card(user, H)

/obj/item/deck/CtrlClick(var/mob/user)
	draw_card(user)

/obj/item/deck/AltClick(var/mob/user)
	. = ..()
	if(use_check_and_message(user))
		return
	var/list/newcards = list()
	while(length(cards))
		var/datum/playingcard/P = pick(cards)
		newcards += P
		cards -= P
	cards = newcards
	playsound(src.loc, shuffle_sound, 100, 1, -4)
	balloon_alert_to_viewers("shuffling")

/obj/item/pack
	name = "card pack"
	desc = "For those with disposible income."
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = "card_pack"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = WEIGHT_CLASS_TINY
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
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = null
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = WEIGHT_CLASS_TINY
	var/deck_type

	var/concealed = TRUE
	var/list/cards = list()

/obj/item/hand/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if((!concealed || src.loc == user) && length(cards))
		if(length(cards) > 1)
			. += "It contains: "
		for(var/datum/playingcard/P in cards)
			. += "The [P.name]. [P.desc ? "<i>[P.desc]</i>" : ""]"

/obj/item/hand/cards
	deck_type = /obj/item/deck/cards

/obj/item/hand/MouseEntered(location, control, params)
	. = ..()
	if(length(cards) == 1 && !concealed)
		var/datum/playingcard/P = cards[1]
		openToolTip(usr, src, params, P.name)

/obj/item/hand/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/hand/verb/pickcard()
	set category = "Object.Cards"
	set name = "Hand - Pick"
	set desc = "Pick a card from your hand in front of you."
	set src in usr

	pick_card(usr)

/obj/item/hand/proc/pick_card(var/mob/user, var/deploy_in_front = TRUE)
	var/list/to_discard = list()
	for(var/datum/playingcard/P in cards)
		to_discard[P.name] = P
	var/input_text = "Which card do you wish to [deploy_in_front ? "put down" : "draw"]?"
	var/discarding = tgui_input_list(user, input_text, "Hand of Cards", to_discard)
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
	playsound(src, 'sound/items/cards/cardflip.ogg', 50, TRUE)
	balloon_alert_to_viewers("picks out a card")
	if(deploy_in_front)
		H.forceMove(get_step(usr, usr.dir))
	else
		user.put_in_hands(H)

	if(!length(cards))
		qdel(src)

/obj/item/hand/attack_hand(mob/user)
	if(length(cards) > 1 && (user.l_hand == src || user.r_hand == src))
		pick_card(user, FALSE)
	else
		..()

/obj/item/hand/attack_self(var/mob/user as mob)
	concealed(user)

/obj/item/hand/CtrlClick(var/mob/user as mob)
	pick_card(user)

/obj/item/hand/AltClick(mob/user)
	concealed(user)

/obj/item/hand/proc/concealed(var/mob/user as mob)
	concealed = !concealed
	if(locate(/obj/structure/table) in loc)
		update_icon(user.dir)
	else
		update_icon()
	playsound(src, 'sound/items/cards/cardflip.ogg', 50, TRUE)
	balloon_alert_to_viewers("[concealed ? "conceals" : "reveals"] their hand.")

/obj/item/hand/update_icon(var/direction = 0)
	if(randpixel)
		randpixel = 0
		randpixel_xy(0)

	if(!length(cards))
		qdel(src)
		return
	else if(length(cards) > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else
		name = "playing card"
		desc = "A playing card."

	ClearOverlays()

	if(length(cards) == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		AddOverlays(I)
		return

	var/offset = FLOOR(20/length(cards), 1)

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Turn(0)
			if(SOUTH)
				M.Turn(180)
			if(WEST)
				M.Turn(270)
			if(EAST)
				M.Turn(90)
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
		AddOverlays(I)
		i++

/obj/item/hand/dropped(mob/user)
	..()
	if(locate(/obj/structure/table) in get_step(user, user.dir))
		update_icon(user.dir)
	else
		update_icon(0)

/obj/item/hand/pickup(mob/user as mob)
	..()
	update_icon()

/obj/item/hand/verb/deck_card()
	set category = "Object.Cards"
	set name = "Turn Hand Into Deck"
	set desc = "Turn this hand of cards into a deck."
	set src in usr

	create_deck(usr)

/obj/item/hand/proc/create_deck(var/mob/user)
	if(use_check_and_message(user, USE_DISALLOW_SILICONS) || !Adjacent(user))
		return
	if(!iscarbon(user))
		to_chat(user, SPAN_WARNING("Your simple form can't operate \the [src]."))
	if(!length(cards))
		to_chat(usr, SPAN_WARNING("There are no cards in \the [src]."))
		return
	if(!deck_type)
		to_chat(usr, SPAN_WARNING("You can't turn \the [src] into a deck."))
		return

	var/obj/item/deck/D = new deck_type(new(user.loc))

	if(!D || !user)
		return

	D.cards = cards
	user.visible_message(SPAN_NOTICE("<b>\The [user]</b> turns his hand into a deck."), SPAN_NOTICE("You turn your hand into a deck."))
	qdel(src)
	user.put_in_hands(D)

/// Lyodii *not* tarot deck.
/obj/item/deck/lyodii
	name = "lyodii fatesayer deck"
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = "lyodii_deck"
	desc = "A traditionally-made deck of Fatesayer cards, used by the people of the Lyod to tell one's fate."
	desc_extended = "These 'cards' are actually rectangular pieces of bone, engraved with different religious imagery. They are then painted with soot or blood-ink. Usually made by tribal shamans in \
	agonizingly difficult work, these are hand-crafted by each tribe - thus some imagery can deviate from one another. A deck consists of 36 pieces, divided as follows: Spirits, Beasts, Winds and Paths \
	each having eight cards in their stack and Bones, with four cards. Traditionally a Bone card is drawn, then one each of the rest. The Bone cards put the other four cards into perspective so one's fate \
	can be determined. More modern iterations of these Fatesayer decks are also made by the few permanent settlements in the Lyod, to sell them off. They are not using real bone and the imagery is usually more \
	refined and detailed, since they are machine-made."
	drop_sound = 'sound/items/drop/bone_drop.ogg'
	pickup_sound = 'sound/items/drop/bone_drop.ogg'
	shuffle_sound = 'sound/items/cards/bone_shuffle.ogg'
	hand_type = /obj/item/hand/lyodii

/obj/item/hand/lyodii
	deck_type = /obj/item/deck/lyodii
	desc = "A deck of lyodii Fatesayer cards."
	drop_sound = 'sound/items/drop/bone_drop.ogg'
	pickup_sound = 'sound/items/drop/bone_drop.ogg'

/obj/item/deck/lyodii/spirits
	name = "lyodii fatesayer spirits deck"
	desc = "A traditionally-made deck of Fatesayer cards, used by the people of the Lyod. This stack contains the Spirits cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/lyodii/spirits/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Chieftain","Shaman","Crown of Ice","Dreaming Girl","Flamewalker","Tall Stranger","Mother","Hollowed Man"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("Chieftain")
				P.desc = "A tall figure stands before a wind-beaten tent, draped in heavy furs. One hand holds a carved antler staff, the other is raised toward a gathering of smaller shadowy figures. The chieftain's eyes are closed in \
				burdened contemplation. Behind him, the sun is barely visible over the horizon. It is associated with: leadership, burden, guidance."
			if("Shaman")
				P.desc = "A kneeling figure surrounded by animal bones and burning herbs. Her face is painted with blood and soot. Behind her, a spectral shape looms but no details can be made out. It is associated with: wisdom, communion \
				with spirits, madness."
			if("Crown of Ice")
				P.desc = "A throne of cracked glacier-ice, on it sitting a crown of deep blue ice. There are two sockets embedded in the crown, one with a sapphire, one empty. It is associated with: harsh judge, death's herald."
			if("Dreaming Girl")
				P.desc = "A young girl sleeping in a snowdrift, untouched by cold. Above her, the night sky swirls with auroras forming vague shapes. Her expression is peaceful, but a tear of blood escapes one eye. It is associated with: \
				prophecy, confusion, hidden truths."
			if("Flamewalker")
				P.desc = "A cloaked figure walking across an icefield. He's burning. Fire doesn’t consume him—it emerges from his footprints. He carries a bundle of books and bones wrapped in red cloth. It is associated with: \
				change-bringing, exile, innovation."
			if("Tall Stranger")
				P.desc = "A faceless, well-built and tall standing figure in fine red-gilded robes stands at atop a snowdrift. He holds a sword in one hand, the other's clenched to a fist. No footprints are left where he stands. \
				It is associated with: deception, fate disguised, dishonesty."
			if("Mother")
				P.desc = "A woman cradling a baby in one arm, a ceremonial blade in the other. Her expression is conflicted. Behind her, two paths diverge—one leads to a firelit camp, the other into a storm. It is associated with: \
				choices, nurture vs. law, duality."
			if("Hollowed Man")
				P.desc = "A man torso unclothed, kneels in the snow. A hole where his heart should be reveals a swirling void inside. Spirits drift around him. It is associated with: sacrifice, emptiness, spiritual rebirth."
		P.card_icon = "spirits"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/lyodii/paths
	name = "lyodii fatesayer paths deck"
	desc = "A traditionally-made deck of Fatesayer cards, used by the people of the Lyod. This stack contains the Paths cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/lyodii/paths/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Frozen Footprint","Shared Fire","Broken Edict","Silent Hunt","Lost Tribe","Marked Bone","Buried Blade","Icebound Oath"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("Frozen Footprint")
				P.desc = "A single footprint frozen solid in a cracked icy path. It glows faintly, untouched by time. Around it, scattered is a bloodied cloth and a broken spearhead. It is associated with: missed opportunity, consequences."
			if("Shared Fire")
				P.desc = "Several figures gather around a fire in the middle of a blizzard. Though cold rages around them, their circle is warm. Shadows on the tent walls show animals instead of people. One figure extends a \
				hand to the viewer. It is associated with: community, sacrifice, loyality."
			if("Broken Edict")
				P.desc = "A sacred tablet cracked down the middle, one half buried in snow, the crack forms a lightning-shaped glyph. A fox sits nearby, watching. It is associated with: rebellion, righteousness, moral ambiguity."
			if("Silent Hunt")
				P.desc = "A hunter crouches in the snow, bow drawn, breath invisible. Behind them, a spectral beast stalks them in silence. No footprints in the snow. Both hunter and hunted wear the same carved mask. It is associated with: \
				patience, waiting, unspoken action."
			if("Lost Tribe")
				P.desc = "A caravan of silhouettes walks endlessly across a snowplain beneath a starry sky. One member carries a banner with, but it is impossible to see what it shows. It is associated with: disconnection, wandering."
			if("TMarked Bone")
				P.desc = "A long, polished bone lies on a shrine, carved with fresh glyphs bleeding red ink, a spectral bird watches from above. The glyphs emit a faint glow. It is associated with: signs from the Goddess, omens."
			if("Buried Blade")
				P.desc = "A ritual dagger protrudes from a snowbank, only its hilt visible. Blood stains the snow nearby. The hilt is wrapped in two colors. A snowflake lands, forming a glyph for 'lies'. It is associated with: \
				hidden conflict, denial."
			if("Icebound Oath")
				P.desc = "Two figures clasp wrists, their hands frozen together by blue ice. One looks determined, the other regretful. A small fire burns in the background. It is associated with: duty, promise, burdens kept too long."
		P.card_icon = "paths"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/lyodii/beasts
	name = "lyodii fatesayer beasts deck"
	desc = "A traditionally-made deck of Fatesayer cards, used by the people of the Lyod. This stack contains the Beasts cards."
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/lyodii/beasts/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Tenelote","Arctic Fox","Bisumoi","Prejoroub","Yastr","Ptarmigan","Reindeer","Snow Hare"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("Tenelote")
				P.desc = "A massive white-furred Tenelote, horned, stands atop a frozen ridge. Its eyes glow faintly blue, snow spirals upward around it. Broken spears stick out of its flank, yet it stands unbowed. Behind it, \
				a blizzard is approaching. It is associated with: strength, endurance, ferocity."
			if("Arctic Fox")
				P.desc = "A small, sleek fox slinks through moonlit snow, looking back over its shoulder with knowing eyes. One pawprint glows faintly. Its tail is split in two. In the snow nearby: a discarded bone dice and a \
				trail of feathers. It is associated with: cunning, hidden paths, trickery."
			if("Bisumoi")
				P.desc = "A towering moose-like creature with two sets of twisted antlers resembling roots and glyphs. It gazes at the viewer through milky eyes while snow falls silently around it. It is associated with: \
				ancient wisdom, balance, ancestral memory."
			if("Prejoroub")
				P.desc = "A long-winged bird, vulture-like but with a face that resembles a skull, circles over a field strewn with bones. Feathers fall from its wings, where they land, fire erupts. Its shadow is shaped like a wolf. \
				It is associated with: death, scavenging, what must be taken."
			if("Yastr")
				P.desc = "A flock of thin-necked bird with long wings fly across the tundra under a blazing sunset. The lead bird looks back, as if uncertain. A single figure watches from afar, unseen by the beasts. It is associated with: \
			migration, movement, restlessness."
			if("Ptarmigan")
				P.desc = "A deceptively calm snowbird perches on a branch above a frozen lake. Beneath the ice, shadows twist and churn. One of the eyes of the bird is missing. A bloodied feather drifts down toward the viewer. It is associated with: \
				danger beneath calm, betrayal."
			if("Reindeer")
				P.desc = "A scarred reindeer stands within a ring of tribal totems. It bows its head, offering its antlers to a shamanic figure. Runes burned into its flank. Each totem around it is engraved with different runes. \
				It is associated with: loyalty, hunger, bonds."
			if("Snow Hare")
				P.desc = "A white hare dashes through the snow under a full moon, carrying a leaf bundle in its mouth. Behind it in the sky, there's a shooting star. Three small spirits follow behind, barely visible. Snowflakes around \
				the hare are all different glyphs. It is associated with: small joys, fleeting beauty, messages."
		P.card_icon = "beasts"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/lyodii/winds
	name = "lyodii fatesayer winds deck"
	desc = "A traditionally-made deck of Fatesayer cards, used by the people of the Lyod. This stack contains the Winds cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/lyodii/winds/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("North Wind","South Wind","East Wind","West Wind","Windless Day","Black Gale","Whisper Breeze","Stormcry"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("North Wind")
				P.desc = "A gentle, blue-hued gust flows over a landscape, moving over a firelit camp. Spirals of warmth rise from the fires. The wind forms a protective circle. It is associated with: mercy, home, unexpected aid."
			if("South Wind")
				P.desc = "A crimson gale howls down a mountainside, tearing trees from the ground. A figure walks into it, teeth bared. Faint, distorted faces can be seen in the gusts. Shattered ice-crystals fly like knives. \
				It is associated with: cruelty, challenge, reckoning."
			if("East Wind")
				P.desc = "A pale wind carries seeds and starlight across a dark horizon. Dawn breaks just as the wind touches the earth. One cloud overhead resembles an open eye. It is associated with: beginnings, clarity, sacred insight."
			if("West Wind")
				P.desc = "A wind brushes over a field of grave markers made of bone. Spirits rise gently in its wake. Faint faces drift briefly along the wind. The moon watches in the sky. It is associated with: endings, \
				mystery, ancestral voices."
			if("Windless Day")
				P.desc = "A completely still scene, a frozen lake, unmoving trees, a bird suspended in midair. A sense of being trapped in time. A small crack in the lake surface forms the glyph for 'waiting'. It is associated with: \
				stagnation, hidden tension."
			if("Black Gale")
				P.desc = "A storm-black wind crashes into tents, tearing them apart as lightning strikes nearby. The wind has claws. Each lightning bolt forms a different rune for destruction, punishment. It is associated with: \
				upheaval, divine punishment."
			if("Whisper Breeze")
				P.desc = "A soft breeze curls around a sleeping child’s ear, one candle stands nearby. It is associated with: secrets, subtle shifts."
			if("Stormcry")
				P.desc = "Rain and wind mix with wailing spirit-faces. A lone figure kneels on a clifftop, arms raised in anguish. Tears fall upward, the wind feels heavy. It is associated with: rage, grief, release."
		P.card_icon = "winds"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/lyodii/bones
	name = "lyodii fatesayer bones deck"
	desc = "A traditionally-made deck of Fatesayer cards, used by the people of the Lyod. This stack contains the Bones cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/lyodii/bones/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Bone of Birth","Bone of Death","Bone of Choice","Goddess"))
		P = new()
		P.name = "[name]"
		P.card_icon = "bones"
		P.back_icon = "card_back_lyodii"
		switch(name)
			if("Bone of Birth")
				P.desc = "A curved rib bone floats in a pool of water, illuminated from below. Inside it, a tiny sprout grows. In the water’s reflection, the bone looks like a cradle. It is associated with: legacy, fate beginning to move."
			if("Bone of Death")
				P.desc = "A skull, half-buried in snow, with a single red flower growing from one eye socket. A spirit form rises behind the skull, birds fly overhead. It is associated with: inevitable ends, sacred cycles."
			if("Bone of Choice")
				P.desc = "A forked femur lies between two paths—one lined with fire, the other shadowy. A hand hesitates above it. The bone is marked with tally marks and blood-stained glyphs. It is associated with: the moment of truth, \
				taking action."
			if("Goddess")
				P.desc = "A glowing, diffuse spectral form floats above a ritual circle of bones. Light spills from the heavens onto it. Snowflakes falling nearby take on different shapes of animals, eyes and hands. It is associated with: \
				divine will, judgement, revelation."
				P.card_icon = "goddess"
		cards += P

/obj/item/storage/box/lyodii
	name = "fatesayer box"
	desc = "A small leather case to to hold all 36 cards of a Fatesayer deck."
	icon_state = "card_holder_empty"
	icon = 'icons/obj/storage/misc.dmi'
	can_hold = list(/obj/item/deck, /obj/item/hand, /obj/item/card)
	storage_slots = 5 //Needs to hold all five Fatesayer cards.
	use_sound = 'sound/items/drop/shoes.ogg'
	drop_sound = 'sound/items/drop/hat.ogg'

/obj/item/storage/box/lyodii/fill()
	..()
	new /obj/item/deck/lyodii/spirits(src)
	new /obj/item/deck/lyodii/paths(src)
	new /obj/item/deck/lyodii/beasts(src)
	new /obj/item/deck/lyodii/winds(src)
	new /obj/item/deck/lyodii/bones(src)
