/obj/item/weapon/material/axe
	name = "felling axe"
	desc = "An axe used to chop down trees."
	icon = 'icons/adhomai/weapons.dmi'
	icon_state = "axe"
	item_state = "axe"
	contained_sprite = TRUE
	force_divisor = 0.3
	thrown_force_divisor = 0.5
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
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
	force = on_damage
	damtype = "fire"
	update_icon()
	START_PROCESSING(SSprocessing, src)