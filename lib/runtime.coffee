llvm = require 'llvm'
types = require 'types'

takes_builtins = types.takes_builtins
does_not_throw = types.does_not_throw
does_not_access_memory = types.does_not_access_memory
only_reads_memory = types.only_reads_memory
returns_ejsval_bool = types.returns_ejsval_bool

runtime_interface =
        personality:           -> @abi.createExternalFunction @module, "__ejs_personality_v0",           types.int32, [types.int32, types.int32, types.int64, types.int8Pointer, types.int8Pointer]

        module_resolve:        -> @abi.createExternalFunction @module, "_ejs_module_resolve", types.void, [types.EjsModule.pointerTo()]
        module_get:            -> @abi.createExternalFunction @module, "_ejs_module_get", types.EjsValue, [types.EjsValue]
        module_get_slot_ref:   -> @abi.createExternalFunction @module, "_ejs_module_get_slot_ref", types.EjsValue.pointerTo(), [types.EjsModule.pointerTo(), types.int32]

        module_add_export_accessors: -> @abi.createExternalFunction @module, "_ejs_module_add_export_accessors", types.void, [types.EjsModule.pointerTo(), types.string, types.getEjsClosureFunc(@abi), types.getEjsClosureFunc(@abi)]
        invoke_closure:        -> takes_builtins @abi.createExternalFunction @module, "_ejs_invoke_closure", types.EjsValue, [types.EjsValue, types.EjsValue, types.int32, types.EjsValue.pointerTo()]
        make_closure_noenv:    -> @abi.createExternalFunction @module, "_ejs_function_new_without_env", types.EjsValue, [types.EjsValue, types.getEjsClosureFunc(@abi)]
        make_closure:          -> @abi.createExternalFunction @module, "_ejs_function_new", types.EjsValue, [types.EjsValue, types.EjsValue, types.getEjsClosureFunc(@abi)]
        make_anon_closure:     -> @abi.createExternalFunction @module, "_ejs_function_new_anon", types.EjsValue, [types.EjsValue, types.getEjsClosureFunc(@abi)]

        make_closure_env:      -> @abi.createExternalFunction @module, "_ejs_closureenv_new", types.EjsValue, [types.int32]
        get_env_slot_val:      -> @abi.createExternalFunction @module, "_ejs_closureenv_get_slot", types.EjsValue, [types.EjsValue, types.int32]
        get_env_slot_ref:      -> @abi.createExternalFunction @module, "_ejs_closureenv_get_slot_ref", types.EjsValue.pointerTo(), [types.EjsValue, types.int32]
        
        arguments_new:         -> does_not_throw @abi.createExternalFunction @module, "_ejs_arguments_new",             types.EjsValue, [types.int32, types.EjsValue.pointerTo()]
        array_new:             -> @abi.createExternalFunction @module, "_ejs_array_new",                 types.EjsValue, [types.int32, types.bool]
        array_new_copy:        -> @abi.createExternalFunction @module, "_ejs_array_new_copy",            types.EjsValue, [types.int32, types.EjsValue.pointerTo()]
        array_from_iterables:  -> @abi.createExternalFunction @module, "_ejs_array_from_iterables",      types.EjsValue, [types.int32, types.EjsValue.pointerTo()]
        number_new:            -> does_not_throw does_not_access_memory @abi.createExternalFunction @module, "_ejs_number_new",                types.EjsValue, [types.double]
        string_new_utf8:       -> only_reads_memory does_not_throw @abi.createExternalFunction @module, "_ejs_string_new_utf8",           types.EjsValue, [types.string]
        regexp_new_utf8:       -> @abi.createExternalFunction @module, "_ejs_regexp_new_utf8",           types.EjsValue, [types.string, types.string]
        truthy:                -> does_not_throw does_not_access_memory @abi.createExternalFunction @module, "_ejs_truthy",                    types.bool, [types.EjsValue]
        object_setprop:        -> @abi.createExternalFunction @module, "_ejs_object_setprop",            types.EjsValue, [types.EjsValue, types.EjsValue, types.EjsValue]
        object_getprop:        -> only_reads_memory @abi.createExternalFunction @module, "_ejs_object_getprop",           types.EjsValue, [types.EjsValue, types.EjsValue]
        global_setprop:        -> @abi.createExternalFunction @module, "_ejs_global_setprop",            types.EjsValue, [types.EjsValue, types.EjsValue]
        global_getprop:        -> only_reads_memory @abi.createExternalFunction @module, "_ejs_global_getprop",           types.EjsValue, [types.EjsValue]

        object_define_accessor_prop: -> @abi.createExternalFunction @module, "_ejs_object_define_accessor_property",  types.bool, [types.EjsValue, types.EjsValue, types.EjsValue, types.EjsValue, types.int32];
        object_define_value_prop: -> @abi.createExternalFunction @module, "_ejs_object_define_value_property",  types.bool, [types.EjsValue, types.EjsValue, types.EjsValue, types.int32];

        object_set_prototype_of: -> @abi.createExternalFunction @module, "_ejs_object_set_prototype_of", types.EjsValue, [types.EjsValue, types.EjsValue];
        object_create:         -> @abi.createExternalFunction @module, "_ejs_object_create",     types.EjsValue, [types.EjsValue];
        prop_iterator_new:     -> @abi.createExternalFunction @module, "_ejs_property_iterator_new",     types.EjsPropIterator, [types.EjsValue]
        prop_iterator_current: -> @abi.createExternalFunction @module, "_ejs_property_iterator_current", types.EjsValue, [types.EjsPropIterator]
        prop_iterator_next:    -> @abi.createExternalFunction @module, "_ejs_property_iterator_next",    types.bool, [types.EjsPropIterator, types.bool]
        prop_iterator_free:    -> @abi.createExternalFunction @module, "_ejs_property_iterator_free",    types.void, [types.EjsPropIterator]
        begin_catch:           -> @abi.createExternalFunction @module, "_ejs_begin_catch",               types.EjsValue, [types.int8Pointer]
        end_catch:             -> @abi.createExternalFunction @module, "_ejs_end_catch",                 types.EjsValue, []
        throw_nativeerror_utf8:-> @abi.createExternalFunction @module, "_ejs_throw_nativeerror_utf8",    types.void, [types.int32, types.string]
        throw:                 -> @abi.createExternalFunction @module, "_ejs_throw",                     types.void, [types.EjsValue]
        rethrow:               -> @abi.createExternalFunction @module, "_ejs_rethrow",                   types.void, [types.EjsValue]

        ToString:              -> @abi.createExternalFunction @module, "ToString",                       types.EjsValue, [types.EjsValue]
        string_concat:         -> @abi.createExternalFunction @module, "_ejs_string_concat",             types.EjsValue, [types.EjsValue, types.EjsValue]
        init_string_literal:   -> @abi.createExternalFunction @module, "_ejs_string_init_literal",       types.void, [types.string, types.EjsValue.pointerTo(), types.EjsPrimString.pointerTo(), types.jschar.pointerTo(), types.int32]

        gc_add_root:           -> @abi.createExternalFunction @module, "_ejs_gc_add_root",               types.void, [types.EjsValue.pointerTo()]
        typeof_is_object:      -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_object",       types.EjsValue, [types.EjsValue]
        typeof_is_function:    -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_function",     types.EjsValue, [types.EjsValue]
        typeof_is_string:      -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_string",       types.EjsValue, [types.EjsValue]
        typeof_is_number:      -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_number",       types.EjsValue, [types.EjsValue]
        typeof_is_undefined:   -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_undefined",    types.EjsValue, [types.EjsValue]
        typeof_is_null:        -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_null",         types.EjsValue, [types.EjsValue]
        typeof_is_boolean:     -> returns_ejsval_bool only_reads_memory @abi.createExternalFunction @module, "_ejs_op_typeof_is_boolean",      types.EjsValue, [types.EjsValue]
        
        undefined:             -> @module.getOrInsertGlobal           "_ejs_undefined",                 types.EjsValue
        "true":                -> @module.getOrInsertGlobal           "_ejs_true",                      types.EjsValue
        "false":               -> @module.getOrInsertGlobal           "_ejs_false",                     types.EjsValue
        "null":                -> @module.getOrInsertGlobal           "_ejs_null",                      types.EjsValue
        "one":                 -> @module.getOrInsertGlobal           "_ejs_one",                       types.EjsValue
        "zero":                -> @module.getOrInsertGlobal           "_ejs_zero",                      types.EjsValue
        global:                -> @module.getOrInsertGlobal           "_ejs_global",                    types.EjsValue
        exception_typeinfo:    -> @module.getOrInsertGlobal           "EJS_EHTYPE_ejsvalue",            types.EjsExceptionTypeInfo
        function_specops:      -> @module.getOrInsertGlobal           "_ejs_Function_specops",          types.EjsSpecops
        symbol_specops:        -> @module.getOrInsertGlobal           "_ejs_Symbol_specops",            types.EjsSpecops

        "unop-":           -> @abi.createExternalFunction @module, "_ejs_op_neg",         types.EjsValue, [types.EjsValue]
        "unop+":           -> @abi.createExternalFunction @module, "_ejs_op_plus",        types.EjsValue, [types.EjsValue]
        "unop!":           -> returns_ejsval_bool @abi.createExternalFunction @module, "_ejs_op_not",         types.EjsValue, [types.EjsValue]
        "unop~":           -> @abi.createExternalFunction @module, "_ejs_op_bitwise_not", types.EjsValue, [types.EjsValue]
        "unoptypeof":      -> does_not_throw @abi.createExternalFunction @module, "_ejs_op_typeof",      types.EjsValue, [types.EjsValue]
        "unopdelete":      -> @abi.createExternalFunction @module, "_ejs_op_delete",      types.EjsValue, [types.EjsValue, types.EjsValue] # this is a unop, but ours only works for memberexpressions
        "unopvoid":        -> @abi.createExternalFunction @module, "_ejs_op_void",        types.EjsValue, [types.EjsValue]

        dump_value:        -> @abi.createExternalFunction @module, "_ejs_dump_value",        types.void, [types.EjsValue]
        log:               -> @abi.createExternalFunction @module, "_ejs_logstr",            types.void, [types.string]
        record_binop:      -> @abi.createExternalFunction @module, "_ejs_record_binop",      types.void, [types.int32, types.string, types.EjsValue, types.EjsValue]
        record_assignment: -> @abi.createExternalFunction @module, "_ejs_record_assignment", types.void, [types.int32, types.EjsValue]
        record_getprop:    -> @abi.createExternalFunction @module, "_ejs_record_getprop",    types.void, [types.int32, types.EjsValue, types.EjsValue]
        record_setprop:    -> @abi.createExternalFunction @module, "_ejs_record_setprop",    types.void, [types.int32, types.EjsValue, types.EjsValue, types.EjsValue]

exports.createInterface = (module, abi) ->
        runtime =
                module: module
                abi: abi
        for k of runtime_interface
                Object.defineProperty runtime, k, { get: runtime_interface[k] }
        runtime

exports.createBinopsInterface = (module, abi) ->
        createBinop = (n) -> abi.createExternalFunction module, n, types.EjsValue, [types.EjsValue, types.EjsValue]
        return Object.create null, {
                "^":          { get: ->                     createBinop "_ejs_op_bitwise_xor" }
                "&":          { get: ->                     createBinop "_ejs_op_bitwise_and" }
                "|":          { get: ->                     createBinop "_ejs_op_bitwise_or" }
                ">>":         { get: ->                     createBinop "_ejs_op_rsh" }
                "<<":         { get: ->                     createBinop "_ejs_op_lsh" }
                ">>>":        { get: ->                     createBinop "_ejs_op_ursh" }
                "<<<":        { get: ->                     createBinop "_ejs_op_ulsh" }
                "%":          { get: ->                     createBinop "_ejs_op_mod" }
                "+":          { get: ->                     createBinop "_ejs_op_add" }
                "*":          { get: ->                     createBinop "_ejs_op_mult" }
                "/":          { get: ->                     createBinop "_ejs_op_div" }
                "-":          { get: ->                     createBinop "_ejs_op_sub" }
                "<":          { get: -> returns_ejsval_bool createBinop "_ejs_op_lt" }
                "<=":         { get: -> returns_ejsval_bool createBinop "_ejs_op_le" }
                ">":          { get: -> returns_ejsval_bool createBinop "_ejs_op_gt" }
                ">=":         { get: -> returns_ejsval_bool createBinop "_ejs_op_ge" }
                "===":        { get: -> returns_ejsval_bool createBinop "_ejs_op_strict_eq" }
                "==":         { get: -> returns_ejsval_bool createBinop "_ejs_op_eq" }
                "!==":        { get: -> returns_ejsval_bool createBinop "_ejs_op_strict_neq" }
                "!=":         { get: -> returns_ejsval_bool createBinop "_ejs_op_neq" }
                "instanceof": { get: -> returns_ejsval_bool createBinop "_ejs_op_instanceof" }
                "in":         { get: -> returns_ejsval_bool createBinop "_ejs_op_in" }
        }                
        
exports.createAtomsInterface = (module) ->
        getGlobal = (n) -> module.getOrInsertGlobal n, types.EjsValue
        return Object.create null, {
                "null":        { get: -> getGlobal "_ejs_atom_null" }
                "undefined":   { get: -> getGlobal "_ejs_atom_undefined" }
                "constructor": { get: -> getGlobal "_ejs_atom_constructor" }
                "length":      { get: -> getGlobal "_ejs_atom_length" }
                "__ejs":       { get: -> getGlobal "_ejs_atom___ejs" }
                "object":      { get: -> getGlobal "_ejs_atom_object" }
                "function":    { get: -> getGlobal "_ejs_atom_function" }
                "prototype":   { get: -> getGlobal "_ejs_atom_prototype" }
                "console":     { get: -> getGlobal "_ejs_atom_console" }
                "log":         { get: -> getGlobal "_ejs_atom_log" }
                "message":     { get: -> getGlobal "_ejs_atom_message" }
                "name":        { get: -> getGlobal "_ejs_atom_name" }
                "true":        { get: -> getGlobal "_ejs_atom_true" }
                "false":       { get: -> getGlobal "_ejs_atom_false" }
                "Arguments": { get: -> getGlobal "_ejs_atom_Arguments" }
                "Array": { get: -> getGlobal "_ejs_atom_Array" }
                "Boolean": { get: -> getGlobal "_ejs_atom_Boolean" }
                "Date": { get: -> getGlobal "_ejs_atom_Date" }
                "Function": { get: -> getGlobal "_ejs_atom_Function" }
                "JSON": { get: -> getGlobal "_ejs_atom_JSON" }
                "Math": { get: -> getGlobal "_ejs_atom_Math" }
                "Number": { get: -> getGlobal "_ejs_atom_Number" }
                "Object": { get: -> getGlobal "_ejs_atom_Object" }
                "Reflect": { get: -> getGlobal "_ejs_atom_Reflect" }
                "RegExp": { get: -> getGlobal "_ejs_atom_RegExp" }
                "String": { get: -> getGlobal "_ejs_atom_String" }
                "Promise": { get: -> getGlobal "_ejs_atom_Promise" }
                "Error": { get: -> getGlobal "_ejs_atom_Error" }
                "EvalError": { get: -> getGlobal "_ejs_atom_EvalError" }
                "RangeError": { get: -> getGlobal "_ejs_atom_RangeError" }
                "ReferenceError": { get: -> getGlobal "_ejs_atom_ReferenceError" }
                "SyntaxError": { get: -> getGlobal "_ejs_atom_SyntaxError" }
                "TypeError": { get: -> getGlobal "_ejs_atom_TypeError" }
                "URIError": { get: -> getGlobal "_ejs_atom_URIError" }
                "console": { get: -> getGlobal "_ejs_atom_console" }
                "require": { get: -> getGlobal "_ejs_atom_require" }
                "exports": { get: -> getGlobal "_ejs_atom_exports" }
                "assign": { get: -> getGlobal "_ejs_atom_assign" }
                "getPrototypeOf": { get: -> getGlobal "_ejs_atom_getPrototypeOf" }
                "setPrototypeOf": { get: -> getGlobal "_ejs_atom_setPrototypeOf" }
                "getOwnPropertyDescriptor": { get: -> getGlobal "_ejs_atom_getOwnPropertyDescriptor" }
                "getOwnPropertyNames": { get: -> getGlobal "_ejs_atom_getOwnPropertyNames" }
                "getOwnPropertySymbols": { get: -> getGlobal "_ejs_atom_getOwnPropertySymbols" }
                "create": { get: -> getGlobal "_ejs_atom_create" }
                "defineProperty": { get: -> getGlobal "_ejs_atom_defineProperty" }
                "defineProperties": { get: -> getGlobal "_ejs_atom_defineProperties" }
                "seal": { get: -> getGlobal "_ejs_atom_seal" }
                "freeze": { get: -> getGlobal "_ejs_atom_freeze" }
                "preventExtensions": { get: -> getGlobal "_ejs_atom_preventExtensions" }
                "isSealed": { get: -> getGlobal "_ejs_atom_isSealed" }
                "isFrozen": { get: -> getGlobal "_ejs_atom_isFrozen" }
                "isExtensible": { get: -> getGlobal "_ejs_atom_isExtensible" }
                "keys": { get: -> getGlobal "_ejs_atom_keys" }
                "toString": { get: -> getGlobal "_ejs_atom_toString" }
                "toLocaleString": { get: -> getGlobal "_ejs_atom_toLocaleString" }
                "valueOf": { get: -> getGlobal "_ejs_atom_valueOf" }
                "hasOwnProperty": { get: -> getGlobal "_ejs_atom_hasOwnProperty" }
                "isPrototypeOf": { get: -> getGlobal "_ejs_atom_isPrototypeOf" }
                "propertyIsEnumerable": { get: -> getGlobal "_ejs_atom_propertyIsEnumerable" }
                "isArray": { get: -> getGlobal "_ejs_atom_isArray" }
                "push": { get: -> getGlobal "_ejs_atom_push" }
                "pop": { get: -> getGlobal "_ejs_atom_pop" }
                "shift": { get: -> getGlobal "_ejs_atom_shift" }
                "unshift": { get: -> getGlobal "_ejs_atom_unshift" }
                "concat": { get: -> getGlobal "_ejs_atom_concat" }
                "slice": { get: -> getGlobal "_ejs_atom_slice" }
                "splice": { get: -> getGlobal "_ejs_atom_splice" }
                "indexOf": { get: -> getGlobal "_ejs_atom_indexOf" }
                "join": { get: -> getGlobal "_ejs_atom_join" }
                "forEach": { get: -> getGlobal "_ejs_atom_forEach" }
                "map": { get: -> getGlobal "_ejs_atom_map" }
                "every": { get: -> getGlobal "_ejs_atom_every" }
                "some": { get: -> getGlobal "_ejs_atom_some" }
                "reduce": { get: -> getGlobal "_ejs_atom_reduce" }
                "reduceRight": { get: -> getGlobal "_ejs_atom_reduceRight" }
                "reverse": { get: -> getGlobal "_ejs_atom_reverse" }
                "copyWithin": { get: -> getGlobal "_ejs_atom_copyWithin" }
                "of": { get: -> getGlobal "_ejs_atom_of" }
                "from": { get: -> getGlobal "_ejs_atom_from" }
                "fill": { get: -> getGlobal "_ejs_atom_fill" }
                "find": { get: -> getGlobal "_ejs_atom_find" }
                "findIndex": { get: -> getGlobal "_ejs_atom_findIndex" }
                "filter": { get: -> getGlobal "_ejs_atom_filter" }
                "next": { get: -> getGlobal "_ejs_atom_next" }
                "done": { get: -> getGlobal "_ejs_atom_done" }
                "parse": { get: -> getGlobal "_ejs_atom_parse" }
                "stringify": { get: -> getGlobal "_ejs_atom_stringify" }
                "charAt": { get: -> getGlobal "_ejs_atom_charAt" }
                "charCodeAt": { get: -> getGlobal "_ejs_atom_charCodeAt" }
                "codePointAt": { get: -> getGlobal "_ejs_atom_codePointAt" }
                "contains": { get: -> getGlobal "_ejs_atom_contains" }
                "endsWith": { get: -> getGlobal "_ejs_atom_endsWith" }
                "lastIndexOf": { get: -> getGlobal "_ejs_atom_lastIndexOf" }
                "localeCompare": { get: -> getGlobal "_ejs_atom_localeCompare" }
                "match": { get: -> getGlobal "_ejs_atom_match" }
                "repeat": { get: -> getGlobal "_ejs_atom_repeat" }
                "replace": { get: -> getGlobal "_ejs_atom_replace" }
                "search": { get: -> getGlobal "_ejs_atom_search" }
                "split": { get: -> getGlobal "_ejs_atom_split" }
                "startsWith": { get: -> getGlobal "_ejs_atom_startsWith" }
                "substr": { get: -> getGlobal "_ejs_atom_substr" }
                "substring": { get: -> getGlobal "_ejs_atom_substring" }
                "toLocaleLowerCase": { get: -> getGlobal "_ejs_atom_toLocaleLowerCase" }
                "toLocaleUpperCase": { get: -> getGlobal "_ejs_atom_toLocaleUpperCase" }
                "toLowerCase": { get: -> getGlobal "_ejs_atom_toLowerCase" }
                "toUpperCase": { get: -> getGlobal "_ejs_atom_toUpperCase" }
                "trim": { get: -> getGlobal "_ejs_atom_trim" }
                "fromCharCode": { get: -> getGlobal "_ejs_atom_fromCharCode" }
                "fromCodePoint": { get: -> getGlobal "_ejs_atom_fromCodePoint" }
                "raw": { get: -> getGlobal "_ejs_atom_raw" }
                "apply": { get: -> getGlobal "_ejs_atom_apply" }
                "call": { get: -> getGlobal "_ejs_atom_call" }
                "bind": { get: -> getGlobal "_ejs_atom_bind" }
                "warn": { get: -> getGlobal "_ejs_atom_warn" }
                "exit": { get: -> getGlobal "_ejs_atom_exit" }
                "chdir": { get: -> getGlobal "_ejs_atom_chdir" }
                "cwd": { get: -> getGlobal "_ejs_atom_cwd" }
                "env": { get: -> getGlobal "_ejs_atom_env" }
                "Map": { get: -> getGlobal "_ejs_atom_Map" }
                "Set": { get: -> getGlobal "_ejs_atom_Set" }
                "clear": { get: -> getGlobal "_ejs_atom_clear" }
                "delete": { get: -> getGlobal "_ejs_atom_delete" }
                "entries": { get: -> getGlobal "_ejs_atom_entries" }
                "add": { get: -> getGlobal "_ejs_atom_add" }
                "has": { get: -> getGlobal "_ejs_atom_has" }
                "values": { get: -> getGlobal "_ejs_atom_values" }
                "Proxy": { get: -> getGlobal "_ejs_atom_Proxy" }
                "createFunction": { get: -> getGlobal "_ejs_atom_createFunction" }
                "construct": { get: -> getGlobal "_ejs_atom_construct" }
                "deleteProperty": { get: -> getGlobal "_ejs_atom_deleteProperty" }
                "enumerate": { get: -> getGlobal "_ejs_atom_enumerate" }
                "ownKeys": { get: -> getGlobal "_ejs_atom_ownKeys" }
                "size": { get: -> getGlobal "_ejs_atom_size" }
                "Symbol": { get: -> getGlobal "_ejs_atom_Symbol" }
                "for": { get: -> getGlobal "_ejs_atom_for" }
                "keyFor": { get: -> getGlobal "_ejs_atom_keyFor" }
                "hasInstance": { get: -> getGlobal "_ejs_atom_hasInstance" }
                "isConcatSpreadable": { get: -> getGlobal "_ejs_atom_isConcatSpreadable" }
                "isRegExp": { get: -> getGlobal "_ejs_atom_isRegExp" }
                "iterator": { get: -> getGlobal "_ejs_atom_iterator" }
                "toPrimitive": { get: -> getGlobal "_ejs_atom_toPrimitive" }
                "toStringTag": { get: -> getGlobal "_ejs_atom_toStringTag" }
                "unscopables": { get: -> getGlobal "_ejs_atom_unscopables" }
        }

exports.createGlobalsInterface = (module) ->
        getGlobal = (n) -> module.getOrInsertGlobal n, types.EjsValue
        return Object.create null, {
                "Object":             { get: -> getGlobal "_ejs_Object" }
                "Object_prototype":   { get: -> getGlobal "_ejs_Object_prototype" }
                "Boolean":            { get: -> getGlobal "_ejs_Boolean" }
                "String":             { get: -> getGlobal "_ejs_String" }
                "Number":             { get: -> getGlobal "_ejs_Number" }
                "Array":              { get: -> getGlobal "_ejs_Array" }
                "DataView":           { get: -> getGlobal "_ejs_DataView" }
                "Date":               { get: -> getGlobal "_ejs_Date" }
                "Error":              { get: -> getGlobal "_ejs_Error" }
                "EvalError":          { get: -> getGlobal "_ejs_EvalError" }
                "RangeError":         { get: -> getGlobal "_ejs_RangeError" }
                "ReferenceError":     { get: -> getGlobal "_ejs_ReferenceError" }
                "SyntaxError":        { get: -> getGlobal "_ejs_SyntaxError" }
                "TypeError":          { get: -> getGlobal "_ejs_TypeError" }
                "URIError":           { get: -> getGlobal "_ejs_URIError" }
                "Function":           { get: -> getGlobal "_ejs_Function" }
                "JSON":               { get: -> getGlobal "_ejs_JSON" }
                "Math":               { get: -> getGlobal "_ejs_Math" }
                "Map":                { get: -> getGlobal "_ejs_Map" }
                "Proxy":              { get: -> getGlobal "_ejs_Proxy" }
                "Promise":            { get: -> getGlobal "_ejs_Promise" }
                "Reflect":            { get: -> getGlobal "_ejs_Reflect" }
                "RegExp":             { get: -> getGlobal "_ejs_RegExp" }
                "Symbol":             { get: -> getGlobal "_ejs_Symbol" }
                "Set":                { get: -> getGlobal "_ejs_Set" }
                "console":            { get: -> getGlobal "_ejs_console" }
                "ArrayBuffer":        { get: -> getGlobal "_ejs_ArrayBuffer" }
                "Int8Array":          { get: -> getGlobal "_ejs_Int8Array" }
                "Int16Array":         { get: -> getGlobal "_ejs_Int16Array" }
                "Int32Array":         { get: -> getGlobal "_ejs_Int32Array" }
                "Uint8Array":         { get: -> getGlobal "_ejs_Uint8Array" }
                "Uint16Array":        { get: -> getGlobal "_ejs_Uint16Array" }
                "Uint32Array":        { get: -> getGlobal "_ejs_Uint32Array" }
                "Float32Array":       { get: -> getGlobal "_ejs_Float32Array" }
                "Float64Array":       { get: -> getGlobal "_ejs_Float64Array" }
                "XMLHttpRequest":     { get: -> getGlobal "_ejs_XMLHttpRequest" }
                "process":            { get: -> getGlobal "_ejs_Process" }
                "require":            { get: -> getGlobal "_ejs_require" }
                "isNaN":              { get: -> getGlobal "_ejs_isNaN" }
                "isFinite":           { get: -> getGlobal "_ejs_isFinite" }
                "parseInt":           { get: -> getGlobal "_ejs_parseInt" }
                "parseFloat":         { get: -> getGlobal "_ejs_parseFloat" }
                "decodeURI":          { get: -> getGlobal "_ejs_decodeURI" }
                "encodeURI":          { get: -> getGlobal "_ejs_encodeURI" }
                "decodeURIComponent": { get: -> getGlobal "_ejs_decodeURIComponent" }
                "encodeURIComponent": { get: -> getGlobal "_ejs_encodeURIComponent" }
                "undefined":          { get: -> getGlobal "_ejs_undefined" }
                "Infinity":           { get: -> getGlobal "_ejs_Infinity" }
                "NaN":                { get: -> getGlobal "_ejs_nan" }
                "__ejs":              { get: -> getGlobal "_ejs__ejs" }
                # kind of a hack, but since we don't define these...
                "window":             { get: -> getGlobal "_ejs_undefined" }
                "document":           { get: -> getGlobal "_ejs_undefined" }
        }

exports.createSymbolsInterface = (module) ->
        getGlobal = (n) -> module.getOrInsertGlobal n, types.EjsValue
        return Object.create null, {
                "create":      { get: -> getGlobal "_ejs_Symbol_create" }
        }
