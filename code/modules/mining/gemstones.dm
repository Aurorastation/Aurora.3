
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

/obj/item/precious
	name = "valuable object"
	desc = "An object of value, made of crystallized coder tears."
	var/maxstack
	var/stack_contents = list()
	var/pickup = 0
	var/stacksize = 1
	var/plural

/obj/item/precious/gemstone
	name = "gemstone"
	desc = "An impossibly generic gemstone. How do you even have this?"
	icon = 'icons/obj/gemstones.dmi'
	var/gemcolor
	var/gemtype
	var/gemsize

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

/obj/item/precious/gemstone/AltClick(mob/user)
	if(src.gemsize == GEM_ENORMOUS)
		user.put_in_hands(src)
		return
	if(src.stacksize == 1) // just pick it up...
		user.put_in_hands(src)
		return
	if(src.gemtype == GEM_MIXED)
		to_chat(user, span("notice", "Try disassembling the whole stack instead, if you want to separate it."))
		return
	else
		to_chat(user, span("notice", "You take a [src.gemsize] [src.gemtype] from the pile."))
		src.stacksize -= 1
		src.update_gem()
		var/obj/O = new type(loc, 1)
		user.put_in_hands(O)
		src.update_gem()

/obj/item/precious/gemstone/attack_self(mob/user)
	. = ..()
	if(src.gemsize == GEM_ENORMOUS)
		user.visible_message(span("notice", "[user] admires the sparkling facets of [src]."),
		span("notice", "You gaze into the sparkling facets of [src.name]. Hypnotically beautiful..."))
		return 
	switch (stacksize)
		if(1)
			user.visible_message(span("notice", "[user] flips [src] in one hand."),
			span("notice", "You give [src] a little flip. Shiny!"))
			return 
		if(1 to 5)
			user.visible_message(span("notice", "[user] sifts [src] through their fingers, admiring the gleaming gemstones."),
			span("notice", "You sift [src] through your fingers. Glittery..."),
			span("notice", "You hear soft clinking."))
			return 
		if(6 to 10)
			user.visible_message(span("notice", "[user] counts [src], looking pleased with their bounty."),
			span("notice", "You count [src]. Yep, still [stacksize] gems in the pile!"),
			span("notice", "You hear soft clinking."))
			return 
		if(11 to 30)
			user.visible_message(span("notice", "[user] begins counting [src], looking extremely pleased."),
			span("notice", "You start counting [src]. 1... 2... 3..."),
			span("notice", "You hear soft clinking."))
			if(do_after(5))
				to_chat(user, span("notice", "You finish counting. There's still [stacksize] gems in the pile. Hurray!"))
			else
				to_chat(user, span("notice", "You lost your count of [src]!"))

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
		qdel(src)
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
		name = "[gemsize] [gemtype]"
		desc = "A single [gemcolor] gemstone of [gemsize] size"
		return 
	if(src.gemtype != GEM_MIXED)
		switch(stacksize)
			if(2 to 5)
				name = "[gemsize] [plural]"
				desc = "Several [gemsize] [gemcolor] gemstones. There are [stacksize] gems."
			if(5 to 14)
				name = "pile of [gemsize] [plural]"
				desc = "A pile of [gemsize] [gemcolor] gemstones, stacked into a pile. There are [stacksize] gems in the pile."
			if(15 to 30)
				name = "heap of [gemsize] [plural]"
				desc = "A hefty stack of [gemsize] [gemcolor] gemstones, heaped into a mass of glittering wealth. There are [stacksize] gems in the pile."
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
		new realtype(get_turf(loc), stack_contents[gtype])
	to_chat(usr, span("notice", "You separate the gemstone pile into neat, organized stacks of similar gems."))
	qdel(src)

// Small gemstones

/obj/item/precious/gemstone/ruby
	name = "small ruby"
	desc = "A single red gemstone of small size."
	icon_state = "sruby_1"
	gemtype = GEM_RUBY
	gemsize = GEM_SMALL
	plural = "rubies"
	gemcolor = "red"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/topaz
	name = "small topaz"
	desc = "A single yellow gemstone of small size."
	icon_state = "stopaz_1"
	gemtype = GEM_TOPAZ
	gemsize = GEM_SMALL
	plural = "topazes"
	gemcolor = "yellow"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/sapphire
	name = "small sapphire"
	desc = "A single blue gemstone of small size."
	icon_state = "ssapphire_1"
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_SMALL		
	plural = "sapphires"
	gemcolor = "blue"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/amethyst
	name = "small amethyst" 
	desc = "A single purple gemstone of small size."
	icon_state = "samethyst_1"
	gemtype = GEM_AMETHYST
	gemsize = GEM_SMALL	
	plural = "amethysts"
	gemcolor = "purple"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/emerald
	name = "small emerald"
	desc = "A single green gemstone of small size."
	icon_state = "semerald_1"
	gemtype = GEM_EMERALD
	gemsize = GEM_SMALL
	plural = "emeralds"
	gemcolor = "green"
	maxstack = 30
	stacksize = 1

/obj/item/precious/gemstone/diamond
	name = "small diamond"
	desc = "A single colorless gemstone of small size."
	icon_state = "sdiamond_1"
	gemtype = GEM_DIAMOND
	gemsize = GEM_SMALL
	plural = "diamonds"
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

/obj/item/precious/gemstone/pickup(mob/living/user)
	if(src.gemsize != GEM_ENORMOUS)
		return
	if(src.pickup == 0)
		to_chat(user, "<span style='color: green;'><i>As you struggle to pick up [src.name], you realize this might possibly be the most valuable object you will ever hold in your life. Can you even put a value on a gemstone this large?</i></span>")
		log_and_message_admins ("[user.name] has found the first enormous gemstone, \a [src.gemtype]. Please inform Kaedwuff about this, he has plans to give them a surprise.")
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

/turf/simulated/mineral/proc/findgem()
	if(prob(95))
		spawnsmallgem()
	else
		if(prob(99))
			spawnmediumgem()
		else
			if(prob(95))
				spawnlargegem()
			else
				spawnhugegem()

/turf/simulated/mineral/proc/spawnsmallgem()
	if(prob(75))
		if(prob(80))
			var/picked = pick(/obj/item/precious/gemstone/ruby, /obj/item/precious/gemstone/topaz, /obj/item/precious/gemstone/sapphire, /obj/item/precious/gemstone/amethyst, /obj/item/precious/gemstone/emerald)
			new picked(src)
			visible_message(span("notice", "A tiny, glittering gemstone was in the rubble!"))
		else
			new /obj/item/precious/gemstone/diamond(src)
			visible_message(span("notice", "A tiny, glittering diamond was in the rubble! Shiny!"))
	
	else
		if(prob(80))
			var/picked = pick(/obj/item/precious/gemstone/ruby, /obj/item/precious/gemstone/topaz, /obj/item/precious/gemstone/sapphire, /obj/item/precious/gemstone/amethyst, /obj/item/precious/gemstone/emerald)
			new picked(src, 2)
			visible_message(span("notice", "A couple tiny, glittering gemstones were in the rubble! Lucky!"))
		else
			new /obj/item/precious/gemstone/diamond(src)
			visible_message(span("notice", "A couple tiny, glittering diamonds were in the rubble! Sweet!"))

/turf/simulated/mineral/proc/spawnmediumgem()
	if(prob(80))
		var/picked = pick(/obj/item/precious/gemstone/ruby/med, /obj/item/precious/gemstone/topaz/med, /obj/item/precious/gemstone/sapphire/med, /obj/item/precious/gemstone/amethyst/med, /obj/item/precious/gemstone/emerald/med)
		new picked(src)
		visible_message(span("notice", "You found a small gemstone in the rubble! Nice!"))
	else
		new /obj/item/precious/gemstone/diamond/med(src)
		visible_message(span("notice", "You found a small diamond in the rubble! Yeehaw!"))

/turf/simulated/mineral/proc/spawnlargegem()
	var/picked = pick(/obj/item/precious/gemstone/ruby/large, /obj/item/precious/gemstone/topaz/large, /obj/item/precious/gemstone/sapphire/large, /obj/item/precious/gemstone/amethyst/large, /obj/item/precious/gemstone/diamond/large, /obj/item/precious/gemstone/emerald/large)
	new picked(src)
	visible_message(span("notice", "There was sizable gemstone in the rubble! Wow!"))

/turf/simulated/mineral/proc/spawnhugegem()
	if(prob(90))
		var/picked = pick(/obj/item/precious/gemstone/ruby/large, /obj/item/precious/gemstone/topaz/large, /obj/item/precious/gemstone/sapphire/large, /obj/item/precious/gemstone/amethyst/large, /obj/item/precious/gemstone/diamond/large, /obj/item/precious/gemstone/emerald/large)
		new picked(src, rand(2,5))
		visible_message(span("danger", "There is a loud crunching sound and you watch in horror as a enormous gemstone that had been embedded in the rock fractures into pieces."))
		visible_message(span("notice", "Well, that was unlucky... at least the fragments are worth something, though..."))
	else
		var/picked = pick(/obj/item/precious/gemstone/ruby/huge, /obj/item/precious/gemstone/topaz/huge, /obj/item/precious/gemstone/sapphire/huge, /obj/item/precious/gemstone/amethyst/huge, /obj/item/precious/gemstone/diamond/huge, /obj/item/precious/gemstone/emerald/huge)
		new picked(src)
		visible_message("<span style='color: green;'><i><em>An enormous gemstone tumbles out of the rubble, somehow managing to survive the destruction of the rock it was hidden in. Holy shit - this thing is larger than your head! You're going to be rich if you can get hold of that!</em></i></span>")

/turf/simulated/mineral/proc/spawndiamond()
	if(prob(95))
		spawnsmalldiamond()
	else
		if(prob(99))
			spawnmediumdiamond()
		else
			if(prob(95))
				spawnlargediamond()
			else
				spawnhugediamond()

/turf/simulated/mineral/proc/spawnsmalldiamond()
	if(prob(75))
		new /obj/item/precious/gemstone/diamond(src)
		visible_message(span("notice", "There was also a tiny, glittering higher quality diamond among the rubble!"))
	else
		new /obj/item/precious/gemstone/diamond(src, 2)
		visible_message(span("notice", "A couple of tiny higher quality diamonds were also among the rubble! Lucky!"))

/turf/simulated/mineral/proc/spawnmediumdiamond()
	new /obj/item/precious/gemstone/diamond/med(src)
	visible_message(span("notice", "A small higher quality diamond was also in the rubble! Nice!"))

/turf/simulated/mineral/proc/spawnlargediamond()
	new /obj/item/precious/gemstone/diamond/large(src)
	visible_message(span("notice", "A sizable higher quality diamond was in the rubble! Wow!"))

/turf/simulated/mineral/proc/spawnhugediamond()
	if(prob(90))
		new /obj/item/precious/gemstone/diamond/large(src, rand(2,5))
		visible_message(span("danger", "There is a loud crunching sound and you watch in horror as a enormous diamond that had been embedded in the rock fractures into pieces."))
		visible_message(span("notice", "Well, that was unlucky... at least the fragments are worth something, though..."))
	else
		new /obj/item/precious/gemstone/diamond/huge(src)
		visible_message("<span style='color: green;'><i><em>You find an enormous diamond in the rubble that managed to survive the destruction of the rock it was hidden in. Holy shit - this thing is larger than your head! You're going to be rich if you can get hold of that!</em></i></span>")
