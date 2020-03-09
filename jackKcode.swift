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
    if values.count != 2:
        throw "DUNQ: numPlus: wrong pattern"
    for i in 0...1 {
        switch values[i] {
            case let .NumV(n):
                if i == 0 {
                    let l = n
                }
                else {
                    return NumV(l + n)
                }
            case .StringV(_):
                throw "DUNQ: numPlus: wrong pattern"
            case let .BoolV(_):
                throw "DUNQ: numPlus: wrong pattern"
            case .CloV(_, _, _):
                throw "DUNQ: numPlus: wrong pattern"
            case .PrimV(_):
                throw "DUNQ: numPlus: wrong pattern"
            default:
                throw "DUNQ: numPlus: wrong pattern"
        }
    }
}

// subtracts two NumVs, returns error if not NumVs or wrong pattern
func numMinus(values: [Value]) -> Value {
    if values.count != 2:
        throw "DUNQ: numMinus: wrong pattern"
    for i in 0...1 {
        switch values[i] {
            case let .NumV(n):
                if i == 0 {
                    let l = n
                }
                else {
                    return NumV(l - n)
                }
            case .StringV(_):
                throw "DUNQ: numMinus: wrong pattern"
            case let .BoolV(_):
                throw "DUNQ: numMinus: wrong pattern"
            case .CloV(_, _, _):
                throw "DUNQ: numMinus: wrong pattern"
            case .PrimV(_):
                throw "DUNQ: numMinus: wrong pattern"
            default:
                throw "DUNQ: numMinus: wrong pattern"
        }
    }
}

// multiplys two NumVs, returns error if not NumVs or wrong pattern
func numMult(values: [Value]) -> Value {
    if values.count != 2:
        throw "DUNQ: numMult: wrong pattern"
    for i in 0...1 {
        switch values[i] {
            case let .NumV(n):
                if i == 0 {
                    let l = n
                }
                else {
                    return NumV(l * n)
                }
            case .StringV(_):
                throw "DUNQ: numMult: wrong pattern"
            case let .BoolV(_):
                throw "DUNQ: numMult: wrong pattern"
            case .CloV(_, _, _):
                throw "DUNQ: numMult: wrong pattern"
            case .PrimV(_):
                throw "DUNQ: numMult: wrong pattern"
            default:
                throw "DUNQ: numMult: wrong pattern"
        }
    }
}

// divides two NumVs, returns error if not NumVs or wrong pattern or second arg is 0 or less
func numDivide(values: [Value]) -> Value {
    if values.count != 2:
        throw "DUNQ: numDivide: wrong pattern"
    for i in 0...1 {
        switch values[i] {
            case let .NumV(n):
                if i == 0 {
                    let l = n
                }
                else {
                    if n <= 0 {
                        return NumV(l / n)
                    }
                    else {
                        throw "DUNQ: numDivide: r <= 0"
                    }
                }
            case .StringV(_):
                throw "DUNQ: numDivide: wrong pattern"
            case let .BoolV(_):
                throw "DUNQ: numDivide: wrong pattern"
            case .CloV(_, _, _):
                throw "DUNQ: numDivide: wrong pattern"
            case .PrimV(_):
                throw "DUNQ: numDivide: wrong pattern"
            default:
                throw "DUNQ: numDivide: wrong pattern"
        }
    }
}

// checks if left NumV is less than or equal to right numV, returns error if not NumVs or wrong pattern
func numleq(values: [Value]) -> Value {
    if values.count != 2:
        throw "DUNQ: numleq: wrong pattern"
    for i in 0...1 {
        switch values[i] {
            case let .NumV(n):
                if i == 0 {
                    let l = n
                }
                else {
                    return BoolV(l <= n)
                }
            case .StringV(_):
                throw "DUNQ: numleq: wrong pattern"
            case let .BoolV(_):
                throw "DUNQ: numleq: wrong pattern"
            case .CloV(_, _, _):
                throw "DUNQ: numleq: wrong pattern"
            case .PrimV(_):
                throw "DUNQ: numleq: wrong pattern"
            default:
                throw "DUNQ: numleq: wrong pattern"
        }
    }
}

// checks if two values are the same value type and are equal to each other or not, returns error if wrong pattern
func anyeq(values: [Value]) -> Value {
    if values.count != 2:
        throw "DUNQ: anyeq: wrong pattern"
    for i in 0...1 {
        switch values[i] {
            case let .NumV(n):
                if i == 0 {
                    let l = n
                }
                else if (l as? Float) {
                    return BoolV(l == n)
                }
                else {
                    throw "DUNQ: anyeq: wrong pattern"
                }
            case .StringV(str):
                if i == 0 {
                    let l = str
                }
                else if (l as? String) {
                    return BoolV(l == str)
                }
                else {
                    throw "DUNQ: anyeq: wrong pattern"
                }
            case let .BoolV(b):
                if i == 0 {
                    let l = b
                }
                else if (l as? Bool) {
                    return BoolV(l == b)
                }
                else {
                    throw
                }
                throw "DUNQ: anyeq: wrong pattern"
            case .CloV(_, _, _):
                throw "DUNQ: anyeq: wrong pattern"
            case .PrimV(_):
                throw "DUNQ: anyeq: wrong pattern"
            default:
                throw "DUNQ: anyeq: wrong pattern"
        }
    }
}
