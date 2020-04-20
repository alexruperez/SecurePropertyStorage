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

protocol MockableProtocol {}

class MockInstance: MockableProtocol, Mock {}

class RealInstance: MockableProtocol {}

protocol InstanceProtocol {
    var timestamp: TimeInterval { get }
}

class InstanceDependency: InstanceProtocol, Equatable {
    let timestamp: TimeInterval

    init(_ timestamp: TimeInterval) {
        self.timestamp = timestamp
    }

    static func == (lhs: InstanceDependency, rhs: InstanceDependency) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
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
    @Register
    private var registerMock: MockableProtocol = MockInstance()
    @Register
    private var registerReal: MockableProtocol = RealInstance()
    @Register
    private var registerBuilder = {
        InstanceDependency(Date().timeIntervalSince1970) as InstanceProtocol
    }

    @Register
    private var registerBuilderWith = { parameters in
        InstanceDependency(parameters) as InstanceProtocol
    }

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
    @Inject
    var sharedInstance: InstanceProtocol?
    @UnwrappedInject
    var unwrappedSharedInstance: InstanceProtocol
    @Inject(.instance)
    var instance: InstanceProtocol?
    @UnwrappedInject(.instance)
    var unwrappedInstance: InstanceProtocol
    @Inject
    var mock: MockableProtocol?
    @InjectWith(Date().timeIntervalSince1970)
    var instanceWith: InstanceProtocol?
    @UnwrappedInjectWith(Date().timeIntervalSince1970)
    var unwrappedInstanceWith: InstanceProtocol
    var injectDependency: Dependency? { inject as? Dependency }
    var unwrappedDependency: Dependency? { unwrappedInject as? Dependency }
    var injectSharedInstance: InstanceDependency? { sharedInstance as? InstanceDependency }
    var injectUnwrappedSharedInstance: InstanceDependency? { unwrappedSharedInstance as? InstanceDependency }
    var injectInstance: InstanceDependency? { instance as? InstanceDependency }
    var injectUnwrappedInstance: InstanceDependency? { unwrappedInstance as? InstanceDependency }
    var injectInstanceWith: InstanceDependency? { instanceWith as? InstanceDependency }
    var injectUnwrappedInstanceWith: InstanceDependency? { unwrappedInstanceWith as? InstanceDependency }

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
        XCTAssertNotNil(sharedInstance)
        XCTAssertEqual(injectSharedInstance, injectUnwrappedSharedInstance)
        XCTAssertNotNil(instance)
        XCTAssertNotEqual(injectInstance, injectUnwrappedInstance)
        XCTAssertNotNil(instanceWith)
        XCTAssertNotEqual(injectInstanceWith, injectUnwrappedInstanceWith)
        XCTAssert(mock is MockInstance)

        let dependencyPropertyWrapper = InjectPropertyWrapper<DependencyProtocol, Void>([])
        XCTAssertThrowsError(try dependencyPropertyWrapper.resolve())

        let stringPropertyWrapper = InjectPropertyWrapper<String, Void>([])
        XCTAssertThrowsError(try stringPropertyWrapper.resolve())

        XCTAssert(stringPropertyWrapper
            .description(InjectError.notFound(String.self))
            .contains("String"))
        XCTAssert(stringPropertyWrapper
            .description(InjectError.moreThanOne(String.self))
            .contains("String"))
        XCTAssert(stringPropertyWrapper
            .description(CocoaError(.userCancelled))
            .contains("cancel"))
    }

    static var allTests = [
        ("testInject", testInject)
    ]
}
