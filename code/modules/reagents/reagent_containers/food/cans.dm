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
	atom_flags = 0 //starts closed
	icon = 'icons/obj/item/reagent_containers/food/drinks/soda.dmi'
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
		M.apply_damage(2,DAMAGE_BRUTE,BP_HEAD) // ouch.
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

/obj/item/reagent_containers/food/drinks/cans/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/grenade/chem_grenade/large))
		var/obj/item/grenade/chem_grenade/grenade_casing = attacking_item
		if(!grenade_casing.detonator && !length(grenade_casing.beakers) && bombcasing < BOMBCASING_LOOSE)
			bombcasing = BOMBCASING_LOOSE
			desc = "A grenade casing with \a [name] slotted into it."
			if(fuselength)
				desc += " It has some steel wool stuffed into the opening."
			user.visible_message(SPAN_NOTICE("[user] slots \the [grenade_casing] over \the [name]."),
									SPAN_NOTICE("You slot \the [grenade_casing] over \the [name]."))
			desc = "A grenade casing with \a [name] slotted into it."
			qdel(grenade_casing)
			update_icon()

	if(attacking_item.isscrewdriver() && bombcasing > BOMBCASING_EMPTY)
		if(bombcasing == BOMBCASING_LOOSE)
			bombcasing = BOMBCASING_SECURE
			shrapnelcount = 14
			user.visible_message(SPAN_NOTICE("[user] tightens the grenade casing around \the [name]."),
									SPAN_NOTICE("You tighten the grenade casing around \the [name]."))
		else if(bombcasing == BOMBCASING_SECURE)
			bombcasing = BOMBCASING_EMPTY
			shrapnelcount = initial(shrapnelcount)
			desc = initial(desc)
			if(fuselength)
				desc += " It has some steel wool stuffed into the opening."
			user.visible_message(SPAN_NOTICE("[user] removes \the [name] from the grenade casing."),
									SPAN_NOTICE("You remove \the [name] from the grenade casing."))
			new /obj/item/grenade/chem_grenade/large(get_turf(src))
		attacking_item.play_tool_sound(get_turf(src), 50)
		update_icon()

	if(istype(attacking_item, /obj/item/steelwool))
		if(is_open_container())
			switch(fuselength)
				if(-INFINITY to FUSELENGTH_MAX)
					user.visible_message("<b>[user]</b> stuffs some steel wool into \the [name].",
											SPAN_NOTICE("You feed steel wool into \the [name], ruining it in the process. It will last approximately 10 seconds."))
					fuselength = FUSELENGTH_MAX
					update_icon()
					desc += " It has some steel wool stuffed into the opening."
					if(attacking_item.isFlameSource())
						light_fuse(attacking_item, user, TRUE)
					qdel(attacking_item)
				if(FUSELENGTH_MAX)
					to_chat(user, SPAN_WARNING("You cannot make the fuse longer than 10 seconds!"))
		else
			to_chat(user, SPAN_WARNING("There is no opening on \the [name] for the steel wool!"))

	else if(attacking_item.iswirecutter() && fuselength)
		switch(fuselength)
			if(1 to FUSELENGTH_MIN) // you can't increase the fuse with wirecutters and you can't trim it down below 3, so just remove it outright.
				user.visible_message("<b>[user]</b> removes the steel wool from \the [name].",
										SPAN_NOTICE("You remove the steel wool fuse from \the [name]."))
				FuseRemove()
			if(4 to FUSELENGTH_MAX)
				var/fchoice = tgui_input_list(user, "Do you want to shorten or remove the fuse on \the [name]?", "Shorten or Remove", list("Shorten", "Remove", "Cancel"), "Cancel")
				switch(fchoice)
					if("Shorten")
						var/short = tgui_input_number(user, "How many seconds do you want the fuse to be?", "[name] fuse", min_value = FUSELENGTH_MIN)
						if(!use_check_and_message(user))
							if(short < fuselength && short >= FUSELENGTH_MIN)
								to_chat(user, SPAN_NOTICE("You shorten the fuse to [short] seconds."))
								FuseRemove(fuselength - short)
							else if(!short && !isnull(short))
								user.visible_message("<b>[user]</b> removes the steel wool from \the [name]",
														SPAN_NOTICE("You remove the steel wool fuse from \the [name]."))
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

	else if(attacking_item.isFlameSource() && fuselength)
		light_fuse(attacking_item, user)
	. = ..()

/obj/item/reagent_containers/food/drinks/cans/proc/light_fuse(obj/item/W, mob/user, var/premature=FALSE)
	if(can_light())
		fuselit = TRUE
		update_icon()
		set_light(2, 2, LIGHT_COLOR_LAVA)
		if(REAGENT_VOLUME(reagents, /singleton/reagent/fuel) >= LETHAL_FUEL_CAPACITY && user)
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
	if(instant)
		handle_detonation()
	else
		addtimer(CALLBACK(src, PROC_REF(handle_detonation)), (fuselength + rand(-2, 2)) SECONDS)

/obj/item/reagent_containers/food/drinks/cans/proc/handle_detonation()
	var/fuel = REAGENT_VOLUME(reagents, /singleton/reagent/fuel)
	switch(round(fuel))
		if(0)
			visible_message(SPAN_NOTICE("\The [name]'s fuse burns out and nothing happens."))
			fuselength = 0
			fuselit = FALSE
			update_icon()
			set_light(0, 0)
			return
		if(1 to 10) // baby explosion.
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
			fragem(src, shrapnelcount, shrapnelcount, 3, 5, 15, 3, TRUE, 5)
			playsound(get_turf(src), 'sound/effects/Explosion1.ogg', 50)
			visible_message(SPAN_DANGER("<b>\The [name] explodes!</b>"))
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
	if(P.firer && REAGENT_VOLUME(reagents, /singleton/reagent/fuel) >= LETHAL_FUEL_CAPACITY)
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
	name = "comet cola can"
	desc = "Getmore's most popular line of soda. A generic cola, otherwise."
	icon_state = "cola"
	item_state = "cola"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/drink/space_cola = 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "stellar jolt can"
	desc = "For those who have a need for caffeine stronger than would be sensible."
	icon_state = "space_mountain_wind"
	item_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/spacemountainwind = 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "getmore energy can"
	desc = "An extremely ill-advised combination of excessive caffeine and alcohol. Getmore's most controversial product to date!"
	icon_state = "thirteen_loko"
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/alcohol/thirteenloko = 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "getmore root-cola can"
	desc = "A canned mixture of Comet Cola and Getmore Root Beer. More popular than one would expect."
	icon_state = "dr_gibb"
	item_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/dr_gibb = 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "orange starshine can"
	desc = "A sugary-sweet citrus soda."
	icon_state = "starkist"
	item_state = "starkist"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/brownstar = 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "vacuum fizz can"
	desc = "Vacuum Fizz. It helps keep your cool."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/spaceup = 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "Generic lemon-lime soda."
	icon_state = "lemon-lime"
	item_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/lemon_lime = 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Silversun Wave iced tea"
	desc = "Marketed as a favorite amongst parched Silversun beachgoers, there's actually more sugar in this than there is tea."
	icon_state = "ice_tea_can"
	item_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/icetea = 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "grapesoda"
	item_state = "grapesoda"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/grapejuice = 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's tonic water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	item_state = "tonic"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/tonic = 50)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	item_state = "sodawater"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/sodawater = 50)

/obj/item/reagent_containers/food/drinks/cans/koispunch
	name = "\improper Phoron Punch!"
	desc = "A radical looking can of " + SPAN_WARNING("Phoron Punch!") + " Phoron poisoning has never been more extreme! " + SPAN_DANGER("WARNING: Phoron is toxic to non-Vaurca. Consuming this product might lead to death.")
	icon_state = "phoron_punch"
	item_state = "phoron_punch"
	center_of_mass = list("x"=16, "y"=8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/singleton/reagent/kois/clean = 10, /singleton/reagent/toxin/phoron = 5)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "getmore root beer can"
	desc = "A classic Earth drink, made from various roots."
	icon_state = "root_beer"
	item_state = "root_beer"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/root_beer = 30)

// Zo'ra Sodas
/obj/item/reagent_containers/food/drinks/cans/zorasoda
	name = "\improper Zo'ra Soda"
	desc = "A can of Zo'ra Soda energy drink, with V'krexi additives. You aren't supposed to see this."
	center_of_mass = list("x" = 16, "y" = 8)
	can_size_overrides = list("x" = 1)
	reagents_to_add = list(/singleton/reagent/drink/zorasoda = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry
	name = "\improper Zo'ra Soda Cherry"
	desc = "A can of cherry flavoured Zo'ra Soda energy drink, with V'krexi additives. All good energy drinks come in cherry."
	icon_state = "zoracherry"
	item_state = "zoracherry"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/cherry = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron
	name = "\improper Zo'ra Soda Phoron Passion"
	desc = "A can of grape flavoured Zo'ra Soda energy drink, with V'krexi additives. Tastes nothing like phoron according to Unbound vaurca taste testers."
	icon_state = "phoronpassion"
	item_state = "phoronpassion"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/phoron = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax
	name = "\improper K'laxan Energy Crush"
	desc = "A can of nitrogen-infused creamy orange zest flavoured Zo'ra Soda energy drink, with V'krexi additives. The smooth taste is engineered to near perfection."
	icon_state = "klaxancrush"
	item_state = "klaxancrush"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/klax = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur
	name = "\improper C'thur Rockin' Raspberry"
	desc = "A can of \"blue raspberry\" flavoured Zo'ra Soda energy drink, with V'krexi additives. Tastes like a more flowery and aromatic raspberry."
	icon_state = "cthurberry"
	item_state = "cthurberry"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/cthur = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass
	name = "\improper Zo'ra Sour Venom Grass"
	desc = "A can of sour \"venom grass\" flavoured Zo'ra Soda energy drink, with V'krexi additives. Tastes like a cloud of angry stinging acidic bees."
	icon_state = "sourvenomgrass"
	item_state = "sourvenomgrass"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/venomgrass = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/hozm // "Contraband"
	name = "\improper High Octane Zorane Might"
	desc = "A can of mint flavoured Zo'ra Soda energy drink, with a lot of V'krexi additives. Tastes like impaling the roof of your mouth with a freezing cold spear laced with angry bees and road salt.<br/>" + SPAN_DANGER(" WARNING: Not for the faint hearted!")
	icon_state = "hozm"
	item_state = "hozm"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/hozm = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois
	name = "\improper Zo'ra Soda K'ois Twist"
	desc = "A can of K'ois-imitation flavoured Zo'ra Soda energy drink, with V'krexi additives. Contains no K'ois, contrary to what the name may imply."
	icon_state = "koistwist"
	item_state = "koistwist"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/kois = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone
	name = "\improper Vaurca Drone Fuel"
	desc = "A can of industrial fluid flavoured Zo'ra Soda energy drink, with V'krexi additives, meant for Vaurca.<br/>" + SPAN_DANGER(" WARNING: Known to induce vomiting in all species except vaurcae and dionae!")
	icon_state = "dronefuel"
	item_state = "dronefuel"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/drone = 30)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/jelly
	name = "\improper Royal Vaurca Jelly"
	desc = "A can of..." + SPAN_ITALIC(" sludge?") + " It smells kind of pleasant either way. Royal jelly is a nutritious concentrated substance commonly created by Caretaker Vaurca in order to feed larvae. It is known to have a stimulating effect in most, if not all, species."
	icon_state = "royaljelly"
	item_state = "royaljelly"
	reagents_to_add = list(/singleton/reagent/drink/zorasoda/jelly = 30)

/obj/item/reagent_containers/food/drinks/cans/adhomai_milk
	name = "fermented fatshouters milk"
	desc = "A can of fermented fatshouters milk, imported from Adhomai."
	icon_state = "milk_can"
	item_state = "milk_can"
	center_of_mass = list("x"=16, "y"=10)
	desc_extended = "Fermend fatshouters milk is a drink that originated among the nomadic populations of Rhazar'Hrujmagh, and it has spread to the rest of Adhomai."

	reagents_to_add = list(/singleton/reagent/drink/milk/adhomai/fermented = 30)

/obj/item/reagent_containers/food/drinks/cans/beetle_milk
	name = "\improper Hakhma Milk"
	desc = "A can of Hakhma beetle milk, sourced from Scarab and Drifter communities."
	icon_state = "beetlemilk"
	item_state = "beetlemilk"
	center_of_mass = list("x"=17, "y"=10)
	reagents_to_add = list(/singleton/reagent/drink/milk/beetle = 30)
	can_size_overrides = list("x" = 1, "y" = -2)

/obj/item/reagent_containers/food/drinks/cans/dyn
	name = "Cooling Breeze"
	desc = "The most refreshing thing you can find on the market, based on a Skrell medicinal plant. No salt or sugar."
	icon_state = "dyncan"
	item_state = "dyncan"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/drink/dynjuice/cold = 30)

/obj/item/reagent_containers/food/drinks/cans/threetowns
	name = "\improper Three Towns Cider"
	desc = "A cider made on the west coast of the Moghresian Sea, this is simply one of many brands made in a region known for its craft local butanol, shipped throughout the Wasteland."
	icon_state = "three_towns_cider"
	item_state = "three_towns_cider"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/alcohol/butanol/threetownscider = 30)

/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda
	name = "Hro'zamal Soda"
	desc = "A can of Hro'zamal Soda. Made with Hro'zamal Ras'Nifs powder and canned in the People's Republic of Adhomai."
	desc_extended = "Hro'zamal Soda is a soft drink made from the seed's powder of a plant native to Hro'zamal, the sole Hadiist colony. While initially consumed as a herbal tea by the \
	colonists, it was introduced to Adhomai by the Army Expeditionary Force and transformed into a carbonated drink. The beverage is popular with factory workers and university \
	students because of its stimulant effect."
	icon_state = "hrozamal_soda"
	item_state = "hrozamal_soda"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/singleton/reagent/drink/hrozamal_soda = 30)

/obj/item/reagent_containers/food/drinks/cans/diet_cola
	name = "diet cola can"
	desc = "Comet Cola! Now in diet!"
	icon_state = "diet_cola"
	item_state = "diet_cola"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/drink/diet_cola = 30)

/obj/item/reagent_containers/food/drinks/cans/peach_soda
	name = "Xanu Rush!"
	desc = "Made from the NEW Xanu Prime peaches."
	desc_extended = "The rehabilitating environment of Xanu has allowed for small-scale agriculture to bloom. Xanu Rush! Is the number one Coalition soda, despite its dull taste."
	icon_state = "xanu_rush"
	item_state = "xanu_rush"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/drink/peach_soda = 30)

/obj/item/reagent_containers/food/drinks/cans/beer
	name = "\improper Virklunder canned beer"
	desc = "Contains only water, malt and hops. Not really as high-quality as the label says, but it's still popular. This particular line of beer is made by Getmore on New Gibson, specifically in the Ovanstad of \
	Virklund in a massive beer brewery complex. It quickly became the most consumed kind of beer across the Republic of Biesel and has since been in stock in practically every bar across the nation."
	icon_state = "space_beer"
	item_state = "space_beer"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/alcohol/beer = 40)

/obj/item/reagent_containers/food/drinks/cans/beer/rice
	name = "\improper Ebisu Super Dry"
	desc = "Konyang's favourite rice beer brand, 200 years running."
	icon_state = "ebisu"
	item_state = "ebisu"
	reagents_to_add = list(/singleton/reagent/alcohol/rice_beer = 40)

/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma
	name = "\improper Shimauma Ichiban"
	desc = "Konyang's most middling rice beer brand. Not as popular as Ebisu, but it's comfortable in second place."
	icon_state = "shimauma"
	item_state = "shimauma"

/obj/item/reagent_containers/food/drinks/cans/beer/rice/moonlabor
	name = "\improper Moonlabor Malt's"
	desc = "Konyang's underdog rice beer brand. Popular amongst New Hai Phongers, for reasons unknown."
	icon_state = "moonlabor"
	item_state = "moonlabor"

/obj/item/reagent_containers/food/drinks/cans/beer/earthmover
	name = "\improper Inverkeithing Imports Earthmover"
	desc = "Himeo's favorite brand of non-mushroom liquor, according to the 2264 Consumer's Census. Rising prices on the import of Virklunder, which held the top point for several years, are probably to blame. \
	Luckily for Himeo- and the Coalition, where it is exported under the Inverkeithing Import name- this hydroponically-grown dry stout is of a reasonably high quality."
	icon_state = "earthmover"
	item_state = "earthmover"
	reagents_to_add = list(/singleton/reagent/alcohol/ale = 40) // mushroom guinness

/obj/item/reagent_containers/food/drinks/cans/beer/whistlingforest
	name = "\improper Whistling Forest Pale Ale"
	desc = "A proud product of the All-Xanu Republic, the Whistling Forest family of pale ales boast a rich history in the coke mines of Himavat City. Tourists take it with ice; locals know better."
	desc_extended = "A Markhor Interstellar Logistics Group product. Move Mountains with Markhor!"
	icon_state = "whistlingforest"
	item_state = "whistlingforest"

/obj/item/reagent_containers/food/drinks/cans/melon_soda
	name = "Kansumi Melon Soda"
	desc = "Konyang's favourite melon soda, now available in can form!"
	icon_state = "melon_soda"
	item_state = "melon_soda"
	reagents_to_add = list(/singleton/reagent/drink/melon_soda = 30)

/obj/item/reagent_containers/food/drinks/cans/himeokvass
	name = "Dorshafen Deluxe"
	desc = "A can of Himean mushroom kvass. Non-alcoholic, unlike its Fisanduhian cousin, which makes it a workday favorite of railyard workers."
	icon_state = "dorshdeluxe"
	reagents_to_add = list(/singleton/reagent/drink/mushroom_kvass = 30)

/obj/item/reagent_containers/food/drinks/cans/galatea
	name = "Svarog Presents: Gala-Tea!"
	desc = "A Galatean energy drink, highly regarded among college students. A warning on the can notes that the maximum dosage of this beverage is forty-five units per cycle."
	icon_state = "galateadrink"
	reagents_to_add = list(/singleton/reagent/drink/galatea = 30)

/obj/item/reagent_containers/food/drinks/cans/boch
	name = "Boch Brew Berry Bounty"
	desc = "A can of Vysokan energy drink, derived from the digestive sac of the boch-zivir. This one is in the typical berry flavor."
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi' // we're not animals
	icon_state = "bochbrew"
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/singleton/reagent/drink/bochbrew = 30)

/obj/item/reagent_containers/food/drinks/cans/boch/attack(mob/living/M, mob/user, var/target_zone) // modified can reaction; have you ever seen someone crush a plastic bottle on their head?
	if(iscarbon(M) && !reagents.total_volume && user.a_intent == I_HURT && target_zone == BP_HEAD)
		if(M == user)
			user.visible_message(SPAN_WARNING("[user] smacks the bottle of [src.name] against [user.get_pronoun("his")] forehead!"), SPAN_NOTICE("You smack the bottle of [src.name] on your forehead."))
		else
			user.visible_message(SPAN_WARNING("[user] smacks the bottle of [src.name] against [M]'s forehead!"), SPAN_NOTICE("You whack the bottle of [src.name] on [M]'s forehead."))
		M.apply_damage(2,DAMAGE_BRUTE,BP_HEAD) // quoth the copy-paste code, 'ouch.'
		return TRUE
	. = ..()

/obj/item/reagent_containers/food/drinks/cans/boch/buckthorn
	name = "Boch Brew Buckthorn Buckwild"
	desc = "A can of Vysokan energy drink, derived from the digestive sac of the boch-zivir. This one is buckthorn flavored."
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi' // if it looks like a bottle it's a bottle
	icon_state = "bochbrew_buck"
	reagents_to_add = list(/singleton/reagent/drink/bochbrew/buckthorn = 30)

/obj/item/reagent_containers/food/drinks/cans/xanuchai
	name = "Brown Palace Champion Chai"
	desc = "A Xanan brand of canned chai tea. This one is the standard chai flavor."
	icon_state = "xanuchai"
	reagents_to_add = list(/singleton/reagent/drink/tea/chaitea = 30)

/obj/item/reagent_containers/food/drinks/cans/xanuchai/creme
	name = "Brown Palace Champion Chai Creme"
	desc = "A Xanan brand of canned chai tea. This one is a chai latte flavor."
	icon_state = "xanucreme"
	reagents_to_add = list(/singleton/reagent/drink/tea/chaitealatte = 30)

/obj/item/reagent_containers/food/drinks/cans/xanuchai/chocolate
	name = "Brown Palace Champion Chocolate Chai"
	desc = "A Xanan brand of canned chai tea. This one is a chocolate chai flavor."
	icon_state = "xanuchoc"
	reagents_to_add = list(/singleton/reagent/drink/tea/coco_chaitea = 30)

/obj/item/reagent_containers/food/drinks/cans/xanuchai/neapolitan
	name = "Brown Palace New Neapolitan"
	desc = "A Xanan brand of canned chai tea. This one is neapolitan flavored; vanilla, chocolate, and strawberry."
	icon_state = "xanuneap"
	reagents_to_add = list(/singleton/reagent/drink/tea/neapolitan_chaitea = 30)

