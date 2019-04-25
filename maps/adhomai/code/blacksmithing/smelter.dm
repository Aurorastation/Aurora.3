/obj/structure/smelter
	name = "smelter"
	desc = "A large furnace used to melt metal."
	icon = 'icons/adhomai/blacksmith.dmi'
	icon_state = "smelter"
	anchored = TRUE
	density = TRUE
	light_color = LIGHT_COLOR_FIRE
	var/fuel = 5
	var/max_fuel = 5
	var/obj/item/mold/current_mold
	var/smelting = FALSE

/obj/structure/smelter/Destroy()
	if(current_mold)
		QDEL_NULL(current_mold)

	return ..()

/obj/structure/smelter/examine(mob/user)
	..(user)
	if(smelting)
		to_chat(user, "It is smelting something.")
	if(current_mold)
		to_chat(user, "\The [current_mold] is inside of it.")

/obj/structure/smelter/Initialize()
	. = ..()
	fuel = rand(3, 5)
	update_flame()

/obj/structure/smelter/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/mold))
		var/obj/item/mold/M = W
		if(!fuel)
			to_chat(user, "<span class='warning'>\The [src] has no fuel left.</span>")
			return
		if(current_mold)
			to_chat(user, "<span class='warning'>There is a mold inside \the [src] already.</span>")
			return
		if(M.filling)
			to_chat(user, "<span class='warning'>This mold is already full.</span>")
			return

		user.drop_from_inventory(M)
		current_mold = M
		M.forceMove(src)
		to_chat(user, "<span class='notice'>You add \the [M] to \the [src].</span>")
		return


	if(istype(W,/obj/item/weapon/ore/coal) && (fuel < max_fuel))
		fuel = min(fuel + 1, max_fuel)
		to_chat(user, "<span class='notice'>You fuel \the [src] with \the [W].</span>")
		qdel(W)
		return

	if(istype(W,/obj/item/stack/material))

		if(smelting)
			to_chat(user, "<span class='warning'>\The [src] is already smelting something.</span>")
			return

		if(!fuel)
			to_chat(user, "<span class='warning'>\The [src] has no fuel left.</span>")
			return

		if(!current_mold)
			to_chat(user, "<span class='warning'>\The [src] has no mold inside of it.</span>")
			return

		var/obj/item/stack/material/I = W

		if(I.amount < current_mold.needed_ammount)
			to_chat(user, "<span class='warning'>You need more materials to fill this mold.</span>")
			return

		if(!(I.material.name in current_mold.allowed_materials))
			to_chat(user, "<span class='warning'>This material is not suitable to the smelter.</span>")
			return

		I.use(current_mold.needed_ammount)
		fuel--
		to_chat(user, "<span class='notice'>You add \the [I] to \the [src].</span>")
		smelting = TRUE
		update_flame()
		addtimer(CALLBACK(src, .proc/smelt, current_mold, I.material), 3 MINUTES)
		return

	if (istype(W, /obj/item/weapon/ore) && (!istype(W, /obj/item/weapon/ore/coal)))
		var/obj/item/weapon/ore/I = W

		if(smelting)
			to_chat(user, "<span class='warning'>\The [src] is already smelting something.</span>")
			return

		if(!fuel)
			to_chat(user, "<span class='warning'>\The [src] has no fuel left.</span>")
			return

		if(!current_mold)
			to_chat(user, "<span class='warning'>\The [src] has no mold inside of it.</span>")
			return

		if(!istype(current_mold,/obj/item/mold/ingot))
			return

		fuel--
		to_chat(user, "<span class='notice'>You add \the [I] to \the [src].</span>")
		smelting = TRUE
		update_flame()
		addtimer(CALLBACK(src, .proc/smelt, current_mold, I.material), 1 MINUTES)
		qdel(W)

/obj/structure/smelter/proc/smelt(var/obj/item/mold/target_mold, var/target_material)
	if(!target_mold)
		return

	if(!target_material)
		return

	if(!current_mold)
		return

	if(target_mold != current_mold)
		return

	smelting = FALSE
	update_flame()
	target_mold.filling = target_material
	target_mold.update_icon()

/obj/structure/smelter/proc/update_flame()
	if(smelting)
		set_light(7)
	else
		set_light(fuel)

/obj/structure/smelter/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!ishuman(user))
		return
	if(smelting)
		to_chat(user, "<span class='warning'>\The [src] is still smelting.</span>")
		return
	if(!current_mold)
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")
		return

	current_mold.forceMove(get_turf(user))
	to_chat(user, "<span class='notice'>You remove \the [current_mold] from inside \the [src].</span>")
	user.put_in_hands(current_mold)
	current_mold = null