/obj/item/battle_monsters/card
	name = "battle monsters card"
	desc = "A battle monster's card."
	var/datum/battle_monsters/element/prefix_datum
	var/datum/battle_monsters/monster/root_datum
	var/datum/battle_monsters/title/suffix_datum
	w_class = ITEMSIZE_TINY

	//Card information here
	var/card_name = ""
	var/card_description = ""
	var/card_special_effects = ""
	var/card_elements = BATTLE_MONSTERS_ELEMENT_NONE
	var/card_attack_type = BATTLE_MONSTERS_ATTACKTYPE_NONE
	var/card_defense_type = BATTLE_MONSTERS_DEFENSETYPE_NONE
	var/card_attack_points = 0
	var/card_defense_points = 0
	var/card_rarity_score = 0
	var/card_power = 0
	var/card_starlevel = 0
	var/card_type = "Monster Card"

/obj/item/battle_monsters/card/New(var/turf/loc,var/prefix,var/root,var/title)
	. = ..()
	Generate_Card(prefix, root, title)

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

	if(src.loc == user)
		to_chat(user,span("notice","You combine \the [src] and the [adding_card] to form a hand."))
	else
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
			to_chat(user,span("notice","You reveal \the [card_name] to yourself, preparing to play it face up."))
		else
			to_chat(user,span("notice", "You prepare \the [card_name] to be played face down."))
	else
		if(!facedown)
			user.visible_message(\
				span("notice","\The [user] flip the card face up and reveals \the [card_name]."),\
				span("notice","You flip the card face up and reveal \the [card_name].")\
			)
		else
			user.visible_message(\
				span("notice","\The [user] flips \the [card_name] face down."),\
				span("notice","You flip \the [card_name] face down.")\
			)

	update_icon()

/obj/item/battle_monsters/card/proc/Generate_Card(var/prefix,var/root,var/title)

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

	update_icon()

/obj/item/battle_monsters/card/update_icon()

	cut_overlays()

	//Icon updating also updates it's information.

	//Card Name
	card_name = root_datum.name
	if(prefix_datum.name)
		card_name = "[prefix_datum.name] [card_name]"
	if(suffix_datum.name)
		card_name = "[card_name], [suffix_datum.name]"

	//Card Description
	card_description = root_datum.description
	if(prefix_datum.description)
		card_description += " [prefix_datum.description]"
	if(suffix_datum.description)
		card_description += "<br><i>[suffix_datum.description]</i>"

	//Card Special Effects
	card_special_effects = "" //This needs to reset every refresh.
	if(prefix_datum.special_effects)
		card_special_effects = trim("[card_special_effects][prefix_datum.special_effects]<br>")
	if(root_datum.special_effects)
		card_special_effects = trim("[card_special_effects][root_datum.special_effects]<br>")
	if(suffix_datum.special_effects)
		card_special_effects = trim("[card_special_effects][suffix_datum.special_effects]<br>")

	//Card Statistics
	card_elements = prefix_datum.elements | root_datum.elements | suffix_datum.elements
	card_attack_type = prefix_datum.attack_type | root_datum.attack_type | suffix_datum.attack_type
	card_defense_type = prefix_datum.defense_type | root_datum.defense_type | suffix_datum.defense_type
	card_rarity_score = prefix_datum.rarity_score + root_datum.rarity_score + suffix_datum.rarity_score
	card_attack_points = (prefix_datum.attack_add + root_datum.attack_add + suffix_datum.attack_add) * (prefix_datum.attack_mul * root_datum.attack_mul * suffix_datum.attack_mul)
	card_defense_points = (prefix_datum.defense_add + root_datum.defense_add + suffix_datum.defense_add) * (prefix_datum.defense_mul * root_datum.defense_mul * suffix_datum.defense_mul)
	card_power = (prefix_datum.power_add + root_datum.power_add + suffix_datum.power_add) * (prefix_datum.power_mul * root_datum.power_mul * suffix_datum.power_mul)
	if(card_attack_points >= card_defense_points)
		card_defense_points = card_defense_points/(card_attack_points + card_defense_points)
		card_attack_points = 1 - card_defense_points
	else
		card_attack_points = card_attack_points/(card_attack_points + card_defense_points)
		card_defense_points = 1 - card_attack_points
	card_attack_points = round(card_power * card_attack_points,100)
	card_defense_points = round(card_power * card_defense_points,100)

	card_starlevel = SSbattlemonsters.GetStarLevel(src)

	var/rounded_rarity_score = min(max(round(card_rarity_score,1),1),4)

	if(facedown)
		icon_state = "back"
	else
		icon_state = "front_r_[rounded_rarity_score]"
		add_overlay("front_label")

		if(prefix_datum.icon_state)
			add_overlay(prefix_datum.icon_state)

		if(root_datum.icon_state)
			add_overlay(root_datum.icon_state)

		if(suffix_datum.icon_state)
			add_overlay(suffix_datum.icon_state)

		if(rounded_rarity_score >= 2)
			add_overlay("rarity_animation")

	var/matrix/M = matrix()
	switch(dir)
		if(SOUTH)
			M.Turn(180)
		if(WEST)
			M.Turn(270)
		if(EAST)
			M.Turn(90)

	transform = M

/obj/item/battle_monsters/card/examine(mob/user)

	..()

	if(facedown)
		to_chat(user,span("notice","You can't examine \the [src] while it's face down!"))
		return

	var/lol_formatting = "<b>[card_name]</b>"
	for(var/i=1, i <= card_starlevel, i++)
		lol_formatting += BATTLE_MONSTERS_FORMAT_STAR
	lol_formatting += " | %ELEMENT_LIST %TYPE | %SPECIES_C %ATTACKTYPE_LIST"

	//I don't know why but the above code just makes me want to eat ass

	to_chat(user,SSbattlemonsters.FormatText(src,lol_formatting))
	to_chat(user,SSbattlemonsters.FormatText(src,"Keywords: %SPECIES_LIST"))
	to_chat(user,SSbattlemonsters.FormatText(src,"ATK: [card_attack_points] | DEF: [card_defense_points]"))
	to_chat(user,SSbattlemonsters.FormatText(src,card_special_effects))
	to_chat(user,SSbattlemonsters.FormatText(src,"The card depicts [card_description]"))