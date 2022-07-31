var/global/list/all_robolimbs = list()
var/global/list/internal_robolimbs = list()
var/global/list/chargen_robolimbs = list()
var/global/list/fabricator_robolimbs = list()
var/global/datum/robolimb/basic_robolimb

/proc/populate_robolimb_list()
	basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			chargen_robolimbs[R.company] = R
		if(R.fabricator_available)
			fabricator_robolimbs[R.company] = R
		if(R.allows_internal)
			internal_robolimbs[R.company] = R

/datum/robolimb
	var/company = "Unbranded"                            // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/ipc/robotic.dmi'   // Icon base to draw from.
	var/unavailable_at_chargen                           // If set, not available at chargen.
	var/lifelike = FALSE                                 // If set, appears organic.
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
	var/paintable = 0 //tired of istype exceptions. bullshit to find, and by god do i know it after this project.
	var/linked_frame = SPECIES_IPC_UNBRANDED //which machine species this limb will create
	var/brute_mod = 0.9 //how resistant is this mode to brute damage
	var/burn_mod = 1.1 //how resistant is this mode to burn damage
	var/fabricator_available = FALSE //if you can print this limb in the robotics fabricator
	var/internal_organ_suffix = "prosthetic" //this is used to define the icon
	var/list/allowed_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_LIVER, BP_KIDNEYS, BP_STOMACH)//what organs can be augmented by this brand
	var/allows_internal = TRUE

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
	desc = "A ludicrously expensive and EMP shielded component, these types of limbs are best suited for highly specialized cyborgs."
	icon = 'icons/mob/human_races/ipc/r_terminator.dmi'
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

/datum/robolimb/vaurca
	company = PROSTHETIC_VAURCA
	desc = "This limb design is from old Sedantis, still manufactured by the Hives when providing maintenace to most of the basic Vaurcesian bioforms."
	icon = 'icons/mob/human_races/vaurca/r_vaurcalimbs.dmi'
	species_can_use = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	allows_internal = FALSE