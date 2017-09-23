/obj/machinery/case_button
    name = "Forcefield Button"
    desc = "A button in a case protected with a forcefield."
    icon = 'icons/obj/glasscasebutton.dmi'
    icon_state = "c1"
    anchored = 1
    use_power = 1
    idle_power_usage = 2000 //2kW because of the forcefield
    active_power_usage = 2000 //2kW because of the forcefield
    power_channel = EQUIP
    //Style variables
    var/case = 1 //What case to use - c value
    var/cover = 1 //What cover to use - g value
    var/button = 1 //What button to use - b value
    //Status variables
    var/covered = 1 //If the cover is active
    var/active = 0 //If the button is active
    var/button_type = "button_case_generic" //Button type for the listener TODO: Add a listener to sync the button active state
    var/listener/listener //Listener for button updates

/obj/machinery/case_button/Initialize()
    listener = new(button_type, src)
    update_icon()

/obj/machinery/case_button/Destroy()
    QDEL_NULL(listener)

/obj/machinery/case_button/attackby(obj/item/weapon/W, mob/user)
    if(istype(W, /obj/item/weapon/card))
        if(access_keycard_auth in W.GetAccess())
            covered = !covered //Enable / Disable the forcefield
    else
        if(covered && (stat & NOPOWER)) //Only bounce off if its powered (i.e. shield active)
            user.visible_message("<span class='danger'>[src] has been hit by [user] with [W], but it bounces off the forcefield</span>","<span class='danger'>You hit [src] with [W], but it bounces off the forcefield</span>","You hear something boucing off a forcefield")
        else
            ..()
    update_icon()
    return

/obj/machinery/case_button/attack_hand(mob/user as mob)
    if(covered == 0)
        if(!active)
            if(activate(user))
                for(var/obj/machinery/case_button/cb in get_listeners_by_type(button_type,/obj/machinery/case_button))
                    cb.active = 1
                    cb.update_icon()
        else
            if(deactivate(user))
                for(var/obj/machinery/case_button/cb in get_listeners_by_type(button_type,/obj/machinery/case_button))
                    cb.active = 0
                    cb.update_icon()
    else
        ..()
    return

/obj/machinery/case_button/power_change()
    . = ..()
    update_icon()
    return

/obj/machinery/case_button/update_icon()
    cut_overlays()
    if(stat & NOPOWER)
        update_use_power(0)
        add_overlay("b[button]d") //Add the deactivated button overlay
        add_overlay("g[cover]d") //add the deactivated cover overlay
        return
    add_overlay("b[button][active]") //Add the button as overlay
    add_overlay("g[cover][covered]") //Add the glass/shield overlay
    return

//Activate the button - Needs to return 1 for the activation to be successful
/obj/machinery/case_button/proc/activate(mob/user)
    user.visible_message("<span class='notice'>\The [user] presses the button</span>","<span class='notice'>You press the button</span>","You hear something being pressed")
    return 1

//Deactivate Button - Needs ro return 1 for the activation to be successful
/obj/machinery/case_button/proc/deactivate(mob/user)
    user.visible_message("<span class='notice'>\The [user] resets the button</span>","<span class='notice'>You rests the button</span>","You hear something being pressed")
    return 1

/obj/machinery/case_button/shuttle
    name = "Emergency Shuttle Button"
    desc = "A button in a case protected with a forcefield."
    button_type = "button_case_emergencyshuttle"

/obj/machinery/case_button/shuttle/activate(mob/user)
    ..()
    return call_shuttle_proc(user)

/obj/machinery/case_button/shuttle/deactivate(mob/user)
    ..()
    return cancel_call_proc(user)