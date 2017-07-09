# Licensing
Aurora Station is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

# Coding Standards

### Absolute Pathing
Absolute pathing has to be used for type, proc, and verb definitions. This is to make searching and reading easier.

An example of properly pathed code:
```DM
/obj/item/device/cake
	[cake code here]

/obj/item/device/cake/proc/eat_cake()
	[proc code here]
```

An example of badly pathed code:
```DM
/obj/item/device/cake
	[cake code here]

	proc/eat_cake()
		[proc code here]
```

### Initialize() over New()
Since the implementation of the Stoned Master Controller, overrides of the `New()` proc have effectively become depracted in favour of `Initialize()` and `LateInitialize()`. In most cases, `Initialize()` is a drop-in replacement for `New()`, however, there are a few considerations to be taken into account when using this. Specifically, `Initialize()` must always return the parent proc's value. Either via the `. = ..()` semantics or with explicit `return ..()` statements.

`LateInitialize()` is invoked as an asynchronous process whenever overridden.

Refer to the [wiki](./wiki/Atom-Initialization) article for further information.

### qdel() and Destroy() usage
All objects with an applicable type need to be deleted by `qdel()`, as opposed to the regular `del()` proc. While conducting this action, make sure you remove all possible references to the object you assign for deletion *after* calling `qdel()`. This will enable the garbage collector to handle the objects assigned to it at its own pace, thus reducing lag in the long run.

An example of how to use `qdel()`:
```DM
/obj/item/plate
	var/obj/item/cake/cake

/obj/item/plate/New()
	cake = New()

// Eat the cake and destroy the cake object.
/obj/item/plate/proc/eat_cake()
	qdel(cake)	// Call qdel()
	cake = null	// Set local reference to null to assist the GC.
```

The `Destroy()` proc for objects should be defined, if there are any special operations that need to be conducted when an object is assigned for destruction with `qdel()`. Normally, it would set all object references that that specific item may contain to null, and destroy them as necessary. It is important to know that the best case scenario for the garbage collector is this: an object passed to it should not reference, or be referenced by any other ingame object.

Note that any modified `Destroy()` proc **must always return the original definition (`return ..()`) call!**

An example of how to define `Destroy()` for an item that needs it:
```dm
/obj/item/plate
	var/obj/item/cake/cake

/obj/item/plate/Initialize()
	cake = New()

/obj/item/plate/Destroy()
	if (src.cake)	// We potentially have a reference.
		qdel(cake)	// Delete the referenced item -- this doesn't always have to be done.
		cake = null	// Set the pointer to null. This is the important bit.
					// All pointers that the plate item contains are now null. This will speed up the GC.

	return ..()		// Return the original definition of the proc.
```

`qdel()` is **not** capable of handling the following types of objects:
* file
* savefile
* SQLLite object
* list objects.
* turfs
* areas

You will have to use the regular `del()` proc to delete any object of that type (except for `/turf`, which should use `ChangeTurf()`).

More details on qdel, Garbage, and `Destroy()` are available [[here|Garbage, qdel, and Destroy]].

### HTML styling for user output
All text output to the user, specially if the output operator `<<` is used, should be formatted in proper HTML. DM text macros for styling, such as `\red` and `\blue`, are no longer to be used actively. This will enable the modification of used HTML styling later down the line, via the centralized .css files. It will also enable a switch from an output panel, to other output methods.

For reference, here are the standard span classes for user output, and the correlation between them and the DM text macros:
* `<span class='danger'></span>` corresponds to `\red` and is bold.
* `<span class='warning'></span>` also corresponds to `\red` and is not bold.
* `<span class='notice'></span>` corresponds to `\blue` and is not bold.

There exist pre-processor macros for using these spans. `span(class, text)` which is the equivilant of typing a string that looks like this: `"<span class='[class]'>[text]</span>"`.

The stylesheet available for use within DM can be found in `code/stylesheet.dm`.

### Usage of forceMove
In order to make `Exited()` and `Entered()` procs more reliable, the usage of `forceMove()` when forcibly moving one item to another location, be it another item or turf, is required. Directly changing an item's loc values will skip over calls to the aforementioned procs, thus making them less useful and more unreliable.

An example of improper item moving:
```dm
/proc/some_proc(var/obj/A, var/obj/B)
	A.loc = B	// Simply move A inside B.
```

An example of proper item moving:
```dm
/proc/some_proc(var/obj/A, var/obj/B)
	A.forceMove(B)	// This will call A.loc.Exited() and B.Entered().
					// The first method does not call either of those.
```

### Regarding the variable usr
If at all possible, procs outside of verbs and `Topic()` should avoid reliance on `usr`, and instead use a custom argument to specify the user and its expected type. This makes it easier to reuse procs in chains where `usr` is not always defined, and combats against potential security flaws that relying on `usr` can bring.

`usr` must also always be validated to be the expected type!

### Reserved argument names
All BYOND procs have a set list of variables which are implicitly defined in each proc. However, the DM compiler will allow you to reuse these names as names for your custom variables. This should be avoided at all costs, to improve the readability and understanding of code.

A list of reserved argument names instantiated with all procs:
* `vars` being an alias of `src.vars` is `src` exists.
* `args`
* `usr`
* `src`

### Avoid `in world` loops
Due to the amount of instances in the world, utilizing an `in world` loop should be avoided in all instances. In large projects, specially when crawling for types that are not optimized internally by BYOND (only core built-in types are), crawling `in world` will surmount to a very large blocking loop and will almost certainly trigger the infinite loop warning. This forces the specific callstack to sleep at least once.

### Database prefixing
All tables for the database should be prefixed according to the following list:
* `ss13_` for tables in which ingame data is held.
* `discord_` for tables in which BOREALIS data is held.
