import XCTest
@testable import SecurePropertyStorage
@testable import Storage
@testable import UserDefault
@testable import Keychain
@testable import Singleton
@testable import Inject

final class ConcurrencyTests: XCTestCase, @unchecked Sendable {

    // MARK: - Storage Concurrency Tests

    @UserDefault("concurrentUserDefaultCounter")
    var userDefaultCounter: Int?
    
    @Singleton("concurrentSingletonValue")
    var singletonValue: Int?

    func testConcurrentWritesToUserDefault() async {
        self.userDefaultCounter = nil // Clear at start of test
        let iterationCount = 100
        let expectation = XCTestExpectation(description: "Concurrent writes to UserDefault complete")
        expectation.expectedFulfillmentCount = iterationCount
        expectation.assertForOverFulfill = false

        for i in 0..<iterationCount {
            Task.detached {
                self.userDefaultCounter = i
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 15.0)
        XCTAssertNotNil(self.userDefaultCounter, "UserDefault counter should have a value after concurrent writes.")
    }

    func testConcurrentReadWriteKeychain() async {
        let taskCount = 50
        let key = "testConcurrentKeychainKey-\(UUID().uuidString)" // Unique key for test
        
        await KeychainStorage.standard.set("initialValue", forKey: key)

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<taskCount {
                group.addTask {
                    _ = await KeychainStorage.standard.string(forKey: key) // Perform a read
                    await KeychainStorage.standard.set("value-\(i)", forKey: key) // Perform a write
                }
            }
        }
        
        let finalValue = await KeychainStorage.standard.string(forKey: key)
        XCTAssertNotNil(finalValue, "Keychain should have a value after concurrent operations.")
        XCTAssertTrue(finalValue?.starts(with: "value-") ?? false, "Keychain value should be one of the written values. Was: \(finalValue ?? "nil")")
        
        await KeychainStorage.standard.remove(forKey: key) // Cleanup
    }
    
    func testConcurrentSingletonIncrement() async {
        let taskCount = 100
        self.singletonValue = 0 // Initialize at start of test
        XCTAssertEqual(self.singletonValue, 0, "Singleton value should be initialized to 0.")

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<taskCount {
                group.addTask {
                    let currentValue = self.singletonValue ?? 0
                    self.singletonValue = currentValue + 1
                }
            }
        }
        
        XCTAssertEqual(self.singletonValue, taskCount, "Singleton value should be incremented by each task. Final value: \(self.singletonValue ?? -1)")
    }

    // MARK: - Inject Concurrency Tests
    
    protocol ConcurrentInjectable: Sendable { func id() -> String }
    final class MyConcurrentService: ConcurrentInjectable, Sendable {
        let uniqueID: String
        init(id: String = UUID().uuidString) { self.uniqueID = id }
        func id() -> String { self.uniqueID }
    }

    func testConcurrentRegistrationAndResolutionInject() async {
        let taskCount = 20 
        let groupKey = "testConcurrentGroup-\(UUID().uuidString)" // Unique group key for this test run

        await withTaskGroup(of: Void.self) { taskGroup in
            for i in 0..<taskCount {
                taskGroup.addTask {
                    let service = MyConcurrentService(id: "service-\(i)")
                    await InjectStorage.standard.testableRegister(service, group: groupKey, key: "service-\(i)")
                }
            }
        }
        
        await withTaskGroup(of: (String?).self) { taskGroup in
            for i in 0..<taskCount {
                taskGroup.addTask {
                    let key = "service-\(i)"
                    let resolved: MyConcurrentService? = await InjectStorage.standard.testableResolve(group: groupKey, key: key)
                    return resolved?.id()
                }
            }
            
            var resolvedIDs = Set<String>()
            for await result in taskGroup { 
                if let id = result { 
                    resolvedIDs.insert(id) 
                } 
            }
            
            XCTAssertEqual(resolvedIDs.count, taskCount, "Should have resolved all concurrently registered services. Resolved \(resolvedIDs.count) out of \(taskCount). IDs: \(resolvedIDs)")
            for i in 0..<taskCount {
                 XCTAssertTrue(resolvedIDs.contains("service-\(i)"), "Resolved IDs should contain service-\(i). Current IDs: \(resolvedIDs)")
            }
        }
    }
}

// Helper extension for InjectStorage for testing; 
// these are instance methods of InjectStorage, so they run on its actor (StorageActor).
// Calls to these methods from non-actor test code need to be `await`ed.
extension InjectStorage {
    func testableRegister<Dependency: Sendable>(_ dependency: Dependency, group: DependencyGroupKey, key: String) {
        let groupStorage = self.storageForGroup(group) 
        groupStorage.set(object: dependency, forKey: key) 
    }

    func testableResolve<Dependency: Sendable>(group: DependencyGroupKey, key: String) -> Dependency? {
        let groupStorage = self.storageForGroup(group) 
        return groupStorage.value(forKey: key) as? Dependency 
    }
}
