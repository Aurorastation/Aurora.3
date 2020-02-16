/obj/item/gun/bang
	name = "some shitty-ass gun"
	desc = "This is a gun. Neat!"
	icon_state = "revolver"
	item_state = "revolver"
	fire_sound = 'sound/misc/sadtrombone.ogg'
	needspin = FALSE
	var/image/bang_flag
	var/fired_gun = 0
	var/pixel_offset_x = -2
	var/pixel_offset_y = 13


/obj/item/gun/bang/Initialize()
	. = ..()
	bang_flag = image('icons/obj/bang_flag.dmi', "bang_flag")
	bang_flag.pixel_x = pixel_offset_x
	bang_flag.pixel_y = pixel_offset_y

/obj/item/gun/bang/handle_click_empty(mob/user)
	if (user)
		to_chat(user, "<span class='danger'>The flag is already out!</span>")

/obj/item/gun/bang/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return

	if(fired_gun)
		handle_click_empty(user)
		return

	add_fingerprint(user)

	if (user)
		user.visible_message("<span class='danger'>A flag pops out of the barrel!</span>")
	else
		src.visible_message("<span class='danger'>A flag pops out of the barrel of \the [src.name]'s barrel!</span>")
	playsound(src, fire_sound, 20, 1)
	src.add_overlay(bang_flag)
	fired_gun = 1

/obj/item/gun/bang/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src && fired_gun)
		src.cut_overlay(bang_flag)
		user.visible_message("<span class='notice'>\The [user] pushes the flag back into the barrel of \the [src.name].</span>", "<span class='notice'>You push the flag back into the barrel of \the [src.name].</span>")
		playsound(src.loc, 'sound/weapons/TargetOff.ogg', 50,1)
		fired_gun = 0
	else
		return ..()