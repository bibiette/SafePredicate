import Foundation

public enum MathCompare<Value: Numeric & Comparable> {
    case count(Compare)
    case average(Compare)
    case sum(Compare)
    case max(Compare)
    case min(Compare)
    
    public enum Compare {
        case greaterThan(Value)
        case lesserThan(Value)
        case equal(Value)
        case between(ClosedRange<Value>)
    }
}

extension MathCompare.Compare {
    var args: String {
        switch self {
        case let .greaterThan(value):
            return "> \(value)"
        case let .lesserThan(value):
            return "< \(value)"
        case let .equal(value):
            return "== \(value)"
        case let .between(value):
            return "BETWEEN { \(value.lowerBound), \(value.upperBound) }"
        }
    }
}

extension MathCompare: Comparing {
    var fun: String {
        switch self {
        case .count: return "@count"
        case .average: return "@avg"
        case .sum: return "@sum"
        case .max: return "@max"
        case .min: return "@min"
        }
    }
    
    var args: String {
        switch self {
        case .count(let comp): return comp.args
        case .average(let comp): return comp.args
        case .sum(let comp): return comp.args
        case .max(let comp): return comp.args
        case .min(let comp): return comp.args
        }
    }
    
    func predicate(expression: String) -> NSPredicate {
        let fun = self.fun
        let args = self.args
        return NSPredicate(format: "\(fun).\(expression) \(args)")
    }
}
