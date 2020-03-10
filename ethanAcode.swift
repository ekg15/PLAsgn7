import Darwin


// Defining All Types==================================================================
extension String: Error {}

indirect enum ExprC {
    case numC(Float)
    case stringC(String)
    case idC(String)
    case appC(ExprC, [ExprC])
    case lamC([String], ExprC)
    case ifC(ExprC, ExprC, ExprC)
}

typealias Env = [String : Value]

indirect enum Value {
    case NumV(Float)
    case StringV(String)
    case BoolV(Bool)
    case CloV([String], ExprC, Env)
    case PrimV(([Value]) throws -> Value)

    func get_bool() -> Bool{
        do {
            switch self {
                case .NumV(_):
                    throw "Error"
                case .StringV(_):
                    throw "Error"
                case let .BoolV(val):
                    return val
                case .CloV(_, _, _):
                    throw "Error"
                case .PrimV(_):
                    throw "Error"
            }
        }
        catch {
            print("DUNQ: conditional has non-boolean test")
            exit(1)
        }
    }

    func serialize() -> String {
        switch self {
            case let .NumV(n):
                return "\(n)"
            case let .StringV(str):
                return "\"\(str)\""
            case let .BoolV(val):
                if val {
                    return "true"
                }
                else {
                    return "false"
                }
            case .CloV(_, _, _):
                return "#<procedure>"
            case .PrimV(_):
                return "#<primop>"
        }
    }
}

// Main Interface Functions============================================================

func interp(exp: ExprC, env: Env) -> Value {
    switch exp {
        case let .idC(s):
            return env_lookup(env: env, s: s)
        case let .numC(n):
            return Value.NumV(n)
        case let .stringC(str):
            return Value.StringV(str)
        case let .ifC(a, b, c):
            let check = interp(exp: a, env: env)
            if check.get_bool() {
                return interp(exp: b, env: env)
            }
            else {
                return interp(exp: c, env: env)
            }
        case let .lamC(p, b):
            return Value.CloV(p, b, env)
        case let .appC(f, a):
            do {
                switch interp(exp: f, env: env) {
                    case .NumV(_):
                        throw "error"
                    case .StringV(_):
                        throw "error"
                    case .BoolV(_):
                        throw "error"
                    case let .CloV(p, b, clo_env):
                        let argvals = list_interp(args: a, env: env)
                        let env2 = list_env_extend(env: clo_env, params: p, argvals: argvals)
                        return interp(exp: b, env: env2)
                    case let .PrimV(primF):
                        let argvals = list_interp(args: a, env: env)
                        do {
                            let result: Value = try primF(argvals)
                            return result
                        }
                        catch {
                            print("DUNQ: primitive error")

                        }
                }
            }
            catch {
                print("DUNQ: improper function application")
                exit(1)
            }
    }
    return Value.NumV(0)
}

func env_lookup(env: Env, s: String) -> Value {
    let bind = env[s]
    if bind != nil {
        return bind!
    }
    do {
        throw "error"
    }
    catch {
        print("unidentified ID \(s)")
        exit(1)
    }
}

func list_interp(args: [ExprC], env: Env) -> [Value] {
    if args.count == 0 {
        return []
    }
    return [interp(exp: args[0], env: env)] + list_interp(args: Array(args[1...]), env: env)
}

func list_env_extend(env: Env, params: [String], argvals: [Value]) -> Env {
    if(params.count == 0) {
        return env
    }
    var new_env: Env = env
    new_env[params[0]] = argvals[0]
    return list_env_extend(env: new_env, params: Array(params[1...]), argvals: Array(argvals[1...]))
}

// Top Environment====================================================================

// sum of two NumVs, returns error if not NumVs or wrong pattern
func numPlus(values: [Value]) throws -> Value {
    if (values.count != 2) {
        throw "DUNQ: wrong pattern +"
    }
    let l: Float
    switch values[0] {
        case let .NumV(n):
            l = n
        default:
            throw "DUNQ: wrong pattern +"
    }
    switch values[1] {
        case let .NumV(r):
            return Value.NumV(l + r)
        default:
            throw "DUNQ: wrong pattern +"
    }
}

// subtracts two NumVs, returns error if not NumVs or wrong pattern
func numMinus(values: [Value]) throws -> Value {
    if (values.count != 2) {
        throw "DUNQ: wrong pattern in -"
    }
    let l: Float
    switch values[0] {
        case let .NumV(n):
            l = n
        default:
            throw "DUNQ: wrong pattern in -"
    }
    switch values[1] {
        case let .NumV(r):
            return Value.NumV(l - r)
        default:
            throw "DUNQ: wrong pattern in -"
    }
}

// multiplys two NumVs, returns error if not NumVs or wrong pattern
func numMult(values: [Value]) throws -> Value {
    if (values.count != 2) {
        throw "DUNQ: wrong pattern in *"
    }
    let l: Float
    switch values[0] {
        case let .NumV(n):
            l = n
        default:
            throw "DUNQ: wrong pattern in *"
    }
    switch values[1] {
        case let .NumV(r):
            return Value.NumV(l * r)
        default:
            throw "DUNQ: wrong pattern in *"
    }
}

// divides two NumVs, returns error if not NumVs or wrong pattern or second arg is 0 or less
func numDivide(values: [Value]) throws -> Value {
    if (values.count != 2) {
        throw "DUNQ: wrong pattern in /"
    }
    let l: Float
    switch values[0] {
        case let .NumV(n):
            l = n
        default:
            throw "DUNQ: wrong pattern in /"
    }
    switch values[1] {
        case let .NumV(r):
            if (r == 0) {
                throw "DUNQ: divide by 0"
            }
            return Value.NumV(l / r)
        default:
            throw "DUNQ: wrong pattern in /"
    }
}

// checks if left NumV is less than or equal to right numV, returns error if not NumVs or wrong pattern
func numleq(values: [Value]) throws -> Value {
    if (values.count != 2) {
        throw "DUNQ: wrong pattern in <="
    }
    let l: Float
    switch values[0] {
        case let .NumV(n):
            l = n
        default:
            throw "DUNQ: wrong pattern in <="
    }
    switch values[1] {
        case let .NumV(r):
            return Value.BoolV(l <= r)
        default:
            throw "DUNQ: wrong pattern in <="
    }
}

// checks if two values are the same value type and are equal to each other or not, returns error if wrong pattern
func anyeq(values: [Value]) throws -> Value {
    if (values.count != 2) {
        throw "DUNQ: wrong pattern in equal?"
    }
    var l1: Float = 0
    var l2: String = ""
    var l3: Bool = false
    switch values[0] {
        case let .NumV(n):
            l1 = n
        case let .StringV(str):
            l2 = str
        case let .BoolV(val):
            l3 = val
        default:
            throw "DUNQ: wrong pattern in equal?"
    }
    switch values[1] {
        case let .NumV(r):
            return Value.BoolV(l1 == r)
        case let .StringV(str):
            return Value.BoolV(l2 == str)
        case let .BoolV(val):
            return Value.BoolV(l3 == val)
        default:
            throw "DUNQ: wrong pattern in equal?"
    }
}


func top_env() -> Env {
    return ["true" : Value.BoolV(true),
            "false" : Value.BoolV(false),
            "+" : Value.PrimV(numPlus),
            "-" : Value.PrimV(numMinus),
            "*" : Value.PrimV(numMult),
            "/" : Value.PrimV(numDivide),
            "<=" : Value.PrimV(numleq),
            "equal?" : Value.PrimV(anyeq)]
}

// Testing=============================================================================
var result = interp(exp: ExprC.idC("true"), env: top_env()).serialize()
print("Test 1: Sexp -> true, Expected -> \(result), Actual -> true")
result = interp(exp: ExprC.idC("false"), env: top_env()).serialize()
print("Test 2: Sexp -> false, Expected -> \(result), Actual -> false")
result = interp(exp: ExprC.stringC("hello"), env: top_env()).serialize()
print("Test 3: Sexp -> \"hello\", Expected -> \(result), Actual -> \"hello\"")
result = interp(exp: ExprC.numC(15), env: top_env()).serialize()
print("Test 4: Sexp -> 15, Expected -> \(result), Actual -> 15.0")
result = interp(exp: ExprC.ifC(ExprC.idC("true"), ExprC.numC(4), ExprC.numC(5)), env: top_env()).serialize()
print("Test 5: Sexp -> {if true 4 5}, Expected -> \(result), Actual -> 4.0")
result = interp(exp: ExprC.ifC(ExprC.idC("false"), ExprC.numC(4), ExprC.numC(5)), env: top_env()).serialize()
print("Test 6: Sexp -> {if false 4 5}, Expected -> \(result), Actual -> 5.0")
result = interp(exp: ExprC.appC(
                        ExprC.lamC(["x", "y"],
                            ExprC.appC(ExprC.idC("+"),
                                [ExprC.idC("x"), ExprC.idC("y")])),
                        [ExprC.numC(4), ExprC.numC(5)]), env: top_env()).serialize()
print("Test 7: Sexp -> {{lam {x y} {+ x y}} 4 5}, Expected -> \(result), Actual -> 9.0")
result = interp(exp: ExprC.lamC(["x", "y"],
                        ExprC.appC(ExprC.idC("<="),
                            [ExprC.idC("x"), ExprC.idC("y")])), env: top_env()).serialize()
print("Test 8: Sexp -> {lam {x y} {+ x y}, Expected -> \(result), Actual -> #<procedure>")
result = interp(exp: ExprC.idC("<="), env: top_env()).serialize()
print("Test 9: Sexp -> <=, Expected -> \(result), Actual -> #<primop>")
result = interp(exp: ExprC.appC(ExprC.idC("<="),
                        [ExprC.numC(70), ExprC.numC(222)]), env: top_env()).serialize()
print("Test 10: Sexp -> {<= 70 222}, Expected -> \(result), Actual -> true")
result = interp(exp: ExprC.appC(ExprC.idC("equal?"),
                        [ExprC.stringC("hello"), ExprC.stringC("hi")]), env: top_env()).serialize()
print("Test 11: Sexp -> {equal? \"hello\" \"hi\"}, Expected -> \(result), Actual -> false")