/*
 * Knives. They stab your eyes out, and fit into boots. Copypasted the screwdriver code
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_kitchen.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_kitchen.dmi',
		)
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	flags = CONDUCT
	sharp = 1
	edge = TRUE
	var/active = 1 // For butterfly knives
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(DEFAULT_WALL_MATERIAL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	unbreakable = 1
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/material/knife/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(active == 1)
		if((target_zone != BP_EYES && target_zone != BP_HEAD) || M.eyes_protected(src, FALSE))
			return ..()
		if((user.is_clumsy()) && prob(50))
			M = user
		return eyestab(M,user)

/obj/item/material/knife/verb/extract_embedded(var/mob/living/carbon/human/H as mob in view(1))
	set name = "Extract Embedded Item"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(!istype(H))
		return

	var/list/available_organs = list()
	for(var/thing in H.organs)
		var/obj/item/organ/external/O = thing
		available_organs[capitalize_first_letters(O.name)] = O
	var/choice = input(usr, "Select an external organ to extract any embedded or implanted item from.", "Organ Selection") as null|anything in available_organs
	if(!choice)
		return

	var/obj/item/organ/external/O = available_organs[choice]
	for(var/thing in O.implants)
		var/obj/S = thing
		usr.visible_message("<span class='notice'>[usr] starts carefully digging out something in [H == usr ? "themselves" : H]...</span>")
		O.take_damage(8, 0, DAM_SHARP|DAM_EDGE, src)
		H.custom_pain("<font size=3><span class='danger'>It burns!</span></font>", 50)
		if(do_mob(usr, H, 100))
			H.remove_implant(S, FALSE)
			log_and_message_admins("has extracted [S] out of [key_name(H)]")
		H.emote("scream")

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "knife"
	applies_material_colour = 0

/obj/item/material/knife/bayonet
	name = "bayonet"
	desc = "A sharp military knife, can be attached to a rifle."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bayonet"
	item_state = "knife"
	applies_material_colour = 0
	force_divisor = 0.35
	can_embed = 0
	w_class = ITEMSIZE_NORMAL

/obj/item/material/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was Medal of Valor: Heroes of Tau Ceti."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_colour = 1
	force_divisor = 0.3 // 18 with hardness 60 (steel)

/obj/item/material/knife/trench
	name = "trench knife"
	desc = "A military knife used to slash and stab enemies in close quarters."
	force_divisor = 0.4
	icon = 'icons/obj/weapons.dmi'
	icon_state = "trench"
	item_state = "knife"
	w_class = ITEMSIZE_NORMAL
	applies_material_colour = 0
	slot_flags = SLOT_BELT

//Butterfly knives stab your eyes out too!

/obj/item/material/knife/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "butterfly"
	item_state = null
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_knives.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_knives.dmi',
		)
	hitsound = null
	active = 0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("patted", "tapped")
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)

/obj/item/material/knife/butterfly/update_force()
	if(active)
		edge = TRUE
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		icon_state += "_open"
		item_state = icon_state
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = ITEMSIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		edge = FALSE
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/material/knife/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "switchblade"
	unbreakable = 1

/obj/item/material/knife/butterfly/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
		playsound(user, 'sound/weapons/blade_open.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
		playsound(user, 'sound/weapons/blade_close.ogg', 15, 1)
	update_force()
	add_fingerprint(user)
