/* Two-handed Weapons
 * Contains:
 * * Twohanded
 * * Fireaxe
 * * Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/material/twohanded
	w_class = WEIGHT_CLASS_BULKY
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wield_sound = /singleton/sound_category/generic_wield_sound
	var/unwield_sound = null
	var/base_name
	var/unwielded_force_divisor = 0.25
	var/parry_chance = 15
	action_button_name = "Wield two-handed weapon"
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_twohanded.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_twohanded.dmi'
		)
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound
	equip_sound = /singleton/sound_category/sword_equip_sound
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/material/twohanded/proc/wield()
	wielded = 1
	force = force_wielded
	update_icon()
	if(src.wield_sound)
		playsound(src.loc, wield_sound, 25, 1)

/obj/item/material/twohanded/proc/unwield()
	wielded = 0
	force = force_unwielded
	name = "[base_name]"
	update_icon()
	if(src.unwield_sound)
		playsound(src.loc, unwield_sound, 25, 1)

/obj/item/material/twohanded/update_force()
	base_name = name
	if(sharp || edge)
		force_wielded = material.get_edge_damage()
	else
		force_wielded = material.get_blunt_damage()
	force_wielded = round(force_wielded*force_divisor)
	force_unwielded = round(force_wielded*unwielded_force_divisor)
	force = force_unwielded
	throwforce = round(force*thrown_force_divisor)

/obj/item/material/twohanded/Initialize(newloc, material_key)
	. = ..()
	update_icon()

/obj/item/material/twohanded/mob_can_equip(var/mob/user, slot, disable_warning = FALSE)
	if(wielded)
		unwield()
		var/obj/item/material/twohanded/offhand/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return ..()

/obj/item/material/twohanded/can_swap_hands(mob/user)
	if(wielded)
		unwield()
		var/obj/item/material/twohanded/offhand/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return ..()

/obj/item/material/twohanded/dropped(mob/user)
	. = ..()
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/material/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return	unwield()

//Allow a small chance of parrying melee attacks when wielded - maybe generalize this to other weapons someday
/obj/item/material/twohanded/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(parry_chance))
		user.visible_message(SPAN_DANGER("\The [user] parries [attack_text] with \the [src]!"))
		playsound(user.loc, /singleton/sound_category/punchmiss_sound, 50, 1)
		return BULLET_ACT_BLOCK
	return BULLET_ACT_HIT

/obj/item/material/twohanded/update_icon()
	icon_state = "[base_icon][wielded]"
	item_state = icon_state

/obj/item/material/twohanded/pickup(mob/user)
	..()
	unwield()

/obj/item/material/twohanded/attack_self(mob/user as mob)

	..()

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(issmall(H))
			to_chat(user, SPAN_WARNING("It's too heavy for you to wield fully."))
			return
	else
		return

	if(!istype(user.get_active_hand(), src))
		to_chat(user, SPAN_WARNING("You need to be holding the [name] in your active hand."))
		return

	if(wielded) //Trying to unwield it
		unwield()
		to_chat(user, SPAN_NOTICE("You are now carrying the [name] with one hand."))

		var/obj/item/material/twohanded/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			user.u_equip(O)
			O.unwield()

	else //Trying to wield it
		var/obj/item/offhand_item = user.get_inactive_hand()
		if(offhand_item)
			user.unEquip(offhand_item, FALSE, user.loc)
		if(user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You need your other hand to be empty."))
			return
		wield()
		to_chat(user, SPAN_NOTICE("You grip the [base_name] with both hands."))

		var/obj/item/material/twohanded/offhand/O = new /obj/item/material/twohanded/offhand(user) ////Let's reserve his other hand~
		O.name = "[base_name] - offhand"
		O.desc = "Your second grip on the [base_name]."
		user.put_in_inactive_hand(O)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	return

/obj/item/material/twohanded/ui_action_click()
	if(src in usr)
		attack_self(usr)

/obj/item/material/twohanded/verb/wield_twohanded()
	set name = "Wield Two-Handed Weapon"
	set category = "Object.Held"
	set src in usr

	attack_self(usr)

///////////OFFHAND///////////////
/obj/item/material/twohanded/offhand
	w_class = WEIGHT_CLASS_HUGE
	icon_state = "offhand"
	name = "offhand"
	default_material = "placeholder"
	drop_sound = null
	pickup_sound = null
	equip_sound = null
	use_material_sound = FALSE

/obj/item/material/twohanded/offhand/unwield()
	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

/obj/item/material/twohanded/offhand/wield()
	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

/obj/item/material/twohanded/offhand/update_icon()
	return

/*
 * Fireaxe
 */
/obj/item/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	unwielded_force_divisor = 0.25
	force_divisor = 0.7 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	sharp = 1
	edge = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	can_embed = 0
	use_material_sound = FALSE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	worth_multiplier = 31

/obj/item/material/twohanded/fireaxe/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

/obj/item/material/twohanded/fireaxe/pre_attack(var/mob/living/target, var/mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)
	if(istype(target) && wielded)
		cleave(user, target)
	..()

/obj/item/material/twohanded/fireaxe/can_woodcut()
	return TRUE

//spears, bay edition
/obj/item/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	force_divisor = 0.35 // 21 damage for steel (hardness 60)
	unwielded_force_divisor = 0.2 // 12 damage for steel (hardness 60)
	thrown_force_divisor = 1.2 // 24 damage for steel (weight 20)
	edge = TRUE
	sharp = 0
	mob_throw_hit_sound =  'sound/weapons/pierce.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"
	var/obj/item/grenade/explosive = null
	use_material_sound = FALSE
	worth_multiplier = 7 //blade + stuff

/obj/item/material/twohanded/spear/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!explosive)
		. += "You can strap a grenade of any type to head of this spear, which will explode on thrown impact."
	. += "You can impale a severed head on a spear, if you're into that sort of thing. Most people don't like this."

/obj/item/material/twohanded/spear/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(explosive)
		. += SPAN_ALERT("It has \the [explosive] strapped to it.")

/obj/item/material/twohanded/spear/Destroy()
	if(explosive)
		QDEL_NULL(explosive)
	return ..()

/obj/item/material/twohanded/spear/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/organ/external/head))
		to_chat(user, SPAN_NOTICE("You stick the head onto the spear and stand it upright on the ground."))
		var/obj/structure/headspear/HS = new /obj/structure/headspear(user.loc)
		var/matrix/M = matrix()
		attacking_item.transform = M
		usr.drop_from_inventory(attacking_item, HS)
		var/mutable_appearance/MA = new(attacking_item)
		MA.layer = FLOAT_LAYER
		HS.AddOverlays(MA)
		HS.name = "[attacking_item.name] on a spear"
		HS.material = material.name
		qdel(src)
		return

	if(istype(attacking_item, /obj/item/grenade))
		to_chat(user, SPAN_NOTICE("You strap \the [attacking_item] to \the [src]."))
		user.unEquip(attacking_item)
		attacking_item.forceMove(src)
		explosive = attacking_item
		update_icon()
		return
	return ..()

/obj/item/material/twohanded/spear/update_icon()
	if(explosive)
		icon_state = "spearbomb[wielded]"
		item_state = "spearbomb[wielded]"
	else
		icon_state = "spearglass[wielded]"
		item_state = "spearglass[wielded]"

/obj/item/material/twohanded/spear/attack(mob/living/target_mob, mob/living/user, target_zone)
	..()

	if(wielded && explosive)
		explosive.prime()
		explosive = null
		update_icon()
		src.shatter()

/obj/item/material/twohanded/spear/throw_impact(atom/hit_atom)
	. = ..()
	if(!.) //not caught
		if(explosive)
			explosive.prime()
			explosive = null
			update_icon()
			src.shatter()

//predefined materials for spears
/obj/item/material/twohanded/spear/steel/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_STEEL)

/obj/item/material/twohanded/spear/plasteel/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_PLASTEEL)

/obj/item/material/twohanded/spear/diamond/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_DIAMOND)

/obj/item/material/twohanded/spear/silver/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_SILVER)

/obj/structure/headspear
	name = "head on a spear"
	desc = "How barbaric."
	icon_state = "headspear"
	density = 0
	anchored = 1

/obj/structure/headspear/attack_hand(mob/living/user)
	user.visible_message(SPAN_WARNING("[user] kicks over \the [src]!"), SPAN_DANGER("You kick down \the [src]!"))
	new /obj/item/material/twohanded/spear(user.loc, material)
	for(var/obj/item/organ/external/head/H in src)
		H.forceMove(user.loc)
	qdel(src)

// Chainsaws!
/obj/item/material/twohanded/chainsaw
	name = "chainsaw"
	desc = "A robust tree-cutting chainsaw intended to cut down various types of invasive spaceplants that grow on stations."
	icon_state = "chainsaw_off"
	base_icon = "chainsaw_off"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 15
	force_unwielded = 10
	force_wielded = 20
	throwforce = 5
	w_class = WEIGHT_CLASS_BULKY
	sharp = TRUE
	edge = TRUE
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	can_embed = FALSE
	applies_material_colour = FALSE
	default_material = "steel"
	parry_chance = 5
	var/fuel_type = /singleton/reagent/fuel
	var/opendelay = 30 // How long it takes to perform a door opening action with this chainsaw, in seconds.
	var/max_fuel = 300 // The maximum amount of fuel the chainsaw stores.
	var/fuel_cost = 1 // Multiplier for fuel cost.

	var/cutting = FALSE //Ignore
	var/powered = FALSE //Ignore
	use_material_sound = FALSE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/material/twohanded/chainsaw/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "ALT-click on this in-hand to rev it and toggle it on or off."

/obj/item/material/twohanded/chainsaw/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "A heavy-duty chainsaw meant for cutting wood. Contains <b>[round(REAGENT_VOLUME(reagents, fuel_type))]</b> unit\s of fuel."
		if(powered)
			. += SPAN_NOTICE("It is currently powered on.")

/obj/item/material/twohanded/chainsaw/Initialize()
	. = ..()
	create_reagents(max_fuel)

/obj/item/material/twohanded/chainsaw/fueled/Initialize()
	. = ..()
	reagents.add_reagent(fuel_type, max_fuel)

/obj/item/material/twohanded/chainsaw/can_woodcut()
	if(powered)
		return TRUE
	else
		return ..()

/obj/item/material/twohanded/chainsaw/op //For events or whatever
	opendelay = 5
	max_fuel = 1000
	fuel_cost = 0.5
	unbreakable = TRUE
	parry_chance = 100 //Gotta punish those validhunters
	default_material = "plasteel"

/obj/item/material/twohanded/chainsaw/op/Initialize()
	. = ..()
	reagents.add_reagent(fuel_type, max_fuel)

/obj/item/material/twohanded/chainsaw/proc/PowerUp()
	var/turf/T = get_turf(src)
	T.audible_message(SPAN_NOTICE("\The [src] rumbles to life."))
	playsound(src, 'sound/weapons/saw/chainsawstart.ogg', 25, 0, 30)
	force_unwielded = 30
	force = force_unwielded
	force_wielded = 60
	if(wielded)
		force = force_wielded
	throwforce = 20
	icon_state = "chainsaw_on"
	base_icon = "chainsaw_on"
	slot_flags = null
	START_PROCESSING(SSfast_process, src)
	powered = TRUE
	update_held_icon()

/obj/item/material/twohanded/chainsaw/proc/PowerDown()
	var/turf/T = get_turf(src)
	T.audible_message(SPAN_NOTICE("\The [src] slowly powers down."))
	force_unwielded = initial(force_unwielded)
	force = force_unwielded
	force_wielded = initial(force_wielded)
	if(wielded)
		force = force_wielded
	throwforce = initial(throwforce)
	hitsound = initial(hitsound)
	icon_state = initial(icon_state)
	base_icon = initial(base_icon)
	slot_flags = initial(slot_flags)
	STOP_PROCESSING(SSfast_process, src)
	powered = FALSE
	update_held_icon()

/obj/item/material/twohanded/chainsaw/shatter(var/consumed)
	var/turf/T = get_turf(src)
	new /obj/effect/decal/cleanable/blood/oil(T)
	new /obj/effect/decal/cleanable/liquid_fuel(T)
	new /obj/item/trash/uselessplastic(T)
	. = ..()

/obj/item/material/twohanded/chainsaw/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	return ..()

/obj/item/material/twohanded/chainsaw/proc/RemoveFuel(var/amount = 1)
	if(reagents && istype(reagents))
		amount *= fuel_cost
		reagents.remove_reagent(fuel_type, clamp(amount,0,REAGENT_VOLUME(reagents, fuel_type)))
		if(REAGENT_VOLUME(reagents, fuel_type) <= 0)
			PowerDown()
	else
		PowerDown()

/obj/item/material/twohanded/chainsaw/process()
	//TickRate is 0.1
	var/FuelToRemove = 0.1 //0.1 Every 0.1 seconds
	if(cutting)
		FuelToRemove = 1
		playsound(loc, 'sound/weapons/saw/chainsawloop2.ogg', 25, 0, 30)
		if(prob(75))
			spark(src, 3, GLOB.alldirs)
			if(prob(25) && isliving(loc))
				if(loc.flash_act())
					to_chat(loc, SPAN_DANGER("Some stray sparks fly into your eyes!"))
	else
		playsound(loc, 'sound/weapons/saw/chainsawloop1.ogg', 25, 0, 30)

	RemoveFuel(FuelToRemove)

/obj/item/material/twohanded/chainsaw/attack(mob/living/target_mob, mob/living/user, target_zone)
	. = ..()
	if(powered)
		playsound(loc, 'sound/weapons/saw/chainsword.ogg', 25, 0, 30)
		RemoveFuel(3)

/obj/item/material/twohanded/chainsaw/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !powered)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You refuel \the [src]."))
		playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if(powered)
		if(!istype(O))
			user.visible_message(SPAN_DANGER("[user] revs the chainsaw!"), SPAN_WARNING("You rev the chainsaw!"), SPAN_WARNING("You hear a chainsaw rev!"))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			playsound(loc, 'sound/weapons/saw/chainsword.ogg', 25, 0, 30)
			RemoveFuel(3)
	. = ..()

/obj/item/material/twohanded/chainsaw/AltClick(mob/user)
	if(powered)
		PowerDown(user)
	else if(!wielded)
		to_chat(user, SPAN_WARNING("You need to hold this with two hands to turn this on."))
	else if(REAGENT_VOLUME(reagents, /singleton/reagent/fuel) <= 0)
		user.visible_message(SPAN_WARNING("[user] pulls the cord on \the [src], but nothing happens."), SPAN_WARNING("You pull the cord on \the [src], but nothing happens."), SPAN_NOTICE("You hear a cord being pulled."))
	else
		var/max = rand(3,6)
		for(var/i in 1 to max)
			user.visible_message(SPAN_WARNING("[user] pulls the cord on \the [src]..."), SPAN_NOTICE("You pull the cord on \the [src]..."), SPAN_NOTICE("You hear a cord being pulled and an engine sputtering..."))
			if(i == max)
				PowerUp(user)
			else
				playsound(loc, 'sound/weapons/saw/chainsawpull.ogg', 50, 0, 15)
				if(!do_after(user, 2 SECONDS))
					break

/obj/item/material/twohanded/chainsaw/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target) && wielded && powered)
		cleave(user, target)
	..()

/obj/item/material/twohanded/chainsaw/update_icon()
	// Just an override.

/obj/item/material/twohanded/chainsaw/verb/toggle_power()
	set name = "Toggle Chainsaw Power"
	set category = "Object.Held"
	set src in usr

	AltClick(usr)

/obj/item/material/twohanded/pike
	icon_state = "pike0"
	base_icon = "pike"
	name = "pike"
	desc = "A long spear used by the infantry in ancient times."
	force = 11
	unwielded_force_divisor = 0.2
	force_divisor = 0.3
	edge = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "poked", "jabbed", "gored", "stabbed")
	default_material = "steel"
	reach = 2
	applies_material_colour = 0
	can_embed = 0
	use_material_sound = FALSE
	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'
	worth_multiplier = 20

/obj/item/material/twohanded/pike/halberd
	icon_state = "halberd0"
	base_icon = "halberd"
	name = "halberd"
	desc = "A sharp axe mounted on the top of a long spear."
	force = 15
	unwielded_force_divisor = 0.4
	force_divisor = 0.6
	sharp = 1
	attack_verb = list("attacked", "poked", "jabbed","gored", "chopped", "cleaved", "torn", "cut", "stabbed")
	worth_multiplier = 30

/obj/item/material/twohanded/pike/halberd/can_woodcut()
	if(wielded)
		return TRUE
	else
		return ..()

/obj/item/material/twohanded/pike/pitchfork
	icon_state = "pitchfork0"
	base_icon = "pitchfork"
	name = "pitchfork"
	desc = "An old farming tool, not something you would find at hydroponics."
	worth_multiplier = 10

/obj/item/material/twohanded/pike/flag
	name = "republic of biesel flag"
	desc = "For the republic!"
	icon_state = "flag_biesel0"
	base_icon = "flag_biesel"
	default_material = "bronze"
	can_embed = 1
	use_material_name = FALSE
	unbreakable = TRUE
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	action_button_name = "Plant Flag"
	var/planted = FALSE

/obj/item/material/twohanded/pike/flag/verb/plant()
	set name = "Plant Flag"
	set category = "Object.Held"
	set src in usr

	if(ishuman(usr))
		var/mob/living/user = usr
		user.drop_from_inventory(src)
		icon_state = "[base_icon]_planted"
		anchored = TRUE
		planted = TRUE
		pixel_x = 16
		pixel_y = 4
		user.visible_message(SPAN_DANGER("[user] plants [src] proudly into the ground!"), SPAN_DANGER("You plant [src] proudly into the ground!"))

/obj/item/material/twohanded/pike/flag/attack_hand(var/mob/user)
	if(planted)
		icon_state = initial(icon_state)
		planted = FALSE
		anchored = FALSE
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
		user.visible_message(SPAN_NOTICE("[user] grabs [src]."), SPAN_NOTICE("You grab [src] from where it stands."))
		..()
	else
		..()

/obj/item/material/twohanded/pike/flag/ui_action_click()
	plant()

/obj/item/material/twohanded/pike/flag/hegemony
	name = "izweski hegemony flag"
	desc = "For the Hegemon!"
	desc_extended = "\"Honor, Fire, Burn thy Fear\" - the famous motto of the Izweski, the clan that leads the largest nation of Unathi."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "flag_hegemony0"
	base_icon = "flag_hegemony"
	contained_sprite = TRUE
	damtype = DAMAGE_BURN

/obj/item/material/twohanded/pike/silver/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_SILVER)

/obj/item/material/twohanded/zweihander
	icon_state = "zweihander0"
	base_icon = "zweihander"
	name = "zweihander"
	desc = "A german upgrade to the einhander models of ancient times."
	force = 25
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	force_wielded = 30
	unwielded_force_divisor = 1
	thrown_force_divisor = 0.75
	edge = TRUE
	sharp = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	default_material = "steel"
	parry_chance = 60
	can_embed = 0
	worth_multiplier = 35
	var/wielded_ap = 40
	var/unwielded_ap = 0

/obj/item/material/twohanded/zweihander/pre_attack(var/mob/living/target, var/mob/living/user)
	if(!wielded && istype(target))
		cleave(user, target)
	..()

/obj/item/material/twohanded/zweihander/unwield()
	..()
	reach = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	armor_penetration = unwielded_ap

/obj/item/material/twohanded/zweihander/wield()
	..()
	reach = 2
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	armor_penetration = wielded_ap

/obj/item/material/twohanded/pike/halberd/warscythe
	name = "war scythe"
	desc = "An ancient Unathi weapon, this heavy polearm was frequently wielded by cavalry forces of pre-Hegemony kingdoms."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "warspike0"
	base_icon = "warspike"
	contained_sprite = TRUE
	applies_material_colour = FALSE

/obj/item/material/twohanded/pike/halberd/warscythe/bronze/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_BRONZE)

/obj/item/material/twohanded/pike/mador_trident
	name = "ancient trident"
	desc = "An ancient weapon, this three-pointed polearm was often wielded by the ancient Sinta'Mador civilization of Moghes."
	icon = 'icons/obj/unathi_ruins.dmi'
	icon_state = "mador_trident0"
	base_icon = "mador_trident"
	contained_sprite = TRUE
	applies_material_colour = FALSE

/obj/item/material/twohanded/pike/mador_trident/bronze/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_BRONZE)
