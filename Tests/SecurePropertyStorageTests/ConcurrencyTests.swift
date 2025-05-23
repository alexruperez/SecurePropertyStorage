@testable import Inject
@testable import Keychain
@testable import Singleton
@testable import Storage
@testable import UserDefault
import XCTest

final class ConcurrencyTests: XCTestCase, @unchecked Sendable {
    protocol ConcurrentInjectable: Sendable {}

    final class MyConcurrentService: ConcurrentInjectable, Sendable {
        let uniqueID: String
        init(_ identifier: String = UUID().uuidString) { uniqueID = identifier }
    }

    func testConcurrentRegistrationAndResolutionInject() async {
        let taskCount = 20
        let groupKey = "testConcurrentGroup-\(UUID().uuidString)"

        await withTaskGroup(of: Void.self) { taskGroup in
            for task in 0 ..< taskCount {
                taskGroup.addTask {
                    let service = MyConcurrentService("service-\(task)")
                    await InjectStorage.standard.testableRegister(service,
                                                                  group: groupKey,
                                                                  key: "service-\(task)")
                }
            }
        }
    }
}

extension InjectStorage {
    func testableRegister(_ dependency: some Sendable, group: DependencyGroupKey, key: String) {
        let groupStorage = storageForGroup(group)
        groupStorage.set(object: dependency, forKey: key)
    }
}
