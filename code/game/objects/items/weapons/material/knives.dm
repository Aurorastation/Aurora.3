/*
 * Knives. They stab your eyes out, and fit into boots. Copypasted the screwdriver code
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	flags = CONDUCT
	sharp = 1
	edge = 1
	var/active = 1 // For butterfly knives
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(DEFAULT_WALL_MATERIAL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	unbreakable = 1
	drop_sound = 'sound/items/drop/knife.ogg'

/obj/item/material/knife/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(active == 1)
		if(target_zone != "eyes" && target_zone != "head")
			return ..()
		if((user.is_clumsy()) && prob(50))
			M = user
		return eyestab(M,user)

/obj/item/material/knife/verb/extract_shrapnel(var/mob/living/carbon/human/H as mob in view(1))
	set name = "Extract Shrapnel"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return

	if(!istype(H))
		return

	for(var/obj/item/material/shard/shrapnel/S in H.contents)
		visible_message("<span class='notice'>[usr] starts carefully digging out some of the shrapnel in [H == usr ? "themselves" : H]...</span>")
		to_chat(H, "<font size=3><span class='danger'>It burns!</span></font>")
		if(do_mob(usr, H, 100))
			S.forceMove(H.loc)
			log_and_message_admins("has extracted shrapnel out of [key_name(H)]")
		else
			break
		H.apply_damage(30, HALLOSS)
		if(prob(25))
			var/obj/item/organ/external/affecting = H.get_organ(H.zone_sel.selecting)
			if(affecting)
				to_chat(H, "<span class='danger'><font size=2>You feel something rip open in your [affecting.name]!</span></font>")
				var/datum/wound/internal_bleeding/I = new(15)
				affecting.wounds += I
		if(H.can_feel_pain())
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
	w_class = 3

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
	w_class = 3
	applies_material_colour = 0
	slot_flags = SLOT_BELT

//Butterfly knives stab your eyes out too!

/obj/item/material/knife/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "butterfly"
	item_state = null
	hitsound = null
	active = 0
	w_class = 2
	attack_verb = list("patted", "tapped")
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)

/obj/item/material/knife/butterfly/update_force()
	if(active)
		edge = 1
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		icon_state += "_open"
		item_state = icon_state
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = 3
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		edge = 0
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
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
	update_force()
	add_fingerprint(user)
