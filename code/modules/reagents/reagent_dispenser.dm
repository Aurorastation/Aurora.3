

/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)
	var/capacity = 1000
	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

	New()
		var/datum/reagents/R = new/datum/reagents(capacity)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
		..()

	examine(mob/user)
		if(!..(user, 2))
			return
		user << "<span class='notice'>It contains:</span>"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				user << "<span class='notice'>[R.volume] units of [R.name]</span>"
		else
			user << "<span class='notice'>Nothing.</span>"

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set category = "Object"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					new /obj/effect/effect/water(src.loc)
					qdel(src)
					return
			if(3.0)
				if (prob(5))
					new /obj/effect/effect/water(src.loc)
					qdel(src)
					return
			else
		return







//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A tank filled with water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",capacity)

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank filled with welding fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/defuse = 0
	var/armed = 0
	var/obj/item/device/assembly_holder/rig = null
	New()
		..()
		reagents.add_reagent("fuel",capacity)

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	if(!..(user, 2))
		return
	if (modded)
		user << "<span class='warning'>Fuel faucet is wrenched open, leaking the fuel!</span>"
	if(rig)
		user << "<span class='notice'>There is some kind of device rigged to the tank.</span>"

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if (rig)
		usr.visible_message("[usr] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
		if(do_after(usr, 20))
			usr.visible_message("<span class='notice'>[usr] detaches [rig] from \the [src].</span>", "<span class='notice'>You detach [rig] from \the [src]</span>")
			rig.loc = get_turf(usr)
			rig = null
			overlays = new/list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (iswrench(W))
		user.visible_message("[user] wrenches [src]'s faucet [modded ? "closed" : "open"].", \
			"You wrench [src]'s faucet [modded ? "closed" : "open"]")
		modded = modded ? 0 : 1
		if (modded)
			message_admins("[key_name_admin(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
			log_game("[key_name(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel.",ckey=key_name(user))
			leak_fuel(amount_per_transfer_from_this)
	if (istype(W,/obj/item/device/assembly_holder))
		if (rig)
			user << "<span class='warning'>There is another device in the way.</span>"
			return ..()
		user.visible_message("[user] begins rigging [W] to \the [src].", "You begin rigging [W] to \the [src]")
		if(do_after(user, 20))
			user.visible_message("<span class='notice'>[user] rigs [W] to \the [src].</span>", "<span class='notice'>You rig [W] to \the [src]</span>")

			var/obj/item/device/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
				message_admins("[key_name_admin(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.",ckey=key_name(user))

			rig = W
			user.drop_item()
			W.loc = src

			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			overlays += test

	return ..()

/obj/structure/reagent_dispensers/fueltank/attack_ghost(mob/user as mob)
	if(user.client && user.client.inquisitive_ghost)
		examine()
	if(!user.client.holder)
		return
	if(!src.defuse && ((user.client.holder.rights & R_ADMIN) || (user.client.holder.rights & R_MOD)))
		src.defuse = 1
		message_admins("[key_name_admin(user)] <font color=#00FF00>defused</font> fueltank at ([loc.x],[loc.y],[loc.z]).")
	else
		if(!src.armed && ((user.client.holder.rights & R_ADMIN) || (user.client.holder.rights & R_MOD)))
			src.defuse = 0
			message_admins("[key_name_admin(user)] <font color=#FF0000>reset</font> fuse on fueltank at ([loc.x],[loc.y],[loc.z]).")

/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			message_admins("[key_name_admin(Proj.firer)] shot fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>).")
			log_game("[key_name(Proj.firer)] shot fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]).",ckey=key_name(Proj.firer))

		if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/ex_act()
	explode()

/obj/structure/reagent_dispensers/fueltank/proc/explode()
	if (reagents.total_volume > 500)
		explosion(src.loc,1,2,4)
	else if (reagents.total_volume > 100)
		explosion(src.loc,0,1,3)
	else if (reagents.total_volume > 50)
		explosion(src.loc,-1,1,2)
	if(src)
		qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, temperature, volume)
	if (modded)
		explode()
	else if (temperature > T0C+500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/tesla_act()
	..()
	explode()

/obj/structure/reagent_dispensers/fueltank/Move()
	if (..() && modded)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent("fuel",amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	New()
		..()
		reagents.add_reagent("condensedcapsaicin",capacity)


/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	New()
		..()
		reagents.add_reagent("water",500)

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (iswrench(W))
		src.add_fingerprint(user)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		if(do_after(user, 20))
			if(!src) return
			switch (anchored)
				if (0)
					anchored = 1
					user.visible_message("\The [user] tightens the bolts securing \the [src] to the floor.", "You tighten the bolts securing \the [src] to the floor.")
				if (1)
					user.visible_message("\The [user] unfastens the bolts securing \the [src] to the floor.", "You unfasten the bolts securing \the [src] to the floor.")
					anchored = 0
		return


/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("beer",capacity)

/obj/structure/reagent_dispensers/xuizikeg
	name = "xuizi juice keg"
	desc = "A keg full of Xuizi juice, blended flower buds from the Moghean Xuizi cactus. The export stamp of the Arizi Guild is imprinted on the side."
	icon = 'icons/obj/objects.dmi'
	icon_state = "keg_xuizi"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("xuizijuice",capacity)

/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0

	New()
		..()
		reagents.add_reagent("virusfood", capacity)

/obj/structure/reagent_dispensers/acid
	name = "Sulphuric Acid Dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0

	New()
		..()
		reagents.add_reagent("sacid", capacity)


//Cooking oil refill tank
/obj/structure/reagent_dispensers/cookingoil
	name = "cooking oil tank"
	desc = "A fifty-litre tank of commercial-grade corn oil, intended for use in large scale deep fryers. Store in a cool, dark place"
	icon = 'icons/obj/objects.dmi'
	icon_state = "oiltank"
	amount_per_transfer_from_this = 120
	capacity = 5000

/obj/structure/reagent_dispensers/cookingoil/Initialize()
	. = ..()
	reagents.add_reagent("cornoil",capacity)

/obj/structure/reagent_dispensers/cookingoil/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		explode()

/obj/structure/reagent_dispensers/cookingoil/ex_act()
	explode()

/obj/structure/reagent_dispensers/cookingoil/proc/explode()
	reagents.splash_area(get_turf(src), 3)
	visible_message(span("danger", "The [src] bursts open, spreading oil all over the area."))
	qdel(src)
