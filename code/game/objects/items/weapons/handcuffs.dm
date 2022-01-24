/obj/item/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/handcuffs.dmi'
	icon_state = "handcuff"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/cuff.dmi'
	)
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	recyclable = TRUE
	var/legcuff = FALSE
	var/elastic = FALSE
	var/dispenser = 0
	var/breakouttime = 2 MINUTES
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/handcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)
	if(!user.IsAdvancedToolUser())
		return

	if ((user.is_clumsy()) && prob(50))
		to_chat(user, SPAN_WARNING("Uh ... how do those things work?!"))
		place_handcuffs(user, user)
		return

	if((!legcuff && !C.handcuffed) || (legcuff && !C.legcuffed))
		if (C == user)
			place_handcuffs(user, user)
			return

		var/can_place
		if(istype(user, /mob/living/silicon/robot))
			can_place = TRUE
		else
			for (var/obj/item/grab/G in C.grabbed_by)
				if (G.state >= GRAB_AGGRESSIVE)
					can_place = TRUE
					break

		if(can_place)
			place_handcuffs(C, user)
		else
			to_chat(user, SPAN_DANGER("You need to have a firm grip on [C] before you can put \the [src] on!"))

/obj/item/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user, var/instant)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return FALSE

	if((!legcuff && !H.has_organ_for_slot(slot_handcuffed)) || (legcuff && !H.has_organ_for_slot(slot_legcuffed)))
		if(user)
			to_chat(user, SPAN_DANGER("\The [H] needs at least two [legcuff ? "ankles" : "wrists"] before you can cuff them together!"))
		return FALSE

	if(!elastic) // Can't cuff someone who's in a deployed hardsuit.
		if(!legcuff && istype(H.gloves, /obj/item/clothing/gloves/rig))
			if(user)
				to_chat(user, SPAN_DANGER("\The [src] won't fit around \the [H.gloves]!"))
			return FALSE
		if(legcuff && istype(H.shoes, /obj/item/clothing/shoes/magboots/rig))
			if(user)
				to_chat(user, SPAN_DANGER("\The [src] won't fit around \the [H.shoes]!"))
			return FALSE

	if(user)
		user.visible_message(SPAN_DANGER("\The [user] is attempting to put [cuff_type] on \the [H]!"))

	if(!instant)
		if(!do_mob(user, target, 30))
			return

	if(user)
		H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Attempted to handcuff [H.name] ([H.ckey])</span>")
		msg_admin_attack("[key_name_admin(user)] attempted to handcuff [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(H))
	feedback_add_details("handcuffs","H")

	if(user)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(H)
		user.visible_message(SPAN_DANGER("\The [user] has put [cuff_type] on \the [H]!"))

	if(!legcuff)
		target.drop_r_hand()
		target.drop_l_hand()

	// Apply cuffs.
	var/obj/item/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(target)
	else if(user)
		user.drop_from_inventory(cuffs,target)
	else
		cuffs.forceMove(target)

	if(!legcuff)
		target.handcuffed = cuffs
		target.update_inv_handcuffed()
	else
		target.legcuffed = cuffs
		target.update_inv_legcuffed()
	return TRUE

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()


	var/mob/living/carbon/human/H = A
	if (H.last_chew + 26 > world.time) return
	if (!H.handcuffed) return
	if (H.a_intent != I_HURT) return
	if (H.zone_sel.selecting != BP_MOUTH) return
	if (!H.check_has_mouth()) return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/item/organ/external/O = H.organs_by_name[H.hand?BP_L_HAND:BP_R_HAND]
	if (!O) return

	var/s = SPAN_WARNING("[H] chews on [H.get_pronoun("his")] [O.name]!")
	H.visible_message(s, SPAN_WARNING("You chew on your [O.name]!"))
	message_admins("[key_name_admin(H)] is chewing on [H.get_pronoun("his")] restrained hand - (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)")
	H.attack_log += text("\[[time_stamp()]\] <span class='warning'>[s] ([H.ckey])</span>")
	log_attack("[s] ([H.ckey])",ckey=key_name(H))

	if(O.take_damage(3, 0, damage_flags = DAM_SHARP|DAM_EDGE, used_weapon = "teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cablecuff"
	item_state = "coil"
	color = COLOR_RED
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_materials.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_materials.dmi',
		)
	breakouttime = 30 SECONDS
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraint handcuffs"
	var/can_be_cut = TRUE
	elastic = TRUE
	build_from_parts = TRUE
	worn_overlay = "end"

/obj/item/handcuffs/cable/Initialize(mapload, new_color)
	. = ..()
	if(new_color)
		color = new_color

	if(build_from_parts) //random colors!
		if(!color)
			color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
		add_overlay(overlay_image(icon, "[initial(icon_state)]_end", flags=RESET_COLOR))

/obj/item/handcuffs/cable/attack_self(mob/user)
	legcuff = !legcuff
	cuff_type = "cable restraint [legcuff ? "leg" : "hand"]cuffs"
	to_chat(user, SPAN_NOTICE("You twist the cable into [cuff_type]."))
	icon_state = "cable[legcuff ? "leg" : ""]cuff"
	breakouttime = legcuff ? 10 SECONDS : 30 SECONDS

/obj/item/handcuffs/cable/yellow
	color = COLOR_YELLOW

/obj/item/handcuffs/cable/blue
	color = COLOR_BLUE

/obj/item/handcuffs/cable/green
	color = COLOR_GREEN

/obj/item/handcuffs/cable/green/vines
	name = "vine bindings"
	desc = "A set of handcuffs made out of vines. How devilish!"
	can_be_cut = FALSE

/obj/item/handcuffs/cable/green/vines/attack_self(mob/user)
	return

/obj/item/handcuffs/cable/pink
	color = COLOR_PINK

/obj/item/handcuffs/cable/orange
	color = COLOR_ORANGE

/obj/item/handcuffs/cable/cyan
	color = COLOR_CYAN

/obj/item/handcuffs/cable/white
	color = COLOR_WHITE

/obj/item/handcuffs/cable/random/Initialize()
	color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	. = ..()

/obj/item/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/material/wirerod/W = new(get_turf(user), MATERIAL_STEEL, color)
			user.put_in_hands(W)
			to_chat(user, SPAN_NOTICE("You wrap \the [src] around the top of the rod."))
			qdel(src)
			update_icon(user)
	else if(can_be_cut && I.iswirecutter())
		user.visible_message("[user] cuts the [src].", SPAN_NOTICE("You cut the [src]."))
		playsound(src.loc, 'sound/items/wirecutter.ogg', 50, 1)
		new/obj/item/stack/cable_coil(get_turf(src), 15, color)
		qdel(src)
		update_icon(user)

/obj/item/handcuffs/cyborg
	dispenser = TRUE

/obj/item/handcuffs/cable/tape
	name = "tape restraints"
	desc = "DIY!"
	icon_state = "tape_cross"
	item_state = null
	icon = 'icons/obj/bureaucracy.dmi'
	breakouttime = 20 SECONDS
	cuff_type = "duct tape"

/obj/item/handcuffs/ziptie
	name = "ziptie"
	desc = " A sturdy and reliable plastic ziptie for binding the wrists."
	icon_state = "ziptie"
	breakouttime = 1 MINUTE
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "zipties"
	elastic = TRUE

/obj/item/handcuffs/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	icon_state = "legcuff"
	legcuff = TRUE
	breakouttime = 30 SECONDS
	cuff_type = "legcuffs"
