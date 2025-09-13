//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = WEIGHT_CLASS_TINY
	contained_sprite = TRUE
	item_state = "candy"
	desc = "General waste material, refuse or litter. Dispose responsibly."
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'
	persistency_considered_trash = TRUE

/obj/item/trash/attack(mob/living/target_mob, mob/living/user, target_zone)
	return

/obj/item/trash/persistence_get_content()
	var/list/content = list()
	content["name"] = name
	content["desc"] = desc
	content["icon"] = icon
	content["icon_state"] = icon_state
	content["item_state"] = item_state
	content["drop_sound"] = drop_sound
	content["pickup_sound"] = pickup_sound
	return content

/obj/item/trash/persistence_apply_content(content, x, y, z)
	name = content["name"]
	desc = content["desc"]
	icon = file(content["icon"])
	icon_state = content["icon_state"]
	item_state = content["item_state"]
	drop_sound = file(content["drop_sound"])
	pickup_sound = file(content["pickup_sound"])
	src.x = x
	src.y = y
	src.z = z

/obj/item/trash/koisbar
	name = "\improper k'ois bar wrapper"
	icon_state = "koisbar"

/obj/item/trash/kokobar
	name = "\improper koko bar wrapper"
	icon_state = "kokobar"

/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state = "4no_raisins"

/obj/item/trash/candy
	name = "candy wrapper"
	icon_state = "candy"

/obj/item/trash/cheesie
	name = "\improper Cheesie Honkers"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "empty chip packet"
	icon_state = "chips"
	item_state = "chips"

/obj/item/trash/chips/cucumber
	icon_state = "cucumberchips"

/obj/item/trash/chips/chicken
	icon_state = "chickenchips"

/obj/item/trash/chips/dirtberry
	icon_state = "dirtberrychips"

/obj/item/trash/chips/phoron
	icon_state = "phoronchips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/syndi_cakes
	name = "\improper Nutri-Cakes"
	icon_state = "syndi_cakes"

/obj/item/trash/waffles
	name = "square tray"
	icon_state = "waffles"
	drop_sound = /singleton/sound_category/tray_hit_sound

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/trash/plate/steak
	icon_state = "steak"

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/trash/snack_bowl/macandcheese
	name = "empty mac and cheese"
	icon_state = "macandcheese"

/obj/item/trash/pistachios
	name = "pistachios pack"
	icon_state = "pistachios_pack"

/obj/item/trash/semki
	name = "semki pack"
	icon_state = "semki_pack"

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	drop_sound = /singleton/sound_category/tray_hit_sound

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/storage/fancy/candle.dmi'
	icon_state = "candle4"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/trash/liquidfood
	name = "\improper \"LiquidFood\" ration"
	icon_state = "liquidfood"

/obj/item/trash/tastybread
	name = "bread tube"
	icon_state = "tastybread"

/obj/item/trash/meatsnack
	name = "mo'gunz meat pie"
	icon_state = "meatsnack-used"
	item_state = "chips"

/obj/item/trash/maps
	name = "maps salty ham"
	icon_state = "maps-used"
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'

/obj/item/trash/nathisnack
	name = "razi-snack corned beef"
	icon_state = "cbeef-used"
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'

/obj/item/trash/brownies
	name = "square tray"
	icon_state = "brownies"
	drop_sound = /singleton/sound_category/tray_hit_sound

/obj/item/trash/snacktray
	name = "snacktray"
	icon_state = "snacktray"

/obj/item/trash/dipbowl
	name = "dip bowl"
	icon_state = "dipbowl"

/obj/item/trash/chipbasket
	name = "empty basket"
	icon_state = "chipbasket_empty"

/obj/item/trash/uselessplastic
	name = "useless plastic"
	icon_state = "useless_plastic"

/obj/item/trash/can
	name = "used can"
	icon_state = "cola"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	randpixel = 4

/obj/item/trash/can/Initialize()
	. = ..()
	randpixel_xy()

/obj/item/trash/can/adhomian_can
	icon_state = "can-used"

/obj/item/trash/tuna
	name = "\improper Tuna Snax"
	icon_state = "tuna"

/obj/item/trash/skrellsnacks
	name = "\improper SkrellSnax"
	icon_state = "skrellsnacks"

/obj/item/trash/space_twinkie
	name = "\improper space twinkie"
	icon_state = "space_twinkie"

/obj/item/trash/grease //used for generic plattered food. example is lasagna.
	name = "square tray"
	icon_state = "grease"
	drop_sound = /singleton/sound_category/tray_hit_sound

/obj/item/trash/cookiesnack
	name = "\improper Carps Ahoy! miniature cookies"
	icon_state = "cookiesnack"

/obj/item/trash/admints
	name = "\improper Ad-mints"
	icon_state = "admint_pack"

/obj/item/trash/gum
	name = "\improper Chewy Fruit flavored gum"
	icon_state = "gum_pack"

/obj/item/trash/stew
	name = "empty pot"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "stew_empty"
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'

/obj/item/trash/coffee
	name = "empty cup"
	icon_state = "coffee_vended"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/trash/ramen
	name = "cup ramen"
	icon_state = "ramen"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/trash/candybowl
	name = "empty candy bowl"
	icon_state = "candy_bowl"
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/trash/ricetub
	name = "empty rice tub"
	icon_state = "ricetub"
	var/has_chopsticks = FALSE

/obj/item/trash/ricetub/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/kitchen/utensil/fork/chopsticks))
		to_chat(user, SPAN_NOTICE("You reattach the [attacking_item] to \the [src]"))
		qdel(attacking_item)
		has_chopsticks = TRUE
		update_icon()
		return TRUE

/obj/item/trash/ricetub/update_icon()
	if(has_chopsticks)
		icon_state = "ricetub_s"
	else
		icon_state = "ricetub"

/obj/item/trash/ricetub/sticks
	has_chopsticks = TRUE

/obj/item/trash/seaweed
	name = "empty moss pack"
	icon_state = "seaweed"

/obj/item/trash/vkrexitaffy
	name = "V'krexi Snax"
	icon_state = "vkrexitaffy"
	item_state = "vkrexi"

/obj/item/trash/broken_electronics
	name = "broken electronics"
	icon_state = "door_electronics_smoked"

/obj/item/trash/phoroncandy
	name = "\improper phoron rock candy stick"
	icon_state = "rock_candy"

/obj/item/trash/proteinbar
	name = "protein bar wrapper"
	icon_state = "proteinbar"

/obj/item/trash/leaf
	name = "dirty leaf"
	icon_state = "leaf"
	desc = "Is... Is that a big old leaf with... are those beans on it? Why?! What kind of situation would lead to this?!"

/obj/item/trash/north60squidempty
	name = "empty platter"
	icon_state = "north60squidempty"
	desc = "A deep dish meant to hold a pool of sauce and seafood, but now it only holds delicious memories. Trash it."
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/trash/triolade
	name = "empty dessert dish"
	icon_state = "triolade"

/obj/item/trash/board
	name = "dirty board"
	icon_state = "board"

/obj/item/trash/icecreamcup
	name = "empty ice cream cup"
	icon_state = "icecreamcup"
	desc = "Oh look, it's one of those prank fake melted ice cream cu- oh, nope. it's real. eugh. Do... Do you have a napkin?"

/obj/item/trash/purplebowl
	name = "empty bowl"
	icon_state = "purplebowl"
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/trash/deepdive
	name = "empty deepdive dish"
	icon_state = "deepdive"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/trash/bluemoon
	name = "empty dessert glass"
	icon_state = "bluemoon"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/trash/shakshouka
	name = "large messy pan"
	icon_state = "shakshouka"
	desc = "It looks like the murder scene... of a delicious, saucy dish. Trash or recycle."
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/trash/stick
	name = "candy stick"
	icon_state = "rock_candy"

/obj/item/trash/imperial_pot_empty
	name = "imperial pot"
	desc = "This large wooden pot was probably used to house a grand, elaborate, dominian feast at some point. How majestic it must have been. Oh well, get rid of it now before it draws rats."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "imperialpotempty"
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'

/obj/item/trash/wooden_platter
	name = "wooden platter"
	icon_state = "wooden_platter"
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/trash/custard_bowl
	name = "custard bowl"
	desc = "It smells tasty... Wait, why are you smelling it? It's trash!"
	icon_state = "custard_bowl"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/trash/fishjerky
	name = "Go-Go Gwok! Great Grouper"
	icon_state = "fishjerky_trash"

/obj/item/trash/pepperoniroll
	name = "roll wrapper"
	icon_state = "rollwrapper"

/obj/item/trash/salmiakpack
	name = "salmiak packet"
	icon_state = "salmiak_pack"

/obj/item/trash/hakhmaps
	name = "maps tin"
	icon_state = "hakhmaps_trash"

/obj/item/trash/pemmican
	name = "pemmican bar wrapper"
	icon_state = "pemmican_trash"

/obj/item/trash/trufflebag
	name = "truffle bag"
	icon_state = "trufflebag_trash"

/obj/item/trash/peanutsnack
	name = "peanut bag"
	icon_state = "nuts_trash"

/obj/item/trash/peanutsnack/pepper
	icon_state = "peppernuts_trash"

/obj/item/trash/peanutsnack/choc
	icon_state = "chocnuts_trash"

/obj/item/trash/peanutsnack/masala
	icon_state = "masalanuts_trash"

/obj/item/trash/chana
	name = "chana wrapper"
	icon_state = "chanamild_trash"

/obj/item/trash/chana/wild
	icon_state = "chanawild_trash"

/obj/item/trash/foysnack
	name = "cookie wrapper"
	icon_state = "foysnack_trash"

/obj/item/trash/papad
	name = "empty papad box"
	icon_state = "papad_trash"

/obj/item/trash/papad/garlic
	icon_state = "papadgarlic_trash"

/obj/item/trash/papad/ginger
	icon_state = "papadginger_trash"

/obj/item/trash/papad/apple
	icon_state = "papadapple_trash"

/obj/item/trash/bowl_small
	name = "small bowl"
	desc = "A side dish used to live here, but then it moved out."
	icon_state = "small_bowl"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/trash/bowl_brown
	name = "terracotta bowl"
	desc = "A brown bowl made of clay. Good for, uh, bowl... ing."
	icon_state = "bowl_brown"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/trash/microwave_package
	name = "empty microwave food package"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "microwave_trash"

/obj/item/trash/mac_cheeze
	name = "empty mac and cheeze container"
	icon_state = "mac_trash"

/obj/item/trash/mac_fiery
	name = "empty fiery hot mac and cheeze container"
	icon_state = "mac_trash_fiery"
