/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon = 'icons/mob/clothing/suit/labcoat.dmi'
	contained_sprite = TRUE
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

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer labcoat"
	desc = "A labcoat with command blue highlights."
	icon_state = "labcoat_cmoalt"

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt2
	name = "chief medical officer labcoat"
	desc = "A labcoat with command gold highlights."
	icon_state = "labcoat_cmoalt2"

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_sci"



/obj/item/clothing/suit/storage/toggle/labcoat/nt
	name = "nt labcoat"
	icon_state = "labcoat_nt"

/obj/item/clothing/suit/storage/toggle/labcoat/zeng
	name = "zeng-hu labcoat"
	icon_state = "labcoat_zeng"

/obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	icon_state = "labcoat_zeng_alt"

/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	name = "zavodskoi interstellar labcoat"
	icon_state = "labcoat_zav"

/obj/item/clothing/suit/storage/toggle/labcoat/heph
	name = "hephaestus labcoat"
	icon_state = "labcoat_heph"

/obj/item/clothing/suit/storage/toggle/labcoat/pmc
	name = "PMCG labcoat"
	icon_state = "labcoat_pmc"

/obj/item/clothing/suit/storage/toggle/labcoat/pmc/alt
	icon_state = "labcoat_pmc_alt"

/obj/item/clothing/suit/storage/toggle/labcoat/iac
	name = "iac labcoat"
	icon_state = "labcoat_iac"
	item_state = "labcoat_iac"

/obj/item/clothing/suit/storage/toggle/labcoat/idris
	name = "idris labcoat"
	icon_state = "labcoat_idris"
	item_state = "labcoat_idris"

/obj/item/clothing/suit/storage/toggle/labcoat/idris/alt
	icon_state = "labcoat_idris_alt"
	item_state = "labcoat_idris_alt"
