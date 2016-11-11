/obj/item/weapon/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 4
	force_divisor = 0.7 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_embed = 0

/obj/item/weapon/material/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	item_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/material/sword/rapier
	name = "rapier"
	desc = "A slender, fancy and sharply pointed sword."
	icon = 'icons/obj/sword.dmi'
	icon_state = "rapier"
	item_state = "rapier"
	contained_sprite = 1
	slot_flags = SLOT_BELT
	attack_verb = list("attacked", "stabbed", "prodded", "poked", "lunged")

/obj/item/weapon/material/sword/longsword
	name = "longsword"
	desc = "A double-edged large blade."
	icon_state = "longsword"
	item_state = "claymore"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/material/sword/trench
	name = "trench knife"
	desc = "A military knife used to slash and stab enemies in close quarters."
	force_divisor = 0.4
	icon_state = "trench"
	item_state = "knife"
	w_class = 3
	slot_flags = SLOT_BELT
	
/obj/item/weapon/material/sword/trench/IsShield()
	return 0
	
/obj/item/weapon/material/sword/sabre
	name = "sabre"
	desc = "A sharp curved backsword."
	icon_state = "sabre"
	item_state = "katana"
	slot_flags = SLOT_BELT
	
/obj/item/weapon/material/sword/axe
	name = "battle axe"
	desc = "A one handed battle axe, still a deadly weapon."
	icon = 'icons/obj/sword.dmi'
	icon_state = "axe"
	item_state = "axe"
	contained_sprite = 1
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0

