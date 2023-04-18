//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = ITEMSIZE_TINY
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_food.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_food.dmi'
		)
	desc = "General waste material, refuse or litter. Dispose responsibly."
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return

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
	name = "chips"
	icon_state = "chips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "\improper Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/syndi_cakes
	name = "syndi cakes"
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
	icon = 'icons/obj/candle.dmi'
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
	icon = 'icons/obj/food.dmi'
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

/obj/item/trash/ricetub/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/material/kitchen/utensil/fork/chopsticks))
		to_chat(user, SPAN_NOTICE("You reattach the [W] to \the [src]"))
		qdel(W)
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

/obj/item/trash/broken_electronics
	name = "broken electronics"
	icon_state = "door_electronics_smoked"

/obj/item/trash/phoroncandy
	name = "\improper phoron rock candy stick"
	icon_state = "rock_candy"

/obj/item/trash/proteinbar
	name = "protein bar wrapper"
	icon_state = "proteinbar"
