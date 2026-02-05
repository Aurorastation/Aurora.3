// This file contains assets for the Tau Ceti Armed Forces. Excludes some older TCFL assets.

// Intended for legionnaires that are expected to engage in combat.
/obj/item/clothing/under/legion/tcaf
	name = "\improper TCAF armsman's uniform"
	desc = "A black longsleeved top over rough khaki tactical pants. Designed for the use of on-ship legionnaires of the Tau Ceti Armed Forces."
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_armsman_uniform"
	item_state = "tcaf_armsman_uniform"
	worn_state = "tcaf_armsman_uniform"

// Generic gloves.
/obj/item/clothing/gloves/tcaf
	name = "\improper TCAF uniform gloves"
	desc = "A pair of khaki tactical gloves with reinforcement at the knuckles and an adjustable strap at the wrist."
	icon = 'icons/obj/item/clothing/gloves/tcaf_gloves.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_armsman_gloves"
	item_state = "tcaf_armsman_gloves"
	build_from_parts = TRUE
	worn_overlay = "over"

// Intended for legionnaires that aren't in active combat roles but are still expected to be able to fight if necessary, like ship crews, engineers, and medics.
/obj/item/clothing/under/legion/tcaf/technician
	name = "\improper TCAF technician's uniform"
	desc = "A plain drab jumpsuit trimmed with dark accents, designed to be cheap and stain-resistant. It could be more comfortable. Worn by members of the Tau Ceti Armed Forces that aren't in active combat roles, such as medical and engineering staff."
	icon = 'icons/obj/item/clothing/under/human/biesel/tcaf_uniform.dmi'
	contained_sprite = TRUE
	icon_state = "tcaf_technician_uniform"
	item_state = "tcaf_technician_uniform"
	worn_state = "tcaf_technician_uniform"

/obj/item/clothing/head/tcaf_technician
	name = "\improper TCAF technician's cap"
	desc = "A plain drab softcap, marked in a small manner at the front with the insignia of the Tau Ceti Armed Forces. Worn by members of the Tau Ceti Armed Forces that aren't in active combat roles, such as medical and engineering staff."
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	icon_state = "tcaf_technician_cap"
	item_state = "tcaf_technician_cap"
	contained_sprite = TRUE

// For specialist roles.
/obj/item/clothing/accessory/legion/specialist
	name = "specialist medallion"
	desc = "Two small medallions, one worn on the shoulder and the other worn on the chest. Meant to display the rank of specialist troops in the Tau Ceti Armed Forces."
	icon_state = "specialist_medallion"
	item_state = "specialist_medallion"
	overlay_state = "specialist_medallion"

// For any legionnaires with significant authority, including officers.
/obj/item/clothing/accessory/legion
	name = "seniority ribbons"
	desc = "A ribbon meant to attach to the chest and sling around the shoulder accompanied by two medallions, marking seniority in the Tau Ceti Armed Forces."
	icon_state = "senior_ribbon"
	item_state = "senior_ribbon"
	overlay_state = "senior_ribbon"
	slot = ACCESSORY_SLOT_CAPE
	flippable = TRUE

// Specifically for Prefects.
/obj/item/clothing/accessory/tcaf_prefect_pauldron
	name = "\improper TCAF prefect pauldron"
	desc = "A bright red hard pauldron to indicate the wearer has the rank of Prefect in the Tau Ceti Armed Forces."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor_attachments.dmi'
	icon_state = "tcaf_prefect_pauldron"
	item_state = "tcaf_prefect_pauldron"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

// Specifically for Senior Legionnaires.
/obj/item/clothing/accessory/tcaf_senior_legion_pauldron
	name = "\improper TCAF senior legionnaire pauldron"
	desc = "A blue hard pauldron to indicate the wearer has the rank of Senior Legionnaire in the Tau Ceti Armed Forces."
	icon = 'icons/obj/item/clothing/suit/armor/modular_armor/modular_armor_attachments.dmi'
	icon_state = "tcaf_senior_legion_pauldron"
	item_state = "tcaf_senior_legion_pauldron"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_GENERIC
	flippable = FALSE

// For officers that want to look like a One Piece villain.
/obj/item/clothing/suit/storage/toggle/tcaf_officer_greatcoat
	name = "\improper TCAF officer's greatcoat"
	desc = "This is a well-trimmed greatcoat worn by commissioned officers in the Tau Ceti Armed Forces, such as by a Decurion or Captain. The fabric seems quite robust, but not particularly well used."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/tcaf_coat.dmi'
	icon_state = "tcaf_officer_coat"
	item_state = "tcaf_officer_coat"
	contained_sprite = TRUE
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	protects_against_weather = TRUE

/obj/item/clothing/head/tcaf_officer
	name = "\improper TCAF officer's cap"
	desc = "This is a peaked cap bearing the colours and insignia of the Tau Ceti Armed Forces, typically worn by commissioned officers therein. It looks like it'd fly off one's head very easily in windy weather."
	icon = 'icons/obj/item/clothing/head/tcaf_hats.dmi'
	icon_state = "tcaf_officer_cap"
	item_state = "tcaf_officer_cap"
	contained_sprite = TRUE

/obj/item/clothing/under/legion/tcaf_officer
	name = "\improper TCAF officer's uniform"
	desc = "A pristine, well-ironed, and perfectly cleaned white jumpsuit with black trimmings, worn by commissioned officers of the Tau Ceti Armed Forces. Who wears a white uniform but someone who intends never to dirty it?"
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
