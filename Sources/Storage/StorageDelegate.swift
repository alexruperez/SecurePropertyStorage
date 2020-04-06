public protocol StorageDelegate: AnyObject {
    func data<D: StorageData>(forKey key: StoreKey) throws -> D?
    func set<D: StorageData>(_ data: D?, forKey key: StoreKey) throws
    func remove(forKey key: StoreKey) throws
}
