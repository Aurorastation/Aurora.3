/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/item/implants.dmi'
	contained_sprite = TRUE
	icon_state = "implanter-0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 320, MATERIAL_GLASS = 800)
	var/obj/item/implant/imp = null

/obj/item/implanter/New()
	if(ispath(imp))
		imp = new imp(src)
	..()
	update_icon()

/obj/item/implanter/update_icon()
	cut_overlays()
	icon_state = "implanter-[imp ? "1" : "0"]"
	if (imp)
		var/mutable_appearance/overlay_implant_icon = mutable_appearance(icon, "implanter-overlay")
		overlay_implant_icon.color = imp.implant_color
		add_overlay(overlay_implant_icon)

/obj/item/implanter/attackby(obj/item/I, mob/user)
	if(!imp && istype(I, /obj/item/implant) && user.unEquip(I,src))
		to_chat(usr, SPAN_NOTICE("You slide \the [I] into \the [src]."))
		imp = I
		update_icon()
	else
		..()

/obj/item/implanter/attack(mob/living/carbon/human/M, mob/user, var/target_zone)
	if(!istype(M))
		return

	var/obj/item/organ/external/affected = M.get_organ(target_zone)

	if(user && imp && affected)
		M.visible_message(SPAN_WARNING("[user] is attempting to implant [M] in \the [affected.name]."))

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 5 SECONDS)))
			if(user && M && (get_turf(M) == T1) && src && imp)
				M.visible_message(SPAN_WARNING("[M] has been implanted by [user] in the [affected.name]."))

				admin_attack_log(user, M, "Implanted using \the [name] ([imp.name])", "Implanted with \the [name] ([imp.name])", "used an implanter, [name] ([imp.name]), on")

				if(imp.implanted(M, user))
					imp.forceMove(M)
					imp.imp_in = M
					imp.implanted = TRUE
					affected.implants += imp
					imp.part = affected
					BITSET(M.hud_updateflag, IMPLOYAL_HUD)

				imp = null
				update_icon()

	return

/obj/item/implanter/ipc_tag
	name = "IPC tag implanter"
	desc = "A special implanter used for implanting synthetics with a special tag."
	var/obj/item/organ/internal/ipc_tag/ipc_tag

/obj/item/implanter/ipc_tag/Initialize()
	. = ..()
	ipc_tag = new /obj/item/organ/internal/ipc_tag(src)
	update_icon()

/obj/item/implanter/ipc_tag/update_icon()
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

	update_icon()

/obj/item/implanter/ipc_tag/attackby(obj/item/I, mob/user)
	if(I.isscrewdriver())
		if(!ipc_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an IPC tag loaded."))
			return
		to_chat(user, SPAN_NOTICE("You remove \the [ipc_tag] from \the [src]."))
		ipc_tag.forceMove(get_turf(user))
		user.put_in_hands(ipc_tag)
		ipc_tag = null
		update_icon()
		return
	if(istype(I, /obj/item/organ/internal/ipc_tag))
		if(ipc_tag)
			to_chat(user, SPAN_WARNING("\The [src] already has an IPC tag loaded."))
			return
		ipc_tag = I
		user.drop_from_inventory(I, src)
		update_icon()
		return
	..()
