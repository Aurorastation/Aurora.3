/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	item_state = "labcoat" // used for inhands and onmobs. ESPECIALLY FOR CONTAINED SPRITES
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper, /obj/item/device/breath_analyzer)
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)
	opened = TRUE // spawns opened

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo"
	item_state = "labcoat_cmo"
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer labcoat"
	desc = "A labcoat with command blue highlights."
	icon_state = "labcoat_cmoalt"
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt2
	name = "chief medical officer labcoat"
	desc = "A labcoat with command gold highlights."
	icon_state = "labcoat_cmoalt2"
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/suit/storage/toggle/labcoat/genetics
	name = "geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen"

/obj/item/clothing/suit/storage/toggle/labcoat/medical
	name = "medical labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_med"

/obj/item/clothing/suit/storage/toggle/labcoat/pharmacist
	name = "pharmacist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem"

/obj/item/clothing/suit/storage/toggle/labcoat/biochemist
	name = "protective labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a red stripe on the shoulder."
	icon_state = "labcoat_vir"

/obj/item/clothing/suit/storage/toggle/labcoat/psych
	name = "psychiatrist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a teal stripe on the shoulder."
	icon_state = "labcoat_psych"

/obj/item/clothing/suit/storage/toggle/labcoat/surgeon
	name = "surgeon labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a light blue stripe on the shoulder."
	icon_state = "labcoat_surgeon"

/obj/item/clothing/suit/storage/toggle/labcoat/trauma
	name = "trauma physician labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a black stripe on the shoulder."
	icon_state = "labcoat_trauma"

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox"

/obj/item/clothing/suit/storage/iacvest
	desc = "It's a lightweight vest. Made of a dark, navy mesh with highly-reflective white material, designed to be worn by the Interstellar Aid Corps as a high-visibility vest, over any other clothing. The I.A.C. logo is prominently  displayed on the back of the vest, between the shoulders."
	name = "IAC vest"
	icon_state = "iac_vest"
	item_state = "iac_vest"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/suit/storage/toggle/labcoat/zeng
	name = "zeng-hu labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Comes in Zeng-Hu colours."
	icon_state = "labcoat_zeng"

/obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	icon_state = "labcoat_zeng_alt"

/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	name = "Zavodskoi Interstellar labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Comes in Zavodskoi Interstellar colours."
	icon_state = "labcoat_necro"

/obj/item/clothing/suit/storage/toggle/labcoat/heph
	name = "hephaestus labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Comes in Hephaestus colours."
	icon_state = "labcoat_heph"
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/suit/storage/toggle/labcoat/iac
	name = "iac labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Comes in IAC colors."
	icon_state = "labcoat_iac"
	item_state = "labcoat_iac"
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)
