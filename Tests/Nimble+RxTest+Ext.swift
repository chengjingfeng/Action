import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

/// `Foundation`

extension Optional {
    func asString() -> String {
        guard let s = self else { return "nil" }
        return String(describing: s)
    }
}

/// `RxSwift`

extension Event {
    var isError: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }
}

/// Nimble

extension PredicateResult {
    static var evaluationFailed: PredicateResult {
        return PredicateResult(status: .doesNotMatch,
                               message: .fail("failed to evaluate given expression"))
    }
    
    static func isEqual<T: Equatable>(actual: T?, expected: T?) -> PredicateResult {
        return PredicateResult(bool: actual == expected,
                               message: .expectedCustomValueTo("get <\(expected.asString())>", "<\(actual.asString())>"))
    }
}

public func match<T: Equatable>(_ expected: T) -> Predicate<T> {
    return Predicate { events in
        
        guard let source = try events.evaluate() else {
            return PredicateResult.evaluationFailed
        }
        guard source == expected else {
            return PredicateResult(status: .doesNotMatch, message: .expectedCustomValueTo("get <\(expected)> events", "<\(source)> events"))
        }
        
        
        return PredicateResult(bool: true, message: .fail("matched values and timeline as expected"))
    }
}