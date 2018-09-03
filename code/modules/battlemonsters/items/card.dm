/obj/item/battle_monsters/card
	name = "battle monsters card"
	desc = "A battle monster's card."

	var/card_type = BATTLE_MONSTERS_CARDTYPE_MONSTER
	var/datum/battle_monsters/element/prefix_datum
	var/datum/battle_monsters/monster/root_datum
	var/datum/battle_monsters/title/suffix_datum

	var/datum/battle_monsters/spell/spell_datum
	var/datum/battle_monsters/trap/trap_datum

	w_class = ITEMSIZE_TINY

	//Card information here

/obj/item/battle_monsters/card/Initialize(var/mapload,var/prefix,var/root,var/title,var/trap,var/spell)
	. = ..()
	Generate_Card(prefix, root, title, trap, spell)

/obj/item/battle_monsters/card/attackby(var/obj/item/attacking, var/mob/user)
	if(istype(attacking,/obj/item/battle_monsters/card) && attacking != src)
		var/obj/item/battle_monsters/card/adding_card = attacking
		make_deck(user,adding_card)

/obj/item/battle_monsters/card/attack_self(mob/user as mob)
	flip_card(user)

/obj/item/battle_monsters/card/proc/make_deck(var/mob/user,var/obj/item/battle_monsters/card/adding_card)

	var/obj/item/battle_monsters/deck/new_deck = new(src.loc)

	if(src.loc == user)
		//Make a hand.
		user.drop_from_inventory(src)
		new_deck.icon_state = "hand"
		user.put_in_inactive_hand(new_deck)
		to_chat(user,span("notice","You combine \the [src] and the [adding_card] to form a hand."))
	else
		new_deck.set_dir(dir)
		new_deck.pixel_x = pixel_x
		new_deck.pixel_y = pixel_y
		new_deck.layer = max(layer,new_deck.layer)
		user.visible_message(\
			span("notice","\The [user] combines \the [src] and the [adding_card] to form a deck."),\
			span("notice","You combine \the [src] and the [adding_card] to form a deck.")\
		)

	new_deck.add_card(user,src)
	new_deck.add_card(user,adding_card)

/obj/item/battle_monsters/card/proc/flip_card(var/mob/user)
	facedown = !facedown

	if(src.loc == user)
		if(!facedown)
			to_chat(user,span("notice","You reveal \the [name] to yourself, preparing to play it face up."))
		else
			to_chat(user,span("notice", "You prepare \the [name] to be played face down."))
	else
		if(!facedown)
			user.visible_message(\
				span("notice","\The [user] flip the card face up and reveals \the [name]."),\
				span("notice","You flip the card face up and reveal \the [name].")\
			)
		else
			user.visible_message(\
				span("notice","\The [user] flips \the [name] face down."),\
				span("notice","You flip \the [name] face down.")\
			)

	update_icon()

/obj/item/battle_monsters/card/proc/Generate_Card(var/prefix,var/root,var/title,var/trap,var/spell)

	if(trap)
		trap_datum = SSbattlemonsters.FindMatchingTrap(trap,TRUE)
		update_icon()
		return

	if(spell)
		spell_datum = SSbattlemonsters.FindMatchingSpell(spell,TRUE)
		update_icon()
		return

	if(prefix)
		prefix_datum = SSbattlemonsters.FindMatchingPrefix(prefix,TRUE)
	else
		prefix_datum = SSbattlemonsters.GetRandomPrefix()

	if(root)
		root_datum = SSbattlemonsters.FindMatchingRoot(root,TRUE)
	else
		root_datum = SSbattlemonsters.GetRandomRoot()

	var/rarity_score = prefix_datum.rarity_score + root_datum.rarity_score

	if(title)
		suffix_datum = SSbattlemonsters.FindMatchingSuffix(title,TRUE)
	else if(rarity_score >= 3)
		suffix_datum = SSbattlemonsters.GetRandomSuffix()
	else
		suffix_datum = SSbattlemonsters.FindMatchingSuffix("no_title",TRUE)

/obj/item/battle_monsters/card/update_icon()

	cut_overlays()

	if(facedown)
		icon_state = "back"
	else

		var/rounded_rarity_score

		if(trap_datum)
			rounded_rarity_score = trap_datum.rarity_score
		else if(spell_datum)
			rounded_rarity_score = spell_datum.rarity_score
		else
			rounded_rarity_score = prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score

		rounded_rarity_score = min(max(round(rounded_rarity_score,1),1),4)

		icon_state = "front_r_[rounded_rarity_score]"
		add_overlay("front_label")

		if(trap_datum && trap_datum.icon_state)
			add_overlay(trap_datum.icon_state)

		if(spell_datum && spell_datum.icon_state)
			add_overlay(spell_datum.icon_state)

		if(prefix_datum && prefix_datum.icon_state)
			add_overlay(prefix_datum.icon_state)

		if(root_datum && root_datum.icon_state)
			add_overlay(root_datum.icon_state)

		if(suffix_datum && suffix_datum.icon_state)
			add_overlay(suffix_datum.icon_state)

		if(rounded_rarity_score >= 2)
			add_overlay("rarity_animation")

	var/matrix/M = matrix()
	switch(dir)
		if(NORTH)
			M.Turn(0)
		if(SOUTH)
			M.Turn(180)
		if(WEST)
			M.Turn(270)
		if(EAST)
			M.Turn(90)

	transform = M

/obj/item/battle_monsters/card/examine(mob/user)

	..()

	if(facedown && src.loc != user)
		to_chat(user,span("notice","You can't examine \the [src] while it's face down!"))
		return

	if(trap_datum)
		SSbattlemonsters.ExamineTrapCard(user,trap_datum)
	else if(spell_datum)
		SSbattlemonsters.ExamineSpellCard(user,spell_datum)
	else
		SSbattlemonsters.ExamineMonsterCard(user,prefix_datum,root_datum,suffix_datum)

