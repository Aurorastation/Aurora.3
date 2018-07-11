# vueui - Vue.js based UI framework for SS13
This UI framework is mostly composed of four main parts:
 - Main JS file and supporting HTML code
 - UI DM datum, responsible for linking opened ui window with code
 - Object specific code, that generates data for uis, and handles actions.
 - SubSystem responsible for keeping track of all uis and making sure they tick.
 
## How to use it?
### Step 1: Open ui
First we have to create a way to open ui, for example, a proc that's called when we want to open ui:
```DM
/datum/mydatum/proc/open_ui()
    var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
    if (!ui)
        ui = new(usr, src, "uiname", 300, 300, "Title of ui")
    ui.open()
```
On first line we check if we already have open ui for this user, if we already have, then we just open it on last line, but if we don't have existing ui, we then create a new one.
### Step 2: Provide data
But how we pass data to it? There is two ways to do it, first one is to pass initial data in constructor: `new(usr, src, "uiname", 300, 300, "Title of ui", data)`. But it's recommended to use `vueui_data_change` proc for data feed to ui.
```DM
/datum/mydatum/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
    if(!newdata)
        // generate new data
        return list("counter" = 0)
    // Here we can add checks for difference of state and alter it
    // or do actions depending on it's change
    if(newdata["counter"] >= 10) 
        return list("counter" = 0)
```
Every time server receives of front end state change it calls this proc to make sure that front end state didn't go too far from data it should represent. If everything is alright with `newstate` and no push to front end of data is needed then it should return `0` or `null`, else return data that should be pushed.
### Step 3: Handle actions.
Simply use `Topic` proc to get ui action calls from ui.
```DM
/datum/mydatum/Topic(href, href_list)
    if(href_list["action"] == "test")
        world << "Got Test Action! [href_list["data"]]"
    return
```
### Step 4: Make ui itself.
It is recommended to [enable debugging](.#debug-ui) for this step to make things easier. 

To create ui itself, you need to create `.vue` file somewhere in `\vueui\src\components\view`. Example vueui file:
```vue
<template>
    <div>
        <p>{{ counter }}</p>
        <vui-button :params="{ action: 'test', data: 'This is from ui.' }">Call topic</vui-button>
        <vui-button @click="counter++">Increment counter</vui-button>
    </div>
</template>

<script>
export default {
  name: 'view-uiname',
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>

<style lang="scss" scoped>
p {
    font-size: 3em;
}
</style>
```
### Step 5: Compile and lint
This ui framework requires whole ui to be compiled for changes to be available. Compilation requires Node.js runtime, that is obtainable in various ways, most common is install from official site. To do initial dependency setup run `npm install` to gather all dependencies needed for ui. Single compilation can be done with `npm run build-dev`, but if you constantly do changes, then `npm run dev` is more convenient, as it compiles everything as soon as change is detected. To make client side code better, you should also lint code with command `npm run lint`.
### Step 6: Add built files to repository
When changes are made to ui code updated compiled code is needed to be included with PR. To compile code for production run `npm run build`
# Notes
## Useful APIs
### `SSvueui.check_uis_for_change(object)`
Asks all uis to call `object`'s `vueui_data_change` proc to make all uis up tp date. Should be used when bigger change was done or action done change that would affect global data.
### `SSvueui.get_open_uis(object)`
Gets a list of all open uis for specified object. This allows to interact with individual uis. 
### `ui.activeui`
Determines currently active view component for this ui datum. Should be combines with `check_for_change()` or `push_change()`. 

It is also plausible for server to send templates dynamically. First character of template should be `?` to specify to vueui that its going to be not recompiled `view` component, but a template. Also template should have single root element. Example for such component would be `?<span>Time since server boot: {{ $root.$data.wtime / 2 }} seconds.</span>`
### `ui.header`
Determines header component that is used with this ui. Should be set before `ui.open()`.
### `ui.auto_update_content`
Checks for change using `ui.check_for_change()` every `process()` tick of `SSvueui` (what is approximately 2 seconds). This should be only used when data changes unpredictably.
### `ui.open()`
Tries to open this ui, and sends all necessary assets for proper ui rendering. If ui has no data, then calls `object.vueui_data_change(null ...)` to obtain initial ui data.
### `ui.send_asset(name)`
Sends singular asset to client for use in ui, after this call you might need to update client-side asset index. To do so call `push_change(null)`.
### `ui.add_asset(name, image)`
Adds asset for ui use, but does not send it to client. It will be sent in during next `ui.open()` call or if it's done manually with `ui.send_asset(name)` combined with `push_change(null)`.
### `ui.remove_asset(name)`
Removes asset from future use in ui. But client-side asset index isn't updated immediately to reflect removal of asset.
### `ui.push_change(data).`
Pushes data change to client. This also pushes changes to metadata, what includes: title, world time, ui status, active ui component, client-side asset index.
### `ui.check_for_change(forcedPush)`
Checks with `object.vueui_data_change` if data has changed, if so, then change is pushed. If forcedPush is true, then it pushes change anyways.
### `ui.update_status()`
This call should be used if external change was detected. It checks if user still can use this ui, and what's its usability level.
## Debug ui
To enable debug mode and make figuring out things easier do following steps:
 - Enable development mode for ui by building it using `npm run build-dev` or `npm run dev` if you want it to auto rebuild on change.
 - Enable debugging for ui datum, by inserting this line anywhere. (This will always push new JS file each time open() is called and show data in JSON format at the end of ui)
```DM
#define UIDEBUG
```
 - Use `\vueui\template.html` in Internet explorer / Microsoft Edge to use inspector to analyze ui behaviour. Also don't forget to copy paste data from actual ui to this debug ui inside template's code. 

## Vue syntax
You should look at [official Vue.js guide](https://vuejs.org/v2/guide/syntax.html). As it's more detailed and more accurate than any explanation that could have been written here.
### Data passed to uis
To access global metadata for this ui, use `this.$root.$data` or `$root.$data`, depending on context. To simplify access you can use following hack that links global data to local component data. It simplifies access to data. following explanation assumes you have done so. _Note: changes made on client side aren't sent to server, so **please** do not alter them._
```vue
<script>
export default {
    name: 'view-name',
    data() {
        return this.$root.$data;
    }
};
</script>
```
#### `state` - Representation of `ui.data` inside ui.
This is outside metadata, so changes to this variable can be made, but this variable is expected to be a object or how BYOND calls it - a keyed list, using other type *will* cause errors. This variable is main way to interact with server without using `Topic()`.

Note: `state` can get very out of sync with `ui.data`, this often occur on rapid changes. So to make sure latest data gets to ui datum, when ui data is needed for usage, `<vui-button>` parameter `push-state` should be set. Example: `<vui-button push-state :params="{copy: 1}">Copy</vui-button>` in photocopier.vue - makes sure that copy amount is up to date. When `state` object is huge, it's discouraged to solve this issue like this. Then it should be solved by sending needed data inside `params`.
#### `wtime` - Global world time since boot, client side guess of `word.time`
This is constantly counting counter updated every 200ms representing time since server has started. This should be used for displaying counters, timers, as it doesn't depend on pushed state so much, so it allows making better user experiences.
#### `title` - This ui's title, copy of `ui.title`
This uis title, mostly used by header components.
#### `status` - Interactivity status, mirror of `ui.status`
Topic status, used to determine how interactive is ui. Meanings of numbers can be seen `\code\__defines\machinery.dm`.
#### `assets` - This makes `add_asset`, `remove_asset` and `<vui-img>` tick
As described, this makes them tick. This ***should*** shouldn't be used, unless you know what you are doing.
#### `active` - Representation of `ui.activeui`
This determines what component / template should be used to display data.
#### `uiref` - Reference for ui datum
Reference to ui datum is used by state updates, and `<vui-button>` to make appropriate requests.
## UI components
### VuiButton `<vui-button>`
Button programmed to send provided data to ui object. Comes with icon support.

Example:
```Vue
<vui-button :params="{ action: 'delete' }" icon="trash">Delete</vui-button>
```
Parameters:
 - `$slot` - Contents of button.
 - `params` - key value pairs to send to `Topic` of object.
 - `icon` - icon that should be used in that button. For available icons look at `\vueui\styles\icons.scss`
 - `push-state` - Boolean determining if current ui state should be pushed on button click. This often results in `vueui_data_change` call right before `Topic` call.

### VuiProgress `<vui-progress>`
Simple progress bar for representing progress of a process or indicate status.

Example:
```Vue
<vui-progress :value="50"></vui-progress>
```
Parameters:
 - `value` - numerical value to display. Should be used with binding.
 - `max` - maximum value of provided value's range. Should be used with binding.
 - `min` - minimum value of provided value's range. Should be used with binding.

### VuiImg `<vui-img>`
Wrapper for showing images added with ui proc `ui.add_asset(name, image)`. Please note: images are sent to client when `open()` is called, if it's added after, then `send_asset(name)` should be used, also image index is sent with next data change, if immediate image change is needed then `check_for_change(1)` or `push_change(null)` should be used to send index.

Example:
```Vue
<vui-img name="my-image-name"></vui-img>
```
Parameters:
 - `name` - name of asset to show that was sent to client. 
Please note that regular `<img>` parameters apply here.
### VuiImg `<vui-item>`
Helper for making item lists using legacy nano styles.

Example:
```Vue
<vui-item label="Current health:">75%</vui-item>
```
Parameters:
 - `label` - Label to display next to contents
 - `balance` - This determines how much space is used by content compared to label. This parameter value should be between 0 and 1.

