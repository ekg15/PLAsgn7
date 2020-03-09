// top environment for program
var top_env: [String:Value] = [
    "true" : BoolV(true),
    "false" : BoolV(false),
    "+" : PrimV(numPlus),
    "-" : PrimV(numMinus),
    "*" : PrimV(numMult),
    "/" : PrimV(numDivide),
    "<=" : PrimV(numleq),
    "equal?" : PrimV(anyeq)
]

// sum of two numVs, returns error if not numVs or wrong pattern
func numPlus(values: [Value]) -> Value {
    switch values {
    case numV:
        
    }
    return 
}

// subtracts two numVs, returns error if not numVs or wrong pattern
func numMinus(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

// multiplys two numVs, returns error if not numVs or wrong pattern
func numMult(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

// divides two numVs, returns error if not numVs or wrong pattern or second arg is 0
func numDivide(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

// checks if left numV is less than or equal to right numV, returns error if not numVs or more than 2
func numleq(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

// checks if two values are the same value type and are equal to each other or not, returns error if wrong pattern
func anyeq(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

