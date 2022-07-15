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
		"Stealth Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/stealth,
		"Solarian Military Hardsuit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/sol,
		"Coalition Gunslinger Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/gunslinger,
		"Hegemony Breacher Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/breacher,
		"People's Republic Tesla Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/tesla,
		"Eridani PMC Strike Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/strike,
		"Jinxiang Pattern Combat Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/jinxiang,
		"Elyran Battlesuit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/elyra,
		"Cyberwarfare Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/hacker,
		"Advanced Mobility Combat Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/frontier,
		"Crimson Hardsuit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/crimson,
		"Rhino Suit" = /obj/structure/closet/crate/secure/gear_loadout/ninja/rhino
	)
	for(var/hardsuit_option in hardsuit_options)
		var/crate_path = hardsuit_options[hardsuit_option]
		var/obj/structure/closet/crate/secure/gear_loadout/ninja/N = crate_path
		var/hardsuit_path = initial(N.associated_hardsuit)
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
		var/crate_path = hardsuit_options[chosen_rig]
		var/obj/structure/closet/crate/secure/gear_loadout/ninja/N = new crate_path(get_turf(src))
		var/obj/item/rig/R = locate(N.associated_hardsuit) in N
		R.dnaLock = user.dna
		qdel(src)