//AMMUNITION

/obj/item/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	throwforce = 8
	w_class = ITEMSIZE_NORMAL
	sharp = TRUE
	edge = FALSE
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /decl/sound_category/sword_pickup_sound

/obj/item/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = TRUE
	edge = FALSE
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /decl/sound_category/sword_pickup_sound

/obj/item/arrow/quill
	name = "alien quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "quill"
	item_state = "quill"
	throwforce = 8
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'

/obj/item/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 20) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, SPAN_WARNING("\The [src] shatters into a scattering of unusable overstressed metal shards as it leaves the crossbow."))
		qdel(src)

/obj/item/gun/launcher/crossbow
	name = "powered crossbow"
	desc = "A 2457AD twist on an old classic. Pick up that can."
	icon = 'icons/obj/guns/crossbow.dmi'
	icon_state = "powered_crossbow"
	item_state = "crossbow-solid"
	fire_sound = 'sound/weapons/crossbow.ogg'
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK
	needspin = FALSE
	has_safety = FALSE

	var/obj/item/bolt
	var/tension = 0                         // Current draw on the bow.
	var/max_tension = 3                     // Highest possible tension.
	var/release_speed = 3                   // Speed per unit of tension.
	var/obj/item/cell/cell = null    // Used for firing superheated rods.
	var/current_user                        // Used to check if the crossbow has changed hands since being drawn.
	var/draw_time = 20						// How long it takes to increase the draw on the bow by one "tension"

/obj/item/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/launcher/crossbow/consume_next_projectile(mob/user)
	if(tension <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is not drawn back!"))
		return null
	return bolt

/obj/item/gun/launcher/crossbow/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = 0
	update_icon()
	..()

/obj/item/gun/launcher/crossbow/unique_action(mob/living/user)
	if(tension)
		if(bolt)
			user.visible_message("<b>[user]</b> relaxes the tension on \the [src]'s string and removes \the [bolt].", SPAN_NOTICE("You relax the tension on \the [src]'s string and remove \the [bolt]."))
			playsound(loc, 'sound/weapons/holster/tactiholsterout.ogg', 50, FALSE)
			bolt.forceMove(get_turf(src))
			var/obj/item/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("<b>[user]</b> relaxes the tension on \the [src]'s string.", SPAN_NOTICE("You relax the tension on \the [src]'s string."))
			playsound(loc, 'sound/weapons/holster/tactiholsterout.ogg', 50, FALSE)
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/proc/draw(var/mob/user)
	if(!bolt)
		to_chat(user, SPAN_WARNING("You don't have anything nocked to \the [src]."))
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("<b>[user]</b> begins to draw back the string of \the [src].", SPAN_NOTICE("You begin to draw back the string of \the [src]."))
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time)) //crossbow strings don't just magically pull back on their own.
			user.visible_message("<b>[user]</b> stops drawing and relaxes the string of \the [src].", SPAN_WARNING("You stop drawing back and relax the string of \the [src]."))
			playsound(loc, 'sound/weapons/holster/tactiholsterout.ogg', 50, FALSE)
			tension = 0
			update_icon()
			return

		//double check that the user hasn't removed the bolt in the meantime
		if(!(bolt && tension && loc == current_user))
			return

		tension++
		update_icon()

		if(tension >= max_tension)
			tension = max_tension
			playsound(loc, 'sound/weapons/unjam.ogg', 50, FALSE)
			to_chat(usr, SPAN_NOTICE("\The [src] clunks as you draw the string to its maximum tension!"))
			return

		user.visible_message("<b>[user]</b> draws back the string of \the [src]!", SPAN_NOTICE("You continue drawing back the string of \the [src]!"))
		playsound(loc, 'sound/weapons/reload_clip.ogg', 50, FALSE)

/obj/item/gun/launcher/crossbow/attackby(obj/item/W as obj, mob/user as mob)
	if(!bolt)
		if (istype(W, /obj/item/arrow))
			user.drop_from_inventory(W, src)
			bolt = W
			user.visible_message("<b>[user]</b> slides \the [bolt] into \the [src].", SPAN_NOTICE("You slide \the [bolt] into \the [src]."))
			update_icon()
			if(istype(W, /obj/item/arrow/rod) && W.throwforce < 15)
				// un-heated converted arrow rod
				superheat_rod(user)
			return
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				bolt.forceMove(src)
				update_icon()
				user.visible_message("<b>[user]</b> jams \the [bolt] into \the [src].", SPAN_NOTICE("You jam \the [bolt] into \the [src]."))
				superheat_rod(user)
			return

	if(istype(W, /obj/item/cell))
		if(!cell)
			user.drop_from_inventory(W, src)
			cell = W
			to_chat(user, SPAN_NOTICE("You jam \the [cell] into \the [src] and wire it to the firing coil."))
			superheat_rod(user)
		else
			to_chat(user, SPAN_NOTICE("\The [src] already has a cell installed."))

	else if(W.isscrewdriver())
		if(cell)
			var/obj/item/C = cell
			C.forceMove(get_turf(user))
			to_chat(user, SPAN_NOTICE("You jimmy \the [cell] out of \the [src] with \the [W]."))
			cell = null
		else
			to_chat(user, SPAN_NOTICE("\The [src] doesn't have a cell installed."))

	else if(istype(W, /obj/item/rfd))
		W.attackby(src, user)

	else
		..()

/obj/item/gun/launcher/crossbow/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !bolt)
		return
	if(cell.charge < 500)
		return
	if(bolt.throwforce >= 20)
		return
	if(!istype(bolt,/obj/item/arrow/rod))
		return

	to_chat(user, SPAN_WARNING("\The [bolt] plinks and crackles as it begins to glow red-hot."))
	bolt.throwforce = 20
	bolt.icon_state = "metal-rod-superheated"
	cell.use(500)

/obj/item/gun/launcher/crossbow/update_icon()
	if(tension > 1)
		icon_state = "[initial(icon_state)]-drawn"
	else if(bolt)
		icon_state = "[initial(icon_state)]-nocked"
	else
		icon_state = initial(icon_state)

// Crossbow construction.
/obj/item/crossbowframe
	name = "crossbow frame"
	desc = "A half-finished crossbow."
	icon_state = "crossbowframe0"
	item_state = "crossbow-solid"
	icon = 'icons/obj/weapons.dmi'
	var/buildstate = 0

/obj/item/crossbowframe/update_icon()
	icon_state = "crossbowframe[buildstate]"

/obj/item/crossbowframe/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) to_chat(user, "It has a loose rod frame in place.")
		if(2) to_chat(user, "It has a steel backbone welded in place.")
		if(3) to_chat(user, "It has a steel backbone and a cell mount installed.")
		if(4) to_chat(user, "It has a steel backbone, plastic limbs and a cell mount installed.")
		if(5) to_chat(user, "It has a steel cable loosely strung across the limbs.")

/obj/item/crossbowframe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/rods))
		if(buildstate == 0)
			var/obj/item/stack/rods/R = W
			if(R.use(3))
				to_chat(user, SPAN_NOTICE("You assemble a backbone of rods around the wooden stock."))
				buildstate++
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You need at least three rods to complete this task."))
			return
	else if(W.iswelder())
		if(buildstate == 1)
			var/obj/item/weldingtool/T = W
			if(T.use(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/welder_pry.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You weld the rods into place."))
			buildstate++
			update_icon()
		return
	else if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 2)
			if(C.use(5))
				to_chat(user, SPAN_NOTICE("You wire a crude cell mount into the top of the crossbow."))
				buildstate++
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You need at least five segments of cable coil to complete this task."))
			return
		else if(buildstate == 4)
			if(C.use(5))
				to_chat(user, SPAN_NOTICE("You string a steel cable across the crossbow's limbs."))
				buildstate++
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You need at least five segments of cable coil to complete this task."))
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == MATERIAL_PLASTIC)
		if(buildstate == 3)
			var/obj/item/stack/material/P = W
			if(P.use(3))
				to_chat(user, SPAN_NOTICE("You assemble and install heavy plastic limbs onto the crossbow."))
				buildstate++
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You need at least three plastic sheets to complete this task."))
			return
	else if(W.isscrewdriver())
		if(buildstate == 5)
			to_chat(user, SPAN_NOTICE("You secure the crossbow's various parts."))
			new /obj/item/gun/launcher/crossbow(get_turf(src))
			qdel(src)
		return
	else
		..()

/*////////////////////
//	RFD Crossbow	//
*/////////////////////
/obj/item/arrow/RFD
	name = "flashforged bolt"
	desc = "The ultimate ghetto deconstruction implement."
	throwforce = 10

/obj/item/gun/launcher/crossbow/RFD
	name = "Rapid-Fabrication-Device Crossbow"
	desc = "A hacked together RFD turns an innocent tool into the penultimate destruction tool. Flashforges bolts using matter units when the string is drawn back."
	icon = 'icons/obj/guns/rxb.dmi'
	icon_state = "rxb"
	item_state = "rxb"
	slot_flags = null
	draw_time = 10
	has_safety = FALSE
	var/stored_matter = 0
	var/max_stored_matter = 40
	var/boltcost = 10

/obj/item/gun/launcher/crossbow/RFD/proc/genBolt(var/mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt = new/obj/item/arrow/RFD(src)
		stored_matter -= boltcost
		to_chat(user, SPAN_NOTICE("The RFD flashforges a new bolt!"))
		playsound(loc, 'sound/weapons/kinetic_reload.ogg', 50, FALSE)
		update_icon()
	else
		to_chat(user, SPAN_WARNING("The \'Low Ammo\' light on the device blinks yellow."))
		playsound(loc, 'sound/items/rfd_empty.ogg', 50, FALSE)
		flick("[icon_state]-empty", src)

/obj/item/gun/launcher/crossbow/RFD/unique_action(mob/living/user as mob)
	if(tension)
		user.visible_message("<b>[user]</b> relaxes the tension on \the [src]'s string.", SPAN_NOTICE("You relax the tension on \the [src]'s string."))
		playsound(loc, 'sound/weapons/holster/tactiholsterout.ogg', 50, FALSE)
		tension = 0
		update_icon()
	else
		genBolt(user)
		draw(user)

/obj/item/gun/launcher/crossbow/RFD/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/rfd_ammo))
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, SPAN_NOTICE("The RFD can't hold that many additional matter-units."))
			return
		stored_matter += 10
		qdel(W)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("The RFD now holds <b>[stored_matter]/[max_stored_matter]</b> matter-units."))
		update_icon()
		return
	if(istype(W, /obj/item/arrow/RFD))
		var/obj/item/arrow/RFD/A = W
		if((stored_matter + 5) > max_stored_matter)
			to_chat(user, SPAN_NOTICE("Unable to reclaim flashforged bolt. The RFD can't hold that many additional matter-units."))
			return
		stored_matter += 5
		qdel(A)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("Flashforged bolt reclaimed. The RXD now holds <b>[stored_matter]/[max_stored_matter]</b> matter-units."))
		update_icon()
		return

/obj/item/gun/launcher/crossbow/RFD/update_icon()
	overlays.Cut()
	if(bolt)
		overlays += "rxb-bolt"
	var/ratio = 0
	if(stored_matter < boltcost)
		ratio = 0
	else
		ratio = stored_matter / max_stored_matter
		ratio = max(round(ratio, 0.25) * 100, 25)
	overlays += "rxb-[ratio]"
	if(tension > 1)
		icon_state = "rxb-drawn"
	else
		icon_state = "rxb"

/obj/item/gun/launcher/crossbow/RFD/examine(var/user)
	. = ..()
	if(.)
		to_chat(user, "It currently holds <b>[stored_matter]/[max_stored_matter]</b> matter-units.")
