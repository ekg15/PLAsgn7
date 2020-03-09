import Darwin

enum MyError: Error {
    case runtimeError(String)
}

indirect enum ExprC {
    case numC(Float)
    case stringC(String)
    case idC(String)
    case appC(ExprC, [ExprC])
    case lamC([String], ExprC)
    case ifC(ExprC, ExprC, ExprC)
}

indirect enum Value {
    case NumV(Float)
    case StringV(String)
    case BoolV(Bool)
    case CloV([String], ExprC, Env)
    case PrimV(([Value]) -> Value)

    func get_bool() throws -> Bool {
        switch self {
            case let .NumV(_):
                throw MyError.runtimeError("DUNQ: conditional has non-boolean test")
            case let .StringV(_):
                throw MyError.runtimeError("DUNQ: conditional has non-boolean test")
                //return Value.StringV("DUNQ: conditional has non-boolean test")
            case let .BoolV(val):
                return val
            case let .CloV(_, _, _):
                throw MyError.runtimeError("DUNQ: conditional has non-boolean test")
                //return Value.StringV("DUNQ: conditional has non-boolean test")
            case let .PrimV(_):
                throw MyError.runtimeError("DUNQ: conditional has non-boolean test")
                //return Value.StringV("DUNQ: conditional has non-boolean test")
            default:
                throw MyError.runtimeError("DUNQ: conditional has non-boolean test")
                //return Value.StringV("DUNQ: conditional has non-boolean test")

        }
    }
}
/*
  
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
*/
func env_lookup(env: Env, s: String) -> Value {
    return Value.NumV(3)
}

struct Binding {
    var name: String
    var val: Value
}
typealias Env = [Binding];


func interp(exp: ExprC, env: Env) -> Value  {
    switch exp {
        case let .idC(s):
            return env_lookup(env: env, s: s)
        case let .numC(n):
            return Value.NumV(n)
        case let .stringC(str):
            return Value.StringV(str)
        case let .ifC(a, b, c):
            let check = interp(exp: a, env: env)
            do { if try check.get_bool() {
                return interp(exp: b, env: env)
            }
            else {
                return interp(exp: c, env: env)
            }} catch {
                "DUNQ: improper function application"
            }
        case let .lamC(p, b):
            return Value.CloV(p, b, env)
        case let .appC(f, a):
             switch interp(exp: f, env: env) {
                case let .NumV(_):
                    Value.StringV("DUNQ: improper function application")
                case let .StringV(_):
                    Value.StringV("DUNQ: improper function application")
                case let .BoolV(_):
                    Value.StringV("DUNQ: improper function application")
                case let .CloV(p, b, clo_env):
                    let argvals = list_interp(args: a, env: env)
                    let env2 = list_env_extend(env: clo_env, params: p, argvals: argvals)
                case let .PrimV(_):
                    return Value.BoolV(false)
                }
        default:
            return Value.NumV(3)
    }
    return Value.NumV(3)
}

func list_interp(args: [ExprC], env: Env) -> [Value] {
    if args.count == 0 {
        return []
    }
    return [interp(exp: args[0], env: env)] + list_interp(args: Array(args[1...]), env: env)
}

func list_env_extend(env: Env, params: [String], argvals: [Value]) -> Env {
    if(params.count == 0)
    {
        return env
    }
    return [Binding(name: params[0], val: argvals[0])] + list_env_extend(env: env, params: Array(params[1...]), argvals: Array(argvals[1...]))
}

print("list_env_extend_test: ", list_env_extend(env: [], params: ["s", "t"], argvals: [Value.NumV(3), Value.NumV(9)]))
print("list_interp_test: ", list_interp(args: [ExprC.numC(3), ExprC.numC(3)], env: []))

var x = ExprC.numC(34);
var y = ExprC.lamC(["hi", "hello"], x);
//print(y)


/*func parse(sexp: [[String]]) -> ExprC {
    print(sexp)
    switch sexp {
        case sexp[0] is String:
            return ExprC.appC(ExprC.lamC(["x"], ExprC.numC(8)), [ExprC.numC(3), ExprC.numC(3)])
        default:
            return ExprC.stringC("DUNQ: Syntax Error")
    }
}*/

//print(parse(sexp: [["vars", [["x", "3"], ["y", "3"]], "7"]]))

/*
 	            Num
 	 	|	 	id
 	 	|	 	String
 	 	|	 	{if Expr Expr Expr}
 	 	|	 	{vars {{id Expr} ...} Expr}
 	 	|	 	{lam {id ...} Expr}
 	 	|	 	{Expr Expr ...}
*/