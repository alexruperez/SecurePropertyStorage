import Foundation
import Storage

/// Any `@objc protocol` to be used as qualifier of your dependencies.
public typealias Qualifier = Protocol

/// Inject property wrapper reusable class.
open class InjectPropertyWrapper<Dependency>: StorePropertyWrapper {
    /// All `@objc protocol`s to be used as qualifiers of your dependencies.
    open var qualifiers: [Qualifier]?

    /**
     Create a inject property wrapper.

     - Parameter qualifier: Any `@objc protocol` to be used as qualifier of your dependencies.
     */
    public convenience init(_ qualifier: Qualifier) {
        self.init([qualifier])
    }

    /**
     Create a inject property wrapper.

     - Parameter qualifiers: All `@objc protocol`s to be used as qualifiers of your dependencies.
     */
    public convenience init(_ qualifiers: [Qualifier]) {
        self.init(InjectStorage.standard, String(describing: Dependency.self))
        self.qualifiers = qualifiers
    }

    /**
     Register a dependency.

     - Parameter dependency: Your dependency to register.
     */
    open func register(_ dependency: Dependency?) {
        storage.set(dependency, forKey: key)
    }

    /**
     Resolve a dependency.

     - Returns: Your dependency resolved.
     */
    open func resolve() throws -> Dependency {
        guard let dependencies: [Any] = storage.array(forKey: key) else {
            throw InjectError.notFound(Dependency.self)
        }
        if dependencies.count == 1,
            let dependency = dependencies.last as? Dependency {
            return dependency
        }
        if let qualifiers = qualifiers {
            let qualifiedDependencies = dependencies.filter { dependency in
                qualifiers.allSatisfy { qualifier in
                    class_conformsToProtocol(type(of: dependency) as? AnyClass, qualifier)
                }
            }
            if qualifiedDependencies.count == 1,
                let dependency = qualifiedDependencies.last as? Dependency {
                return dependency
            }
        }
        throw InjectError.moreThanOne(Dependency.self)
    }
}

/// `@Inject` property wrapper.
@propertyWrapper
public class Inject<Dependency>: InjectPropertyWrapper<Dependency> {
    /// Create a `Inject` property wrapper.
    public convenience init() {
        self.init([])
    }

    /// Property wrapper stored dependency.
    public var wrappedValue: Dependency? { try? resolve() }
}

/// `@UnwrappedInject` property wrapper.
@propertyWrapper
public class UnwrappedInject<Dependency>: InjectPropertyWrapper<Dependency> {
    /// Create a `UnwrappedInject` property wrapper.
    public convenience init() {
        self.init([])
    }

    /// Property wrapper stored dependency.
    public var wrappedValue: Dependency {
        do {
            return try resolve()
        } catch let error as InjectError {
            fatalError(error.description)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

/// `@Register` property wrapper.
@propertyWrapper
public class Register<Dependency>: InjectPropertyWrapper<Dependency> {
    /**
     Create a `Register` property wrapper.

     - Parameter wrappedValue: Registered dependency.
     */
    public convenience init(wrappedValue: Dependency) {
        self.init([])
        self.wrappedValue = wrappedValue
    }

    /// Property wrapper stored dependency.
    public var wrappedValue: Dependency {
        get {
            do {
                return try resolve()
            } catch let error as InjectError {
                fatalError(error.description)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        set { register(newValue) }
    }
}
