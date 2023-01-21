//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = 0
	anchored = 1
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/Initialize()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(swirlie)
		usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		usr.visible_message(SPAN_DANGER("[user] slams the toilet seat onto [swirlie.name]'s head!"), SPAN_NOTICE("You slam the toilet seat onto [swirlie.name]'s head!"), "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(8)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(get_turf(src))
			to_chat(user, SPAN_NOTICE("You find \an [I] in the cistern."))
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/toilet/update_icon()
	icon_state = "toilet[open][cistern]"

/obj/structure/toilet/attackby(obj/item/I as obj, mob/living/user as mob)
	if(I.iscrowbar())
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(I.use_tool(src, user, 30, volume = 0))
			user.visible_message(SPAN_NOTICE("[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"), SPAN_NOTICE("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"), "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/obj/item/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the toilet."))
					return
				if(open && !swirlie)
					user.visible_message(SPAN_DANGER("[user] starts to give [GM.name] a swirlie!"), SPAN_NOTICE("You start to give [GM.name] a swirlie!"))
					swirlie = GM
					if(do_after(user, 30, 5, 0))
						user.visible_message(SPAN_DANGER("[user] gives [GM.name] a swirlie!"), SPAN_NOTICE("You give [GM.name] a swirlie!"), "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
						SSfeedback.IncrementSimpleStat("swirlies")
					swirlie = null
				else
					user.visible_message(SPAN_DANGER("[user] slams [GM.name] into the [src]!"), SPAN_NOTICE("You slam [GM.name] into the [src]!"))
					GM.adjustBruteLoss(8)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > 3)
			to_chat(user, SPAN_NOTICE("\The [I] does not fit."))
			return
		if(w_items + I.w_class > 5)
			to_chat(user, SPAN_NOTICE("The cistern is full."))
			return
		user.drop_from_inventory(I,src)
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return

/obj/structure/toilet/noose
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one's cistern seems remarkably scratched."

/obj/structure/toilet/noose/Initialize()
	. = ..()
	new /obj/item/stack/cable_coil(src)
	if(prob(5))
		cistern = 1

/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = 0
	anchored = 1

/obj/structure/urinal/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name] needs to be on the urinal."))
					return
				user.visible_message(SPAN_DANGER("[user] slams [GM.name] into the [src]!"), SPAN_NOTICE("You slam [GM.name] into the [src]!"))
				GM.apply_damage(8, def_zone = BP_HEAD, used_weapon = "blunt force")
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)
			else
				to_chat(user, SPAN_NOTICE("You need a tighter grip."))



/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2450s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = 0
	anchored = 1
	use_power = POWER_USE_OFF
	var/spray_amount = 20
	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/mobpresent = 0		//true if there is a mob on the shower's loc, this is to ease process()
	var/is_washing = 0
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)
	var/datum/looping_sound/showering/soundloop

/obj/machinery/shower/Initialize()
	. = ..()
	create_reagents(2)
	soundloop = new(list(src), FALSE)

/obj/machinery/shower/Destroy()
	QDEL_NULL(soundloop)
	return ..()

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = 1
	mouse_opacity = 0

/obj/machinery/shower/attack_hand(mob/M as mob)
	on = !on
	update_icon()
	if(on)
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood()

/obj/machinery/shower/attackby(obj/item/I as obj, mob/user as mob)
	if(I.type == /obj/item/device/analyzer)
		to_chat(user, SPAN_NOTICE("The water temperature seems to be [watertemp]."))
	if(I.iswrench())
		var/newtemp = input(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve") in temperature_settings
		to_chat(user, SPAN_NOTICE("You begin to adjust the temperature valve with \the [I]."))
		if(I.use_tool(src, user, 50, volume = 50))
			watertemp = newtemp
			user.visible_message(SPAN_NOTICE("[user] adjusts the shower with \the [I]."), SPAN_NOTICE("You adjust the shower with \the [I]."))
			add_fingerprint(user)

/obj/machinery/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	cut_overlays()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)

	if(on)
		soundloop.start(src)
		add_overlay(image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir))
		if(temperature_settings[watertemp] < T20C)
			return //no mist for cold water
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else //??? what the fuck is this
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else
		soundloop.stop(src)
		if(ismist)
			ismist = 1
			mymist = new /obj/effect/mist(loc)
			addtimer(CALLBACK(src, .proc/clear_mist), 250, TIMER_OVERRIDE|TIMER_UNIQUE)

/obj/machinery/shower/proc/clear_mist()
	if (!on)
		QDEL_NULL(mymist)
		ismist = FALSE

/obj/machinery/shower/Crossed(atom/movable/O)
	..()
	wash(O)
	if(ismob(O))
		mobpresent += 1
		process_heat(O)

/obj/machinery/shower/Uncrossed(atom/movable/O)
	if(ismob(O))
		mobpresent -= 1
	..()

//Yes, showers are super powerful as far as washing goes.
/obj/machinery/shower/proc/wash(atom/movable/O)
	if(!on)
		return

	var/obj/effect/effect/water/W = new(O)
	W.create_reagents(spray_amount)
	W.reagents.add_reagent(/singleton/reagent/water, spray_amount)
	W.set_up(O, spray_amount)

	if(iscarbon(O))
		var/update_icons_required = FALSE

		var/mob/living/carbon/M = O
		if(M.r_hand)
			M.r_hand.clean_blood()
		if(M.l_hand)
			M.l_hand.clean_blood()
		if(M.back)
			if(M.back.clean_blood())
				M.update_inv_back(0)

		//flush away reagents on the skin
		if(M.touching)
			var/remove_amount = M.touching.maximum_volume * M.reagent_permeability() //take off your suit first
			M.touching.remove_any(remove_amount)

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/washgloves = TRUE
			var/washshoes = TRUE
			var/washmask = TRUE
			var/washears = TRUE
			var/washglasses = TRUE
			var/washwrists = TRUE

			if(H.wear_suit)
				washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
				washshoes = !(H.wear_suit.flags_inv & HIDESHOES)
				washwrists = !(H.wear_suit.flags_inv & HIDEWRISTS)

			if(H.head)
				washmask = !(H.head.flags_inv & HIDEMASK)
				washglasses = !(H.head.flags_inv & HIDEEYES)
				washears = !(H.head.flags_inv & HIDEEARS)

			if(H.wear_mask)
				if (washears)
					washears = !(H.wear_mask.flags_inv & HIDEEARS)
				if (washglasses)
					washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
					update_icons_required = TRUE
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
					update_icons_required = TRUE
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
					update_icons_required = TRUE
			if(H.gloves && washgloves)
				if(H.gloves.clean_blood())
					H.update_inv_gloves(0)
					update_icons_required = TRUE
			if(H.shoes && washshoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
					update_icons_required = TRUE
			if(H.wear_mask && washmask)
				if(H.wear_mask.clean_blood())
					H.update_inv_wear_mask(0)
					update_icons_required = TRUE
			if(H.glasses && washglasses)
				if(H.glasses.clean_blood())
					H.update_inv_glasses(0)
					update_icons_required = TRUE
			if(H.l_ear && washears)
				if(H.l_ear.clean_blood())
					H.update_inv_l_ear(0)
					update_icons_required = TRUE
			if(H.r_ear && washears)
				if(H.r_ear.clean_blood())
					H.update_inv_r_ear(0)
					update_icons_required = TRUE
			if(H.belt)
				if(H.belt.clean_blood())
					H.update_inv_belt(0)
					update_icons_required = TRUE
			if(H.wrists && washwrists)
				if(H.wrists.clean_blood())
					H.update_inv_wrists(0)
					update_icons_required = TRUE
			H.clean_blood(washshoes)
		else
			if(M.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
				if(M.wear_mask.clean_blood())
					M.update_inv_wear_mask(0)
					update_icons_required = TRUE
			M.clean_blood()

		if (update_icons_required)
			M.update_icon()
	else
		O.clean_blood()

	if(istype(O, /obj/item/light))
		var/obj/item/light/L = O
		L.brightness_color = initial(L.brightness_color)
		L.update()
	else if(istype(O, /obj/machinery/light))
		var/obj/machinery/light/L = O
		L.brightness_color = initial(L.brightness_color)
		L.update()

	O.color = initial(O.color)

	if(isturf(loc))
		var/turf/tile = loc
		loc.clean_blood()
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/rune) || istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				qdel(E)

/obj/machinery/shower/process()
	if(!on)
		return
	wash_floor()
	if(!mobpresent)
		return
	for(var/mob/living/L in loc)
		wash(L) // Why was it not here before?
		process_heat(L)

/obj/machinery/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
	reagents.add_reagent(/singleton/reagent/water, 2)
	T.clean(src)
	spawn(100)
		is_washing = 0

/obj/machinery/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M))
		return

	var/temperature = temperature_settings[watertemp]
	var/temp_adj = between(BODYTEMP_COOLING_MAX, temperature - M.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(temperature >= H.species.heat_level_1)
			to_chat(H, SPAN_DANGER("The water is searing hot!"))
		else if(temperature <= H.species.cold_level_1)
			to_chat(H, SPAN_WARNING("The water is freezing cold!"))

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	desc_info = "You can right-click this and change the amount transferred per use."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment
	var/amount_per_transfer_from_this = 300
	var/possible_transfer_amounts = list(5,10,15,25,30,50,60,100,120,250,300)

/obj/structure/sink/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/sink/attack_hand(mob/user as mob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	to_chat(usr, SPAN_NOTICE("You start washing your hands."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = 1
	if(!do_after(user, 40, src))
		busy = 0
		return TRUE
	busy = 0

	if(!Adjacent(user))
		return		//Person has moved away from the sink

	user.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("[user] washes their hands using \the [src]."), \
		SPAN_NOTICE("You wash your hands using \the [src]."))

/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	// Filling/emptying open reagent containers
	var/obj/item/reagent_containers/RG = O

	if (istype(RG) && RG.is_open_container())
		var/atype = alert(usr, "Do you want to fill or empty \the [RG] at \the [src]?", "Fill or Empty", "Fill", "Empty", "Cancel")

		if(!usr.Adjacent(src)) return
		if(RG.loc != usr && !isrobot(user)) return
		if(busy)
			to_chat(usr, SPAN_WARNING("Someone's already using \the [src]."))
			return

		switch(atype)
			if ("Fill")
				if(RG.reagents.total_volume >= RG.volume)
					to_chat(usr, SPAN_WARNING("\The [RG] is already full."))
					return

				RG.reagents.add_reagent(/singleton/reagent/water, min(RG.volume - RG.reagents.total_volume, amount_per_transfer_from_this))
				user.visible_message("<b>[user]</b> fills \a [RG] using \the [src].",
									 SPAN_NOTICE("You fill \a [RG] using \the [src]."))
				playsound(loc, 'sound/effects/sink.ogg', 75, 1)
			if ("Empty")
				if(!RG.reagents.total_volume)
					to_chat(usr, SPAN_WARNING("\The [RG] is already empty."))
					return

				var/empty_amount = RG.reagents.trans_to(src, RG.amount_per_transfer_from_this)
				var/max_reagents = RG.reagents.maximum_volume
				user.visible_message("<b>[user]</b> empties [empty_amount == max_reagents ? "all of \the [RG]" : "some of \the [RG]"] into \a [src].")
				playsound(src.loc, /singleton/sound_category/generic_pour_sound, 10, 1)
		return

	// Filling/empying Syringes
	else if (istype(O, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = O
		switch(S.mode)
			if(0) // draw
				if(S.reagents.total_volume >= S.volume)
					to_chat(usr, SPAN_WARNING("\The [S] is already full."))
					return

				var/trans = min(S.volume - S.reagents.total_volume, S.amount_per_transfer_from_this)
				S.reagents.add_reagent(/singleton/reagent/water, trans)
				user.visible_message(SPAN_NOTICE("[usr] uses \the [S] to draw water from \the [src]."),
									 SPAN_NOTICE("You draw [trans] units of water from \the [src]. \The [S] now contains [S.reagents.total_volume] units."))
			if(1) // inject
				if(!S.reagents.total_volume)
					to_chat(usr, SPAN_WARNING("\The [S] is already empty."))
					return

				var/trans = min(S.amount_per_transfer_from_this, S.reagents.total_volume)
				S.reagents.remove_any(trans)
				user.visible_message(SPAN_NOTICE("[usr] empties \the [S] into \the [src]."),
									 SPAN_NOTICE("You empty [trans] units of water into \the [src]. \The [S] now contains [S.reagents.total_volume] units."))
		return

	else if (istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message(SPAN_DANGER("[user] was stunned by \the [O]!"))
				return 1
	// Short of a rewrite, this is necessary to stop monkeycubes being washed.
	else if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		return
	else if(istype(O, /obj/item/mop))
		O.reagents.add_reagent(/singleton/reagent/water, 5)
		to_chat(user, SPAN_NOTICE("You wet \the [O] in \the [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, SPAN_NOTICE("You start washing \the [I]."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = 1
	if(!do_after(user, 40, src))
		busy = 0
		return TRUE
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	I.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("[user] washes \a [I] using \the [src]."), \
		SPAN_NOTICE("You wash \a [I] using \the [src]."))

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	desc = "A small pool of some liquid, ostensibly water."

/obj/structure/sink/puddle/attack_hand(mob/M as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"
