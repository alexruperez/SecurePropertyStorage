public protocol StorageDelegate: class {
    func data<D: StorageData>(forKey key: String) throws -> D?
    func set<D: StorageData>(_ data: D?, forKey key: String) throws
    func remove(forKey key: String) throws
}
