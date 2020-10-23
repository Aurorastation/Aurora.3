/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 320, MATERIAL_GLASS = 800)
	var/obj/item/implant/imp = null

/obj/item/implanter/attack_self(var/mob/user)
	if(!imp)
		return ..()
	imp.forceMove(get_turf(src))
	user.put_in_hands(imp)
	to_chat(user, "<span class='notice'>You remove \the [imp] from \the [src].</span>")
	name = "implanter"
	imp = null
	update()
	return

/obj/item/implanter/proc/update()
	if (imp)
		icon_state = "implanter1"
	else
		icon_state = "implanter0"
	return

/obj/item/implanter/attack(mob/living/carbon/human/M, mob/user, var/target_zone)
	if(!istype(M))
		return

	var/obj/item/organ/external/affected = M.get_organ(target_zone)

	if(user && imp && affected)
		M.visible_message("<span class='warning'>[user] is attempting to implant [M] in \the [affected.name].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 50)))
			if(user && M && (get_turf(M) == T1) && src && imp)
				M.visible_message("<span class='warning'>[M] has been implanted by [user] in the [affected.name].</span>")

				admin_attack_log(user, M, "Implanted using \the [name] ([imp.name])", "Implanted with \the [name] ([imp.name])", "used an implanter, [name] ([imp.name]), on")

				if(imp.implanted(M, user))
					imp.forceMove(M)
					imp.imp_in = M
					imp.implanted = TRUE
					affected.implants += imp
					imp.part = affected
					BITSET(M.hud_updateflag, IMPLOYAL_HUD)
					if(istype(imp, /obj/item/implanter/loyalty))
						to_chat(M, "<span class ='notice'You feel a sudden surge of loyalty to [current_map.company_name]!</span>")

				imp = null
				update()

	return

/obj/item/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/implanter/loyalty/New()
	imp = new /obj/item/implant/mindshield(src)
	..()
	update()
	return

/obj/item/implanter/explosive
	name = "implanter (E)"

/obj/item/implanter/explosive/New()
	imp = new /obj/item/implant/explosive(src)
	..()
	update()
	return

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/implanter/adrenalin/New()
	imp = new /obj/item/implant/adrenalin(src)
	..()
	update()
	return

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

/obj/item/implanter/compressed/New()
	imp = new /obj/item/implant/compressed( src )
	..()
	update()
	return

/obj/item/implanter/compressed/update()
	if (imp)
		var/obj/item/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please scan an object with the implanter first.")
		return
	..()

/obj/item/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && imp)
		var/obj/item/implant/compressed/c = imp
		if(istype(A,/obj/item/implant/compressed))
			to_chat(user, SPAN_NOTICE("The implant is loaded into the implanter."))
			return
		if (c.scanned)
			to_chat(user, SPAN_WARNING("Something is already scanned inside the implant!"))
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
		else if(istype(A.loc,/obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()

/obj/item/implanter/freedom/Initialize()
	imp = new /obj/item/implant/freedom( src )
	..()
	update()

/obj/item/implanter/uplink
	name = "implanter (U)"

/obj/item/implanter/uplink/Initialize()
	imp = new /obj/item/implant/uplink( src )
	..()
	update()

/obj/item/implanter/anti_augment
	name = "implanter-augmentation disrupter"

/obj/item/implanter/anti_augment/New()
	imp = new /obj/item/implant/anti_augment(src)
	..()
	update()
	return

/obj/item/implanter/ipc_tag
	name = "IPC tag implanter"
	desc = "A special implanter used for implanting synthetics with a special tag."
	var/obj/item/organ/internal/ipc_tag/ipc_tag

/obj/item/implanter/ipc_tag/Initialize()
	. = ..()
	ipc_tag = new /obj/item/organ/internal/ipc_tag(src)
	update()

/obj/item/implanter/ipc_tag/update()
	if(ipc_tag)
		icon_state = "cimplanter1"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/ipc_tag/attack(mob/M, mob/user)
	if(!ishuman(M))
		return

	if(!ipc_tag)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have an IPC tag loaded!"))
		return

	var/mob/living/carbon/human/H = M
	if(!H.species || !isipc(H) || !H.organs_by_name[BP_HEAD])
		to_chat(user, SPAN_WARNING("You cannot use \the [src] on a non-IPC!"))
		return

	if(H.internal_organs_by_name[BP_IPCTAG])
		to_chat(user, SPAN_WARNING("\The [H] is already tagged!"))
		return

	user.visible_message(SPAN_WARNING("\The [user] tags \the [M] with \the [src]!"), SPAN_NOTICE("You tag \the [M] with \the [src]."), range = 3)

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'> Implanted with [name] ([ipc_tag.name])  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [name] ([ipc_tag.name]) to implant [M.name] ([M.ckey])</span>")
	msg_admin_attack("[key_name_admin(user)] implanted [key_name_admin(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

	ipc_tag.replaced(H, H.organs_by_name[BP_HEAD])
	ipc_tag.forceMove(M)
	if(ipc_tag.auto_generate)
		ipc_tag.serial_number = uppertext(dd_limittext(md5(M.real_name), 12))
	ipc_tag = null

	update()

/obj/item/implanter/ipc_tag/attackby(obj/item/I, mob/user)
	if(I.isscrewdriver())
		if(!ipc_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an IPC tag loaded."))
			return
		to_chat(user, SPAN_NOTICE("You remove \the [ipc_tag] from \the [src]."))
		ipc_tag.forceMove(get_turf(user))
		user.put_in_hands(ipc_tag)
		ipc_tag = null
		update()
		return
	if(istype(I, /obj/item/organ/internal/ipc_tag))
		if(ipc_tag)
			to_chat(user, SPAN_WARNING("\The [src] already has an IPC tag loaded."))
			return
		ipc_tag = I
		user.drop_from_inventory(I, src)
		update()
		return
	..()
