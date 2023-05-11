import Foundation

public extension TimeInterval {
    /// The interval between now and 00:00:00 UTC on 1 January 1970.
    static var since1970: TimeInterval {
        Date().timeIntervalSince1970
    }

    internal static let secondsInOneMinute: TimeInterval = 60 // There is 60 seconds in one minute
    internal static let secondsInOneHour: TimeInterval = 3600 // There is 60 minutes in one hour
 
    var seconds: TimeInterval { return self }
    var minutes: TimeInterval { return self * .secondsInOneMinute }
    var hours: TimeInterval { return self * .secondsInOneHour }

//    /// The interval between now and 00:00:00 UTC on 1 January 1970. - the interval
//    ///
//    /// e.g:
//    ///  30.days.ago would be the interval between 30 days ago and 00:00:00 UTC on 1 January 1970
//    var ago: TimeInterval {
//        .since1970 - self
//    }
//
//    /// The interval between now and 00:00:00 UTC on 1 January 1970. - the interval
//    ///
//    /// e.g:
//    ///  30.days.later would be the interval between 30 days later and 00:00:00 UTC on 1 January 1970
//    var later: TimeInterval {
//        .since1970 + self
//    }
}

public extension Int {
    var seconds: TimeInterval { TimeInterval(self).seconds }
    var minutes: TimeInterval { TimeInterval(self).minutes }
    var hours: TimeInterval { TimeInterval(self).hours }
}
