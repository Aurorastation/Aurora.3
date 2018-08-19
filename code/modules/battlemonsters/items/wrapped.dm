/obj/item/battle_monsters/wrapped
	name = "battle monsters starterpack"
	desc = "A battle monsters 52 card deck starterpack. Contains 52 basic cards and a lifetime of sadness."
	icon_state = "pack1"
	var/contained_cards = 52
	var/rare_limiter = 1000

/obj/item/battle_monsters/wrapped/attack_self(mob/user)
	var/list/deck_data = list()
	for(var/i=1,i < contained_cards,i++)
		CHECK_TICK //This stuff is a little intensive I think.
		var/datum/battle_monsters/selected_root = SSbattlemonsters.GetRandomRoot_Filtered(rare_limiter)
		var/datum/battle_monsters/selected_prefix = SSbattlemonsters.GetRandomPrefix_Filtered(rare_limiter)
		var/datum/battle_monsters/selected_suffix = SSbattlemonsters.GetRandomSuffix_Filtered(rare_limiter)
		deck_data += "[selected_root.id],[selected_prefix.id],[(selected_prefix.rarity_score + selected_root.rarity_score) >= 3 ? selected_suffix.id : "no_title"]"
	user.visible_message(\
		span("notice","\The [user] unwraps \the [src]."),\
		span("notice","You unwrap \the [src].")\
	)
	var/obj/item/battle_monsters/deck/generated_deck = new(get_turf(src))
	generated_deck.stored_card_names = deck_data
	user.drop_from_inventory(src)
	user.put_in_active_hand(generated_deck)
	qdel(src)

/obj/item/battle_monsters/wrapped/pro
	name = "battle monsters booster pack"
	desc = "A pack of 10 rare battle monster cards."
	icon_state = "pack2"
	contained_cards = 10
	rare_limiter = 0.1

/obj/item/battle_monsters/wrapped/rare
	name = "battle monsters rare booster pack"
	desc = "A pack of 10 ultra-rare battle monster cards."
	icon_state = "pack2"
	contained_cards = 10
	rare_limiter = 0.1