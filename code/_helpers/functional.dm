#define PREPARE_INPUT \
predicates = istype(predicates) ? predicates : list(predicates);\
input = istype(input) ? input : list(input);

#define PREPARE_ARGUMENTS \
var/extra_arguments = predicates[predicate];\
var/list/predicate_input = input;\
if(LAZYLEN(extra_arguments)) {\
	predicate_input = predicate_input.Copy();\
	predicate_input += list(extra_arguments);\
}

/proc/all_predicates_true(var/list/input, var/list/predicates)
	PREPARE_INPUT
	for(var/predicate in predicates)
		PREPARE_ARGUMENTS
		if(!call(predicate)(arglist(predicate_input)))
			return FALSE
	return TRUE

/proc/any_predicate_true(var/list/input, var/list/predicates)
	PREPARE_INPUT
	if(!predicates.len)
		return TRUE

	for(var/predicate in predicates)
		PREPARE_ARGUMENTS
		if(call(predicate)(arglist(predicate_input)))
			return TRUE
	return FALSE

#undef PREPARE_ARGUMENTS
#undef PREPARE_INPUT
