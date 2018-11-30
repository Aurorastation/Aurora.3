/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT."
	icon_state = "ionrifle"
	item_state = "ionrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = 4
	accuracy = 1
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	charge_cost = 300
	max_shots = 10
	projectile_type = /obj/item/projectile/ion
	can_turret = 1
	turret_sprite_set = "ion"
	pin = /obj/item/device/firing_pin/blacklist

/obj/item/weapon/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/weapon/gun/energy/ionrifle/update_icon()
	..()
	if(power_supply.charge < charge_cost)
		item_state = "ionrifle-empty"
	else
		item_state = initial(item_state)

/obj/item/weapon/gun/energy/ionrifle/mounted
	name = "mounted ion rifle"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/weapon/gun/energy/deauth
	name = "\improper Lawgiver Mk I"
	desc = "A somewhat advanced firearm for the modern bureaucracy. It has multiple voice-activated firing modes."
	icon_state = "lawgiver"
	item_state = "gun"
	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/item/projectile/energy/flash
	max_shots = 8
	var/blacklist = 0
	var/fine = 0
	var/scan = 0

	firemodes = list(
		list(mode_name="flash", projectile_type=/obj/item/projectile/energy/flash, fire_sound='sound/weapons/gunshot_pistol.ogg'),
		list(mode_name="deauthenticate", projectile_type=/obj/item/projectile/energy/deauth, fire_sound='sound/weapons/Laser.ogg'),
		list(mode_name="fine", projectile_type=/obj/item/projectile/energy/deauth, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="scan", projectile_type=/obj/item/projectile/energy/deauth, fire_sound='sound/weapons/Taser.ogg')
		)

/obj/item/weapon/gun/energy/deauth/Initialize()
	. = ..()
	listening_objects += src
	power_supply = new /obj/item/weapon/cell/device/variable(src, 2000)
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

/obj/item/weapon/gun/energy/deauth/Destroy()
	listening_objects -= src
	return ..()

/obj/item/weapon/gun/energy/deauth/attack_self(mob/living/carbon/user as mob)
	switch(sel_mode)
		if(3)
			var/increment = 0
			if(fine >= 15000)
				fine = 0

			switch(fine)
				if(0 to 500)
					increment = 50
				if(501 to 1000)
					increment = 100
				if(1000 to 15000)
					increment = 1000

			fine += increment

		else
			var/obj/item/weapon/spacecash/ewallet/E
			for(var/obj/item/weapon/spacecash/ewallet/EE in src)
				E = EE
				break
			if(E)
				if(ishuman(user) && !user.get_inactive_hand())
					user.put_in_inactive_hand(E)
				else
					E.forceMove(get_turf(src))
				playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)

/obj/item/weapon/gun/energy/deauth/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	if (self_recharge) addtimer(CALLBACK(src, .proc/try_recharge), recharge_time * 2 SECONDS, TIMER_UNIQUE)

	if(istype(projectile_type, /obj/item/projectile/energy/deauth))
		var/obj/item/projectile/energy/deauth/D = new projectile_type(src)
		D.blacklist = blacklist
		D.fine = fine

		D.scan = scan
		D.lawgiver = src
		return D

	else
		return new projectile_type(src)

/obj/item/weapon/gun/energy/deauth/hear_talk(mob/living/M in range(0,src), msg)
	var/mob/living/carbon/human/H = M
	if (!H || !istype(H))
		return
	if((src in H.contents))
		hear(msg)
	return

/obj/item/weapon/gun/energy/deauth/proc/hear(var/msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	msg = sanitize_old(msg, replacechars)
	/* Firing Modes*/
	if(findtext(msg,"flash"))
		sel_mode = 1
		visible_message("<span class='warning'>\icon[src] [src.name] states: <b>\"[src.name] is now set to flash shell.\"</b></span>")
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		blacklist = 0
		scan = 0
		fine = 0

	else if(findtext(msg,"weapons access"))
		sel_mode = 2
		blacklist = NO_WEAPONS
		visible_message("<span class='warning'>\icon[src] [src.name] states: <b>\"[src.name] is now set to deauthentice weapons access.\"</b></span>")
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		scan = 0
		fine = 0

	else if(findtext(msg,"fine target"))
		sel_mode = 3
		visible_message("<span class='warning'>\icon[src] [src.name] states: <b>\"[src.name] is now set to administrative fines. Please manually set fine amount.\"</b></span>")
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		blacklist = 0
		scan = 0

	else if(findtext(msg,"approval scan"))
		sel_mode = 4
		scan = 1
		visible_message("<span class='warning'>\icon[src] [src.name] states: <b>\"[src.name] is now set to approval scan.\"</b></span>")
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		blacklist = 0
		fine = 0

	else if(findtext(msg,"megaphone"))
		visible_message("<span class='warning'>\icon[src] [src.name] states: <FONT size=3>\"[msg]\"</FONT></span>")
		playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 100, 1)

	else if(findtext(msg,"joke"))
		var/jokes = pick("I was going to attend the clairvoyants meeting, but it was cancelled due to unforeseen events.", "Two cannibals are eating a clown. One cannibal turns to the other and asks, \'Does this taste funnysto you?\'", \
					"Two atoms are in a bar. One says, \'I think I lost an electron.\' The other says, \'Are you sure?\' To which the first replies, \'I'm positive.\'", "A neutron walks into a bar. \'How much for a drink here, anyway?\' To which the bartender responds, \'For you, no charge.\'", \
					"I once visited a crematorium that gave discounts for burn victims.", "Photons have mass? I didn't even know they were Catholic.", "War doesn't determine who is right, only who is left", "The past, the present and the future walked into a bar, it was tense.", \
					"What has 4 letters, sometimes has 9 letters, and always has 6 letters, but never has 5 letters.", "Two fish swim into a concrete wall. One turns to the other and says, \'Dam\'.", "I’ve decided to sell the vacuum. It’s just collecting dust", \
					"A blind man walks into a bar. And a table. And a chair.", "There is a band called one thousand and twenty three megabytes. They haven’t had any gigs yet.", "What do you call two crows on a branch? Attempted Murder.", "Chemically speaking, alcohol IS a solution.", \
					"How do you kill a circus clown? Go for the juggler.", "The bartender says, \'We don’t serve faster than light particles in here.\' A tachyon walks into a bar.", "If 4 out of 5 people suffer from phoron poisoning... Does that mean the fifth guy enjoys it?", \
					"How about a pizza joke? Nevermind it’s just too cheesy", "What is the best way to start a parade in Phoenixport? Roll a 40 down the street.", "What did the Democratic People's Republic of Adhomai light their houses with before they used candles? Electricity.", \
					"A photon checks into a hotel and the bellhop asks if she has any luggage. The photon replies, \'No, I’m traveling light.\'", "What do people from Mars have in common with a bottle of beer? They’re both empty from the neck up.", "An assassin, a terrorist, and a Vaurca walk into a bar. It orders a drink", \
					"Relationships are a lot like algebra. You always look at your X and try to figure out Y.")

		visible_message("<span class='warning'>\icon[src] [src.name] states: \"[jokes]\"</span>")
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)

/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	item_state = "decloner"
	fire_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 3)
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/declone

/obj/item/weapon/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "floramut"
	fire_sound = 'sound/effects/stealthoff.ogg'
	charge_cost = 100
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	modifystate = "floramut"
	self_recharge = 1

	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/item/projectile/energy/floramut, modifystate="floramut"),
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, modifystate="florayield")
		)

/obj/item/weapon/gun/energy/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/weapon/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "meteor_gun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 4
	max_shots = 10
	projectile_type = /obj/item/projectile/meteor
	self_recharge = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0
	can_turret = 1
	turret_sprite_set = "meteor"

/obj/item/weapon/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = 1
	slot_flags = SLOT_BELT
	can_turret = 0


/obj/item/weapon/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A custom-built weapon of some kind."
	icon_state = "xray"
	projectile_type = /obj/item/projectile/beam/mindflayer
	fire_sound = 'sound/weapons/Laser.ogg'
	can_turret = 1
	turret_sprite_set = "xray"

/obj/item/weapon/gun/energy/toxgun
	name = "phoron pistol"
	desc = "A specialized firearm designed to fire lethal bolts of phoron."
	icon_state = "toxgun"
	fire_sound = 'sound/effects/stealthoff.ogg'
	w_class = 3.0
	origin_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	projectile_type = /obj/item/projectile/energy/phoron
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "net"

/obj/item/weapon/gun/energy/beegun
	name = "\improper NanoTrasen Portable Apiary"
	desc = "An experimental firearm that converts energy into bees, for purely botanical purposes."
	icon_state = "gyrorifle"
	item_state = "arifle"
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/effects/Buzz2.ogg'
	force = 5
	projectile_type = /obj/item/projectile/energy/bee
	slot_flags = SLOT_BACK
	max_shots = 9
	sel_mode = 1
	burst = 3
	burst_delay = 1
	move_delay = 3
	fire_delay = 0
	dispersion = list(0, 8)

/obj/item/weapon/gun/energy/mousegun
	name = "\improper NT \"Arodentia\" Exterminator ray"
	desc = "A highly sophisticated and certainly experimental raygun designed for rapid pest-control."
	icon_state = "floramut100"
	item_state = "floramut"
	charge_meter = 0
	w_class = 3
	fire_sound = 'sound/weapons/taser2.ogg'
	force = 5
	projectile_type = /obj/item/projectile/beam/mousegun
	slot_flags = SLOT_HOLSTER | SLOT_BELT
	max_shots = 6
	sel_mode = 1
	burst = 3
	burst_delay = 1
	move_delay = 0
	fire_delay = 3
	dispersion = list(0, 15, 15)

	var/lightfail = 0

/obj/item/weapon/gun/energy/mousegun/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0, var/playemote = 1)
	var/T = get_turf(user)
	spark(T, 3, alldirs)
	..()

/obj/item/weapon/gun/energy/net
	name = "net gun"
	desc = "A gun designed to deploy energy nets to capture animals or unruly crew members."
	icon_state = "netgun"
	projectile_type = /obj/item/projectile/beam/energy_net
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_HOLSTER | SLOT_BELT
	w_class = 3
	max_shots = 4
	fire_delay = 25
	can_turret = 1
	turret_is_lethal = 0
	turret_sprite_set = "net"

/obj/item/weapon/gun/energy/net/mounted
	max_shots = 1
	self_recharge = 1
	use_external_power = 1
	recharge_time = 40
	can_turret = 0

/* Vaurca Weapons */

/obj/item/weapon/gun/energy/vaurca
	name = "Alien Firearm"
	desc = "Vaurcae weapons tend to be specialized and highly lethal. This one doesn't do much"
	var/is_charging = 0 //special var for sanity checks in the three guns that currently use charging as a special_check

/obj/item/weapon/gun/energy/vaurca/bfg
	name = "BFG 9000"
	desc = "'Bio-Force Gun'. Yeah, right."
	icon_state = "bfg"
	item_state = "bfg"
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/bfg
	slot_flags = SLOT_BACK
	max_shots = 3
	sel_mode = 1
	fire_delay = 10
	accuracy = 20
	muzzle_flash = 10

#define GATLINGLASER_DISPERSION_CONCENTRATED list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
#define GATLINGLASER_DISPERSION_SPRAY list(0, 5, 5, 10, 10, 15, 15, 20, 20, 25, 25, 30, 30, 35, 40, 45)

/obj/item/weapon/gun/energy/vaurca/gatlinglaser
	name = "gatling laser"
	desc = "A highly sophisticated rapid fire laser weapon."
	icon_state = "gatling"
	item_state = "gatling"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6)
	charge_meter = 0
	slot_flags = SLOT_BACK
	w_class = 4
	force = 10
	projectile_type = /obj/item/projectile/beam/gatlinglaser
	max_shots = 80
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 10
	dispersion = GATLINGLASER_DISPERSION_CONCENTRATED

	firemodes = list(
		list(mode_name="concentrated burst", burst=10, burst_delay = 1, fire_delay = 10, dispersion = GATLINGLASER_DISPERSION_CONCENTRATED),
		list(mode_name="spray", burst=20, burst_delay = 1, move_delay = 5, fire_delay = 30, dispersion = GATLINGLASER_DISPERSION_SPRAY)
		)

	action_button_name = "Wield gatling laser"
	charge_cost = 50

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/can_wield()
	return 1

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/verb/wield_rifle()
	set name = "Wield gatling laser"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/gatlinglaser/special_check(var/mob/user)
	if(is_charging)
		user << "<span class='danger'>\The [src] is already spinning!</span>"
		return 0
	if(!wielded)
		user << "<span class='danger'>You cannot fire this weapon with just one hand!</span>"
		return 0
	playsound(src, 'sound/weapons/chainsawstart.ogg', 90, 1)
	user.visible_message(
					"<span class='danger'>\The [user] begins spinning [src]'s barrels!</span>",
					"<span class='danger'>You begin spinning [src]'s barrels!</span>",
					"<span class='danger'>You hear the spin of a rotary gun!</span>"
					)
	is_charging = 1
	if(!do_after(user, 30))
		return 0
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

	return ..()

/obj/item/weapon/gun/energy/vaurca/blaster
	name = "\improper Zo'ra Blaster"
	desc = "An elegant weapon for a more civilized time."
	icon_state = "blaster"
	item_state = "blaster"
	origin_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4)
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BACK | SLOT_HOLSTER | SLOT_BELT
	w_class = 3
	accuracy = 1
	force = 10
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 6
	sel_mode = 1
	burst = 1
	burst_delay = 1
	fire_delay = 0
	can_turret = 1
	turret_sprite_set = "laser"
	firemodes = list(
		list(mode_name="single shot", burst=1, burst_delay = 1, fire_delay = 0),
		list(mode_name="concentrated burst", burst=3, burst_delay = 1, fire_delay = 5)
		)

/obj/item/weapon/gun/energy/vaurca/typec
	name = "thermal lance"
	desc = "A powerful piece of Zo'rane energy artillery, converted to be portable...if you weigh a metric tonne, that is."
	icon = 'icons/mob/species/breeder/inventory/items.dmi'
	icon_state = "megaglaive0"
	item_state = "megaglaive"
	item_icons = list(//DEPRECATED. USE CONTAINED SPRITES IN FUTURE
		slot_l_hand_str = 'icons/mob/species/breeder/held_l.dmi',
		slot_r_hand_str = 'icons/mob/species/breeder/held_r.dmi'
		)
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 8)
	fire_sound = 'sound/magic/lightningbolt.ogg'
	attack_verb = list("sundered", "annihilated", "sliced", "cleaved", "slashed", "pulverized")
	slot_flags = SLOT_BACK
	w_class = 5
	accuracy = 3 // It's a massive beam, okay.
	force = 60
	projectile_type = /obj/item/projectile/beam/megaglaive
	max_shots = 36
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 30
	sharp = 1
	edge = 1
	anchored = 0
	armor_penetration = 40
	flags = NOBLOODY
	can_embed = 0
	self_recharge = 1
	recharge_time = 2
	needspin = FALSE

	action_button_name = "Wield thermal lance"

/obj/item/weapon/gun/energy/vaurca/typec/can_wield()
	return 1

/obj/item/weapon/gun/energy/vaurca/typec/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/typec/verb/wield_rifle()
	set name = "Wield thermal lance"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/typec/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	user.setClickCooldown(16)
	..()

/obj/item/weapon/gun/energy/vaurca/typec/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	..()

/obj/item/weapon/gun/energy/vaurca/typec/special_check(var/mob/user)
	if(is_charging)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	if(!wielded)
		user << "<span class='danger'>You could never fire this weapon with merely one hand!</span>"
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	if(!do_after(user, 20))
		return 0
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

	return ..()

/obj/item/weapon/gun/energy/vaurca/typec/attack_hand(mob/user as mob)
	if(loc != user)
		var/mob/living/carbon/human/H = user
		if(H.mob_size >= 30)
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			anchored = 1
			user << "<span class='notice'>\The [src] is now energised.</span>"
			icon_state = "megaglaive1"
			..()
			return
		user << "<span class='warning'>\The [src] is far too large for you to pick up.</span>"
		return

/obj/item/weapon/gun/energy/vaurca/typec/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		icon_state = "megaglaive0"
		anchored = 0

/obj/item/weapon/gun/energy/vaurca/typec/update_icon()
	return

/obj/item/weapon/gun/energy/vaurca/thermaldrill
	name = "thermal drill"
	desc = "Pierce the heavens? Son, there won't <i>be</i> any heavens when you're through with it."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "thermaldrill"
	item_state = "thermaldrill"
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 8)
	fire_sound = 'sound/magic/lightningbolt.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	accuracy = 0 // Overwrite just in case.
	force = 15
	projectile_type = /obj/item/projectile/beam/thermaldrill
	max_shots = 90
	sel_mode = 1
	burst = 10
	burst_delay = 1
	fire_delay = 20
	self_recharge = 1
	recharge_time = 1
	charge_meter = 1
	charge_cost = 50
	can_turret = 1
	turret_sprite_set = "thermaldrill"

	firemodes = list(
		list(mode_name="2 second burst", burst=10, burst_delay = 1, fire_delay = 20),
		list(mode_name="4 second burst", burst=20, burst_delay = 1, fire_delay = 40),
		list(mode_name="6 second burst", burst=30, burst_delay = 1, fire_delay = 60)
		)

	action_button_name = "Wield thermal drill"

/obj/item/weapon/gun/energy/vaurca/thermaldrill/can_wield()
	return 1

/obj/item/weapon/gun/energy/vaurca/thermaldrill/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/thermaldrill/verb/wield_rifle()
	set name = "Wield thermal drill"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/vaurca/thermaldrill/special_check(var/mob/user)
	if(is_charging)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	if(!wielded)
		user << "<span class='danger'>You cannot fire this weapon with just one hand!</span>"
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	if(!do_after(user, 40))
		is_charging = FALSE
		return 0
	is_charging = 0
	if(!istype(user.get_active_hand(), src))
		return
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

	return ..()

/obj/item/weapon/gun/energy/vaurca/mountedthermaldrill
	name = "mounted thermal drill"
	desc = "Pierce the heavens? Son, there won't <i>be</i> any heavens when you're through with it."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "thermaldrill"
	item_state = "thermaldrill"
	origin_tech = "combat=6;phorontech=8,"
	fire_sound = 'sound/magic/lightningbolt.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	force = 15
	projectile_type = /obj/item/projectile/beam/thermaldrill
	max_shots = 90
	sel_mode = 1
	burst = 30
	burst_delay = 1
	fire_delay = 20
	self_recharge = 1
	recharge_time = 1
	charge_meter = 1
	use_external_power = 1
	charge_cost = 25

/obj/item/weapon/gun/energy/vaurca/mountedthermaldrill/special_check(var/mob/user)
	if(is_charging)
		user << "<span class='danger'>\The [src] is already charging!</span>"
		return 0
	user.visible_message(
					"<span class='danger'>\The [user] begins charging the [src]!</span>",
					"<span class='danger'>You begin charging the [src]!</span>",
					"<span class='danger'>You hear a low pulsing roar!</span>"
					)
	is_charging = 1
	if(!do_after(user, 20))
		return 0
	is_charging = 0
	msg_admin_attack("[key_name_admin(user)] shot with \a [src.type] [key_name_admin(src)]'s target (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src))

	return ..()

/obj/item/weapon/gun/energy/vaurca/tachyon
	name = "tachyon carbine"
	desc = "A Vaurcan carbine that fires a beam of concentrated faster than light particles, capable of passing through most forms of matter."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "tachyoncarbine"
	item_state = "tachyoncarbine"
	fire_sound = 'sound/weapons/laser3.ogg'
	projectile_type = /obj/item/projectile/beam/tachyon
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	max_shots = 10
	accuracy = 1
	fire_delay = 1
	can_turret = 0

/obj/item/weapon/gun/energy/tesla
	name = "tesla gun"
	desc = "A gun that shoots a projectile that bounces from living thing to living thing. Keep your distance from whatever you are shooting at."
	icon_state = "tesla"
	item_state = "tesla"
	icon = 'icons/obj/gun.dmi'
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/magic/LightningShock.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/tesla
	slot_flags = SLOT_BACK
	max_shots = 3
	sel_mode = 1
	fire_delay = 10
	accuracy = 80
	muzzle_flash = 15

/obj/item/weapon/gun/energy/gravity_gun
	name = "gravity gun"
	desc = "This nifty gun disables the gravity in the area you shoot at. Use with caution."
	icon_state = "gravity_gun"
	item_state = "gravity_gun"
	icon = 'icons/obj/gun.dmi'
	charge_meter = 0
	w_class = 4
	fire_sound = 'sound/magic/Repulse.ogg'
	force = 30
	projectile_type = /obj/item/projectile/energy/gravitydisabler
	slot_flags = SLOT_BACK
	max_shots = 2
	sel_mode = 1
	fire_delay = 20
	accuracy = 40
	muzzle_flash = 10
