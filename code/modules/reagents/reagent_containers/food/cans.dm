#define LETHAL_FUEL_CAPACITY 21 // this many units of fuel will cause a harmful explosion
#define FUSELENGTH_MAX 10 // this is the longest a fuse can be
#define FUSELENGTH_MIN 3 // and the minimum that the builder can intentionally make
#define FUSELENGTH_SHORT 5 // the upper boundary of the short fuse
#define FUSELENGTH_LONG 6 // the lower boundary of the long fuse
#define BOMBCASING_EMPTY 0 // no grenade casing
#define BOMBCASING_LOOSE 1 // it's in a grenade casing but not secured
#define BOMBCASING_SECURE 2 // it's in a grenade casing and secured - shrapnel count increased

/obj/item/reagent_containers/food/drinks/cans
	var/fuselength = 0
	var/fuselit
	var/bombcasing
	var/shrapnelcount = 7
	var/list/can_size_overrides = list("x" = 0, "y" = -3) // position of the can's opening - make sure to take away 16 from X and 23 from Y
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	flags = 0 //starts closed
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	desc_info = "Click it in your hand to open it.\
				 If it's carbonated and closed, you can shake it by clicking on it with harm intent. \
				 If it's empty, you can crush it on your forehead by selecting your head and clicking on yourself with harm intent. \
				 You can also crush cans on other people's foreheads as well."

/obj/item/reagent_containers/food/drinks/cans/attack(mob/living/M, mob/user, var/target_zone)
	if(iscarbon(M) && !reagents.total_volume && user.a_intent == I_HURT && target_zone == BP_HEAD)
		if(M == user)
			user.visible_message(SPAN_WARNING("[user] crushes the can of [src.name] on [user.get_pronoun("his")] forehead!"), SPAN_NOTICE("You crush the can of [src.name] on your forehead."))
		else
			user.visible_message(SPAN_WARNING("[user] crushes the can of [src.name] on [M]'s forehead!"), SPAN_NOTICE("You crush the can of [src.name] on [M]'s forehead."))
		M.apply_damage(2,BRUTE,BP_HEAD) // ouch.
		playsound(M,'sound/items/soda_crush.ogg', rand(10,50), TRUE)
		var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(M.loc)
		crushed_can.icon_state = icon_state
		qdel(src)
		user.put_in_hands(crushed_can)
		return TRUE
	. = ..()

/obj/item/reagent_containers/food/drinks/cans/update_icon()
	cut_overlays()
	if(fuselength)
		var/image/fuseoverlay = image('icons/obj/fuses.dmi', icon_state = "fuse_short")
		switch(fuselength)
			if(FUSELENGTH_LONG to INFINITY)
				fuseoverlay.icon_state = "fuse_long"
		if(fuselit)
			fuseoverlay.icon_state = "lit_fuse"
		fuseoverlay.pixel_x = can_size_overrides["x"]
		fuseoverlay.pixel_y = can_size_overrides["y"]
		add_overlay(fuseoverlay)
	if(bombcasing > BOMBCASING_EMPTY)
		var/image/casingoverlay = image('icons/obj/fuses.dmi', icon_state = "pipe_bomb")
		add_overlay(casingoverlay)

/obj/item/reagent_containers/food/drinks/cans/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/grenade/chem_grenade/large))
		var/obj/item/grenade/chem_grenade/grenade_casing = W
		if(!grenade_casing.detonator && !length(grenade_casing.beakers) && bombcasing < BOMBCASING_LOOSE)
			bombcasing = BOMBCASING_LOOSE
			desc = "A grenade casing with \a [name] slotted into it."
			if(fuselength)
				desc += " It has some steel wool stuffed into the opening."
			user.visible_message(SPAN_NOTICE("[user] slots \the [grenade_casing] over \the [name]."), SPAN_NOTICE("You slot \the [grenade_casing] over \the [name]."))
			desc = "A grenade casing with \a [name] slotted into it."
			qdel(grenade_casing)
			update_icon()

	if(W.isscrewdriver() && bombcasing > BOMBCASING_EMPTY)
		if(bombcasing == BOMBCASING_LOOSE)
			bombcasing = BOMBCASING_SECURE
			shrapnelcount = 14
			user.visible_message(SPAN_NOTICE("[user] tightens the grenade casing around \the [name]."), SPAN_NOTICE("You tighten the grenade casing around \the [name]."))
		else if(bombcasing == BOMBCASING_SECURE)
			bombcasing = BOMBCASING_EMPTY
			shrapnelcount = initial(shrapnelcount)
			desc = initial(desc)
			if(fuselength)
				desc += " It has some steel wool stuffed into the opening."
			user.visible_message(SPAN_NOTICE("[user] removes \the [name] from the grenade casing."), SPAN_NOTICE("You remove \the [name] from the grenade casing."))
			new /obj/item/grenade/chem_grenade/large(get_turf(src))
		playsound(loc, W.usesound, 50, 1)
		update_icon()

	if(istype(W, /obj/item/steelwool))
		if(is_open_container())
			switch(fuselength)
				if(-INFINITY to FUSELENGTH_MAX)
					user.visible_message("<b>[user]</b> stuffs some steel wool into \the [name].", SPAN_NOTICE("You feed steel wool into \the [name], ruining it in the process. It will last approximately 10 seconds."))
					fuselength = FUSELENGTH_MAX
					update_icon()
					desc += " It has some steel wool stuffed into the opening."
					if(W.isFlameSource())
						light_fuse(W, user, TRUE)
					qdel(W)
				if(FUSELENGTH_MAX)
					to_chat(user, SPAN_WARNING("You cannot make the fuse longer than 10 seconds!"))
		else
			to_chat(user, SPAN_WARNING("There is no opening on \the [name] for the steel wool!"))

	else if(W.iswirecutter() && fuselength)
		switch(fuselength)
			if(1 to FUSELENGTH_MIN) // you can't increase the fuse with wirecutters and you can't trim it down below 3, so just remove it outright.
				user.visible_message("<b>[user]</b> removes the steel wool from \the [name].", SPAN_NOTICE("You remove the steel wool fuse from \the [name]."))
				FuseRemove()
			if(4 to FUSELENGTH_MAX)
				var/fchoice = alert("Do you want to shorten or remove the fuse on \the [name]?", "Shorten or Remove", "Shorten", "Remove", "Cancel")
				switch(fchoice)
					if("Shorten")
						var/short = input("How many seconds do you want the fuse to be?", "[name] fuse") as null|num
						if(!use_check_and_message(user))
							if(short < fuselength && short >= FUSELENGTH_MIN)
								to_chat(user, SPAN_NOTICE("You shorten the fuse to [short] seconds."))
								FuseRemove(fuselength - short)
							else if(!short && !isnull(short))
								user.visible_message("<b>[user]</b> removes the steel wool from \the [name]", SPAN_NOTICE("You remove the steel wool fuse from \the [name]."))
								FuseRemove()
							else if(short == fuselength || isnull(short))
								to_chat(user, SPAN_NOTICE("You decide against modifying the fuse."))
							else if (short > fuselength)
								to_chat(user, SPAN_WARNING("You cannot make the fuse longer than it already is!"))
							else if(short in list(1,2))
								to_chat(user, SPAN_WARNING("The fuse cannot be shorter than 3 seconds!"))
							else
								return
					if("Remove")
						if(!use_check_and_message(user))
							user.visible_message("<b>[user]</b> removes the steel wool from \the [name].", "You remove the steel wool fuse from \the [name].")
							FuseRemove()
					if("Cancel")
						return
				return

	else if(W.isFlameSource() && fuselength)
		light_fuse(W, user)
	. = ..()

/obj/item/reagent_containers/food/drinks/cans/proc/light_fuse(obj/item/W, mob/user, var/premature=FALSE)
	if(can_light())
		fuselit = TRUE
		update_icon()
		set_light(2, 2, LIGHT_COLOR_LAVA)
		if(REAGENT_VOLUME(reagents, /decl/reagent/fuel) >= LETHAL_FUEL_CAPACITY && user)
			msg_admin_attack("[user] ([user.ckey]) lit the fuse on an improvised [name] grenade. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user))
			if(fuselength >= FUSELENGTH_MIN && fuselength <= FUSELENGTH_SHORT)
				user.visible_message(SPAN_DANGER("<b>[user]</b> accidentally takes \the [W] too close to \the [name]'s opening!"))
				detonate(TRUE) // it'd be a bit dull if the toy-levels of fuel had a chance to insta-pop, it's mostly just a way to keep the grenade balance in check
		if(fuselength < FUSELENGTH_MIN)
			user.visible_message(SPAN_DANGER("<b>[user]</b> tries to light the fuse on \the [name] but it was too short!"), SPAN_DANGER("You try to light the fuse but it was too short!"))
			detonate(TRUE) // if you're somehow THAT determined and/or ignorant you managed to get the fuse below 3 seconds, so be it. reap what you sow.
		else
			if(premature)
				user.visible_message(SPAN_WARNING("<b>[user]</b> prematurely starts \the [name]'s fuse!"), SPAN_WARNING("You prematurely start \the [name]'s fuse!"))
			else
				user.visible_message(SPAN_WARNING("<b>[user]</b> lights the steel wool on \the [name] with \the [W]!"), SPAN_WARNING("You light the steel wool on \the [name] with the [W]!"))
			playsound(get_turf(src), 'sound/items/flare.ogg', 50)
			detonate(FALSE)

/obj/item/reagent_containers/food/drinks/cans/proc/detonate(var/instant)
	var/fuel = REAGENT_VOLUME(reagents, /decl/reagent/fuel)
	if(instant)
		fuselength = 0
	else if(prob(fuselength * 6)) // the longer the fuse, the higher chance it will fizzle out (18% chance minimum)
		var/fizzle = rand(1, fuselength - 1)
		sleep(fizzle * 1 SECOND)

		fuselength -= fizzle
		visible_message(SPAN_WARNING("The fuse on \the [name] fizzles out early."))
		playsound(get_turf(src), 'sound/items/cigs_lighters/cig_snuff.ogg', 50)
		fuselit = FALSE
		set_light(0, 0)
		update_icon()
		return
	else
		fuselength += rand(-2, 2) // if the fuse isn't fizzling out or detonating instantly, make it a little harder to predict the fuse by +2/-2 seconds
	sleep(fuselength * 1 SECOND)

	switch(round(fuel))
		if(0)
			visible_message(SPAN_NOTICE("\The [name]'s fuse burns out and nothing happens."))
			fuselength = 0
			fuselit = FALSE
			update_icon()
			set_light(0, 0)
			return
		if(1 to FUSELENGTH_MAX) // baby explosion.
			var/obj/item/trash/can/popped_can = new(get_turf(src))
			popped_can.icon_state = icon_state
			popped_can.name = "popped can"
			playsound(get_turf(src), 'sound/effects/snap.ogg', 50)
			visible_message(SPAN_WARNING("\The [name] pops harmlessly!"))
		if(11 to 20) // slightly less baby explosion
			new /obj/item/material/shard/shrapnel(get_turf(src))
			playsound(get_turf(src), 'sound/effects/bang.ogg', 50)
			visible_message(SPAN_WARNING("\The [name] bursts violently into pieces!"))
		if(LETHAL_FUEL_CAPACITY to INFINITY) // boom
			fragem(src, shrapnelcount, shrapnelcount, 1, 0, 5, 1, TRUE, 2) // The main aim of the grenade should be to hit and wound people with shrapnel instead of causing a lot of station damage, hence the small explosion radius
			playsound(get_turf(src), 'sound/effects/Explosion1.ogg', 50)
			visible_message(SPAN_DANGER("<b>\The [name] explodes!</b>"))
	fuselit = FALSE
	update_icon()
	qdel(src)

/obj/item/reagent_containers/food/drinks/cans/proc/can_light() // just reverses the fuselit var to return a TRUE or FALSE, should hopefully make things a little easier if someone adds more fuse interactions later.
    return !fuselit && fuselength

/obj/item/reagent_containers/food/drinks/cans/proc/FuseRemove(var/CableRemoved = fuselength)
	fuselength -= CableRemoved
	update_icon()
	if(!fuselength)
		if(bombcasing > BOMBCASING_EMPTY)
			desc = "A grenade casing with \a [name] slotted into it."
		else
			desc = initial(desc)

/obj/item/reagent_containers/food/drinks/cans/bullet_act(obj/item/projectile/P)
	if(P.firer && REAGENT_VOLUME(reagents, /decl/reagent/fuel) >= LETHAL_FUEL_CAPACITY)
		visible_message(SPAN_DANGER("\The [name] is hit by the [P]!"))
		log_and_message_admins("shot an improvised [name] explosive", P.firer)
		log_game("[key_name(P.firer)] shot improvised grenade at [loc.loc.name] ([loc.x],[loc.y],[loc.z]).",ckey=key_name(P.firer))
	detonate(TRUE)
	. = ..()

/obj/item/reagent_containers/food/drinks/cans/ex_act(severity)
	detonate(TRUE)
	. = ..()

/obj/item/reagent_containers/food/drinks/cans/fire_act()
	if(can_light())
		fuselit = TRUE
		detonate(FALSE)
		visible_message(SPAN_WARNING("<b>\The [name]'s fuse catches on fire!</b>"))
	. = ..()

#undef LETHAL_FUEL_CAPACITY
#undef FUSELENGTH_MAX
#undef FUSELENGTH_MIN
#undef FUSELENGTH_SHORT
#undef FUSELENGTH_LONG
#undef BOMBCASING_EMPTY
#undef BOMBCASING_LOOSE
#undef BOMBCASING_SECURE

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "space cola"
	desc = "Cola. in space."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/space_cola = 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/spacemountainwind = 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "thirteen loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/alcohol/thirteenloko = 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/dr_gibb = 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/brownstar = 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/spaceup = 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/lemon_lime = 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket iced tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/icetea = 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "grapesoda"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/grapejuice = 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's tonic water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/tonic = 50)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/sodawater = 50)

/obj/item/reagent_containers/food/drinks/cans/koispunch
	name = "\improper Phoron Punch!"
	desc = "A radical looking can of <span class='warning'>Phoron Punch!</span> Phoron poisoning has never been more extreme!"
	icon_state = "phoron_punch"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/kois/clean = 10, /decl/reagent/toxin/phoron = 5)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "\improper RnD Root Beer"
	desc = "A classic Earth drink from the United Americas province."
	icon_state = "root_beer"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/root_beer = 30)

//zoda

/obj/item/reagent_containers/food/drinks/cans/zorasoda
	name = "\improper Zo'ra Soda Cherry"
	desc = "A can of cherry energy drink, with V'krexi additives. All good colas come in cherry."
	icon_state = "zoracherry"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zorakois
	name = "\improper Zo'ra Soda Kois Twist"
	desc = "A can of K'ois flavored energy drink, with V'krexi additives. Contains no K'ois, probably contains no palatable flavor."
	icon_state = "koistwist"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/kois = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoraphoron
	name = "\improper Zo'ra Soda Phoron Passion"
	desc = "A can of grape flavored energy drink, with V'krexi additives. Tastes nothing like phoron according to Unbound taste testers."
	icon_state = "phoronpassion"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/phoron = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zorahozm
	name = "\improper High Octane Zorane Might"
	desc = "A can of fizzy, acidic energy, with plenty of V'krexi additives. Tastes like impaling the bottom of your mouth with a freezing cold spear laced with bees and salt."
	icon_state = "hozm"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/hozm = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoravenom
	name = "\improper Zo'ra Soda Sour Venom Grass (Diet!)"
	desc = "A diet can of Venom Grass flavored energy drink, with V'krexi additives. Still tastes like a cloud of stinging polytrinic bees, but calories are nowhere to be found."
	icon_state = "sourvenomgrass"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/venomgrass = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoraklax
	name = "\improper Klaxan Energy Crush"
	desc = "A can of orange cream flavored energy drink, with V'krexi additives. Engineered nearly to perfection."
	icon_state = "klaxancrush"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/klax = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoracthur
	name = "\improper C'thur Rockin' Raspberry"
	desc = "A can of blue raspberry flavored energy drink, with V'krexi additives. You're pretty sure this was shipped by mistake, the previous K'laxan Energy Crush wrapper is still partly visible underneath the current one."
	icon_state = "cthurberry"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/cthur = 20, /decl/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoradrone
	name = "\improper Drone Fuel"
	desc = "A can of some kind of industrial fluid flavored energy drink, with V'krexi additives meant for Vaurca. <span class='warning'>Known to induce vomiting in humans!</span>."
	icon_state = "dronefuel"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/drone = 30, /decl/reagent/mental/vaam = 10)

/obj/item/reagent_containers/food/drinks/cans/zorajelly
	name = "\improper Royal Jelly"
	desc = "A can of... You aren't sure, but it smells pleasant already."
	icon_state = "royaljelly"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda/jelly = 30)

/obj/item/reagent_containers/food/drinks/cans/adhomai_milk
	name = "fermented fatshouters milk"
	desc = "A can of fermented fatshouters milk, imported from Adhomai."
	icon_state = "milk_can"
	center_of_mass = list("x"=16, "y"=10)
	desc_fluff = "Fermend fatshouters milk is a drink that originated among the nomadic populations of Rhazar'Hrujmagh, and it has spread to the rest of Adhomai."

	reagents_to_add = list(/decl/reagent/drink/milk/adhomai/fermented = 30)

/obj/item/reagent_containers/food/drinks/cans/beetle_milk
	name = "\improper Hakhma Milk"
	desc = "A can of Hakhma beetle milk, sourced from Scarab and Drifter communities."
	icon_state = "beetlemilk"
	center_of_mass = list("x"=17, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/milk/beetle = 30)
	can_size_overrides = list("x" = 1, "y" = -2)

/obj/item/reagent_containers/food/drinks/cans/dyn
	name = "Cooling Breeze"
	desc = "The most refreshing thing you can find on the market, based on a Skrell medicinal plant. No salt or sugar."
	icon_state = "dyncan"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/dynjuice/cold = 30)

/obj/item/reagent_containers/food/drinks/cans/threetowns
	name = "\improper Three Towns Cider"
	desc = "A cider made on the west coast of the Moghresian Sea, this is simply one of many brands made in a region known for its craft local butanol, shipped throughout the Wasteland."
	icon_state = "three_towns_cider"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/alcohol/butanol/threetownscider = 30)
