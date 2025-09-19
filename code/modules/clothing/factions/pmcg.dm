#define MODSUIT_REGULAR "Regular"
#define MODSUIT_SHORTSLEEVE "Shortsleeve"
#define MODSUIT_PANTS "Pants"
#define MODSUIT_SHORTS "Shorts"

// PMCG Modsuit
/obj/item/clothing/under/pmc_modsuit
	name = "\improper PMCG modsuit"
	desc = "A modular fatigue jumpsuit, from the Private Military Contracting Group."
	desc_extended = "The proprietary PMCG Modular Fatigue Jumpsuit, quickly dubbed the modsuit, is an innovation by the recently-formed PMCG to quickly outfit its scores of new \
	hires and acquisitions at economic production costs. Designed to fit military contractors of a wide range of sizes, species, and operating environments with tolerable comfort, \
	the modsuit features a number of smart-fabric connection points for the modern contractor to modify their uniform to a number of preset configurations."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "pmcg_modsuit"
	item_state = "pmcg_modsuit"
	contained_sprite = TRUE
	action_button_name = "Change Modsuit"

	/// The current display mode of the modsuit
	var/modsuit_mode = MODSUIT_REGULAR

	/// The possible options the modsuit can be configured into, it's a key value list which get populated in Initialize, the key is the name of the mode, while the value is the icon for the radial menu
	var/list/configuration_options = list(
		MODSUIT_REGULAR,
		MODSUIT_SHORTSLEEVE,
		MODSUIT_PANTS,
		MODSUIT_SHORTS
	)

/obj/item/clothing/under/pmc_modsuit/Initialize()
	. = ..()
	for(var/option in configuration_options)
		configuration_options[option] = image('icons/obj/item/clothing/department_uniforms/security.dmi', initial(icon_state) + "_" + option)

/obj/item/clothing/under/pmc_modsuit/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("It's currently in the [SPAN_BOLD("[modsuit_mode]")] configuration.")

/obj/item/clothing/under/pmc_modsuit/attack_self(mob/user)
	select_modsuit(user)

/// Opens the radial menu to let the user select their modsuit configuration
/obj/item/clothing/under/pmc_modsuit/proc/select_modsuit(mob/user)
	var/modsuit_choice = RADIAL_INPUT(user, configuration_options)
	if(!modsuit_choice)
		return

	modsuit_mode = modsuit_choice
	selected_modsuit(user)

/// Updates the clothing icon with the new modsuit_mode
/obj/item/clothing/under/pmc_modsuit/proc/selected_modsuit(mob/user)
	icon_state = initial(icon_state) + "_[modsuit_mode]"
	item_state = initial(item_state) + "_[modsuit_mode]"
	update_clothing_icon()
	if(user)
		user.update_action_buttons()

/obj/item/clothing/under/pmc_modsuit/verb/change_modsuit()
	set name = "Change Modsuit"
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr))
		return

	select_modsuit(usr)

#undef MODSUIT_REGULAR
#undef MODSUIT_SHORTSLEEVE
#undef MODSUIT_PANTS
#undef MODSUIT_SHORTS

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

/obj/item/clothing/under/rank/medical/paramedic/pmc/vekatak_phalanx
	name = "\improper Ve'katak Phalanx medical uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has dark blue shoulder stripes and ornamentation, identifying it as belonging to a Phalanx medic in the employ of the Private Military Contracting Group."
	desc_extended = "These uniforms are designed to fit under the combat hardsuits favored by the Phalanx. They are utilitarian in design, and reportedly somewhat uncomfortable - though few of the non-Vaurcae bold enough to join Ve'katak seem to complain."
	icon_state = "phalanx-med_jumpsuit"
	item_state = "phalanx-med_jumpsuit"

/obj/item/clothing/under/rank/pmc/vekatak_phalanx
	name = "\improper Ve'katak Phalanx representative uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has ice blue shoulder stripes, identifying it as belonging to a Phalanx member that is representing the direct interests of the Phalanx and their immediate employers."
	desc_extended = "These uniforms are designed to fit under the combat hardsuits favored by the Phalanx. They are utilitarian in design, and reportedly somewhat uncomfortable - though few of the non-Vaurcae bold enough to join Ve'katak seem to complain."
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	icon_state = "phalanx-rep_jumpsuit"
	item_state = "phalanx-rep_jumpsuit"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/pmc/vekatak_phalanx/reserve
	name = "\improper Ve'katak Phalanx reserve uniform"
	desc = "A uniform used by the forces of the Ve'katak Phalanx, a Vaurca-run private military company. This one has green shoulder stripes, identifying it as belonging to a Phalanx member that is not presently serving in an active combat role."
	icon_state = "phalanx-res_jumpsuit"
	item_state = "phalanx-res_jumpsuit"

/obj/item/clothing/under/rank/security/pmc/grupo_amapola
	name = "Grupo Amapola uniform"
	desc = "A uniform used by the forces of the Grupo Amapola, a private military company originating out of Mictlan. It is based off the old uniforms of the Mictlan Defense Force, a once-Solarian planetary guard, with red poppy patches on the back and right arm."
	desc_extended = "The Grupo Amapola's light green camo is taken from old uniforms of the Mictlan Defense Force, the same uniforms used by the insurgents known as the Samaritans. Many MDF service personnel defected to the Samaritans, and after the fighting between the Tau Ceti Armed Forces and Samaritans ended, the less scrupulous among their number now work for Grupo Amapola."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "amapola_ftg"
	item_state = "amapola_ftg"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/security/pmc/nexus
	name = "Nexus Corporate Security uniform"
	desc= "A uniform used by employees of Nexus Corporate Security, a subsidiary of NanoTrasen. Despite being technically a separate entity, Nexus's security uniforms still bare resemblance to its parent company's now largely defunct security division."
	icon_state = "nexus_officer"
	item_state = "nexus_officer"

/obj/item/clothing/under/rank/medical/paramedic/pmc/nexus
	name = "Nexus Corporate Security paramedic uniform"
	desc= "A uniform used by employees of Nexus Corporate Security, a subsidiary of NanoTrasen. The predominantly black colour identifies the wearer as a member of Nexus's medical division, with the leg cuffs further specifying them being a paramedic."
	desc_extended = "More rugged than traditional medical attire, Nexus's uniforms are designed to be comfortable in every environment, be it the sterile hallways of a Mendell clinic or the battered roads of Mictlan."
	icon_state = "nexus_emt"
	item_state = "nexus_emt"

/obj/item/clothing/under/rank/medical/pmc/nexus
	name = "Nexus Corporate Security medic uniform"
	desc= "A uniform used by employees of Nexus Corporate Security, a subsidiary of NanoTrasen. The predominantly black colour identifies the wearer as a member of Nexus's medical division."
	desc_extended = "More rugged than traditional medical attire, Nexus's uniforms are designed to be comfortable in every environment, be it the sterile hallways of a Mendell clinic or the battered roads of Mictlan."
	icon_state = "nexus_med"
	item_state = "nexus_med"

/obj/item/clothing/under/rank/security/pmc/kog/uniform
	name = "Kazarrhaldiye Operations Group security uniform"
	desc= "A uniform used by employees of Kazarrhaldiye Operations Group, a Tajaran mercenary company originating from Little Adhomai."
	desc_extended = "Kazarrhaldiye Operations Group uniforms are based on First Revolution-era naval uniforms. With modern clothing materials, these uniforms were redesigned to be much lighter and breathable for use in Human-environments. Despite the white coloration, a holdover from the snowy fields of Adhomai, the uniform remains popular."
	icon_state = "kog_security"
	item_state = "kog_security"
	contained_sprite = TRUE
	no_overheat = TRUE

/obj/item/clothing/under/rank/medical/pmc/kog/medical
	name = "Kazarrhaldiye Operations Group medical uniform"
	desc= "A uniform used by employees of Kazarrhaldiye Operations Group, a Tajaran mercenary company originating from Little Adhomai. The green accents identifies the wearer as a member of the KOG's medical corp, also known as Messa's Men."
	desc_extended = "Kazarrhaldiye Operations Group uniforms are based on First Revolution-era naval uniforms. With modern clothing materials, these uniforms were redesigned to be much lighter and breathable for use in Human-environments. Despite the white coloration, a holdover from the snowy fields of Adhomai, the uniform remains popular."
	icon_state = "kog_medical"
	item_state = "kog_medical"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/armor/kog/
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	contained_sprite = TRUE
	opened = FALSE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/storage/toggle/armor/kog/officer
	name = "Kazarrhaldiye Operations Group officer jacket"
	desc= "A jacket used by employees of Kazarrhaldiye Operations Group, a Tajaran mercenary company originating from Little Adhomai. The bronze trim identifies the wearer as a Security Officer."
	desc_extended = "Kazarrhaldiye Operations Group uniform jackets were originally based on First Revolution-era designs made with modern materials. These rugged and durable jackets were popular across the mercenary group for being a fashionable yet practical part of the uniform. Following the first SCC-based contracts by the KOG, many jackets were refitted to utilize special trims denoting role."
	icon_state = "kog_officer"
	item_state = "kog_officer"


/obj/item/clothing/suit/storage/toggle/armor/kog/warden
	name = "Kazarrhaldiye Operations Group warden jacket"
	desc= "A jacket used by employees of Kazarrhaldiye Operations Group, a Tajaran mercenary company originating from Little Adhomai. The silver trim identifies the wearer as a Warden."
	desc_extended = "Kazarrhaldiye Operations Group uniform jackets were originally based on First Revolution-era designs made with modern materials. These rugged and durable jackets were popular across the mercenary group for being a fashionable yet practical part of the uniform. Following the first SCC-based contracts by the KOG, many jackets were refitted to utilize special trims denoting role."
	icon_state = "kog_warden"
	item_state = "kog_warden"

/obj/item/clothing/suit/storage/toggle/armor/kog/commander
	name = "Kazarrhaldiye Operations Group head of security jacket"
	desc= "A jacket used by employees of Kazarrhaldiye Operations Group, a Tajaran mercenary company originating from Little Adhomai. The gold trim identifies the wearer as a Head of Security."
	desc_extended = "Kazarrhaldiye Operations Group uniform jackets were originally based on First Revolution-era designs made with modern materials. These rugged and durable jackets were popular across the mercenary group for being a fashionable yet practical part of the uniform. Following the first SCC-based contracts by the KOG, many jackets were refitted to utilize special trims denoting role."
	icon_state = "kog_commander"
	item_state = "kog_commander"

/obj/item/clothing/suit/storage/toggle/labcoat/kog
	icon = 'icons/obj/item/clothing/department_uniforms/medical.dmi'
	name = "Kazarrhaldiye Operations Group medical jacket"
	desc= "A jacket used by employees of Kazarrhaldiye Operations Group, a Tajaran mercenary company originating from Little Adhomai. The bronze trim identifies the wearer as a member of the KOG's medical corp, also known as Messa's Men."
	desc_extended = "Kazarrhaldiye Operations Group uniform jackets were originally based on First Revolution-era designs made with modern materials. These rugged and durable jackets were popular across the mercenary group for being a fashionable yet practical part of the uniform. Following the first SCC-based contracts by the KOG, many jackets were refitted to utilize special trims denoting role."
	icon_state = "kog_medical_jacket"
	item_state = "kog_medical_jacket"
	opened = FALSE
