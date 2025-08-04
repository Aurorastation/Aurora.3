/**
 * Abstract-ness is a meta-property of a class that is used to indicate
 * that the class is intended to be used as a base class for others, and
 * should not (or cannot) be instantiated.
 *
 * We have no such language concept in DM, and so we provide a datum member
 * that can be used to hint at abstractness for circumstances where we would
 * like that to be the case, such as base behavior providers.
 *
 * Use this macro, and only this macro, to define an abstract type.
 */
#define ABSTRACT_TYPE(typepath)\
##typepath {\
	abstract_type = ##typepath; \
}; ##typepath

/**
 * Returns whether the given datum/path is an abstract type
 *
 * * thing - A `datum` or `typepath` to check
 */
#define is_abstract(thing) (ispath(##thing) ? (##thing == initial(##thing:abstract_type)) : (##thing:type == (##thing:abstract_type)))
// ^- The dynamic access operator is needed because we accept paths and we can't fake cast them to a hygenic typed var since we have to give a return value
// it sucks, but it's DM, so things are bound to suck sometimes. Thanks byond. It shouldn't however give any issue, because the abstract_type var is defined
// at the datum level, so essentially for everything, and this being a macro saves proc call overhead -- essentially, i think the tradeoff is worth it
