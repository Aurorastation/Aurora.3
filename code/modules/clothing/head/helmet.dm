/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)
	item_flags = THICKMATERIAL
	armor = list(
		melee = ARMOR_MELEE_KEVLAR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	w_class = ITEMSIZE_NORMAL
	var/obj/machinery/camera/camera
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/clothing/head/helmet/Initialize()
	. = ..()
	if(camera)
		verbs += /obj/item/clothing/head/helmet/proc/toggle_camera

/obj/item/clothing/head/helmet/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)

	if(camera)
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, SPAN_NOTICE("User scanned as [camera.c_tag]. Camera activated."))
		else
			to_chat(usr, SPAN_NOTICE("Camera deactivated."))

/obj/item/clothing/head/helmet/space/examine(var/mob/user)
	if(..(user, 1) && camera)
		to_chat(user, FONT_SMALL(SPAN_NOTICE("To toggle the helmet camera, right click the helmet and press <b>Toggle Helmet Camera</b>.")))
		to_chat(user, "This helmet has a built-in camera. It's [!ispath(camera) && camera.status ? "" : "in"]active.")

/obj/item/clothing/head/helmet/hos
	name = "head of security helmet"
	desc = "A special Internal Security Division helmet designed to protect the precious craniums of important installation security officers."
	desc_fluff = "What the heck did you just hecking say about me, you little honker? I'll have you know I graduated top of my class in the Sol Army, and I've been involved in numerous secret raids on the Jargon Federation, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire Sol armed forces. You are nothing to me but just another target. I will wipe you the heck out with precision the likes of which has never been seen before on Biesel, mark my hecking words."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_sec_commander"
	item_state = "helm_sec_commander"

/obj/item/clothing/head/helmet/hos/dermal
	name = "dermal armor patch"
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
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_riot"
	item_state = "helm_riot"
	body_parts_covered = HEAD|FACE|EYES //face shield
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR
		)
	siemens_coefficient = 0.35
	flags_inv = HIDEEARS
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/riot/attack_self(mob/user as mob)
	if (use_check_and_message(user))
		return

	do_flip(user)
	update_clothing_icon()

/obj/item/clothing/head/helmet/riot/proc/do_flip(var/mob/user)
	if(icon_state == initial(icon_state))
		icon_state = "[icon_state]-up"
		item_state = icon_state
		to_chat(user, SPAN_NOTICE("You raise the visor on \the [src]."))
		body_parts_covered = HEAD
	else
		icon_state = initial(icon_state)
		item_state = icon_state
		to_chat(user, SPAN_NOTICE("You lower the visor on \the [src]."))
		body_parts_covered = HEAD|FACE|EYES


/obj/item/clothing/head/helmet/ablative
	name = "ablative helmet"
	desc = "A helmet made from advanced materials which protects against concentrated energy weapons."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_ablative"
	item_state = "helm_ablative"
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_RESISTANT
	)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/ballistic
	name = "ballistic helmet"
	desc = "A helmet with reinforced plating to protect against ballistic projectiles."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_ballistic"
	item_state = "helm_ballistic"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A tan helmet made from advanced ceramic."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	contained_sprite = TRUE
	icon_state = "helm_heavy"
	item_state = "helm_heavy"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/merc/scc
	name = "heavy SCC helmet"
	desc = "A blue helmet made from advanced ceramic. If corporate drones had brains, this would be protecting it."
	icon_state = "helm_blue"
	item_state = "helm_blue"

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	item_state = "swat"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.1

/obj/item/clothing/head/helmet/swat/peacekeeper
	name = "\improper ERT civil protection helmet"
	desc = "A full helmet made of highly advanced ceramic materials, complete with a jetblack visor. Shines with a mirror sheen."
	icon_state = "civilprotection_helmet"
	item_state = "civilprotection_helmet"
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
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
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
	flags_inv = HIDEEARS|BLOCKHAIR
	sprite_sheets = list(
		BODYTYPE_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		BODYTYPE_UNATHI = 'icons/mob/species/unathi/helmet.dmi'
	)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35


/obj/item/clothing/head/helmet/augment
	name = "augment array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.1

/obj/item/clothing/head/helmet/iachelmet
	name = "IAC helmet"
	desc = "This helmet is meant to protect the wearer from light debris, scrapes and bumps in a disaster situation, this lightweight helmet doesn't offer any significant protection from attacks or severe accidents. It's not recommended for use as armor and it's definitely not spaceworthy."
	icon_state = "iac_helmet"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_MINOR
	)
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/unathi
	name = "unathi helmet"
	desc = "An outdated helmet designated to be worn by an Unathi, it was commonly used by the Hegemony Levies."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "unathi_helmet"
	item_state = "unathi_helmet"
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_UNATHI)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/unathi/hegemony
	name = "hegemony helmet"
	desc = "A highly armored helmet designated to be worn by an Unathi, a newer variant commonly worn by the Hegemony Levies."
	icon_state = "hegemony_helmet"
	item_state = "hegemony_helmet"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		rad = ARMOR_RAD_MINOR
	)

/obj/item/clothing/head/helmet/unathi/klax
	name = "klaxan hopeful helmet"
	desc = "A helmet designated to be worn by a K'lax hopeful. The retrofit features a modified shape and an extra two eye visors.."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "klax_hopeful_helmet"
	item_state = "klax_hopeful_helmet"
	species_restricted = list(BODYTYPE_VAURCA)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/tank
	name = "padded cap"
	desc = "A padded skullcap for those prone to bumping their heads against hard surfaces."
	icon_state = "tank"
	flags_inv = BLOCKHEADHAIR
	color = "#5f5f5f"
	armor = list(
		melee = ARMOR_MELEE_KNIVES
	)
	siemens_coefficient = 0.75

/obj/item/clothing/head/helmet/tank/olive
	color = "#727c58"

/obj/item/clothing/head/helmet/tank/tan
	color = "#ae9f79"

/obj/item/clothing/head/helmet/tank/legion
	color = "#5674a6"

//Non-hardsuit ERT helmets.
/obj/item/clothing/head/helmet/ert
	name = "emergency response team helmet"
	desc = "An in-atmosphere helmet worn by members of the Emergency Response Team. Protects the head from impacts."
	icon_state = "erthelmet_cmd"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-green",
		slot_r_hand_str = "syndicate-helm-green"
	)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BIO_MINOR
	)
	siemens_coefficient = 0.35

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
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHEADHAIR
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.35
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi',
		"Machine" = 'icons/mob/species/machine/helmet.dmi'
	)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light_dual"
	brightness_on = 6
	light_wedge = LIGHT_WIDE
	camera = /obj/machinery/camera/network/tcfl
	on = 0
