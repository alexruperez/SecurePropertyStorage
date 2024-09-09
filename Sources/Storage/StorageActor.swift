@globalActor
/// A global actor responsible for managing access and write operations in storage systems
public actor StorageActor {
    public static var shared = StorageActor()
}
