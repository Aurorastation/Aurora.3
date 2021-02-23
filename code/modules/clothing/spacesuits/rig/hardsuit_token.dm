/obj/item/hardsuit_token
	name = "hardsuit token"
	desc = "A coin infused with telecrystals. Using it will allow you to summon a hardsuit of your choice."
	icon = 'icons/obj/hardsuit_token.dmi'
	icon_state = "hardsuit_token"

/obj/item/hardsuit_token/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You can't use \the [src]."))
		return
	var/list/hardsuit_options = list(
		"Stealth Suit" = /obj/item/rig/light/ninja,
		"Solarian Military Hardsuit" = /obj/item/rig/military/ninja,
		"Coalition Gunslinger Suit" = /obj/item/rig/gunslinger/ninja,
		"Hegemony Breacher Suit" = /obj/item/rig/unathi/fancy/ninja,
		"People's Republic Tesla Suit" = /obj/item/rig/tesla/ninja,
		"Eridani PMC Strike Suit" = /obj/item/rig/strike/ninja,
		"Jinxiang Pattern Combat Suit" = /obj/item/rig/jinxiang/ninja,
		"Elyran Battlesuit" = /obj/item/rig/elyran/ninja,
		"Cyberwarfare Suit" = /obj/item/rig/light/hacker/ninja,
		"Technoconglomerate Mobility Suit" = /obj/item/rig/light/offworlder/techno/ninja,
		"Crimson Hardsuit" = /obj/item/rig/merc/ninja,
		"Rhino Suit" = /obj/item/rig/merc/distress/ninja
	)
	for(var/hardsuit_option in hardsuit_options)
		var/hardsuit_path = hardsuit_options[hardsuit_option]
		var/obj/item/rig/R = new hardsuit_path
		if(!(user.species.bodytype in R.species_restricted))
			hardsuit_options -= hardsuit_option
	var/list/options = list()
	for(var/hardsuit in hardsuit_options)
		var/image/radial_button = image(icon = src.icon, icon_state = hardsuit)
		options[hardsuit] = radial_button
	var/chosen_rig = show_radial_menu(user, user, options, radius = 42, tooltips = TRUE)
	if(chosen_rig)
		spark(loc, 2, alldirs)
		var/hardsuit_path = hardsuit_options[chosen_rig]
		var/obj/item/rig/R = new hardsuit_path(get_turf(src))
		R.dnaLock = user.dna
		user.put_in_hands(R)
		qdel(src)