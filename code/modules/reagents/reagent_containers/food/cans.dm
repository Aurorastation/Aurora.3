/obj/item/reagent_containers/food/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	flags = 0 //starts closed
	drop_sound = 'sound/items/drop/soda.ogg'

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "space cola"
	desc = "Cola. in space."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

/obj/item/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Introduced to the vending machines by Skrellian request, this water comes straight from the Martian poles."
	icon_state = "waterbottle"
	center_of_mass = list("x"=16, "y"=8)
	drop_sound = 'sound/items/drop/food.ogg'

/obj/item/reagent_containers/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent("spacemountainwind", 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "thirteen loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent("thirteenloko", 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent("dr_gibb", 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent("brownstar", 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent("space_up", 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent("lemon_lime", 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket iced tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent("icetea", 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent("grapejuice", 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's tonic water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/toni/Initialize()
	. = ..()
	reagents.add_reagent("tonic", 50)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 50)

/obj/item/reagent_containers/food/drinks/cans/koispunch
	name = "\improper Phoron Punch!"
	desc = "A radical looking can of <span class='warning'>Phoron Punch!</span> Phoron poisoning has never been more extreme!"
	icon_state = "phoron_punch"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/koispunch/Initialize()
	. = ..()
	reagents.add_reagent("koispasteclean", 10)
	reagents.add_reagent("phoron", 5)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "\improper R&D Root Beer"
	desc = "A classic Earth drink from the United Americas province."
	icon_state = "root_beer"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/root_beer/Initialize()
	. = ..()
	reagents.add_reagent("root_beer", 30)

//zoda

/obj/item/reagent_containers/food/drinks/cans/zorasoda
	name = "\improper Zo'ra Soda Cherry"
	desc = "A can of cherry energy drink, with V'krexi additives. All good colas come in cherry."
	icon_state = "zoracherry"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zorasoda/Initialize()
	. = ..()
	reagents.add_reagent("zora_cherry", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zorakois
	name = "\improper Zo'ra Soda Kois Twist"
	desc = "A can of K'ois flavored energy drink, with V'krexi additives. Contains no K'ois, probably contains no palatable flavor."
	icon_state = "koistwist"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zorakois/Initialize()
	. = ..()
	reagents.add_reagent("zora_kois", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zoraphoron
	name = "\improper Zo'ra Soda Phoron Passion"
	desc = "A can of grape flavored energy drink, with V'krexi additives. Tastes nothing like phoron according to Unbound taste testers."
	icon_state = "phoronpassion"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zoraphoron/Initialize()
	. = ..()
	reagents.add_reagent("zora_phoron", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zorahozm
	name = "\improper High Octane Zorane Might"
	desc = "A can of fizzy, acidic energy, with plenty V'krexi additives. It tastes like the bottom of your mouth is being impaled by a freezing cold spear, a spear laced with bees and salt."
	icon_state = "hozm"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zorahozm/Initialize()
	. = ..()
	reagents.add_reagent("zora_hozm", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zoravenom
	name = "\improper Zo'ra Soda Sour Venom Grass (Diet!)"
	desc = "A diet can of Venom Grass flavored energy drink, with V'krexi additives. It still tastes like a cloud of stinging polytrinic bees, but calories are nowhere to be found."
	icon_state = "sourvenomgrass"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zoravenom/Initialize()
	. = ..()
	reagents.add_reagent("zora_venom", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zoraklax
	name = "\improper Klaxan Energy Crush"
	desc = "A can of orange cream flavored energy drink, with V'krexi additives. Engineered nearly to perfection."
	icon_state = "klaxancrush"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zoraklax/Initialize()
	. = ..()
	reagents.add_reagent("zora_klax", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zoracthur
	name = "\improper C'thur Rockin' Raspberry"
	desc = "A can of blue raspberry flavored energy drink, with V'krexi additives. You're pretty sure this was shipped by mistake, the previous K'laxan Energy Crush wrapper is still partly visible underneath the current one."
	icon_state = "cthurberry"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zoracthur/Initialize()
	. = ..()
	reagents.add_reagent("zora_cthur", 20)
	reagents.add_reagent("vaam", 15)

/obj/item/reagent_containers/food/drinks/cans/zoradrone
	name = "\improper Drone Fuel"
	desc = "A can of some kind of industrial fluid flavored energy drink, with V'krexi additives meant for Vaurca. <span class='warning'>Known to induce vomiting in humans!</span>."
	icon_state = "dronefuel"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zoradrone/Initialize()
	. = ..()
	reagents.add_reagent("zora_drone", 30)
	reagents.add_reagent("vaam", 10)

/obj/item/reagent_containers/food/drinks/cans/zorajelly
	name = "\improper Royal Jelly"
	desc = "A can of... You aren't sure, but it smells pleasant already."
	icon_state = "royaljelly"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/zorajelly/Initialize()
	. = ..()
	reagents.add_reagent("zora_jelly", 30)

/obj/item/reagent_containers/food/drinks/cans/adhomai_milk
	name = "fermented fatshouters milk"
	desc = "A can of fermented fatshouters milk, imported from Adhomai."
	icon_state = "milk_can"
	center_of_mass = list("x"=16, "y"=10)
	description_fluff = "Fermend fatshouters milk is a drink that originated among the nomadic populations of Rhazar'Hrujmagh, and it has spread to the rest of Adhomai."

/obj/item/reagent_containers/food/drinks/cans/adhomai_milk/Initialize()
	. = ..()
	reagents.add_reagent("adhomai_milk", 30)

/obj/item/reagent_containers/food/drinks/cans/beetle_milk
	name = "\improper Hakhma Milk"
	desc = "A can of Hakhma beetle milk, sourced from Scarab and Drifter communities."
	icon_state = "beetlemilk"
	center_of_mass = list("x"=17, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/beetle_milk/Initialize()
	. = ..()
	reagents.add_reagent("beetle_milk", 30)

/obj/item/reagent_containers/food/drinks/cans/dyn
	name = "Cooling Breeze"
	desc = "The most refreshing thing you can find on the market, based on a Skrell medicinal plant. No salt or sugar. "
	icon_state = "dyncan"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/dyn/Initialize()
	. = ..()
	reagents.add_reagent("dyncold", 30)

