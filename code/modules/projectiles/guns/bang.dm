#define FRAME_ANIM_TIME 3
ABSTRACT_TYPE(/obj/item/gun/bang)
	name = "flag gun"
	desc = "This is a gun. Neat!"
	icon = 'icons/obj/guns/faction/zavodskoi_interstellar/revolver.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	fire_sound = 'sound/machines/crate_close.ogg'
	suppressed_sound = 'sound/machines/crate_close.ogg'
	var/empty_sound_flag = SFX_PLASTIC_DRY_FIRE
	needspin = FALSE
	var/fakecaliber = "357"
	var/fired_gun = FALSE
	var/pixel_offset_x = 28
	var/pixel_offset_y = 12
	/// Caches offset matrix for use later
	VAR_PRIVATE/matrix/TM
	var/obj/effect/overlay/vis/bang_flag
	///Pixel offset for the suppressor overlay on the x axis.
	var/suppressor_x_offset
	///Pixel offset for the suppressor overlay on the y axis.
	var/suppressor_y_offset

/obj/item/gun/bang/update_icon()
	..()
	if(suppressed)
		var/mutable_appearance/MA = mutable_appearance('icons/obj/guns/attachments/suppressor.dmi', "suppressor")
		if(suppressor_x_offset)
			MA.pixel_x = suppressor_x_offset
		if(suppressor_y_offset)
			MA.pixel_y = suppressor_y_offset
		underlays += MA

/obj/item/gun/bang/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!fired_gun)
		. += "This is a ballistic weapon. It fires [fakecaliber] ammunition. To reload most guns, click the gun with an empty hand to remove any spent casings or magazines, and then insert new ones."
	else
		. += "This is a fake weapon. It won't do you much good. Click to retract the flag."

/obj/item/gun/bang/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(fired_gun)
		. += SPAN_NOTICE("A flag is sticking out of the barrel!")

/obj/item/gun/bang/Initialize()
	. = ..()
	TM = matrix()
	TM.Translate(pixel_offset_x, pixel_offset_y)

// Doesn't send a signal
/obj/item/gun/bang/proc/handle_click_empty_flag(mob/user)
	playsound(loc, empty_sound_flag, 30, TRUE)
	balloon_alert_to_viewers("*click*")

/obj/item/gun/bang/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0, accuracy_decrease=0, is_offhand=0)
	if(!fire_checks(target,user,clickparams,pointblank,reflex))
		return FALSE

	if(fired_gun)
		handle_click_empty_flag(user)
		return FALSE

	balloon_alert_to_viewers("*pop*")

	if (user)
		user.visible_message(SPAN_NOTICE("A flag pops out of the barrel of \the [src.name]'s barrel!"), SPAN_WARNING("A flag pops out of the barrel!"))
	else
		visible_message(SPAN_NOTICE("A flag pops out of the barrel of \the [src.name]'s barrel!"))

	appearance_flags &= KEEP_TOGETHER
	play_fire_sound()
	add_vis_contents(return_flag())
	fired_gun = TRUE

	addtimer(CALLBACK(src, PROC_REF(play_sad_sound)), 4) //4 deciseconds

/obj/item/gun/bang/attack_self(mob/user)
	. = ..()
	if(fired_gun)
		user.visible_message(SPAN_NOTICE("\The [user] pushes the flag back into the barrel of \the [src.name]."),
								SPAN_NOTICE("You push the flag back into the barrel of \the [src.name]."))
		bang_flag.icon_state = "bang_flag_rew"
		addtimer(CALLBACK(src, PROC_REF(remove_flag)), FRAME_ANIM_TIME)
		playsound(src.loc, 'sound/weapons/TargetOff.ogg', 50,1)
		return TRUE

/obj/item/gun/bang/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(astype(attacking_item, /obj/item/suppressor))
		if(!can_suppress)
			balloon_alert(user, "doesn't fit!")
			return

		if(suppressed)
			balloon_alert(user, "already has a suppressor!")
			return

		if(user.l_hand != attacking_item && user.r_hand != attacking_item)
			balloon_alert(user, "not in hand!")
			return

		user.drop_from_inventory(suppressor, src)
		balloon_alert(user, "[attacking_item.name] attached")
		install_suppressor(attacking_item)
		return

/obj/item/gun/bang/proc/return_flag()
	PRIVATE_PROC(TRUE)
	bang_flag = new(src)
	bang_flag.icon = 'icons/obj/bang_flag.dmi'
	bang_flag.icon_state = "bang_flag"
	bang_flag.layer = FLOAT_LAYER
	bang_flag.plane = FLOAT_PLANE
	bang_flag.transform = TM
	return bang_flag

/obj/item/gun/bang/proc/remove_flag()
	if(!(initial(appearance_flags) & KEEP_TOGETHER))
		appearance_flags &= ~KEEP_TOGETHER
	remove_vis_contents(bang_flag)
	QDEL_NULL(bang_flag)
	fired_gun = FALSE

/obj/item/gun/bang/proc/play_sad_sound()
	PRIVATE_PROC(TRUE)
	playsound(src, 'sound/misc/sadtrombone.ogg', 20, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)


//This stuff only exists to avoid suppressors from revealing a fake gun. Eventually, we should add a base-level attachments system to replace this mess
///Installs a new suppressor, assumes that the suppressor is already in the contents of src
/obj/item/gun/bang/proc/install_suppressor(obj/item/suppressor/S)
	suppressed = TRUE
	w_class += S.w_class //Add our weight class to the item's weight class
	suppressor = S
	update_icon()

/obj/item/gun/bang/clear_suppressor()
	if(!can_unsuppress)
		return
	if(istype(suppressor))
		w_class -= suppressor.w_class
	return ..()

#undef FRAME_ANIM_TIME
