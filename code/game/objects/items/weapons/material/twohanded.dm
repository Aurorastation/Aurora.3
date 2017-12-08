/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
	w_class = 4
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25

	wielded = 0
	force = force_unwielded
	name = "[base_name]"
	update_icon()

	wielded = 1
	force = force_wielded
	name = "[base_name] (Wielded)"
	update_icon()

	base_name = name
	if(sharp || edge)
		force_wielded = material.get_edge_damage()
	else
		force_wielded = material.get_blunt_damage()
	force_wielded = round(force_wielded*force_divisor)
	force_unwielded = round(force_wielded*unwielded_force_divisor)
	force = force_unwielded
	throwforce = round(force*thrown_force_divisor)
	//world << "[src] has unwielded force [force_unwielded], wielded force [force_wielded] and throwforce [throwforce] when made from default material [material.name]"

	..()
	update_icon()

	//Cannot equip wielded items.
	if(wielded)
		M << "<span class='warning'>Unwield the [base_name] first!</span>"
		return 0

	return ..()

	if(user)
		if(istype(O))
			O.unwield()
	return	unwield()

	if(wielded && default_parry_check(user, attacker, damage_source) && prob(15))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		return 1
	return 0

	icon_state = "[base_icon][wielded]"
	item_state = icon_state

	unwield()


	..()

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(issmall(H))
			user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
			return
	else
		return

	if(wielded) //Trying to unwield it
		unwield()
		user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"
		if (src.unwieldsound)
			playsound(src.loc, unwieldsound, 50, 1)

		if(O && istype(O))
			user.u_equip(O)
			O.unwield()

	else //Trying to wield it
		if(user.get_inactive_hand())
			user << "<span class='warning'>You need your other hand to be empty</span>"
			return
		wield()
		user << "<span class='notice'>You grab the [base_name] with both hands.</span>"
		if (src.wieldsound)
			playsound(src.loc, wieldsound, 50, 1)

		O.name = "[base_name] - offhand"
		O.desc = "Your second grip on the [base_name]."
		user.put_in_inactive_hand(O)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	return

	if(src in usr)
		attack_self(usr)

	set category = "Object"
	set src in usr

	attack_self(usr)

///////////OFFHAND///////////////
	w_class = 5
	icon_state = "offhand"
	name = "offhand"
	default_material = "placeholder"

	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)
		
	qdel(src)

	return

/*
 * Fireaxe
 */
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	unwielded_force_divisor = 0.25
	force_divisor = 0.7 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	sharp = 1
	edge = 1
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0

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

//spears, bay edition
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	force = 10
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_wielded = 0.75           // 22 when wielded with hardness 15 (glass)
	unwielded_force_divisor = 0.65 // 14 when unwielded based on above
	thrown_force_divisor = 1.5 // 20 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 1
	sharp = 1
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"

//Putting heads on spears
		user << "<span class='notice'>You stick the head onto the spear and stand it upright on the ground.</span>"
		var/obj/structure/headspear/HS = new /obj/structure/headspear(user.loc)
		var/matrix/M = matrix()
		src.transform = M
		user.drop_item()
		src.loc = HS
		var/image/IM = image(src.icon,src.icon_state)
		IM.overlays = src.overlays.Copy()
		HS.overlays += IM
		qdel(W)
		qdel(src)
		return
	return ..()*/

	if(istype(I, /obj/item/organ/external/head))
		user << "<span class='notice'>You stick the head onto the spear and stand it upright on the ground.</span>"
		var/obj/structure/headspear/HS = new /obj/structure/headspear(user.loc)
		var/matrix/M = matrix()
		I.transform = M
		usr.drop_item()
		I.loc = HS
		var/image/IM = image(I.icon,I.icon_state)
		IM.overlays = I.overlays.Copy()
		HS.overlays += IM
		HS.name = "[I.name] on a spear"
		qdel(src)
		return
	return ..()

//predefined materials for spears
	..(newloc,"steel")

	..(newloc,"plasteel")

	..(newloc,"diamond")

/obj/structure/headspear
	name = "head on a spear"
	desc = "How barbaric."
	icon_state = "headspear"
	density = 0
	anchored = 1

/obj/structure/headspear/attack_hand(mob/living/user)
	user.visible_message("<span class='warning'>[user] kicks over \the [src]!</span>", "<span class='danger'>You kick down \the [src]!</span>")
	for(var/obj/item/organ/external/head/H in src)
		H.loc = user.loc
	qdel(src)
