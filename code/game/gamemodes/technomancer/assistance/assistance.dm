/datum/technomancer/assistance
	var/one_use_only = 0

/datum/technomancer/assistance/apprentice
	name = "Friendly Apprentice"
	desc = "A one-time use teleporter that sends a less powerful manipulator of space to you, who will do their best to protect \
	and serve you.  They get their own catalog and can buy spells for themselves, however they have a smaller pool to buy with.  \
	If you are unable to receive an apprentice, the teleporter can be refunded like most equipment by sliding it into the \
	catalog.  Note that apprentices cannot purchase more apprentices."
	cost = 300
	obj_path = /obj/item/antag_spawner/technomancer_apprentice
	has_additional_info = TRUE

/datum/technomancer/assistance/apprentice/additional_info()
	var/technomancer_count = 0
	var/ghost_count = 0
	for(var/mob/abstract/ghost/observer/O in GLOB.player_list)
		if(O.client && (O.client.inactivity < 5 MINUTES))
			if("technomancer" in O.client.prefs.be_special_role)
				technomancer_count++
			ghost_count++
	return "There [technomancer_count > 1 ? "are" : "is"] <b>[technomancer_count]</b> out of <b>[ghost_count]</b> active observer\s with the technomancer role enabled."

/datum/technomancer/assistance/apprentice/golem
	name = "GOLEM Unit"
	desc = "Teleports a specially designed synthetic unit to you, which is very durable, has an advanced AI, and can also use \
	functions. It also has a large storage capacity for energy, and due to it's synthetic nature, instability is less of an issue for them."
	cost = 350
	obj_path = /obj/item/antag_spawner/technomancer_apprentice/golem
	one_use_only = TRUE

/datum/technomancer/assistance/summoning_stone
	name = "Summoning Stone"
	desc = "A summoning stone is a small bluespace stone that's intra-dimensionally linked to a Core Bracelet, a miniaturized version of a manipulation core. \
	Upon crushing the crystal in one's hand, the bracelet will appear on their wrist and a catalog in their hand. You can give this to anyone you deem worthy to bring them into the fold. \
	NOTE: The agent will in no way have their free will modified, they can do whatever they wish with their power."
	cost = 150
	obj_path = /obj/item/summoning_stone

/obj/item/summoning_stone
	name = "small bluespace crystal"
	desc = "A smaller variant of the bluespace crystal. This one probably isn't big enough to teleport you around."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "bluespace_crystal_small"

/obj/item/summoning_stone/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user) || !user.mind)
		return
	// since this gives us a catalogue with more points than it costs, prevent the antag from farming points by using this
	if(GLOB.technomancers.is_technomancer(user.mind))
		to_chat(user, SPAN_WARNING("You're already in the fold, you can't use this!"))
		return
	var/turf/user_turf = get_turf(user)
	user.drop_from_inventory(src, user_turf)
	user.visible_message(SPAN_DANGER("<b>[user]</b> crushes \the [src] in their hand with a shower of sparks! A small bracelet appears on their wrist, and a catalog flies into their hand."), SPAN_DANGER("You crush \the [src] in your hand with a shower of sparks! A small bracelet appears on your wrist, and a catalog flies into your hand."))
	spark(user_turf, 4, GLOB.alldirs)
	var/initiate_welcome_text = "You will need to purchase <b>functions</b> and perhaps some <b>equipment</b> from your initiate's catalogue. \
	Choose your technological arsenal carefully.  Remember that without the <b>core</b> on your wrist, your functions are \
	powerless, and therefore you will be as well."
	GLOB.technomancers.add_antagonist_mind(user.mind, 1, "Technomancer Initiate", initiate_welcome_text)
	if(user.wrists)
		user.drop_from_inventory(user.wrists, get_turf(user_turf))
	var/obj/item/technomancer_core/bracelet/bracelet = new(user_turf)
	user.equip_to_slot_if_possible(bracelet, slot_wrists, assisted_equip = TRUE)
	var/obj/item/technomancer_catalog/initiate/catalog = new(user_turf)
	catalog.owner = user
	user.put_in_active_hand(catalog)
	qdel(src)
