// Thanks Lohikar!
// Off-set by 26px pls

/obj/machinery/glove_dispenser
    name = "Glove Dispenser"
    desc = "A quick dispenser for sterile gloves."
    icon = 'icons/obj/machines/glove_dispenser.dmi'
    icon_state = "gdisp_l"
    var/target_type = /obj/item/clothing/gloves/latex
    var/amount = 7
    anchored = 1
    density = 0

/obj/machinery/glove_dispenser/attack_hand(mob/living/user)
    if (use_check(user, USE_DISALLOW_SILICONS))
        return
    if (!amount)
        user << "This dispenser is empty."
        return
    if (amount)
        new target_type(loc)
        amount--
    update_icon()

/obj/machinery/glove_dispenser/attackby(obj/item/weapon/W as obj, mob/user as mob)
    if (isscrewdriver(W))
        playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
        if (anchored)
            anchored = 0
            user << "You screw the dispenser loose."
        else
            anchored = 1
            user << "You screw the dispenser in place."

/obj/machinery/glove_dispenser/update_icon()
    if (!amount)
        icon_state = "gdisp_empty"
    else
        icon_state = "gdisp_l"

// Nitrile version Below.

/obj/machinery/glove_dispenser/nitrile
    name = "Nitrile Glove Dispenser"
    desc = "A quick dispenser for sterile gloves. This one's for Nitrile."
    icon = 'icons/obj/machines/glove_dispenser.dmi'
    icon_state = "gdisp_n"
    target_type = /obj/item/clothing/gloves/latex/nitrile
    amount = 7
    anchored = 1
    density = 0

/obj/machinery/glove_dispenser/nitrile/attack_hand(mob/living/user)
    if (use_check(user, USE_DISALLOW_SILICONS))
        return
    if (!amount)
        user << "This dispenser is empty."
        return
    if (amount)
        new target_type(loc)
        amount--
    update_icon()

/obj/machinery/glove_dispenser/nitrile/attackby(obj/item/weapon/W as obj, mob/user as mob)
    if (isscrewdriver(W))
        playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
        if (anchored)
            anchored = 0
            user << "You screw the dispenser loose."
        else
            anchored = 1
            user << "You screw the dispenser in place."

/obj/machinery/glove_dispenser/nitrile/update_icon()
    if (!amount)
        icon_state = "gdisp_empty"
    else
        icon_state = "gdisp_n"