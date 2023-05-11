import Foundation

public enum StringOption: String, CaseIterable, Codable {
    /// e.g: "NeXT[c]" == "next" is true
    case caseInsensitive = "c"
    /// e.g: "naïve[d]" == "naive" is true
    case diacreticInsensitive = "d"
    /// e.g "straße[l]" == "strasse" is true
    case localeInsensitive = "l"

    public static var all: [StringOption] = StringOption.allCases
}

enum Comparison<Value> {
    case anyIs(Value, [StringOption] = [])
    case `is`(Value, [StringOption] = [])
    case isNot(Value, [StringOption] = [])
    /// Equivalent to an SQL IN operation,
    ///  the left-hand side must appear in the collection specified by the right-hand side.
    ///  For example, name IN { 'Ben', 'Melissa', 'Nick' }
    case `in`([Value], [StringOption] = [])
    case between((Value, Value))
    case contains(Value, [StringOption] = [])
    case endsWith(Value, [StringOption] = [])
    case beginsWith(Value, [StringOption] = [])
    case greaterThan(Value)
    case lesserThan(Value)
    case equal(Value, [StringOption] = [])
}

extension Comparison: Comparing {
    func predicate(expression: String) -> NSPredicate {
        switch self {
        case let .anyIs(value, options):
            return .init(format: "ANY \(expression) =\(options.evaluation) %@",
                         value: value)
        case let .is(value, options),
            let .equal(value, options):
            return .init(format: "\(expression) =\(options.evaluation) %@",
                         value: value)
        case let .isNot(value, options):
            return .init(format: "\(expression) !=\(options.evaluation) %@",
                         value: value)
        case let .in(value, options):
            return .init(format: "\(expression) IN\(options.evaluation) %@",
                         value: [value])
        case let .between(value):
            return .init(format: "\(expression) BETWEEN { %@, %@ }",
                         value: [value.0, value.1])
        case let .contains(value, options):
            return .init(format: "\(expression) CONTAINS\(options.evaluation) %@",
                         value: value)
        case let .beginsWith(value, options):
            return .init(format: "\(expression) BEGINSWITH\(options.evaluation) %@",
                         value: value)
        case let .endsWith(value, options):
            return .init(format: "\(expression) ENDSWITH\(options.evaluation) %@",
                         value: value)
        case let .greaterThan(value):
            return .init(format: "\(expression) > %@",
                         value: value)
        case let .lesserThan(value):
            return .init(format: "\(expression) < %@",
                         value: value)
        }
    }
}

extension Array where Element == StringOption {
    var evaluation: String {
        guard !self.isEmpty else { return "" }
        let options = self.reduce("") { $0 + $1.rawValue }
        return "[\(options)]"
    }
}
