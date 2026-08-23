GLOBAL_LIST_EMPTY(consistent_pick_cache)

/*
# Explanation of what this is, and what problem it is trying to solve.

Example scenario: You want a table with a random wood type. Tables are composed of multiple parts.
The problem: If you just use `/obj/random/table`, then you will have a single table that's all wrong, made from different wood types.
The solution: Consistent randomness. In this case, area-consistent. It returns the same thing when called different times in the same area.

The `consistent_pick_cache` is basically a 2-level assoc list:
```
GLOB.consistent_pick_cache = list(
    /area/example1 = list(
        /obj/random/table = /obj/structure/table/wood/bamboo,
    ),
    /area/example2 = list(
        /obj/random/table = /obj/structure/table/wood/maple,
    ),
)
```

*/

/**
 * Picks an item from a list consistently based on a scope and identifier.
 * @param choices List of items to pick from.
 * @param scope_key The group boundary (like an /area datum).
 * @param identifier Unique key for this specific roll (like src.type or a string name).
 */
/proc/pick_consistent(list/choices, scope_key, identifier)
    if(!length(choices))
        return null
    if(!scope_key)
        return pick(choices)

    // Fallback identifier if omitted
    identifier = identifier || "\ref[choices]"

    var/list/scope_cache = GLOB.consistent_pick_cache[scope_key]
    if(scope_cache?[identifier])
        return scope_cache[identifier]

    var/picked = pick(choices)

    if(!scope_cache)
        GLOB.consistent_pick_cache[scope_key] = list()
    GLOB.consistent_pick_cache[scope_key][identifier] = picked

    return picked

/// Consistent within the same /area
/proc/pick_area_consistent(list/choices, atom/context, identifier = null)
    var/area/area = isarea(context) ? context : get_area(context)
    if(!area)
        return pick(choices)
    return pick_consistent(choices, area, identifier || context?.type)

// /// Consistent within a specific map template load
// /// Can get the template via `var/datum/map_template/template = GLOB.map_templates["[z]"]`
// /proc/pick_maptemplate_consistent(list/choices, template_id, identifier = null)
//     if(!template_id)
//         return pick(choices)
//     return pick_consistent(choices, "template_[template_id]", identifier)
