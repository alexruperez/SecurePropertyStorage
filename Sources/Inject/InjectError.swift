/// Inject error enum.
public enum InjectError: Error, CustomStringConvertible {
    /// A descriptor for the dependencies qualifiers
    public typealias QualifierDescriptor = String
    
    /// When no dependency has been registered.
    case notFound(_ dependency: any Sendable, qualifiers: [QualifierDescriptor]?, group: DependencyGroupKey?)
    /// When more than one dependency registered.
    case moreThanOne(_ dependency: any Sendable, qualifiers: [QualifierDescriptor]?, group: DependencyGroupKey?)

    public var description: String {
        switch self {
        case let .notFound(dependency, qualifiers, group):
            """
            No dependency registered for \(dependency)
            with qualifiers \(qualifiers ?? []) and dependency group \(group ?? "undefined"),
            please use @Register property wrapper to specify what you want to inject.
            """
        case let .moreThanOne(dependency, qualifiers, group):
            """
            More than one dependency registered for \(dependency)
            with qualifiers \(qualifiers ?? []) and dependency group \(group ?? "undefined"),
            please use a Qualifier to specify which one you want to inject.
            """
        }
    }
    
    static func notFound(_ dependency: any Sendable, qualifiers: [Qualifier]?, group: DependencyGroupKey?) -> InjectError {
        .notFound(
            dependency,
            qualifiers: ["\(qualifiers ?? [])"],
            group: group
        )
    }
    
    static func moreThanOne(_ dependency: any Sendable, qualifiers: [Qualifier]?, group: DependencyGroupKey?) -> InjectError {
        .moreThanOne(
            dependency,
            qualifiers: ["\(qualifiers ?? [])"],
            group: group
        )
    }
}
