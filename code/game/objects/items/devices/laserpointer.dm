

/obj/item/device/laser_pointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	icon = 'icons/obj/device.dmi'
	icon_state = "pointer"
	item_state = "pen"
	var/pointer_icon_state
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_TINY
	var/turf/pointer_loc
	var/obj/item/stock_parts/micro_laser/diode //cant use the laser without it




/obj/item/device/laser_pointer/red
	pointer_icon_state = "red_laser"
/obj/item/device/laser_pointer/green
	pointer_icon_state = "green_laser"
/obj/item/device/laser_pointer/blue
	pointer_icon_state = "blue_laser"
/obj/item/device/laser_pointer/purple
	pointer_icon_state = "purple_laser"


/obj/item/device/laser_pointer/Initialize()
	. = ..()
	diode = new(src)
	icon_state = "pointer"
	if(!pointer_icon_state)
		pointer_icon_state = pick("red_laser","green_laser","blue_laser","purple_laser")

/obj/item/device/laser_pointer/upgraded/Initialize()
	. = ..()
	diode = new /obj/item/stock_parts/micro_laser/ultra



/obj/item/device/laser_pointer/attack(mob/living/M, mob/user)
	laser_act(M, user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/item/device/laser_pointer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/micro_laser))
		if(!diode)
			user.drop_item()
			W.forceMove(src)
			diode = W
			to_chat(user, "<span class='notice'>You install a [diode.name] in [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] already has a laser diode.</span>")
		return TRUE

	else if(W.isscrewdriver())
		if(diode)
			to_chat(user, "<span class='notice'>You remove the [diode.name] from the [src].</span>")
			diode.forceMove(get_turf(user))
			diode = null
		return TRUE

/obj/item/device/laser_pointer/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)	//we're placing the object on a table or in backpack
		return
	laser_act(target, user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/item/device/laser_pointer/proc/laser_act(var/atom/target, var/mob/living/user)
	if( !(user in (viewers(7,target))) )
		return
	if (!diode)
		to_chat(user, "<span class='notice'>You point \the [src] at \the [target], but nothing happens!</span>")
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	add_fingerprint(user)


	var/selfmsg
	var/othermsg
	var/turf/targloc = get_turf(target)

	if(istype(target, /obj/machinery/camera))
		var/obj/machinery/camera/C = target

		if(prob(25))
			C.emp_act(28)
			selfmsg = "<span class='notice'>You hit the lens of \the [C] with \the [src], temporarily disabling the camera!</span>"

			admin_attack_log(user, src,"hits the  camera with a laser pointer",  "EMPd a camera with a laser pointer")

		else
			selfmsg = "<span class='notice'>You fail to hit the lens of \the [C] with \the [src].</span>"
		othermsg = "<b>[user]</b> shines \the [src] at \the [C]."

	if(iscarbon(target))
		if(user.zone_sel.selecting == BP_EYES)
			var/mob/living/carbon/C = target
			if(prob(30) && C.flash_act())
				selfmsg = "<span class='notice'>You blind \the [C] with \the [src].</span>"
				othermsg = "<b>[user]</b> shines \the [src] at \the [C]'s eyes'."
				C.eye_blind = 3
			else
				selfmsg = "<span class='notice'>You fail to blind \the [C] with \the [src].</span>"
				othermsg = "<b>[user]</b> fails to blind \the [C] with \the [src]."

	//laser pointer image
	icon_state = "pointer_[pointer_icon_state]"
	var/list/showto = list()
	for(var/mob/M in range(7,targloc))
		if(M.client)
			showto += M.client
	var/image/I = image('icons/obj/projectiles.dmi',targloc,pointer_icon_state,10)
	I.pixel_x = target.pixel_x + rand(-5,5)
	I.pixel_y = target.pixel_y + rand(-5,5)

	if(selfmsg)
		user.visible_message(othermsg, selfmsg)
	else
		user.visible_message("<b>[user]</b> points \the [src] at \the [target].", "<span class='notice'>You point \the [src] at \the [target].</span>")


	flick_overlay(I, showto, 15)
	icon_state = "pointer"

/obj/item/device/laser_pointer/Destroy()
	if (diode)
		QDEL_NULL(diode)

	. = ..()
