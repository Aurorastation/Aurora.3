/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "Off"
	anchored = TRUE
	req_access = list(ACCESS_BAR) //Has to initalize at first, this is updated by instance's req_access
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/cult = 0
	var/choice_types = /singleton/sign/double/bar

/obj/structure/sign/double/barsign/attackby(obj/item/attacking_item, mob/user)
	if(cult)
		return ..()
	var/obj/item/card/id/card = attacking_item.GetID()
	if(istype(card))
		if(check_access(card))
			set_sign()
			to_chat(user, "<span class='notice'>You change the sign.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	return ..()

/obj/structure/sign/double/barsign/proc/get_sign_choices()
	var/list/sign_choices = GET_SINGLETON_SUBTYPE_MAP(choice_types)
	return sign_choices

/obj/structure/sign/double/barsign/proc/set_sign()
	var/list/sign_choices = get_sign_choices()

	var/list/sign_index = list()
	for(var/sign in sign_choices)
		var/singleton/sign/double/B = GET_SINGLETON(sign)
		sign_index["[B.name]"] = B

	var/sign_choice = tgui_input_list(usr, "What should the sign be changed to?", "Bar Sign", sign_index)
	if(!sign_choice)
		return
	var/singleton/sign/double/signselect = sign_index[sign_choice]

	name = signselect.name
	desc = signselect.desc
	desc_extended = signselect.desc_extended
	icon_state = signselect.icon_state
	update_icon()

/obj/structure/sign/double/barsign/kitchensign
	icon = 'icons/obj/kitchensigns.dmi'
	icon_state = "Off"
	req_access = list(ACCESS_KITCHEN)
	choice_types = /singleton/sign/double/kitchen

/obj/structure/sign/double/barsign/kitchensign/mirrored // Visible from the other end of the sign.
	pixel_x = -32

/singleton/sign/double
	var/name = "Holographic Projector"
	var/icon_state = "Off"
	var/desc = "A holographic projector, displaying different saved themes. It is turned off right now."
	var/desc_extended = "To change the displayed theme, use your bartender's or chef's ID on it and select something from the menu. There are two different selections for the bar and the kitchen."

/singleton/sign/double/off // Here start the different bar signs. To add any new ones, just copy the format, make sure its in the .dmi and write away. -KingOfThePing
	name = "Holgraphic Projector"
	icon_state = "Off"
	desc = "A holographic projector, displaying different saved themes. It is turned off right now."
	desc_extended = "To change the displayed theme, use your bartender's or chef's ID on it and select something from the menu. There are two different selections for the bar and the kitchen."

/singleton/sign/double/bar/whiskey_implant
	name = "Whiskey Implant"
	icon_state = "Whiskey Implant"
	desc = "A hit on modern extensive augmentations."
	desc_extended = "Some people would probably argue, that an implant which injects you some whiskey in certain situations, would probably make the galaxy a better place for everyone."
/singleton/sign/double/bar/the_drunk_carp
	name = "The Drunk Carp"
	icon_state = "The Drunk Carp"
	desc = "A depiction of a stylized space carp drinking a beer."
	desc_extended = "A depiction of 'Ivan the Space Carp' from the popular children's show of the same name. As the name suggests, Ivan has a heavy drinking problem."
/singleton/sign/double/bar/the_outer_spess
	name = "The Outer Spess"
	icon_state = "The Outer Spess"
	desc = "A long running joke between spacemen, which never gets old."
	desc_extended = "It's almost tradition to call the great unknown of the universe 'spess'. No one really knows anymore where this joke comes from nor does anyone care. It's also not important, probably."
/singleton/sign/double/bar/officer_beersky
	name = "Officer Beersky"
	icon_state = "Officer Beersky"
	desc = "To remember the hero, lost along the way, Officer Beepsky."
	desc_extended = "To commemorate the great accomplishments and never ending duty of the ISD's small security robot Officer Beepsky. Gone, but not forgotten."
/singleton/sign/double/bar/ishimura
	name = "Ishimura"
	icon_state = "Ishimura"
	desc = "Named after a famous solarian physicist."
	desc_extended = "Hideki Ishimura was a famous solarian astrophysicist, responsible for some great scientific achievements from a time long gone."
/singleton/sign/double/bar/foreign
	name = "Foreign"
	icon_state = "Foreign"
	desc = "A sign, designed in a classic estern-asian design, originating from Earth."
	desc_extended = "Earth's eastern asian culture brought forward a greatly varied and loved style of cuisine, still eaten today. This sign looks like one of the many signs that come to mind, when thinking about this."
/singleton/sign/double/bar/hearts_of_plasteel
	name = "Hearts of Plasteel"
	icon_state = "Hearts of Plasteel"
	desc = "The sign of a diner from a famous TV show."
	desc_extended = "This sign is a replication of the diner sign, which the military-comedy show 'Hearts of Plasteel' revolves around. Loved by fans universe-wide."
/singleton/sign/double/bar/the_lightbulb
	name = "The Lightbulb"
	icon_state = "The Lightbulb"
	desc = "The Lightbulb, a famous scene-bar and club in Mendell City."
	desc_extended = "The Lightbulb is one of the top hidden gems in Mendell City, if you want to party. Known for it's expansive dance floors and planet-wide renowned bartenders, the Lightbulb is a once in a lifetime experience."
/singleton/sign/double/bar/chem_lab
	name = "Chem Lab"
	icon_state = "Chem Lab"
	desc = "Chem Labs are the unofficial name given to some eridanian bars."
	desc_extended = "Underground, hidden or less known bars in Eridani, where almost exclusively Dregs or other 'Unwanted' frequent are unofficially called Chem Labs, not only due to the dubious origin of the alcohol served there."
/singleton/sign/double/bar/meow_mix
	name = "Meow Mix"
	icon_state = "Meow Mix"
	desc = "A sign with a selection of some of the SCC's much beloved pets."
	desc_extended = "Two cats, named Bones and Nickel are depicted on this sign. They are much beloved mascotts, raising morale and work efficiency whereever they are."
/singleton/sign/double/bar/the_hive
	name = "The Hive"
	icon_state = "The Hive"
	desc = "A wildly known, high class eridanian cocktail bar chain."
	desc_extended = "The Hive, known for its expensive and extravagant drinks, this bar chain is known as the place to be with your suit friends, when visiting Eridani I."
/singleton/sign/double/bar/mead_bay
	name = "Mead Bay"
	icon_state = "Mead Bay"
	desc = "The Mead Bay is the alternative for visiting an actual Medbay."
	desc_extended = "Another long running joke among spacefarers. A bandage from the Medbay may mend your body, but a good drink from the Mead Bay together with your colleagues really mends your soul."
/singleton/sign/double/bar/toolbox_tavern
	name = "Toolbox Tavern"
	icon_state = "Toolbox Tavern"
	desc = "A popular bar at an Hepheastus Industries shipyard."
	desc_extended = "The name of the after-hours bar, located at the Hepheastus Industries shipyard the Horizon was built. To remember the great lengths and sacrifices that were made to bring this vessel to life."
/singleton/sign/double/bar/maltese_falcon
	name = "Maltese Falcon"
	icon_state = "Maltese Falcon"
	desc = "A recreation of the famous Maltese Falcon bar sign."
	desc_extended = "An exact replica of the sign, which is hanging over the entrance of the famous Maltese Falcon Bar & Grill. A safe heaven for every pilot, captain or crewman of any vessel, looking to take a break."
/singleton/sign/double/bar/old_cock_inn
	name = "Old Cock Inn"
	icon_state = "Old Cock Inn"
	desc = "The sign of a formerly well-known discotheque."
	desc_extended = "The Old Cock Inn was a discotheque, from times long gone. Formerly known as 'Old Richard's Inn' no one can remember much about it, but the name has persisted over the decades."
/singleton/sign/double/bar/commie
	name = "People's Preferred"
	icon_state = "Commie"
	desc = "The name of a bar, located at Pluto's biggest spaceport."
	desc_extended = "People's Preferred is the name of the drinking hole at Pluto's biggest spaceport. Everyone stops there and everyone loves it there. It's what the people prefer, apparently."
/singleton/sign/double/kitchen/event_horizon // Start of the kitchen signs. Don't mix it up.
	name = "Event Horizon"
	icon_state = "Event Horizon"
	desc = "The SCCV Horizon's kitchen franchise sign."
	desc_extended = "The SCCV Horizon's dining area was the testing ground for the SCC to experiment with food franchising. The goal was to provide better food perparing processes, food quality and, of course, to maybe capitalize on this. To remember where it all started, the name 'Event Horizon' was chosen."
/singleton/sign/double/kitchen/paradise_sands
	name = "Paradise Sands"
	icon_state = "Paradise Sands"
	desc = "A take on the sign of one of Silversun's most popular cafe and bistro owned by Idris Incorporated."
	desc_extended = "Paradise Sands is the name of one of the most popular cafe- and bistro places on all of Silversun. Located in a secluded cove, you can brunch, drink, and swim at a beach with white sand and a deep, azure ocean; a paradise."
/singleton/sign/double/kitchen/city_alive
	name = "City Alive"
	icon_state = "City Alive"
	desc = "City Alive is another popular restaurant chain, originating from Eridani I. It is famous for its light shows."
	desc_extended = "City Alive is a high class restaurant chain, dotted all over Eridani I and III. Especially on Eridani I they are also famous for their light shows in the evenings. These lights look like pulsating veins, making the city seem alive, especially when observed from orbit."
