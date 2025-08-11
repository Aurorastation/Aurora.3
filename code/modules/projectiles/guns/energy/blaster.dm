/obj/item/gun/energy/blaster
	name = "blaster pistol"
	desc = "A tiny energy pistol converted to fire off energy bolts rather than lasers beams."
	icon = 'icons/obj/guns/blaster_pistol.dmi'
	icon_state = "blaster_pistol"
	item_state = "blaster_pistol"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = WEIGHT_CLASS_SMALL
	force = 11
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	offhand_accuracy = 1
	projectile_type = /obj/projectile/energy/blaster
	max_shots = 12

	burst_delay = 2
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=2,    burst_accuracy=list(1,0,0),       dispersion=list(0, 10, 15))
		)

/obj/item/gun/energy/blaster/mounted/mech
	name = "rapidfire blaster"
	desc = "An aged but reliable rapidfire blaster tuned to expel projectiles at high fire rates."
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/projectile/energy/blaster/heavy
	burst = 5
	burst_delay = 3
	max_shots = 30
	charge_cost = 100
	use_external_power = TRUE
	self_recharge = TRUE
	recharge_time = 1.5
	dispersion = list(3,6,9,12)
	firemodes = list()

/obj/item/gun/energy/blaster/pilot_special
	name = "pilot's sidearm"
	desc = "A robust, low in maintenance blaster pistol. Customized for peak performance and perfect for self-defense purposes."
	max_shots = 12
	accuracy = 2 // Likely to get nothing else, so they gotta know how to make it count.
	offhand_accuracy = 2

/obj/item/gun/energy/blaster/revolver
	name = "blaster revolver"
	desc = "A robust eight-shot blaster."
	icon = 'icons/obj/guns/blaster_revolver.dmi'
	icon_state = "blaster_revolver"
	item_state = "blaster_revolver"
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/projectile/energy/blaster
	max_shots = 8
	w_class = WEIGHT_CLASS_SMALL

/obj/item/gun/energy/blaster/revolver/unique_action(mob/living/user)
	user.visible_message(SPAN_WARNING("\The [user] spins the cylinder of \the [src]!"), SPAN_WARNING("You spin the cylinder of \the [src]!"), SPAN_NOTICE("You hear something metallic spin and click."))
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)

/obj/item/gun/energy/blaster/carbine
	name = "blaster carbine"
	desc = "A short-barreled blaster carbine meant for easy handling and comfort when in combat."
	icon = 'icons/obj/guns/blaster_carbine.dmi'
	icon_state = "blaster_carbine"
	item_state = "blaster_carbine"
	max_shots = 16
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	offhand_accuracy = 0
	projectile_type = /obj/projectile/energy/blaster
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/energy/blaster/rifle
	name = "bolt slinger"
	desc = "A blaster rifle which seems to work by accelerating particles and flinging them out in destructive bolts."
	icon = 'icons/obj/guns/blaster_rifle.dmi'
	icon_state = "blaster_rifle"
	item_state = "blaster_rifle"
	max_shots = 20
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	offhand_accuracy = 0
	projectile_type = /obj/projectile/energy/blaster/heavy

	force = 15
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	fire_delay = 25
	accuracy = -3
	scoped_accuracy = 4

	fire_delay_wielded = 10
	accuracy_wielded = 1

	is_wieldable = TRUE

/obj/item/gun/energy/blaster/rifle/verb/scope()
	set category = "Object.Held"
	set name = "Use Scope"
	set src in usr

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, SPAN_WARNING("You can't look through the scope without stabilizing the rifle!"))

/obj/item/gun/energy/blaster/tcaf
	name = "blaster rifle"
	desc = "Developed by Zavodskoi Interstellar, the Z.I. Guardian is a burst-fire blaster rifle designed for the armed forces of the Republic of Biesel. Cheap, reliable and easy to mass-produce, these weapons can be seen across the branches of the TCAF."
	desc_extended = "Released in early 2464, the Guardian is a modernisation of the outdated blasters previously used by the TCFL developed in conjunction with the Zo'ra Hive. Since its release, it has been widely adopted by Biesel, leading to a slight fall in NanoTrasen market share as Zavodskoi took their place as the main arms supplier of the TCAF."
	icon = 'icons/obj/guns/blaster_ar.dmi'
	icon_state = "blaster_ar"
	item_state = "blaster_ar"
	max_shots = 24
	projectile_type = /obj/projectile/energy/blaster/heavy
	fire_sound = 'sound/weapons/laserstrong.ogg'
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	is_wieldable = TRUE
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	accuracy = -1
	fire_delay = ROF_RIFLE
	fire_delay_wielded = 5
	burst_delay = 4
	accuracy_wielded = 2
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3, TECH_PHORON = 2)
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_INTERMEDIATE),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(2,1,1), dispersion=list(0, 7.5))
		)

/obj/item/gun/energy/blaster/himeo
	name = "himean assault blaster"
	desc = "The standard infantry blaster of the Himean Planetary Guard. 'TO RESIST EVIL BY FORCE' is stamped on the side."
	desc_extended = "Originally developed in 2351, the Type-11 \"Guthrie\" is a descendant of the first Himean-made weapons; haphazardly overcharged mining equipment. If it ain't broke, don't fix it; variants \
	of this rifle have served in the United Syndicates' arsenal for generations, although none have matched modern improvements 'borrowed' from Zavodskoi Interstellar. Waterproof, spaceproof, idiot-proof; it's here to stay, even as advanced Xanan ballistics \
	creep their way into the market. Ironically, lend-lease aid to the now-defunct League of Independent Corporate-Free Systems have seen a great deal of these end up in the hands of pirates."
	icon = 'icons/obj/guns/himeo_blaster.dmi'
	icon_state = "himeoblaster"
	item_state = "himeoblaster"
	projectile_type = /obj/projectile/energy/blaster/heavy
	usesound = 'sound/weapons/plasma_cutter.ogg'
	fire_sound = 'sound/weapons/gunshot/slammer.ogg'
	cell_type = /obj/item/cell/hydrogen
	needspin = FALSE // can't remove the cell if it has a pin
	charge_cost = 500 // 20 mag
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	is_wieldable = TRUE
	can_bayonet = FALSE
	sharp = FALSE
	edge = FALSE
	accuracy = -1
	fire_delay = ROF_RIFLE
	fire_delay_wielded = 5
	burst_delay = 4
	accuracy_wielded = 2
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3)
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_INTERMEDIATE),
		list(mode_name="2-round bursts", burst=2, burst_accuracy=list(2,1,1), dispersion=list(0, 7.5)),
		list(mode_name="full auto",	can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25)) //same as the assault rifle
		)

/obj/item/gun/energy/blaster/himeo/get_examine_text(mob/user, distance, is_adjacent, infix, suffix) //stolen from the plasma cutter
	. = ..()
	if(is_adjacent)
		if(power_supply)
			. += FONT_SMALL(SPAN_NOTICE("It has a <b>[capitalize_first_letters(power_supply.name)]</b> in the cell mount."))
		else
			. += FONT_SMALL(SPAN_WARNING("It has no cell installed."))

/obj/item/gun/energy/blaster/himeo/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(power_supply)
			playsound(user, 'sound/machines/compbeep1.ogg', 40, FALSE)
			to_chat(user, SPAN_NOTICE("You uninstall \the [power_supply]."))
			power_supply.forceMove(get_turf(src))
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.put_in_hands(power_supply)
			power_supply = null
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a cell installed!"))
	else if(istype(attacking_item, /obj/item/cell/hydrogen))
		if(power_supply)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell in the chamber!"))
		else
			playsound(user, 'sound/weapons/kinetic_reload.ogg', 40, FALSE)
			to_chat(user, SPAN_NOTICE("You install \the [attacking_item] into \the [src]."))
			user.drop_from_inventory(attacking_item, src)
			power_supply = attacking_item
			update_icon()
	else
		..()

/obj/item/gun/energy/blaster/himeo/afterattack(atom/A, mob/living/user) // if the cell is drained, eject it so we're not fumbling for a screwdriver mid-shootout
	..()
	if(power_supply.charge == 0)
		power_supply.forceMove(get_turf(src.loc))
		user.visible_message(
			"[power_supply] pops out of the cell mount!",
			SPAN_NOTICE("[power_supply] pops out of \the [src] and clatters on the floor!")
			)
		power_supply.update_icon()
		power_supply = null
		playsound(user, 'sound/machines/rig/rig_retract.ogg', 40, FALSE)
		update_icon()

/obj/item/gun/energy/blaster/himeo/pistol
	name = "himean heavy blaster pistol"
	desc = "The standard sidearm of the Himean Planetary Guard. For those revolutions you cannot fight with fists."
	desc_extended = "A plasma cutter gave its life for the first Type-45 \"Sabo-Tabby\" pistol. Powered by the same hydrogen cells as the Type-11 \"Guthrie\" rifle, this robust model has earned the nickname of \
	the 'One Big Handgun' in those foreign markets it has cropped up. What was initially seen as a flaw in the power converter led to its 'magnum'-sized blaster bolts."
	icon = 'icons/obj/guns/himeo_pistol.dmi'
	icon_state = "himeopistol"
	item_state = "himeopistol"
	projectile_type = /obj/projectile/energy/blaster/heavy
	usesound = 'sound/weapons/plasma_cutter.ogg'
	fire_sound = 'sound/weapons/laserstrong.ogg'
	charge_cost = 1250 // leaky but lethal
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = WEIGHT_CLASS_SMALL
	force = 11
	is_wieldable = FALSE
	can_bayonet = FALSE
	sharp = FALSE
	edge = FALSE
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3)
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_INTERMEDIATE)
		)
