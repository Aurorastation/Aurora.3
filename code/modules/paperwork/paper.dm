/*
 * Paper
 * also scraps of paper
 */

/obj/item/paper
	name = "paper"
	desc = "A piece of paper."
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	var/base_state = "paper"
	item_state = "paper"
	contained_sprite = 1
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_range = 1
	throw_speed = 1
	layer = 4
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields		//Amount of user created fields
	var/free_space = MAX_PAPER_MESSAGE_LEN
	var/list/stamped
	var/list/ico[0]      //Icons and
	var/list/offset_x[0] //offsets stored for later
	var/list/offset_y[0] //usage by the photocopier
	var/rigged = 0
	var/last_honk = 0
	var/old_name		// The name of the paper before it was folded into a plane.
	var/can_fold = TRUE		// If it can be folded into a plane or swan
	var/paper_like = TRUE		// Is it made of paper and/or burnable material?

	var/const/deffont = "Verdana"
	var/const/signfont = "Times New Roman"
	var/const/crayonfont = "Comic Sans MS"
	var/const/fountainfont = "Segoe Script"
	var/const/typewriterfont = "Typewriter"

	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	var/can_change_icon_state = TRUE
	var/set_unsafe_on_init = FALSE

/obj/item/paper/Initialize(mapload, text, title)
	. = ..()
	base_state = initial(icon_state)
	if (text || title)
		if(set_unsafe_on_init)
			set_content_unsafe(title, text ? text : info)
		else
			set_content(title, text ? text : info)
	else
		updateinfolinks()
		if (mapload)
			update_icon()
		else
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 1)

/obj/item/paper/proc/set_content(title, text)
	if(title)
		name = title
	if (text && length(text))
		info = parsepencode(text)
	else
		info = ""

	update_icon()
	update_space(info)
	updateinfolinks()

// DO NOT USE THIS FOR UNTRUSTED PLAYER INPUT. IT DOES NOT SANITIZE.
/obj/item/paper/proc/set_content_unsafe(title, text)
	if (title)
		name = title
	if (text && length(text))
		info = text
	else
		info = ""

	update_icon()
	update_space(info)
	updateinfolinks()

/obj/item/paper/update_icon()
	if(!can_change_icon_state)
		return
	else if (info && length(trim(info)))
		icon_state = "[base_state]_words"
	else
		icon_state = "[base_state]"

/obj/item/paper/proc/update_space(var/new_text)
	if(new_text)
		free_space -= length(strip_html_properly(new_text))

/obj/item/paper/examine(mob/user, distance, is_adjacent)
	. = ..()
	if (old_name && (icon_state == "paper_plane" || icon_state == "paper_swan"))
		to_chat(user, SPAN_NOTICE("You're going to have to unfold it before you can read it."))
		return
	if(name != initial(name))
		to_chat(user,"It's titled '[name]'.")
	if(distance <= 1)
		show_content(user)
	else
		to_chat(user, SPAN_NOTICE("You have to go closer if you want to read it."))

/obj/item/paper/proc/show_content(mob/user, forceshow)
	simple_asset_ensure_is_sent(user, /datum/asset/simple/paper)
	var/datum/browser/paper_win = new(user, name, null, 450, 500, null, TRUE)
	paper_win.set_content(get_content(user, can_read(user, forceshow)))
	paper_win.add_stylesheet("paper_languages", 'html/browser/paper_languages.css')
	paper_win.open()

/obj/item/paper/proc/can_read(var/mob/user, var/forceshow = FALSE)
	var/can_read = (istype(user, /mob/living/carbon/human) || isobserver(user) || istype(user, /mob/living/silicon)) || forceshow
	if(!forceshow && istype(user,/mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI
		can_read = get_dist(src, AI.camera) < 2
	return can_read

/obj/item/paper/proc/get_content(var/mob/user, var/can_read = TRUE)
	return "<head><title>[capitalize_first_letters(name)]</title><style>body {background-color: [color];}</style></head><body>[can_read ? parse_languages(user, info) : stars(info)][stamps]</body>"

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT))
		return

	if((usr.is_clumsy()) && prob(50))
		to_chat(usr, SPAN_WARNING("You cut yourself on the paper."))
		return

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the paper?", "Paper Labelling", null) as text, MAX_NAME_LEN)

	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT))
		return

	var/atom/surface_atom = recursive_loc_turf_check(src, 3, usr)
	if(surface_atom == usr || surface_atom.Adjacent(usr))
		if(n_name)
			name = "[initial(name)] ([n_name])"
		else
			name = initial(name)
		add_fingerprint(usr)

/obj/item/paper/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT && paper_like)
		if(icon_state == "scrap")
			user.show_message(SPAN_WARNING("\The [src] is already crumpled."))
			return
		//crumple dat paper
		info = stars(info,85)
		user.visible_message("\The [user] crumples \the [src] into a ball!", "You crumple \the [src] into a ball.")
		playsound(src, 'sound/bureaucracy/papercrumple.ogg', 50, 1)
		icon_state = "scrap"
		throw_range = 4 //you can now make epic paper ball hoops into the disposals (kinda dumb that you could only throw crumpled paper 1 tile) -wezzy
		return

	if (user.a_intent == I_GRAB && icon_state != "scrap" && can_fold)
		if (icon_state == "paper_plane")
			user.show_message(SPAN_ALERT("The paper is already folded into a plane."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] carefully folds \the [src] into a plane."),
			SPAN_NOTICE("You carefully fold \the [src] into a plane."), "\The [user] folds \the [src] into a plane.")
		playsound(src, 'sound/bureaucracy/paperfold.ogg', 50, 1)
		icon_state = "paper_plane"
		throw_range = 8
		old_name = name
		name = "paper plane"
		cut_overlays() //Removes stamp icons
		return

	if (user.a_intent == I_DISARM && icon_state != "scrap" && can_fold)
		if (icon_state == "paper_swan")
			user.show_message(SPAN_ALERT("The paper is already folded into a swan."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] carefully folds \the [src] into an origami swan."),
			SPAN_NOTICE("You carefully fold \the [src] into a swan."), "\The [user] folds \the [src] into a swan.")
		playsound(src, 'sound/bureaucracy/paperfold.ogg', 50, 1)
		icon_state = "paper_swan"
		old_name = name
		name = "origami swan"
		cut_overlays() //Removes stamp icons
		return

	if (user.a_intent == I_HELP && old_name && (icon_state == "paper_plane" || icon_state == "paper_swan"))
		user.visible_message(SPAN_NOTICE("\The [user] unfolds \the [src]."), SPAN_NOTICE("You unfold \the [src]."), "You hear paper rustling.")
		playsound(src, 'sound/bureaucracy/paperfold.ogg', 50, 1)
		icon_state = base_state
		throw_range = initial(throw_range)
		name = old_name
		old_name = null
		restore_stamps()
		update_icon()
		return

	examinate(user, src)
	if(rigged && (Holiday == "April Fool's Day"))
		if(last_honk <= world.time - 20) //Spam limiter.
			last_honk = world.time
			playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)

/obj/item/paper/attack_ai(var/mob/living/silicon/ai/user)
	show_content(user)

/obj/item/paper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	if(target_zone == BP_EYES)
		user.visible_message(SPAN_NOTICE("You show \the [src] to [M]."), \
			SPAN_NOTICE("[user] holds up \the [src] and shows it to [M]."))
		examinate(M, src)

	else if(target_zone == BP_MOUTH && paper_like) // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, SPAN_NOTICE("You wipe off the lipstick with [src]."))
				H.lipstick_color = null
				H.update_body()
			else
				user.visible_message(SPAN_WARNING("[user] begins to wipe [H]'s lipstick off with \the [src]."), \
										SPAN_NOTICE("You begin to wipe off [H]'s lipstick."))
				if(do_after(user, 1 SECOND, H, do_flags = (DO_DEFAULT | DO_USER_UNIQUE_ACT) & ~DO_BOTH_CAN_TURN))
					user.visible_message(SPAN_NOTICE("[user] wipes [H]'s lipstick off with \the [src]."), \
											SPAN_NOTICE("You wipe off [H]'s lipstick."))
					H.lipstick_color = null
					H.update_body()

/obj/item/paper/proc/addtofield(var/id, var/text, var/links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(1) // I know this can cause infinite loops and fuck up the whole server, but the if(istart==0) should be safe as fuck
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart==0)
			return // No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()

/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for (var/i = 1, i <= min(fields, 35), i++)
		addtofield(i, "<font face=\"[deffont]\"><A href='?src=\ref[src];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[deffont]\"><A href='?src=\ref[src];write=end'>write</A></font>"


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	free_space = MAX_PAPER_MESSAGE_LEN
	stamped = list()
	cut_overlays()
	updateinfolinks()
	update_icon()

/obj/item/paper/proc/get_signature(var/obj/item/pen/P, mob/user as mob)
	if(P && P.ispen())
		return P.get_signature(user)

	if (user)
		if (user.mind && user.mind.signature)
			return user.mind.signature
		else if (user.real_name)
			return "<i>[user.real_name]</i>"

	return "<i>Anonymous</i>"

/obj/item/paper/proc/get_signfont(var/obj/item/pen/P, var/mob/user)
	if (!istype(P, /obj/item/pen/chameleon))
		if (user && user.mind && user.mind.signfont)
			return user.mind.signfont

	return signfont

/obj/item/paper/proc/parsepencode(t, obj/item/pen/P, mob/user, iscrayon, isfountain, istypewriter)
	if(user)
		t = parse_languages(user, t, TRUE)
	if(P)
		t = replacetext(t, "\[sign\]", "<font face=\"[get_signfont(P, user)]\">[get_signature(P, user)]</font>")

	if(iscrayon) // If it is a crayon, and he still tries to use these, make them empty!
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")
		t = replacetext(t, "\[table\]", "")
		t = replacetext(t, "\[/table\]", "")
		t = replacetext(t, "\[row\]", "")
		t = replacetext(t, "\[cell\]", "")
		t = replacetext(t, "\[logo_scc\]", "")
		t = replacetext(t, "\[logo_scc_small\]", "")
		t = replacetext(t, "\[logo_nt\]", "")
		t = replacetext(t, "\[logo_nt_small\]", "")
		t = replacetext(t, "\[logo_zh\]", "")
		t = replacetext(t, "\[logo_zh_small\]", "")
		t = replacetext(t, "\[logo_idris\]", "")
		t = replacetext(t, "\[logo_idris_small\]", "")
		t = replacetext(t, "\[logo_eridani\]", "")
		t = replacetext(t, "\[logo_eridani_small\]", "")
		t = replacetext(t, "\[logo_zavod\]", "")
		t = replacetext(t, "\[logo_zavod_small\]", "")
		t = replacetext(t, "\[logo_hp\]", "")
		t = replacetext(t, "\[logo_hp_small\]", "")
		t = replacetext(t, "\[logo_be\]", "")
		t = replacetext(t, "\[logo_golden\]", "")
		t = replacetext(t, "\[barcode\]", "")

	if(istypewriter)
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")
		t = replacetext(t, "\[table\]", "")
		t = replacetext(t, "\[/table\]", "")
		t = replacetext(t, "\[row\]", "")
		t = replacetext(t, "\[cell\]", "")
		t = replacetext(t, "\[barcode\]", "")

	if(iscrayon)
		t = "<font face=\"[crayonfont]\" color=[P ? P.colour : "black"]><b>[t]</b></font>"
	else if(isfountain)
		t = "<font face=\"[fountainfont]\" color=[P ? P.colour : "black"]><i>[t]</i></font>"
	else if(istypewriter)
		t = "<font face=\"[typewriterfont]\" color=[P ? P.colour : "black"]><i>[t]</i></font>"
	else
		t = "<font face=\"[deffont]\" color=[P ? P.colour : "black"]>[t]</font>"

	t = pencode2html(t)

	//Count the fields
	var/laststart = 1
	while(1)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)	//</span>
		if(i==0)
			break
		laststart = i+1
		fields++

	return t


/obj/item/paper/proc/burnpaper(obj/item/P, mob/user)
	var/class = "warning"
	if(!use_check_and_message(user) && paper_like)
		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose"

		user.visible_message("<span class='[class]'>[user] holds \the [P] up to \the [src], it looks like [user.get_pronoun("he")]'s trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")
		playsound(src.loc, 'sound/bureaucracy/paperburn.ogg', 50, 1)
		if(icon_state == "scrap")
			flick("scrap_onfire", src)
		else
			flick("paper_onfire", src)

		addtimer(CALLBACK(src, PROC_REF(burnpaper_callback), P, user, class), 20, TIMER_UNIQUE)

/obj/item/paper/proc/burnpaper_callback(obj/item/P, mob/user, class = "warning")
	if (QDELETED(user) || QDELETED(src))
		return

	if(get_dist(src, user) < 2 && user.get_active_hand() == P)
		user.visible_message("<span class='[class]'>[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
		"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

		if(user.get_inactive_hand() == src)
			user.drop_from_inventory(src)

		new /obj/effect/decal/cleanable/ash(src.loc)
		qdel(src)

	else
		to_chat(user, "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>")


/obj/item/paper/proc/restore_stamps() //Used when unfolding paper from cranes or planes, restores the stamp overlays.
	for(var/i = 1, i <= ico.len, i++)
		var/image/S = image('icons/obj/bureaucracy.dmi', ico[i])
		S.pixel_x = offset_x[i]
		S.pixel_y = offset_y[i]
		add_overlay(S)
/**
 * Takes the paper's info variable, a user, and parses language markers that exist
 * in it. It returns an HTML string which represents the languages properly.
 *
 * @param	user The mob we're parsing the text for.
 *
 * @return	An HTML string where all of the [lang][/lang] marker contents are replaced
 * with scrambled and properly fonted content depending on what languages the user knows.
 */
/obj/item/paper/proc/parse_languages(mob/user, input, language_check = FALSE)
	// Just a safety fallback.
	if (!user)
		return input

	var/static/regex/written_lang_regex
	if (!written_lang_regex)
		written_lang_regex = new(@"(\[lang=([#_a-zA-Z0-9\^]{1})])(.*?)(\[\/lang])", "g")

	. = input

	while (written_lang_regex.Find(.))
		var/datum/language/L = GLOB.language_keys[written_lang_regex.group[2]]
		// Unknown language.
		if (!L || !L.written_style)
			continue

		var/content = written_lang_regex.group[3]
		var/reader_understands = user.say_understands(null, L)

		// Replace the content with <p>content here</p>
		if(!reader_understands)
			if(language_check)
				. = replacetext(., written_lang_regex.match, "")
			else
				content = L.scramble(content)

		if(!language_check)
			// Refer to paper/proc/show_content to edit the spans here.
			. = replacetext(., written_lang_regex.match, "<span class='[L.written_style] [reader_understands ? "understood" : "scramble"]'>[L.short && reader_understands ? "([L.short]) [content]" : content]</span>")

/obj/item/paper/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.restrained()))
		return

	if(href_list["write"])
		var/id = href_list["write"]
		//var/t = strip_html_simple(input(usr, "What text do you wish to add to " + (id=="end" ? "the end of the paper" : "field "+id) + "?", "[name]", null),8192) as message

		if(free_space <= 0)
			to_chat(usr, SPAN_INFO("There isn't enough space left on \the [src] to write anything."))
			return

		var/t =  sanitize(input("Enter what you want to write:", "Write", null, null) as message, free_space, extra = 0)

		if(!t)
			return

		var/obj/item/i = usr.get_active_hand() // Check to see if he still got that darn pen, also check if he's using a crayon or pen.

		if(!i && istype(loc, /obj/item/portable_typewriter))
			var/obj/item/portable_typewriter/T = loc
			if(T.pen)
				i = T.pen

		if(i && istype(i, /obj/item/portable_typewriter) || !i && istype(loc, /obj/item/portable_typewriter))
			var/obj/item/portable_typewriter/T = i
			if(T.pen)
				i = T.pen

		if(!i || !i.ispen())
			i = usr.get_inactive_hand()
		var/obj/item/clipboard/c
		var/iscrayon = FALSE
		var/isfountain = FALSE
		var/istypewriter = FALSE
		if(!i.ispen())
			if(usr.back && istype(usr.back,/obj/item/rig))
				var/obj/item/rig/r = usr.back
				var/obj/item/rig_module/device/pen/m = locate(/obj/item/rig_module/device/pen) in r.installed_modules
				if(!r.offline && m)
					i = m.device
				else
					return
			if(istype(src.loc, /obj/item/clipboard))
				c = src.loc
				if(c.haspen)
					i = c.haspen
			else
				return

		if(istype(i, /obj/item/pen/crayon))
			iscrayon = TRUE

		if(istype(i, /obj/item/pen/fountain) || istype(i, /obj/item/pen/augment))
			var/obj/item/pen/f = i
			if(f.cursive)
				isfountain = TRUE
			else
				isfountain = FALSE

		if(istype(i, /obj/item/pen/typewriter))
			istypewriter = TRUE

		if(!write_check(usr))
			return

		var/last_fields_value = fields

		t = parsepencode(t, i, usr, iscrayon, isfountain, istypewriter) // Encode everything from pencode to html

		if(fields > 50)//large amount of fields creates a heavy load on the server, see updateinfolinks() and addtofield()
			to_chat(usr, SPAN_WARNING("Too many fields. Sorry, you can't do this."))
			fields = last_fields_value
			return

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()

		update_space(t)

		var/datum/browser/paper_win = new(usr, name, null, 450, 500, null, TRUE)
		paper_win.set_content("<head><title>[capitalize_first_letters(name)]</title><style>body {background-color: [color];}</style></head><body>[parse_languages(usr, info_links)][stamps]</body>")
		paper_win.add_stylesheet("paper_languages", 'html/browser/paper_languages.css')
		paper_win.open()

		if(istype(i, /obj/item/pen/typewriter))
			playsound(src, ('sound/machines/typewriter.ogg'), 40)
		else
			playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)

		update_icon()
		if(c)
			c.update_icon()

/obj/item/paper/proc/write_check(var/mob/user)
	. = TRUE
	// if paper is not in usr, then it must be near them, or in a clipboard or folder, which must be in or near usr
	if(loc != user && !Adjacent(user))
		. = FALSE
	if(!. && istype(loc, /obj/item/clipboard))
		var/obj/item/clipboard/C = loc
		if(C.loc == user || C.Adjacent(user))
			. = TRUE
	if(!. && istype(loc, /obj/item/folder))
		var/obj/item/folder/F = loc
		if(F.loc_check(user) || F.Adjacent(user))
			. = TRUE
	if(!. && istype(loc, /obj/item/portable_typewriter))
		var/obj/item/portable_typewriter/T = loc
		if(T.loc == user || T.Adjacent(user))
			. = TRUE

/obj/item/paper/attackby(var/obj/item/P, mob/user)
	..()

	if(istype(P, /obj/item/tape_roll) && !istype(src, /obj/item/paper/business_card))
		var/obj/item/tape_roll/tape = P
		tape.stick(src, user)
		return

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/photo))
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, SPAN_NOTICE("Take off the carbon copy first."))
				add_fingerprint(user)
				return
		var/obj/item/paper_bundle/B = new(src.loc)
		if (name != initial(name))
			B.name = name
		else if (P.name != initial(P.name))
			B.name = P.name
		user.drop_from_inventory(P,B)
		//TODO: Look into this stuff
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			if (h_user.r_hand == src)
				h_user.drop_from_inventory(src)
				h_user.equip_to_slot_if_possible(B, slot_r_hand)
			else if (h_user.l_hand == src)
				h_user.drop_from_inventory(src)
				h_user.equip_to_slot_if_possible(B, slot_l_hand)
			else if (h_user.l_store == src)
				h_user.drop_from_inventory(src)
				B.forceMove(h_user)
				B.layer = SCREEN_LAYER+0.01
				h_user.l_store = B
				h_user.update_inv_pockets()
			else if (h_user.r_store == src)
				h_user.drop_from_inventory(src)
				B.forceMove(h_user)
				B.layer = SCREEN_LAYER+0.01
				h_user.r_store = B
				h_user.update_inv_pockets()
			else if (h_user.head == src)
				h_user.u_equip(src)
				h_user.put_in_hands(B)
			else if (!istype(src.loc, /turf))
				src.forceMove(get_turf(h_user))
				if(h_user.client)	h_user.client.screen -= src
				h_user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You clip the [P.name] to [(src.name == "paper") ? "the paper" : src.name]."))
		src.forceMove(B)

		B.pages.Add(src)
		B.pages.Add(P)
		B.amount = 2
		B.update_icon()

	else if(P.ispen())
		if(icon_state == "scrap")
			to_chat(user, SPAN_WARNING("The [src] is too crumpled to write on."))
			return

		var/obj/item/pen/robopen/RP = P
		if ( istype(RP) && RP.mode == 2 )
			RP.RenamePaper(user,src)
		else
			var/datum/browser/paper_win = new(user, name, null, 450, 500, null, TRUE)
			paper_win.set_content("<head><title>[capitalize_first_letters(name)]</title><style>body {background-color: [color];}</style></head><body>[info_links][stamps]</body>")
			paper_win.add_stylesheet("paper_languages", 'html/browser/paper_languages.css')
			paper_win.open()
		return

	else if(istype(P, /obj/item/stamp) || istype(P, /obj/item/clothing/ring/seal))
		if((!in_range(src, usr) && loc != user && !( istype(loc, /obj/item/clipboard) ) && loc.loc != user && user.get_active_hand() != P))
			return

		stamps += (stamps=="" ? "<HR>" : "<BR>") + "<i>This paper has been stamped with the [P.name].</i>"

		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		var/x
		var/y
		if(istype(P, /obj/item/stamp/captain) || istype(P, /obj/item/stamp/centcomm))
			x = rand(-2, 0)
			y = rand(-1, 2)
		else
			x = rand(-2, 2)
			y = rand(-3, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(!ico)
			ico = new
		ico += "paper_[P.icon_state]"
		stampoverlay.icon_state = "paper_[P.icon_state]"

		if(!stamped)
			stamped = new
		stamped += P.type
		add_overlay(stampoverlay)

		playsound(src, 'sound/bureaucracy/stamp.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You stamp the paper with \the [P]."))

	else if(P.isFlameSource())
		burnpaper(P, user)

	update_icon()
	add_fingerprint(user)
	return

/*
 * Premade paper
 */
/obj/item/paper/Court
	name = "Judgement"
	info = "For crimes against the station, the offender is sentenced to:<BR>\n<BR>\n"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"

/obj/item/paper/crumpled/update_icon()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/incident
	name = "incident form receipt"
	var/datum/crime_incident/incident
	var/sentence = 1 // Is this form contain a sentence of guilty?

/obj/item/paper/incident/New()
	var/T = parsepencode({"\[center\]\[logo_scc\]\[/center\]
		\[center\]\[b\]\[i\]Encoded SCC Security Incident Report\[/b\]\[/i\]\[hr\]
		\[small\]FOR USE BY <b>SCCV HORIZON</b> SECURITY ONLY\[/small\]\[br\]
		\[barcode\]\[/center\]"})
	info = T

	..()

/obj/item/paper/sentencing
	name = "Sentencing and You"
	icon_state = "pamphlet"

/obj/item/paper/sentencing/New()
	var/T = parsepencode(
		{"\[center\]\[logo_scc_small\]\[/center\]
		\[center\]\[b\]\[i\]Operation of Sentencing Consoles\[/b\]\[/i\]\[hr\]
		\[small\]In compliance with SCC criminal regulations, the \[b\][station_name()]\[/b\] has been equipped with state of the art sentencing consoles. The operation of these consoles, or computers, is quite simple:
		While preparing a convicted individual, remove their ID and have the console scan it.\[br\]
		Next, select all applicable charges from the menu available. The console will calculate the sentence based on the minimum recommended sentence - any variables such as repeat offense will need to be manually accounted for.\[br\]
		After all the charges have been applied, the processing officer is invited to add a short description of the incident, any related evidence, and any witness testimonies.\[br\]
		Simply press the option "Render Guilty", and the sentence is complete! The convict's records will be automatically updated to reflect their crimes. You should now insert the printed receipt into the cell timer, and begin processing.\[br\]
		\[hr\]Please note: Cell timers will \[b\]NOT\[/b\] function without a valid incident form report inserted into them."}
	)
	info = T

	..()

/obj/item/paper/sentencing/update_icon()
	return

/obj/item/paper/nka_pledge
	name = "imperial volunteer Alam'ardii corps pledge"
	info = "<center><b><u>Imperial Volunteer Alam'ardii Corps Pledge</u></b></center> <hr> <center><i><u>May the Gods bless his Kingdom and Dynasty</u></i></center> <hr> I, <field>, hereby declare, under a vow of loyalty and compromise, that I shall serve as a volunteer in the Imperial Volunteer Alam'ardii Corps, for the mininum duration of three years or until discharge. I accept the duty of aiding the New Kingdom of Adhomai and His Majesty, King Vahzirthaamro Azunja, in this struggle and I shall not relinquish this pledge. <hr> Volunteer Signature: <field> <hr> Recruiting Officer Stamp:"

/obj/item/paper/medscan
	icon_state = "medscan"
	color = "#eeffe8"
	set_unsafe_on_init = TRUE
	var/datum/weakref/scan_target

/obj/item/paper/medscan/Initialize(mapload, text, title, var/atom/set_scan_target)
	. = ..()
	scan_target = WEAKREF(set_scan_target)

//
// Fluff Papers
// Fluff papers that you can map in, for lore or whatever.
//

// Parent item.
/obj/item/paper/fluff
	name = "fluff paper"
	desc = "You aren't supposed to see this."

// Used in the deck 3 cafe on the SCCV Horizon.
/obj/item/paper/fluff/microwave
	name = "\improper RE: Where are our microwaves?"
	desc = "A paper."
	info = "<font face=\"Verdana\"><font size=\"1\"><i>2464-04-30 04:50 GST</i></font><BR><font size=\"1\"><i>E-Mail Title: RE: Where are our microwaves?</i></font>\
		<BR>We are sorry for the lack of a microwave, but the transport got misdirected on the way.<BR>-<font face=\"Courier New\"><i>Orion Express Customer \
		Service</i></font><BR><BR><font size=\"1\"><i>2464-04-30 07:50 GST</i></font><BR><font size=\"1\"><i>E-Mail Title: RE: Where are our microwaves?</i></font>\
		<BR>We apologize for the lack of a microwave. As compensation, employees are given a donut box. Please enjoy.<BR>-<font face=\"Courier New\"><i>SCC Internal \
		Affairs</i></font></font>"

// Used in the bunker on the SCCV Horizon.
/obj/item/paper/fluff/bunker
	name = "bunker evacuation route instructions"
	desc = "A paper. It has evacuation route instructions printed on it."
	info = "<font face=\"Verdana\"><center>SCCV Horizon Command Bunker<br>Evacuation Route Instructions</center><font size=\"2\"><ol><li>Put on the emergency \
		welding goggles.</li><li>Grasp the emergency welding tool firmly in your hands, turn it on, and start cutting a hole in the floor.</li><li>Wait for \
		the newly created hole to cool.<li>Use the emergency crowbar to pry away the metal.</li><li>Deploy the emergency ladder.</li><li>Dispose of the used \
		equipment, if necessary.</li></ol></font></font>"

// Used in the bridge on the SCCV Horizon
/obj/item/paper/fluff/bridge
	name = "bridge evacuation route instructions"
	desc = "A paper. It has evacuation route instructions printed on it."
	info = "<font face=\"Verdana\"><center>SCCV Horizon Command <br>Evacuation Route Instructions</center><font size=\"2\"><ol><li>Put on the emergency \
		welding goggles.</li><li>Grasp the emergency welding tool firmly in your hands, turn it on, and start cutting a hole in the floor.</li><li>Wait for \
		the newly created hole to cool.<li>Use the emergency crowbar to pry away the metal.</li><li>Deploy the emergency ladder.</li><li>Dispose of the used \
		equipment, if necessary.</li></ol></font></font>"

// Used on the IAC ship, meant for distribution.
/obj/item/paper/fluff/iac
	name = "interstellar aid corps info pamphlet"
	desc = "A paper. It has an IAC logo stamped right on front of it."
	info = "<font face=\"Verdana\"><center><b>The Interstellar Aid Corps Needs YOUR Help!</b></center><br>With the crisis in the Wildlands still affecting billions \
	of people, now more than ever the IAC needs your help to provide relief to those worst affected by Phoron shortages, Warlord attacks, and even a lack of \
	basic necessities, such as food and water.<br>The IAC and its personnel have been able to provide relief to hundreds of colonies, but this can only happen \
	with your support. As such, local IAC vessels and stations are accepting donations of non-perishable foods and water, as well as medical supplies of any type. \
	Additionally, at the behest of the IAC coordinator in your area of space, you can join for a blood drive or apply to volunteer in the IAC. <br> \
	<center><i>Remember - it's up to all of us to look after our galaxy!</i></center></font>"
