@testable import Inject
import XCTest

protocol SubDependencyProtocol {}

class SubDependency: SubDependencyProtocol, Equatable {
    let timestamp = Date().timeIntervalSince1970

    static func == (lhs: SubDependency, rhs: SubDependency) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}

@objc protocol DependencyQualifier {}

@objc protocol AlternativeQualifier {}

protocol DependencyProtocol {
    var timestamp: TimeInterval { get }
}

class Dependency: DependencyProtocol, Equatable, DependencyQualifier {
    let timestamp = Date().timeIntervalSince1970
    @Inject
    var sub: SubDependencyProtocol?
    @Inject
    var subClass: SubDependency?
    var subDependency: SubDependency? { sub as? SubDependency }

    static func == (lhs: Dependency, rhs: Dependency) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}

class AlternativeDependency: DependencyProtocol, AlternativeQualifier {
    let timestamp = Date().timeIntervalSince1970
}

final class InjectTests: XCTestCase {
    @Register
    private var register: DependencyProtocol = Dependency()
    @Register
    private var registerAlternative: DependencyProtocol = AlternativeDependency()
    @Register
    private var registerClass = Dependency()
    @Register
    private var registerSub: SubDependencyProtocol = SubDependency()
    @Register
    private var registerSubClass = SubDependency()
    @Inject(DependencyQualifier.self)
    var inject: DependencyProtocol?
    @Inject(AlternativeQualifier.self)
    var alternative: DependencyProtocol?
    @Inject
    var injectClass: Dependency?
    @UnwrappedInject(DependencyQualifier.self)
    var unwrappedInject: DependencyProtocol
    @UnwrappedInject
    var unwrappedClass: Dependency
    var injectDependency: Dependency? { inject as? Dependency }
    var unwrappedDependency: Dependency? { unwrappedInject as? Dependency }

    func testInject() {
        XCTAssertNotNil(inject)
        XCTAssertNotNil(alternative)
        XCTAssertNotNil(injectClass)
        XCTAssertNotNil(injectClass?.sub)
        XCTAssertNotNil(injectClass?.subClass)
        XCTAssertNotEqual(injectClass?.subDependency, injectClass?.subClass)
        XCTAssertNotNil(unwrappedInject)
        XCTAssertNotNil(unwrappedClass)
        XCTAssertEqual(injectDependency, unwrappedDependency)
        XCTAssertEqual(registerClass, injectClass)
        XCTAssertEqual(injectClass, unwrappedClass)

        let test = ""
        XCTAssert(InjectError.notFound(type(of: test)).description.contains("String"))
        XCTAssert(InjectError.moreThanOne(type(of: test)).description.contains("String"))

        XCTAssertThrowsError(try InjectPropertyWrapper([]).resolve() as String)

        XCTAssertThrowsError(try InjectPropertyWrapper([]).resolve() as DependencyProtocol)
    }

    static var allTests = [
        ("testInject", testInject)
    ]
}
