// Precious objects and materials.

/datum/export/precious/gemstone/smallruby
	cost = 50
	unit_name = "small ruby"
	export_types = list(/obj/item/precious/gemstone/ruby)

/datum/export/precious/gemstone/smallsapphire
	cost = 50
	unit_name = "small sapphire"
	export_types = list(/obj/item/precious/gemstone/sapphire)

/datum/export/precious/gemstone/smallemerald
	cost = 50
	unit_name = "small emerald"
	export_types = list(/obj/item/precious/gemstone/emerald)

/datum/export/precious/gemstone/smalltopaz
	cost = 50
	unit_name = "small topaz"
	export_types = list(/obj/item/precious/gemstone/topaz)

/datum/export/precious/gemstone/smallamethyst
	cost = 50
	unit_name = "small amethyst"
	export_types = list(/obj/item/precious/gemstone/amethyst)

/datum/export/precious/gemstone/smalldiamond
	cost = 75
	unit_name = "small diamond"
	export_types = list(/obj/item/precious/gemstone/diamond)

/datum/export/precious/gemstone/medruby
	cost = 250
	unit_name = "medium ruby"
	export_types = list(/obj/item/precious/gemstone/ruby/med)

/datum/export/precious/gemstone/medsapphire
	cost = 250
	unit_name = "medium sapphire"
	export_types = list(/obj/item/precious/gemstone/sapphire/med)

/datum/export/precious/gemstone/medemerald
	cost = 250
	unit_name = "medium emerald"
	export_types = list(/obj/item/precious/gemstone/emerald/med)

/datum/export/precious/gemstone/medtopaz
	cost = 250
	unit_name = "medium topaz"
	export_types = list(/obj/item/precious/gemstone/topaz/med)

/datum/export/precious/gemstone/medamethyst
	cost = 250
	unit_name = "medium amethyst"
	export_types = list(/obj/item/precious/gemstone/amethyst/med)

/datum/export/precious/gemstone/meddiamond
	cost = 375
	unit_name = "medium diamond"
	export_types = list(/obj/item/precious/gemstone/diamond/med)

/datum/export/precious/gemstone/largeruby
	cost = 1500
	unit_name = "large ruby"
	export_types = list(/obj/item/precious/gemstone/ruby/large)

/datum/export/precious/gemstone/largesapphire
	cost = 1500
	unit_name = "large sapphire"
	export_types = list(/obj/item/precious/gemstone/sapphire/large)

/datum/export/precious/gemstone/largeemerald
	cost = 1500
	unit_name = "large emerald"
	export_types = list(/obj/item/precious/gemstone/emerald/large)

/datum/export/precious/gemstone/largetopaz
	cost = 1500
	unit_name = "large topaz"
	export_types = list(/obj/item/precious/gemstone/topaz/large)

/datum/export/precious/gemstone/largeamethyst
	cost = 1500
	unit_name = "large amethyst"
	export_types = list(/obj/item/precious/gemstone/amethyst/large)

/datum/export/precious/gemstone/largediamond
	cost = 2250
	unit_name = "large diamond"
	export_types = list(/obj/item/precious/gemstone/diamond/large)

/datum/export/precious/gemstone/hugeruby
	cost = 25000
	unit_name = "enormous ruby"
	export_types = list(/obj/item/precious/gemstone/ruby/huge)

/datum/export/precious/gemstone/largesapphire
	cost = 25000
	unit_name = "enormous sapphire"
	export_types = list(/obj/item/precious/gemstone/sapphire/huge)

/datum/export/precious/gemstone/largeemerald
	cost = 25000
	unit_name = "enormous emerald"
	export_types = list(/obj/item/precious/gemstone/emerald/huge)

/datum/export/precious/gemstone/largetopaz
	cost = 25000
	unit_name = "enormous topaz"
	export_types = list(/obj/item/precious/gemstone/topaz/huge)

/datum/export/precious/gemstone/largeamethyst
	cost = 25000
	unit_name = "enormous amethyst"
	export_types = list(/obj/item/precious/gemstone/amethyst/huge)

/datum/export/precious/gemstone/largediamond
	cost = 37500
	unit_name = "enormous diamond"
	export_types = list(/obj/item/precious/gemstone/diamond/huge)

/obj/item/precious/gemstone/Value(var/base)
    return base * stacksize