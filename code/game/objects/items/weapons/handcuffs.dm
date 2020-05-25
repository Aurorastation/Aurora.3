/obj/item/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/elastic
	var/dispenser = 0
	var/is_restraining = FALSE
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/handcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)

	if(!user.IsAdvancedToolUser())
		return

	if ((user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='warning'>Uh ... how do those things work?!</span>")
		place_handcuffs(user, user)
		return

	if(!C.handcuffed)
		if (C == user)
			place_handcuffs(user, user)
			return

		var/fast_place
		if(istype(user, /mob/living/silicon/robot))
			fast_place = TRUE
		else
			for (var/obj/item/grab/G in C.grabbed_by)
				if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
					fast_place = TRUE
					break

		if(fast_place)
			place_handcuffs(C, user)
		else
			if(C.stat == DEAD) // gotta make sure those corpses don't run off...
				restrain(C, user)
				return
			if(C.stat == UNCONSCIOUS)
				restrain()
				return
			if(C.a_intent == I_HELP)
				restrain(C, user)
			else
				to_chat(user, "<span class='danger'>\the [C] is not unconscious or cooperative! Try getting a good grip on them first, or suggest they cooperate!</span>")
				to_chat(C, "<span class='danger'>\the [user] is trying to restrain you, but you resist them! Try being more helpful if you meant to cooperate.</span>")

/obj/item/handcuffs/proc/restrain(var/mob/living/carbon/C, var/mob/user)
	if(is_restraining)
		return
	is_restraining = TRUE
	to_chat(user, "<span class='danger'>You begin to restrain [C] with \the [src]. This would be faster if you had a firm grip on them!</span>")
	visible_message("<span class='danger'>\The [user] is attempting to restrain \the [C]!</span>")
	if(!do_mob(user, C, 70))
		is_restraining = FALSE
		return	
	is_restraining = FALSE
	place_handcuffs(C, user)

/obj/item/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0

	if (!H.has_organ_for_slot(slot_handcuffed))
		to_chat(user, "<span class='danger'>\The [H] needs at least two wrists before you can cuff them together!</span>")
		return 0

	if(istype(H.gloves,/obj/item/clothing/gloves/rig) && !elastic) // Can't cuff someone who's in a deployed hardsuit.
		to_chat(user, "<span class='danger'>\The [src] won't fit around \the [H.gloves]!</span>")
		return 0

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_mob(user, target, 30))
		return

	H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [H.name] ([H.ckey])</font>")
	msg_admin_attack("[key_name_admin(user)] attempted to handcuff [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(H))
	feedback_add_details("handcuffs","H")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")
	target.drop_r_hand()
	target.drop_l_hand()
	// Apply cuffs.
	var/obj/item/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(target)
	else
		user.drop_from_inventory(cuffs,target)
	target.handcuffed = cuffs
	target.update_inv_handcuffed()
	return 1

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

	var/s = "<span class='warning'>[H.name] chews on \his [O.name]!</span>"
	H.visible_message(s, "<span class='warning'>You chew on your [O.name]!</span>")
	message_admins("[key_name_admin(H)] is chewing on [H.get_pronoun(1)] restrained hand - (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)")
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>")
	log_attack("[s] ([H.ckey])",ckey=key_name(H))

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraints"
	elastic = 1

/obj/item/handcuffs/cable/red
	color = "#DD0000"

/obj/item/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/handcuffs/cable/green
	color = "#00DD00"

/obj/item/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/material/wirerod/W = new(get_turf(user))
			user.put_in_hands(W)
			to_chat(user, "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>")
			qdel(src)
			update_icon(user)

/obj/item/handcuffs/cyborg
	dispenser = 1

/obj/item/handcuffs/cable/tape
	name = "tape restraints"
	desc = "DIY!"
	icon_state = "tape_cross"
	item_state = null
	icon = 'icons/obj/bureaucracy.dmi'
	breakouttime = 200
	cuff_type = "duct tape"

/obj/item/handcuffs/ziptie
	name = "ziptie"
	desc = " A sturdy and reliable plastic ziptie for binding the wrists."
	icon = 'icons/obj/items.dmi'
	icon_state = "ziptie"
	breakouttime = 600
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	elastic = 1
