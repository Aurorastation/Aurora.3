/obj/item/paper_scanner
	name = "paper scanner"
	desc = "A simple device that can be used to scan paper or paper bundles in order to digitize them."
	desc_info = "Alt-click it while it's in one of your hands to eject the portable drive. Click paper or a paper bundle with it to digitize it and store it in the inserted drive."
	icon = 'icons/obj/item/paperscanner.dmi'
	icon_state = "paperscanner"
	item_state = "paperscanner"
	contained_sprite = TRUE
	var/obj/item/computer_hardware/hard_drive/portable/drive

/obj/item/paper_scanner/Initialize(mapload, ...)
	. = ..()
	drive = new /obj/item/computer_hardware/hard_drive/portable(src)
	update_icon()

/obj/item/paper_scanner/update_icon()
	cut_overlays()
	if(drive)
		add_overlay("paperscanner-drive")

/obj/item/paper_scanner/AltClick(mob/living/user)
	if(!drive)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a drive installed."))
		return
	if(!istype(user))
		to_chat(user, SPAN_WARNING("You're too simple to work \the [src]."))
		return
	if(user.l_hand == src || user.r_hand == src || issilicon(user))
		to_chat(user, SPAN_NOTICE("You eject \the [drive]."))
		user.put_in_hands(drive)
		drive = null
		update_icon()
	else
		to_chat(user, SPAN_WARNING("You must be holding \the [src] in one of your hands before you can eject a drive."))

/obj/item/paper_scanner/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/computer_hardware/hard_drive/portable))
		if(drive)
			to_chat(user, SPAN_WARNING("\The [src] already has a drive installed!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
		user.drop_from_inventory(W, src)
		drive = W
		update_icon()
		return TRUE
	else
		return ..()

/obj/item/paper_scanner/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && (istype(target, /obj/item/paper) || istype(target, /obj/item/paper_bundle)))
		do_scan(target, user)

/obj/item/paper_scanner/proc/do_scan(var/obj/item/target, var/mob/user)
	if(!drive)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a drive installed."))
		return

	var/list/pages_to_scan = list()
	var/obj/item/paper/P = target
	var/obj/item/paper_bundle/PB = target

	if(istype(P))
		if(!P.info)
			to_chat(user, SPAN_WARNING("\The [P] doesn't have any information on it."))
			return
		pages_to_scan += P
	else if(istype(PB))
		var/has_info = FALSE
		for(var/obj/item/paper/page in PB.pages)
			if(page.info)
				pages_to_scan += page
				has_info = TRUE
		if(!has_info)
			to_chat(user, SPAN_WARNING("\The [PB] doesn't have any information in it."))
			return

	if(!length(pages_to_scan))
		return

	user.visible_message("<b>[user]</b> starts making a scan of \the [target]...", SPAN_NOTICE("You start making a scan of \the [target]..."), range = 3)
	if(do_after(user, 30 * length(pages_to_scan), TRUE, target))
		if(!drive)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a drive installed."))
			return
		user.visible_message("<b>[user]</b> makes a scan of \the [target].", SPAN_NOTICE("You make a scan of \the [target]."), range = 3)
		var/datum/computer_file/data/F = new /datum/computer_file/data(drive)
		F.filename = target.name != initial(target.name) ? "[target.name] ([worldtime2text()] - [time2text(world.time, "Month DD")])" : "Digital Paper ([worldtime2text()] - [time2text(world.time, "Month DD")])"
		F.filetype = "TXT"
		var/data_to_save = ""
		for(var/thing in pages_to_scan)
			var/obj/item/paper/page = thing
			var/p_info = html2pencode(page.info)
			data_to_save += strip_html_properly(p_info)
			data_to_save += "\[br\]"
		F.stored_data = data_to_save
		if(!drive.store_file(F))
			to_chat(user, SPAN_WARNING("\The [drive] does not have enough space to store the latest scanned file."))
