var/global/list/generic_fishing_rare_list = list(
                /mob/living/simple_animal/fish/koi = 3
				)

var/global/list/generic_fishing_uncommon_list = list(
				/mob/living/simple_animal/fish/salmon = 6,
				/mob/living/simple_animal/fish/pike = 10,
				)

var/global/list/generic_fishing_common_list = list(
				/mob/living/simple_animal/fish/bass = 10,
				/mob/living/simple_animal/fish/trout = 8,
				/mob/living/simple_animal/fish/perch = 6,
				/mob/living/simple_animal/crab = 1
				)

var/global/list/generic_fishing_junk_list = list(
				/obj/item/clothing/shoes/cowboy = 1,
				/obj/random/fishing_junk = 10
				)

var/global/list/generic_fishing_misc_list = list(
				/obj/item/bikehorn/rubberducky = 5,
				/obj/item/toy/plushie/carp = 20,
				/obj/random/junk = 80,
				/obj/item/spacecash/c1 = 10,
				/obj/item/spacecash/c10 = 5,
				/obj/item/spacecash/c100 = 1
				)

#define FISHING_RARE     "rare"
#define FISHING_UNCOMMON "uncommon"
#define FISHING_COMMON   "common"
#define FISHING_JUNK     "junk"
#define FISHING_MISC	 "miscellaneous"
#define FISHING_NOTHING  "nothing"

var/global/list/generic_fishing_chance_list = list(
				FISHING_RARE = 5,
				FISHING_UNCOMMON = 15,
				FISHING_COMMON = 30,
				FISHING_JUNK = 30,
				FISHING_MISC = 30,
				FISHING_NOTHING = 40
				)

/obj/structure/sink/puddle/fishable
	var/has_fish = TRUE

	var/list/rare_fish_list	// Rare list.

	var/list/uncommon_fish_list	// Uncommon list.

	var/list/common_fish_list	// Common list.

	var/list/junk_list	// Junk item list.

	var/list/fishing_loot	// Chance list.

	var/fishing_cooldown = 30 SECONDS
	var/last_fished = 0

	var/fish_type
	var/min_fishing_time = 30	// Time in seconds.
	var/max_fishing_time = 90

	var/being_fished = FALSE

/obj/structure/sink/puddle/fishable/proc/handle_fish()
	if(has_fish)
		rare_fish_list = generic_fishing_rare_list
		uncommon_fish_list = generic_fishing_uncommon_list
		common_fish_list = generic_fishing_common_list
		junk_list = generic_fishing_junk_list
		fishing_loot = generic_fishing_chance_list

/obj/structure/sink/puddle/fishable/proc/pick_fish()
	if(has_fish)
		var/table = pickweight(fishing_loot)
		if(table == FISHING_RARE && rare_fish_list.len)
			fish_type = pickweight(rare_fish_list)
		else if(table == FISHING_UNCOMMON && uncommon_fish_list.len)
			fish_type = pickweight(uncommon_fish_list)
		else if(table == FISHING_COMMON && common_fish_list.len)
			fish_type = pickweight(common_fish_list)
		else if(table == FISHING_JUNK && junk_list.len)
			fish_type = pickweight(junk_list)
		else
			fish_type = null
	else
		fish_type = null

/obj/structure/sink/puddle/fishable/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/material/fishing_rod) && !being_fished && !busy)
		var/obj/item/material/fishing_rod/R = P
		if(R.cast)
			to_chat(user, "<span class='notice'>You can only cast one line at a time!</span>")
			return
		playsound(src, 'sound/effects/slosh.ogg', 5, 1, 5)
		to_chat(user,"You cast \the [P.name] into \the [src].")
		being_fished = TRUE
		R.cast = TRUE
		var/fishing_time = rand(min_fishing_time SECONDS,max_fishing_time SECONDS)
		if(do_after(user,fishing_time,user))
			playsound(src, 'sound/effects/slosh.ogg', 5, 1, 5)
			icon_state = "puddle-splash"
			update_icon()
			to_chat(user,"<span class='notice'>You feel a tug and begin pulling!</span>")
			if(world.time >= last_fished + fishing_cooldown)
				pick_fish()
				last_fished = world.time
			else
				fish_type = null
			//List of possible outcomes.
			if(!fish_type)
				to_chat(user,"<span class='filter_notice'>You caught... nothing. How sad.</span>")
			else
				var/fished = new fish_type(get_turf(user))
				if(isliving(fished))
					R.consume_bait()
					var/mob/living/L = fished
					if(prob(33))	// Dead on hook. Good for food, not so much for live catch.
						L.death()
				to_chat(user,"<span class='notice'>You fish out \the [fished] from the water with [P.name]!</span>")
		R.cast = FALSE
		being_fished = FALSE
		icon_state = "puddle"
		update_icon()
	else ..()

/obj/random/fishing_junk
	name = "junk"
	desc = "This is a random fishing junk item."
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "red"

/obj/random/fishing_junk/item_to_spawn()
	return pickweight(list(
	/obj/random/powercell = 30,
	/obj/random/plushie = 30,
	/obj/random/contraband = 20,
	/obj/random/coin = 20,
	/obj/random/action_figure = 15,
	))

#undef FISHING_RARE
#undef FISHING_UNCOMMON
#undef FISHING_COMMON
#undef FISHING_JUNK
#undef FISHING_NOTHING
