	name = "some shitty-ass gun"
	desc = "This is a gun. Neat!"
	icon_state = "revolver"
	item_state = "revolver"
	fire_sound = 'sound/misc/sadtrombone.ogg'
	var/image/bang_flag
	var/fired_gun = 0
	var/pixel_offset_x = -2
	var/pixel_offset_y = 13


	. = ..()
	bang_flag = image('icons/obj/bang_flag.dmi', "bang_flag")
	bang_flag.pixel_x = pixel_offset_x
	bang_flag.pixel_y = pixel_offset_y

	if (user)
		user.visible_message("<span class='danger'>The flag is already out!</span>")

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

	if(user.get_inactive_hand() == src && fired_gun)
		src.cut_overlay(bang_flag)
		user.visible_message("<span class='notice'>You push the flag back into the barrel of \the [src.name].</span>")
		fired_gun = 0
	else
		return ..()