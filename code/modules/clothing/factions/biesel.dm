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
	name = "\improper TCAF combat gloves"
	desc = "A pair of khaki tactical gloves with reinforcement at the knuckles and an adjustable strap at the wrist. Designed for use by the TCAF's Republic Espatiers and Home Defence Forces."
	icon = 'icons/obj/item/clothing/gloves/tcaf_gloves.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_combat_gloves"
	item_state = "tcaf_combat_gloves"
	build_from_parts = TRUE
	worn_overlay = "over"

// Intended for enlisted vessel crew of the TCAF's Astroforces
/obj/item/clothing/under/tcaf/crew
	name = "\improper TCAF-RAF crew uniform"
	desc = "A blue jumpsuit trimmed with dark accents, designed to be cheap and stain-resistant. It could be more comfortable. Worn by enlisted crewmembers of the TCAF's Republic Astroforce."
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_raf_crew"
	item_state = "tcaf_raf_crew"
	worn_state = "tcaf_raf_crew"

/obj/item/clothing/under/tcaf/crew/foreign_legion
	name = "\improper TCAF-RAF foreign legion crew uniform"
	desc = "A blue jumpsuit with red accenting, designed to be cheap and stain-resistant. It could be more comfortable. Worn by enlisted crewmembers of the TCAF's Republic Astroforce Foreign Legions corps."
	icon_state = "tcaf_raf_foreign_legion"
	item_state = "tcaf_raf_foreign_legion"
	worn_state = "tcaf_raf_foreign_legion"

// For specialist legionnaires
/obj/item/clothing/accessory/tcaf/immunis
	name = "legionnaire immuni medallions"
	desc = "Two small gold medallions, one worn on the shoulder and the other worn on the chest. They denote the rank of Legionnaire Imminus, a specialist enlisted member immune from menial taskings."
	icon_state = "tcaf_immuni_medallions"
	item_state = "tcaf_immuni_medallions"
	overlay_state = "tcaf_immuni_medallions"

// For astrachs
/obj/item/clothing/accessory/tcaf/astrarch
	name = "arch medallions"
	desc = "A gold ribbon meant to attach to the chest and sling around the shoulder accompanied by two platinum medallions. They denote the rank of Astrarch or Planarch depending on service branch, roughly equivalent to a Captain."
	icon_state = "tcaf_astrarch_medallions"
	item_state = "tcaf_astrarch_medallions"
	overlay_state = "tcaf_astrarch_medallions"
	slot = ACCESSORY_SLOT_CAPE
	flippable = TRUE

/obj/item/clothing/accessory/tcaf/legate
	name = "legate medallions"
	desc = "A gold ribbon meant to attach to the chest and sling around the shoulder accompanied by two enamelled phoron medallions. They denote the rank of Legate, roughly equivalent to a General or Admiral."
	icon_state = "tcaf_legate_medallions"
	item_state = "tcaf_legate_medallions"
	overlay_state = "tcaf_legate_medallions"
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
	name = "\improper TCAF astroforces officer greatcoat"
	desc = "This is a well-trimmed greatcoat worn by commissioned officers in the TCAF's Republic Astroforce. The fabric seems quite robust, but not particularly well used."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/tcaf_coat.dmi'
	icon_state = "tcaf_officer_coat"
	item_state = "tcaf_officer_coat"
	contained_sprite = TRUE
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	protects_against_weather = TRUE

/obj/item/clothing/head/tcaf_officer
	name = "\improper TCAF astroforces officer cap"
	desc = "This is a peaked cap bearing the colours and insignia of the TCAF's Republic Astroforce, typically worn by commissioned officers therein. It looks like it'd fly off one's head very easily in windy weather."
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	icon_state = "tcaf_officer_cap"
	item_state = "tcaf_officer_cap"
	contained_sprite = TRUE

/obj/item/clothing/under/tcaf_officer
	name = "\improper TCAF astroforces officer uniform"
	desc = "A pristine, well-ironed, and perfectly cleaned white jumpsuit with black trimmings, worn by commissioned officers of the TCAF's Republic Astroforce. Who wears a white uniform but someone who intends never to dirty it?"
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_raf_officer_uniform"
	item_state = "tcaf_raf_officer_uniform"
	worn_state = "tcaf_raf_officer_uniform"

/obj/item/clothing/head/softcap/tcaf_cap
	name = "TCAF uniform cap"
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	desc = "A rugged blue softcap bearing the insignia of the Tau Ceti Armed Forces, the military of the Republic of Biesel."
	icon_state = "tcaf_cap"
	item_state = "tcaf_cap"
