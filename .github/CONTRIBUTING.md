# Licensing
Aurora Station code is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA](https://creativecommons.org/licenses/by-sa/3.0/) license unless otherwise indicated.

# Github Standards

### Prefer Atomic Pull-Requests
Pull requests should do **one** thing.

This means that a series of small, dependant pull requests is preferred over one large, monolithic one.
Developers and maintainers may request that you break up a pull request into multiple smaller pull requests
to enforce this standard at their discretion.

Small pull requests allow for easier reverting, easier (and faster!) reviewing and deliberation, and enable
developers in the future to more easily locate all changes relevant to a potential issue.

### Master & Development Branch Model
This community operates with two active branches: **master** and **development**.
The former represents what is being currently hosted on the main server, and the
latter is used as a staging area for new features and updates. Whenever the master
branch is updated directly, the changes in question will be pulled to the development
branch as soon as possible. So it can be expected that the development branch contains
every commit that's in the master branch, but not vice-versa.

All branches containing features, refactors, minor adjustments, etcetera, should be
based off of the **development** branch. Consequently, all such PRs should be targetted
and merged into the development branch. Where they will then be pulled into master
with the next feature update.

PRs targeting **master** should only contain bugfixes, security vulnerability patches,
and important adjustments to recently implemented features. Due to the fact that the
development branch can contain commits which are not in the master branch yet, it is
important that all branches targeting master be based off of the master branch.

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
Since the implementation of the Stoned Master Controller, overrides of the `New()` proc have effectively become depracted in favour of `Initialize()` and `LateInitialize()`. In most cases, `Initialize()` is a drop-in replacement for `New()`, however, there are a few considerations to be taken into account when using this. Specifically, `Initialize()` must always return a initialization hint and must always call the superior definition via `..()`. Usually these two are done together, either via the `. = ..()` semantics or with explicit `return ..()` statements.

`LateInitialize()` can be used to manage race conditions during map loading. In the middle of the game, when `mapload = FALSE` in `Initialize()`, `LateInitialize()` is called immediately after the specific atom's `Initialize()` call. However, if `mapload = TRUE`, which it does during map atom initialization, the `LateInitialization()` of an atom is called once all atoms have finished their `Initialization()` calls. Note that `Initialize()` needs to return `INITIALIZE_HINT_LATELOAD` in order for `LateInitialization()` to be called in either case.

Refer to the [wiki](https://github.com/Aurorastation/Aurora.3/wiki/Atom-Initialization) article for further information.

### qdel() and Destroy() usage
All objects with an applicable type need to be deleted by `qdel()`, as opposed to the regular `del()` proc. While conducting this action, make sure you remove all possible references to the object you assign for deletion *after* calling `qdel()`. This will enable the garbage collector to handle the objects assigned to it at its own pace, thus reducing lag in the long run.

An example of how to use `qdel()`:
```DM
/obj/item/plate
	var/obj/item/cake/cake

/obj/item/plate/Initialize()
	. = ..()
	cake = new()

// Eat the cake and destroy the cake object.
/obj/item/plate/proc/eat_cake()
	qdel(cake)	// Call qdel()
	cake = null	// Set local reference to null to assist the GC.
```

The `Destroy()` proc for objects should be defined, if there are any special operations that need to be conducted when an object is assigned for destruction with `qdel()`. Normally, it would set all object references that that specific item may contain to null, and destroy them as necessary. It is important to know that the best case scenario for the garbage collector is this: an object passed to it should not reference, or be referenced by any other ingame object.

Note that any modified `Destroy()` proc must always **call its superior definition `..()`** and **must return a deletion hint.** Usually the hint passed down from the superior definition is returned, via `. = ..()` or an explicit `return ..()` statement.

An example of how to define `Destroy()` for an item that needs it:
```DM
/obj/item/plate
	var/obj/item/cake/cake

/obj/item/plate/Initialize()
	. = ..()
	cake = new()

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
* areas (Note that these shouldn't be deleted at all)

You will have to use the regular `del()` proc to delete any object of that type (except for `/turf`, which should use `ChangeTurf()`).

More details on qdel, Garbage, and `Destroy()` are available [on the wiki](https://github.com/Aurorastation/Aurora.3/wiki/Garbage%2C-qdel%2C-and-Destroy).

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
```DM
/proc/some_proc(var/obj/A, var/obj/B)
	A.loc = B	// Simply move A inside B.
```

An example of proper item moving:
```DM
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
* `vars` being an alias of `src.vars` if `src` exists.
* `args`
* `usr`
* `src`

### Avoid `in world` loops
Due to the amount of instances in the world, utilizing an `in world` loop should be avoided in all instances. In large projects, specially when crawling for types that are not optimized internally by BYOND (only core built-in types are), crawling `in world` will surmount to a very large blocking loop and will almost certainly trigger the infinite loop warning. This forces the specific callstack to sleep at least once.

Note that a for-each loop without an explicit container specified will default to an `in world` loop. This is to say, the following two examples are equivalent:

```DM
for (var/client/C)
	qdel(C)

for (var/client/C in world)
	qdel(C)
```

### Database prefixing
All tables for the database should be prefixed according to the following list:
* `ss13_` for tables in which ingame data is held.
* `discord_` for tables in which BOREALIS data is held.
