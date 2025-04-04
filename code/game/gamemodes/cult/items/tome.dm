/obj/item/book/tome
	name = "arcane tome"
	desc_antag = null // It's already been forged once.
	icon_state = "tome"
	item_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	unique = TRUE
	slot_flags = SLOT_BELT

/obj/item/book/tome/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(isobserver(target_mob))
		var/mob/abstract/ghost/observer/D = target_mob
		D.manifest(user)
		attack_admins(D, user)
		return

	if(!istype(target_mob))
		return

	if(!iscultist(user))
		return ..()

	if(iscultist(target_mob))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	target_mob.take_organ_damage(0, rand(5,20)) //really lucky - 5 hits for a crit
	visible_message(SPAN_WARNING("\The [user] beats \the [target_mob] with \the [src]!"))
	to_chat(target_mob, SPAN_DANGER("You feel searing heat inside!"))
	attack_admins(target_mob, user)

/obj/item/book/tome/proc/attack_admins(var/mob/living/target_mob, var/mob/living/user)
	target_mob.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had the [name] used on them by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <span class='warning'>Used [name] on [target_mob.name] ([target_mob.ckey])</span>"
	msg_admin_attack("[key_name_admin(user)] used [name] on [target_mob.name] ([target_mob.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target_mob))


/obj/item/book/tome/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!ishuman(user) || !iscultist(user))
		return ..()
	if(!proximity_flag || target.density || !isturf(target))
		return ..()

	if(use_check_and_message(user))
		return
	scribe_rune_to_turf(user, target)

/obj/item/book/tome/attack_self(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/scribe = user
	if(use_check_and_message(scribe))
		return

	if(iscultist(scribe))
		var/turf/current_turf = get_turf(scribe)
		scribe_rune_to_turf(user, current_turf)
	else
		to_chat(user, SPAN_CULT("The book seems full of illegible scribbles."))

/obj/item/book/tome/proc/scribe_rune_to_turf(var/mob/living/carbon/human/scribe, var/turf/target_turf)
	if(!isturf(scribe.loc))
		to_chat(scribe, SPAN_WARNING("You do not have enough space to write a proper rune."))
		return

	if(target_turf.is_hole || target_turf.is_space())
		to_chat(scribe, SPAN_WARNING("You are unable to write a rune here."))
		return

	if(locate(/obj/effect/rune) in scribe.loc)
		to_chat(scribe, SPAN_WARNING("There is already a rune in this location."))
		return

	if(use_check_and_message(scribe))
		return

	var/chosen_rune = tgui_input_list(scribe, "Choose a rune to scribe.", "Cultist Tome", SScult.runes_by_name)
	if(!chosen_rune)
		return

	var/rune_type = SScult.runes_by_name[chosen_rune]
	if(SScult.check_rune_limit(rune_type))
		to_chat(scribe, SPAN_WARNING("The cloth of reality can't take that much of a strain. Remove some runes first!"))
		return

	if(use_check_and_message(scribe))
		return

	scribe.visible_message(SPAN_CULT("[scribe] slices open their palm with a ceremonial knife, drawing arcane symbols with their blood..."))
	playsound(scribe, 'sound/weapons/bladeslice.ogg', 50, FALSE)
	scribe.drip(4)

	if(do_after(scribe, 3 SECONDS))
		create_rune(scribe, chosen_rune, target_turf)

/obj/item/book/tome/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(iscultist(user) || isobserver(user))
		. += "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual his followers could think of. Most of these are useless, though."
		. += SPAN_WARNING("\[?\] This tome contains arcane knowledge of the Geometer's runes. <a href='byond://?src=[REF(src)];read_tome=1>\[Read Tome\]</a>")
	else
		. += "An old, dusty tome with frayed edges and a sinister looking cover."

/obj/item/book/tome/Topic(href, href_list)
	if(href_list["read_tome"])
		if(use_check_and_message(usr))
			return
		var/datum/browser/tome_win = new(usr, "Arcane Tome", "Nar'Sie's Runes")
		tome_win.set_content(SScult.tome_data)
		tome_win.add_stylesheet("cult", 'html/browser/cult.css')
		tome_win.open()
		return
	return ..()

/obj/item/book/tome/cultify()
	return
