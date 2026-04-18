//
// Sweaters
//

// Sweater
/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm, knit sweater."
	desc_extended = "Commonly made out of cotton or wool, but sometimes polyester or acrylic as well."
	icon = 'icons/obj/item/clothing/accessory/sweaters.dmi'
	icon_state = "sweater"
	item_state = "sweater"
	contained_sprite = TRUE
	slot_flags = SLOT_ICLOTHING | SLOT_TIE

// Tubeneck Sweater
/obj/item/clothing/accessory/sweater/tubeneck
	name = "tubeneck sweater"
	desc = "A warm, knit tubeneck sweater."
	icon_state = "sweater_tubeneck"
	item_state = "sweater_tubeneck"

// Turtleneck Sweater
/obj/item/clothing/accessory/sweater/turtleneck
	name = "turtleneck sweater"
	desc = "A warm, knit turtleneck sweater."
	icon_state = "sweater_turtleneck"
	item_state = "sweater_turtleneck"

// Crewneck Sweater
/obj/item/clothing/accessory/sweater/crewneck
	name = "crewneck sweater"
	desc = "A sewn crewneck sweater featuring a collarless neckline."
	icon_state = "sweater_crewneck"
	item_state = "sweater_crewneck"

// V-neck Sweater
/obj/item/clothing/accessory/sweater/v_neck
	name = "v-neck sweater"
	desc = "A sewn v-neck sweater featuring a collarless neckline."
	icon_state = "sweater_v_neck"
	item_state = "sweater_v_neck"

// Alternative V-neck Sweater
/obj/item/clothing/accessory/sweater/v_neck/deep
	icon_state = "sweater_deep_v_neck"
	item_state = "sweater_deep_v_neck"
	contained_sprite = TRUE

// Argyle Sweater
/obj/item/clothing/accessory/sweater/argyle
	name = "argyle sweater"
	desc = "A warm, knit sweater with an argyle pattern."
	icon_state = "argyle_sweater"
	item_state = "argyle_sweater"

// Argyle Tubeneck Sweater
/obj/item/clothing/accessory/sweater/argyle/tubeneck
	name = "argyle tubeneck sweater"
	desc = "A warm, knit argyle tubeneck sweater."
	icon_state = "argyle_sweater_tubeneck"
	item_state = "argyle_sweater_tubeneck"

// Argyle Turtleneck Sweater
/obj/item/clothing/accessory/sweater/argyle/turtleneck
	name = "argyle turtleneck sweater"
	desc = "A warm, knit argyle turtleneck sweater."
	icon_state = "argyle_sweater_turtleneck"
	item_state = "argyle_sweater_turtleneck"

// Argyle Crewneck Sweater
/obj/item/clothing/accessory/sweater/argyle/crewneck
	name = "argyle crewneck sweater"
	desc = "A sewn crewneck sweater featuring a collarless neckline and an argyle pattern."
	icon_state = "argyle_sweater_crewneck"
	item_state = "argyle_sweater_crewneck"

// Argyle V-neck Sweater
/obj/item/clothing/accessory/sweater/argyle/v_neck
	name = "argyle v-neck sweater"
	desc = "A sewn v-neck sweater featuring a collarless neckline and an argyle pattern."
	icon_state = "argyle_sweater_v_neck"
	item_state = "argyle_sweater_v_neck"

// Sweater Vest
/obj/item/clothing/accessory/sweater/vest
	name = "sweater vest"
	desc = "A warm, knit sweater vest."
	desc_extended = "Commonly made out of cotton or wool, but sometimes polyester or acrylic as well."
	icon_state = "sweater_vest"
	item_state = "sweater_vest"
// Argyle Sweater Vest
/obj/item/clothing/accessory/sweater/argyle/vest
	name = "argyle sweater vest"
	desc = "A warm, knit sweater vest with an argyle pattern."
	desc_extended = "Commonly made out of cotton or wool, but sometimes polyester or acrylic as well."
	icon_state = "argyle_sweater_vest"
	item_state = "argyle_sweater_vest"

/obj/item/clothing/accessory/sweater/visegradi
	name = "visegradi patterned sweater"
	desc = "A thick wool sweater, with a meandering pattern. These are typical of the planet Visegrad, where the wool is valued in both keeping the wearer dry and warm on the notoriously wet planet."
	icon = 'icons/obj/item/clothing/accessory/visegradi_sweater.dmi'
	icon_state = "visegradi_sweater"
	item_state = "visegradi_sweater"

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

/obj/item/clothing/accessory/wcoat_rec/det_vest
	var/open = FALSE
	desc = "A slick waistcoat."
	icon_state = "det_vest"
	item_state = "det_vest"
	contained_sprite = FALSE

/obj/item/clothing/accessory/wcoat_rec/det_vest/verb/unbutton()
	set name = "Unbutton Waistcoat"
	set category = "Object.Equipped"
	set src in usr

	if(!istype(usr, /mob/living))
		return
	if(use_check_and_message(usr))
		return

	var/mob/user = usr
	attack_self(user)

/obj/item/clothing/accessory/wcoat_rec/det_vest/attack_self(mob/user)
	open = !open
	icon_state = "[initial(icon_state)][open ? "_open" : ""]"
	item_state = icon_state
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	// the below forces the shirt to hard reset its image so it resets later its fucking weird ok
	inv_overlay = null

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

