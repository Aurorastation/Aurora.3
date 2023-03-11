/obj/item/vault_token
	name = "hardsuit token"
	desc = "A token infused with telecrystals. You can summon almost any hardsuit with this."
	icon = 'icons/obj/hardsuit_token.dmi'
	icon_state = "hardsuit_token"

/obj/item/vault_token/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You can't use \the [src]."))
		return
	var/list/hardsuit_options = list(
		"Crimson Hardsuit" = /obj/structure/closet/crate/secure/gear_loadout/vault/crimson,
		"Solarian Military Hardsuit" = /obj/structure/closet/crate/secure/gear_loadout/vault/sol,
		"Hazard Control Hardsuit" = /obj/structure/closet/crate/secure/gear_loadout/vault/hazard,
		"Paragon Control Module" = /obj/structure/closet/crate/secure/gear_loadout/vault/einstein,
		"Combat Suit" = /obj/structure/closet/crate/secure/gear_loadout/vault/combat
	)
	for(var/hardsuit_option in hardsuit_options)
		var/crate_path = hardsuit_options[hardsuit_option]
		var/obj/structure/closet/crate/secure/gear_loadout/vault/N = crate_path
		var/hardsuit_path = initial(N.associated_vault_hardsuit)
		var/obj/item/rig/R = new hardsuit_path
		if(!(user.species.bodytype in R.species_restricted))
			hardsuit_options -= hardsuit_option
	var/list/options = list()
	for(var/hardsuit in hardsuit_options)
		var/obj/structure/closet/crate/secure/gear_loadout/vault/choice = hardsuit_options[hardsuit]
		var/image/radial_button = image(icon = choice.icon, icon_state = choice.icon_state)
		options[hardsuit] = radial_button
	var/chosen_rig = show_radial_menu(user, user, options, radius = 42, tooltips = TRUE)
	if(chosen_rig)
		spark(loc, 2, alldirs)
		var/crate_path = hardsuit_options[chosen_rig]
		var/obj/structure/closet/crate/secure/gear_loadout/vault/N = new crate_path(get_turf(src))
		qdel(src)
