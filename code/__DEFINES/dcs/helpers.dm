/// Used to trigger signals and call procs registered for that signal
/// The datum hosting the signal is automaticaly added as the first argument
/// Returns a bitfield gathered from all registered procs
/// Arguments given here are packaged in a list and given to _SendSignal
#define SEND_SIGNAL(target, sigtype, arguments...) ( !target._listen_lookup?[sigtype] ? NONE : target._SendSignal(sigtype, list(target, ##arguments)) )

/**
 * A variant on SEND_SIGNAL() which sends pointers to the original variables used for its arguments. AKA "By Reference" in other languages.
 * This means that rather than Registrars receiving a copy of a variable, they receive the actual original variable, which is open for modification.
 * Think of it like letting you bypass the "You can only return one thing" limit.
 * A By-Ref signal doesn't care about its own return, since any arbitrary amount of variables can be sent and retrieved through it.
 */
#define SEND_SIGNAL_BY_REF(target, sigtype, arguments...) ( !target._listen_lookup?[sigtype] ? NONE : target._SendSignal(sigtype, list(target, &##arguments)) )

#define SEND_GLOBAL_SIGNAL(sigtype, arguments...) ( SEND_SIGNAL(SSdcs, sigtype, ##arguments) )

/**
 * A variant on SEND_SIGNAL() which includes an early return if any Registrar sets the cancel_var to TRUE. This is equivalent to "Cancellable Event" in other languages.
 *
 * ==New arguments==
 * cancel_var: the name of the variable you wish to use for the early return. Typically you should just set this to cancelled
 * return_value: The actual return that this pattern will use if canceled.
 */
#define CANCELABLE_SEND_SIGNAL(target, sigtype, cancel_var, return_value, arguments...) \
	var/cancel_var = FALSE; \
	SEND_SIGNAL(target, sigtype, &cancel_var, ##arguments); \
	if(cancel_var) \
		return return_value

/// As per CANCELABLE_SEND_SIGNAL(), but the arguments are sent "By Reference" like in SEND_SIGNAL_BY_REF
#define CANCELABLE_SEND_SIGNAL_BY_REF(target, sigtype, cancel_var, return_value, arguments...) \
	var/cancel_var = FALSE; \
	SEND_SIGNAL_BY_REF(target, sigtype, cancel_var, ##arguments); \
	if(cancel_var) \
		return return_value

/// Signifies that this proc is used to handle signals.
/// Every proc you pass to RegisterSignal must have this.
#define SIGNAL_HANDLER SHOULD_NOT_SLEEP(TRUE)

/// A wrapper for _AddElement that allows us to pretend we're using normal named arguments
#define AddElement(arguments...) _AddElement(list(##arguments))
/// A wrapper for _RemoveElement that allows us to pretend we're using normal named arguments
#define RemoveElement(arguments...) _RemoveElement(list(##arguments))

/// A wrapper for _AddComponent that allows us to pretend we're using normal named arguments
#define AddComponent(arguments...) _AddComponent(list(##arguments))

/// A wrapper for _AddComonent that passes in a source.
/// Necessary if dupe_mode is set to COMPONENT_DUPE_SOURCES.
#define AddComponentFrom(source, arguments...) _AddComponent(list(##arguments), source)

/// A wrapper for _LoadComponent that allows us to pretend we're using normal named arguments
#define LoadComponent(arguments...) _LoadComponent(list(##arguments))

/**
 * Creates a new variable that will ALWAYS be equal to the given component attached to a target datum.
 * If such a component does not exist, one will be created.
 * It is thus impossible for the resulting variable to ever be null.
 */
#define EnsureComponent(target, component_type, component_var, arguments...) var component_type/component_var = target._LoadComponent(list(component_type, ##arguments))

/// Removes a specified component from a target if it exists on that target.
#define RemoveComponent(target, component_type) qdel(target.GetComponent(component_type))

/**
 * A variant of GetComponent() which includes its own inline early return if the component doesn't exist.
 * It creates a variable equal to the specified value in component_var.
 * This can be especially useful if you're writing a proc which needs to check multiple components in a row.
 */
#define TryComponentOrReturn(target, component_type, component_var, return_value) \
	var component_type/component_var = target.GetComponent(component_type); \
	if(!component_var)\
		return return_value

/**
 * A variant of GetComponent() which includes its own inline loop continue if the component doesn't exist.
 * It creates a variable equal to the specified value in component_var.
 * This can be especially useful if you're writing a loop which needs to check multiple components in a row.
 */
#define TryComponentOrContinue(target, component_type, component_var) \
	var component_type/component_var = target.GetComponent(component_type); \
	if(!component_var)\
		continue

/**
 * A variant of GetComponent() which includes its own inline loop break if the component doesn't exist.
 * It creates a variable equal to the specified value in component_var.
 * This can be especially useful if you're writing a loop which needs to check multiple components in a row.
 */
#define TryComponentOrBreak(target, component_type, component_var) \
	var component_type/component_var = target.GetComponent(component_type); \
	if(!component_var)\
		break
