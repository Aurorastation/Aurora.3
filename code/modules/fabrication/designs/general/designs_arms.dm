ABSTRACT_TYPE(/singleton/fabricator_recipe/armaments)
	name = "Abstract Armaments"
	category = "Armaments"

/singleton/fabricator_recipe/armaments/grenade
	name = "grenade casing"
	path = /obj/item/grenade/chem_grenade

/singleton/fabricator_recipe/armaments/grenade/large
	name = "large grenade casing"
	path = /obj/item/grenade/chem_grenade/large

/singleton/fabricator_recipe/armaments/handcuffs
	name = "handcuffs"
	path = /obj/item/handcuffs

/singleton/fabricator_recipe/armaments/flamethrower
	name = "flamethrower"
	path = /obj/item/flamethrower/full
	security_level = SEC_LEVEL_RED

/singleton/fabricator_recipe/armaments/tacknife
	name = "tactical knife"
	path = /obj/item/material/knife/tacknife
	security_level = SEC_LEVEL_RED

/singleton/fabricator_recipe/armaments/brassknuckles
	name = "brass knuckles"
	path = /obj/item/clothing/gloves/brassknuckles
	hack_only = TRUE

/singleton/fabricator_recipe/armaments/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hack_only = TRUE

/singleton/fabricator_recipe/armaments/trap
	name = "mechanical trap"
	path = /obj/item/trap
	hack_only = TRUE
