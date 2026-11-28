/obj/item/folder
	name = "folder"
	desc = "Holds loose sheets of paper and is a bureaucrat's best friend."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	var/can_write = FALSE
	/// Customized name without a pen-applied label. Set when the folder is first labelled.
	var/tmp/unlabelled_name
	/// Stable ID of the filing cabinet whose long-term storage contains this folder.
	var/tmp/persistent_filing_cabinet_id

/obj/item/folder/get_persistence_hint()
	return persistence_hint("Folders containing supported nonblank paperwork can be saved between rounds in a filing cabinet's Long-Term storage aboard the SCCV Horizon. Only supported paperwork is preserved. Removing the folder from Long-Term storage cancels persistence.")

/obj/item/folder/Initialize(mapload)
	var/obj/item/paper/paper_type = /obj/item/paper
	persistent_objects_expiration_time_days = initial(paper_type.persistent_objects_expiration_time_days)
	return ..()

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/sec
	desc = "A gold and blue folder, specifically designed for the Internal Security Department."
	icon_state = "folder_blue_gold"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/folder/purple
	desc = "A purple folder, specifically designed for the Research Division facilities of the company."
	icon_state = "folder_purple"

/obj/item/folder/colorable
	desc = "A folder with a customizable fold and marking."
	icon_state = "folder_colorable_fold"
	color = COLOR_GRAY
	accent_color = COLOR_GRAY
	update_icon_on_init = TRUE

/obj/item/folder/colorable/update_icon()
	ClearOverlays()
	AddOverlays(overlay_image(icon, "folder_colorable_mark", accent_color, RESET_COLOR))
	AddOverlays(overlay_image(icon, "folder_colorable_tag", flags = RESET_COLOR))
	if(contents.len)
		AddOverlays(overlay_image(icon, "folder_paper", flags = RESET_COLOR))
	return

/obj/item/folder/update_icon()
	ClearOverlays()
	if(contents.len)
		AddOverlays("folder_paper")
	return

/obj/item/folder/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper) || istype(attacking_item, /obj/item/photo) || istype(attacking_item, /obj/item/paper_bundle) || istype(attacking_item, /obj/item/sample))
		if(istype(attacking_item, /obj/item/paper))
			var/obj/item/paper/paper = attacking_item
			paper.persistent_filing_cabinet_id = null
			SSpersistence.objectsDeregisterTrack(paper)
		else if(istype(attacking_item, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/bundle = attacking_item
			bundle.persistent_filing_cabinet_id = null
			SSpersistence.objectsDeregisterTrack(bundle)
		user.drop_from_inventory(attacking_item, src)
		to_chat(user, SPAN_NOTICE("You put the [attacking_item] into \the [src]."))
		update_icon()
	else if(attacking_item.tool_behaviour == TOOL_PEN)
		var/n_name = sanitizeSafe( tgui_input_text(user, "What would you like to label the folder?", "Folder Labelling", max_length = MAX_NAME_LEN), MAX_NAME_LEN )
		if(Adjacent(user) && user.stat == 0)
			if(isnull(unlabelled_name))
				unlabelled_name = name
			name = "[unlabelled_name][(n_name ? "- '[n_name]'" : null)]"
	return

/obj/item/folder/attack_self(mob/user as mob)
	var/dat = ""

	for(var/obj/item/paper/P in src)
		dat += "[can_write ? "<A href='byond://?src=[REF(src)];write=[REF(P)]'>Write</A> " : ""]<A href='byond://?src=[REF(src)];remove=[REF(P)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(P)]'>Rename</A> - <A href='byond://?src=[REF(src)];read=[REF(P)]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='byond://?src=[REF(src)];remove=[REF(Ph)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(Ph)]'>Rename</A> - <A href='byond://?src=[REF(src)];look=[REF(Ph)]'>[Ph.name]</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='byond://?src=[REF(src)];remove=[REF(Pb)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(Pb)]'>Rename</A> - <A href='byond://?src=[REF(src)];browse=[REF(Pb)]'>[Pb.name]</A><BR>"
	for(var/obj/item/sample/Pf in src)
		dat += "<A href='byond://?src=[REF(src)];remove=[REF(Pf)]'>Remove</A> - [Pf.name]<BR>"
	user << browse(HTML_SKELETON_TITLE(name, dat), "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if((usr.stat || usr.restrained()))
		return

	if(loc_check(usr))

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				handle_remove(P, astype(usr, /mob))
		else if(href_list["write"])
			var/obj/item/paper/paper = locate(href_list["write"])
			if(!istype(paper) || paper.loc != src)
				return
			var/obj/item/pen = usr.get_inactive_hand()
			if(!pen || pen.tool_behaviour != TOOL_PEN)
				pen = usr.get_active_hand()
			if(pen?.tool_behaviour == TOOL_PEN)
				paper.attackby(pen, usr)
		else if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P))
				P.show_content(usr)
		else if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list["browse"])
			var/obj/item/paper_bundle/P = locate(href_list["browse"])
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "[P.name]")
		else if(href_list["rename"])
			var/obj/item/O = locate(href_list["rename"])

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/paper_bundle))
					var/obj/item/paper_bundle/to_rename = O
					to_rename.rename()

		//Update everything
		attack_self(usr)
		update_icon()
	return

/obj/item/folder/proc/loc_check(var/atom/A)
	if(loc == A)
		return TRUE
	return FALSE

/obj/item/folder/proc/handle_remove(obj/item/P, mob/user)
	user?.put_in_hands(P)
	handle_post_remove()

/obj/item/folder/proc/handle_post_remove()
	return

/// Whether this folder contains anything which cannot safely be serialized as paperwork.
/obj/item/folder/proc/has_unsupported_persistent_content()
	if(istype(src, /obj/item/folder/embedded))
		return TRUE
	for(var/obj/item/item in src)
		if(istype(item, /obj/item/paper))
			continue
		if(istype(item, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/bundle = item
			if(!bundle.has_unsupported_persistent_content())
				continue
		return TRUE
	return FALSE

/// Whether this folder contains at least one nonblank document and can enter long-term storage.
/obj/item/folder/can_persist_in_filing_cabinet()
	if(has_unsupported_persistent_content())
		return FALSE
	for(var/obj/item/item in src)
		if(istype(item, /obj/item/paper))
			var/obj/item/paper/paper = item
			if(!paper.is_blank())
				return TRUE
		else if(istype(item, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/bundle = item
			if(bundle.can_persist_in_filing_cabinet())
				return TRUE
	return FALSE

/// Serializes the folder and its supported nonblank document contents.
/obj/item/folder/proc/get_persistent_document_content()
	var/list/content = list(
		"name" = name,
		"description" = desc,
		"color" = color,
		"accent_color" = accent_color,
		"unlabelled_name" = unlabelled_name,
		"filing_cabinet_id" = persistent_filing_cabinet_id
	)

	var/list/documents = list()
	for(var/obj/item/item in src)
		if(istype(item, /obj/item/paper))
			var/obj/item/paper/paper = item
			var/list/paper_data = paper.get_persistent_document_data()
			if(paper_data)
				documents += list(list("kind" = "paper", "data" = paper_data))
		else if(istype(item, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/bundle = item
			if(bundle.can_persist_in_filing_cabinet())
				var/list/bundle_content = bundle.get_persistent_document_content()
				bundle_content["filing_cabinet_id"] = null
				documents += list(list(
					"kind" = "bundle",
					"type" = "[bundle.type]",
					"content" = bundle_content
				))
	content["documents"] = documents
	return content

/obj/item/folder/proc/apply_persistent_document_content(list/content)
	if(!islist(content))
		return
	for(var/obj/item/item in src)
		qdel(item)

	if(istext(content["name"]))
		name = content["name"]
	if("description" in content)
		desc = content["description"]
	if("color" in content)
		color = content["color"]
	if("accent_color" in content)
		accent_color = content["accent_color"]
	if("unlabelled_name" in content)
		unlabelled_name = content["unlabelled_name"]
	persistent_filing_cabinet_id = content["filing_cabinet_id"]
	for(var/list/document as anything in content["documents"])
		switch(document["kind"])
			if("paper")
				restore_persistent_document_paper(document["data"], src)
			if("bundle")
				var/bundle_type = text2path(document["type"])
				if(!ispath(bundle_type, /obj/item/paper_bundle))
					continue
				var/obj/item/paper_bundle/bundle = new bundle_type(src)
				bundle.apply_persistent_document_content(document["content"])
				bundle.persistent_filing_cabinet_id = null
	update_icon()

/obj/item/folder/persistent_objects_get_content()
	return get_persistent_document_content()

/obj/item/folder/persistent_objects_apply_content(content, x, y, z)
	apply_persistent_document_content(content)
	src.x = x
	src.y = y
	src.z = z

/obj/item/folder/blue/nka/Initialize()
	. = ..()
	for (var/I = 1 to 5)
		new /obj/item/paper/nka_pledge(src)

/obj/item/folder/filled/Initialize()
	. = ..()
	for (var/I = 1 to 10)
		new /obj/item/paper(src)

/obj/item/folder/embedded
	name = "index"
	can_write = TRUE

/obj/item/folder/embedded/loc_check(var/atom/A)
	if(loc.loc.Adjacent(A))
		return TRUE
	return FALSE

/obj/item/folder/embedded/handle_remove(obj/item/paper/P, mob/user)
	. = ..()
	if(istype(P, /obj/item/paper/notepad))
		P.ripped = TRUE
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 25, 1)
		P.update_icon()

/obj/item/folder/embedded/handle_post_remove()
	if(!length(contents))
		qdel(src)

/obj/item/folder/embedded/Destroy()
	for(var/x in src)
		qdel(x)
	. = ..()

/obj/item/folder/envelope
	name = "envelope"
	desc = "A thick envelope. You can't see what's inside."
	icon_state = "envelope_sealed"
	var/sealed = TRUE

/obj/item/folder/envelope/update_icon()
	if(sealed)
		icon_state = "envelope_sealed"
	else
		icon_state = "envelope[contents.len > 0]"

/obj/item/folder/envelope/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "The seal is [sealed ? "intact" : "broken"]."

/obj/item/folder/envelope/proc/sealcheck(user)
	var/ripperoni = tgui_alert(usr, "Are you sure you want to break the seal on \the [src]?", "Confirmation", list("Yes", "No"))
	if(ripperoni == "Yes")
		visible_message(SPAN_NOTICE("[user] breaks the seal on \the [src], and opens it."), visible_message_flags = LOCAL_MESSAGE)
		sealed = FALSE
		update_icon()
		return TRUE

/obj/item/folder/envelope/attack_self(mob/user)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/folder/envelope/attackby(obj/item/attacking_item, mob/user)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/folder/envelope/empty
	sealed = FALSE

/obj/item/folder/envelope/empty/zat
	name = "instructions envelope"
	desc = "\
		A small envelope with some warning words written in bold text on the front. \
		It is all dusty and crumpled, like someone forgot about it a while ago.\
	"

/obj/item/folder/envelope/zat
	name = "leviathan zero-point artillery instructions"
	desc = "A small envelope with 'SCC CONFIDENTIAL' written in bold text on the front."

/obj/item/folder/envelope/zat/Initialize()
	. = ..()
	var/obj/item/paper/R = new(src)
	R.set_content("leviathan zero-point artillery instructions", "<table><cell><hr><small><center><img src=scclogo.png><br><b>Stellar Corporate Conglomerate<br> \
	SCCV Horizon</b><hr><b>Form 0000<br> \
	<large>Confidential Information Report</large></b></center><hr> \
	<b>Classification Index:</b> <font color='red'>TOP SECRET</font>, protect at all costs <field><hr><b>Entrusted Personnel:</b> Command, Engineering<br> <field>\
	<b>Subject Designation:</b> Leviathan Prototype Zero-Point Artillery <br><field> \
	<b>Subject Specification:</b> The Leviathan-class Prototype Warp Emitter Artillery is the crowning achievement of the Chainlink's \
	unified science and engineering arm. Nearly two-thousand tonnes and longer than fifty meters, the Leviathian is composed of two (2) arc batteries, \
	six (6) hyper conductors, six (6) warp engine generators, four (4) warp field stabilizers, a thirty meter (30m) dampening rail-line, and a full targeting \
	acquisition and power management array.<br><field> \
	<b>Instructions:</b> In order to fire the Leviathan, the capacitors must first be coupled by lowering the activation lever. This coupling is, however, extremely energy intensive. \
	Long term activation thus requires a hefty supply of electricity in the APC. Firing the Leviathan itself takes energy directly from the superconducting SMES specially built \
	for the gun. Its firing cost is around 20 megawatts per shot, not counting power taken from the APC in idle mode.<br> \
	To activate the Leviathan itself, two command staff must first couple the warp fields to the firing array by unlocking the safeties on the keycard authentication device. \
	Once that is done, the key must be retrieved from its case in the Captain's office. It must then be placed in the activation terminal in the bridge. \
	The key must then be twisted and, finally, the button to fire the Leviathan will be uncovered and it may be pressed.<field><br> \
	<b>Subject Description:</b> The Leviathan's one and only intended purpose is to annihilate any single target \
	that proves to be an existential threat to the SCCV Horizon and all of its valuable designs and crew. The weapon achieves this by pushing and weaponizing \
	already understood warp drive technology to a scale only currently matched by phoron fusion bombs.<br> \
	In layman's terms, an extreme amount of energy is at first used by several high-level warp generators, which instead of bending space around the ship, \
	creates a \"warp funnel\" around the outer half of the weapon. Every bit of energy remaining is then fired out through the funnel, \
	accelerating it into a powerful beam travelling at several times the speed of light. <br>No currently known hull nor shield configuration is able to withstand the attack: \
	the beam is expected to inflict too much structural damage for any one vessel to continue fighting.<br> \
	The power draw of a single shot is greater than a single jump operation into bluespace, meaning each use will leave the Horizon vulnerable to any other threats that remain.<br>\
	To date, the prototype has not been tested against stars, planets, or other supermassive targets. While its use should be limited to catastrophic scenarios, \
	the Horizon is expected to gather as much field data as possible throughout its journey.<br>")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-leland_stamp"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.overlays += stampoverlay
	R.stamps += "<hr><i>This paper has been stamped as \"TOP SECRET\".</i>"
