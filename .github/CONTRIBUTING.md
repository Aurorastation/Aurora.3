# Licensing
Aurora Station code is licensed under the [GNU Affero General Public License version 3](https://www.gnu.org/licenses/agpl-3.0.en.html), which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA](https://creativecommons.org/licenses/by-sa/3.0/) license unless otherwise indicated.

# Github Standards

### Sub-licensing External Content
**When does this section apply to me?** When you are integrating content that is **not** licensed under [AGPLv3](https://www.gnu.org/licenses/agpl-3.0.en.html) (code)
or [Creative Commons 3.0 BY-SA](https://creativecommons.org/licenses/by-sa/3.0/) (icons and sounds). The most common application here is for icons and sounds gathered
from an external source or repository.

As a contributor, you must do your utmost to pay respect to international copyright law. This means that, if copying code or content from an external source, you **must**
be aware of what license it is published under. And you must ensure that the conditions of said license are followed when integrating the content into the codebase. (Sometimes
this is not possible, and the content cannot be used.)

**If you cannot locate or reasonably dicern authorship or the license associated with given content, we ask that you not submit it into a pull request.**

As a courtesy, attribution of authorship is also encouraged, even if the license of the content does not require this outright. Generally this is done in the PR by declaring
the source of the material, the author(s) (if known), and adding similar attributions to the relevant changelog entry (if applicable). This may be both done in the `author` field
or within the plain text describing the change itself.

When reading the sub-sections that follow, note that these will be **generalizations**, and the specifics will be dictated by the license itself.

#### Code
Code from most other open source SS13 code bases is GPLv3 or AGPLv3. This means that it's free to be copied without any additional effort. Though any notes of authorship within
the code files, if presents, must be kept intact. Be wary of **Goon**: their code is licensed under CC-BY-SA-NC and is **not** directly compatible with our codebase's license.
Porting Goon code directly is highly discouraged as a result.

If the code is external, or licensed under something else (example being the TGS library), then ensure that the copyright notices within the file(s) (if present) are kept intact,
and that a separate license file (if present in/packaged with the original source) is added to the repository. This generally means that you have to put all of the code you are
porting in this manner into a `modules/` sub folder, and stick the license file in there.

#### Other Assets (Sound, Icons)
If the material is distributed under CC-BY-SA 3.0, then it can go straight into the relevant folders, as long as you attribute the author(s) in the PR and changelog if they can be
identified.

In any other case, create a subfolder somewhere in the relevant structure, stick the items in there, and provide a copy of the license with the content. Also, ensure that the
license permits the intended use of the content in the appropriate manner.

### Peer Review
All pull requests are subject to peer review prior to being merged. After said reviews, they are given a final once-over by a maintainer and
then merged if good.

A **feature** pull request will require *two* reviews, with one of them being a community developer's. There is also a minimum time out of
*three days* before a feature pull request can be merged. This is to ensure that there is enough time to review and discuss new additions
from the game.

A **bug fix** pull request will require *two* reviews, if it is to be merged in the first 24 hours, or *one* following the first 24 hours.

### Prefer Atomic Pull-Requests
Pull requests should do **one** thing.

This means that a series of small, dependant pull requests is preferred over one large, monolithic one.
Developers and maintainers may request that you break up a pull request into multiple smaller pull requests
to enforce this standard at their discretion.

Small pull requests allow for easier reverting, easier (and faster!) reviewing and deliberation, and enable
developers in the future to more easily locate all changes relevant to a potential issue.

### Changelogs
Changelogs are automatically parsed from within the `html/changelogs` folder. A readme file exists there with specific information on how to
create and manage changelogs. All pull requests which contain player-visible changes are required to have a changelog. Any others, like pull
requests containing background system tweaks, minor optimizations, admin systems, etcetera, do not necessarily require a changelog.

Changelogs should be written in a concise and clear manner. There is no need for long winded explanations or too much detail (such as
specific numbers, values, etcetera) in a changelog. If necessary, the PR can be tagged as **wiki update** for a wiki article to be written
about it.

There also exist **IC changelogs**. These are presented in-game as a news article by NanoTrasen, and can be used to provide temporary fluff
for in-game changes. To make use of these, simply put a IC changelog header into the description of the PR and write up the contents below
it. An example:

> # IC Changelog
> A new weapon was commissioned by NanoTrasen. It is currently being tested aboard the NSS Aurora

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

There exist pre-processor macros for using these spans. `span(class, text)` which is the equivalent of typing a string that looks like this: `"<span class='[class]'>[text]</span>"` and macros such as `SPAN_WARNING(text)`, `SPAN_NOTICE(text)`, `SPAN_DANGER(text)`.

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

# HTML UI Standards

### UI conversion policy
Due to our current situation with 5 different HTML UI systems we are now enforcing a policy that all new UIs should be made using the VueUi UI system. This policy also applies to editing existing UIs, with the following exceptions:

 1. Modification is security / severe bug fix.
 0. It is typo fix.
 0. Touched UI file is too large.
 0. VueUi can't accommodate that type of UI.

### Responsiveness
All new UIs must be responsive, that means that when parameters change in game world, UI data must update as quickly as possible to reflect that change. If change is time dependant, then client side time approximation should be used.

### Conditional usage policy
If you need to use conditional rendering inside UI, then try to put conditional statements on elements you want to hide, then try using `<template>` to apply condition to multiple components.

For conditional rendering try to prefer to use `v-show` attribute when change is expected to be often occurring. Use `v-if` when you need `v-else` and switch is expected expected not often.

### Reusability
If there is segment of UI that is used multiple times with different content, then we strongly encourage making of new component. If that component is general or may be reused globally, then it should be made in to global component (placed in `vui` folder), else it should be made in to UI specific component that must be placed in folder inside `view` folder.
