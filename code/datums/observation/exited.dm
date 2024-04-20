//	Observer Pattern Implementation: Exited
//		Registration type: /atom
//
//		Raised when: An /atom/movable instance has exited an atom.
//
//		Arguments that the called proc should expect:
//			/atom/entered: The atom that was exited from
//			/atom/movable/exitee: The instance that exited the atom
//			/atom/new_loc: The atom the exitee is now residing in
//

GLOBAL_DATUM_INIT(exited_event, /singleton/observ/exited, new)

/singleton/observ/exited
	name = "Exited"
	expected_type = /atom
