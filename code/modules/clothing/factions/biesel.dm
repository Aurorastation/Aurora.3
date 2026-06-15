// This file contains assets for the Tau Ceti Armed Forces.

// Intended for espatiers/marines of the TCAF's Astroforces
/obj/item/clothing/under/tcaf/espatier
	name = "\improper TCAF-RAF espatier uniform"
	desc = "A black longsleeved top over rough khaki tactical pants. Designed for the use of espatiers of the TCAF's Republic Astroforce."
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_espatier_uniform"
	item_state = "tcaf_espatier_uniform"
	worn_state = "tcaf_espatier_uniform"

// Generic gloves.
/obj/item/clothing/gloves/tcaf
	name = "\improper TCAF uniform gloves"
	desc = "A pair of khaki tactical gloves with reinforcement at the knuckles and an adjustable strap at the wrist."
	icon = 'icons/obj/item/clothing/gloves/tcaf_gloves.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_espatier_gloves"
	item_state = "tcaf_espatier_gloves"
	build_from_parts = TRUE
	worn_overlay = "over"

// Intended for enlisted vessel crew of the TCAF's Astroforces
/obj/item/clothing/under/tcaf/rate
	name = "\improper TCAF-RAF rate uniform"
	desc = "A plain drab jumpsuit trimmed with dark accents, designed to be cheap and stain-resistant. It could be more comfortable. Worn by enlisted crewmembers of the TCAF's Republic Astroforce."
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_rate_uniform"
	item_state = "tcaf_rate_uniform"
	worn_state = "tcaf_rate_uniform"

/obj/item/clothing/head/tcaf_rate
	name = "\improper TCAF-RAF rate cap"
	desc = "A plain drab softcap, marked in a small manner at the front with the insignia of the Republic Astroforce. Worn by enlisted crewmembers of the TCAF's Republic Astroforce."
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	icon_state = "tcaf_rate_cap"
	item_state = "tcaf_rate_cap"
	contained_sprite = TRUE

// For specialist legionnaires
/obj/item/clothing/accessory/tcaf/immunis
	name = "legionnaire immuni medallion"
	desc = "Two small gold medallions, one worn on the shoulder and the other worn on the chest. They denote the rank of Legionnaire Imminus, a specialist enlisted member immune from menial taskings."
	icon_state = "specialist_medallion"
	item_state = "specialist_medallion"
	overlay_state = "specialist_medallion"

// For astrachs
/obj/item/clothing/accessory/tcaf/astrarch
	name = "astrarch medallions"
	desc = "A gold ribbon meant to attach to the chest and sling around the shoulder accompanied by two platinum medallions. They denote the rank of Astrarch or Planarch depending on service branch, roughly equivalent to a Captain."
	icon_state = "senior_ribbon"
	item_state = "senior_ribbon"
	overlay_state = "senior_ribbon"
	slot = ACCESSORY_SLOT_CAPE
	flippable = TRUE

// Specifically for Prefects.
/obj/item/clothing/accessory/tcaf_prefect_pauldron
	name = "\improper TCAF prefect pauldron"
	desc = "A bright red hard pauldron with three gold medallions attached to it. They denote the rank of Principal Prefect during combat situations."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor_attachments.dmi'
	icon_state = "tcaf_prefect_pauldron"
	item_state = "tcaf_prefect_pauldron"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

// Specifically for Principal Prefects.
/obj/item/clothing/accessory/tcaf_principal_prefect_pauldron
	name = "\improper TCAF principal prefect pauldron"
	desc = "A blue hard pauldron with a platinum medallion attached to it. They denote the rank of Principal Prefect during combat situations."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor_attachments.dmi'
	icon_state = "tcaf_principal_prefect_pauldron"
	item_state = "tcaf_principal_prefect_pauldron"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

// For officers that want to look like a One Piece villain.
/obj/item/clothing/suit/storage/toggle/tcaf_officer_greatcoat
	name = "\improper TCAF-RAF officer greatcoat"
	desc = "This is a well-trimmed greatcoat worn by commissioned officers in the TCAF's Republic Astroforce. The fabric seems quite robust, but not particularly well used."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/tcaf_coat.dmi'
	icon_state = "tcaf_officer_coat"
	item_state = "tcaf_officer_coat"
	contained_sprite = TRUE
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	protects_against_weather = TRUE

/obj/item/clothing/head/tcaf_officer
	name = "\improper TCAF-RAF officer cap"
	desc = "This is a peaked cap bearing the colours and insignia of the TCAF's Republic Astroforce, typically worn by commissioned officers therein. It looks like it'd fly off one's head very easily in windy weather."
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	icon_state = "tcaf_officer_cap"
	item_state = "tcaf_officer_cap"
	contained_sprite = TRUE

/obj/item/clothing/under/tcaf_officer
	name = "\improper TCAF officer uniform"
	desc = "A pristine, well-ironed, and perfectly cleaned white jumpsuit with black trimmings, worn by commissioned officers of the TCAF's Republic Astroforce. Who wears a white uniform but someone who intends never to dirty it?"
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_officer_uniform"
	item_state = "tcaf_officer_uniform"
	worn_state = "tcaf_officer_uniform"

// Identical sprites to the TCFL variant, just reflavoured.
/obj/item/clothing/head/softcap/tcaf_cap
	name = "TCAF uniform cap"
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	desc = "A rugged blue softcap bearing the insignia of the Tau Ceti Armed Forces, the military of the Republic of Biesel."
	icon_state = "tcaf_cap"
	item_state = "tcaf_cap"
