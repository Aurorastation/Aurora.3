//
// Cans
//

// Bomb Defines
#define LETHAL_FUEL_CAPACITY 21 // This many units of fuel will cause a harmful explosion.
#define FUSELENGTH_MAX       10 // This is the longest a fuse can be.
#define FUSELENGTH_MIN        3 // And the minimum that the builder can intentionally make.
#define FUSELENGTH_SHORT      5 // The upper boundary of the short fuse.
#define FUSELENGTH_LONG       6 // The lower boundary of the long fuse.
#define BOMBCASING_EMPTY      0 // No grenade casing.
#define BOMBCASING_LOOSE      1 // It is in a grenade casing but not secured.
#define BOMBCASING_SECURE     2 // It is in a grenade casing and secured - shrapnel count increased.

// Parent Item
/obj/item/reagent_containers/food/drinks/cans
	name = "can"
	desc = "An aluminium can."
	icon = 'icons/contained_items/items/cans.dmi'
	icon_state = "can_33cl"
	desc_info = "Activate it in your active hand to open it.<br>\
				 - If it's carbonated and closed, you can shake it by activating it on harm intent.<br>\
				 - If it's empty, you can crush it on your forehead by selecting your head on the targetting doll and clicking on yourself on harm intent.<br>\
				 - You can also crush cans on other people's foreheads as well."
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	flags = 0 // Item flag to check if you can pour stuff inside.
	amount_per_transfer_from_this = 5
	volume = 33 // Centiliters.

	var/can_open = FALSE // If the can is opened. Used for the "open_overlay".
	var/sticker // Used to know which overlay sticker to put on the can.
	var/shadow_overlay = "33cl_shadow_overlay" // Used to know where the shadow overlay goes.
	var/open_overlay = "33cl_open_overlay" // Used to know where the open overlay goes.
	var/list/can_size_overrides = list("x" = 0, "y" = -3) // Position of the can's opening. Make sure to take away 16 from X and 23 from Y.

	// Bomb Code
	var/fuse_length = 0
	var/fuse_lit
	var/bombcasing
	var/shrapnelcount = 7

// Initialize()
/obj/item/reagent_containers/food/drinks/cans/Initialize()
	update_icon()
	..()

// attack()
/obj/item/reagent_containers/food/drinks/cans/attack(mob/living/M, mob/user, var/target_zone)
	if(iscarbon(M) && !reagents.total_volume && user.a_intent == I_HURT && target_zone == BP_HEAD)
		if(M == user)
			user.visible_message(
				SPAN_WARNING("\The [user] crushes the can of [src.name] on [user.get_pronoun("his")] forehead!"),
				SPAN_NOTICE("You crush the can of [src.name] on your forehead.")
			)
		else
			user.visible_message(
				SPAN_WARNING("\The [user] crushes the can of [src.name] on \the [M]'s forehead!"),
				SPAN_NOTICE("You crush the can of [src.name] on \the [M]'s forehead.")
			)
		M.apply_damage(2, BRUTE, BP_HEAD)
		playsound(M, 'sound/items/soda_crush.ogg', rand(10, 50), TRUE)
		var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(M.loc)
		crushed_can.icon_state = icon_state
		qdel(src)
		user.put_in_hands(crushed_can)
		return TRUE
	. = ..()

// update_icon()
/obj/item/reagent_containers/food/drinks/cans/update_icon()
	cut_overlays()

	add_overlay(shadow_overlay)
	add_overlay(sticker)

	if(can_open)
		add_overlay(open_overlay)

	// Bomb Code
	if(fuse_length)
		var/image/fuseoverlay = image('icons/obj/fuses.dmi', icon_state = "fuse_short")
		switch(fuse_length)
			if(FUSELENGTH_LONG to INFINITY)
				fuseoverlay.icon_state = "fuse_long"
		if(fuse_lit)
			fuseoverlay.icon_state = "lit_fuse"
		fuseoverlay.pixel_x = can_size_overrides["x"]
		fuseoverlay.pixel_y = can_size_overrides["y"]
		add_overlay(fuseoverlay)

	if(bombcasing > BOMBCASING_EMPTY)
		var/image/casingoverlay = image('icons/obj/fuses.dmi', icon_state = "pipe_bomb")
		add_overlay(casingoverlay)

/obj/item/reagent_containers/food/drinks/cans/open(mob/user)
	playsound(src,'sound/items/soda_open.ogg', rand(10, 50), TRUE)
	user.visible_message(
		"\The <b>[user]</b> opens \the [src].",
		SPAN_NOTICE("You open \the [src] with an audible pop!"),
		SPAN_NOTICE("You can hear a pop.")
	)
	flags |= OPENCONTAINER
	can_open = TRUE
	update_icon()

// attackby()
/obj/item/reagent_containers/food/drinks/cans/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/grenade/chem_grenade/large))
		var/obj/item/grenade/chem_grenade/grenade_casing = W
		if(!grenade_casing.detonator && !length(grenade_casing.beakers) && bombcasing < BOMBCASING_LOOSE)
			bombcasing = BOMBCASING_LOOSE
			desc = "A grenade casing with \a [name] slotted into it."
			if(fuse_length)
				desc += " It has some steel wool stuffed into the opening."
			user.visible_message(
				SPAN_NOTICE("[user] slots \the [grenade_casing] over \the [name]."),
				SPAN_NOTICE("You slot \the [grenade_casing] over \the [name].")
			)
			desc = "A grenade casing with \a [name] slotted into it."
			qdel(grenade_casing)
			update_icon()

	if(W.isscrewdriver() && bombcasing > BOMBCASING_EMPTY)
		if(bombcasing == BOMBCASING_LOOSE)
			bombcasing = BOMBCASING_SECURE
			shrapnelcount = 14
			user.visible_message(
				SPAN_NOTICE("[user] tightens the grenade casing around \the [name]."),
				SPAN_NOTICE("You tighten the grenade casing around \the [name].")
			)
		else if(bombcasing == BOMBCASING_SECURE)
			bombcasing = BOMBCASING_EMPTY
			shrapnelcount = initial(shrapnelcount)
			desc = initial(desc)
			if(fuse_length)
				desc += " It has some steel wool stuffed into the opening."
			user.visible_message(
				SPAN_NOTICE("[user] removes \the [name] from the grenade casing."),
				SPAN_NOTICE("You remove \the [name] from the grenade casing.")
			)
			new /obj/item/grenade/chem_grenade/large(get_turf(src))
		playsound(loc, W.usesound, 50, 1)
		update_icon()

	if(istype(W, /obj/item/steelwool))
		if(is_open_container())
			switch(fuse_length)
				if(-INFINITY to FUSELENGTH_MAX)
					user.visible_message(
						SPAN_NOTICE("\The [user] stuffs some steel wool into \the [name]."),
						SPAN_NOTICE("You feed steel wool into \the [name], ruining it in the process. It will last approximately 10 seconds.")
					)
					fuse_length = FUSELENGTH_MAX
					update_icon()
					desc += " It has some steel wool stuffed into the opening."
					if(W.isFlameSource())
						light_fuse(W, user, TRUE)
					qdel(W)
				if(FUSELENGTH_MAX)
					to_chat(user, SPAN_WARNING("You cannot make the fuse longer than 10 seconds!"))
		else
			to_chat(user, SPAN_WARNING("There is no opening on \the [name] for the steel wool!"))

	else if(W.iswirecutter() && fuse_length)
		switch(fuse_length)
			if(1 to FUSELENGTH_MIN) // you can't increase the fuse with wirecutters and you can't trim it down below 3, so just remove it outright.
				user.visible_message("<b>[user]</b> removes the steel wool from \the [name].", SPAN_NOTICE("You remove the steel wool fuse from \the [name]."))
				fuse_remove()
			if(4 to FUSELENGTH_MAX)
				var/fchoice = alert("Do you want to shorten or remove the fuse on \the [name]?", "Shorten or Remove", "Shorten", "Remove", "Cancel")
				switch(fchoice)
					if("Shorten")
						var/short = input("How many seconds do you want the fuse to be?", "[name] fuse") as null|num
						if(!use_check_and_message(user))
							if(short < fuse_length && short >= FUSELENGTH_MIN)
								to_chat(user, SPAN_NOTICE("You shorten the fuse to [short] seconds."))
								fuse_remove(fuse_length - short)
							else if(!short && !isnull(short))
								user.visible_message("<b>[user]</b> removes the steel wool from \the [name]", SPAN_NOTICE("You remove the steel wool fuse from \the [name]."))
								fuse_remove()
							else if(short == fuse_length || isnull(short))
								to_chat(user, SPAN_NOTICE("You decide against modifying the fuse."))
							else if (short > fuse_length)
								to_chat(user, SPAN_WARNING("You cannot make the fuse longer than it already is!"))
							else if(short in list(1,2))
								to_chat(user, SPAN_WARNING("The fuse cannot be shorter than 3 seconds!"))
							else
								return
					if("Remove")
						if(!use_check_and_message(user))
							user.visible_message("<b>[user]</b> removes the steel wool from \the [name].", "You remove the steel wool fuse from \the [name].")
							fuse_remove()
					if("Cancel")
						return
				return

	else if(W.isFlameSource() && fuse_length)
		light_fuse(W, user)
	. = ..()

// light_fuse()
/obj/item/reagent_containers/food/drinks/cans/proc/light_fuse(obj/item/W, mob/user, var/premature=FALSE)
	if(can_light())
		fuse_lit = TRUE
		update_icon()
		set_light(2, 2, LIGHT_COLOR_LAVA)
		if(REAGENT_VOLUME(reagents, /decl/reagent/fuel) >= LETHAL_FUEL_CAPACITY && user)
			msg_admin_attack("[user] ([user.ckey]) lit the fuse on an improvised [name] grenade. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user))
			if(fuse_length >= FUSELENGTH_MIN && fuse_length <= FUSELENGTH_SHORT)
				user.visible_message(SPAN_DANGER("<b>[user]</b> accidentally takes \the [W] too close to \the [name]'s opening!"))
				detonate(TRUE) // it'd be a bit dull if the toy-levels of fuel had a chance to insta-pop, it's mostly just a way to keep the grenade balance in check
		if(fuse_length < FUSELENGTH_MIN)
			user.visible_message(SPAN_DANGER("<b>[user]</b> tries to light the fuse on \the [name] but it was too short!"), SPAN_DANGER("You try to light the fuse but it was too short!"))
			detonate(TRUE) // if you're somehow THAT determined and/or ignorant you managed to get the fuse below 3 seconds, so be it. reap what you sow.
		else
			if(premature)
				user.visible_message(SPAN_WARNING("<b>[user]</b> prematurely starts \the [name]'s fuse!"), SPAN_WARNING("You prematurely start \the [name]'s fuse!"))
			else
				user.visible_message(SPAN_WARNING("<b>[user]</b> lights the steel wool on \the [name] with \the [W]!"), SPAN_WARNING("You light the steel wool on \the [name] with the [W]!"))
			playsound(get_turf(src), 'sound/items/flare.ogg', 50)
			detonate(FALSE)

// detonate()
/obj/item/reagent_containers/food/drinks/cans/proc/detonate(var/instant)
	var/fuel = REAGENT_VOLUME(reagents, /decl/reagent/fuel)
	if(instant)
		fuse_length = 0
	else if(prob(fuse_length * 6)) // the longer the fuse, the higher chance it will fizzle out (18% chance minimum)
		var/fizzle = rand(1, fuse_length - 1)
		sleep(fizzle * 1 SECOND)

		fuse_length -= fizzle
		visible_message(SPAN_WARNING("The fuse on \the [name] fizzles out early."))
		playsound(get_turf(src), 'sound/items/cigs_lighters/cig_snuff.ogg', 50)
		fuse_lit = FALSE
		set_light(0, 0)
		update_icon()
		return
	else
		fuse_length += rand(-2, 2) // if the fuse isn't fizzling out or detonating instantly, make it a little harder to predict the fuse by +2/-2 seconds
	sleep(fuse_length * 1 SECOND)

	switch(round(fuel))
		if(0)
			visible_message(SPAN_NOTICE("\The [name]'s fuse burns out and nothing happens."))
			fuse_length = 0
			fuse_lit = FALSE
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
	fuse_lit = FALSE
	update_icon()
	qdel(src)

// can_light()
/obj/item/reagent_containers/food/drinks/cans/proc/can_light() // just reverses the fuse_lit var to return a TRUE or FALSE, should hopefully make things a little easier if someone adds more fuse interactions later.
    return !fuse_lit && fuse_length

/obj/item/reagent_containers/food/drinks/cans/proc/fuse_remove(var/cable_removed = fuse_length)
	fuse_length -= cable_removed
	update_icon()
	if(!fuse_length)
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
		fuse_lit = TRUE
		detonate(FALSE)
		visible_message(SPAN_WARNING("<b>\The [name]'s fuse catches on fire!</b>"))
	. = ..()

//
// Can Sizes
//

// 33 Centiliter Can
// Regular sodas, juice, et cetera.
/obj/item/reagent_containers/food/drinks/cans/regular
	name = "can"
	desc = "A 33 cl aluminium can."
	volume = 33

// 50 Centiliter Can
// Water, energy drinks, et cetera.
/obj/item/reagent_containers/food/drinks/cans/large
	name = "large can"
	desc = "A 50 cl aluminium can."
	volume = 50

//
// Drinks
//

// Carbonated Water
/obj/item/reagent_containers/food/drinks/cans/carbonated_water
	name = "\improper carbonated water can"
	desc = "A 33 cl can of carbonated water."
	sticker = "water"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/water/carbonated = 33)

// Starfall (Cola)
/obj/item/reagent_containers/food/drinks/cans/starfall
	name = "\improper Starfall can"
	desc = "A 33 cl can of Starfall cola."
	sticker = "starfall"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/space_cola = 33)

// Starfall Max (Cola)
/obj/item/reagent_containers/food/drinks/cans/starfall_max
	name = "\improper Starfall Max can"
	desc = "A 33 cl can of Starfall Max cola. Contains no sugar, unless you count the sweetener as sugar."
	sticker = "starfall_max"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/diet_cola = 33)

// Comet Cola (Cola)
/obj/item/reagent_containers/food/drinks/cans/comet_cola
	name = "\improper Comet Cola can"
	desc = "A 33 cl can of Comet Cola."
	sticker = "comet_cola"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/space_cola = 33)

// Comet Cola Zero (Cola)
/obj/item/reagent_containers/food/drinks/cans/comet_cola_zero
	name = "\improper Comet Cola Zero can"
	desc = "A 33 cl can of Comet Cola Zero. The zero sugar variant as the name implies."
	sticker = "comet_cola_zero"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/diet_cola = 33)

// Stellar Jolt (Lemon and Lime Soda)
/obj/item/reagent_containers/food/drinks/cans/stellar_jolt
	name = "\improper Stellar Jolt can"
	desc = "A 33 cl can of Stellar Jolt."
	sticker = "jolt"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/spacemountainwind = 33)

// Lemon Twist (Lemon and Lime Soda)
/obj/item/reagent_containers/food/drinks/cans/lemon_twist
	name = "\improper Lemon Twist can"
	desc = "A 33 cl can of Lemon Twist."
	sticker = "lemon_twist"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/spacemountainwind = 33)

// OJ Dash (Orange Soda)
/obj/item/reagent_containers/food/drinks/cans/oj_dash
	name = "\improper OJ Dash can"
	desc = "A 33 cl can of OJ Dash."
	sticker = "oj_dash"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/brownstar = 33)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "thirteen loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/alcohol/thirteenloko = 33)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/dr_gibb = 33)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Silversun Wave ice tea"
	desc = "Marketed as a favorite amongst parched Silversun beachgoers, there's actually more sugar in this than there is tea."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/icetea = 33)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/grapejuice = 33)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's tonic water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/tonic = 33)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/sodawater = 33)

/obj/item/reagent_containers/food/drinks/cans/koispunch
	name = "\improper Phoron Punch!"
	desc = "A radical looking can of " + SPAN_WARNING("Phoron Punch!") + " Phoron poisoning has never been more extreme! " + SPAN_DANGER("WARNING: Phoron is toxic to non-Vaurca. Consuming this product might lead to death.")

	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/water = 18, /decl/reagent/kois/clean = 10, /decl/reagent/toxin/phoron = 5)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "\improper RnD Root Beer"
	desc = "A classic Earth drink from the United Americas province."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/root_beer = 33)

/obj/item/reagent_containers/food/drinks/cans/adhomai_milk
	name = "fermented fatshouters milk"
	desc = "A can of fermented fatshouters milk, imported from Adhomai."

	center_of_mass = list("x"=16, "y"=10)
	desc_extended = "Fermend fatshouters milk is a drink that originated among the nomadic populations of Rhazar'Hrujmagh, and it has spread to the rest of Adhomai."

	reagents_to_add = list(/decl/reagent/drink/milk/adhomai/fermented = 33)

/obj/item/reagent_containers/food/drinks/cans/beetle_milk
	name = "\improper Hakhma Milk"
	desc = "A can of Hakhma beetle milk, sourced from Scarab and Drifter communities."

	center_of_mass = list("x"=17, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/milk/beetle = 33)
	can_size_overrides = list("x" = 1, "y" = -2)

/obj/item/reagent_containers/food/drinks/cans/dyn
	name = "Cooling Breeze"
	desc = "The most refreshing thing you can find on the market, based on a Skrell medicinal plant. No salt or sugar."

	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/dynjuice/cold = 33)

/obj/item/reagent_containers/food/drinks/cans/threetowns
	name = "\improper Three Towns Cider"
	desc = "A cider made on the west coast of the Moghresian Sea, this is simply one of many brands made in a region known for its craft local butanol, shipped throughout the Wasteland."

	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/alcohol/butanol/threetownscider = 33)

/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda
	name = "Hro'zamal Soda"
	desc = "A can of Hro'zamal Soda. Made with Hro'zamal Ras'Nifs powder and canned in the People's Republic of Adhomai."
	desc_extended = "Hro'zamal Soda is a soft drink made from the seed's powder of a plant native to Hro'zamal, the sole Hadiist colony. While initially consumed as a herbal tea by the \
	colonists, it was introduced to Adhomai by the Army Expeditionary Force and transformed into a carbonated drink. The beverage is popular with factory workers and university \
	students because of its stimulant effect."

	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/decl/reagent/drink/hrozamal_soda = 33)

/obj/item/reagent_containers/food/drinks/cans/peach_soda
	name = "Xanu Rush!"
	desc = "Made from the NEW Xanu Prime peaches."
	desc_extended = "The rehabilitating environment of Xanu has allowed for small-scale agriculture to bloom. Xanu Rush! Is the number one Coalition soda, despite its dull taste."
	icon_state = "xanu_rush"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/decl/reagent/drink/peach_soda = 33)

//
// Zo'ra Sodas
//

/obj/item/reagent_containers/food/drinks/cans/zorasoda
	name = "\improper Zo'ra Soda"
	desc = "A can of Zo'ra Soda energy drink, with V'krexi additives. You aren't supposed to see this."
	center_of_mass = list("x" = 16, "y" = 8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/decl/reagent/drink/zorasoda = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry
	name = "\improper Zo'ra Soda Cherry"
	desc = "A can of cherry flavoured Zo'ra Soda energy drink, with V'krexi additives. All good energy drinks come in cherry."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/cherry = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron
	name = "\improper Zo'ra Soda Phoron Passion"
	desc = "A can of grape flavoured Zo'ra Soda energy drink, with V'krexi additives. Tastes nothing like phoron according to Unbound vaurca taste testers."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/phoron = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax
	name = "\improper K'laxan Energy Crush"
	desc = "A can of nitrogen-infused creamy orange zest flavoured Zo'ra Soda energy drink, with V'krexi additives. The smooth taste is engineered to near perfection."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/klax = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur
	name = "\improper C'thur Rockin' Raspberry"
	desc = "A can of \"blue raspberry\" flavoured Zo'ra Soda energy drink, with V'krexi additives. Tastes like a more flowery and aromatic raspberry."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/cthur = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass
	name = "\improper Zo'ra Sour Venom Grass"
	desc = "A can of sour \"venom grass\" flavoured Zo'ra Soda energy drink, with V'krexi additives. Tastes like a cloud of angry stinging acidic bees."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/venomgrass = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/hozm // "Contraband"
	name = "\improper High Octane Zorane Might"
	desc = "A can of mint flavoured Zo'ra Soda energy drink, with a lot of V'krexi additives. Tastes like impaling the roof of your mouth with a freezing cold spear laced with angry bees and road salt.<br/>" + SPAN_DANGER(" WARNING: Not for the faint hearted!")

	reagents_to_add = list(/decl/reagent/drink/zorasoda/hozm = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois
	name = "\improper Zo'ra Soda K'ois Twist"
	desc = "A can of K'ois-imitation flavoured Zo'ra Soda energy drink, with V'krexi additives. Contains no K'ois, contrary to what the name may imply."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/kois = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone
	name = "\improper Vaurca Drone Fuel"
	desc = "A can of industrial fluid flavoured Zo'ra Soda energy drink, with V'krexi additives, meant for Vaurca.<br/>" + SPAN_DANGER(" WARNING: Known to induce vomiting in all species except vaurcae and dionae!")

	reagents_to_add = list(/decl/reagent/drink/zorasoda/drone = 50)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/jelly
	name = "\improper Royal Vaurca Jelly"
	desc = "A can of..." + SPAN_ITALIC(" sludge?") + " It smells kind of pleasant either way. Royal jelly is a nutritious concentrated substance commonly created by Caretaker Vaurca in order to feed larvae. It is known to have a stimulating effect in most, if not all, species."

	reagents_to_add = list(/decl/reagent/drink/zorasoda/jelly = 50)

#undef LETHAL_FUEL_CAPACITY
#undef FUSELENGTH_MAX
#undef FUSELENGTH_MIN
#undef FUSELENGTH_SHORT
#undef FUSELENGTH_LONG
#undef BOMBCASING_EMPTY
#undef BOMBCASING_LOOSE
#undef BOMBCASING_SECURE