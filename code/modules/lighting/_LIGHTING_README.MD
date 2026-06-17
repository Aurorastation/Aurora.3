# The Lighting Systems
## Introduction

Hello reader, and welcome to the coders guide to lighting. TGMC uses three different lighting systems: Static Lighting, Movable Lighting and Hybrid Lighting
These all have their pros and cons, and are explained later in this file.
For now we will look at the frameworks we have pertaining to lighting.

```dm
//Our vars:
//The "intensity" of our light to determine how much it actually lights up
var/light_power
// The range of our light, aka how many turfs are actually lit up
var/light_range
//the color of our light
var/light_color
///whether the light is actually on or not, use /atom/proc/turn_on() to set this
var/light_on
```

Additionally, we have SSlighting, the lighting subsystem which handles lighting updates for Static and Hybrid lighting.
This subsystems processes enqueued lighting object, corner and source updates, as well as taking enqueued hybrid lighting updates.
You shouldnt really be touching this as it primarily just stops too many updates from happening at once.

## The Lighting systems
As mentioned previously,lighting is split into three seperate systems who's functionality, benefits and downsides will be discussed below

Seperate from these systems we also have a system to update the base lighting of an area, we do this using "Base lighting"

```dm
/area/proc/set_base_lighting(new_base_lighting_color = -1, new_alpha = -1)
```
Use this to set areas as required to luminosity. This is expensive-ish to apply/update but is very cheap to maintain. It also enables area specific light intensity and color changes.

### Static Lighting
Static lighting consists of a single, static_lighting_source light source which gets all turfs in view, then tells their /datum/static_lighting_objects to update themselves. These lighting objects manage two things: lighting corners, and an underlay. The lighting corners hold data for the edges of turfs next to darkness to allow a smooth transition from dark to light, and the actual lighting is done using an underlay which is layered over the darkness layer in order to create light. Color is changed using a color matrix.
The advantage of this system, is that it is cheap, as long as it does not need to actively update opacity changes or a moving light target.
This system can also be used for as large lights as you want.
The disadvantage however is that updating this type of light, such as when it moves is relatively expensive, and colors are not always the prettiest. Additionally, lighting corners are known to be a large source of RAM usage and thus you should only load lighting objects in areas hat it is needed using /area/var/static_lighting.
Thus this should be your go to choice for large, frequent, immobile lights.

To update lights using this system use
```dm
/atom/proc/set_light(l_range, l_power, l_color, mask_type)
```
Note that the use of mask_type only is applicable to Hybrid lights.

### Movable lighting
Movable lighting is extremely simple and cheap as it requires no updates. This is done by replacing a large amount of updating objects with one single, large vis_contents overlay, which we apply and manage through a component (/datum/component/overlay_lighting). This means that it will move smoothly when the owner moves and requires no updating, but also means that rendering issues might occur, where the overlay will seemingly "pop in" to existence as it suddenly renders when someone walks around a corner or into the 1/2-tile render buffer around the edges of the viewport.
Thus this should be your go to ideal cheap light for small and mobile lights (NOT turfs or anchored objects!). This light also typically has more saturated colors than static lighting.

Note that this lighting type utilises special update procs from the other two lighting types, specifically
```dm
//update light variables
/atom/movable/proc/set_light_range_power_color(range, power, color)
	set_light_range(range)
	set_light_power(power)
	set_light_color(color)

//turn the light on and off without changing any variables
/atom/proc/set_light_on(new_value)
```

### Overlay lighting
Overlay lighting is the movable client-side light path. It uses generated overlay visuals instead of the old Aurora mask objects, which were removed during the tg lighting port. As a result, it has a higher drain on player GPU and you should avoid using many large overlay lights around players on weaker computers. Most items will be fine using this except for light fixtures, as lag mostly seems to crop up from multiple large lighting sources.
Using lights for turf based fires and large floodlights is thus fine, but be careful with frequent use.
This system also supports non-round lights, such as light cones, rotating lights, and shimmering lights through vars like
```dm
var/light_angle
var/light_dir
var/light_render_source
```
and through `/datum/light_middleman` when a caller needs to intercept and animate overlay light appearances.

Actual updates are handled through the same light setter procs as complex lighting.
