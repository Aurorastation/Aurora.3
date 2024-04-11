GLOBAL_LIST_EMPTY(all_robolimbs)
GLOBAL_LIST_EMPTY(internal_robolimbs)
GLOBAL_LIST_EMPTY(chargen_robolimbs)
GLOBAL_LIST_EMPTY(fabricator_robolimbs)
GLOBAL_DATUM(basic_robolimb, /datum/robolimb)

/proc/populate_robolimb_list()
	GLOB.basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		GLOB.all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			GLOB.chargen_robolimbs[R.company] = R
		if(R.fabricator_available)
			GLOB.fabricator_robolimbs[R.company] = R
		if(R.allows_internal)
			GLOB.internal_robolimbs[R.company] = R

/datum/robolimb
	/// Shown when selecting the limb.
	var/company = "Unbranded"
	/// Seen when examining a limb.
	var/desc = "A generic unbranded robotic prosthesis."
	/// Icon base to draw from.
	var/icon = 'icons/mob/human_races/ipc/robotic.dmi'
	/// If set, not available in character setup.
	var/unavailable_at_chargen
	/// If set, it appears as organic on examine, like synthskin.
	var/lifelike = FALSE
	/// Which species can use this prosthetic type.
	var/list/species_can_use = list(
		SPECIES_HUMAN,
		SPECIES_SKRELL,
		SPECIES_SKRELL_AXIORI,
		SPECIES_TAJARA,
		SPECIES_TAJARA_ZHAN,
		SPECIES_TAJARA_MSAI,
		SPECIES_UNATHI,
		SPECIES_VAURCA_WORKER,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_IPC,
		SPECIES_IPC_SHELL,
		SPECIES_IPC_BISHOP,
		SPECIES_HUMAN_OFFWORLD
	)
	/// If this prosthetic type is paintable.
	var/paintable = 0
	/// Which IPC species this prosthetic type will create.
	var/linked_frame = SPECIES_IPC_UNBRANDED
	/// How resistant this prosthetic type is to brute damage.
	var/brute_mod = 0.9
	/// How resistant this prosthetic type is to burn damage.
	var/burn_mod = 1.1
	/// If you can print this prosthetic type in the robotics fabricator.
	var/fabricator_available = FALSE
	/// Suffix used for the icon.
	var/internal_organ_suffix = "prosthetic"
	/// If this prosthetic type can be used for internal organs.
	var/allows_internal = TRUE
	/// What internal organs you can pick this prosthetic type for.
	var/list/allowed_internal_organs = list(
		BP_HEART,
		BP_EYES,
		BP_LUNGS,
		BP_LIVER,
		BP_KIDNEYS,
		BP_STOMACH
	)
	/// What external organs you can pick this prosthetic type for.
	var/list/allowed_external_organs = list(
		BP_L_ARM,
		BP_R_ARM,
		BP_L_HAND,
		BP_R_HAND,
		BP_L_LEG,
		BP_R_LEG,
		BP_L_FOOT,
		BP_R_FOOT
	)

/datum/robolimb/proc/malfunctioning_check()
	return FALSE

/datum/robolimb/bishop
	company = PROSTHETIC_BC
	desc = "This limb is coated in a brilliant silver illuminated from the inside with blue status lights."
	icon = 'icons/mob/human_races/ipc/r_ind_bishop.dmi'
	linked_frame = SPECIES_IPC_BISHOP
	fabricator_available = TRUE
	allows_internal = FALSE

/datum/robolimb/hesphaistos
	company = PROSTHETIC_HI
	desc = "This limb is covered in thick plating coated with a militaristic olive drab."
	icon = 'icons/mob/human_races/ipc/r_ind_hephaestus.dmi'
	linked_frame = SPECIES_IPC_G2
	fabricator_available = TRUE
	allows_internal = FALSE

/datum/robolimb/zenghu
	company = PROSTHETIC_ZH
	desc = "This limb has sleek white plating over a graphene-based nanofiber weave."
	icon = 'icons/mob/human_races/ipc/r_ind_zenghu.dmi'
	linked_frame = SPECIES_IPC_ZENGHU
	fabricator_available = TRUE
	allows_internal = FALSE

/datum/robolimb/xion
	company = PROSTHETIC_XMG
	desc = "This limb has a minimalist black and grey casing with exposed orange wiring channels."
	icon = 'icons/mob/human_races/ipc/r_ind_xion.dmi'
	linked_frame = SPECIES_IPC_XION
	fabricator_available = TRUE
	allows_internal = FALSE

/datum/robolimb/ipc
	company = PROSTHETIC_IPC
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/ipc/r_machine.dmi'
	unavailable_at_chargen = 1
	paintable = 1
	linked_frame = SPECIES_IPC
	fabricator_available = TRUE
	allows_internal = FALSE

/datum/robolimb/industrial
	company = PROSTHETIC_IND
	desc = "This limb is more robust than the standard Hephaestus Integrated Limb, and is better suited for industrial machinery."
	icon = 'icons/mob/human_races/ipc/r_industrial.dmi'
	unavailable_at_chargen = 1
	linked_frame = SPECIES_IPC_G1
	fabricator_available = TRUE
	allows_internal = FALSE

/datum/robolimb/terminator
	company = PROSTHETIC_HK
	desc = "A ludicrously complex prosthetic created for Purpose Hunter-Killers."
	icon = 'icons/mob/human_races/ipc/r_hunter_killer.dmi'
	unavailable_at_chargen = TRUE
	allows_internal = FALSE

/datum/robolimb/human
	company = PROSTHETIC_SYNTHSKIN
	desc = "This limb is designed to mimic the Human form. It does so with moderate success."
	icon = 'icons/mob/human_races/human/r_human.dmi'
	species_can_use = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	linked_frame = SPECIES_IPC_SHELL
	fabricator_available = TRUE
	paintable = TRUE
	lifelike = TRUE
	allows_internal = FALSE

/datum/robolimb/autakh
	company = PROSTHETIC_AUTAKH
	desc = "This limb has been designed by the Aut'akh unathi sect."
	icon = 'icons/mob/human_races/unathi/r_autakh.dmi'
	species_can_use = list(SPECIES_UNATHI)
	paintable = TRUE
	allows_internal = FALSE

/datum/robolimb/tesla
	company = PROSTHETIC_TESLA
	desc = "A limb designed to be used by the People's Republic of Adhomai Tesla Brigade. This civilian version is issued to disabled veterans and civilians."
	icon = 'icons/mob/human_races/tajara/tesla_limbs.dmi'
	species_can_use = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	internal_organ_suffix = "tesla"
	allowed_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_LIVER, BP_KIDNEYS, BP_STOMACH, BP_APPENDIX)

/datum/robolimb/tesla/malfunctioning_check(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/augment/tesla/T = H.internal_organs_by_name[BP_AUG_TESLA]
	if(T && !T.is_broken())
		return FALSE
	else
		return TRUE

/datum/robolimb/tesla/industrial
	company = PROSTHETIC_TESLA_BODY
	desc = "A heavy version of the Tesla prosthetics created for the Tesla Rejuvenation Suit"
	icon = 'icons/mob/human_races/tajara/industrial_tesla_limbs.dmi'
	species_can_use = list(SPECIES_TAJARA_TESLA_BODY)
	brute_mod = 0.7

/datum/robolimb/vaurca
	company = PROSTHETIC_VAURCA
	desc = "This limb design is from old Sedantis, still manufactured by the Hives when providing maintenace to most of the basic Vaurcesian bioforms."
	icon = 'icons/mob/human_races/vaurca/r_vaurcalimbs.dmi'
	species_can_use = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	allows_internal = FALSE

/datum/robolimb/hoplan
	company = PROSTHETIC_HOPLAN
	desc = "A refined helmet with an industrial lean. Extra plating seems to be applied to the top surface while the rest of the head features \
			small breaks in the armor and running lights. A polished screen hides four optic sensors behind a display."
	species_can_use = list(SPECIES_IPC)
	icon = 'icons/mob/human_races/ipc/hoplan.dmi'
	allowed_external_organs = list(BP_HEAD)

/datum/robolimb/indricus
	company = PROSTHETIC_INDRICUS
	desc = "One lens-like eye dominates this style of head, with a camera like adjustable segment, this head is entirely encased with no seams or \
			crevices bar service hatches."
	species_can_use = list(SPECIES_IPC)
	linked_frame = SPECIES_IPC
	icon = 'icons/mob/human_races/ipc/indricus.dmi'
	allowed_external_organs = list(BP_HEAD)

/datum/robolimb/raxus
	company = PROSTHETIC_RAXUS
	desc = "Imposing and bold, this angled helmet features a collection of small pin-prick optic sensors to make up for its lack of inherent eyes. \
			The top of the head extends outward, where the thinner point meets halfway down the face before extending in to a similarly wide jaw, \
			giving the head a shape almost like an cubic hourglass."
	species_can_use = list(SPECIES_IPC)
	linked_frame = SPECIES_IPC
	icon = 'icons/mob/human_races/ipc/raxus.dmi'
	allowed_external_organs = list(BP_HEAD)
