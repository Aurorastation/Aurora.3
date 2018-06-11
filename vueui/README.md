# vueui - Vue.js based UI framework for SS13
This UI framework is mostly composed of four main parts:
 - Main JS file and supporting HTML code
 - UI DM datum, responsible for linking opened ui window with code
 - Object specific code, that generates data for uis, and handles actions.
 - Sub System responsible for keeping track of all uis and making sure they tick.
 
## How to use it?
### Step 1: Open ui
First we have to create a way to open ui, for example, a proc that's called when we want to open ui:
```DM
/datum/mydatum/proc/open_ui()
    var/datum/vueuiui/ui = SSvueui.get_open_ui(usr, src)
    if (!ui)
        ui = new(usr, src, "uiname", 300, 300)
    ui.open()
```
On first line we check if we already have open ui for this user, if we already have, then we just open it on last line, but if we don't have exisiting ui, we then create a new one.
### Step 2: Provide data
But how we pass data to it? There is two ways to do it, first one is to pass inital data in constructor: `new(usr, src, "uiname", 300, 300, data)`. But it's recommended to use `vueui_data_change` proc for data feed to ui.
```DM
/datum/mydatum/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueuiui/ui)
    if(!newdata)
        // generate new data
        return list("counter" = 0)
    // Here we can add checks for diffrence of state and alter it
    // or do actions depending on it's change
    if(newdata["counter"] >= 10) 
        return list("counter" = 0)
    return
```
Everytime DM receves of frontend state change it calls this proc to make sure that frontend state didn't go too far from actual data it should represent. If everything is alrigth with `newstate` and no push to frontend of data is needed then it should return `0` or `null`, else return data that should be pushed.
### Step 3: Handle actions.
Simply use `Topic` proc to get ui action calls.
```DM
/datum/vueuiuitest/Topic(href, href_list)
    if(href_list["action"] == "test")
        world << "Got Test Action! [href_list["data"]]"
    return
```
### Step 4: Make ui itself.
It is recomended to [enable debuging](.#debug-ui) for this step to make things easier. 

To create ui itself, you need to create `.vue` file inside `\vueui\components\ui` and register it inside `\vueui\components\ui\index.js`. Example vueui file:
```vue
<template>
    <div>
        <p>{{ counter }}</p>
        <bybutton :params="{ action: 'test', data: 'This is from ui.' }">Call topic</bybutton>
        <bybutton @click="counter++">Increment counter</bybutton>
    </div>
</template>

<script>
export default {
  name: 'ui-uiname',
  data() {
    return this.$root.$data.state; // Make data more easily acessible
  }
};
</script>

<style lang="scss" scoped>
p {
    font-size: 3em;
}
</style>
```
### Step 5: Compile
This ui framework requres whole ui to be compiled for changes to be avavible. Compilation requres Node.js runtime. To do initial dependency setup run `npm install` to gather all dependencies nedded for ui. Single compilation can be done with `npm run compile`, but if you constantly do changes, then `npm run run` is more convienient, as it compiles everything as soon as change is detected.
# Notes
## Usefull APIs
### `SSvueui.check_uis_for_change(object)`
Asks all ui's to call `object`'s `vueui_data_change` proc to make all uis up tp date. Should be used when bigger change was done or action done change that would affect data.
## Debug ui
To enable debug mode and make figuring out things easier do following steps:
 - Enable development mode inside wepbpack file by changing out commented out line 
```js
\vueui\webpack.config.js: line 7
   mode: 'production', // And comment this one out
   //mode: 'development', // Uncomment this line to set mode to development
```
 - Enable debuging inside ui datum. (This will always push new JS file each time open() is called and show data in JSON format at the end of ui)
```DM
\code\modules\vueui\ui.dm: line 5
#define UIDEBUG 0 // Change 0 to 1
```
 - Use `\vueui\template.html` in Internet explorer to use inspector to analyze ui behavour. Also don't forget to copy paste data data from actual ui to this debug ui. 

## UI components
### ByButton `<bybutton>`
Example:
```Vue
<bybutton :params="{ action: 'delete' }">Delete</bybutton>
```
Parameters:
 - `params` - key value pairs to send to `Topic` of object.
 - `icon` - icon that should be used in that button. For avavible icons look at `\vueui\styles\theme-nano.scss`
