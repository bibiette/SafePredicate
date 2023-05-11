import Foundation

extension KeyPath {
    var expression: NSExpression {
        \Root.self == self ?
            NSExpression.expressionForEvaluatedObject() :
            NSExpression(forKeyPath: self)
    }
}

/// begins with
infix operator ==* : ComparisonPrecedence
/// ends with
infix operator *== : ComparisonPrecedence

public extension KeyPath {
    static func ==(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .is(rhs)).predicate
    }
    
    static func ==(_ lhs: KeyPath<Root, String>,
                   _ rhs: (value: String, options: [StringOption])) -> NSPredicate where Value == String {
        PartialPair(keyPath: lhs, compare: .is(rhs.value, rhs.options)).predicate
    }
    
    static func ==(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate where Value: RawRepresentable {
        PartialPair(keyPath: lhs, compare: .is(rhs)).predicate
    }
    
    static func !=(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .isNot(rhs)).predicate
    }
    
    static func !=(_ lhs: KeyPath<Root, String>,
                   _ rhs: (value: String, options: [StringOption])) -> NSPredicate where Value == String {
        PartialPair(keyPath: lhs, compare: .isNot(rhs.value, rhs.options)).predicate
    }
    
    static func !=(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate where Value: RawRepresentable {
        PartialPair(keyPath: lhs, compare: .isNot(rhs)).predicate
    }
    
    
    /// The value for KeyPath begins with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to
    /// - Returns: TypedPredicate
    static func ==*(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .beginsWith(rhs)).predicate
    }
    
    /// The value for KeyPath begins with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to, can define option such as case insensitive, diacritic insensitive etc
    /// - Returns: TypedPredicate
    static func ==*(_ lhs: KeyPath<Root, Value>, _ rhs: (value: Value, options: [StringOption]))
    -> NSPredicate where Value == String {
        PartialPair(keyPath: lhs, compare: .beginsWith(rhs.value, rhs.options)).predicate
    }
    
    /// The value for KeyPath ends with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to
    /// - Returns: TypedPredicate
    static func *==(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .endsWith(rhs)).predicate
    }
    
    /// The value for KeyPath ends with the String value
    /// - Parameters:
    ///   - lhs: The KeyPath to compare the value to
    ///   - rhs: String value to compare the entity keypath to, can define option such as case insensitive, diacritic insensitive etc
    /// - Returns: TypedPredicate
    static func *==(_ lhs: KeyPath<Root, Value>, _ rhs: (value: Value, options: [StringOption]))
    -> NSPredicate where Value == String {
        PartialPair(keyPath: lhs, compare: .endsWith(rhs.value, rhs.options)).predicate
        
    }
    
    static func >(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .greaterThan(rhs)).predicate
        
    }
    
    static func <(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .lesserThan(rhs)).predicate
    }
    
    static func ~=(_ rhs: KeyPath<Root, Value>, _ lhs: ClosedRange<Value>) -> NSPredicate where Value: Comparable {
        PartialPair(keyPath: rhs, compare: .between((lhs.lowerBound, lhs.upperBound))).predicate
    }
    
    static func ~=(_ lhs: KeyPath<Root, Value>, _ rhs: Value) -> NSPredicate where Value == String {
        PartialPair(keyPath: lhs, compare: .contains(rhs)).predicate
    }
    
    static func ~=(_ lhs: KeyPath<Root, Value>, _ rhs: (value: Value, options: [StringOption]))
    -> NSPredicate where Value == String {
        PartialPair(keyPath: lhs, compare: .contains(rhs.value, rhs.options)).predicate
    }
    
    static func ~=(_ lhs: KeyPath<Root, Value>, _ rhs: [Value]) -> NSPredicate {
        PartialPair(keyPath: lhs, compare: .in(rhs)).predicate
    }
}
