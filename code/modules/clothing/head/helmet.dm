/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)
	item_flags = THICKMATERIAL
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	w_class = 3
	var/allow_hair_covering = TRUE //in case if you want to allow someone to switch the BLOCKHEADHAIR var from the helmet or not
	drop_sound = 'sound/items/drop/helm.ogg'

/obj/item/clothing/head/helmet/verb/toggle_block_hair()
	set name = "Toggle Helmet Hair Coverage"
	set category = "Object"

	if(allow_hair_covering)
		flags_inv ^= BLOCKHEADHAIR
		to_chat(usr, "<span class='notice'>[src] will now [flags_inv & BLOCKHEADHAIR ? "hide" : "show"] hair.</span>")
	..()

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a securiy force. Protects the head from impacts."
	icon_state = "policehelm"
	flags_inv = 0

/obj/item/clothing/head/helmet/warden/commissar
	name = "commissar's cap"
	desc = "A security commissar's cap."
	icon_state = "commissarcap"

/obj/item/clothing/head/helmet/HoS
	name = "head of security hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/HoS/dermal
	name = "dermal armour patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	allow_hair_covering = FALSE

/obj/item/clothing/head/helmet/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"
	flags_inv = 0

/obj/item/clothing/head/helmet/formalcaptain
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"
	flags_inv = 0

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	body_parts_covered = HEAD|FACE|EYES //face shield
	armor = list(melee = 80, bullet = 20, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/riot/attack_self(mob/user as mob)
	if (use_check_and_message(user))
		return

	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]-up"
		to_chat(user, "You raise the visor on \the [src].")
		body_parts_covered = HEAD
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on \the [src].")
		body_parts_covered = HEAD|FACE|EYES
	update_clothing_icon()

/obj/item/clothing/head/helmet/ablative
	name = "ablative helmet"
	desc = "A helmet made from advanced materials which protects against concentrated energy weapons."
	icon_state = "helmet_reflect"
	armor = list(melee = 25, bullet = 25, laser = 80, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/ballistic
	name = "ballistic helmet"
	desc = "A helmet with reinforced plating to protect against ballistic projectiles."
	icon_state = "helmet_bulletproof"
	armor = list(melee = 25, bullet = 80, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A tan helmet made from advanced ceramic."
	icon_state = "helmet_tac"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	item_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/swat/peacekeeper
	name = "\improper ERT civil protection helmet"
	desc = "A full helmet made of highly advanced ceramic materials, complete with a jetblack visor. Shines with a mirror sheen."
	icon_state = "erthelmet_peacekeeper"
	item_state = "erthelmet_peacekeeper"
	body_parts_covered = HEAD|FACE|EYES //face shield
	flags_inv = HIDEEARS
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/swat/peacekeeper/attack_self(mob/user as mob)
	if (use_check_and_message(user))
		return

	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]-up"
		to_chat(user, "You raise the visor on \the [src].")
		body_parts_covered = HEAD
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on \the [src].")
		body_parts_covered = HEAD|FACE|EYES
	update_clothing_icon()

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi'
		)

	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/augment
	name = "augment array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/iachelmet
	name = "IAC helmet"
	desc = "This helmet is meant to protect the wearer from light debris, scrapes and bumps in a disaster situation, this lightweight helmet doesn't offer any significant protection from attacks or severe accidents. It's not recommended for use as armor and it's definitely not spaceworthy."
	icon_state = "iac_helmet"
	armor = list(melee = 6, bullet = 10, laser = 10, energy = 3, bomb = 5, bio = 15, rad = 0)
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/unathi
	name = "unathi helmet"
	desc = "A helmet designated to be worn by an unathi, used commonly by the hegemony levies."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "unathi_helmet"
	item_state = "unathi_helmet"
	contained_sprite = 1
	species_restricted = list("Unathi")
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/tank
	name = "padded cap"
	desc = "A padded skullcup for those prone to bumping their heads against hard surfaces."
	icon_state = "tank"
	flags_inv = BLOCKHEADHAIR
	color = "#5f5f5f"
	armor = list(melee = 25, bullet = 5, laser = 5, energy = 10, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/tank/olive
	color = "#727c58"

/obj/item/clothing/head/helmet/tank/tan
	color = "#ae9f79"

//Non-hardsuit ERT helmets.
/obj/item/clothing/head/helmet/ert
	name = "emergency response team helmet"
	desc = "An in-atmosphere helmet worn by members of the Emergency Response Team. Protects the head from impacts."
	icon_state = "erthelmet_cmd"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-green",
		slot_r_hand_str = "syndicate-helm-green"
		)
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)

//Commander
/obj/item/clothing/head/helmet/ert/command
	name = "emergency response team commander helmet"
	desc = "An in-atmosphere helmet worn by the commander of a Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "emergency response team security helmet"
	desc = "An in-atmosphere helmet worn by security members of the Emergency Response Team. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "An in-atmosphere helmet worn by engineering members of the Emergency Response Team. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "emergency response team medical helmet"
	desc = "A set of armor worn by medical members of the NanoTrasen Emergency Response Team. Has red and white highlights."
	icon_state = "erthelmet_med"

/obj/item/clothing/head/helmet/legion
	name = "foreign legion helmet"
	desc = "A large helmet meant to fit some pretty big heads. It has a ballistic faceplate on the front of it."
	icon_state = "legion_helmet"
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	armor = list(melee = 50, bullet = 30, laser = 30, energy = 15, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/tajara
	name = "amohdan swordsmen helmet"
	desc = "A helmet used by the traditional warriors of Amohda."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "amohdan_helmet"
	item_state = "amohdan_helmet"
	contained_sprite = TRUE
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	species_restricted = list("Tajara")
	armor = list(melee = 60, bullet = 50, laser = 20, energy = 10, bomb = 5, bio = 0, rad = 0)
	allow_hair_covering = FALSE
	description_fluff = "The Feudal Era of Amohda is famous for the steel swords which became common. Many renowned swordsmen and famous warriors would travel the land fighting duels of \
	single combat in their quests to become the greatest swordsman. Modern Amohda is a mix between loyalists to the NKA and to the DPRA, with almost universal praise for a return to \
	traditional culture, yet often violent disagreement about the course of the island's political future. A sizable third party of monarchists which advocate the reestablishment of the \
	Imperial Amohdan dynasty also exists, fragmenting the monarchist factions on the island and further complicating political violence in the area."
