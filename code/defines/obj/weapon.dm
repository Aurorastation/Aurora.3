/obj/item/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "red_phone"
	flags = CONDUCT
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/rsp
	name = "\improper Rapid-Seed-Producer (RSP)"
	desc = "A device used to rapidly deploy seeds."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rfd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 0
	var/mode = 1
	w_class = 3.0

/obj/item/bikehorn
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

/obj/item/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	flags = CONDUCT
	force = 10
	throwforce = 7.0
	w_class = 4
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/cane/attack(mob/living/target, mob/living/carbon/human/user, target_zone = "chest")

	if(!(istype(target) && istype(user)))
		return ..()

	var/targetIsHuman = ishuman(target)
	var/mob/living/carbon/human/targetashuman = target
	var/wasselfattack = 0
	var/verbtouse = pick(attack_verb)
	var/punct = "!"
	var/class = "warning"
	var/soundname = "swing_hit"
	var/armorpercent = 0
	var/wasblocked = 0
	var/shoulddisarm = 0
	var/damagetype = HALLOSS
	var/chargedelay = 4 // 4 half frames = 2 seconds

	if(targetIsHuman && targetashuman == user)
		wasselfattack = 1

	if (user.intent == I_HURT)
		target_zone = get_zone_with_miss_chance(target_zone, target) //Vary the attack
		damagetype = BRUTE

	if (targetIsHuman)
		var/mob/living/carbon/human/targethuman = target
		armorpercent = targethuman.run_armor_check(target_zone,"melee")
		wasblocked = targethuman.check_shields(force, src, user, target_zone, null) //returns 1 if it's a block

	var/damageamount = force

	switch(user.a_intent)
		if(I_HELP)
			class = "notice"
			punct = "."
			soundname = 0
			if (target_zone == "head" || target_zone == "eyes" || target_zone == "mouth")
				verbtouse = pick("tapped")
			else
				verbtouse = pick("tapped","poked","prodded","touched")
			damageamount = 0
		if(I_DISARM)
			verbtouse = pick("smacked","slapped")
			soundname = "punch"
			if(targetIsHuman)
				user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun(1)] [name]...</span>", "<span class='[class]'>You flip the [name], preparing a disarm...</span>")
				if (do_mob(user,target,chargedelay,display_progress=0))
					if(!wasblocked && damageamount)
						var/chancemod = (100 - armorpercent)*0.05*damageamount // Lower chance if lower damage + high armor. Base chance is 50% at 10 damage.
						if(target_zone == "l_hand" || target_zone == "l_arm")
							if (prob(chancemod) && target.l_hand && target.l_hand != src)
								shoulddisarm = 1
						else if(target_zone == "r_hand" || target_zone == "r_arm")
							if (prob(chancemod) && target.r_hand && target.r_hand != src)
								shoulddisarm = 2
						else
							if (prob(chancemod*0.5) && target.l_hand && target.l_hand != src)
								shoulddisarm = 1
							if (prob(chancemod*0.5) && target.r_hand && target.r_hand != src)
								shoulddisarm += 2
				else
					user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun(1)] [name] back to it's original position.</span>", "<span class='[class]'>You flip the [name] back to it's original position.</span>")
					return 0
			damageamount *= 0.25
		if(I_GRAB)
			verbtouse = pick("hooked")
			soundname = "punch"
			if(targetIsHuman)
				user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun(1)] [name]...</span>", "<span class='[class]'>You flip the [name], preparing a grab...</span>")
				if (do_mob(user,target,chargedelay,display_progress=0))
					if(!wasblocked && damageamount)
						user.start_pulling(target)
					else
						verbtouse = pick("awkwardly tries to hook","fails to grab")
				else
					user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun(1)] [name] back to it's original position.</span>", "<span class='[class]'>You flip the [name] back to it's original position.</span>")
					return 0
			else
				soundname = "punch"
			damageamount *= 0.1

	// Damage Logs
	/////////////////////////
	user.lastattacked = target
	target.lastattacker = user
	if(!no_attack_log)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [target.name] ([target.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damagetype)])</font>"
		target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damagetype)])</font>"
		msg_admin_attack("[key_name(user, highlight_special = 1)] attacked [key_name(target, highlight_special = 1)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damagetype)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target) )
	/////////////////////////

	var/washit = 0
	var/endmessage1st
	var/endmessage3rd

	if(!target_zone || get_dist(user,target) > 1) //Dodged
		endmessage1st = "Your [name] was dodged by [target]"
		endmessage3rd = "[target] dodged the [name]"
		soundname = "sound/weapons/punchmiss.ogg"
	else if(wasblocked) // Blocked by Shield
		endmessage1st = "Your [name] was blocked by [target]"
		endmessage3rd = "[target] blocks the [name]"
		soundname = "sound/weapons/punchmiss.ogg"
	else

		washit = 1
		var/noun = "[target]"
		var/selfnoun = "your"

		if(shoulddisarm)
			if(wasselfattack)
				selfnoun = "your grip"
				noun = "[target.get_pronoun(1)] grip"
			else
				noun = "[target]'s grip"
				selfnoun = noun
		if (targetIsHuman && shoulddisarm != 3) // Query: Can non-humans hold objects in hands?
			var/mob/living/carbon/human/targethuman = target
			var/obj/item/organ/external/O = targethuman.get_organ(target_zone)
			if (O.is_stump())
				if(wasselfattack)
					selfnoun = "your missing [O.name]"
					noun = "[target.get_pronoun(1)] missing [O.name]"
				else
					noun = "[target]'s missing [O.name]"
					selfnoun = noun
			else
				if(wasselfattack)
					selfnoun = "your [O.name]"
					noun = "[target.get_pronoun(1)] [O.name]"
				else
					noun = "[target]'s [O.name]"
					selfnoun = noun

		switch(shoulddisarm)
			if(1)
				endmessage1st = "You [verbtouse] the [target.l_hand.name] out of [selfnoun]"
				endmessage3rd = "[user] [verbtouse] the [target.l_hand.name] out of [noun]"
				target.drop_l_hand()
			if(2)
				endmessage1st = "You [verbtouse] the [target.r_hand.name] out of [selfnoun]"
				endmessage3rd = "[user] [verbtouse] the [target.r_hand.name] out of [noun]"
				target.drop_r_hand()
			if(3)
				endmessage1st = "You [verbtouse] both the [target.r_hand.name] and the [target.l_hand.name] out of [selfnoun]"
				endmessage3rd = "[user] [verbtouse] both the [target.r_hand.name] and the [target.l_hand.name] out of [noun]"
				target.drop_l_hand()
				target.drop_r_hand()
			else
				endmessage1st = "You [verbtouse] [selfnoun] with the [name]"
				endmessage3rd = "[user] [verbtouse] [noun] with the [name]"

	if(damageamount > 0) // Poking will no longer do damage until there is some fix that makes it so that 0.0001 HALLOS doesn't cause bleed.
		target.standard_weapon_hit_effects(src, user, damageamount, armorpercent, target_zone)

	user.visible_message("<span class='[class]'>[endmessage3rd][punct]</span>", "<span class='[class]'>[endmessage1st][punct]</span>")
	user.do_attack_animation(target)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(soundname)
		playsound(src.loc, soundname, 50, 1, -1)

	return washit

/obj/item/cane/concealed
	var/concealed_blade

/obj/item/cane/concealed/New()
	..()
	var/obj/item/canesword/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.attack_self()

/obj/item/cane/concealed/attack_self(var/mob/user)
	if(concealed_blade)
		user.visible_message("<span class='warning'>[user] has unsheathed \a [concealed_blade] from \his [src]!</span>", "You unsheathe \the [concealed_blade] from \the [src].")
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(user.loc, 'sound/weapons/holster/sheathout.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		concealed_blade = null
		update_icon()
	else
		..()

/obj/item/cane/concealed/attackby(var/obj/item/canesword/W, var/mob/user)
	if(!src.concealed_blade && istype(W))
		user.visible_message("<span class='warning'>[user] has sheathed \a [W] into \his [src]!</span>", "You sheathe \the [W] into \the [src].")
		playsound(user.loc, 'sound/weapons/holster/sheathin.ogg', 50, 1)
		user.drop_from_inventory(W)
		W.forceMove(src)
		src.concealed_blade = W
		update_icon()
	else
		..()

/obj/item/cane/concealed/update_icon()
	if(concealed_blade)
		name = initial(name)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		name = "cane shaft"
		icon_state = "nullrod"
		item_state = "foldcane"

/obj/item/cane/crutch
	name ="crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon_state = "crutch"
	item_state = "crutch"

/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'

/*
/obj/item/game_kit
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

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = 4.0

/obj/item/gift/random_pixel/Initialize()
	pixel_x = rand(-16,16)
	pixel_y = rand(-16,16)

/obj/item/legcuffs
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

/obj/item/caution
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
	drop_sound = 'sound/items/drop/shoes.ogg'

/obj/item/caution/attack_self(mob/user as mob)
    if(src.icon_state == "caution")
        src.icon_state = "caution_blinking"
        to_chat(user, "You turn the sign on.")
    else
        src.icon_state = "caution"
        to_chat(user, "You turn the sign off.")

/obj/item/caution/AltClick()
	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	if(src.icon_state == "caution")
		src.icon_state = "caution_blinking"
		to_chat(usr, "You turn the sign on.")
	else
		src.icon_state = "caution"
		to_chat(usr, "You turn the sign off.")

/obj/item/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"
	item_state = "cone"
	contained_sprite = 1
	slot_flags = SLOT_HEAD

/obj/item/caution/cone/attack_self(mob/user as mob)
	return

/obj/item/caution/cone/AltClick()
	return

/*/obj/item/syndicate_uplink
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

/obj/item/SWF_uplink
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

/obj/item/staff
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

/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

/obj/item/staff/gentcane
	name = "Gentlemans Cane"
	desc = "An ebony can with an ivory tip."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"

/obj/item/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stick"
	item_state = "stick"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

/obj/item/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'icons/obj/power.dmi'
	icon_state = "item_wire"
	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null
	matter = list(DEFAULT_WALL_MATERIAL = 40)
	attack_verb = list("whipped", "lashed", "disciplined", "tickled")

/obj/item/module
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = CONDUCT
	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/module/power_control/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (W.ismultitool())
		var/obj/item/circuitboard/ghettosmes/newcircuit = new/obj/item/circuitboard/ghettosmes(user.loc)
		qdel(src)
		user.put_in_hands(newcircuit)

/obj/item/module/id_auth
	name = "\improper ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

/obj/item/module/cell_power
	name = "power cell regulator module"
	icon_state = "power_mod"
	desc = "A converter and regulator allowing the use of power cells."

/obj/item/module/cell_power
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

/obj/item/camera_bug/attack_self(mob/usr as mob)
	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		to_chat(usr, "<span class='warning'>No bugged functioning cameras found.</span>")
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
/obj/item/cigarpacket
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

/obj/item/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine

/obj/item/neuralbroke
	name = "fried neural socket"
	desc = "A Vaurca neural socket subjected to extreme heat. It's security chip appears to be fried."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "neuralbroke"

/obj/item/neuralbroke/attackby(obj/item/W as obj, mob/user as mob)
	if(W.isscrewdriver())
		new /obj/item/device/encryptionkey/hivenet(user.loc)
		playsound(src.loc, W.usesound, 50, 1)
		to_chat(user, "You bypass the fried security chip and extract the encryption key.")
		to_chat(user, "The fried neural socket crumbles away like dust.")
		qdel(src)

/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	w_class = 5
	can_hold = list(/obj/item/stock_parts,/obj/item/reagent_containers/glass/beaker)
	storage_slots = 50
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	display_contents_with_number = 1
	max_w_class = 3
	max_storage_space = 100

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/anomaly_core
	name = "anomaly core"
	desc = "An advanced bluespace device, little is known about its applications, meriting research into its purpose."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "anomaly_core"
	origin_tech = list(TECH_MAGNET = 6, TECH_MATERIAL = 7, TECH_BLUESPACE = 8)

/obj/item/research
	name = "research debugging device"
	desc = "Instant research tool. For testing purposes only."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = list(TECH_MATERIAL = 19, TECH_ENGINEERING = 19, TECH_PHORON = 19, TECH_POWER = 19, TECH_BLUESPACE = 19, TECH_BIO = 19, TECH_COMBAT = 19, TECH_MAGNET = 19, TECH_DATA = 19, TECH_ILLEGAL = 19, TECH_ARCANE = 19)
