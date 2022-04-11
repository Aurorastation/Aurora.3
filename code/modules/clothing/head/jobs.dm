//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"

/obj/item/clothing/head/chefhat/nt
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_chef_hat"
	item_state = "nt_chef_hat"

/obj/item/clothing/head/chefhat/idris
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "idris_chef_hat"
	item_state = "idris_chef_hat"


/obj/item/clothing/head/surgery/hairnet
	name = "hairnet"
	desc = "A hairnet used to keep the hair out of the way and out of the food."
	icon_state = "hairnet"
	item_state = "hairnet"
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi'
		)
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
		)

//HOP
/obj/item/clothing/head/caphat/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"

/obj/item/clothing/head/caphat/xo
	name = "executive officer cap"
	desc = "A stylish cap issued to SCC executive officers."
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	contained_sprite = TRUE
	icon_state = "executive_officer_cap"
	item_state = "executive_officer_cap"

/obj/item/clothing/head/caphat/bridge_crew
	name = "bridge crew cap"
	desc = "A stylish cap issued to the SCC bridge crew."
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	contained_sprite = TRUE
	icon_state = "bridge_officer_cap"
	item_state = "bridge_officer_cap"

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "chaplain's hood"
	desc = "It's hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	flags_inv = BLOCKHAIR

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inv = BLOCKHAIR

//Medical
/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgcap_blue"
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/surgery/purple
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is deep purple."
	icon_state = "surgcap_purple"

/obj/item/clothing/head/surgery/blue
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is baby blue."
	icon_state = "surgcap_blue"

/obj/item/clothing/head/surgery/green
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is dark green."
	icon_state = "surgcap_green"

/obj/item/clothing/head/surgery/black
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is black."
	icon_state = "surgcap_black"

/obj/item/clothing/head/surgery/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	contained_sprite = TRUE
	icon_state = "surgcap_nt"
	item_state = "surgcap_nt"

/obj/item/clothing/head/surgery/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	contained_sprite = TRUE
	icon_state = "surgcap_zeng"
	item_state = "surgcap_zeng"

/obj/item/clothing/head/surgery/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	contained_sprite = TRUE
	icon_state = "surgcap_epmc"
	item_state = "surgcap_epmc"

//Detective

/obj/item/clothing/head/det
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."
	icon_state = "brown_fedora"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat"
		)
	allowed = list(/obj/item/reagent_containers/food/snacks/candy_corn, /obj/item/pen)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
	)
	siemens_coefficient = 0.75

/obj/item/clothing/head/det/grey
	icon_state = "grey_fedora"
	desc = "A grey fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/warden
	name = "warden hat"
	desc = "A blue warden hat. For showing who is in charge of the brig."
	icon = 'icons/obj/clothing/hats/security.dmi'
	icon_state = "warden"
	item_state = "warden"
	flags_inv = HIDEEARS
	contained_sprite = TRUE

/obj/item/clothing/head/warden/corp
	name = "corporate warden hat"
	desc = "A black warden parade hat. For showing who is in charge of the brig."
	icon_state = "corp"
	item_state = "corp"

/obj/item/clothing/head/warden/zavod
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "zav_warden_hat"
	item_state = "zav_warden_hat"
	contained_sprite = TRUE

/obj/item/clothing/head/warden/pmc
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "epmc_warden_hat"
	item_state = "epmc_warden_hat"
	contained_sprite = TRUE

/obj/item/clothing/head/warden/idris
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "idris_warden_hat"
	item_state = "idris_warden_hat"
	contained_sprite = TRUE

/obj/item/clothing/head/hos
	name = "head of security hat"
	desc = "The navy blue parade hat of the Head of Security. For showing the officers who's in charge."
	icon = 'icons/obj/clothing/hats/security.dmi'
	icon_state = "hos"
	item_state = "hos"
	flags_inv = HIDEEARS
	contained_sprite = TRUE

/obj/item/clothing/head/hos/scc
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	icon_state = "hos_hat"
	item_state = "hos_hat"

/obj/item/clothing/head/hos/corp
	name = "corporate head of security hat"
	desc = "The black parade hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "corp"
	item_state = "corp"

/obj/item/clothing/head/flatcap/bartender
	name = "bartender flatcap"
	desc = "An simple hat issued to bartenders."
	icon_state = "corp"

/obj/item/clothing/head/flatcap/bartender/idris
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	desc = "An simple hat issued to bartenders. This one has Idris colors."
	contained_sprite = TRUE
	icon_state = "idris_bartender_flatcap"
	item_state = "idris_bartender_flatcap"

/obj/item/clothing/head/flatcap/bartender/nt
	desc = "An simple hat issued to bartenders. This one has NanoTrasen colors."
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_bartender_flatcap"
	item_state = "nt_bartender_flatcap"
