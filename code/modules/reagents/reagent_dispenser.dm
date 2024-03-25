/obj/structure/reagent_dispensers
	name = "strange dispenser"
	desc = "What the fuck is this?"
	desc_info = "You can right-click this and change the amount transferred per use."
	icon = 'icons/obj/reagent_dispensers.dmi'
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
		desc_info = ""

/obj/structure/reagent_dispensers/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	. += "<span class='notice'>It contains [reagents.total_volume] units of reagents.</span>"

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = tgui_input_list(usr, "Select the amount to transfer from this. ", "[src]", possible_transfer_amounts, amount_per_transfer_from_this)
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	reagents.splash_turf(get_turf(src), reagents.total_volume)
	qdel(src)

/obj/structure/reagent_dispensers/attackby(obj/item/attacking_item, mob/user)

	var/obj/item/reagent_containers/RG = attacking_item
	if (istype(RG) && RG.is_open_container())

		var/atype
		if(accept_any_reagent)
			atype = alert(user, "Do you want to fill or empty \the [RG] at \the [src]?", "Fill or Empty", "Fill", "Empty", "Cancel")
		else
			atype = alert(user, "Do you want to fill \the [RG] at \the [src]?", "Fill", "Fill", "Cancel")

		if(!user.Adjacent(src)) return
		if(RG.loc != user && !isrobot(user)) return

		switch(atype)
			if ("Fill")
				RG.standard_dispenser_refill(user,src)
				playsound(src.loc, 'sound/machines/reagent_dispense.ogg', 25, 1)
			if ("Empty")
				if(is_open_container())
					RG.standard_pour_into(user,src)
				else
					to_chat(user,"<span class='notice'>The inlet cap on \the [src] is wrenched on tight!</span>")
		return

	if (attacking_item.iswrench())
		if(use_check(user, USE_DISALLOW_SPECIALS))
			to_chat(user, SPAN_WARNING("A strange force prevents you from doing this.")) //there is no way to justify this icly
			return
		if(can_tamper && user.a_intent == I_HURT)
			user.visible_message("<span class='warning'>\The [user] wrenches \the [src]'s faucet [is_leaking ? "closed" : "open"].</span>",
									"<span class='warning'>You wrench \the [src]'s faucet [is_leaking ? "closed" : "open"]</span>")
			is_leaking = !is_leaking
			if (is_leaking)
				message_admins("[key_name_admin(user)] wrench opened \the [src] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking reagents. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] opened \the [src] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking reagents.",ckey=key_name(user))
				START_PROCESSING(SSprocessing,src)

		else if(accept_any_reagent)
			if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
				user.visible_message(SPAN_NOTICE("[user] wrenches the inlet cap on \the [src] shut."),
										SPAN_NOTICE("You wrench the inlet cap back on \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("[user] unwrenches the inlet cap from \the [src]."),
										SPAN_NOTICE("You unwrench the inlet cap from \the [src]."))
			atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
			return

/obj/structure/reagent_dispensers/process()

	if(!is_leaking || reagents.total_volume <= 0)
		STOP_PROCESSING(SSprocessing,src)
		return

	var/splash_amount = min(amount_per_transfer_from_this,60) //Hard limit of 60 per process
	reagents.trans_to_turf(get_turf(src),splash_amount)

//Fire extinguisher tank

/obj/structure/reagent_dispensers/extinguisher
	name = "extinguisher tank"
	desc = "A tank filled with extinguisher fluid."
	icon_state = "extinguisher_tank"
	amount_per_transfer_from_this = 30
	reagents_to_add = list(/singleton/reagent/toxin/fertilizer/monoammoniumphosphate = 1000)

// Tanks
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A tank filled with water."
	icon_state = "watertank"
	amount_per_transfer_from_this = 300
	reagents_to_add = list(/singleton/reagent/water = 1000)

/obj/structure/reagent_dispensers/lube
	name = "lube tank"
	desc = "A tank filled with a silly amount of lube."
	icon_state = "lubetank"
	amount_per_transfer_from_this = 30
	reagents_to_add = list(/singleton/reagent/lube = 1000)

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank filled with welding fuel."
	icon_state = "weldtank"
	accept_any_reagent = FALSE
	amount_per_transfer_from_this = 30
	var/defuse = 0
	var/armed = 0
	var/obj/item/device/assembly_holder/rig = null
	reagents_to_add = list(/singleton/reagent/fuel = 1000)

/obj/structure/reagent_dispensers/fueltank/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	if (is_leaking)
		. += "<span class='warning'>Fuel faucet is wrenched open, leaking the fuel!</span>"
	if(rig)
		. += "<span class='notice'>There is some kind of device rigged to the tank.</span>"

/obj/structure/reagent_dispensers/fueltank/attack_hand(mob/user)
	if (rig)
		user.visible_message("[user] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
		if(do_after(user, 20))
			user.visible_message("<span class='notice'>[user] detaches [rig] from \the [src].</span>", "<span class='notice'>You detach [rig] from \the [src]</span>")
			rig.forceMove(get_turf(user))
			rig = null
			overlays = new/list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/attacking_item, mob/user)
	src.add_fingerprint(user)
	if(istype(attacking_item, /obj/item/wirecutters/bomb) && rig)
		user.visible_message(SPAN_WARNING("\The [user] carefully removes \the [rig] from \the [src]."), \
							SPAN_NOTICE("You carefully remove \the [rig] from \the [src]."))
		rig.forceMove(get_turf(user))
		rig.detached()
		user.put_in_hands(rig)
		rig = null
		overlays = new/list()
	if (istype(attacking_item,/obj/item/device/assembly_holder))
		if (rig)
			to_chat(user, "<span class='warning'>There is another device in the way.</span>")
			return ..()
		user.visible_message("[user] begins rigging [attacking_item] to \the [src].", "You begin rigging [attacking_item] to \the [src]")
		if(do_after(user, 20))
			user.visible_message("<span class='notice'>[user] rigs [attacking_item] to \the [src].</span>", "<span class='notice'>You rig [attacking_item] to \the [src]</span>")

			var/obj/item/device/assembly_holder/H = attacking_item
			if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
				message_admins("[key_name_admin(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.",ckey=key_name(user))

			rig = attacking_item
			user.drop_from_inventory(attacking_item,src)
			var/mutable_appearance/MA = new(attacking_item)
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
			log_and_message_admins("shot a welding tank", Proj.firer)
			log_game("[key_name(Proj.firer)] shot fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]).",ckey=key_name(Proj.firer))

		if(!istype(Proj ,/obj/item/projectile/beam/laser_tag) && !istype(Proj ,/obj/item/projectile/beam/practice) && !istype(Proj ,/obj/item/projectile/kinetic))
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
	if (is_leaking)
		ex_act(2.0)
	else if (temperature > T0C+500)
		ex_act(2.0)
	return ..()

/obj/structure/reagent_dispensers/fueltank/tesla_act()
	..()
	ex_act(2.0)

//Wall Dispensers

/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Refill pepper spray canisters."
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	can_tamper = FALSE
	reagents_to_add = list(/singleton/reagent/capsaicin/condensed = 1000)

/obj/structure/reagent_dispensers/virusfood
	name = "virus food dispenser"
	desc = "A dispenser of virus food."
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0
	can_tamper = FALSE
	reagents_to_add = list(/singleton/reagent/nutriment/virusfood = 1000)

/obj/structure/reagent_dispensers/acid
	name = "sulphuric acid dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = 1
	density = 0
	can_tamper = FALSE
	reagents_to_add = list(/singleton/reagent/acid = 1000)

/obj/structure/reagent_dispensers/peppertank/luminol
	name = "luminol dispenser"
	desc = "A dispenser to refill luminol bottles."
	icon_state = "luminoltank"
	amount_per_transfer_from_this = 50
	reagents_to_add = list(/singleton/reagent/luminol = 1000)

/obj/structure/reagent_dispensers/peppertank/spacecleaner
	name = "cleaner dispenser"
	desc = "A wall-mounted dispenser filled with cleaner. Used to refill cleaner bottles and cleaner tanks."
	icon_state = "cleanertank"
	amount_per_transfer_from_this = 250
	reagents_to_add = list(/singleton/reagent/spacecleaner = 1000)

//Water Cooler

/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	capacity = 500
	can_tamper = FALSE
	reagents_to_add = list(/singleton/reagent/water = 500)
	var/cups = 12
	var/cup_type = /obj/item/reagent_containers/food/drinks/sillycup

/obj/structure/reagent_dispensers/water_cooler/attack_hand(var/mob/user)
	if(cups > 0)
		var/visible_messages = DispenserMessages(user)
		visible_message(SPAN_NOTICE(visible_messages[1]), SPAN_NOTICE(visible_messages[2]))
		var/cup = new cup_type(loc)
		user.put_in_active_hand(cup)
		cups--
	else
		to_chat(user, SPAN_WARNING(RejectionMessage(user)))

/obj/structure/reagent_dispensers/water_cooler/proc/DispenserMessages(var/mob/user)
	return list("\The [user] grabs a paper cup from \the [src].", "You grab a paper cup from \the [src]'s cup compartment.")

/obj/structure/reagent_dispensers/water_cooler/proc/RejectionMessage(var/mob/user)
	return "[src]'s cup dispenser is empty."

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.isscrewdriver())
		src.add_fingerprint(user)
		attacking_item.play_tool_sound(get_turf(src), 100)
		if(do_after(user, 20))
			if(!src) return
			switch (anchored)
				if (0)
					anchored = 1
					user.visible_message("\The [user] tightens the screws securing \the [src] to the floor.",
											"You tighten the screws securing \the [src] to the floor.")
				if (1)
					user.visible_message("\The [user] unfastens the screws securing \the [src] to the floor.",
											"You unfasten the screws securing \the [src] to the floor.")
					anchored = 0
		return
	else
		..()

//Beer Kegs

/obj/structure/reagent_dispensers/keg
	name = "keg"
	desc = "An empty keg."
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/keg/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = attacking_item
		if(!R.can_use(3)) // like a tripod
			to_chat(user, SPAN_NOTICE("You need three rods to make a still!"))
			return
		if(do_after(user, 20))
			if (QDELETED(src))
				return
			R.use(3)
			new /obj/structure/distillery(src.loc)
			if(reagents)
				to_chat(user, SPAN_NOTICE("As you prop the still up on the rods, the reagents inside are spilled. However, you successfully make the still."))
				reagents.trans_to_turf(get_turf(src), reagents.total_volume)
			else
				to_chat(user, SPAN_NOTICE("You successfully build a still."))
			qdel(src)
		return
	. = ..()

/obj/structure/reagent_dispensers/keg/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	reagents_to_add = list(/singleton/reagent/alcohol/beer = 1000)

/obj/structure/reagent_dispensers/keg/beerkeg/rice
	reagents_to_add = list(/singleton/reagent/alcohol/rice_beer = 1000)

/obj/structure/reagent_dispensers/keg/xuizikeg
	name = "xuizi juice keg"
	desc = "A keg full of Xuizi juice, blended flower buds from the Moghean Xuizi cactus. The export stamp of the Arizi Guild is imprinted on the side."
	icon_state = "keg_xuizi"
	reagents_to_add = list(/singleton/reagent/alcohol/butanol/xuizijuice = 1000)

/obj/structure/reagent_dispensers/keg/mead
	name = "mead barrel"
	desc = "A wooden mead barrel."
	icon_state = "woodkeg"
	reagents_to_add = list(/singleton/reagent/alcohol/messa_mead = 1000)

/obj/structure/reagent_dispensers/keg/sake
	name = "sake barrel"
	desc = "A wooden sake barrel."
	icon_state = "woodkeg"
	reagents_to_add = list(/singleton/reagent/alcohol/sake = 1000)

//Cooking oil tank
/obj/structure/reagent_dispensers/cookingoil
	name = "cooking oil tank"
	desc = "A fifty-litre tank of commercial-grade corn oil, intended for use in large scale deep fryers. Store in a cool, dark place"
	icon_state = "oiltank"
	amount_per_transfer_from_this = 120
	capacity = 5000
	reagents_to_add = list(/singleton/reagent/nutriment/triglyceride/oil/corn = 5000)

/obj/structure/reagent_dispensers/cookingoil/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		ex_act(2.0)

//Coolant tank

/obj/structure/reagent_dispensers/coolanttank
	name = "coolant tank"
	desc = "A tank of industrial coolant"
	icon_state = "coolanttank"
	amount_per_transfer_from_this = 10
	reagents_to_add = list(/singleton/reagent/coolant = 1000)

/obj/structure/reagent_dispensers/coolanttank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if (Proj.damage_type != DAMAGE_PAIN)
			explode()

/obj/structure/reagent_dispensers/coolanttank/ex_act(var/severity = 2.0)
	explode()

/obj/structure/reagent_dispensers/coolanttank/proc/explode()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread
	//S.attach(src)
	S.set_up(5, 0, src.loc)

	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	INVOKE_ASYNC(S, TYPE_PROC_REF(/datum/effect/effect/system/smoke_spread, start))

	if(src.loc)
		var/datum/gas_mixture/env = src.loc.return_air()
		if(env)
			if (reagents.total_volume > 750)
				env.temperature = 0
			else if (reagents.total_volume > 500)
				env.temperature -= 100

	QDEL_IN(src, 10)

//acid barrel

/obj/structure/reagent_dispensers/acid_barrel
	name = "chemical barrel"
	desc = "A metal barrel containing some unknown chemical."
	icon_state = "acid_barrel"
	amount_per_transfer_from_this = 300

/obj/structure/reagent_dispensers/radioactive_waste
	name = "radioactive waste barrel"
	desc = "A metal barrel containing radioactive waste."
	icon_state = "chemical_barrel"
	amount_per_transfer_from_this = 300
	reagents_to_add = list(/singleton/reagent/radioactive_waste = 1000)
