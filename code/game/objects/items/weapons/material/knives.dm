/*
 * Knives. They stab your eyes out, and fit into boots. Copypasted the screwdriver code
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	contained_sprite = TRUE
	icon_state = "knife"
	item_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	obj_flags = OBJ_FLAG_CONDUCTABLE
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
	surgerysound = 'sound/items/surgery/scalpel.ogg'

/obj/item/material/knife/bloody/Initialize()
	. = ..()
	src.add_blood()

/obj/item/material/knife/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(active == 1)
		if((target_zone != BP_EYES && target_zone != BP_HEAD) || target_mob.eyes_protected(src, FALSE))
			return ..()
		if((user.is_clumsy()) && prob(50))
			target_mob = user
		return eyestab(target_mob,user)

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
	var/choice = tgui_input_list(usr, "Select an external organ to extract any embedded or implanted item from.", "Organ Selection", available_organs)
	if(!choice)
		return

	var/obj/item/organ/external/O = available_organs[choice]
	for(var/thing in O.implants)
		var/obj/S = thing
		usr.visible_message(SPAN_NOTICE("[usr] starts carefully digging out something in [H == usr ? "themselves" : H]..."))
		O.take_damage(8, 0, DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE, src)
		H.custom_pain(SPAN_DANGER("<font size=3>It burns!</font>"), 50)
		if(do_mob(usr, H, 100))
			H.remove_implant(S, FALSE)
			log_and_message_admins("has extracted [S] out of [key_name(H)]")
		H.emote("scream")

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/item/material/knife/ritual.dmi'
	icon_state = "render"
	item_state = "render"
	contained_sprite = TRUE
	applies_material_colour = FALSE

/obj/item/material/knife/ritual/bloody/Initialize()
	. = ..()
	src.add_blood()

/obj/item/material/knife/raskariim
	name = "adhomian ritual dagger"
	desc = "An adhomian knife used in occult rituals."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "raskariim_dagger"
	item_state = "raskariim_dagger"
	contained_sprite = TRUE
	applies_material_colour = FALSE

/obj/item/material/knife/bayonet
	name = "bayonet"
	desc = "A sharp military knife, can be attached to a rifle."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bayonet"
	item_state = "knife"
	applies_material_colour = 0
	force_divisor = 0.35
	can_embed = 0
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/material/knife/bayonet/silver/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_SILVER)

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
	w_class = WEIGHT_CLASS_NORMAL
	applies_material_colour = 0
	slot_flags = SLOT_BELT

/obj/item/material/knife/trench/silver/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_SILVER)

/obj/item/material/knife/trench/bloody/Initialize()
	. = ..()
	src.add_blood()


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
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("patted", "tapped")
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	worth_multiplier = 8

/obj/item/material/knife/butterfly/update_force()
	if(active)
		edge = TRUE
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		icon_state += "_open"
		item_state = icon_state
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = WEIGHT_CLASS_NORMAL
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
		to_chat(user, SPAN_NOTICE("You flip out \the [src]."))
		playsound(user, 'sound/weapons/blade_open.ogg', 15, 1)
	else
		to_chat(user, SPAN_NOTICE("\The [src] can now be concealed."))
		playsound(user, 'sound/weapons/blade_close.ogg', 15, 1)
	update_force()
	add_fingerprint(user)
