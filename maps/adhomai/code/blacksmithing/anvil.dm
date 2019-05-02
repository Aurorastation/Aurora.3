/obj/structure/anvil
	name = "anvil"
	desc = "A heavy anvil used to smith weapons and other objects."
	icon = 'icons/adhomai/blacksmith.dmi'
	icon_state = "anvil"
	anchored = TRUE
	density = TRUE
	light_color = LIGHT_COLOR_FIRE
	var/obj/item/mold/current_mold
	var/blacksmithing = FALSE

/obj/structure/anvil/Destroy()
	if(current_mold)
		QDEL_NULL(current_mold)

	return ..()

/obj/structure/anvil/update_icon()
	overlays.Cut()
	if(current_mold)
		add_overlay("anvil_mold")

/obj/structure/anvil/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(istype(W, /obj/item/mold))
		var/obj/item/mold/M = W
		if(current_mold)
			to_chat(user, "<span class='warning'>There is a mold on \the [src] already.</span>")
			return

		if(!M.filling)
			to_chat(user, "<span class='warning'>This mold is empty.</span>")
			return

		user.drop_from_inventory(M)
		current_mold = M
		M.forceMove(src)
		to_chat(user, "<span class='notice'>You place \the [M] on \the [src].</span>")
		update_icon()
		return

	if(istype(W, /obj/item/weapon/material/blacksmith_hammer))

		if(blacksmithing)
			return

		if(!current_mold)
			to_chat(user, "<span class='warning'>\The [W] has no mold on \the [src].</span>")
			return

		if(!current_mold.filling)
			to_chat(user, "<span class='warning'>\The [current_mold] is empty.</span>")
			return

		blacksmithing = TRUE
		user.visible_message("<span class='notice'>\The [user] hammers \the [src]!</span>")
		playsound(src.loc, 'maps/adhomai/sound/anvil.ogg', 50, 1, -3)
		if(do_after(user, 160, act_target = src))
			current_mold.create_result(get_turf(src))
			to_chat(user, "<span class='warning'>You finish your creation.</span>")
			current_mold.filling = null
			current_mold.update_icon()
			blacksmithing = FALSE
			return
		else
			blacksmithing = FALSE
			return

/obj/structure/anvil/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!ishuman(user))
		return
	if(blacksmithing)
		return
	if(!current_mold)
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")
		return

	current_mold.forceMove(get_turf(user))
	to_chat(user, "<span class='notice'>You remove \the [current_mold] from the top of \the [src].</span>")
	user.put_in_hands(current_mold)
	current_mold = null
	update_icon()