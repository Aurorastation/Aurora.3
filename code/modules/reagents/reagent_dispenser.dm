/obj/structure/reagent_dispensers
	name = "Strange dispenser"
	desc = "What the fuck is this?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0
	var/accept_any_reagent = TRUE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(5,10,15,25,30,50,60,100,120,250,300)
	var/capacity = 1000
	var/can_tamper = TRUE
	var/is_leaking = FALSE

/obj/structure/reagent_dispensers/Initialize()
	. = ..()
	create_reagents(capacity)
	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT

/obj/structure/reagent_dispensers/examine(mob/user)
	if(!..(user, 2))
		return
	to_chat(user,"<span class='notice'>It contains [reagents.total_volume] units of reagents.</span>")

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	reagents.splash_turf(get_turf(src), reagents.total_volume)
	visible_message(span("danger", "\The [src] bursts open, spreading reagents all over the area!"))
	qdel(src)

/obj/structure/reagent_dispensers/attackby(obj/item/O as obj, mob/user as mob)

	var/obj/item/weapon/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())

		var/atype
		if(accept_any_reagent)
			atype = alert(user, "Do you want to fill or empty \the [RG] at \the [src]?", "Fill or Empty", "Fill", "Empty", "Cancel")
		else
			atype = alert(user, "Do you want to fill \the [RG] at \the [src]?", "Fill", "Fill", "Cancel")

		if(!user.Adjacent(src)) return
		if(RG.loc != user) return

		switch(atype)
			if ("Fill")
				RG.standard_dispenser_refill(user,src)
			if ("Empty")
				if(is_open_container())
					RG.standard_pour_into(user,src)
				else
					to_chat(user,"<span class='notice'>The top cap is wrenched on tight!</span>")
		return

	if (iswrench(O))
		if(can_tamper && user.a_intent == I_HURT)
			user.visible_message("<span class='warning'>\The [user] wrenches \the [src]'s faucet [is_leaking ? "closed" : "open"].</span>","<span class='warning'>You wrench \the [src]'s faucet [is_leaking ? "closed" : "open"]</span>")
			is_leaking = !is_leaking
			if (is_leaking)
				message_admins("[key_name_admin(user)] wrench opened \the [src] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking reagents. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] opened \the [src] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking reagents.",ckey=key_name(user))
				START_PROCESSING(SSprocessing,src)

		else if(accept_any_reagent)
			var/is_closed = flags & OPENCONTAINER
			var/verb01 = is_closed ? "unwrenches" : "wrenches"
			var/verb02 = (is_closed ? "open" : "shut")
			user.visible_message("<span class='notice'>[user] [verb01] the top cap [verb02] from \the [src].</span>", "<span class='notice'>You [verb01] the top cap [verb02] from \the [src].</span>")
			flags ^= OPENCONTAINER
			return

/obj/structure/reagent_dispensers/process()

	if(!is_leaking || reagents.total_volume <= 0)
		STOP_PROCESSING(SSprocessing,src)
		return

	var/splash_amount = min(amount_per_transfer_from_this,60) //Hard limit of 60 per process
	reagents.trans_to_turf(get_turf(src),splash_amount)

//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A tank filled with water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/watertank/Initialize()
	. = ..()
	reagents.add_reagent("water",capacity)

/obj/structure/reagent_dispensers/extinguisher
	name = "extinguisher tank"
	desc = "A tank filled with extinguisher fluid."
	icon = 'icons/obj/objects.dmi'
	icon_state = "extinguisher_tank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/extinguisher/Initialize()
	. = ..()
	reagents.add_reagent("monoammoniumphosphate",capacity)

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank filled with welding fuel."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	accept_any_reagent = FALSE
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/defuse = 0
	var/armed = 0
	var/obj/item/device/assembly_holder/rig = null

/obj/structure/reagent_dispensers/fueltank/Initialize()
	. = ..()
	reagents.add_reagent("fuel",capacity)

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	if(!..(user, 2))
		return
	if (modded)
		user << "<span class='warning'>Fuel faucet is wrenched open, leaking the fuel!</span>"
	if(rig)
		user << "<span class='notice'>There is some kind of device rigged to the tank.</span>"

/obj/structure/reagent_dispensers/fueltank/attack_hand(mob/user)
	if (rig)
		user.visible_message("[user] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
		if(do_after(user, 20))
			user.visible_message("<span class='notice'>[user] detaches [rig] from \the [src].</span>", "<span class='notice'>You detach [rig] from \the [src]</span>")
			rig.forceMove(get_turf(user))
			rig = null
			overlays = new/list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
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
			user.drop_from_inventory(W,src)
			var/mutable_appearance/MA = new(W)
			MA.pixel_x += 1
			MA.pixel_y += 6
			add_overlay(MA)

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
			ex_act(2.0)

/obj/structure/reagent_dispensers/fueltank/ex_act(var/severity = 3.0)

	if (QDELETED(src))
		return

	if (reagents.total_volume > 500)
		explosion(src.loc,1,2,4)
	else if (reagents.total_volume > 100)
		explosion(src.loc,0,1,3)
	else if (reagents.total_volume > 50)
		explosion(src.loc,-1,1,2)

	..()

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, temperature, volume)
	if (modded)
		ex_act(2.0)
	else if (temperature > T0C+500)
		ex_act(2.0)
	return ..()

/obj/structure/reagent_dispensers/fueltank/tesla_act()
	..()
	ex_act(2.0)

/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	can_tamper = FALSE

/obj/structure/reagent_dispensers/peppertank/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin",capacity)

/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	capacity = 500
	can_tamper = FALSE

/obj/structure/reagent_dispensers/water_cooler/Initialize()
	. = ..()
	reagents.add_reagent("water",capacity)

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (isscrewdriver(W))
		src.add_fingerprint(user)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		if(do_after(user, 20))
			if(!src) return
			switch (anchored)
				if (0)
					anchored = 1
					user.visible_message("\The [user] tightens the screws securing \the [src] to the floor.", "You tighten the screws securing \the [src] to the floor.")
				if (1)
					user.visible_message("\The [user] unfastens the screws securing \the [src] to the floor.", "You unfasten the screws securing \the [src] to the floor.")
					anchored = 0
		return

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/beerkeg/Initialize()
	. = ..()
	reagents.add_reagent("beer",capacity)

/obj/structure/reagent_dispensers/xuizikeg
	name = "xuizi juice keg"
	desc = "A keg full of Xuizi juice, blended flower buds from the Moghean Xuizi cactus. The export stamp of the Arizi Guild is imprinted on the side."
	icon = 'icons/obj/objects.dmi'
	icon_state = "keg_xuizi"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/xuizikeg/Initialize()
	. = ..()
	reagents.add_reagent("xuizijuice",capacity)

/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0
	can_tamper = FALSE

/obj/structure/reagent_dispensers/virusfood/Initialize()
	. = ..()
	reagents.add_reagent("virusfood", capacity)

/obj/structure/reagent_dispensers/acid
	name = "Sulphuric Acid Dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0
	can_tamper = FALSE

/obj/structure/reagent_dispensers/acid/Initialize()
	. = ..()
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
		ex_act(2.0)
