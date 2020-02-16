# VueUi - Vue.js based UI framework for SS13
This UI framework is mostly composed of four main parts:
 - Main JS file and supporting HTML code
 - UI DM datum, responsible for linking opened ui window with code
 - Object specific code, that generates data for uis, and handles actions.
 - SubSystem responsible for keeping track of all uis and making sure they tick.

## How to use it?
### Step 1: Open ui
First we have to create a way to open ui, for example, a proc that's called when we want to open ui:
```DM
/datum/mydatum/ui_interact(mob/user)
    var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
    if (!ui)
        ui = new(user, src, "uiname", 300, 300, "Title of ui")
    ui.open()
```
On first line we check if we already have open ui for this user, if we already have, then we just open it on last line, but if we don't have existing ui, we then create a new one.
### Step 2: Provide data
But how we pass data to it? There are two ways to do it, first one is to pass initial data in constructor: `new(user, src, "uiname", 300, 300, "Title of ui", data)`. But it's recommended to use `vueui_data_change` proc for data feed to ui. More information is available [on different ways to provide data.](.#ways-to-provide-data-to-ui-more-easily)
```DM
/datum/mydatum/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
    if(!newdata)
        // generate new data
        return list("counter" = 0)
    // Here we can add checks for difference of state and alter it
    // or do actions depending on its change
    if(newdata["counter"] >= 10)
        return list("counter" = 0)
```
Every time server receives of front end state change it calls this proc to make sure that front end state didn't go too far from data it should represent. If everything is alright with `newstate` and no push to front end of data is needed then it should return `0` or `null`, else return data that should be pushed.
### Step 3: Handle actions.
Simply use `Topic` proc to get ui action calls from ui.
```DM
/datum/mydatum/Topic(href, href_list)
    if(href_list["action"] == "test")
        to_world("Got Test Action! [href_list["data"]]")
    return
```
### Step 4: Make ui itself.
It is recommended to [enable debugging](.#debug-ui) for this step to make things easier.

To create ui itself, you need to create `.vue` file somewhere in `\vueui\src\components\view`. Depending on location of .vue file depends on its component name. Example `\vueui\src\components\view\uiname.vue` file:
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
This ui framework requires whole ui to be compiled for changes to be available. Compilation requires Node.js runtime (>=13.6.0), that is obtainable in various ways, most common is install from official site. To do initial dependency setup run `npm install` to gather all dependencies needed for ui. Single compilation can be done with `npm run build-dev`, but if you constantly do changes, then `npm run dev` is more convenient, as it compiles everything as soon as change is detected. To make client side code better, you should also lint code with command `npm run lint`.
### Step 6: Add built files to repository
When changes are made to ui code updated compiled code is needed to be included with PR. To compile code for production run `npm run build`
## Ways to provide data to ui more easily
Currently there is multiple ways of providing data to ui, some are more advanced, others are simpler and get job done.
### 1. Var monitor
In other words, var monitor is just one-way link between object's vars and ui data. It is great when object has vars that can be directly passed to ui. All you need to do is to define somewhere vars to be monitored.
```DM
VUEUI_MONITOR_VARS(/datum/mydatum, mydatummonitor)
    watch_var("objects_var_name", "uis_var_name")
    watch_var("other_datum", "has_other_datum", CALLBACK(null, .proc/transform_to_boolean, FALSE))
```
In this example it monitors `/datum/mydatum/var/objects_var_name` and presents it to ui as `uis_var_name`. On last line we define other watcher, that has transform (sanitizer) callback function set. In this case it's set to call `/datum/vueui_var_monitor/proc/transform_to_boolean` right before var is transferred to ui data list. It also allows us to pass additional options to call back function, in this case it's boolean that determines if conversion is inverting. Other parameters passed to callback right after those defined in `CALLBACK` are: value of source var, last value of ui var, user that is interacting with ui, ui datum. `callback(..., var/source, var/current, var/mob/user, var/datum/vueui/ui)`
There is also plausibility to extend var monitors with other ways by extending default `vueui_data_change` proc. For example of this, you can look at `photocopier.dm`
### 2. Macro assist
This way is more primitive, but simpler and allows reverse data flow. Let's look at example:
```DM
/datum/mydatum/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
    if(!newdata)
        . = newdata = list()
    VUEUI_SET_CHECK(newdata["uis_var_name"], objects_var_name, ., newdata)
    VUEUI_SET_CHECK(newdata["has_other_datum"], !!other_datum, ., newdata)
    VUEUI_SET_CHECK_LIST(newdata["some_list"], other_list, ., newdata)
    VUEUI_SET_CHECK_IFNOTSET(newdata["text"], "[other_datum]", ., newdata)
```
This code functionally is same as example that is provided for var monitors. Macro `VUEUI_SET_CHECK` compare if first two params are equal, if not, then it makes them equal, and also sets third parameter to fourth one (I this case it sets `.` to `newdata`, what makes it return data). `VUEUI_SET_CHECK_LIST` should be used if the first two params are lists. `VUEUI_SET_CHECK_IFNOTSET` is almost exactly same, but it's checks if first var is not already set (is null), and if it is null, then it sets it.
### 3. Combination of both
```DM
VUEUI_MONITOR_VARS(/datum/mydatum, mydatummonitor)
    watch_var("objects_var_name", "uis_var_name")
    watch_var("other_datum", "has_other_datum", CALLBACK(null, .proc/transform_to_boolean, FALSE))

/datum/mydatum/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
    var/monitordata = ..()
    if(monitordata)
        . = data = monitordata
    VUEUI_SET_CHECK_IFNOTSET(data["text"], "[other_datum]", ., data)
```
# Notes
## Useful APIs
### `SSvueui.check_uis_for_change(object)`
Asks all uis to call `object`'s `vueui_data_change` proc to make all uis up tp date. Should be used when bigger change was done or action done change that would affect global data.
### `SSvueui.get_open_uis(object)`
Gets a list of all open uis for specified object. This allows to interact with individual uis.
### `SSvueui.close_uis(obj)`
Closes all open uis for specified object.
### `SSvueui.get_open_ui(user, obj)`
Gets a singular open UI for specified user and obj combination.
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
### `ui.resize(width, height)`
Resizes open UI to specified dimensions. Usefully when UI content changes size dramatically. Should be avoided in regular use.
### `ui.update_status()`
This call should be used if external change was detected. It checks if user still can use this ui, and what's its usability level.
### `ui.metadata`
This is helper variable meant to store references, or other data that is linked to that specific ui. This is just a helper field for keeping track of what goes where.
### `href_list["vueui"]`
This variable provides a way to obtain instance of ui that has invoked this `Topic()` call. Fast and simple way to safetly obtain it using this var is:
```DM
var/datum/vueui/ui = href_list["vueui"]
if(!istype(ui))
	return
```
## Debug ui
To enable debug mode and make figuring out things easier do following steps:
 - Enable development mode for ui by building it using `npm run build-dev` or `npm run dev` if you want it to auto rebuild on change.
 - Enable debugging for ui datum, by inserting this line anywhere. (This will always push new JS file each time open() is called and show data in JSON format at the end of ui)
```DM
#define UIDEBUG
```
 - Use URL provided by debug info in Internet explorer / Microsoft Edge to use inspector to analyze ui behaviour. 

## Vue syntax
You should look at [official Vue.js guide](https://vuejs.org/v2/guide/syntax.html). As it's more detailed and more accurate than any explanation that could have been written here.
### Data passed to uis
To access global metadata for this ui, use `this.$root.$data` or `$root.$data`, depending on context. To simplify access you can use following hack that links global data to local component data. It simplifies access to data. following explanation assumes you have done so. _Note: changes made on client side aren't sent to server, so **please** do not alter them._
```vue
<script>
export default {
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
 - `params` - key value pairs to send to `Topic` of object. Can contain objects or arrays (DM keyed lists and lists respectively).
 - `unsafe-params` - Used to execute a generic `Topic()` call to the game. Requires that you specify the `src` object as a valid reference, otherwise it will not function. **Should not generally be used**, primary use-case is backwards compatibility with older APIs that are spread out over multiple objects.
 - `icon` - icon that should be used in that button. For available icons look at `\vueui\styles\icons.scss`
 - `push-state` - Boolean determining if current ui state should be pushed on button click. This often results in `vueui_data_change` call right before `Topic` call.

Events:
 - `click` - Fires when button is clicked.

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
### VuiItem `<vui-item>` DEPRECATED
(Please use VuiGroup and VuiGroupItem)

Helper for making item lists using legacy nano styles.

Example:
```Vue
<vui-item label="Current health:">75%</vui-item>
```
Parameters:
 - `label` - Label to display next to contents
 - `balance` - This determines how much space is used by content compared to label. This parameter value should be between 0 and 1.

### VuiGroupItem `<vui-group-item>` and VuiGroup `<vui-group>`
Helper for making item lists. Automatically adjusts label width for optimal layout, makes space for content.
`VuiGroup` is container for items. It should contain vui-group-item or any element that has CSS `display: table-row`.
Example:
```Vue
<vui-group>
    <vui-group-item label="Current health:">75%</vui-item>
</vui-group>
```
Parameters:
 - `label` - Label to display next to contents.

### VuiTooltip `<vui-tooltip>`
Helper to getting nice tooltips when you hover over text. Works with buttons.

Example:
```Vue
<vui-tooltip label="VUI">VueUi UI element<vui-tooltip>
<vui-tooltip><template v-slot:label>ADV</template>Advanced use of tooltips</vui-tooltip>
```
Parameters:
 - `$slot` - Contents of tooltip
 - `$slot:label` - Actual content that is always shown. If slot is set, `label` parameter is ignored.
 - `label` - Actual text that is always shown

### VuiInputNumeric `<vui-input-numeric>`
Numeric input helper to help inputting large and small numbers.

Example:
```Vue
<vui-input-numeric width="2.5em" v-model="number" :min="1" :max="10"/>
```
Parameters:
 - `value` - Initial value for input.
 - `button-count` - How many -/+ buttons to show on each side.
 - `min` - Minimum value.
 - `max` - Maximum value.
 - `push-state` - Boolean determining if current ui state should be pushed on input change.
 - `width` - Determines width of input text field.
 - `decimal-places` - How many decimal places are allowed.

Events:
 - `input` - Fires when value changes. Value is number currently entered.

### VuiInputSearch `<vui-input-search>`
Search text field to filter objects in user input.

Example:
```Vue
<vui-input-search :input="[{name: 'Bret'}, {name: 'Andrea'}]" v-model="output" :keys="['name']"/>
```
Parameters:
 - `input` - Initial array with elements to search.
 - `keys` - Array of strings listing keys to be searched.
 - `include-score` - Includes internal search score in the results. `{item: x, score: (0 to 1)}`. 0 - means perfect match.
 - `threshold` - Determines maximum score at witch results are cut off.

Events:
 - `input` - Fires when search text changes. Event value is new sorted array.
