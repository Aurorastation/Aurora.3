/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/item/implants.dmi'
	contained_sprite = TRUE
	icon_state = "implanter-0"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 320, MATERIAL_GLASS = 800)
	var/obj/item/implant/imp = null

/obj/item/implanter/New()
	if(ispath(imp))
		imp = new imp(src)
	..()
	update_icon()

/obj/item/implanter/update_icon()
	ClearOverlays()
	icon_state = "implanter-[imp ? "1" : "0"]"
	if (imp)
		var/mutable_appearance/overlay_implant_icon = mutable_appearance(icon, "implanter-overlay")
		overlay_implant_icon.color = imp.implant_color
		AddOverlays(overlay_implant_icon)

/obj/item/implanter/attackby(obj/item/attacking_item, mob/user)
	if(!imp && istype(attacking_item, /obj/item/implant) && user.unEquip(attacking_item, src))
		to_chat(usr, SPAN_NOTICE("You slide \the [attacking_item] into \the [src]."))
		imp = attacking_item
		attacking_item.forceMove(src)
		update_icon()
	else
		..()

/obj/item/implanter/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/human/M = target_mob
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
	icon_state = "implanter-[ipc_tag ? "1" : "0"]"
	return

/obj/item/implanter/ipc_tag/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!ishuman(target_mob))
		return

	if(!ipc_tag)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have an IPC tag loaded!"))
		return

	var/mob/living/carbon/human/H = target_mob
	if(!H.species || !isipc(H) || !H.organs_by_name[BP_HEAD])
		to_chat(user, SPAN_WARNING("You cannot use \the [src] on a non-IPC!"))
		return

	if(H.internal_organs_by_name[BP_IPCTAG])
		to_chat(user, SPAN_WARNING("\The [H] is already tagged!"))
		return

	user.visible_message(SPAN_WARNING("\The [user] tags \the [target_mob] with \the [src]!"), SPAN_NOTICE("You tag \the [target_mob] with \the [src]."), range = 3)

	target_mob.attack_log += "\[[time_stamp()]\] <font color='orange'> Implanted with [name] ([ipc_tag.name])  by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <span class='warning'>Used the [name] ([ipc_tag.name]) to implant [target_mob.name] ([target_mob.ckey])</span>"
	msg_admin_attack("[key_name_admin(user)] implanted [key_name_admin(target_mob)] with [name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target_mob))

	ipc_tag.replaced(H, H.organs_by_name[BP_HEAD])
	ipc_tag.forceMove(target_mob)
	if(ipc_tag.auto_generate)
		ipc_tag.serial_number = uppertext(dd_limittext(md5(target_mob.real_name), 12))
	ipc_tag = null

	update_icon()

/obj/item/implanter/ipc_tag/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(!ipc_tag)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an IPC tag loaded."))
			return
		to_chat(user, SPAN_NOTICE("You remove \the [ipc_tag] from \the [src]."))
		ipc_tag.forceMove(get_turf(user))
		user.put_in_hands(ipc_tag)
		ipc_tag = null
		update_icon()
		return
	if(istype(attacking_item, /obj/item/organ/internal/ipc_tag))
		if(ipc_tag)
			to_chat(user, SPAN_WARNING("\The [src] already has an IPC tag loaded."))
			return
		ipc_tag = attacking_item
		user.drop_from_inventory(attacking_item, src)
		update_icon()
		return
	..()
