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


func numPlus(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return 
}

func numMinus(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

func numMult(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

func numDivide(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

func numleq(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

func anyeq(values: [Value]) -> Value {
    switch values {
    case numC:
        
    }
    return
}

