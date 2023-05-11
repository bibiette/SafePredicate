import Foundation

public
class Subquery<Root, Value: Sequence>: NSPredicate {
    public enum Category {
        case any(KeyPath<Root, Value>)
        case all(KeyPath<Root, Value>)
        case none(KeyPath<Root, Value>)
        
        var expression: NSExpression {
            switch self {
            case let .any(keyPath),
                let .all(keyPath),
                let .none(keyPath):
                return keyPath.expression
            }
        }
        var format: String {
            switch self {
            case .any: return "@count > 0"
            case let .all(keyPath): return "@count == \(keyPath.expression).@count"
            case .none: return "@count == 0"
            }
        }
    }
    
    /// Subquery(.any(\Book.chapters), \.title == "")
    internal
    convenience init(_ category: Category,
                    _ lhs: PartialPair<Value.Element>) {
        self.init(
            format: "SUBQUERY(\(category.expression), $a, $a.\(lhs.predicate)).\(category.format)"
        )
    }
    
    /// Subquery(.any(\Book.chapters), .and([\.title == "" ...]))
    internal
    convenience init(_ category: Category,
                     group: Group<Value.Element>) {
        self.init(
            format: "SUBQUERY(\(category.expression), $a, \(group.subquery("$a"))).\(category.format)"
        )
    }
}

public extension KeyPath {    
    static func ==(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .is(rhs))
    }
    
    static func ==(_ lhs: KeyPath<Root, String>,
                   _ rhs: (value: String, options: [StringOption])) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .is(rhs.value, rhs.options))
    }
    
    static func ==(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> where Value: RawRepresentable {
        .init(keyPath: lhs, compare: .is(rhs))
    }
    
    static func !=(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .isNot(rhs))
    }
    
    static func !=(_ lhs: KeyPath<Root, String>, _ rhs: (value: String, options: [StringOption])) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .isNot(rhs.value, rhs.options))
    }
    
    static func !=(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> where Value: RawRepresentable {
        .init(keyPath: lhs, compare: .isNot(rhs))
    }
    
    
    /// The value for KeyPath begins with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to
    /// - Returns: TypedPredicate
    static func ==*(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .beginsWith(rhs))
    }
    
    /// The value for KeyPath begins with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to, can define option such as case insensitive, diacritic insensitive etc
    /// - Returns: TypedPredicate
    static func ==*(_ lhs: KeyPath<Root, Value>, _ rhs: (value: Value, options: [StringOption]))
    -> PartialPair<Root> where Value == String {
        .init(keyPath: lhs, compare: .beginsWith(rhs.value, rhs.options))
    }
    
    /// The value for KeyPath ends with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to
    /// - Returns: TypedPredicate
    static func *==(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .endsWith(rhs))
    }
    
    /// The value for KeyPath ends with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to, can define option such as case insensitive, diacritic insensitive etc
    /// - Returns: TypedPredicate
    static func *==(_ lhs: KeyPath<Root, Value>, _ rhs: (value: Value, options: [StringOption]))
    -> PartialPair<Root> where Value == String {
        .init(keyPath: lhs, compare: .endsWith(rhs.value, rhs.options))
        
    }
    
    static func >(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .greaterThan(rhs))
        
    }
    
    static func <(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .lesserThan(rhs))
    }
    
    static func ~=(_ rhs: KeyPath<Root, Value>, _ lhs: ClosedRange<Value>) -> PartialPair<Root> where Value: Comparable {
        .init(keyPath: rhs, compare: .between((lhs.lowerBound, lhs.upperBound)))
    }
    
    static func ~=(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> PartialPair<Root> where Value == String {
        .init(keyPath: lhs, compare: .contains(rhs))
    }
    
    static func ~=(_ lhs: KeyPath<Root, Value>, _ rhs: (value: Value, options: [StringOption]))
    -> PartialPair<Root> where Value == String {
        .init(keyPath: lhs, compare: .contains(rhs.value, rhs.options))
    }
    
    static func ~=(_ lhs: KeyPath<Root, Value>, _ rhs: [Value]) -> PartialPair<Root> {
        .init(keyPath: lhs, compare: .in(rhs))
    }
}
