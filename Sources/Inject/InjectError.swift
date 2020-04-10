/// Inject error enum.
public enum InjectError: Error, CustomStringConvertible {
    /// When no dependency has been registered.
    case notFound(_ dependency: Any)
    /// When more than one dependency registered.
    case moreThanOne(_ dependency: Any)

    public var description: String {
        switch self {
        case let .notFound(dependency):
            return """
            No dependency registered for \(dependency),
            please use @Register property wrapper to specify what you want to inject.
            """
        case let .moreThanOne(dependency):
            return """
            More than one dependency registered for \(dependency),
            please use a Qualifier to specify which one you want to inject.
            """
        }
    }
}
