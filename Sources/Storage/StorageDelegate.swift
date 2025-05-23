/// `StorageDelegate` protocol.
public protocol StorageDelegate: AnyObject {
    /**
     Returns the `StorageData` associated with the specified `StoreKey`.

     - Parameter key: A `StoreKey` in storage.

     - Throws: `StorageDelegate` implementation possible errors.
     */
    @StorageActor
    func data<D: StorageData>(forKey key: StoreKey) throws -> D?

    /**
     Sets the value of the specified `StoreKey` to the specified `StorageData`.

     - Parameter data: `StorageData` to store.
     - Parameter key: The `StoreKey` with which to associate the value.

     - Throws: `StorageDelegate` implementation possible errors.
     */
    @StorageActor
    func set<D: StorageData>(_ data: D?, forKey key: StoreKey) throws

    /**
     Removes the value of the specified `StoreKey`.

     - Parameter key: The `StoreKey` whose value you want to remove.

     - Throws: `StorageDelegate` implementation possible errors.
     */
    @StorageActor
    func remove(forKey key: StoreKey) throws
}
