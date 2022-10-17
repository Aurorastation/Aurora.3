/obj/item/folder
	name = "folder"
	desc = "Holds loose sheets of paper and is a bureaucrat's best friend."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	var/can_write = FALSE

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

/obj/item/folder/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("folder_paper")
	return

/obj/item/folder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle) || istype(W, /obj/item/sample))
		user.drop_from_inventory(W,src)
		to_chat(user, "<span class='notice'>You put the [W] into \the [src].</span>")
		update_icon()
	else if(W.ispen())
		var/n_name = sanitizeSafe(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text, MAX_NAME_LEN)
		if(Adjacent(user) && user.stat == 0)
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"
	return

/obj/item/folder/attack_self(mob/user as mob)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/paper/P in src)
		dat += "[can_write ? "<A href='?src=\ref[src];write=\ref[P]'>Write</A> " : ""]<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Pb]'>Rename</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	for(var/obj/item/sample/Pf in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pf]'>Remove</A> - [Pf.name]<BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(loc_check(usr))

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				P.forceMove(usr.loc)
				usr.put_in_hands(P)
				handle_post_remove()
		else if(href_list["write"])
			var/obj/item/paper/paper = locate(href_list["write"])
			if(!istype(paper) || paper.loc != src)
				return
			var/obj/item/pen = usr.get_inactive_hand()
			if(!pen || !pen.ispen())
				pen = usr.get_active_hand()
			if(pen?.ispen())
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

/obj/item/folder/proc/handle_post_remove()
	return

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

/obj/item/folder/embedded/handle_post_remove()
	if(!length(contents))
		qdel(src)

/obj/item/folder/envelope
	name = "envelope"
	desc = "A thick envelope. You can't see what's inside."
	icon_state = "envelope_sealed"
	var/sealed = 1

/obj/item/folder/envelope/update_icon()
	if(sealed)
		icon_state = "envelope_sealed"
	else
		icon_state = "envelope[contents.len > 0]"

/obj/item/folder/envelope/examine(mob/user)
	. = ..()
	to_chat(user, "The seal is [sealed ? "intact" : "broken"].")

/obj/item/folder/envelope/proc/sealcheck(user)
	var/ripperoni = alert("Are you sure you want to break the seal on \the [src]?", "Confirmation","Yes", "No")
	if(ripperoni == "Yes")
		visible_message(SPAN_NOTICE("[user] breaks the seal on \the [src], and opens it."))
		sealed = FALSE
		update_icon()
		return TRUE

/obj/item/folder/envelope/attack_self(mob/user)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/folder/envelope/attackby(obj/item/W, mob/user)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/folder/envelope/zta
	name = "leviathan zero-point artillery instructions"
	desc = "A small envelope. This one reads 'SCC - CONFIDENTIAL'."

/obj/item/folder/envelope/zta/Initialize()
	. = ..()
	var/obj/item/paper/R = new(src)
	R.set_content("leviathan zero-point artillery instructions", "<table><cell><hr><small><center><img src=scclogo.png><br><b>Stellar Corporate Conglomerate<br>\
	SCCV Horizon</b><hr><b>Form 0000<br>\
	<large>Confidential Information Report</large></b></center><hr>\
	<b>Classification Index:</b> <font color='red'>TOP SECRET</font>, protect at all costs <field><hr><b>Entrusted Personnel:</b> Command, Engineering<br> <field>\
	<b>Subject Designation:</b> Leviathan Prototype Zero-Point Artillery <br><field>\
	<b>Subject Specification:</b> The Leviathan-class Prototype Warp Emitter Artillery is the crowning achievement of the Chainlink's \
	unified science and engineering arm. Nearly two-thousand tonnes and longer than fifty meters, the Leviathian is composed of two (2) arc batteries,\
	six (6) hyper conductors, six (6) warp engine generators, four (4) warp field stabilizers, a thirty meter (30m) dampening rail-line and a full targeting\
	acquisition/power management array.<br><field>\
	<b>Instructions:</b> In order to fire the Leviathan, the capacitors must first be coupled by lowering the activation lever. This coupling is, however, extremely energy intensive. \
	Long term activation thus requires a hefty supply of electricity in the APC. Firing the Leviathan itself takes energy directly from the superconducting SMES specially built \
	for the gun. Its firing cost is around 20 megawatts per shot, not counting power taken from the APC in idle mode.<br> \
	To activate the Leviathan itself, two command staff must first couple the warp fields to the firing array by unlocking the safeties on the keycard authentication device. \
	Once that is done, the key must be retrieved from its case in the Captain's office. It must then be placed in the activation terminal in the bridge. \
	The key must then be twisted and, finally, the button to fire the Leviathan will be uncovered and it may be pressed.<field><br>\
	<b>Subject Description:</b> The Leviathan's one and only intended purpose is to annihilate any single target\
	that proves to be an existential threat to the SCCV Horizon and all of its valuable designs and crew. The subject achieves this by pushing and weaponizing \
	already understood warp drive technology to a scale only currently matched by phoron fusion bombs.<br> \
	In layman's terms, an extreme amount of energy is at first used by several high-level warp generators, which instead of bending space around the ship, \
	create a 'warp funnel' around the outer half of the weapon. Every bit of energy remaining is then fired out through the 'warp tunnel', \
	accelerating it into a powerful beam travelling at several times the speed of light. <br>No currently known hull and shield configuration is able to withstand the attack: \
	the beam is expected to inflict too much structural damage for any one vessel to continue fighting. <br>\
	The power draw of a single shot is greater than a single jump operation into bluespace, meaning each use will leave the Horizon vulnerable to any other threats that remain.<br>\
	To date, the prototype has not been tested against stars, planets or other supermassive targets. While its use should be limited to catastrophic scenarios, \
	the Horizon is expected to gather as much field data as possible throughout its journey.<br>")

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-leland_stamp"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.overlays += stampoverlay
	R.stamps += "<HR><i>This paper has been stamped as 'TOP SECRET'.</i>"