/obj/item/reagent_containers/food/drinks/cans
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
			user.visible_message(SPAN_WARNING("[user] crushes the can of [src.name] on [user.get_pronoun(1)] forehead!"), SPAN_NOTICE("You crush the can of [src.name] on your forehead."))
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

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "space cola"
	desc = "Cola. in space."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/datum/reagent/drink/space_cola = 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/spacemountainwind = 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "thirteen loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/alcohol/ethanol/thirteenloko = 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/dr_gibb = 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/brownstar = 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/spaceup = 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/lemon_lime = 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket iced tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/icetea = 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "grapesoda"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/grapejuice = 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's tonic water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/tonic = 50)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/sodawater = 50)

/obj/item/reagent_containers/food/drinks/cans/koispunch
	name = "\improper Phoron Punch!"
	desc = "A radical looking can of <span class='warning'>Phoron Punch!</span> Phoron poisoning has never been more extreme!"
	icon_state = "phoron_punch"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/kois/clean = 10, /datum/reagent/toxin/phoron = 5)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "\improper R&D Root Beer"
	desc = "A classic Earth drink from the United Americas province."
	icon_state = "root_beer"
	center_of_mass = list("x"=16, "y"=10)

	reagents_to_add = list(/datum/reagent/drink/root_beer = 30)

//zoda

/obj/item/reagent_containers/food/drinks/cans/zorasoda
	name = "\improper Zo'ra Soda Cherry"
	desc = "A can of cherry energy drink, with V'krexi additives. All good colas come in cherry."
	icon_state = "zoracherry"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zorakois
	name = "\improper Zo'ra Soda Kois Twist"
	desc = "A can of K'ois flavored energy drink, with V'krexi additives. Contains no K'ois, probably contains no palatable flavor."
	icon_state = "koistwist"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/kois = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoraphoron
	name = "\improper Zo'ra Soda Phoron Passion"
	desc = "A can of grape flavored energy drink, with V'krexi additives. Tastes nothing like phoron according to Unbound taste testers."
	icon_state = "phoronpassion"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/phoron = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zorahozm
	name = "\improper High Octane Zorane Might"
	desc = "A can of fizzy, acidic energy, with plenty of V'krexi additives. Tastes like impaling the bottom of your mouth with a freezing cold spear laced with bees and salt."
	icon_state = "hozm"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/hozm = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoravenom
	name = "\improper Zo'ra Soda Sour Venom Grass (Diet!)"
	desc = "A diet can of Venom Grass flavored energy drink, with V'krexi additives. Still tastes like a cloud of stinging polytrinic bees, but calories are nowhere to be found."
	icon_state = "sourvenomgrass"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/venomgrass = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoraklax
	name = "\improper Klaxan Energy Crush"
	desc = "A can of orange cream flavored energy drink, with V'krexi additives. Engineered nearly to perfection."
	icon_state = "klaxancrush"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/klax = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoracthur
	name = "\improper C'thur Rockin' Raspberry"
	desc = "A can of blue raspberry flavored energy drink, with V'krexi additives. You're pretty sure this was shipped by mistake, the previous K'laxan Energy Crush wrapper is still partly visible underneath the current one."
	icon_state = "cthurberry"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/cthur = 20, /datum/reagent/mental/vaam = 15)

/obj/item/reagent_containers/food/drinks/cans/zoradrone
	name = "\improper Drone Fuel"
	desc = "A can of some kind of industrial fluid flavored energy drink, with V'krexi additives meant for Vaurca. <span class='warning'>Known to induce vomiting in humans!</span>."
	icon_state = "dronefuel"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/drone = 30, /datum/reagent/mental/vaam = 10)

/obj/item/reagent_containers/food/drinks/cans/zorajelly
	name = "\improper Royal Jelly"
	desc = "A can of... You aren't sure, but it smells pleasant already."
	icon_state = "royaljelly"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/drink/zorasoda/jelly = 30)

/obj/item/reagent_containers/food/drinks/cans/adhomai_milk
	name = "fermented fatshouters milk"
	desc = "A can of fermented fatshouters milk, imported from Adhomai."
	icon_state = "milk_can"
	center_of_mass = list("x"=16, "y"=10)
	desc_fluff = "Fermend fatshouters milk is a drink that originated among the nomadic populations of Rhazar'Hrujmagh, and it has spread to the rest of Adhomai."

	reagents_to_add = list(/datum/reagent/drink/milk/adhomai/fermented = 30)

/obj/item/reagent_containers/food/drinks/cans/beetle_milk
	name = "\improper Hakhma Milk"
	desc = "A can of Hakhma beetle milk, sourced from Scarab and Drifter communities."
	icon_state = "beetlemilk"
	center_of_mass = list("x"=17, "y"=10)
	reagents_to_add = list(/datum/reagent/drink/milk/beetle = 30)

/obj/item/reagent_containers/food/drinks/cans/dyn
	name = "Cooling Breeze"
	desc = "The most refreshing thing you can find on the market, based on a Skrell medicinal plant. No salt or sugar."
	icon_state = "dyncan"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/datum/reagent/drink/dynjuice/cold = 30)
