	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	flags = CONDUCT
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")

	name = "\improper Rapid-Seed-Producer (RSP)"
	desc = "A device used to rapidly deploy seeds."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 0
	var/mode = 1
	w_class = 3.0

	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = 2.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

	desc = "A NanoTrasen-brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

	icon_state = "soapdeluxe"

	..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = 2
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0


	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 2.0
	throw_speed = 4
	throw_range = 5

	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon_state = "cane"
	item_state = "stick"
	flags = CONDUCT
	force = 10
	throwforce = 7.0
	w_class = 4
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

	var/concealed_blade

	..()
	concealed_blade = temp_blade
	temp_blade.attack_self()

	if(concealed_blade)
		user.visible_message("<span class='warning'>[user] has unsheathed \a [concealed_blade] from \his [src]!</span>", "You unsheathe \the [concealed_blade] from \the [src].")
		// Calling drop/put in hands to properly call item drop/pickup procs
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		concealed_blade = null
		update_icon()
	else
		..()

	if(!src.concealed_blade && istype(W))
		user.visible_message("<span class='warning'>[user] has sheathed \a [W] into \his [src]!</span>", "You sheathe \the [W] into \the [src].")
		user.drop_from_inventory(W)
		W.loc = src
		src.concealed_blade = W
		update_icon()
	else
		..()

	if(concealed_blade)
		name = initial(name)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		name = "cane shaft"
		icon_state = "nullrod"
		item_state = "foldcane"

	name = "disk"
	icon = 'icons/obj/items.dmi'

/*
	name = "Gaming Kit"
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = 5.0
*/

	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = 4.0

	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	throwforce = 0
	w_class = 3.0
	origin_tech = list(TECH_MATERIAL = 1)
	var/breakouttime = 300	//Deciseconds = 30s = 0.5 minute
	sprite_sheets = list("Resomi" = 'icons/mob/species/resomi/handcuffs.dmi')

	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	attack_verb = list("warned", "cautioned", "smashed")

    if(src.icon_state == "caution")
        src.icon_state = "caution_blinking"
        user << "You turn the sign on."
    else
        src.icon_state = "caution"
        user << "You turn the sign off."

	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	if(src.icon_state == "caution")
		src.icon_state = "caution_blinking"
		usr << "You turn the sign on."
	else
		src.icon_state = "caution"
		usr << "You turn the sign off."

	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"
	item_state = "cone"
	contained_sprite = 1
	slot_flags = SLOT_HEAD

	return

	return

	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/device/radio/origradio = null
	flags = CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	matter = list("metal" = 100
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 3)*/

	name = "station-bounced radio"
	desc = "used to comunicate it appears."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/origradio = null
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "radio"
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	origin_tech = list(TECH_MAGNET = 1)

	name = "wizards staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	attack_verb = list("bludgeoned", "whacked", "disciplined")

	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

	name = "Gentlemans Cane"
	desc = "An ebony can with an ivory tip."
	icon_state = "cane"
	item_state = "stick"

	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon_state = "stick"
	item_state = "stick"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'icons/obj/power.dmi'
	icon_state = "item_wire"
	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null
	matter = list(DEFAULT_WALL_MATERIAL = 40)
	attack_verb = list("whipped", "lashed", "disciplined", "tickled")

	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = CONDUCT
	var/mtype = 1						// 1=electronic 2=hardware

	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

	if (ismultitool(W))
		qdel(src)
		user.put_in_hands(newcircuit)

	name = "\improper ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

	name = "power cell regulator module"
	icon_state = "power_mod"
	desc = "A converter and regulator allowing the use of power cells."

	name = "power cell charger module"
	icon_state = "power_mod"
	desc = "Charging circuits for power cells."


/obj/item/device/camera_bug
	name = "camera bug"
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	w_class = 1.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20

	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		usr << "<span class='warning'>No bugged functioning cameras found.</span>"
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null|anything in friendly_cameras
	if (!target)
		return
	for (var/obj/machinery/camera/C in cameras)
		if (C.c_tag == target)
			target = C
			break
	if (usr.stat == 2) return

	usr.client.eye = target

/*
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = 1
	throwforce = 2
	var/cigarcount = 6
	flags = ONBELT
	*/

	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine

	name = "fried neural socket"
	desc = "A Vaurca neural socket subjected to extreme heat. It's security chip appears to be fried."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "neuralbroke"

	if(isscrewdriver(W))
		new /obj/item/device/encryptionkey/hivenet(user.loc)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		user << "You bypass the fried security chip and extract the encryption key."
		user << "The fried neural socket crumbles away like dust."
		qdel(src)

	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	w_class = 5
	storage_slots = 50
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	display_contents_with_number = 1
	max_w_class = 3
	max_storage_space = 100

	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

	name = "anomaly core"
	desc = "An advanced bluespace device, little is known about its applications, meriting research into its purpose."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anomaly_core"
	origin_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 7, TECH_BLUESPACE = 8)

	name = "research debugging device"
	desc = "Instant research tool. For testing purposes only."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = list(TECH_MATERIAL = 19, TECH_ENGINEERING = 19, TECH_PHORON = 19, TECH_POWER = 19, TECH_BLUESPACE = 19, TECH_BIO = 19, TECH_COMBAT = 19, TECH_MAGNET = 19, TECH_DATA = 19, TECH_ILLEGAL = 19, TECH_ARCANE = 19)
