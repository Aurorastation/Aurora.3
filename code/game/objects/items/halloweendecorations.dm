//Two small halloween decoration items
//Candle pile
/obj/item/flame/waxcandles
	name = "candle pile"
	desc = "A pile of half molten white wax candles, that seem to burn on forever."
	icon = 'icons/obj/contained_items/halloween_decorations.dmi'
	icon_state = "candles"
	item_state = "candles"
	light_color = "#E09D37"
	var/wax = 40000

/obj/item/flame/waxcandles/proc/light()
    if(!src.lit)
        src.lit = 1
        set_light(CANDLE_LUM)
        update_icon()
        START_PROCESSING(SSprocessing, src)

/obj/item/flame/waxcandles/snowflake_candle/Initialize()
	. = ..()
	wax = rand(1600, 2000)
	light()

// Happy Halloween banner

/obj/item/banner/halloween/l
	name = "halloween banner"
	desc = "A bright, purple banner with an orange rim, spelling out \"HAPPY HALLOWEEN\"."
	icon = 'icons/obj/contained_items/halloween_decorations.dmi'

/obj/item/flag/halloween/left
	icon_state = "halloween_l"

/obj/item/flag/halloween/right
	icon_state = "halloween_r"


