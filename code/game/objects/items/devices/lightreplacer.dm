
// Light Replacer (LR)
//
// ABOUT THE DEVICE
//
// This is a device supposedly to be used by Janitors and Janitor Cyborgs which will
// allow them to easily replace lights. This was mostly designed for Janitor Cyborgs since
// they don't have hands or a way to replace lightbulbs.
//
// HOW IT WORKS
//
// You attack a light fixture with it, if the light fixture is broken it will replace the
// light fixture with a working light; the broken light is then placed on the floor for the
// user to then pickup with a trash bag. If it's empty then it will just place a light in the fixture.
//
// HOW TO REFILL THE DEVICE
//
// It can be manually refilled or by clicking on a storage item containing lights.
// If it's part of a robot module, it will charge when the Robot is inside a Recharge Station.
//
// EMAGGED FEATURES
//
// NOTICE: The Cyborg cannot use the emagged Light Replacer and the light's explosion was nerfed. It cannot create holes in the station anymore.
//
// I'm not sure everyone will react the emag's features so please say what your opinions are of it.
//
// When emagged it will rig every light it replaces, which will explode when the light is on.
// This is VERY noticable, even the device's name changes when you emag it so if anyone
// examines you when you're holding it in your hand, you will be discovered.
// It will also be very obvious who is setting all these lights off, since only Janitor Borgs and Janitors have easy
// access to them, and only one of them can emag their device.
//
// The explosion cannot insta-kill anyone with 30% or more health.


/obj/item/device/lightreplacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs or sheets of glass."
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "lightreplacer"
	item_state = "lightreplacer"

	flags = CONDUCT
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 2)

	var/max_uses = 20
	var/uses = 10
	var/emagged = 0
	var/failmsg = ""
	var/charge = 0
	var/load_interval = 60
	var/store_broken = 0//If set, this lightreplacer will suck up and store broken bulbs
	var/max_stored = 10

/obj/item/device/lightreplacer/advanced
	name = "advanced light replacer"
	desc = "A specialised light replacer which stores more lights, refills faster from boxes, and sucks up broken bulbs. Empty into a disposal or trashbag when full!"
	icon_state = "adv_lightreplacer"
	item_state = "adv_lightreplacer"
	w_class = ITEMSIZE_SMALL
	store_broken = 1
	load_interval = 10
	max_uses = 30
	uses = 0 //Starts empty
	
/obj/item/device/lightreplacer/New()
	failmsg = "The [name]'s refill light blinks red."
	..()

/obj/item/device/lightreplacer/examine(mob/user)
	if(..(user, 2))
		to_chat(user, "It has [uses] lights remaining.")
		if (store_broken)
			to_chat(user, "It is storing [stored()]/[max_stored] broken lights.")

/obj/item/device/lightreplacer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == "glass")
		var/obj/item/stack/G = W
		if(uses >= max_uses)
			to_chat(user, SPAN_WARNING("[src.name] is full."))
		else if(G.use(5))
			AddUses(2)
			if (prob(50))
				AddUses(1)
			to_chat(user, SPAN_NOTICE("You insert five pieces of glass into the [src]. You have [uses] light\s remaining."))
		else
			to_chat(user, SPAN_WARNING("You need 5 sheets of glass to replace lights."))
		return

	if(istype(W, /obj/item/light))
		var/obj/item/light/L = W
		if(L.status == 0) // LIGHT OKAY
			if(uses < max_uses)
				AddUses(1)
				to_chat(user, SPAN_NOTICE("You insert \the [L] into \the [src]. You have [uses] light\s remaining."))
				user.drop_from_inventory(L,get_turf(src))
				qdel(L)
		else
			to_chat(user, SPAN_WARNING("You need a working light."))
		return

	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(LR.uses == LR.max_uses)
			to_chat(user, SPAN_WARNING("\The [LR] is already full!"))
			return
		var/use_difference = min(LR.max_uses - LR.uses, uses)
		AddUses(-use_difference)
		LR.AddUses(use_difference)
		to_chat(user, SPAN_NOTICE("You transfer the lights from \the [src] to \the [LR]."))
		return


/obj/item/device/lightreplacer/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if (istype(target, /obj/item/storage/box))
		if (box_contains_lights(target))
			load_lights_from_box(target, user)
		else
			to_chat(user, "This box has no bulbs in it!")


/obj/item/device/lightreplacer/proc/box_contains_lights(var/obj/item/storage/box/box)
	for (var/obj/item/light/L in box.contents)
		if (L.status == 0)
			return 1
	return 0


/obj/item/device/lightreplacer/proc/load_lights_from_box(var/obj/item/storage/box/box, var/mob/user)
	var/boxstartloc = box.loc
	var/ourstartloc = src.loc
	user.visible_message(SPAN_NOTICE("[user] starts loading lights from the [box] into their [src]"), SPAN_NOTICE("You start loading lights from the [box] into the [src]"))
	while (uses < max_uses)
		var/bulb = null
		for (var/obj/item/light/L in box.contents)
			if (L.status == 0)
				bulb = L
				break

		if (!bulb)
			to_chat(user, SPAN_WARNING("There are no more working lights left in the box!"))
			return

		if (do_after(user, load_interval, needhand = 0) && boxstartloc == box.loc && ourstartloc == src.loc)
			if(uses >= max_uses) //catches loading from multiple boxes
				break
			uses++
			to_chat(user, SPAN_NOTICE("Light loaded: [uses]/[max_uses]"))
			playsound(src.loc, 'sound/machines/click.ogg', 20, 1)
			box.remove_from_storage(bulb,get_turf(box))
			qdel(bulb)
		else
			to_chat(user, SPAN_WARNING("You need to keep the [src] close to the box!"))
			return

	to_chat(user, SPAN_NOTICE("The [src]'s refill light shines a solid green, indicating it's full and ready to go!"))

/obj/item/device/lightreplacer/proc/stored()
	var/count = 0
	for (var/obj/item/light/L in src)
		count++

	return count

/obj/item/device/lightreplacer/attack_self(mob/user)
	to_chat(usr, "It has [uses] lights remaining.")

/obj/item/device/lightreplacer/update_icon()
	if(emagged)
		add_overlay("emagged")


/obj/item/device/lightreplacer/proc/Use(var/mob/user)

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	AddUses(-1)
	return 1

// Negative numbers will subtract
/obj/item/device/lightreplacer/proc/AddUses(var/amount = 1)
	uses = min(max(uses + amount, 0), max_uses)

/obj/item/device/lightreplacer/proc/Charge(var/mob/user, var/amount = 1)
	charge += amount
	if(charge > 3)
		AddUses(1)
		charge = 0

/obj/item/device/lightreplacer/proc/ReplaceLight(var/obj/machinery/light/target, var/mob/living/U)

	if(target.status != LIGHT_OK)
		if(CanUse(U))
			if(!Use(U)) return
			to_chat(U, SPAN_NOTICE("You replace the [target.fitting] with the [src]."))

			if(target.status != LIGHT_EMPTY)

				var/obj/item/light/L1 = new target.light_type(target.loc)
				L1.status = target.status
				L1.rigged = target.rigged
				L1.brightness_range = target.brightness_range
				L1.brightness_power = target.brightness_power
				L1.brightness_color = target.brightness_color
				L1.switchcount = target.switchcount
				target.switchcount = 0
				target.inserted_light = L1.type
				L1.update()

				target.status = LIGHT_EMPTY
				target.update()

				if (store_broken)
					if (stored() < max_stored)
						L1.forceMove(src)
						to_chat(U, SPAN_NOTICE("\The [src] neatly sucks the broken [target.fitting] into its internal storage. Now storing [stored()]/[max_stored] broken bulbs"))
					else
						to_chat(U, SPAN_DANGER("\The [src] tries to suck up the broken [target.fitting] but it has no more space. Empty it into the trash!"))

			var/obj/item/light/L2 = new target.light_type()

			target.status = L2.status
			target.switchcount = L2.switchcount
			target.rigged = emagged
			target.brightness_range = L2.brightness_range
			target.brightness_power = L2.brightness_power
			target.brightness_color = L2.brightness_color
			target.inserted_light = L2.type
			target.update()
			qdel(L2)

			if(!target.stat && target.rigged)
				target.explode()
			return

		else
			to_chat(U, failmsg)
			return
	else
		to_chat(U, "There is a working [target.fitting] already inserted.")
		return

/obj/item/device/lightreplacer/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	playsound(src.loc, /decl/sound_category/spark_sound, 100, 1)
	update_icon()
	return 1

//Can you use it?

/obj/item/device/lightreplacer/proc/CanUse(var/mob/living/user)
	src.add_fingerprint(user)
	//Not sure what else to check for. Maybe if clumsy?
	if(uses > 0)
		return 1
	else
		return 0
