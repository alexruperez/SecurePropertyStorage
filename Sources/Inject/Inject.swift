import Foundation
import Storage

/// Any `@objc protocol` to be used as qualifier of your dependencies.
public typealias Qualifier = Protocol

/// Dependency group key type.
public typealias DependencyGroupKey = StoreKey

/// Mock qualifier indicating that dependency must be injected before any other registered.
@objc public protocol Mock {}

/// Inject property wrapper reusable class.
open class InjectPropertyWrapper<Dependency, Parameters>: StorePropertyWrapper<InjectStorage> {
    /// Injection scope.
    public enum Scope {
        /// Singleton injection scope.
        case singleton
        /// Instance injection scope.
        case instance
    }

    /// All `@objc protocol`s to be used as qualifiers of your dependencies.
    open var qualifiers: [Qualifier]?
    /// Dependency group key.
    open var group: DependencyGroupKey?

    /**
     Create a inject property wrapper.

     - Parameter qualifier: Any `@objc protocol` to be used as qualifier of your dependencies.
     - Parameter group: Dependency group key.
     */
    public convenience init(_ qualifier: Qualifier,
                            group: DependencyGroupKey? = nil) {
        self.init([qualifier], group: group)
    }

    /**
     Create a inject property wrapper.

     - Parameter qualifiers: All `@objc protocol`s to be used as qualifiers of your dependencies.
     - Parameter group: Dependency group key.
     */
    public convenience init(_ qualifiers: [Qualifier],
                            group: DependencyGroupKey? = nil) {
        var key = String(describing: Dependency.self)
        if let index = key.lastIndex(of: " ") {
            key = String(key[key.index(after: index)...])
        }
        self.init(InjectStorage.standard, key)
        self.qualifiers = qualifiers
        self.group = group
    }

    /**
     Register a dependency.

     - Parameter dependency: Dependency to register.
     */
    open func register(_ dependency: Dependency?) {
        if let group = group {
            var groupStorage: InjectStorage?
            if let storage = storage.groups[group] {
                groupStorage = storage
            } else {
                groupStorage = InjectStorage()
                storage.groups[group] = groupStorage
            }
            groupStorage?.set(dependency, forKey: key)
        } else {
            storage.set(dependency, forKey: key)
        }
    }

    /**
     Resolve a dependency.

     - Parameter scope: Dependency injection scope.
     - Parameter parameters: Parameters to inject in builder.

     - Throws: `InjectError`.

     - Returns: Resolved dependency.
     */
    open func resolve(_ scope: Scope = .singleton,
                      _ parameters: Parameters? = nil) throws -> Dependency {
        var resolved = try dependencies()
        if let dependency = instance(resolved, scope, parameters) {
            return dependency
        }
        if let qualifiers = qualifiers {
            let qualifiedDependencies = resolved.filter { dependency in
                qualifiers.allSatisfy { qualifier in
                    class_conformsToProtocol(type(of: dependency) as? AnyClass, qualifier)
                }
            }
            if let dependency = instance(qualifiedDependencies, scope, parameters) {
                return dependency
            } else if qualifiedDependencies.count > 1 {
                resolved = qualifiedDependencies
            }
        }
        let mockDependencies = resolved.filter { dependency in
            class_conformsToProtocol(type(of: dependency) as? AnyClass, Mock.self)
        }
        if let dependency = instance(mockDependencies, scope, parameters) {
            return dependency
        }
        throw InjectError.moreThanOne(Dependency.self)
    }

    /**
     Get all matching dependencies.

     - Throws: `InjectError`.

     - Returns: Matching dependencies.
     */
    private func dependencies() throws -> [Any] {
        if let group = group, let storage = storage.groups[group],
           let dependencies = storage.array(forKey: key) {
            return dependencies
        }
        if let dependencies = storage.array(forKey: key) {
            return dependencies
        }
        throw InjectError.notFound(Dependency.self)
    }

    /**
     Resolve a dependency from candidate dependencies or by calling the builder if necessary.

     - Parameter dependencies: Candidate dependencies.
     - Parameter scope: Dependency injection scope.
     - Parameter parameters: Parameters to inject in builder.

     - Returns: Resolved dependency.
     */
    open func instance(_ dependencies: [Any],
                       _ scope: Scope,
                       _ parameters: Parameters?) -> Dependency? {
        var dependency: Dependency?
        let instances: [Dependency] = map(dependencies)
        if scope == .singleton,
            instances.count == 1 {
            dependency = instances.first
        }
        if let parameters = parameters {
            let builders: [(Parameters) -> Dependency] = map(dependencies)
            if builders.count == 1,
                let builder = builders.first {
                dependency = builder(parameters)
            }
        }
        let builders: [() -> Dependency] = map(dependencies)
        if builders.count == 1,
            let builder = builders.first {
            let instance = builder()
            if scope == .instance, dependency == nil {
                dependency = instance
            } else if instances.isEmpty {
                register(instance)
                dependency = instance
            }
        }
        return dependency
    }

    func map<Result>(_ dependencies: [Any]) -> [Result] {
        dependencies.compactMap { $0 as? Result }
    }

    /**
     A `String` representation of `Error`.

     - Parameter error: Any `Error`.
     */
    open func description(_ error: Error) -> String {
        if let error = error as? InjectError {
            return error.description
        }
        return error.localizedDescription
    }
}

/// `@Inject` property wrapper.
@propertyWrapper
public class Inject<Dependency>: InjectPropertyWrapper<Dependency, Void> {
    /// Injection scope.
    public var scope: Scope = .singleton

    /**
     Create a `Inject` property wrapper.

     - Parameter scope: Injection scope.
     - Parameter group: Dependency group key.
     */
    public convenience init(_ scope: Scope = .singleton,
                            group: DependencyGroupKey? = nil) {
        self.init([], group: group)
        self.scope = scope
    }

    /// Property wrapper stored dependency.
    public var wrappedValue: Dependency? { try? resolve(scope) }
}

/// `@InjectWith` property wrapper.
@propertyWrapper
public class InjectWith<Dependency, Parameters>: InjectPropertyWrapper<Dependency, Parameters> {
    /// Parameters to inject in builder.
    public var parameters: Parameters?

    /**
     Create a `InjectWith` property wrapper.

     - Parameter parameters: Parameters to inject in builder.
     - Parameter group: Dependency group key.
     */
    public convenience init(_ parameters: Parameters,
                            group: DependencyGroupKey? = nil) {
        self.init([], group: group)
        self.parameters = parameters
    }

    /// New dependency instance with parameters injected.
    public var wrappedValue: Dependency? { try? resolve(.instance, parameters) }
}

/// `@UnwrappedInject` property wrapper.
@propertyWrapper
public class UnwrappedInject<Dependency>: InjectPropertyWrapper<Dependency, Void> {
    /// Injection scope.
    public var scope: Scope = .singleton

    /**
     Create a `UnwrappedInject` property wrapper.

     - Parameter scope: Injection scope.
     - Parameter group: Dependency group key.
     */
    public convenience init(_ scope: Scope = .singleton,
                            group: DependencyGroupKey? = nil) {
        self.init([], group: group)
        self.scope = scope
    }

    /// Property wrapper stored dependency.
    public var wrappedValue: Dependency {
        do {
            return try resolve(scope)
        } catch {
            fatalError(description(error))
        }
    }
}

/// `@UnwrappedInjectWith` property wrapper.
@propertyWrapper
public class UnwrappedInjectWith<Dependency, Parameters>: InjectPropertyWrapper<Dependency, Parameters> {
    /// Parameters to inject in builder.
    public var parameters: Parameters?

    /**
     Create a `UnwrappedInjectWith` property wrapper.

     - Parameter parameters: Parameters to inject in builder.
     - Parameter group: Dependency group key.
     */
    public convenience init(_ parameters: Parameters,
                            group: DependencyGroupKey? = nil) {
        self.init([], group: group)
        self.parameters = parameters
    }

    /// New dependency instance with parameters injected.
    public var wrappedValue: Dependency {
        do {
            return try resolve(.instance, parameters)
        } catch {
            fatalError(description(error))
        }
    }
}

/// `@Register` property wrapper.
@propertyWrapper
public class Register<Dependency>: InjectPropertyWrapper<Dependency, Void> {
    /**
     Create a `Register` property wrapper.

     - Parameter wrappedValue: Registered dependency.
     - Parameter group: Dependency group key.
     */
    public convenience init(wrappedValue: Dependency,
                            group: DependencyGroupKey? = nil) {
        self.init([], group: group)
        self.wrappedValue = wrappedValue
    }

    /// Property wrapper stored dependency.
    public var wrappedValue: Dependency {
        get {
            do {
                return try resolve()
            } catch {
                fatalError(description(error))
            }
        }
        set { register(newValue) }
    }
}
