// top environment for program
let top_env =  Env[
    "true" : BoolV(true),
    "false" : BoolV(false),
    "+" : PrimV(numPlus),
    "-" : PrimV(numMinus),
    "*" : PrimV(numMult),
    "/" : PrimV(numDivide),
    "<=" : PrimV(numleq),
    "equal?" : PrimV(anyeq)
]

// sum of two NumVs, returns error if not NumVs or wrong pattern
func numPlus(values: [Value]) -> Value {
    switch values {
        case let [.NumV(l), .NumV(r)]:
            return NumV(l + r)
        default:
            throw "DUNQ: numPlus:  wrong pattern"
    }
    return 
}

// subtracts two NumVs, returns error if not NumVs or wrong pattern
func numMinus(values: [Value]) -> Value {
    switch values {
        case let [.NumV(l), .NumV(r)]:
            return NumV(l - r)
        default:
            throw "DUNQ: numMinus: wrong pattern"
    }
    return
}

// multiplys two NumVs, returns error if not NumVs or wrong pattern
func numMult(values: [Value]) -> Value {
    switch values {
        case let [.NumV(l), .NumV(r)]:
            return NumV(l * r)
        default:
            throw "DUNQ: numMult: wrong pattern"
    }
    return
}

// divides two NumVs, returns error if not NumVs or wrong pattern or second arg is 0 or less
func numDivide(values: [Value]) -> Value {
    switch values {
        case let [.NumV(l), .NumV(r)]:
            if r <= 0:
                return NumV(l / r)
            else:
                throw "DUNQ: numDivide: r <= 0"
        default:
            throw "DUNQ: numDivide: wrong pattern"
    }
    return
}

// checks if left NumV is less than or equal to right numV, returns error if not NumVs or wrong pattern
func numleq(values: [Value]) -> Value {
    switch values {
        case let [.NumV(l), .NumV(r)]:
            return BoolV(l <= r)
        default:
            throw "DUNQ: numleq: wrong pattern"
    }
    return
}

// checks if two values are the same value type and are equal to each other or not, returns error if wrong pattern
func anyeq(values: [Value]) -> Value {
    switch values {
        case let [.NumV(l), .NumV(r)]:
            return BoolV(l == r)
        case let [.BoolV(l), .BoolV(r)]:
            return BoolV(l == r)
        case let [.StringV(l), .StringV(r)]:
            return BoolV(l == r)
        default:
            throw "DUNQ: anyeq: wrong pattern"
    }
}
