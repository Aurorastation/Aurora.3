/obj/item/weapon/material/axe
	name = "felling axe"
	desc = "An axe used to chop down trees."
	icon = 'icons/adhomai/weapons.dmi'
	icon_state = "axe"
	item_state = "axe"
	contained_sprite = TRUE
	force_divisor = 0.3
	thrown_force_divisor = 0.3
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT

/obj/item/device/flashlight/flare/torch
	name = "torch"
	desc = "A rustic source of light."
	light_color = LIGHT_COLOR_FIRE
	icon = 'icons/adhomai/weapons.dmi'
	icon_state = "torch"
	item_state = "torch"
	contained_sprite = TRUE
	on_damage = 15

/obj/item/device/flashlight/flare/torch/update_icon()
	if(!fuel)
		icon_state = "[initial(icon_state)]-empty"
		item_state = "[initial(item_state)]-empty"
		set_light(0)
		return
	if(on)
		icon_state = "[initial(icon_state)]-on"
		item_state = "[initial(item_state)]-on"
		set_light(brightness_on)
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		set_light(0)

/obj/item/device/flashlight/flare/torch/attack_self(mob/user)
	return

/obj/item/device/flashlight/flare/torch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(on)
		return
	if(!fuel)
		return
	if(W.iswelder())
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			light(user)
	else if(isflamesource(W))
		light(user)
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light(user)
	else if(istype(W, /obj/item/device/flashlight/flare/torch))
		var/obj/item/device/flashlight/flare/torch/T = W
		if(T.on)
			light(user)

	// All good, turn it on.
/obj/item/device/flashlight/flare/torch/proc/light(var/mob/user)
	user.visible_message("<span class='notice'>[user] lights \the [src].</span>", "<span class='notice'>You light \the [src]!</span>")
	on = TRUE
	force = on_damage
	damtype = "fire"
	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()
	START_PROCESSING(SSprocessing, src)


/obj/item/weapon/material/sword/sabre/meteoric
	default_material = "meteoric iron"

/obj/item/weapon/material/sword/amohdan_sword/meteoric
	default_material = "meteoric iron"

/obj/item/weapon/material/blacksmith_hammer
	name = "blacksmith hammer"
	desc = "A hammer used to repair or craft tools.."
	icon = 'icons/adhomai/blacksmith.dmi'
	icon_state = "hammer"
	item_state = "hammer"
	contained_sprite = TRUE
	force_divisor = 0.3
	thrown_force_divisor = 0.3
	sharp = FALSE
	edge = FALSE
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	slot_flags = SLOT_BELT

/obj/item/weapon/material/caltrops
	name = "caltrops"
	desc = "A sharp antipersonnel weapon. Useful to delay advances."
	icon = 'icons/adhomai/items.dmi'
	icon_state = "caltrop1"
	w_class = 1
	force_divisor = 0.1
	thrown_force_divisor = 0.3
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "sliced", "torn", "ripped", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	applies_material_colour = FALSE

/obj/item/weapon/material/caltrops/Initialize()
	. = ..()
	icon_state = "caltrop[pick(1,2,3)]"
/obj/item/weapon/material/caltrops/Crossed(AM as mob|obj)
	..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/damage_coef = 1
		if(H.buckled)
			return

		to_chat(H, "<span class='danger'>You step on \the [src]!</span>")
		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)

		if(H.species.siemens_coefficient<0.5 || isunathi(H) || isvaurca(H) || (H.species.flags & (NO_EMBED)))
			damage_coef -= 0.2

		if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
			damage_coef -= 0.2

		var/list/check = list("l_foot", "r_foot")
		while(check.len)
			var/picked = pick(check)
			var/obj/item/organ/external/affecting = H.get_organ(picked)
			if(affecting)
				if(affecting.status & ORGAN_ROBOT)
					damage_coef -= 0.2
					return
				if(affecting.take_damage(20*damage_coef, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
				return
			check -= picked
		return