import Foundation

public extension Array {    
    /// Filter the array with predicate passed as parameters
    ///
    /// The key being looked up must be of type `@objc`, or the method will cause a crash
    ///
    /// Usage:
    ///  ```
    /// class Book: NSObject {
    ///     @objc var title: String
    ///     @objc var wordCount: Int
    ///     @objc var readingTime: TimeInterval
    ///     @objc var author: String
    ///     @objc var id: String = UUID().uuidString
    ///
    ///     init() { ... }
    /// }
    ///
    /// let books: [Book] = [...]
    ///
    /// let shortBooks = books.where(\Book.wordCount < 10000 || \Book.readingTime < 3.hours)
    /// ```
    /// - Returns: Returns an array which element satisfy the predicate passed as parameters
    func `where`(_ predicate: NSPredicate) -> [Element] {
        return NSArray(array: self).filtered(using: predicate) as! [Element]
    }
    
    func oneSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        for element in self { if try predicate(element) { return true } }
        return false
    }
}
