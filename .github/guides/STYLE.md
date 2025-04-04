# Style Guide
This is the style you must follow when writing code. It's important to note that large parts of the codebase do not consistently follow these rules, but this does not free you of the requirement to follow them. Exceptions might be granted (primarily for ports) at the discretion of the devs.

Thank you to /tg/station for the original style guide, from which this was adapted from.

1. [General Guidelines](#general-guidelines)
2. [Paths and Inheritence](#paths-and-inheritence)
3. [Variables](#variables)
4. [Procs](#procs)
5. [Macros](#macros)
6. [Documentation](#documentation)

## General Guidelines

### Tabs, not spaces
You must use tabs to indent your code, NOT SPACES.

Do not use tabs/spaces for indentation in the middle of a code line. Not only is this inconsistent because the size of a tab is undefined, but it means that, should the line you're aligning to change size at all, we have to adjust a ton of other code. Plus, it often time hurts readability.

```dm
// Bad
#define SPECIES_VAURCA			"vaurca"
#define SPECIES_UNATHI			"unathi"
#define SPECIES_TAJARA			"tajara"

// Good
#define SPECIES_VAURCA "vaurca"
#define SPECIES_UNATHI "unathi"
#define SPECIES_TAJARA "tajara"
```

### Control statements
(if, while, for, etc)

* No control statement may contain code on the same line as the statement (`if (blah) return`)
* All control statements comparing a variable to a number should use the formula of `thing` `operator` `number`, not the reverse (eg: `if (count <= 10)` not `if (10 >= count)`)
* Chained conditions that are checked only once for existence should be collapsed (eg: `if(thing.my_variable?.my_other_variable)` not `if(thing.my_variable && thing.my_variable.my_other_variable)`)
* Unless necessary (eg. in a macro), C-style code must **not** be used (eg: `if(something){do_something();}` would be wrong)

#### Iteration over ranges and lists
Iterations over number ranges should generally be done with a `for(var/<var> in <start_number> to <end_number>)` loop

Iterations over lists should generally be done with a `for(var/<var> in <list>)` loop

```dm
// Good! The underscore is a convention to indicate that the iterator is not important
// the structure of the loop indicates the range in numbers
for(var/_ in 1 to 10)
	// do stuff

// Good! The variable is typed, with a descriptive name of the object it's iterating over
for(var/obj/item/items_in_mob_backpack in mob.backpack_contents)
	// do stuff

// Good! This would indicate that we are assured that the list mob.backpack_contents only contains /obj/item instances
// we know that because we have declared it as var/list/obj/item/backpack_contents, 
// so we espect the content to be of the correct type already
for(var/obj/item/items_in_mob_backpack as anything in mob.backpack_contents)
	// do stuff

// Bad! There is no reason to take the iterator here, not only it's harder to read and follow,
// it also loses efficiency as you're allocating two vars when you can avoid it
for(var/i in length(mob.backpack_contents))
	var/obj/item/item_in_mob_backpack = mob.backpack_contents[i]
	// do stuff with item_in_mob_backpack

// Egregiously bad! Ontop of what said above, you should generally never use C-style code, especially if avoidable
for(var/i = 0, i < length(mob.backpack_contents), i++)
	var/obj/item/item_in_mob_backpack = mob.backpack_contents[i]
	// do stuff with item_in_mob_backpack
// Did you catch that? This would crash because list indexes starts at 1, not 0, also the condition is wrong even if you fix the starting number
// and it would skip one element; it's also slightly slower. Now you see why you shouldn't use this if possible
```

Exceptions can apply for performance reasons or for special cases, eg a subsystem that has to interrupt the iterations and resume later could use a `while` loop and store the index for when it resumes, however without a valid, good reason, you should stick to this.

### Operators
#### Spacing
* Operators that should be separated by spaces
	* Boolean and logic operators like &&, || <, >, ==, etc (but not !)
	* Bitwise AND &
	* Argument separator operators like , (and ; when used in a forloop)
	* Assignment operators like = or += or the like
* Operators that should not be separated by spaces
	* Access operators like . and :
	* Parentheses ()
	* Logical not !
	* Bitwise NOT ~
	* Increment/decrement operators ++, --
* Operators that might or might not be separated by spaces (depends on readability):
	* Bitwise OR |

Math operators like +, -, /, *, etc are up in the air, just choose which version looks more readable.

#### Use
* Bitwise AND - '&'
	* Should be written as `variable & CONSTANT` NEVER `CONSTANT & variable`. Both are valid, but the latter is confusing and nonstandard.
* Associated lists declarations must have their key value quoted if it's a string
	* WRONG: `list(a = "b")`
	* RIGHT: `list("a" = "b")`

### Use static instead of global
DM has a var keyword, called global. This var keyword is for vars inside of types. For instance:

```DM
/mob
	var/global/thing = TRUE
```
This does NOT mean that you can access it everywhere like a global var. Instead, it means that that var will only exist once for all instances of its type.

There is also an undocumented keyword called `static` that has the same behaviour as global but more correctly describes BYOND's behaviour. Therefore, we always use static instead of global where we need it.

### Use early returns (also called guard clauses)
Do not enclose a proc in an if-block when returning on a condition is more feasible
This is bad:
````DM
/datum/datum1/proc/proc1()
	if (thing1)
		if (!thing2)
			if (thing3 == 30)
				do stuff
````
This is good:
````DM
/datum/datum1/proc/proc1()
	if (!thing1)
		return
	if (thing2)
		return
	if (thing3 != 30)
		return
	do stuff
````
This prevents nesting levels from getting deeper then they need to be.

### No magic numbers or strings
This means stuff like having a "mode" variable for an object set to "1" or "2" with no clear indicator of what that means. Make these #defines with a name that more clearly states what it's for.

For instance, this is bad:
````DM
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(1)
			(...)
		if(2)
			(...)
````

Instead, you need to do something like this:
````DM
#define DO_THE_THING_REALLY_HARD 1
#define DO_THE_THING_EFFICIENTLY 2
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(DO_THE_THING_REALLY_HARD)
			(...)
		if(DO_THE_THING_EFFICIENTLY)
			(...)
````

### Use our time defines

The codebase contains some defines which will automatically multiply a number by the correct amount to get a number in deciseconds. Using these is prefered over using a literal amount in deciseconds.

The defines are as follows:
* SECONDS
* MINUTES
* HOURS

This is bad:
````DM
/datum/datum1/proc/proc1()
	if(do_after(mob, 15))
		mob.dothing()
````

This is good:
````DM
/datum/datum1/proc/proc1()
	if(do_after(mob, 1.5 SECONDS))
		mob.dothing()
````

## Paths and Inheritence
### All BYOND paths must contain the full path
(i.e. absolute pathing)

DM will allow you nest almost any type keyword into a block, such as:

```DM
// Not our style!
datum
	datum1
		var
			varname1 = 1
			varname2
			static
				varname3
				varname4
		proc
			proc1()
				code
			proc2()
				code
```

The use of this is not allowed in this project as it makes finding definitions via full text searching next to impossible. The only exception is the variables of an object may be nested to the object, but must not nest further.

The previous code made compliant:

```DM
// Matches Aurorastation style.
/datum/datum1
	var/varname1
	var/varname2
	var/static/varname3
	var/static/varname4

/datum/datum1/proc/proc1()
	code
/datum/datum1/proc/proc2()
	code
```

### Type paths must begin with a `/`
eg: `/datum/thing`, not `datum/thing`, outside of proc parameters definitions

### Type paths must be snake case
eg: `/datum/blue_bird`, not `/datum/BLUEBIRD` or `/datum/BlueBird` or `/datum/Bluebird` or `/datum/blueBird`

### Datum type paths must began with "datum"
In DM, this is optional, but omitting it makes finding definitions harder.

### Abstract types
All types that are not meant to be instantiated directly because they should be derived from must be declared as abstract types, eg:
```dm
ABSTRACT_TYPE(/obj/item/animal)
	code
```

You should use abstract types when possible and sensible to provide the functionality without delving into the implementation details, and then derive from it with the implementation details.
For example, the above code would describe what an animal does (eg. with walk(), eat(), run() or whatever), then the derivate types would specify the implementation details, eg. an elephant would flattern whoever it's run against, while a mouse would just run below the person. This is highly subjective where goes where (and to what extent), but it's a good practice to follow where reasonable

## Variables

### Use `var/name` format when declaring variables
While DM allows other ways of declaring variables, this one should be used for consistency.

### Use descriptive and obvious names
Optimize for readability, not writability. While it is certainly easier to write `M` than `victim`, it will cause issues down the line for other developers to figure out what exactly your code is doing, even if you think the variable's purpose is obvious.
The **only** exception to this rule is for variables used in short loops, or `for` loops with the well known variables `i` (index, used on a flat list) and `k` (key, used on a keyed list).

#### Any variable or argument that holds time and uses a unit of time other than decisecond must include the unit of time in the name.
For example, a proc argument named `delta_time` that marks the seconds between fires could confuse somebody who assumes it stores deciseconds. Naming it `delta_time_seconds` makes this clearer, naming it `seconds_per_tick` makes its purpose even clearer.

### Don't use abbreviations
Avoid variables like C, M, and H. Prefer descriptive names like "user", "victim", "weapon", etc.

```dm
// What is M? The user? The target?
// What is A? The target? The item?
/proc/use_item(mob/M, atom/A)

// Much better!
/proc/use_item(mob/user, atom/target)
```

The use of this kind of abbreviations is not allowed in proc arguments (in the proc signature) nor as variables of types.

Unless it is otherwise obvious, try to avoid just extending variables like "C" to "carbon"--this is slightly more helpful, but does not describe the *context* of the use of the variable.

### Declare types whenever possible
Variables should be declared with their type, eg:
```dm
/obj/item/something
	var/mob/living/carbon/carbon_target
```

This also applies to lists, though at the moment DM doesn't do anything, the list should express the type of elements it will contain (unless it's an associative list), eg:
```dm
/obj/item/something
	var/list/mob/carbon/human/human_targets_hit = list()
```

Associative lists are exempted from this, they should be declared as flat lists and the DMDoc should describe the keys and values types, aka
describe the list structure, eg:
```dm
/obj/item/something
	/**
	 * A list of all the targets that have been hit by this item, and how much damage they took from us
	 *
	 * Key is an `atom/movable`, value is a `number`
	 */
	var/list/hit_targets_damage_done = list()
```

A special case is lists that might contain multiple types, this is heavily discouraged and almost always avoidable, but in cases where it's not, the list must be
declared as a flat list, and the types it can contain specified in the DMDoc that documents the variable, eg:
```dm
/obj/item/something
	/**
	 * A list of all the targets that have been hit by this item
	 *
	 * This list can contain a `/mob`, an `/obj`, a `/turf` or an `/icon`
	 */
	var/list/hit_targets = list()
```

Note that, if the above list did not contain an icon, it should have been declared with their closest common parent type
and the content it expects (or does NOT expect) listed in the DMDoc instead, whichever is more convenient, eg:
```dm
// Ok
/obj/item/something
	/**
	 * A list of all the targets that have been hit by this item
	 *
	 * This list can contain `/mob`, `/obj` or `/turf` instances
	 */
	var/list/atom/movable/hit_targets = list(/icon)

// Even better
/obj/item/something
	/**
	 * A list of all the targets that have been hit by this item
	 *
	 * This list can contain any `/atom/movable` instance except `/area`
	 */
	var/list/atom/hit_targets = list(/icon)
```

### Naming things when typecasting
When typecasting, keep your names descriptive:
```dm
var/mob/living/living_target = target
var/mob/living/carbon/carbon_target = living_target
```

Of course, if you have a variable name that better describes the situation when typecasting, feel free to use it.

Note that it's okay, semantically, to use the same variable name as the type, e.g.:
```dm
var/atom/atom
var/client/client
var/mob/mob
```

Your editor may highlight the variable names, but BYOND, and we, accept these as variable names:

```dm
// This functions properly!
var/client/client = CLIENT_FROM_VAR(usr)
// vvv this may be highlighted, but it's fine!
client << browse(...)
```

### Name things as directly as possible
`was_called` is better than `has_been_called`. `notify` is better than `do_notification`.

### Avoid negative variable names
`is_flying` is better than `is_not_flying`. `late` is better than `not_on_time`.
This prevents double-negatives (such as `if (!is_not_flying)` which can make complex checks more difficult to parse).

### Exceptions to variable names

Exceptions can be made in the case of **inheriting** (NOT copying, **inheriting**) existing procs, as it makes it so you can use named parameters, but *new* variable names must follow these standards. It is also welcome, and encouraged, to refactor existing procs to use clearer variable names.

### initial() versus ::
`::` is a compile time scope operator which we use as an alternative to `initial()`.
It's used within the definition of a datum as opposed to `Initialize` or other procs.

```dm
// Bad
/atom/thing/better
	name = "Thing"

/atom/thing/better/Initialize()
	var/atom/thing/parent = /atom/thing
	desc = inital(parent)

// Good
/atom/thing/better
	name = "Thing"
	desc = /atom/thing::desc
```

Another good use for it easy access of the parent's variables.
```dm
/obj/item/fork/dangerous
	damage = parent_type::damage * 2
```

```dm
/obj/item/fork
	flags_1 = parent_type::flags_1 | FLAG_COOLER
```


It's important to note that `::` does not apply to every application of `initial()`.
Primarily in cases where the type you're using for the initial value is not static.

For example,
```dm
/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return initial(b.init_order) - initial(a.init_order)
```
could not use `::` as the provided types are not static.

### Vars should not be accessed with the runtime operator `:` whenever possible
Unless absolutely unavoidable, use the compile-time operator `.` to access vars instead of the runtime operator `:`.

### Text variables
Do not leave empty lines just to isolate the text, the text should start right after the `"` and end right before the `"`.

Any newline should be preceded by the space in a phrase, and phrases should only be broken in a newline after complete words

```dm
// Good
/obj/item/mything
	var/text_var = "This is a test variable \
					that spans multiple lines"

// Bad, wasted lines
/obj/item/mything
	var/text_var = "\
					This is a test variable \
					that spans multiple lines\
					"

// Bad, breaks incorrectly
/obj/item/mything
	var/text_var = "This is a test varia\
					ble that spans multiple lines"
```

Regular expressions, especially complex ones, should use the unescapable raw string delimiter with single apostrophe (`@'my_regex'`) over escaping special characters.

## Procs

### Getters and setters

* Avoid getter procs. They are useful tools in languages with that properly enforce variable privacy and encapsulation, but DM is not one of them. The upfront cost in proc overhead is met with no benefits, and it may tempt to develop worse code.

This is bad:
```DM
/datum/datum1/proc/simple_getter()
	return gotten_variable
```
Prefer to either access the variable directly or use a macro/define.


* Make usage of variables or traits, set up through condition setters, for a more maintainable alternative to compex and redefined getters.

These are bad:
```DM
/datum/datum1/proc/complex_getter()
	return condition ? VALUE_A : VALUE_B

/datum/datum1/child_datum/complex_getter()
	return condition ? VALUE_C : VALUE_D
```

This is good:
```DM
/datum/datum1
	var/getter_turned_into_variable

/datum/datum1/proc/set_condition(new_value)
	if(condition == new_value)
		return
	condition = new_value
	on_condition_change()

/datum/datum1/proc/on_condition_change()
	getter_turned_into_variable = condition ? VALUE_A : VALUE_B

/datum/datum1/child_datum/on_condition_change()
	getter_turned_into_variable = condition ? VALUE_C : VALUE_D
```

### When passing vars through New() or Initialize()'s arguments, use src.var
Using src.var + naming the arguments the same as the var is the most readable and intuitive way to pass arguments into a new instance's vars.

This is bad:
```DM
/atom/thing
	var/is_red

/atom/thing/Initialize(mapload, _is_red)
	is_red = _is_red

/proc/make_red_thing()
	new /atom/thing(null, _is_red = TRUE)
```

This is good:
```DM
/atom/thing
	var/is_red

/atom/thing/Initialize(mapload, is_red)
	src.is_red = is_red

/proc/make_red_thing()
	new /atom/thing(null, is_red = TRUE)
```

Setting `is_red` in args is simple, and directly names the variable the argument sets.

### Prefer named arguments when the meaning is not obvious.

You should prefer to use named arguments where the meaning is not otherwise obvious, eg:
```dm
give_pizza(hot = TRUE, toppings = 2)
```

What is "obvious" is subjective--for instance, `give_pizza(PIZZA_HOT, toppings = 2)` is completely acceptable.

### Only meaningful returns
If a proc doesn't return anything meaningful, it should return with only `return`, not `return TRUE` or `return FALSE`.
Only exception to the above is if the `.` implicit return is used, in which case it should be set to something at the start of the proc.

### Appropriately mark the procs in the declaration with the applicable markers
The procs should be marked with the appropriate markers, eg:
```dm
/obj/item/mything/proc/add_mythings(obj/item/mything/other_thing)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	
	return (value + other_thing.value)
```

### Respect the proc signature when inheriting from it
You must respect the proc signature when inheriting from it, at most you can expand the argument list, eg:
```dm
/obj/item/mything/proc/add_mythings(obj/item/mything/other_thing)
	code

// This is all BAD because it's not respecting the signature
/obj/item/mything/mysubthing/add_mythings(obj/item/mything/thing) // This changes the variable name
/obj/item/mything/mysubthing/add_mythings(atom/movable/other_thing) // This changes the type of the argument

// This is acceptable, but not optimal
/obj/item/mything/mysubthing/add_mythings(obj/item/mything/other_thing, approximate_to_integer = TRUE) // Acceptable, it's expanding the argument list
```

### If inherited procs are not meant to call the parent, mark it
If a proc is not meant to call the parent proc, it should be marked with the `SHOULD_CALL_PARENT(FALSE)` marker, eg:
```dm
/obj/item/mything/proc/implement_this()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("This should not have happened")
```

### Call the parent at the start of the proc
If a proc is meant to call the parent, it should be called at the start of the proc where possible, and return the return value, eg:
```dm
/obj/item/mything/do_something()
	. = ..()
```

Notable exception (outside of procs that aren't meant to call their parent) is `Destroy()`, which should generally call the parent at the end of the proc.
There is no hard and fast rule on this, as many exceptions exist, but generally unless there is a reason to, this is what is expected.

### If something happens in either cases, do it before the conditional
If something has to be done in any case, do it before the conditional checks and don't repeat the code, eg:
```dm
// BAD
/obj/item/mything/do_something()
	if(something)
		var/mob/living/carbon/human/human = target // This is happening either way, so it's just repeated code
		code
	else
		var/mob/living/carbon/human/human = target // This is happening either way, so it's just repeated code
		some_other_code

// GOOD
/obj/item/mything/do_something()
	var/mob/living/carbon/human/human = target // This is happening either way, so it's just repeated code
	
	if(something)
		code
	else
		some_other_code
```

### Separate logical blocks with empty lines
It's generally a good idea to separate logical blocks with empty lines, eg:
```dm
// BAD, this put strain on the reader in trying to understand what is going on
/obj/item/mything/do_something()
	for(var/i in 1 to length(something))
		if(something[i] == TRUE)
			if(something[i + 1] == TRUE)
				code
			else
				some_other_code
			some_proc(something[i + 1])
		some_var = something[i]

// Better, the blocks are distinct to a quick parse, and the comments tell you what they do
// (note that as this is a made up proc, the comments or the logic are not really relevant)
/obj/item/mything/do_something()

	//Loop through the keys of the list (for whatever reason)
	for(var/i in 1 to length(something))

		//If the element is TRUE and the next element is also true,
		// do (whatever), otherwise (whatever else)
		if(something[i] == TRUE)
			if(something[i + 1] == TRUE)
				code
			else
				some_other_code

			//Call (whatever for whatever reason)
			some_proc(something[i + 1])

		// Assign the (whatever) to (whatever)
		some_var = something[i]
```

This is in large part arbirary, but you should try to keep the code readable and understandable to a quick glance at it when possible. It is ultimately up to devs discretion if the code is readable and understandable.

## Use typed procs where possible
DM uses classes (types) to group variables and procs, and you should do the same when possible.
```dm
// BAD
/proc/sum_mythings(obj/item/mything/thing1, obj/item/mything/thing2)
	return thing1.value + thing2.value

// GOOD
/obj/item/mything/proc/sum_with(obj/item/mything/thing_to_sum_with)
	return (value + thing_to_sum_with.value)
```

## Multi-lining

Whether it's a very long proc call, list, or something else entirely, you should split code across multiple lines when it makes it more readable. This is ultimately up to devs discretion.
When you do, follow this consistent style:

```dm
proc_call_on_one_line(
	arg1, // Only indent once! Remember to not align tabs.
	arg2,
	arg3, // End with a trailing comma
) // The parenthesis should be on the same indentation level as the proc call
```

For example:
```dm
/area/town
	var/list/places_to_visit = list(
		"Coffee Shop",
		"Dance Club",
		"Gift Shop",
	)
```

This is not a strict rule and there may be times where you can place the lines in a more sensible spot. For example:

```dm
act(list(
	// Fine!
))

act(
	list(
		// Fine, though verbose
	)
)

act(x, list(
	// Also fine!
))

act(x, list(

), y) // Getting clunky, might want to split this up!
```

Occasionally, you will need to use backslashes to multiline. This happens when you are calling a macro. This comes up often with `AddComponent`. For example,

```dm
AddComponent( \
	/datum/component/makes_sound, \
	"chirp", \
	volume = 10, \
)
```

Backslashes should **only** be used when necessary, and they are only necessary for macros.

### No useless variables in procs
With few exceptions (mainly for readability), do not declare variables in procs that do not have any use, eg.
```dm
// BAD, some_var is only used once in the proc and is useless
/obj/item/proc/do_something()
	var/some_var = (some_other_var || another_var)
	if(some_var)
		do_something_else()

// BAD, the iterator isn't used
/obj/item/proc/do_something()
	for(var/i in 1 to length(some_list))
		do_something_else()

// Acceptable to break the line from being too long and/or for understandability (the var name documents an intent that would otherwise not be clear/obvious)
// note that in performance critical code, this would be more scrutinized, and likely told to be refactored in a macro (#macros), while on less performance critical code,
// where it doesn't matter as much, it would be more acceptable
/obj/item/proc/do_something()
	var/explicative_named_var = (condition1 && (is_condition() || another_condition) || guess_what_this_is?.some_other_var && yet_another_var)
	if(explicative_named_var)
		do_something_else()

// OK, some_var is used more than once in the proc
/obj/item/proc/do_something()
	var/some_var = (some_other_var || another_var)
	if(some_var)
		do_something_else()
	
	more_code

	if(another_var && some_var)
		do_something_else_again()
```

Exception to this would be `_` in an interative loop, which by convention indicates a variable that is not important / to be ignored, eg:
```dm
// OK, by convention the underscore means to ignore the iterator
/obj/item/proc/do_something()
	for(var/_ in 1 to length(some_list))
		do_something_else()
```

### Passthrough arguments to a proc
If you need to passthrough the same arguments from one proc to the other, use `arglist(args)`.
```dm
// Bad
/obj/item/container/do_something(arg1, arg2, arg3)
	contained_item.do_something(arg1, arg2, arg3)

// Good
/obj/item/container/do_something(arg1, arg2, arg3)
	contained_item.do_something(arglist(args))
```

### Single calls to procs with nullcheck
If you need to call a proc on a variable with a nullcheck, and no further check is needed, use the conditional access operator `?.`
```dm
// Bad
/obj/item/container/do_something()
	code
	if(contained_item)
		contained_item.do_something()
	more_code

// Good
/obj/item/container/do_something()
	code
	contained_item?.do_something()
	more_code

// Bad, you are doing more than a single check now
/obj/item/container/do_something()
	code
	contained_item?.do_something()
	contained_item?.do_something_else()
	if(contained_item?.some_var)
		more_code
	even_more_code
```

Notable exception to this, is in guard statements for procs where it wouldn't make sense to do anything if said var is null, eg:
```dm
// OK! The proc wouldn't make sense to do anything if the head is missing,
// so the guard statement is good here even if it would have been only a
// single use instance
/mob/living/carbon/human/proc/behead()
	if(!head)
		return
	head.drop_limb()
```

## Macros

Macros are, in essence, direct copy and pastes into the code. They are one of the few zero cost abstractions we have in DM, and you will see them often. Macros have strange syntax requirements, so if you see lots of backslashes and semicolons and braces that you wouldn't normally see, that is why.

This section will assume you understand the following concepts:

### Language - Hygienic
We say a macro is [**hygienic**](https://en.wikipedia.org/wiki/Hygienic_macro) if, generally, it does not rely on input not given to it directly through the call site, and does not affect the call site outside of it in a way that could not be easily reused somewhere else.

An example of a non-hygienic macro is:

```dm
#define GET_HEALTH(health_percent) ((##health_percent) * max_health)
```

In here, we rely on the external `max_health` value.

Here are two examples of non-hygienic macros, because it affects its call site:

```dm
#define DECLARE_VAURCA(name) var/mob/living/vaurca/vaurca = new(##name)
#define RETURN_IF(condition) if (condition) { return; }
```

### Language - Side effects/Pure
We say something has [**side effects**](https://en.wikipedia.org/wiki/Side_effect_(computer_science)) if it mutates anything outside of itself. We say something is **pure** if it does not.

For example, this has no side effects, and is pure:
```dm
#define VAURCA_MAX_HEALTH 500
```

This, however, performs a side effect of updating the health:
```dm
#define VAURCA_SET_HEALTH(vaurca, new_health) ##vaurca.set_health(##new_health)
```

Now that you're caught up on the terms, let's get into the guidelines.

### Naming
With little exception, macros should be SCREAMING_SNAKE_CASE.

### Put macro segments inside parentheses where possible.
This will save you from bugs down the line with operator precedence.

For example, the following macro:

```dm
#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION T20C + 10
```

...will break when order of operations comes into play:

```dm
var/temperature = MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION * 50

// ...is preprocessed as...
var/temperature = T20C + 10 * 50 // Oh no! T20C + 500!
```

So, defensively wrap macro bodies with parentheses where possible.

```dm
// Phew!
#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION (T20C + 10)
```

The same goes for arguments passed to a macro...

```
// Guarantee 
#define CALCULATE_TEMPERATURE(base) (T20C + (##base))
```

### Be hygienic where reasonably possible

Consider the previously mentioned non-hygienic macro:

```dm
#define GET_HEALTH(health_percent) ((##health_percent) * max_health)
```

This relies on "max_health", but it is not obviously clear what the source is. This will also become worse if we *do* want to change where we get the source from. This would be preferential as:

```dm
#define GET_HEALTH(source, health_percent) ((##health_percent) * (##source).max_health)
```

When a macro can't be hygienic, such as in the case where a macro is preferred to do something like define a variable, it should still do its best to rely only on input given to it:

```dm
#define DECLARE_VAURCA(name) var/mob/living/vaurca/vaurca = new(##name)
```

...would ideally be written as...

```dm
#define DECLARE_VAURCA(var_name, name) var/mob/living/vaurca/##var_name = new(##name)
```

As usual, exceptions exist--for instance, accessing a global like a subsystem within a macro is generally acceptable. It is up to dev discretion where this is acceptable.

### Preserve hygiene using double underscores (`__`) and `do...while (FALSE)`

Some macros will want to create variables for themselves, and not the consumer. For instance, consider this macro:

```dm
#define HOW_LONG(proc_to_call) \
	var/current_time = world.time; \
	##proc_to_call(); \
	world.log << "That took [world.time - current_time] deciseconds to complete.";
```

There are two problems here.

One is that it is unhygienic. The `current_time` variable is leaking into the call site.

The second is that this will create weird errors if `current_time` is a variable that already exists, for instance:

```dm
var/current_time = world.time

HOW_LONG(make_soup) // This will error!
```

If this seems unlikely to you, then also consider that this:

```dm
HOW_LONG(make_soup)
HOW_LONG(eat_soup)
```

...will also error, since they are both declaring the same variable!

There is a way to solve both of these, and it is through both the `do...while (FALSE)` pattern and by using `__` for variable names.

This code would change to look like:

```dm
#define HOW_LONG(proc_to_call) \
	do { \
		var/__current_time = world.time; \
		##proc_to_call(); \
		world.log << "That took [world.time - current_time] deciseconds to complete."; \
	} while (FALSE)
```

The point of the `do...while (FALSE)` here is to **create another scope**. It is impossible for `__current_time` to be used outside of the define itself.

### Keep anything you use more than once in variables

Remember that macros are just pastes. This means that, if you're not thinking, you can end up creating some really weird macros by reusing variables, as they could be passed in as procs that would be called multiple times (one for each time you use it). To avoid so, we store in variables anything used more than once:
```dm
#define TEST_ASSERT_EQUAL(a, b) \
	do { \
		var/__a_value = ##a;
		var/__b_value = ##b;

		if (__a_value != __b_value) { \
			return Fail("Expected [__a_value] to be equal to [__b_value]."); \
		} \
	} while (FALSE)
```

### ...but if you must be unhygienic, try to restrict the scope.

If your macro is only used by one proc, and it would look extremely noisy otherwise, you can define unhygienic macros in that proc, ideally after whatever variables it uses, to increase readability.

```dm
/proc/some_complex_proc()
	var/counter = 0

	#define MY_NECESSARY_MACRO counter += 5; do_something(counter);

	// My complex code that uses MY_NECESSARY_MACRO here...

	#undef MY_NECESSARY_MACRO
```

### Don't perform work in an unsuspecting macro

Pretty self explanatory, the macro name should **clearly** represent what it does, and should **only** do that which is expected from the name.

### `#undef` any macros you create, unless they are needed elsewhere

We do not want macros to leak outside their file, this will create odd dependencies that are based on the filenames. Thus, you should `#undef` any macro you make.

```dm
// Start of corn.dm
#define CORN_KERNELS 5

// All my brilliant corn code

#undef CORN_KERNELS
```

It is sometimes preferable for your `#define` and `#undef` to surround the code that actually uses them, especially in unhygienic macros.

If you want more than one files to use macros, put them in somewhere as a file in `__DEFINES`. That way, the files are included in a consistent order:

```dm
#include "__DEFINES/my_defines.dm" // Will always be included first, because of the underscores
#include "game/my_object.dm" // This will be able to consistently use defines put in my_defines.dm
```

Macros should be separated in files that reflect what they refer to, eg. a macro that is used for subsystems should be in a file like `code\__DEFINES\subsystems.dm` or similar.

### Use `##` to help with ambiguities

Especially with complex macros, it might not be immediately obvious what's part of the macro and what isn't.

`##` will paste in the define parameter directly, and makes it more clear what belongs to the macro, eg:
```dm
#define CALL_PROC_COMPLEX(source, proc_name) \
	if (##source.is_ready()) { \
		##source.##proc_name(); \
	}
```

This is the most subjective of all the guidelines here, as it might just create visual noise in very simple macros, so use your best judgment.

### For impure/unhygienic defines, use procs/normal code when reasonable

If you don't have a strong reason to use a macro, consider just writing the code out normally or using a proc.

```dm
#define SWORD_HIT(sword, victim) { /* Ugly backslashes! */ \
	##sword.attack(##victim); /* Ugly semicolons! */ \
	##victim.say("Ouch!"); /* Even ugly comments! */ \
}
```

This is a fairly egregious macro, and would be better off just written like:
```dm
/obj/item/sword/proc/hit(mob/victim)
	attack(victim)
	victim.say("Ouch!")
```

Generally, macros should only be used in performance-critical scenarios, where they would enhance readability, or where there's no other way to do it.

## Documentation
We use DMDoc to document the codebase, this allows us to read the documentation of variables, procs, macros and classes (most of the times) from the IDE (Visual Studio Code) without having to dig around, among other things.

### What to document
All variables, procs and classes that do not have a clear name / signature must be documented using DMDoc.

### How to document
Single-line documentation is done with a `///` comment immediately above what it is documenting.

Multi-line documentation is done with a `/**` comment immediately above what it is documenting, and a `*/` at the end of the comment, with an asterisk space-aligned, eg:
```
/**
 * Description
 *
 * More description
 */
 ```

In multi-line documentation, you can use `*` to make a bullet point, enclose something in `**` to make it bold, enclose something in `__` to make it italic, and prepend something at the start of the block with `#` to make it a header. 

A block surrounded by \`\`\` (in multiline) or \` (in single line) will be rendered as code.

One empty line separates the various lines in the final rendering unless they are bullet points.

eg:
```
/**
 * ## Header name / title
 *
 * This section of the comment
 * will be all rendered on
 * the same line
 *
 * This will be rendered on a new line thanks to the empty line above us, and the bullet point below
 * * Bullet point **with some bold text** `and.some.single.line.code()`
 * * Bullet point __with some italic text__
 *
 * ```
 * this.wouldbe.rendered.as.code()
 * ```
 */
```

### Documenting a proc
When documenting a proc, we give at least a short description and a description of the parameters, eg:
```
/**
 * Short description of the proc
 *
 * * arg1 - Relevance of this argument
 * * arg2 - Relevance of this argument
 *
 * Returns `TRUE`
 */
```

You can expand on the description of the proc by adding a longer description as seen fit / useful.

The DMDoc must make relatively clear what the proc does / why you would use it, what params do / are used for / it expects,
and if it returns anything, what it returns (and the meaning of that return).

### Documenting a variable/define
Document a variable by giving a short description of what it is, what it is used for, what it does or represents.

If the variable is a list, the DMDoc must indicate what the expected content of the list is. If it's an associative list, the DMDoc must indicate what the expected keys/values types are, aka the structure of the list. If it's a lazylist, the DMDoc must indicate so.

Untyped variables (eg. `var/some_variable`) must be documented extensively, indicating what they can contain under what conditions.

### Use comments where possible and sensible
Comments are a great way to describe what you are doing in a proc, and should be used in procs to give a general idea of what you are doing (and why).
This allows the reader to understand what a section of the proc is doing without having to painstakingly read the whole code contained in it, thus lightening the mental load.

All comments inside a proc should **not** be DMDoc comments, but plain ones. You should use DMDoc comments **only** to document classes, procs, and class variables.

Do not use comments to mark obvious things, like the start or end of a file, unless they document the content of the file.

You can and should use comments to separate logical blocks of classes, eg:
```dm
/obj/item/mything

/*#######################
	MyOtherThings
#######################*/

/obj/item/mything/myotherthing
/obj/item/mything/myotherthing2
/obj/item/mything/myotherthing3
/obj/item/mything/myotherthing4

/*#######################
	MyOtherOtherThings
#######################*/

/obj/item/mything/myotherotherthing
/obj/item/mything/myotherotherthing2
/obj/item/mything/myotherotherthing3
/obj/item/mything/myotherotherthing4
```
