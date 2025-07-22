/obj/item/gun/bang
	name = "some shitty-ass gun"
	desc = "This is a gun. Neat!"
	icon = 'icons/obj/guns/revolver.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	fire_sound = 'sound/misc/sadtrombone.ogg'
	needspin = FALSE
	var/fakecaliber = "357"
	var/image/bang_flag
	var/fired_gun = 0
	var/pixel_offset_x = -2
	var/pixel_offset_y = 13

/obj/item/gun/bang/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This is a ballistic weapon. It fires [fakecaliber] ammunition. To reload most guns, click the gun with an empty hand to remove any spent casings or magazines, and then insert new ones."

/obj/item/gun/bang/Initialize()
	. = ..()
	bang_flag = image('icons/obj/bang_flag.dmi', "bang_flag")
	bang_flag.pixel_x = pixel_offset_x
	bang_flag.pixel_y = pixel_offset_y

/obj/item/gun/bang/handle_click_empty(mob/user)
	if (user)
		to_chat(user, SPAN_DANGER("The flag is already out!"))

/obj/item/gun/bang/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return

	if(fired_gun)
		handle_click_empty(user)
		return

	add_fingerprint(user)

	if (user)
		user.visible_message(SPAN_DANGER("A flag pops out of the barrel!"))
	else
		src.visible_message(SPAN_DANGER("A flag pops out of the barrel of \the [src.name]'s barrel!"))
	playsound(src, fire_sound, 20, 1)
	src.AddOverlays(bang_flag)
	fired_gun = 1

/obj/item/gun/bang/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src && fired_gun)
		src.CutOverlays(bang_flag)
		user.visible_message(SPAN_NOTICE("\The [user] pushes the flag back into the barrel of \the [src.name]."),
								SPAN_NOTICE("You push the flag back into the barrel of \the [src.name]."))

		playsound(src.loc, 'sound/weapons/TargetOff.ogg', 50,1)
		fired_gun = 0
	else
		return ..()
