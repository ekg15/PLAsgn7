import XCTest
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
    case PrimV(([Value]) -> Value)

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
                        return primF(argvals)
                }
            }
            catch {
                print("DUNQ: improper function application")
                exit(1)
            }
    }
}

func env_lookup(env: Env, s: String) -> Value {
    return Value.NumV(3)
}

func list_interp(args: [ExprC], env: Env) -> [Value] {
    return [Value.NumV(3), Value.NumV(3)]
}

func list_env_extend(env: Env, params: [String], argvals: [Value]) -> Env {
    return ["he" : Value.NumV(3)]
}


// Testing=============================================================================
