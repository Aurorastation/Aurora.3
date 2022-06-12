// PMCG Modsuit
/obj/item/clothing/under/pmc_modsuit
	name = "\improper PMCG modsuit"
	desc = "A modular fatigue jumpsuit, from the Private Military Contracting Group."
	desc_fluff = "The proprietary PMCG Modular Fatigue Jumpsuit, quickly dubbed the modsuit, is an innovation by the recently-formed PMCG to quickly outfit its scores of new \
	hires and acquisitions at economic production costs. Designed to fit military contractors of a wide range of sizes, species, and operating environments with tolerable comfort, \
	the modsuit features a number of smart-fabric connection points for the modern contractor to modify their uniform to a number of preset configurations."
	icon = 'icons/clothing/under/uniforms/pmcg_modsuit.dmi'
	icon_state = "pmcg_modsuit"
	item_state = "pmcg_modsuit"
	contained_sprite = TRUE
	action_button_name = "Change Modsuit"
	var/modsuit_mode = 0
	var/list/names = list(
		"\improper PMCG modsuit",
		"\improper PMCG shortsleeved modsuit",
		"\improper PMCG modsuit pants",
		"\improper PMCG shorts modsuit")

/obj/item/clothing/under/pmc_modsuit/Initialize()
	for(var/option in names)
		if(!modsuit_mode)
			names[option] = image('icons/clothing/under/uniforms/pmcg_modsuit.dmi', icon_state)
			modsuit_mode = 1
		else
			names[option] = image('icons/clothing/under/uniforms/pmcg_modsuit.dmi', initial(icon_state) + "_[names.Find(option) - 1]")
	modsuit_mode = 0
	.=..()

/obj/item/clothing/under/pmc_modsuit/attack_self(mob/user)
	select_modsuit(user)

/obj/item/clothing/under/pmc_modsuit/proc/select_modsuit(mob/user)
	var/modsuit_choice = RADIAL_INPUT(user, names)
	if(!modsuit_choice)
		return
	modsuit_mode = names.Find(modsuit_choice) - 1

	selected_modsuit(user)
	update_clothing_icon()

/obj/item/clothing/under/pmc_modsuit/proc/selected_modsuit(mob/user as mob)
	if(!modsuit_mode)
		name = initial(name)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		name = names[modsuit_mode + 1]
		icon_state = initial(icon_state) + "_[modsuit_mode]"
		item_state = initial(item_state) + "_[modsuit_mode]"

	update_clothing_icon()
	user.update_action_buttons()

/obj/item/clothing/under/pmc_modsuit/verb/change_modsuit()
	set name = "Change Modsuit"
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr))
		return

	select_modsuit(usr)