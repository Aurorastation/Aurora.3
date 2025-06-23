#ifndef SPACEMAN_DMM

#pragma FileAlreadyIncluded error
#pragma MissingIncludedFile error
#pragma MisplacedDirective error
#pragma UndefineMissingDirective error
#pragma DefinedMissingParen error
#pragma ErrorDirective error
#pragma WarningDirective error
#pragma MiscapitalizedDirective error

//2000-2999
#pragma SoftReservedKeyword error
#pragma DuplicateVariable error
#pragma DuplicateProcDefinition error
#pragma PointlessParentCall error
#pragma PointlessBuiltinCall error
#pragma SuspiciousMatrixCall error
#pragma FallbackBuiltinArgument error
#pragma PointlessScopeOperator error
#pragma PointlessPositionalArgument error
#pragma ProcArgumentGlobal error
#pragma MalformedRange error
#pragma InvalidRange error
#pragma InvalidSetStatement error
#pragma InvalidOverride error
#pragma InvalidIndexOperation error
#pragma DanglingVarType error
#pragma MissingInterpolatedExpression error
#pragma AmbiguousResourcePath error

//3000-3999
#pragma EmptyBlock error
#pragma SuspiciousSwitchCase error
#pragma AssignmentInConditional error
#pragma AmbiguousInOrder error
#pragma ExtraToken error
//We rely on macros for things that require this operator, so for now it's kept disabled
#pragma RuntimeSearchOperator disabled

#endif
