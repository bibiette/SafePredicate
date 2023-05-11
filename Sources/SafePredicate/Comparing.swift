import Foundation

protocol Comparing {
    associatedtype Value
    
    func predicate(expression: String) -> NSPredicate
}
