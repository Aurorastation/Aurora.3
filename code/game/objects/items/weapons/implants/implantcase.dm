/**
 * Item used to store implants. Can be renamed with a pen. Implants are moved between these and implanters when a mob uses an implanter on the case.
 */
/obj/item/implantcase
	name = "implant case"
	desc = "An aluminium case, which can safely contain an implant."
	icon = 'icons/obj/item/implants.dmi'
	icon_state = "implantcase"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_TINY
	///The implant within the case
	var/obj/item/implant/imp = null

/obj/item/implantcase/Initialize(mapload)
	. = ..()
	if(ispath(imp))
		imp = new imp(src)
		update_description()
	update_icon()

/obj/item/implantcase/proc/update_description()
	if(imp)
		desc = "An aluminium case, containing \a [imp]."
		origin_tech = imp.origin_tech
	else
		desc = "An aluminium case, which can safely contain an implant."
		origin_tech.Cut()


/obj/item/implantcase/update_icon()
	cut_overlays()
	if (imp)
		var/overlay_icon_state = "implantstorage_[imp.implant_icon]"
		var/mutable_appearance/overlay_implant_icon = mutable_appearance(icon, overlay_icon_state)
		add_overlay(overlay_implant_icon)

/obj/item/implantcase/attackby(obj/item/I, mob/user)
	if (I.ispen())
		var/t = tgui_input_text(user, "What would you like the label to be?", name, name, MAX_NAME_LEN)
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && loc != user))
			return
		if(t)
			src.name = "implant case - [t]"
			desc = "An aluminium case, containing \a [t] implant."
		else
			src.name = "implant case"
			desc = "An aluminium case, which can safely contain an implant."
	else if(istype(I, /obj/item/reagent_containers/syringe))
		imp.attackby(I, user)
	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if (M.imp && !imp && !M.imp.implanted)
			M.imp.forceMove(src)
			imp = M.imp
			M.imp = null
		else if (imp && !M.imp)
			imp.forceMove(M)
			M.imp = src.imp
			imp = null
		update_description()
		update_icon()
		M.update_icon()
	else if (istype(I, /obj/item/implant))
		if(imp == null)
			to_chat(user, SPAN_NOTICE("You slide \the [I] into \the [src]."))
			user.drop_from_inventory(I,src)
			imp = I
		else
			to_chat(user, SPAN_WARNING("\The [src] already has an implant inside of it!"))
		update_description()
		update_icon()
	else if(istype(I, /obj/item/implantpad))
		var/obj/item/implantpad/pad = I
		if(!pad.case)
			user.drop_from_inventory(src,pad)
			pad.case = src
			pad.update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [pad] already has an implant case attached to it!"))
	..()

