/obj/item/weapon/handcuffs
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
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	origin_tech = "materials=1"
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"

/obj/item/weapon/handcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)

	if(!user.IsAdvancedToolUser())
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>Uh ... how do those things work?!</span>"
		place_handcuffs(user, user)
		return

	if(!C.handcuffed)
		if (C == user)
			place_handcuffs(user, user)
			return

		//check for an aggressive grab (or robutts)
//		var/can_place
//		if(istype(user, /mob/living/silicon/robot))
//			can_place = 1
//		else
//			for (var/obj/item/weapon/grab/G in C.grabbed_by)
//				if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
//					can_place = 1
//					break
//
//		if(can_place)
//			place_handcuffs(C, user)
//		else
//			user << "<span class='danger'>You need to have a firm grip on [C] before you can put \the [src] on!</span>"

		//Or just. You know. Don't check for it and place the handcuffs anyways!
		place_handcuffs(C, user)

/obj/item/weapon/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return

	if (!H.has_organ_for_slot(slot_handcuffed))
		user << "<span class='danger'>\The [H] needs at least two wrists before you can cuff them together!</span>"
		return

	if(istype(H.gloves,/obj/item/clothing/gloves/rig)) // Can't cuff someone who's in a deployed hardsuit.
		user << "<span class='danger'>The cuffs won't fit around \the [H.gloves]!</span>"
		return

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_mob(user, target, 30))
		return

	H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [H.name] ([H.ckey])</font>")
	msg_admin_attack("[key_name(user)] attempted to handcuff [key_name(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
	feedback_add_details("handcuffs","H")

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	var/obj/item/weapon/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(get_turf(user))
	else
		user.drop_from_inventory(cuffs)
	cuffs.loc = target
	target.handcuffed = cuffs
	target.update_inv_handcuffed()
	return

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != I_HURT) return
	if (H.zone_sel.selecting != "mouth") return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/item/organ/external/O = H.organs_by_name[H.hand?"l_hand":"r_hand"]
	if (!O) return

	var/s = "\red [H.name] chews on \his [O.name]!"
	H.visible_message(s, "\red You chew on your [O.name]!")
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>")
	log_attack("[s] ([H.ckey])")

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraints"

/obj/item/weapon/handcuffs/cable/red
	color = "#DD0000"

/obj/item/weapon/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/weapon/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/weapon/handcuffs/cable/green
	color = "#00DD00"

/obj/item/weapon/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/weapon/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/weapon/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/weapon/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/weapon/material/wirerod/W = new(get_turf(user))
			user.put_in_hands(W)
			user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"
			qdel(src)
			update_icon(user)

/obj/item/weapon/handcuffs/cyborg
	dispenser = 1


/obj/item/weapon/handcuffs/ziptie
	name = "zipties"
	desc = "Sturdy, and reliable plastic zipties for binding the wrists."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	breakouttime = 600 //One minute, because they're not made of steel, therefore easier to slip out of.
	icon_state = "ziptie"
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	var/singular_name = "ziptie"
	var/amount = 6
	var/max_amount = 6

/obj/item/weapon/handcuffs/ziptie/New(var/loc, var/amount=null)
	..()
	if (amount)
		src.amount=amount
	return

/obj/item/weapon/handcuffs/ziptie/Del()
	if (src && usr && usr.machine==src)
		usr << browse(null, "window=stack")
	..()

/obj/item/weapon/handcuffs/ziptie/examine()
	set src in view(1)
	..()
	usr << "There are [src.amount] [src.singular_name]\s in the stack."
	return

/obj/item/weapon/handcuffs/ziptie/proc/use(var/amount)
	src.amount-=amount
	if (src.amount<=0)
		src = null //dont kill proc after del()
	return

/obj/item/weapon/handcuffs/ziptie/proc/add_to_stacks(mob/usr as mob)
	var/obj/item/weapon/handcuffs/ziptie/oldsrc = src
	src = null
	for (var/obj/item/weapon/handcuffs/ziptie/N in usr.loc)
		if (N==oldsrc)
			continue
		if (!istype(N, oldsrc.type))
			continue
		if (N.amount>=N.max_amount)
			continue
		oldsrc.attackby(N, usr)
		usr << "You add new [N.singular_name] to the stack. It now contains [N.amount] [N.singular_name]\s."
		if(!oldsrc)
			break

/obj/item/weapon/handcuffs/ziptie/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/weapon/handcuffs/ziptie/F = new src.type( user, 1)
		F.copy_evidences(src)
		user.put_in_hands(F)
		src.add_fingerprint(user)
		F.add_fingerprint(user)
		use(1)
		if (src && usr.machine==src)
			spawn(0) src.interact(usr)
	else
		..()
	return

/obj/item/weapon/handcuffs/ziptie/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, src.type))
		var/obj/item/weapon/handcuffs/ziptie/S = W
		if (S.amount >= max_amount)
			return 1
		var/to_transfer as num
		if (user.get_inactive_hand()==src)
			to_transfer = 1
		else
			to_transfer = min(src.amount, S.max_amount-S.amount)
		S.amount+=to_transfer
		if (S && usr.machine==S)
			spawn(0) S.interact(usr)
		src.use(to_transfer)
		if (src && usr.machine==src)
			spawn(0) src.interact(usr)
	else return ..()

/obj/item/weapon/handcuffs/ziptie/proc/copy_evidences(obj/item/weapon/handcuffs/ziptie/from as obj)
	src.blood_DNA = from.blood_DNA
	src.fingerprints  = from.fingerprints
	src.fingerprintshidden  = from.fingerprintshidden
	src.fingerprintslast  = from.fingerprintslast