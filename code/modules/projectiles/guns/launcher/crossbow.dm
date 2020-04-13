//AMMUNITION

/obj/item/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	throwforce = 8
	w_class = 3.0
	sharp = 1
	edge = 0
	hitsound = "swing_hit"
	drop_sound = 'sound/items/drop/sword.ogg'

/obj/item/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 2
	icon = 'icons/obj/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"
	drop_sound = 'sound/items/drop/sword.ogg'

/obj/item/arrow/quill
	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "quill"
	item_state = "quill"
	throwforce = 8
	drop_sound = 'sound/items/drop/knife.ogg'

/obj/item/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, "[src] shatters into a scattering of unusable overstressed metal shards as it leaves the crossbow.")
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

	var/obj/item/bolt
	var/tension = 0                         // Current draw on the bow.
	var/max_tension = 5                     // Highest possible tension.
	var/release_speed = 5                   // Speed per unit of tension.
	var/obj/item/cell/cell = null    // Used for firing superheated rods.
	var/current_user                        // Used to check if the crossbow has changed hands since being drawn.
	var/draw_time = 20						// How long it takes to increase the draw on the bow by one "tension"

/obj/item/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/launcher/crossbow/consume_next_projectile(mob/user=null)
	if(tension <= 0)
		to_chat(user, "<span class='warning'>\The [src] is not drawn back!</span>")
		return null
	return bolt

/obj/item/gun/launcher/crossbow/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = 0
	update_icon()
	..()

/obj/item/gun/launcher/crossbow/attack_self(mob/living/user as mob)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
			bolt.forceMove(get_turf(src))
			var/obj/item/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/proc/draw(var/mob/user as mob)

	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("[user] begins to draw back the string of [src].","<span class='notice'>You begin to draw back the string of [src].</span>")
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time)) //crossbow strings don't just magically pull back on their own.
			user.visible_message("[usr] stops drawing and relaxes the string of [src].","<span class='warning'>You stop drawing back and relax the string of [src].</span>")
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
			to_chat(usr, "[src] clunks as you draw the string to its maximum tension!")
			return

		user.visible_message("[usr] draws back the string of [src]!","<span class='notice'>You continue drawing back the string of [src]!</span>")

/obj/item/gun/launcher/crossbow/proc/increase_tension(var/mob/user as mob)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return


/obj/item/gun/launcher/crossbow/attackby(obj/item/W as obj, mob/user as mob)
	if(!bolt)
		if (istype(W,/obj/item/arrow))
			user.drop_from_inventory(W, src)
			bolt = W
			user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
			update_icon()
			return
		else if(istype(W,/obj/item/stack/rods))
			var/obj/item/stack/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				bolt.forceMove(src)
				update_icon()
				user.visible_message("[user] jams [bolt] into [src].","You jam [bolt] into [src].")
				superheat_rod(user)
			return

	if(istype(W, /obj/item/cell))
		if(!cell)
			user.drop_from_inventory(W, src)
			cell = W
			to_chat(user, "<span class='notice'>You jam [cell] into [src] and wire it to the firing coil.</span>")
			superheat_rod(user)
		else
			to_chat(user, "<span class='notice'>[src] already has a cell installed.</span>")

	else if(W.isscrewdriver())
		if(cell)
			var/obj/item/C = cell
			C.forceMove(get_turf(user))
			to_chat(user, "<span class='notice'>You jimmy [cell] out of [src] with [W].</span>")
			cell = null
		else
			to_chat(user, "<span class='notice'>[src] doesn't have a cell installed.</span>")

	else
		..()

/obj/item/gun/launcher/crossbow/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !bolt)
		return
	if(cell.charge < 500)
		return
	if(bolt.throwforce >= 15)
		return
	if(!istype(bolt,/obj/item/arrow/rod))
		return

	to_chat(user, "<span class='warning'>[bolt] plinks and crackles as it begins to glow red-hot.</span>")
	bolt.throwforce = 15
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
	hitsound = "swing_hit"

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
				to_chat(user, "<span class='notice'>You assemble a backbone of rods around the wooden stock.</span>")
				buildstate++
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least three rods to complete this task.</span>")
			return
	else if(W.iswelder())
		if(buildstate == 1)
			var/obj/item/weldingtool/T = W
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You weld the rods into place.</span>")
			buildstate++
			update_icon()
		return
	else if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 2)
			if(C.use(5))
				to_chat(user, "<span class='notice'>You wire a crude cell mount into the top of the crossbow.</span>")
				buildstate++
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least five segments of cable coil to complete this task.</span>")
			return
		else if(buildstate == 4)
			if(C.use(5))
				to_chat(user, "<span class='notice'>You string a steel cable across the crossbow's limbs.</span>")
				buildstate++
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least five segments of cable coil to complete this task.</span>")
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == MATERIAL_PLASTIC)
		if(buildstate == 3)
			var/obj/item/stack/material/P = W
			if(P.use(3))
				to_chat(user, "<span class='notice'>You assemble and install heavy plastic limbs onto the crossbow.</span>")
				buildstate++
				update_icon()
			else
				to_chat(user, "<span class='notice'>You need at least three plastic sheets to complete this task.</span>")
			return
	else if(W.isscrewdriver())
		if(buildstate == 5)
			to_chat(user, "<span class='notice'>You secure the crossbow's various parts.</span>")
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
	var/stored_matter = 0
	var/max_stored_matter = 40
	var/boltcost = 10

/obj/item/gun/launcher/crossbow/RFD/proc/genBolt(var/mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt = new/obj/item/arrow/RFD(src)
		stored_matter -= boltcost
		to_chat(user, "<span class='notice'>The RFD flashforges a new bolt!</span>")
		update_icon()
	else
		to_chat(user, "<span class='warning'>The \'Low Ammo\' light on the device blinks yellow.</span>")
		flick("[icon_state]-empty", src)

/obj/item/gun/launcher/crossbow/RFD/attack_self(mob/living/user as mob)
	if(tension)
		user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		genBolt(user)
		draw(user)

/obj/item/gun/launcher/crossbow/RFD/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/rfd_ammo))
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, "<span class='notice'>The RFD can't hold that many additional matter-units.</span>")
			return
		stored_matter += 10
		qdel(W)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>The RFD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()
		return
	if(istype(W, /obj/item/arrow/RFD))
		var/obj/item/arrow/RFD/A = W
		if((stored_matter + 5) > max_stored_matter)
			to_chat(user, "<span class='notice'>Unable to reclaim flashforged bolt. The RFD can't hold that many additional matter-units.</span>")
			return
		stored_matter += 5
		qdel(A)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>Flashforged bolt reclaimed. The RXD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
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
		if(get_dist(src, user) > 1)
			return
		to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] matter-units.")
