/datum/technomancer/equipment/tesla_armor
	name = "Tesla Armor"
	desc = "This piece of armor offers a retaliation-based defense.  When the armor is 'ready', it will completely protect you from \
	the next attack you suffer, and strike the attacker with a strong bolt of lightning, provided they are close enough.  This effect requires \
	fifteen seconds to recharge.  If you are attacked while this is recharging, a weaker lightning bolt is sent out, however you won't be protected from \
	the person beating you."
	cost = 150
	obj_path = /obj/item/clothing/suit/armor/tesla

/obj/item/clothing/suit/armor/tesla
	name = "tesla armor"
	desc = "This rather dangerous looking armor will hopefully shock your enemies, and not you in the process."
	icon_state = "tesla_armor_1"
	blood_overlay_type = "armor"
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	action_button_name = "Toggle Tesla Armor"
	var/active = 1	//Determines if the armor will zap or block
	var/ready = 1 //Determines if the next attack will be blocked, as well if a strong lightning bolt is sent out at the attacker.
	var/ready_icon_state = "tesla_armor_1" //also wip
	var/normal_icon_state = "tesla_armor_0"
	var/cooldown_to_charge = 20 SECONDS

/obj/item/clothing/suit/armor/tesla/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	//First, some retaliation.
	if(active)
		if(istype(damage_source, /obj/item/projectile))
			var/obj/item/projectile/P = damage_source
			if(P.firer && get_dist(user, P.firer) <= 3)
				if(ready)
					shoot_lightning(P.firer, 2000)
				else
					shoot_lightning(P.firer, 1000, /obj/item/projectile/beam/lightning/small)

		else
			if(attacker && attacker != user)
				if(get_dist(user, attacker) <= 3) //Anyone farther away than three tiles is too far to shoot lightning at.
					if(ready)
						shoot_lightning(attacker, 2000)
					else
						shoot_lightning(attacker, 1000, /obj/item/projectile/beam/lightning/small)

		//Deal with protecting our wearer now.
		if(ready)
			ready = FALSE
			addtimer(CALLBACK(src, PROC_REF(recharge), user), cooldown_to_charge)
			visible_message("<span class='danger'>\The [user]'s [src.name] blocks [attack_text]!</span>")
			update_icon()
			return PROJECTILE_STOPPED
	return FALSE

/obj/item/clothing/suit/armor/tesla/proc/recharge(var/mob/user)
	ready = TRUE
	update_icon()
	to_chat(user, "<span class='notice'>\The [src] is ready to protect you once more.</span>")

/obj/item/clothing/suit/armor/tesla/attack_self(mob/user)
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "de"]activate \the [src].</span>")
	update_icon()
	user.update_inv_wear_suit()
	user.update_action_buttons()

/obj/item/clothing/suit/armor/tesla/update_icon()
	if(active && ready)
		icon_state = ready_icon_state
		item_state = ready_icon_state
		set_light(2, 1, l_color = "#006AFF")
	else
		icon_state = normal_icon_state
		item_state = normal_icon_state
		set_light(0, 0, l_color = "#000000")

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_wear_suit(0)
		H.update_action_buttons()
	..()

/obj/item/clothing/suit/armor/tesla/proc/shoot_lightning(mob/target, power, lightning_type = /obj/item/projectile/beam/lightning)
	var/obj/item/projectile/beam/lightning/lightning = new lightning_type(get_turf(src))
	lightning.power = power
	lightning.old_style_target(target)
	lightning.fire()
	visible_message("<span class='danger'>\The [src] strikes \the [target] with lightning!</span>")
	playsound(src, 'sound/weapons/gaussrifle1.ogg', 75, 1)