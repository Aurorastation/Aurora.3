
#define GEM_RUBY "ruby"
#define GEM_TOPAZ "topaz"
#define GEM_SAPPHIRE "sapphire"
#define GEM_AMETHYST "amethyst"
#define GEM_EMERALD "emerald"
#define GEM_DIAMOND "diamond"
#define GEM_MIXED "mixed"

#define GEM_SMALL "small"
#define GEM_MEDIUM "medium"
#define GEM_LARGE "large"
#define GEM_ENORMOUS "enormous"

/obj/item/precious/gemstone
	name = "gemstone"
	desc = "An impossibly generic gemstone. How do you even have this?"
	icon = 'icons/obj/gemstones.dmi'
	var/gemtype
	var/gemsize
	var/stacksize = 1
	var/gemcolor
	var/maxstack
	var/stack_contents = list()
	var/pickup = 0

/obj/item/precious/gemstone/Initialize(mapload, amount)
	. = ..()
	if(amount)
		stacksize = amount
		update_gem()

/obj/item/precious/gemstone/mixed/Initialize(mapload, amount, kind)
	ASSERT(kind)
	stack_contents[kind] = amount
	. = ..(mapload, amount)

/obj/item/precious/gemstone/attackby(obj/item/precious/gemstone/G, mob/user)
	if (!istype(G))
		return ..()
	if(G.gemtype == GEM_MIXED)
		to_chat(user, span("notice", "Try doing it the other way - put an unmixed gem into the pile, instead of the pile onto an organized gem stack."))
		return
	if(src.gemsize != G.gemsize)
		to_chat(user, span("notice", "You can't mix gem sizes. It would be too disorganized!"))
		return
	if(src.gemsize == GEM_ENORMOUS)
		to_chat(user, span("notice", "That gem is far too big to stack!"))
		return
	if(src.gemtype == G.gemtype)
		gemstacker(G, user)
	else
		gemmixer(G, user)

/obj/item/precious/gemstone/proc/gemstacker(obj/item/precious/gemstone/G, mob/user)
	if(src.stacksize == src.maxstack)
		to_chat(user, span("notice", "That stack can't get any bigger!"))
		return
	else
		src.stacksize += 1
		G.stacksize -= 1 
		update_gem(G)
		G.update_gem(src)

/obj/item/precious/gemstone/proc/gemmixer(obj/item/precious/gemstone/G, mob/user)
	if(src.stacksize == src.maxstack)
		to_chat(user, span("notice", "You can't fit any more gems into that pile!"))
		return
	if(src.gemtype != GEM_MIXED)
		to_chat(user, span("notice", "You mix the gemstones together into a pile."))
		src.stacksize -= 1
		G.stacksize -= 1
		switch(gemsize)
			if(GEM_SMALL)
				var/obj/item/precious/gemstone/mixed/pile = new(loc, stacksize, gemtype)
				pile.add_gem(G)
			if(GEM_MEDIUM)
				var/obj/item/precious/gemstone/mixed/med/pile = new(loc, stacksize, gemtype)
				pile.add_gem(G)
			if(GEM_LARGE)
				var/obj/item/precious/gemstone/mixed/large/pile = new(loc, stacksize, gemtype)
				pile.add_gem(G)
	else 
		to_chat(user, span("notice", "You add the [G.gemtype] to the pile."))
		stack_contents[G.gemtype] += 1
		src.stacksize += 1
		G.stacksize -= 1
	update_gem()
	G.update_gem()


/obj/item/precious/gemstone/proc/add_gem(obj/item/precious/gemstone/G)
	stack_contents[G.gemtype] += 1
	stacksize += 1


/obj/item/precious/gemstone/proc/update_gem()
	if(src.stacksize <= 0)
		qdel(src)
		return
	if(src.gemtype == GEM_MIXED)
		switch (gemsize)
			if(GEM_SMALL)
				switch(stacksize)
					if(30)
						icon_state = "smixed_30"
					if(10 to 29)
						icon_state = "smixed_10"
					else
						icon_state = "smixed_5"
			if(GEM_MEDIUM)
				switch(stacksize)
					if(15)
						icon_state = "mmixed_10"
					else
						icon_state = "mmixed_5"
			if(GEM_LARGE)
				icon_state = "lmixed"
	else
		switch (gemsize)
			if(GEM_SMALL)
				switch (stacksize)
					if(30)
						icon_state = "s[gemtype]_30"
					if(10 to 29)
						icon_state = "s[gemtype]_10"
					if(5 to 9)
						icon_state = "s[gemtype]_5"
					else
						icon_state = "s[gemtype]_[stacksize]"
			if(GEM_MEDIUM)
				switch (stacksize)
					if(15)
						icon_state = "m[gemtype]_10"
					if(5 to 14)
						icon_state = "m[gemtype]_5"
					else
						icon_state = "m[gemtype]_[stacksize]"
			if(GEM_LARGE)
				icon_state = "l[gemtype]_[stacksize]"
		updatedesc()

/obj/item/precious/gemstone/proc/updatedesc()
	if(src.stacksize == 1)
		desc = "A single [gemcolor] gemstone of [gemsize] size"
		return 
	if(src.gemtype != GEM_MIXED)
		desc = "A pile of [gemsize] [gemcolor] gemstones. There are [stacksize] gems in the pile."
	else 
		desc = "A colorful pile of assorted [gemsize] gleaming gemstones. There are [stacksize] gems in the pile."

var/list/gemtype2type = list(
	GEM_RUBY = list(
		GEM_SMALL = /obj/item/precious/gemstone/ruby, 
		GEM_MEDIUM = /obj/item/precious/gemstone/ruby/med, 
		GEM_LARGE = /obj/item/precious/gemstone/ruby/large), 
	GEM_AMETHYST = list(
		GEM_SMALL = /obj/item/precious/gemstone/amethyst, 
		GEM_MEDIUM = /obj/item/precious/gemstone/amethyst/med, 
		GEM_LARGE = /obj/item/precious/gemstone/amethyst/large), 
	GEM_TOPAZ = list(
		GEM_SMALL = /obj/item/precious/gemstone/topaz, 
		GEM_MEDIUM = /obj/item/precious/gemstone/topaz/med, 
		GEM_LARGE = /obj/item/precious/gemstone/topaz/large), 
	GEM_DIAMOND = list(
		GEM_SMALL = /obj/item/precious/gemstone/diamond, 
		GEM_MEDIUM = /obj/item/precious/gemstone/diamond/med, 
		GEM_LARGE = /obj/item/precious/gemstone/diamond/large), 
	GEM_EMERALD = list (
		GEM_SMALL = /obj/item/precious/gemstone/emerald, 
		GEM_MEDIUM = /obj/item/precious/gemstone/emerald/med, 
		GEM_LARGE = /obj/item/precious/gemstone/emerald/large), 
	GEM_SAPPHIRE = list(
		GEM_SMALL = /obj/item/precious/gemstone/sapphire, 
		GEM_MEDIUM = /obj/item/precious/gemstone/sapphire/med, 
		GEM_LARGE = /obj/item/precious/gemstone/sapphire/large))


/obj/item/precious/gemstone/mixed/verb/separate_pile()
	set name = "Separate Pile"
	set category = "Object"
	set src in view(1)

	for (var/gtype in stack_contents)
		var/realtype = global.gemtype2type[gtype][gemsize]
		new realtype(loc, stack_contents[gtype])
	to_chat(usr, span("notice", "You separate the gemstone pile into neat, organized stacks of similar gems."))
	qdel(src)

// Small gemstones

/obj/item/precious/gemstone/ruby
	name = "small ruby"
	desc = "A single red gemstone of small size."
	icon_state = "sruby_1"
	gemtype = GEM_RUBY
	gemsize = GEM_SMALL
	gemcolor = "red"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/topaz
	name = "small topaz"
	desc = "A single yellow gemstone of small size."
	icon_state = "stopaz_1"
	gemtype = GEM_TOPAZ
	gemsize = GEM_SMALL
	gemcolor = "yellow"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/sapphire
	name = "small sapphire"
	desc = "A single blue gemstone of small size."
	icon_state = "ssapphire_1"
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_SMALL
	gemcolor = "blue"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/amethyst
	name = "small amethyst" 
	desc = "A single purple gemstone of small size."
	icon_state = "samethyst_1"
	gemtype = GEM_AMETHYST
	gemsize = GEM_SMALL
	gemcolor = "purple"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/emerald
	name = "small emerald"
	desc = "A single green gemstone of small size."
	icon_state = "semerald_1"
	gemtype = GEM_EMERALD
	gemsize = GEM_SMALL
	gemcolor = "green"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/diamond
	name = "small diamond"
	desc = "A single colorless gemstone of small size."
	icon_state = "sdiamond_1"
	gemtype = GEM_DIAMOND
	gemsize = GEM_SMALL
	gemcolor = "colorless"
	maxstack = 30
	stacksize = 1

// Medium Gemstones

/obj/item/precious/gemstone/ruby/med
	name = "medium ruby"
	desc = "A single red gemstone of medium size."
	icon_state = "mruby_1"
	gemtype = GEM_RUBY
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

/obj/item/precious/gemstone/topaz/med
	name = "medium topaz"
	desc = "A single yellow gemstone of medium size."
	icon_state = "mtopaz_1"
	gemtype = GEM_TOPAZ
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

/obj/item/precious/gemstone/sapphire/med
	name = "medium sapphire"
	desc = "A single blue gemstone of medium size."
	icon_state = "msapphire_1"
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

/obj/item/precious/gemstone/amethyst/med
	name = "medium amethyst"
	desc = "A single purple gemstone of medium size."
	icon_state = "mamethyst_1"
	gemtype = GEM_AMETHYST
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

/obj/item/precious/gemstone/emerald/med
	name = "medium emerald"
	desc = "A single green gemstone of medium size."
	icon_state = "memerald_1"
	gemtype = GEM_EMERALD
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

/obj/item/precious/gemstone/diamond/med
	name = "medium diamond"
	desc = "A single colorless gemstone of medium size."
	icon_state = "mdiamond_1"
	gemtype = GEM_DIAMOND
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

// Large Gemstones

/obj/item/precious/gemstone/ruby/large
	name = "large ruby"
	desc = "A single red gemstone of large size."
	icon_state = "lruby_1"
	gemtype = GEM_RUBY
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/topaz/large
	name = "large topaz"
	desc = "A single yellow gemstone of large size."
	icon_state = "ltopaz_1"
	gemtype = GEM_TOPAZ
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/sapphire/large
	name = "large sapphire"
	desc = "A single blue gemstone of large size."
	icon_state = "lsapphire_1"
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/amethyst/large
	name = "large amethyst"
	desc = "A single purple gemstone of large size."
	icon_state = "lamethyst_1"
	gemtype = GEM_AMETHYST
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/emerald/large
	name = "large emerald"
	desc = "A single green gemstone of large size."
	icon_state = "lemerald_1"
	gemtype = GEM_EMERALD
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/diamond/large
	name = "large diamond"
	desc = "A single colorless gemstone of large size."
	icon_state = "ldiamond_1"
	gemtype = GEM_DIAMOND
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

// Enormous Gemstones

/obj/item/precious/gemstone/ruby/huge
	name = "enormous ruby"
	desc = "A single red gemstone of enormous size."
	icon_state = "eruby"
	gemtype = GEM_RUBY
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/topaz/huge
	name = "enormous topaz"
	desc = "A single yellow gemstone of enormous size."
	icon_state = "etopaz"
	gemtype = GEM_TOPAZ
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/sapphire/huge
	name = "enormous sapphire"
	desc = "A single blue gemstone of enormous size."
	icon_state = "esapphire"
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/amethyst/huge
	name = "enormous amethyst"
	desc = "A single purple gemstone of enormous size."
	icon_state = "eamethyst"
	gemtype = GEM_AMETHYST
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/emerald/huge
	name = "enormous emerald"
	desc = "A single green gemstone of enormous size."
	icon_state = "eemerald"
	gemtype = GEM_EMERALD
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

/obj/item/precious/gemstone/diamond/huge
	name = "enormous diamond"
	desc = "A single colorless gemstone of enormous size."
	icon_state = "ediamond"
	gemtype = GEM_DIAMOND
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

// Temporary treasure hunt space - to be deleted after someone finds the first enormous gemstone

/obj/item/precious/gemstone/ruby/huge/pickup(mob/living/user)
	if(src.pickup == 0)
		to_chat(world, "<span style='color: green;'><i>[usr.name] has found the first ever enormous gemstone - a huge ruby! You should inform Kaedwuff OOC for a surprise.</i></span>")
		src.pickup = 1

/obj/item/precious/gemstone/sapphire/huge/pickup(mob/living/user)
	if(src.pickup == 0)
		to_chat(world, "<span style='color: green;'><i>[usr.name] has found the first ever enormous gemstone - a huge sapphire! You should inform Kaedwuff OOC for a surprise.</i></span>")
		src.pickup = 1

/obj/item/precious/gemstone/topaz/huge/pickup(mob/living/user)
	if(src.pickup == 0)
		to_chat(world, "<span style='color: green;'><i>[usr.name] has found the first ever enormous gemstone - a huge topaz! You should inform Kaedwuff OOC for a surprise.</i></span>")
		src.pickup = 1

/obj/item/precious/gemstone/diamond/huge/pickup(mob/living/user)
	if(src.pickup == 0)
		to_chat(world, "<span style='color: green;'><i>[usr.name] has found the first ever enormous gemstone - a huge diamond! You should inform Kaedwuff OOC for a surprise.</i></span>")
		src.pickup = 1

/obj/item/precious/gemstone/amethyst/huge/pickup(mob/living/user)
	if(src.pickup == 0)
		to_chat(world, "<span style='color: green;'><i>[usr.name] has found the first ever enormous gemstone - a huge amethyst! You should inform Kaedwuff OOC for a surprise.</i></span>")
		src.pickup = 1

/obj/item/precious/gemstone/emerald/huge/pickup(mob/living/user)
	if(src.pickup == 0)
		to_chat(world, "<span style='color: green;'><i>[usr.name] has found the first ever enormous gemstone - a huge emerald! You should inform Kaedwuff OOC for a surprise.</i></span>")
		src.pickup = 1

// Mixed Gem Piles

/obj/item/precious/gemstone/mixed
	name = "small gemstone pile"
	desc = "A pile of assorted small gemstones."
	icon_state = "smixed_5"
	gemtype = GEM_MIXED
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 0

/obj/item/precious/gemstone/mixed/med
	name = "medium gemstone pile"
	desc = "A pile of assorted medium gemstones."
	gemtype = GEM_MIXED
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 0

/obj/item/precious/gemstone/mixed/large
	name = "large gemstone pile"
	desc = "A pile of assorted large gemstones."
	gemtype = GEM_MIXED
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 0

/turf/simulated/mineral/proc/findgem(loc)
	if(prob(95))
		spawnsmallgem()
	else 
		if(prob(99))
			spawnmediumgem()
		else 
			if (prob (95))
				spawnlargegem()
			else 
				spawnhugegem()

/turf/simulated/mineral/proc/spawnsmallgem(loc)
	if(prob(75))
		var/picked = pick(/obj/item/precious/gemstone/ruby, /obj/item/precious/gemstone/topaz, /obj/item/precious/gemstone/sapphire, /obj/item/precious/gemstone/amethyst, /obj/item/precious/gemstone/diamond, /obj/item/precious/gemstone/emerald)
		new picked(loc)
		visible_message(span("notice", "A tiny, glittering gemstone was in the rubble!"))
	else
		var/picked = pick(/obj/item/precious/gemstone/ruby, /obj/item/precious/gemstone/topaz, /obj/item/precious/gemstone/sapphire, /obj/item/precious/gemstone/amethyst, /obj/item/precious/gemstone/diamond, /obj/item/precious/gemstone/emerald)
		new picked(loc, 2)
		visible_message(span("notice", "A couple tiny, glittering gemstones were in the rubble! Lucky!"))

/turf/simulated/mineral/proc/spawnmediumgem(loc)
	var/picked = pick(/obj/item/precious/gemstone/ruby/med, /obj/item/precious/gemstone/topaz/med, /obj/item/precious/gemstone/sapphire/med, /obj/item/precious/gemstone/amethyst/med, /obj/item/precious/gemstone/diamond/med, /obj/item/precious/gemstone/emerald/med)
	new picked(loc)
	visible_message(span("notice", "You found a small gemstone in the rubble! Nice!"))

/turf/simulated/mineral/proc/spawnlargegem(loc)
	var/picked = pick(/obj/item/precious/gemstone/ruby/large, /obj/item/precious/gemstone/topaz/large, /obj/item/precious/gemstone/sapphire/large, /obj/item/precious/gemstone/amethyst/large, /obj/item/precious/gemstone/diamond/large, /obj/item/precious/gemstone/emerald/large)
	new picked(loc)
	visible_message(span("notice", "There was sizable gemstone in the rubble! Wow!"))

/turf/simulated/mineral/proc/spawnhugegem(loc)
	if(prob(80))
		var/picked = pick(/obj/item/precious/gemstone/ruby/large, /obj/item/precious/gemstone/topaz/large, /obj/item/precious/gemstone/sapphire/large, /obj/item/precious/gemstone/amethyst/large, /obj/item/precious/gemstone/diamond/large, /obj/item/precious/gemstone/emerald/large)
		new picked(loc, rand(2,5))
		visible_message(span("danger", "There is a loud crunching sound and you watch in horror as a enormous gemstone that had been embedded in the rock fractures into pieces."))
		visible_message(span("notice", "Well, that was unlucky... at least the fragments are worth something, though..."))
	else 
		var/picked = pick(/obj/item/precious/gemstone/ruby/large, /obj/item/precious/gemstone/topaz/large, /obj/item/precious/gemstone/sapphire/large, /obj/item/precious/gemstone/amethyst/large, /obj/item/precious/gemstone/diamond/large, /obj/item/precious/gemstone/emerald/large)
		new picked(loc, rand(2,5))
		visible_message("<span style='color: green;'><i><em>An enormous gemstone tumbles out of the rubble, somehow managing to survive the destruction of the rock it was hidden in. Holy shit - this thing is larger than your head! You're going to be rich if you can get hold of that!</em></i></span>")
