/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm knit sweater."
	desc_fluff = "Fortunately, it comes with Itch-Proof technology. The only thing they haven't invented is a better fashion sense for you, though."
	icon_state = "sweater"
	item_state = "sweater"

/obj/item/clothing/accessory/sweatervest
	name = "sweater vest"
	desc = "A warm knit sweater vest."
	desc_fluff = "Unlike a bulletproof vest, the only thing this'll protect you from is the opposite sex."
	icon_state = "sweatervest"
	item_state = "sweatervest"

/obj/item/clothing/accessory/sweatercrewneck
	name = "crewneck sweater"
	desc = "A sewn crewneck sweater featuring a collarless neckline."
	desc_fluff = "Fortunately, they even have a type of sweater for the sporty and informal."
	icon_state = "sweatercrewneck"
	item_state = "sweatercrewneck"

/obj/item/clothing/accessory/sweatervneck
	name = "v-neck sweater"
	desc = "A sewn v-neck sweater featuring a collarless neckline."
	desc_fluff = "Fortunately, they even have a type of sweater for the sporty and informal."
	icon_state = "sweatervneck"
	item_state = "sweatervneck"

/obj/item/clothing/accessory/sweaterturtleneck
	name = "turtleneck sweater"
	desc = "A warm knit turtleneck sweater."
	desc_fluff = "Engineered for the rigors of poetry club finger snapping."
	icon_state = "sweaterturtleneck"
	item_state = "sweaterturtleneck"

/obj/item/clothing/accessory/sweatertubeneck
	name = "tubeneck sweater"
	desc = "A warm knit tubeneck sweater."
	desc_fluff = "What the hell is cashmere anyway?"
	icon_state = "sweatertubeneck"
	item_state = "sweatertubeneck"

/obj/item/clothing/accessory/sweaterargyle
	name = "argyle sweater"
	desc = "A warm knit sweater with an argyle pattern."
	desc_fluff = "Never go unprepared for the next work-mandated secret santa with this fashion statement! Revel in their awkward thanks as they unbox it! Realize that you've received one too!"
	icon_state = "sweaterargyle"
	item_state = "sweaterargyle"

/obj/item/clothing/accessory/sweatervestargyle
	name = "argyle sweater vest"
	desc = "A warm knit sweater vest with an argyle pattern."
	desc_fluff = "Reminds you of family picture day. Wearing this is entirely your own volition, unfortunately."
	icon_state = "sweaterargylevest"
	item_state = "sweaterargylevest"

/obj/item/clothing/accessory/sweaterargylecrewneck
	name = "argyle crewneck sweater"
	desc = "A sewn crewneck sweater featuring a collarless neckline and an argyle pattern."
	desc_fluff = "Fortunately, they even have a type of sweater for the sporty and informal."
	icon_state = "sweaterargylecrewneck"
	item_state = "sweaterargylecrewneck"

/obj/item/clothing/accessory/sweaterargylevneck
	name = "argyle v-neck sweater"
	desc = "A sewn v-neck sweater featuring a collarless neckline and an argyle pattern."
	desc_fluff = "Fortunately, they even have a type of sweater for the sporty and informal."
	icon_state = "sweaterargylevneck"
	item_state = "sweaterargylevneck"

/obj/item/clothing/accessory/sweaterargyleturtleneck
	name = "argyle turtleneck sweater"
	desc = "A warm knit argyle turtleneck sweater."
	desc_fluff = "Now your clothing can be as stuffy as your personality."
	icon_state = "sweaterargyleturtleneck"
	item_state = "sweaterargyleturtleneck"

/obj/item/clothing/accessory/sweaterargyletubeneck
	name = "argyle tubeneck sweater"
	desc = "A warm knit argyle tubeneck sweater."
	desc_fluff = "Does not come with accompanying dog-sized version."
	icon_state = "sweaterargyletubeneck"
	item_state = "sweaterargyletubeneck"

/obj/item/clothing/accessory/dressshirt
	name = "dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirt"
	item_state = "dressshirt"
	var/rolled = FALSE

/obj/item/clothing/accessory/dressshirt/update_clothing_icon()
	var/mob/M = loc
	if(ismob(loc))
		M.update_inv_wear_suit()
	get_accessory_mob_overlay(M, TRUE)
	get_inv_overlay(M, TRUE)

/obj/item/clothing/accessory/dressshirt/verb/roll_up_shirt_sleeves()
	set name = "Roll Up Shirt Sleeves"
	set desc = "Roll up your shirt sleeves. Doesn't work with some shirts."
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return FALSE

	var/list/icon_states = icon_states(icon)
	var/initial_state = initial(icon_state)
	var/new_state = "[initial_state]_r"
	if(!(new_state in icon_states))
		to_chat(usr, SPAN_WARNING("Your shirt doesn't allow this!"))
		return

	rolled = !rolled
	to_chat(usr, SPAN_NOTICE("You roll your shirt sleeves [rolled ? "up" : "down"]."))
	icon_state = rolled ? new_state : initial_state
	item_state = rolled ? new_state : initial_state
	overlay_state = rolled ? new_state : initial_state
	update_icon()
	update_clothing_icon()

/obj/item/clothing/accessory/dressshirt/alt
	name = "dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirt_alt"
	item_state = "dressshirt_alt"

/obj/item/clothing/accessory/dressshirt/alt/vneck
	name = "v-neck dress shirt"
	desc = "A casual dress shirt."
	icon_state = "dressshirtvneck_alt"
	item_state = "dressshirtvneck_alt"

/obj/item/clothing/accessory/dressshirt/deepv
	name = "deep v-neck dress shirt"
	desc = "A casual dress shirt with a deep neckline."
	icon_state = "dressshirt_deepv"
	item_state = "dressshirt_deepv"

/obj/item/clothing/accessory/dressshirt/crop
	name = "cropped dress shirt"
	desc = "A casual cropped dress shirt."
	icon_state = "dressshirt_crop"
	item_state = "dressshirt_crop"

// So people can see how these appear in the loadout
/obj/item/clothing/accessory/dressshirt/rolled
	name = "dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirt_r"
	item_state = "dressshirt_r"

/obj/item/clothing/accessory/dressshirt/alt/rolled
	name = "dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirt_alt_r"
	item_state = "dressshirt_alt_r"

/obj/item/clothing/accessory/dressshirt/alt/vneck/rolled
	name = "v-neck dress shirt"
	desc = "A casual dress shirt. This one has its sleeves rolled up."
	icon_state = "dressshirtvneck_alt_r"
	item_state = "dressshirtvneck_alt_r"

/obj/item/clothing/accessory/dressshirt/deepv/rolled
	name = "deep v-neck dress shirt"
	desc = "A casual dress shirt with a deep neckline. This one has its sleeves rolled up."
	icon_state = "dressshirt_deepv_r"
	item_state = "dressshirt_deepv_r"

/obj/item/clothing/accessory/dressshirt/crop/rolled
	name = "cropped dress shirt"
	desc = "A casual cropped dress shirt. This one has its sleeves rolled up"
	icon_state = "dressshirt_crop"
	item_state = "dressshirt_crop"

/obj/item/clothing/accessory/blouse
	name = "blouse"
	desc = "A loose fitting garment."
	icon_state = "blouse"
	item_state = "blouse"

/obj/item/clothing/accessory/longblouse
	name = "long-sleeved blouse"
	desc = "A long-sleeved, loose fitting garment."
	icon_state = "longblouse"
	item_state = "longblouse"

/obj/item/clothing/accessory/puffyblouse
	name = "puffy blouse"
	desc = "A loose fitting garment with plenty of material around the arms."
	icon_state = "puffyblouse"
	item_state = "puffyblouse"

//Legacy
/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "wcoat"
	item_state = "wcoat"

//New one that will actually be in the loadout
/obj/item/clothing/accessory/wcoat_rec
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "wcoat_rec"
	item_state = "wcoat_rec"

/obj/item/clothing/accessory/longsleeve
	name = "long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric."
	icon_state = "longshirt"
	item_state = "longshirt"

/obj/item/clothing/accessory/longsleeve_s
	name = "black striped long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one is striped in black."
	icon_state = "longshirt_s"
	item_state = "longshirt_s"

/obj/item/clothing/accessory/longsleeve_sb
	name = "blue striped long-sleeved shirt"
	desc = "A long-sleeved shirt made of light fabric. This one is striped in blue."
	icon_state = "longshirt_sb"
	item_state = "longshirt_sb"

/obj/item/clothing/accessory/tshirt
	name = "t-shirt"
	desc = "A simple, cheap t-shirt."
	icon_state = "tshirt"
	item_state = "tshirt"

/obj/item/clothing/accessory/tshirt_crop
	name = "cropped t-shirt"
	desc = "A simple, cheap cropped t-shirt."
	icon_state = "tshirt_crop"
	item_state = "tshirt_crop"

/obj/item/clothing/accessory/silversun
	name = "silversun floral shirt"
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is cyan."
	icon = 'icons/clothing/under/shirts/hawaiian.dmi'
	icon_state = "hawaii"
	item_state = "hawaii"
	contained_sprite = TRUE
	var/open = FALSE

/obj/item/clothing/accessory/silversun/verb/unbutton()
	set name = "Unbutton Shirt"
	set category = "Object"
	set src in usr

	if(!istype(usr, /mob/living))
		return
	if(use_check_and_message(usr))
		return

	var/mob/user = usr
	attack_self(user)

/obj/item/clothing/accessory/silversun/attack_self(mob/user)
	open = !open
	icon_state = "[initial(icon_state)][open ? "_open" : ""]"
	item_state = icon_state
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	// the below forces the shirt to hard reset its image so it resets later its fucking weird ok
	inv_overlay = null
	accessory_mob_overlay = null

/obj/item/clothing/accessory/silversun/red
	desc = "A stylish Solarian shirt of Silversun design. It bears a floral design. This one is crimson."
	icon_state = "hawaii_red"
	item_state = "hawaii_red"

/obj/item/clothing/accessory/silversun/random
	name = "silversun floral shirt"

/obj/item/clothing/accessory/silversun/random/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "hawaii_red"
	color = color_rotation(rand(-11,12)*15)

/obj/item/clothing/accessory/silversun/wcoat
	name = "waistcoat"
	desc = "A slick waistcoat."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "det_vest"
	item_state = "det_vest"
	contained_sprite = FALSE

/obj/item/clothing/accessory/university
	name = "university sweatshirt"
	desc = "A comfy university sweatshirt. This one is grey."
	icon_state = "usweatshirt_grey"
	item_state = "usweatshirt_grey"

/obj/item/clothing/accessory/university/red
	desc = "A comfy university sweatshirt. This one is crimson."
	icon_state = "usweatshirt_red"
	item_state = "usweatshirt_red"

/obj/item/clothing/accessory/university/yellow
	desc = "A comfy university sweatshirt. This one is mustard."
	icon_state = "usweatshirt_yellow"
	item_state = "usweatshirt_yellow"

/obj/item/clothing/accessory/university/blue
	desc = "A comfy university sweatshirt. This one is navy."
	icon_state = "usweatshirt_blue"
	item_state = "usweatshirt_blue"

/obj/item/clothing/accessory/university/black
	desc = "A comfy university sweatshirt. This one is black."
	icon_state = "usweatshirt_black"
	item_state = "usweatshirt_black"