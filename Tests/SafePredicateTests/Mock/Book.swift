import Foundation

@objc
enum BookState: Int16 {
    case unopen
    case read
}

class Chapter: NSObject {
    @objc var uuid: String = UUID().uuidString
    @objc var title: String
    @objc var wordCount: Int
    @objc var reviews: Set<Review> = .init()

    init(title: String, wordCount: Int = 100_000) {
        self.title = title
        self.wordCount = wordCount
    }
}

class Review: NSObject {
    @objc let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
}

class Book: NSObject {
    @objc var title: String
    @objc var author: String
    @objc var wordCount: Int
    @objc var readingTime: TimeInterval
    @objc var id: UUID = UUID()
    @objc var state: BookState = .unopen
    @objc var chapters: [Chapter] = []
    @objc var reviews: Set<Review> = .init()
    
    @objc var nextInSeries: Book?
    
    init(title: String, author: String, wordCount: Int, readingTime: TimeInterval) {
        self.title = title
        self.author = author
        self.wordCount = wordCount
        self.readingTime = readingTime
    }
    
    static func ==(lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id
    }
}
