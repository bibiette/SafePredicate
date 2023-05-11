import Foundation

public struct PartialPair<Root> {
    let predicate: NSPredicate
    let expression: String
    
    init<Value>(keyPath: KeyPath<Root, Value>, compare: Comparison<Value>) {
        self.expression = "\(keyPath.expression)"
        self.predicate = compare.predicate(expression: expression)
    }
    
    init<Value>(expression: String, compare: Comparison<Value>) {
        self.expression = expression
        self.predicate = compare.predicate(expression: expression)
    }
    
    init<Value: Numeric>(keyPath: KeyPath<Root, Value>, math: MathCompare<Value>) {
        self.expression = "\(keyPath.expression)"
        self.predicate = math.predicate(expression: expression)
    }

    static func math<Value: Numeric & Comparable>(_ lhs: KeyPath<Root, Value>, _ math: MathCompare<Value>)
    -> PartialPair<Root> {
        .init(keyPath: lhs, math: math)
    }
    
    public
    static func &&(lhs: PartialPair<Root>, rhs: PartialPair<Root>) -> Group<Root> {
        .and([lhs, rhs])
    }
    
    public
    static func ||(lhs: PartialPair<Root>, rhs: PartialPair<Root>) -> Group<Root> {
        .or([lhs, rhs])
    }
}

public
enum Group<Root> {
    case and([PartialPair<Root>])
    case or([PartialPair<Root>])
}

protocol Grouping {
    associatedtype Root
}

extension Group: Grouping {
    var pairs: [PartialPair<Root>] {
        switch self {
        case let .and(pairs), let .or(pairs):
            return pairs
        }
    }
    
    func subquery(_ arg: String) -> String {
        func subquery(pair: PartialPair<Root>) -> String {
            "\(arg).\(pair.predicate)"
        }
        
        switch self {
        case let .and(pairs):
            return pairs.map { subquery(pair: $0) }.joined(separator: " AND ")
        case let .or(pairs):
            return pairs.map { subquery(pair: $0) }.joined(separator: " OR ")
        }
    }
    
    var predicateFormat: String {
        func format() -> String {
            switch self {
            case let .and(pairs):
                return pairs.map { $0.predicate.predicateFormat }.joined(separator: " AND ")
            case let .or(pairs):
                return pairs.map { $0.predicate.predicateFormat }.joined(separator: " OR ")
            }
        }
        return "(\(format())"
    }
}
