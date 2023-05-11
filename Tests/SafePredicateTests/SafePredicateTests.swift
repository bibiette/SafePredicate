import XCTest
import SafePredicate

final class SafePredicateTests: XCTestCase {
    let philosopherStone = Book(
        title: "Harry Potter and the Philosopher's Stone",
        author: "J.K Rowling",
        wordCount: 76944,
        readingTime: 3.hours
    )
    let chamberOfSecrets = Book(
        title: "Harry Potter and the Chamber of Secrets",
        author: "J.K Rowling",
        wordCount: 85141,
        readingTime: 3.5.hours
    )
    let prisonerOfAzkaban = Book(
        title: "Harry Potter and the Prisoner of Azkaban",
        author: "J.K Rowling",
        wordCount: 107253,
        readingTime: 4.hours
    )
    let vingtMilleLieuesSousLesMers = Book(
        title: "20 mille lieues sous les mers",
        author: "Jules Verne",
        wordCount: 138138,
        readingTime: 20.hours
    )
    
    private var books: [Book]!
    
    override func setUpWithError() throws {
        philosopherStone.nextInSeries = chamberOfSecrets
        chamberOfSecrets.nextInSeries = prisonerOfAzkaban
        
        books = [philosopherStone,
                 chamberOfSecrets,
                 prisonerOfAzkaban,
                 vingtMilleLieuesSousLesMers]
    }
    
    func test_average() {
        philosopherStone.reviews = Set([Review(3),
                                        Review(4),
                                        Review(5),
                                        Review(4),
                                        Review(4),
                                        Review(5)])
        
        chamberOfSecrets.reviews = Set([Review(3),
                                        Review(4),
                                        Review(5),
                                        Review(4),
                                        Review(4),
                                        Review(5)])
        
        let results = books.where(.math(\Book.reviews, \.value, .average(.between(4...5))))

        XCTAssertEqual(results.count, 2)
    }
    
    func test_any_average() {
        philosopherStone.chapters = [
            .init(title: "The cupboard under the stairs")
            ]
        philosopherStone.reviews = Set([Review(3),
                                        Review(4),
                                        Review(5),
                                        Review(4),
                                        Review(4),
                                        Review(5)])
        
        chamberOfSecrets.reviews = Set([Review(1),
                                        Review(2),
                                        Review(3),
                                        Review(1),
                                        Review(5),
                                        Review(0)])
        
        
        let results = books.where(.any(\Book.chapters, \.title == "The cupboard under the stairs")
                                  && .math(\Book.reviews, \.value, .average(.greaterThan(4))))
        
        XCTAssertEqual(results.count, 1)
    }
    
    func test_any_subquery() {
        philosopherStone.chapters = [
            .init(title: "The cupboard under the stairs"),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        chamberOfSecrets.chapters = [
            .init(title: "The cupboard under the stairs", wordCount: 200_000),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        prisonerOfAzkaban.chapters = [
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        let results = books.where(.any(\Book.chapters,
                                        \.title == "The cupboard under the stairs")
                                  && \Book.author == "J.K Rowling")
        XCTAssertEqual(results.count, 2)
    }
    
    func test_none_subquery() {
        philosopherStone.chapters = [
            .init(title: "The cupboard under the stairs"),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        chamberOfSecrets.chapters = [
            .init(title: "The cupboard under the stairs", wordCount: 200_000),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        prisonerOfAzkaban.chapters = [
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        let results = books.where(.no(\Book.chapters,
                                       \.title == "The cupboard under the stairs")
                                  && \Book.author == "J.K Rowling")
        XCTAssertEqual(results.count, 1)
    }
    
    func test_all_subquery() {
        philosopherStone.chapters = [
            .init(title: "The cupboard under the stairs"),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        chamberOfSecrets.chapters = [
            .init(title: "The cupboard under the stairs", wordCount: 200_000),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        prisonerOfAzkaban.chapters = [
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        let results = books.where(.all(\Book.chapters,
                                        \.title == "The cupboard under the stairs")
                                  && \Book.author == "J.K Rowling")
        XCTAssertEqual(results.count, 0)
    }
    
    func test_and_subquery() {
        philosopherStone.chapters = [
            .init(title: "The cupboard under the stairs"),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        chamberOfSecrets.chapters = [
            .init(title: "The cupboard under the stairs", wordCount: 200_000),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        prisonerOfAzkaban.chapters = [
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        let results = books.where(.any(\Book.chapters,
                                        \.title == "The cupboard under the stairs" && \.wordCount > 100_000
                                      )
                                  && \Book.author == "J.K Rowling"
        )
        XCTAssertEqual(results.count, 1)
    }
    
    func test_any_chapter_title() {
        philosopherStone.chapters = [
            .init(title: "The cupboard under the stairs"),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        chamberOfSecrets.chapters = [
            .init(title: "The cupboard under the stairs"),
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        prisonerOfAzkaban.chapters = [
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        let results = books.where(.any(\Book.chapters,
                                        \.title == "The cupboard under the stairs"))
        XCTAssertEqual(results.count, 2)
    }
    
    func test_uuid_subquery() {
        let underTheStairs = Chapter(title: "The cupboard under the stairs")
        philosopherStone.chapters = [
            underTheStairs,
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        chamberOfSecrets.chapters = [
            underTheStairs,
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        prisonerOfAzkaban.chapters = [
            .init(title: "Hogwarts"),
            .init(title: "Azkaban")
        ]
        let uuid = underTheStairs.uuid
        let results = books.where(.any(\Book.chapters, \.uuid == uuid)
                                  && \Book.author == "J.K Rowling")
        XCTAssertEqual(results.count, 2)
    }
    
    func test_uuid_book() {
        let results = books.where(\Book.id == chamberOfSecrets.id)
        XCTAssertEqual(results.count, 1)
    }
    
    func test_next_book() {
        let results = books.where(\Book.nextInSeries == chamberOfSecrets)
        XCTAssertEqual(results.count, 1)
    }
    
    func test_enum() {
        let readBook = Book(title: "A title", author: "An Author", wordCount: 10, readingTime: 3.seconds)
        readBook.state = .read
        books.append(readBook)
        XCTAssertEqual(books.where(\Book.state == .read).count, 1)
    }
    
    func test_multiple() {
        let ids = books.map { $0.id }
        XCTAssertEqual(books.where(\Book.id ~= ids).count, 4)
        
        let newIds = [philosopherStone.id, chamberOfSecrets.id]
        let results = books.where(\Book.id ~= newIds)
        XCTAssertTrue(results.oneSatisfy { $0.id == philosopherStone.id })
        XCTAssertTrue(results.oneSatisfy { $0.id == chamberOfSecrets.id })
        XCTAssertEqual(results.count, 2)
    }
    
    // MARK: - Test Number
    func test_lower_than() {
        let results = books.where(\Book.readingTime < 10.hours)
        XCTAssertFalse(results.oneSatisfy { $0.id == vingtMilleLieuesSousLesMers.id })
        XCTAssertEqual(results.count, 3)
    }
    
    func test_greater_than() {
        let results = books.where(\Book.readingTime > 10.hours)
        XCTAssertTrue(results.oneSatisfy { $0.id == vingtMilleLieuesSousLesMers.id })
        XCTAssertEqual(results.count, 1)
    }
    
    func test_in_range() {
        let results = books.where(\Book.readingTime ~= 3.hours...3.7.hours)
        XCTAssertFalse(results.oneSatisfy { $0.id == prisonerOfAzkaban.id })
        XCTAssertFalse(results.oneSatisfy { $0.id == vingtMilleLieuesSousLesMers.id })
        XCTAssertEqual(results.count, 2)
    }
    
    func test_not_equal() {
        let results = books.where(\Book.readingTime != 3.hours)
        XCTAssertFalse(results.oneSatisfy { $0.id == philosopherStone.id })
        XCTAssertEqual(results.count, 3)
    }
    
    func test_equal() {
        let results = books.where(\Book.readingTime == 3.5.hours)
        XCTAssertTrue(results.oneSatisfy { $0.id == chamberOfSecrets.id })
        XCTAssertEqual(results.count, 1)
    }
    
    // MARL: - Test String
    func test_string_equal() {
        let value = philosopherStone.title
        let results = books.where(\Book.title == value)
        XCTAssertTrue(results.oneSatisfy { $0.id == philosopherStone.id })
        XCTAssertEqual(results.count, 1)
    }
    
    func test_string_equal_wt_options() {
        let value = "haRry potTeR aNd the phïLOSOpher's Stone"
        let results = books.where(\Book.title == (value: value,
                                                  options: [.diacreticInsensitive, .caseInsensitive]))
        
        XCTAssertTrue(results.oneSatisfy { $0.id == philosopherStone.id })
        XCTAssertEqual(results.count, 1)
    }
    
    func test_string_not_equal() {
        let value = philosopherStone.title
        let results = books.where(\Book.title != value)
        
        XCTAssertFalse(results.oneSatisfy { $0.id == philosopherStone.id })
        XCTAssertEqual(results.count, 3)
    }
    
    func testStringNotEqual_WithOptions() {
        let value: String = "haRry potTeR aNd the phïLOSOpher's Stone"
        
        let results = books.where(\Book.title != (value, [.diacreticInsensitive, .caseInsensitive]))
        
        XCTAssertFalse(results.oneSatisfy { $0.id == philosopherStone.id })
        XCTAssertEqual(results.count, 3)
    }
    
    func testStringBegins() {
        let value = "Harry Potter"
        let results = books.where(\Book.title ==* value)
        XCTAssertFalse(results.oneSatisfy { $0.id == vingtMilleLieuesSousLesMers.id })
        XCTAssertEqual(results.count, 3)
    }
    
    func testStringBegins_WithOptions() {
        let value = "HaRRy Pôtter"
        let results = books.where(\Book.title ==* (value, [.diacreticInsensitive, .caseInsensitive]))
        
        XCTAssertFalse(results.oneSatisfy { $0.id == vingtMilleLieuesSousLesMers.id })
        XCTAssertEqual(results.count, 3)
    }
    
    func testStringEnds() {
        let value = "Secrets"
        let results = books.where(\Book.title *== value)
        XCTAssertTrue(results.oneSatisfy { $0.id == chamberOfSecrets.id })
        XCTAssertEqual(results.count, 1)
    }
    
    func testStringEnds_WithOptions() {
        let value = "secréTs"
        let results = books.where(\Book.title *== (value, [.diacreticInsensitive, .caseInsensitive]))
        
        XCTAssertTrue(results.oneSatisfy { $0.id == chamberOfSecrets.id })
        XCTAssertEqual(results.count, 1)
    }
    
    func testStringContains() {
        let value = "of"
        let results = books.where(\Book.title ~= value)
        XCTAssertTrue(results.oneSatisfy { $0.id == chamberOfSecrets.id })
        XCTAssertTrue(results.oneSatisfy { $0.id == prisonerOfAzkaban.id })
        XCTAssertEqual(results.count, 2)
    }
    
    func testStringContains_WithOptions() {
        let value = "ôF"
        let results = books.where(\Book.title ~= (value, [.diacreticInsensitive, .caseInsensitive]))
        
        XCTAssertTrue(results.oneSatisfy { $0.id == chamberOfSecrets.id })
        XCTAssertTrue(results.oneSatisfy { $0.id == prisonerOfAzkaban.id })
        XCTAssertEqual(results.count, 2)
    }
}
