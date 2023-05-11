import Foundation

public extension NSPredicate {
    static var falsePredicate: NSPredicate { .init(format: "FALSEPREDICATE") }
    static var truePredicate: NSPredicate { .init(format: "TRUEPREDICATE") }
    
    static func &&(lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
        .init(format: "(\(lhs.predicateFormat && rhs.predicateFormat))" )
    }
    
    static func ||(lhs: NSPredicate, rhs: NSPredicate) -> NSPredicate {
        .init(format: "(\(lhs.predicateFormat || rhs.predicateFormat))" )
    }
    
    // MARK: - Maths
    static func math<Root, Value: Sequence, Sub: Numeric & Comparable>(
        _ lhs: KeyPath<Root, Value>,
        _ rhs: KeyPath<Value.Element, Sub>,
        _ math: MathCompare<Sub>
    ) -> NSPredicate {
        let exp = PartialPair(keyPath: rhs, math: math)
        let predicate = NSPredicate(format: "\(lhs.expression).\(exp.predicate.predicateFormat)")
        return predicate
    }
    
    // MARK: - Queries
    static func and<Root>(_ pairs: PartialPair<Root>...) -> NSPredicate {
        .init(format: Group.and(pairs).predicateFormat)
    }
    
    static func or<Root>(_ pairs: PartialPair<Root>...) -> NSPredicate {
        .init(format: Group.or(pairs).predicateFormat)
    }
    
    // MARK: - Subqueries
    static func `any`<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        _ pair: PartialPair<Value.Element>
    ) -> NSPredicate {
        Subquery(.any(keyPath), pair)
    }
    
    static func `any`<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        and pairs: PartialPair<Value.Element>...
    ) -> NSPredicate {
        Subquery(.any(keyPath), group: .and(pairs))
    }
    
    static func `any`<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        or pairs: PartialPair<Value.Element>...
    ) -> NSPredicate {
        Subquery(.any(keyPath), group: .or(pairs))
    }
    
    static func `any`<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        _ group: Group<Value.Element>
    ) -> NSPredicate {
        Subquery(.any(keyPath), group: group)
    }
    
    static func no<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        _ pair: PartialPair<Value.Element>
    ) -> NSPredicate {
        Subquery(.none(keyPath), pair)
    }
    
    static func no<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        _ group: Group<Value.Element>
    ) -> NSPredicate {
        Subquery(.none(keyPath), group: group)
    }
    
    static func all<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        _ pair: PartialPair<Value.Element>
    ) -> NSPredicate {
        Subquery(.all(keyPath), pair)
    }
    
    static func all<Root, Value: Sequence>(
        _ keyPath: KeyPath<Root, Value>,
        _ group: Group<Value.Element>
    ) -> NSPredicate {
        Subquery(.all(keyPath), group: group)
    }
}

extension NSPredicate {    
    convenience init<Value>(format: String, value: Value) {
        switch value {
        case let arguments as Array<Any>:
            self.init(format: format, argumentArray: arguments)
        case let arguments as any RawRepresentable:
            self.init(format: format, argumentArray: [arguments.rawValue])
        default:
            self.init(format: format, argumentArray: [value])
        }
    }
}

extension String {
    static func &&(lhs: String, rhs: String) -> String {
        if lhs.isEmpty { return rhs }
        if rhs.isEmpty { return lhs }
        return "\(lhs) AND \(rhs)"
    }
    
    static func ||(lhs: String, rhs: String) -> String {
        if lhs.isEmpty { return rhs }
        if rhs.isEmpty { return lhs }
        return "\(lhs) OR \(rhs)"
    }
}
