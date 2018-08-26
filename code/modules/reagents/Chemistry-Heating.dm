//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/reagent_heating/
	name = "Heater"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	layer = 2.9
	var/beaker = null
	var/temp_delta = 5
	var/max_delta = 5

/obj/machinery/reagent_heating/ui_interact(mob/user)
    var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
    if (!ui)
        ui = new(user, src, "uiname", 300, 300, "[name]")
    ui.open()

/obj/machinery/reagent_heating/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
    if(!newdata)
        // generate new data
        return list("counter" = 0)
    // Here we can add checks for difference of state and alter it
    // or do actions depending on its change
    if(newdata["counter"] >= 10) 
        return list("counter" = 0)