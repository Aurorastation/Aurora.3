/obj/item/clothing/accessory/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	slot = ACCESSORY_SLOT_UTILITY
	var/obj/item/holstered = null
	var/sound_in = 'sound/weapons/holster/holsterin.ogg'
	var/sound_out = 'sound/weapons/holster/holsterout.ogg'
	flippable = 1
	w_class = ITEMSIZE_NORMAL

/obj/item/clothing/accessory/holster/Initialize()
	. = ..()
	AddComponent(/datum/component/base_name, name)

/obj/item/clothing/accessory/holster/proc/update_name(var/base_name = initial(name))
	SEND_SIGNAL(src, COMSIG_BASENAME_SETNAME, args)
	if(holstered)
		name = "occupied [base_name]"
	else
		name = "[base_name]"

/obj/item/clothing/accessory/holster/proc/holster(var/obj/item/I, var/mob/living/user)
	if(holstered && istype(user))
		to_chat(user, "<span class='warning'>There is already \a [holstered] holstered here!</span>")
		return

	if (!(I.slot_flags & SLOT_HOLSTER))
		to_chat(user, "<span class='warning'>[I] won't fit in [src]!</span>")
		return

	if(sound_in)
		playsound(get_turf(src), sound_in, 50)

	if(istype(user))
		user.stop_aiming(no_message=1)
	holstered = I
	user.drop_from_inventory(holstered,src)
	holstered.add_fingerprint(user)
	w_class = max(w_class, holstered.w_class)
	user.visible_message("<span class='notice'>[user] holsters \the [holstered].</span>", "<span class='notice'>You holster \the [holstered].</span>")
	update_name()

/obj/item/clothing/accessory/holster/proc/clear_holster()
	holstered = null
	update_name()

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		to_chat(user, "<span class='warning'>You need an empty hand to draw \the [holstered]!</span>")
	else if (use_check(user))
		to_chat(user, "<span class='warning'>You can't draw \the [holstered] in your current state!</span>")
	else
		var/sound_vol = 25
		if(user.a_intent == I_HURT)
			sound_vol = 50
			usr.visible_message(
				"<span class='danger'>[user] draws \the [holstered], ready to shoot!</span>",
				"<span class='warning'>You draw \the [holstered], ready to shoot!</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>[user] draws \the [holstered], pointing it at the ground.</span>",
				"<span class='notice'>You draw \the [holstered], pointing it at the ground.</span>"
				)

		if(sound_out)
			playsound(get_turf(src), sound_out, sound_vol)

		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		w_class = initial(w_class)
		clear_holster()

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	..(user)
	if (holstered)
		to_chat(user, "A [holstered] is holstered here.")
	else
		to_chat(user, "It is empty.")

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/accessory/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	//can't we just use src here?
	var/obj/item/clothing/accessory/holster/H = get_accessory(/obj/item/clothing/accessory/holster)
	if(!H && istype(src, /obj/item/clothing/suit/armor/tactical)) // This armor is a snowflake and has an integrated holster.
		var/obj/item/clothing/suit/armor/tactical/tacticool = src
		H = tacticool.holster

	if (!H)
		to_chat(usr, "<span class='warning'>Something is very wrong.</span>")

	if(!H.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, "<span class='warning'>You need your gun equiped to holster it.</span>")
			return
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/accessory/holster/armpit
	name = "black armpit holster"
	desc = "A worn-out handgun holster. Mostly seen in cheesy cop flicks, used to keep the actor's face in the shot."
	icon_state = "holster"

/obj/item/clothing/accessory/holster/waist
	name = "black waist holster"
	desc = "A handgun holster, made of expensive leather. Can possibly be concealed under a shirt, albeit a little archaic."
	icon_state = "holster_low"

/obj/item/clothing/accessory/holster/hip
	name = "black hip holster"
	desc = "<i>No one dared to ask his business, no one dared to make a slip. The stranger there among them had a big iron on his hip.</i>"
	icon_state = "holster_hip"

/obj/item/clothing/accessory/holster/thigh
	name = "black thigh holster"
	desc = "A drop leg holster made of a durable synthetic fiber."
	icon_state = "holster_thigh"
	sound_in = 'sound/weapons/holster/tactiholsterin.ogg'
	sound_out = 'sound/weapons/holster/tactiholsterout.ogg'

/obj/item/clothing/accessory/holster/armpit/brown
	name = "brown armpit holster"
	icon_state = "holster_brown"

/obj/item/clothing/accessory/holster/waist/brown
	name = "brown waist holster"
	icon_state = "holster_brown_low"

/obj/item/clothing/accessory/holster/hip/brown
	name = "brown hip holster"
	icon_state = "holster_brown_hip"

/obj/item/clothing/accessory/holster/thigh/brown
	name = "brown thigh holster"
	icon_state = "holster_brown_thigh"

