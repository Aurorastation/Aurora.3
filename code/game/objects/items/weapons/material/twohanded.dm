/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
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
	w_class = 4
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25
	var/parry_chance = 15
	action_button_name = "Wield two-handed weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"
	drop_sound = 'sound/items/drop/sword.ogg'

/obj/item/material/twohanded/proc/unwield()
	wielded = 0
	force = force_unwielded
	name = "[base_name]"
	update_icon()

/obj/item/material/twohanded/proc/wield()
	wielded = 1
	force = force_wielded
	update_icon()

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

/obj/item/material/twohanded/New()
	..()
	update_icon()

/obj/item/material/twohanded/mob_can_equip(M as mob, slot)
	//Cannot equip wielded items.
	if(wielded)
		to_chat(M, "<span class='warning'>Unwield the [base_name] first!</span>")
		return 0

	return ..()

/obj/item/material/twohanded/dropped(mob/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/material/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return	unwield()

//Allow a small chance of parrying melee attacks when wielded - maybe generalize this to other weapons someday
/obj/item/material/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(parry_chance))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

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
			to_chat(user, "<span class='warning'>It's too heavy for you to wield fully.</span>")
			return
	else
		return

	if(!istype(user.get_active_hand(), src))
		to_chat(user, "<span class='warning'>You need to be holding the [name] in your active hand.</span>")
		return

	if(wielded) //Trying to unwield it
		unwield()
		to_chat(user, "<span class='notice'>You are now carrying the [name] with one hand.</span>")
		if (src.unwieldsound)
			playsound(src.loc, unwieldsound, 50, 1)

		var/obj/item/material/twohanded/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			user.u_equip(O)
			O.unwield()

	else //Trying to wield it
		if(user.get_inactive_hand())
			to_chat(user, "<span class='warning'>You need your other hand to be empty.</span>")
			return
		wield()
		to_chat(user, "<span class='notice'>You grab the [base_name] with both hands.</span>")
		if (src.wieldsound)
			playsound(src.loc, wieldsound, 50, 1)

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
	set name = "Wield two-handed weapon"
	set category = "Object"
	set src in usr

	attack_self(usr)

///////////OFFHAND///////////////
/obj/item/material/twohanded/offhand
	w_class = 5
	icon_state = "offhand"
	name = "offhand"
	default_material = "placeholder"

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
	edge = 1
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	can_embed = 0
	drop_sound = 'sound/items/drop/axe.ogg'

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

//spears, bay edition
/obj/item/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 10
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_divisor = 0.35 // 21 damage for steel (hardness 60)
	unwielded_force_divisor = 0.2 // 12 damage for steel (hardness 60)
	thrown_force_divisor = 1.2 // 24 damage for steel (weight 20)
	edge = 1
	sharp = 0
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"
	var/obj/item/grenade/explosive = null

/obj/item/material/twohanded/spear/Destroy()
	if(explosive)
		QDEL_NULL(explosive)
	return ..()

/obj/item/material/twohanded/spear/examine(mob/user)
	..(user)
	if(explosive)
		to_chat(user, "It has \the [explosive] strapped to it.")

/obj/item/material/twohanded/spear/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/organ/external/head))
		to_chat(user, "<span class='notice'>You stick the head onto the spear and stand it upright on the ground.</span>")
		var/obj/structure/headspear/HS = new /obj/structure/headspear(user.loc)
		var/matrix/M = matrix()
		I.transform = M
		usr.drop_from_inventory(I,HS)
		var/mutable_appearance/MA = new(I)
		MA.layer = FLOAT_LAYER
		HS.add_overlay(MA)
		HS.name = "[I.name] on a spear"
		HS.material = material.name
		qdel(src)
		return

	if(istype(I, /obj/item/grenade))
		to_chat(user, "<span class='notice'>You strap \the [I] to \the [src].</span>")
		user.unEquip(I)
		I.forceMove(src)
		explosive = I
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

/obj/item/material/twohanded/spear/attack(mob/living/target, mob/living/user, var/target_zone)
	..()

	if(wielded && explosive)
		explosive.prime()
		explosive = null
		update_icon()
		src.shatter()

/obj/item/material/twohanded/spear/throw_impact(atom/target)
	. = ..()
	if(!.) //not caught
		if(explosive)
			explosive.prime()
			explosive = null
			update_icon()
			src.shatter()

//predefined materials for spears
/obj/item/material/twohanded/spear/steel/New(var/newloc)
	..(newloc, MATERIAL_STEEL)

/obj/item/material/twohanded/spear/plasteel/New(var/newloc)
	..(newloc, MATERIAL_PLASTEEL)

/obj/item/material/twohanded/spear/diamond/New(var/newloc)
	..(newloc, MATERIAL_DIAMOND)

/obj/structure/headspear
	name = "head on a spear"
	desc = "How barbaric."
	icon_state = "headspear"
	density = 0
	anchored = 1

/obj/structure/headspear/attack_hand(mob/living/user)
	user.visible_message("<span class='warning'>[user] kicks over \the [src]!</span>", "<span class='danger'>You kick down \the [src]!</span>")
	new /obj/item/material/twohanded/spear(user.loc, material)
	for(var/obj/item/organ/external/head/H in src)
		H.forceMove(user.loc)
	qdel(src)

// Chainsaws!
/obj/item/material/twohanded/chainsaw
	name = "chainsaw"
	desc = "A robust tree-cutting chainsaw intended to cut down various types of invasive spaceplants that grow on the station."
	icon_state = "chainsaw_off"
	base_icon = "chainsaw_off"
	flags = CONDUCT
	force = 10
	force_unwielded = 10
	force_wielded = 20
	throwforce = 5
	w_class = ITEMSIZE_LARGE
	sharp = 1
	edge = 1
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	hitsound = "sound/weapons/bladeslice.ogg"
	can_embed = 0
	applies_material_colour = 0
	default_material = "steel"
	parry_chance = 5
	var/fuel_type = "fuel"
	var/opendelay = 30 // How long it takes to perform a door opening action with this chainsaw, in seconds.
	var/max_fuel = 300 // The maximum amount of fuel the chainsaw stores.
	var/fuel_cost = 1 // Multiplier for fuel cost.

	var/cutting = 0 //Ignore
	var/powered = 0 //Ignore
	drop_sound = 'sound/items/drop/metalshield.ogg'

/obj/item/material/twohanded/chainsaw/Initialize()
	. = ..()
	create_reagents(max_fuel)

/obj/item/material/twohanded/chainsaw/fueled/Initialize()
	. = ..()
	reagents.add_reagent(fuel_type, max_fuel)

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
	T.audible_message(span("notice", "\The [src] rumbles to life."))
	playsound(src, "sound/weapons/chainsawstart.ogg", 25, 0, 30)
	force = 15
	force_unwielded = 30
	force_wielded = 60
	throwforce = 20
	icon_state = "chainsaw_on"
	base_icon = "chainsaw_on"
	slot_flags = null
	START_PROCESSING(SSfast_process, src)
	powered = 1
	update_held_icon()

/obj/item/material/twohanded/chainsaw/proc/PowerDown()
	var/turf/T = get_turf(src)
	T.audible_message(span("notice", "\The [src] slowly powers down."))
	force = initial(force)
	force_wielded = initial(force_wielded)
	throwforce = initial(throwforce)
	hitsound = initial(hitsound)
	icon_state = initial(icon_state)
	base_icon = initial(base_icon)
	slot_flags = initial(slot_flags)
	STOP_PROCESSING(SSfast_process, src)
	powered = 0
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
		reagents.remove_reagent(fuel_type, Clamp(amount,0,reagents.get_reagent_amount(fuel_type)))
		if(reagents.get_reagent_amount(fuel_type) <= 0)
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
			spark(src, 3, alldirs)
			if(prob(25))
				eyecheck(2,loc)
	else
		playsound(loc, 'sound/weapons/saw/chainsawloop1.ogg', 25, 0, 30)

	RemoveFuel(FuelToRemove)

/obj/item/material/twohanded/chainsaw/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A heavy-duty chainsaw meant for cutting wood. Contains [round(reagents.get_reagent_amount(fuel_type))] unit\s of fuel.")

/obj/item/material/twohanded/chainsaw/attack(mob/M as mob, mob/living/user as mob)
	. = ..()
	if(powered)
		playsound(loc, "sound/weapons/saw/chainsword.ogg", 25, 0, 30)
		RemoveFuel(3)

/obj/item/material/twohanded/chainsaw/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !powered)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>[src] refueled</span>")
		playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if(powered)
		if(!istype(O))
			user.visible_message(\
				"<span class='warning'>[user] revs the chainsaw!.</span>",\
				"<span class='warning'>You rev the chainsaw!.</span>",\
				"<span class='warning'>You hear a machine rev.</span>"\
			)

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			playsound(loc, "sound/weapons/saw/chainsword.ogg", 25, 0, 30)
			RemoveFuel(3)

	. = ..()

/obj/item/material/twohanded/chainsaw/proc/eyecheck(var/multiplier, mob/living/carbon/human/H as mob) //Shamefully copied from the welder. Damage values multiplied by 0.1

	if (!istype(H) || H.status_flags & GODMODE)
		return

	var/obj/item/organ/internal/eyes/E = H.get_eyes()
	if(!istype(E))
		return

	var/eye_damage = max(0, (2 - H.eyecheck())*multiplier )
	E.damage += eye_damage
	if(eye_damage > 0)
		to_chat(H, "<span class='danger'>Some stray sparks fly in your eyes!</span>")

/obj/item/material/twohanded/chainsaw/AltClick(mob/user as mob)

	if(powered)
		PowerDown(user)
	else if(!wielded)
		to_chat(user, "<span class='notice'>You need to hold this with two hands to turn this on.</span>")
	else if(reagents.get_reagent_amount("fuel") <= 0)
		user.visible_message(\
			"<span class='notice'>[user] pulls the cord on the [src], but nothing happens.</span>",\
			"<span class='notice'>You pull the cord on the [src], but nothing happens.</span>",\
			"<span class='notice'>You hear a cord being pulled.</span>"\
		)
	else
		var/max = rand(3,6)
		for(var/i in 1 to max)
			user.visible_message(\
				"<span class='notice'>[user] pulls the cord on the [src]...</span>",\
				"<span class='notice'>You pull the cord on the [src]...</span>",\
				"<span class='notice'>You hear a cord being pulled and an engine sputtering...</span>"\
			)
			if(i == max)
				PowerUp(user)
			else
				playsound(loc, 'sound/weapons/saw/chainsawpull.ogg', 50, 0, 15)
				if(!do_after(user, 2 SECONDS, act_target = user))
					break



/obj/item/material/twohanded/chainsaw/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target) && wielded && powered)
		cleave(user, target)
	..()

/obj/item/material/twohanded/chainsaw/update_icon()
	// Just an override.

/obj/item/material/twohanded/chainsaw/verb/toggle_power()
	set name = "Toggle power"
	set category = "Object"
	set src in usr

	AltClick(usr)


/obj/item/material/twohanded/pike
	icon_state = "pike0"
	base_icon = "pike"
	name = "pike"
	desc = "A long spear used by the infantry in ancient times."
	force = 5
	unwielded_force_divisor = 0.2
	force_divisor = 0.3
	edge = 1
	w_class = 4.0
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "poked", "jabbed", "gored", "stabbed")
	default_material = "steel"
	reach = 2
	applies_material_colour = 0
	can_embed = 0
	drop_sound = 'sound/items/drop/woodweapon.ogg'

/obj/item/material/twohanded/pike/halberd
	icon_state = "halberd0"
	base_icon = "halberd"
	name = "halberd"
	desc = "A sharp axe mounted on the top of a long spear."
	force = 10
	unwielded_force_divisor = 0.4
	force_divisor = 0.6
	sharp = 1
	attack_verb = list("attacked", "poked", "jabbed","gored", "chopped", "cleaved", "torn", "cut", "stabbed")

/obj/item/material/twohanded/pike/pitchfork
	icon_state = "pitchfork0"
	base_icon = "pitchfork"
	name = "pitchfork"
	desc = "An old farming tool, not something you would find at hydroponics."

/obj/item/material/twohanded/zweihander
	icon_state = "zweihander0"
	base_icon = "zweihander0"
	name = "zweihander"
	desc = "A german upgrade to the einhander models of ancient times."
	force = 20
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_wielded = 30
	unwielded_force_divisor = 1
	thrown_force_divisor = 0.75
	edge = 1
	sharp = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	default_material = "steel"
	parry_chance = 60
	can_embed = 0
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
