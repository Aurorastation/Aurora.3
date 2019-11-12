
#define GEM_RUBY "ruby"
#define GEM_TOPAZ "topaz"
#define GEM_SAPPHIRE "sapphire"
#define GEM_AMETHYST "amethyst"
#define GEM_EMERALD "emerald"
#define GEM_DIAMOND "diamond"
#define GEM_MIXED "gem pile"

#define GEM_SMALL "small"
#define GEM_MEDIUM "medium"
#define GEM_LARGE "large"
#define GEM_ENORMOUS "enormous"

obj/item/precious/gemstone
	name = "gemstone"
	desc = "An impossibly generic gemstone. How do you even have this?"
	icon = 'icons/obj/gemstones.dmi'
	var/gemtype
	var/gemsize
	var/stacksize = 1
	var/maxstack
	var/stack_contents = list()

obj/item/precious/gemstone/Initialize(mapload, amount)
	. = ..()
	if(amount)
		stacksize = amount

// Small gemstones

obj/item/precious/gemstone/smallruby
	name = "small ruby"
	desc = "A single red gemstone of small size."
	icon_state = "sruby_1"
	gemtype = GEM_RUBY
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 1

obj/item/precious/gemstone/smalltopaz
	name = "small topaz"
	desc = "A single yellow gemstone of small size."
	icon_state = "stopaz_1"
	gemtype = GEM_TOPAZ
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 1

obj/item/precious/gemstone/smallsapphire
	name = "small sapphire"
	desc = "A single blue gemstone of small size."
	icon_state = "ssapphire_1"
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 1

obj/item/precious/gemstone/smallamethyst
	name = "small amethyst" 
	desc = "A single purple gemstone of small size."
	icon_state = "samethyst_1"
	gemtype = GEM_AMETHYST
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 1

obj/item/precious/gemstone/smallemerald
	name = "small emerald"
	desc = "A single green gemstone of small size."
	icon_state = "semerald_1"
	gemtype = GEM_EMERALD
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 1

obj/item/precious/gemstone/smalldiamond
	name = "small diamond"
	desc = "A single colorless gemstone of small size."
	icon_state = "sdiamond_1"
	gemtype = GEM_DIAMOND
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 1

// Medium Gemstones

obj/item/precious/gemstone/medruby
	name = "medium ruby"
	desc = "A single red gemstone of medium size."
	gemtype = GEM_RUBY
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

obj/item/precious/gemstone/medtopaz
	name = "medium topaz"
	desc = "A single yellow gemstone of medium size."
	gemtype = GEM_TOPAZ
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

obj/item/precious/gemstone/medsapphire
	name = "medium sapphire"
	desc = "A single blue gemstone of medium size."
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

obj/item/precious/gemstone/medamethyst
	name = "medium amethyst"
	desc = "A single purple gemstone of medium size."
	gemtype = GEM_AMETHYST
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

obj/item/precious/gemstone/medemerald
	name = "medium emerald"
	desc = A single green gemstone of medium size.
	gemtype = GEM_EMERALD
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

obj/item/precious/gemstone/meddiamond
	name = "medium diamond"
	desc = "A single colorless gemstone of medium size."
	gemtype = GEM_DIAMOND
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 1

// Large Gemstones

obj/item/precious/gemstone/largeruby
	name = "large ruby"
	desc = "A single red gemstone of large size."
	gemtype = GEM_RUBY
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/largetopaz
	name = "large topaz"
	desc = "A single yellow gemstone of large size."
	gemtype = GEM_TOPAZ
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/largesapphire
	name = "large sapphire"
	desc = "A single blue gemstone of large size."
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/largeamethyst
	name = "large amethyst"
	desc = "A single purple gemstone of large size."
	gemtype = GEM_AMETHYST
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/largeemerald
	name = "small emerald"
	desc = "A single green gemstone of large size."
	gemtype = GEM_EMERALD
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/largediamond
	name = "large diamond"
	desc = "A single colorless gemstone of large size."
	gemtype = GEM_DIAMOND
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 1

// Enormous Gemstones

obj/item/precious/gemstone/hugeruby
	name = "enormous ruby"
	desc = "A single red gemstone of enormous size."
	gemtype = GEM_RUBY
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/hugetopaz
	name = "enormous topaz"
	desc = "A single yellow gemstone of enormous size."
	gemtype = GEM_TOPAZ
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/hugesapphire
	name = "enormous sapphire"
	desc = "A single blue gemstone of enormous size."
	gemtype = GEM_SAPPHIRE
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/hugeamethyst
	name = "enormous amethyst"
	desc = "A single purple gemstone of enormous size."
	gemtype = GEM_AMETHYST
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/hugeemerald
	name = "enormous emerald"
	desc = "A single green gemstone of enormous size."
	gemtype = GEM_EMERALD
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

obj/item/precious/gemstone/hugediamond
	name = "enormous diamond"
	desc = "A single colorless gemstone of enormous size."
	gemtype = GEM_DIAMOND
	gemsize = GEM_ENORMOUS
	maxstack = 5
	stacksize = 1

// Mixed Gem Piles

obj/item/precious/gemstone/smallmixed
	name = "small gemstone pile"
	desc = "A pile of assorted small gemstones."
	icon state - "smixed_5"
	gemtype = GEM_MIXED
	gemsize = GEM_SMALL
	maxstack = 30
	stacksize = 0

obj/item/precious/gemstone/medmixed
	name = "medium gemstone pile"
	desc = "A pile of assorted medium gemstones."
	gemtype = GEM_MIXED
	gemsize = GEM_MEDIUM
	maxstack = 15
	stacksize = 0

obj/item/precious/gemstone/largemixed
	name = "large gemstone pile"
	desc = "A pile of assorted large gemstones."
	gemtype = GEM_MIXED
	gemsize = GEM_LARGE
	maxstack = 5
	stacksize = 0
