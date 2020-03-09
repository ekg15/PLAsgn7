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
    case PrimV(([Value]) -> Value)

    func get_bool() -> Bool throws{
        switch self {
            case let .NumV(_):
                throw "DUNQ: conditional has non-boolean test"
            case let .StringV(_):
                throw "DUNQ: conditional has non-boolean test"
            case let .BoolV(val):
                return val
            case let .CloV(_, _, _):
                throw "DUNQ: conditional has non-boolean test"
            case let .PrimV(_):
                throw "DUNQ: conditional has non-boolean test"
        }
    }
}

func interp(exp: ExprC, env: Env) -> Value throws {
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
            switch interp(exp: f, env: env) {
                case let .NumV(_):
                    throw "DUNQ: improper function application"
                case let .StringV(_):
                    throw "DUNQ: improper function application"
                case let .BoolV(_):
                    throw "DUNQ: improper function application"
                case let .CloV(p, b, clo_env):
                    let argvals = list_interp(args: a, env: env)
                    let env2 = list_env_extend(env: clo_env, params: p, argvals: argvals)
                case let .PrimV(_):
                    return false
            }
    }
}

func env_lookup(env: Env, s: String) -> Value {
    return Value.NumV(3)
}

var x = ExprC.numC(34);
var y = ExprC.lamC(["hi", "hello"], x);
