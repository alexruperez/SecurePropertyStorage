/// Inject error enum.
public enum InjectError: Error, CustomStringConvertible {
    /// When no dependency has been registered.
    case notFound(_ dependency: Any, qualifiers: [Qualifier]?, group: DependencyGroupKey?)
    /// When more than one dependency registered.
    case moreThanOne(_ dependency: Any, qualifiers: [Qualifier]?, group: DependencyGroupKey?)

    public var description: String {
        switch self {
        case let .notFound(dependency, qualifiers, group):
            return """
            No dependency registered for \(dependency)
            with qualifiers \(qualifiers ?? []) and dependency group \(group ?? "undefined"),
            please use @Register property wrapper to specify what you want to inject.
            """
        case let .moreThanOne(dependency, qualifiers, group):
            return """
            More than one dependency registered for \(dependency)
            with qualifiers \(qualifiers ?? []) and dependency group \(group ?? "undefined"),
            please use a Qualifier to specify which one you want to inject.
            """
        }
    }
}
