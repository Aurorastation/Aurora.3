var/global/list/all_robolimbs = list()
var/global/list/chargen_robolimbs = list()
var/global/datum/robolimb/basic_robolimb

/proc/populate_robolimb_list()
	basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			chargen_robolimbs[R.company] = R

/datum/robolimb
	var/company = "Unbranded"                            // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/robotic.dmi'       // Icon base to draw from.
	var/unavailable_at_chargen                           // If set, not available at chargen.
	var/list/species_can_use = list(
		"Human",
		"Skrell",
		"Tajara",
		"Zhan-Khazan Tajara",
		"M'sai Tajara",
		"Unathi",
		"Vaurca Worker",
		"Vaurca Warrior",
		"Baseline Frame"
	)
	var/paintable = 0 //tired of istype exceptions. bullshirt to find, and by god do i know it after this project.
	var/linked_frame = "Unbranded Frame" //which machine species this limb will create

/datum/robolimb/bishop
	company = PROSTHETIC_BC
	desc = "This limb is coated in a brilliant silver illuminated from the inside with blue status lights."
	icon = 'icons/mob/human_races/r_ind_bishop.dmi'
	linked_frame = "Bishop Accessory Frame"

/datum/robolimb/hesphaistos
	company = PROSTHETIC_HI
	desc = "This limb is covered in thick plating coated with a militaristic olive drab."
	icon = 'icons/mob/human_races/r_ind_hephaestus.dmi'
	linked_frame = "Hephaestus G2 Industrial Frame"

/datum/robolimb/zenghu
	company = PROSTHETIC_ZH
	desc = "This limb has sleek white plating over a graphene-based nanofiber weave."
	icon = 'icons/mob/human_races/r_ind_zenghu.dmi'
	linked_frame = "Zeng-Hu Mobility Frame"

/datum/robolimb/xion
	company = PROSTHETIC_XMG
	desc = "This limb has a minimalist black and grey casing with exposed orange wiring channels."
	icon = 'icons/mob/human_races/r_ind_xion.dmi'
	linked_frame = "Xion Industrial Frame"

/datum/robolimb/ipc
	company = PROSTHETIC_IPC
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/r_machine.dmi'
	unavailable_at_chargen = 1
	paintable = 1
	linked_frame = "Baseline Frame"

/datum/robolimb/industrial
	company = PROSTHETIC_IND
	desc = "This limb is more robust than the standard Hephaestus Integrated Limb, and is better suited for industrial machinery."
	icon = 'icons/mob/human_races/r_industrial.dmi'
	unavailable_at_chargen = 1
	linked_frame = "Hephaestus G1 Industrial Frame"

/datum/robolimb/terminator
	company = PROSTHETIC_HK
	desc = "A ludicrously expensive and EMP shielded component, these types of limbs are best suited for highly specialized cyborgs."
	icon = 'icons/mob/human_races/r_terminator.dmi'
	unavailable_at_chargen = 1

/datum/robolimb/human
	company = PROSTHETIC_SYNTHSKIN
	desc = "This limb is designed to mimic the Human form. It does so with moderate success."
	icon = 'icons/mob/human_races/r_human.dmi'
	species_can_use = list("Human")
	linked_frame = "Shell Frame"

/datum/robolimb/autakh
	company = PROSTHETIC_AUTAKH
	desc = "This limb has been designed by the Aut'akh sect, it was created to interact exclusively with their bodies and implants."
	icon = 'icons/mob/human_races/r_autakh.dmi'
	species_can_use = list("Aut'akh Unathi")
	linked_frame = "Aut'akh Unathi"
	unavailable_at_chargen = 1
	paintable = 1