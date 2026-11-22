/obj/item/paper/crevus_brochure
	name = "tourist brochure"
	icon_state = "crevus_brochure"

/obj/item/paper/fluff/crevus/kitchen_note
	name = "to kitchen staff"
	info = {"
	There are sweets and main dishes in the freezer, ONLY to be served if you're unable to handle the crowd.
	<br><br> Don't let me catch you reheating them otherwise.
	"}

/obj/item/paper/fluff/crevus/pharmacy_note
	name = "suspicious delivery notice"
	info = {"
	As usual, everything in the package. Don't expect a new shipment anytime soon. Make sure the product is ready in time.
	"}

/obj/item/paper/fluff/crevus/key_note
	name = "RE: keys"
	info = {"
	Keep your keys secure or you'll be locked out of your office, there are no spares. We don't want to hear about any re-occurrances.
	"}

/obj/item/paper/fluff/crevus/the_lock_note
	name = "a reminder"
	info = {"
	They will find the hidden main entrance at the northern wall of the party area, he marked the floor with a red arrow pointing to the false wall, hard to miss.
	If they need to evacuate, the passage is at the southern wall of the production room, leading to the decrepit shack at the public park.
	"}

// ---------- Keys

/obj/item/key/door_key/crevus/rhan_cresh_patrol
	name = "Highway Enforcement Office Key"
	desc = "As the label suggests, this key ought to unlock something important."
	access_list = list(/datum/access/crevus_rhan_cresh)

/obj/item/key/door_key/crevus/azaula_enforcer
	name = "Azaula Entertainment Enforcer Office Key"
	desc = "As the label suggests, this key ought to unlock something important."
	access_list = list(/datum/access/crevus_azaula_enforcer)

/obj/item/key/door_key/crevus/the_lock
	name = "decrepit key"
	desc = "A key without label, who knows what it might unlock."
	access_list = list(/datum/access/crevus_the_lock)

/obj/item/key/door_key/crevus/casino
	name = "Casino Key"
	desc = "A key with \"Keltra Zav Nikal\" written in the label. Jackpot?"
	access_list = list(/datum/access/crevus_casino)

/obj/item/key/door_key/crevus/general_store
	name = "Ane-Mart Staff Key"
	desc = "A key with \"Ane-Mart\" written in the label."
	access_list = list(/datum/access/crevus_general_store)

/obj/item/key/door_key/crevus/firearm_store
	name = "Firearm Store Key"
	access_list = list(/datum/access/crevus_firearm_store)

/obj/item/key/door_key/crevus/nt_pharmacy
	name = "NanoTrasen Pharmacy Key"
	access_list = list(/datum/access/crevus_nt_pharmacy)

/obj/item/key/door_key/crevus/artisan_shop
	name = "Artisan Shop Key"
	access_list = list(/datum/access/crevus_artisan_shop)

/obj/item/key/door_key/crevus/clothing_store
	name = "Clothing Store Key"
	access_list = list(/datum/access/crevus_clothing_store)
