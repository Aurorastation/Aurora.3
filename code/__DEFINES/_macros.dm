#define CLAMP01(x) (clamp(x, 0, 1))
#define JOINTEXT(X) jointext(X, null)
#define list_find(L, needle, LIMITS...) L.Find(needle, LIMITS)

/// Adds a generic or coloured box around a chat message.
#define EXAMINE_BLOCK(str) ("<div class='examine_block'>" + str + "</div>")
#define EXAMINE_BLOCK_GREY(str) ("<div class='examine_block--grey'>" + str + "</div>")
#define EXAMINE_BLOCK_BLUE(str) ("<div class='examine_block--blue'>" + str + "</div>")
#define EXAMINE_BLOCK_RED(str) ("<div class='examine_block--red'>" + str + "</div>")
#define EXAMINE_BLOCK_DEEP_CYAN(str) ("<div class='examine_block--deep-cyan'>" + str + "</div>")
#define EXAMINE_BLOCK_ODYSSEY(str) ("<div class='examine_block--odyssey'>" + str + "</div>")

#define MATRIX_DANGER(str) (FONT_LARGE(SPAN_DANGER(str)))
#define MATRIX_NOTICE(str) (FONT_LARGE(SPAN_NOTICE(str)))

#define UNDERSCORE_OR_NULL(target) "[target ? "[target]_" : ""]"

#define sequential_id(key) GLOB.uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

/// General I/O helpers
#define to_target(target, payload)                          target << (payload)
#define from_target(target, receiver)                       target >> (receiver)
#define to_file(file_entry, file_content)                   file_entry << file_content

#define place_meta_charset(content) (istext(content) ? "<meta charset=\"utf-8\">" + (content) : (content))

#define legacy_chat(target, message)                        to_target(target, message)
#define to_world(message)                                   to_chat(world, message)
#define sound_to(target, sound)                             to_target(target, sound)
#define to_save(handle, value)                              to_target(handle, value) //semantics postport: what did they mean by this
#define show_browser(target, browser_content, browser_name) to_target(target, browse(place_meta_charset(browser_content), browser_name))
#define send_rsc(target, content, title)                    to_target(target, browse_rsc(content, title))
#define send_output(target, msg, control)                   to_target(target, output(msg, control))
#define send_link(target, url)                              to_target(target, link(url))

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)
#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define isopenturf(target) istype(target, /turf/simulated/open)
#define isweakref(target) istype(target, /datum/weakref)
#define isopenspace(A) istype(A, /turf/simulated/open)
#define isatom(D) istype(D, /atom)
#define isdatum(target) istype(target, /datum)
#define isitem(D) istype(D, /obj/item)
#define islist(D) istype(D, /list)

/// Semantic define for a 0 int intended for use as a bitfield
#define EMPTY_BITFIELD 0

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

/// Right-shift of INT by BITS
#define SHIFTR(INT, BITS) ((INT) >> (BITS))

/// Left-shift of INT by BITS
#define SHIFTL(INT, BITS) ((INT) << (BITS))

/// Convenience define for nth-bit flags, 0-indexed
#define FLAG(BIT) SHIFTL(1, BIT)

/// Increase the size of L by 1 at the end. Is the old last entry index.
#define LIST_INC(L) ((L).len++)

/// Increase the size of L by 1 at the end. Is the new last entry index.
#define LIST_PRE_INC(L) (++(L).len)

/// Decrease the size of L by 1 from the end. Is the old last entry index.
#define LIST_DEC(L) ((L).len--)

/// Explicitly set the length of L to NEWLEN, adding nulls or dropping entries. Is the same value as NEWLEN.
#define LIST_RESIZE(L, NEWLEN) ((L).len = (NEWLEN))

/// Drops x into the the src's location, and then nulls its reference.
#define DROP_NULL(x) if(x) { x.dropInto(loc); x = null}

/// Radial input menu
#define RADIAL_INPUT(user, choices) show_radial_menu(user, user, choices, tooltips = TRUE)
