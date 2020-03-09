indirect enum ExprC {
    case numC(Float)
    case stringC(String)
    case idC(String)
    case appC(ExprC, [ExprC])
    case lamC([String], ExprC)
    case ifC(ExprC, ExprC, ExprC)
}

struct Binding {
    var name: String
    var val: Value
}
typealias Env = [Binding];

indirect enum Value {
    case NumV(Float)
    case StringV(String)
    case BoolV(Bool)
    case CloV([String], ExprC, Env)
    case PrimV(([Value]) -> Value)
}

var x = ExprC.numC(34);
var y = ExprC.lamC(["hi", "hello"], x);
print(y)

