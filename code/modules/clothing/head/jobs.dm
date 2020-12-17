//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"

//HOP
/obj/item/clothing/head/caphat/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"

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
	armor = list(melee = 50, bullet = 5, laser = 25,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/head/det/grey
	icon_state = "grey_fedora"
	desc = "A grey fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/warden
	name = "blue warden hat"
	desc = "A navy blue warden hat. For showing who is in charge of the brig."
	icon_state = "wardencap"
	flags_inv = HIDEEARS

/obj/item/clothing/head/warden/alt
	name = "black warden hat"
	desc = "A black warden hat. For showing who is in charge of the brig."
	icon_state = "wardencap_alt"

/obj/item/clothing/head/warden/commissar
	name = "commissar's cap"
	desc = "A security commissar's cap."
	icon_state = "commissarcap"

/obj/item/clothing/head/hos/cap
	name = "blue commander hat"
	desc = "The navy blue hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	flags_inv = HIDEEARS

/obj/item/clothing/head/hos/cap/alt
	name = "black commander hat"
	desc = "The black hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap_alt"
