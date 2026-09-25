/datum/game_mode/technomancer
	name = "Technomancer"
	config_tag = "technomancer"
	votable = 1
	max_players = 15
	required_players = 5
	required_enemies = 1
	antag_tags = list(MODE_TECHNOMANCER)

/datum/game_mode/technomancer/pre_setup()
	round_description = "An entity possessing advanced, unknown technology is onboard, who is capable of accomplishing amazing feats."
	extended_round_description = "A powerful entity capable of manipulating space around them, has arrived on the [SSatlas.current_map.station_type]. \
	They have a wide variety of powers and functions available to them that makes your own simple moral self tremble with \
	fear and excitement. Ultimately, their purpose is unknown. However, it is up to you and your crew to decide if \
	their powers can be used for good or if their arrival foreshadows the destruction of the entire [SSatlas.current_map.station_type], or worse."
	. = ..()

/obj/item/technomancer_jumpstarter
	name = "technomancer jumpstarter"
	desc = "Use this to become a technomancer. This item is definitely not canon."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "amp"
	contained_sprite = FALSE

/obj/item/technomancer_jumpstarter/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/datum/technomancer/technomancer = H.mind.antag_datums[MODE_TECHNOMANCER]
	if(technomancer)
		to_chat(H, SPAN_WARNING("You're already a technomancer!"))
		return

	if(GLOB.technomancers.add_antagonist(H.mind, FALSE, TRUE, FALSE, TRUE, TRUE))
		var/obj/item/technomancer_core/core = new /obj/item/technomancer_core
		if (core)
			GLOB.technomancer_belongings.Add(core)
			H.equip_or_collect(core, slot_in_backpack)
		var/obj/item/technomancer_catalog/catalog = new /obj/item/technomancer_catalog
		if (catalog)
			catalog.bind_to_owner(H)
			if(istype(H.back, /obj/item/storage))
				var/obj/item/storage/S = H.back
				S.handle_item_insertion(catalog, TRUE)
			else
				var/turf/T = get_turf(H)
				if(istype(T))
					catalog.forceMove(T)

		to_chat(H, SPAN_NOTICE("You've become a technomancer! You will find your core and catalog inside your backpack."))
		qdel(src)
	else
		to_chat(H, SPAN_WARNING("Something prevented you from becoming a technomancer."))
