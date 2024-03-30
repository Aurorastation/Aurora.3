// PMCG Modsuit
/obj/item/clothing/under/pmc_modsuit
	name = "\improper PMCG modsuit"
	desc = "A modular fatigue jumpsuit, from the Private Military Contracting Group."
	desc_extended = "The proprietary PMCG Modular Fatigue Jumpsuit, quickly dubbed the modsuit, is an innovation by the recently-formed PMCG to quickly outfit its scores of new \
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

/obj/item/clothing/under/rank/security/pmc/wildlands_squadron
	name = "wildlands squadron uniform"
	desc = "A set of uniform fatigues used by employees of the Wildlands Squadron, a Private Military Contracting Group subsidiary. The original design is remarkably similar to the Mictlan System Defense Force's uniform, of which many of the original members of the Wildlands Squadron were members."
	icon_state = "pmc_ws"
	item_state = "pmc_ws"

/obj/item/clothing/under/rank/security/pmc/dagamuir_freewater
	name = "\improper Dagamuir Freewater Private Forces uniform"
	desc = "An Unathi-style uniform used by the mercenaries of Dagamuir Freewater Private Forces, an Unathi-run PMCG subsidiary. The chest and back are emblazoned with a stylised red and golden eye, once the emblem of the Dagamuir clan."
	icon_state = "pmc_dpf"
	item_state = "pmc_dpf"

/obj/item/clothing/under/rank/security/pmc/vekatak_phalanx
	name = "\improper Ve'katak Phalanx security uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has the standard red shoulder stripes, as well as pale blue ornamentation, identifying it as belonging to a Phalanx member in the employ of the Private Military Contracting Group."
	desc_extended = "These uniforms are designed to fit under the combat hardsuits favored by the Phalanx. They are utilitarian in design, and reportedly somewhat uncomfortable - though few of the non-Vaurcae bold enough to join Ve'katak seem to complain."
	icon_state = "phalanx-sec-jumpsuit"
	item_state = "phalanx-sec-jumpsuit"

/obj/item/clothing/under/rank/medical/first_responder/pmc/vekatak_phalanx
	name = "\improper Ve'katak Phalanx medical uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has dark blue shoulder stripes and ornamentation, identifying it as belonging to a Phalanx medic in the employ of the Private Military Contracting Group."
	desc_extended = "These uniforms are designed to fit under the combat hardsuits favored by the Phalanx. They are utilitarian in design, and reportedly somewhat uncomfortable - though few of the non-Vaurcae bold enough to join Ve'katak seem to complain."
	icon_state = "phalanx-med_jumpsuit"
	item_state = "phalanx-med_jumpsuit"

/obj/item/clothing/under/rank/pmc/vekatak_phalanx
	name = "\improper Ve'katak Phalanx representative uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has ice blue shoulder stripes, identifying it as belonging to a Phalanx member that is representing the direct interests of the Phalanx and their immediate employers."
	desc_extended = "These uniforms are designed to fit under the combat hardsuits favored by the Phalanx. They are utilitarian in design, and reportedly somewhat uncomfortable - though few of the non-Vaurcae bold enough to join Ve'katak seem to complain."
	icon = 'icons/clothing/under/uniforms/pmcg.dmi'
	icon_state = "phalanx-rep_jumpsuit"
	item_state = "phalanx-rep_jumpsuit"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/pmc/vekatak_phalanx/reserve
	name = "\improper Ve'katak Phalanx reserve uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has green shoulder stripes, identifying it as belonging to a Phalanx member that is not presently serving in an active combat role."
	icon_state = "phalanx-res_jumpsuit"
	item_state = "phalanx-res_jumpsuit"
