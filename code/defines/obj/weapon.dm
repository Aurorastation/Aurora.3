/obj/item/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "red_phone"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 3
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_SMALL
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
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/last_honk = 0

/obj/item/bikehorn/attack_self(mob/user as mob)
	if(last_honk <= world.time - 20) //Spam limiter.
		last_honk = world.time
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
	return

/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 15
	throwforce = 7.0
	w_class = WEIGHT_CLASS_BULKY
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")
	var/can_support = TRUE

/obj/item/cane/attack(mob/living/target_mob, mob/living/user, target_zone)

	if(!(istype(target_mob) && istype(user)))
		return ..()

	var/targetIsHuman = ishuman(target_mob)
	var/mob/living/carbon/human/targetashuman = target_mob
	var/wasselfattack = 0
	var/verbtouse = pick(attack_verb)
	var/punct = "!"
	var/class = "warning"
	var/soundname = "swing_hit"
	var/armorpercent = 0
	var/wasblocked = 0
	var/shoulddisarm = 0
	var/damagetype = DAMAGE_PAIN
	var/chargedelay = 4 // 4 half frames = 2 seconds

	if(targetIsHuman && targetashuman == user)
		wasselfattack = 1

	if (user.a_intent == I_HURT)
		target_zone = get_zone_with_miss_chance(target_zone, target_mob) //Vary the attack
		damagetype = DAMAGE_BRUTE

	if (targetIsHuman)
		var/mob/living/carbon/human/targethuman = target_mob
		armorpercent = targethuman.get_blocked_ratio(target_zone, DAMAGE_BRUTE, damage = force)*100
		wasblocked = (targethuman.check_shields(force, src, user, target_zone, null) in list(BULLET_ACT_BLOCK, BULLET_ACT_FORCE_PIERCE))

	var/damageamount = force

	switch(user.a_intent)
		if(I_HELP)
			class = "notice"
			punct = "."
			soundname = 0
			if (target_zone == BP_HEAD || target_zone == BP_EYES || target_zone == BP_MOUTH)
				verbtouse = pick("tapped")
			else
				verbtouse = pick("tapped","poked","prodded","touched")
			damageamount = 0
		if(I_DISARM)
			verbtouse = pick("smacked","slapped")
			soundname = "punch"
			if(targetIsHuman)
				user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun("his")] [name]...</span>", "<span class='[class]'>You flip [src], preparing a disarm...</span>")
				if (do_mob(user,target_mob,chargedelay,display_progress=0))
					if(!wasblocked && damageamount)
						var/chancemod = (100 - armorpercent)*0.05*damageamount // Lower chance if lower damage + high armor. Base chance is 50% at 10 damage.
						if(target_zone == BP_L_HAND || target_zone == BP_L_ARM)
							if (prob(chancemod) && target_mob.l_hand && target_mob.l_hand != src)
								shoulddisarm = 1
						else if(target_zone == BP_R_HAND || target_zone == BP_R_ARM)
							if (prob(chancemod) && target_mob.r_hand && target_mob.r_hand != src)
								shoulddisarm = 2
						else
							if (prob(chancemod*0.5) && target_mob.l_hand && target_mob.l_hand != src)
								shoulddisarm = 1
							if (prob(chancemod*0.5) && target_mob.r_hand && target_mob.r_hand != src)
								shoulddisarm += 2
				else
					user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun("his")] [name] back to its original position.</span>", "<span class='[class]'>You flip [src] back to its original position.</span>")
					return 0
			damageamount *= 0.25
		if(I_GRAB)
			verbtouse = pick("hooked")
			soundname = "punch"
			if(targetIsHuman)
				user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun("his")] [name]...</span>", "<span class='[class]'>You flip [src], preparing a grab...</span>")
				if (do_mob(user,target_mob,chargedelay,display_progress=0))
					if(!wasblocked && damageamount)
						user.start_pulling(target_mob)
					else
						verbtouse = pick("awkwardly tries to hook","fails to grab")
				else
					user.visible_message("<span class='[class]'>[user] flips [user.get_pronoun("his")] [name] back to its original position.</span>", "<span class='[class]'>You flip [src] back to its original position.</span>")
					return 0
			else
				soundname = "punch"
			damageamount *= 0.1

	// Damage Logs
	/////////////////////////
	user.lastattacked = target_mob
	target_mob.lastattacker = user
	if(!no_attack_log)
		user.attack_log += "\[[time_stamp()]\]<span class='warning'> Attacked [target_mob.name] ([target_mob.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damagetype)])</span>"
		target_mob.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damagetype)])</font>"
		msg_admin_attack("[key_name(user, highlight_special = 1)] attacked [key_name(target_mob, highlight_special = 1)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damagetype)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target_mob) )
	/////////////////////////

	var/washit = 0
	var/endmessage1st
	var/endmessage3rd

	if(!target_zone || get_dist(user,target_mob) > 1) //Dodged
		endmessage1st = "Your [name] was dodged by [target_mob]"
		endmessage3rd = "[target_mob] dodged the [name]"
		soundname = "punchmiss"
	else if(wasblocked) // Blocked by Shield
		endmessage1st = "Your [name] was blocked by [target_mob]"
		endmessage3rd = "[target_mob] blocks the [name]"
		soundname = "punchmiss"
	else

		washit = 1
		var/noun = "[target_mob]"
		var/selfnoun = "your"

		if(shoulddisarm)
			if(wasselfattack)
				selfnoun = "your grip"
				noun = "[target_mob.get_pronoun("his")] grip"
			else
				noun = "[target_mob]'s grip"
				selfnoun = noun
		if (targetIsHuman && shoulddisarm != 3) // Query: Can non-humans hold objects in hands?
			var/mob/living/carbon/human/targethuman = target_mob
			var/obj/item/organ/external/O = targethuman.get_organ(target_zone)
			if (O.is_stump())
				if(wasselfattack)
					selfnoun = "your missing [O.name]"
					noun = "[target_mob.get_pronoun("his")] missing [O.name]"
				else
					noun = "[target_mob]'s missing [O.name]"
					selfnoun = noun
			else
				if(wasselfattack)
					selfnoun = "your [O.name]"
					noun = "[target_mob.get_pronoun("his")] [O.name]"
				else
					noun = "[target_mob]'s [O.name]"
					selfnoun = noun

		switch(shoulddisarm)
			if(1)
				endmessage1st = "You [verbtouse] the [target_mob.l_hand.name] out of [selfnoun]"
				endmessage3rd = "[user] [verbtouse] the [target_mob.l_hand.name] out of [noun]"
				target_mob.drop_l_hand()
			if(2)
				endmessage1st = "You [verbtouse] the [target_mob.r_hand.name] out of [selfnoun]"
				endmessage3rd = "[user] [verbtouse] the [target_mob.r_hand.name] out of [noun]"
				target_mob.drop_r_hand()
			if(3)
				endmessage1st = "You [verbtouse] both the [target_mob.r_hand.name] and the [target_mob.l_hand.name] out of [selfnoun]"
				endmessage3rd = "[user] [verbtouse] both the [target_mob.r_hand.name] and the [target_mob.l_hand.name] out of [noun]"
				target_mob.drop_l_hand()
				target_mob.drop_r_hand()
			else
				endmessage1st = "You [verbtouse] [selfnoun] with the [name]"
				endmessage3rd = "[user] [verbtouse] [noun] with the [name]"

	if(damageamount > 0) // Poking will no longer do damage until there is some fix that makes it so that 0.0001 HALLOS doesn't cause bleed.
		target_mob.standard_weapon_hit_effects(src, user, damageamount, armorpercent, target_zone)

	user.visible_message("<span class='[class]'>[endmessage3rd][punct]</span>", "<span class='[class]'>[endmessage1st][punct]</span>")
	user.do_attack_animation(target_mob)
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
		user.visible_message(SPAN_WARNING("[user] has unsheathed \a [concealed_blade] from [user.get_pronoun("his")] [src]!"), "You unsheathe \the [concealed_blade] from \the [src].")
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

/obj/item/cane/concealed/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/canesword/attacking_canesword = attacking_item
	if(!src.concealed_blade && istype(attacking_canesword))
		user.visible_message(SPAN_WARNING("[user] has sheathed \a [attacking_canesword] into [user.get_pronoun("his")] [src]!"), "You sheathe \the [attacking_canesword] into \the [src].")
		playsound(user.loc, 'sound/weapons/holster/sheathin.ogg', 50, 1)
		user.drop_from_inventory(attacking_canesword)
		attacking_canesword.forceMove(src)
		src.concealed_blade = attacking_canesword
		update_icon()
		return TRUE
	else
		return ..()

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
	name = "crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon_state = "crutch"
	item_state = "crutch"

/obj/item/cane/crutch/forearm
	name = "forearm crutch"
	desc = "A different style of crutch with a handle and a cuff that goes around the forearm for additional support."
	icon_state = "forearm_crutch"
	item_state = "forearm_crutch"

/obj/item/cane/shillelagh
	name = "adhomian shillelagh"
	desc = "A sturdy walking stick made from adhomian wood."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "shillelagh"
	item_state = "shillelagh"
	contained_sprite = TRUE

/obj/item/cane/telecane
	name = "telescopic cane"
	desc = "A compact cane which can be collapsed for storage."
	icon = 'icons/obj/item/telecane.dmi'
	icon_state = "telecane"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	var/on = FALSE
	can_support = FALSE
	var/extended_icon_state = "telecane_1"
	var/extended_item_state = "telestick"
	var/retracted_icon_state = "telecane"
	var/retracted_item_state = "telestick_0"

/obj/item/cane/telecane/attack_self(mob/user)
	on = !on
	if(on)
		user.visible_message(SPAN_NOTICE("With a flick of their wrist, [user] extends their [src.name]"), SPAN_NOTICE("You extend the [src.name]."), SPAN_NOTICE("You hear a click."))
		icon_state = extended_icon_state
		item_state = extended_item_state
		w_class = WEIGHT_CLASS_BULKY
		slot_flags = null
		force = 14
		attack_verb = list("smacked", "struck", "slapped")
		can_support = TRUE
	else
		user.visible_message(SPAN_NOTICE("\The [user] collapses their [src.name]."), SPAN_NOTICE("You collapse the [src.name]."), SPAN_NOTICE("You hear a click."))
		icon_state = retracted_icon_state
		item_state = retracted_item_state
		w_class = WEIGHT_CLASS_SMALL
		slot_flags = SLOT_BELT
		force = 3
		attack_verb = list("hit", "punched")
		can_support = FALSE

	if(istype(user,/mob/living/carbon/human))
		update_held_icon()

	playsound(src.loc, 'sound/weapons/click.ogg', 50, 1)
	add_fingerprint(user)

/obj/item/cane/telecane/white
	name = "white cane"
	desc = "A white cane, used by the visually impaired."
	icon = 'icons/obj/item/whitecane.dmi'
	icon_state = "whitecane"
	drop_sound =  /singleton/sound_category/generic_drop_sound
	pickup_sound =  /singleton/sound_category/generic_pickup_sound
	extended_icon_state = "whitecane_extended"
	extended_item_state = "whitecane"
	retracted_icon_state = "whitecane"
	retracted_item_state = "whitecane_0"

/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_card.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_card.dmi',
		)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound =  'sound/items/pickup/disk.ogg'

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/holidays/christmas/presents.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gift/random_pixel/Initialize()
	. = ..()
	pixel_x = rand(-16,16)
	pixel_y = rand(-16,16)

/obj/item/SWF_uplink
	name = "station-bounced radio"
	desc = "Used to communicate, it appears."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	item_state = "radio"
	contained_sprite = TRUE
	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/origradio = null
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 4
	throw_range = 20
	matter = list(MATERIAL_ALUMINIUM = 25, MATERIAL_PLASTIC = 75)
	origin_tech = list(TECH_MAGNET = 1)

/obj/item/staff
	name = "wizards staff"
	desc = "A staff which only has the power to make you look like a nerd."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("bludgeoned", "whacked", "disciplined")

/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

/obj/item/staff/gentcane
	name = "gentlemans cane"
	desc = "An ebony can with an ivory tip."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"

/obj/item/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "qstaff0"
	item_state = "stick"
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/module
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	usesound = 'sound/items/Deconstruct.ogg'
	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."
	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)

/obj/item/module/power_control/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ismultitool())
		var/obj/item/circuitboard/ghettosmes/new_circuit = new /obj/item/circuitboard/ghettosmes(get_turf(src))
		to_chat(user, SPAN_NOTICE("You modify \the [src] into a makeshift PSU circuitboard."))
		qdel(src)
		user.put_in_hands(new_circuit)
		return TRUE

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
	icon = 'icons/obj/item/device/flash.dmi'
	icon_state = "flash"
	item_state = "flash"
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 4
	throw_range = 20

/obj/item/camera_bug/attack_self(mob/user as mob)
	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in GLOB.cameranet.cameras)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		to_chat(user, SPAN_WARNING("No bugged functioning cameras found."))
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = tgui_input_list(user, "Select the camera to observe", "Camera Bug", friendly_cameras)
	if (!target)
		return
	for (var/obj/machinery/camera/C in cameras)
		if (C.c_tag == target)
			target = C
			break
	if (user.stat == 2) return

	user.client.eye = target

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

/obj/item/neuralbroke/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		new /obj/item/device/encryptionkey/hivenet(user.loc)
		attacking_item.play_tool_sound(get_turf(src), 50)
		to_chat(user, "You bypass the fried security chip and extract the encryption key.")
		to_chat(user, "The fried neural socket crumbles away like dust.")
		qdel(src)
		return TRUE

/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	icon = 'icons/obj/storage/misc.dmi'
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_HUGE
	can_hold = list(/obj/item/stock_parts,/obj/item/reagent_containers/glass/beaker)
	storage_slots = 50
	use_to_pickup = TRUE
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	collection_mode = 1
	display_contents_with_number = TRUE
	max_w_class = WEIGHT_CLASS_NORMAL
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
	desc = "Instant research tool. For testing purposes only. PUTS ALL RESEARCH TECHS TO MAX, EVEN ILLEGAL AND ARCANE."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = list(TECH_MATERIAL = 19, TECH_ENGINEERING = 19, TECH_PHORON = 19, TECH_POWER = 19, TECH_BLUESPACE = 19, TECH_BIO = 19, TECH_COMBAT = 19, TECH_MAGNET = 19, TECH_DATA = 19, TECH_ILLEGAL = 19, TECH_ARCANE = 19)
