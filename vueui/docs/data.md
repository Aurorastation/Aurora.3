# Different ways to provide data
VueUI framework is flexible and reliable as long as you select one data flow or are aware of how combining them affects everything.
## Direct data
This solution might be the easiest but most dangerous. This involves directly editing UIs data object.
### UI open code
In this case we open ui with initial data.
```DM
/datum/mydatum/ui_interact(mob/user)
    // Attempt to obtain existing UI object for user.
    var/datum/vueui/ui = SSvueui.get_open_ui(user, src)

    // We do not have open UI. So we make new one
    if (!ui)
        var/list/data = list("counter" = 0)
        ui = new(user, src, "uiname", 300, 300, "Title of ui", data)

    // Or we edit data variable directly.
    // If we modify data variable after open() then it won't be sent to client.
    ui.data["field"] = "value"

    // We may also set metadata here to store some state in UI object itself, meta data is only present on server and it's not ever altered.
    ui.metadata = list("other" = otherdatum)
    ui.open()
```
### Topic code
```DM
/datum/mydatum/Topic(href, href_list)
    // We do not need to check for change in direct mode
    . = FALSE
    // We obtain our current UI that invoked this Topic call
    var/datum/vueui/ui = href_list["vueui"]
    if(!istype(ui))
        return

    if(href_list["action"] == "test")
        // My action code
        // ...

        // If we want to modify data of only this UI that invoked
        ui.data["field"] = "value"
        // And we push changed data to client
        ui.push_change(null)

        // Or if we want to push and override whole data object
        ui.push_change(list("counter" = 0))
        // This line is same as
        ui.data = list("counter" = 0)
        ui.push_change(null)

        // If we want to modify data to all UIs we have to iterate over them all.
        for (var/U in get_open_uis(src))
            var/datum/vueui/ui = U

            // Here we must check if UI should receive change
            if(ui.status <= STATUS_DISABLED)
                continue
            
            // Do our ui change code here
            ui.data["field"] = "value"
		    ui.push_change(null)
    return
```
### Data change code
```DM
/datum/mydatum/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
    // We always return ui.data so we do not allow client UI to alter data.
    return ui.data
```
### Explanation how it works.
VueUI main server side data object is stored at `ui.data` and it is source from where client UI primary receives data when when `push_change()` is called. It may be altered from `push_change()` if it's being called with argument. Other source of it being altered is from `vueui_data_change` method, so we should override it and and make sure we always return `ui.data`.