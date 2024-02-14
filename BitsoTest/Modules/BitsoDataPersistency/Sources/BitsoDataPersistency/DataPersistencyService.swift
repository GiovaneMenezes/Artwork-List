import Foundation

public protocol IDataPersistencyService {
    func fetchData<T: Codable>(_ type: T.Type) throws -> T
    func storeData<T: Codable>(_ data: T) throws
}

enum DataPersistencyServiceError {
    case unknownFilePath
    case noData
}

extension DataPersistencyServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownFilePath:
            return "The data is not reachable."
        case .noData:
            return "There is no data stored"
        }
    }
}

public struct DataPersistencyService: IDataPersistencyService {
    public init() { }
    
    private func getFilePath<T: Codable>(type: T.Type) throws -> URL {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let firstFilePath = filePath.first else { throw DataPersistencyServiceError.unknownFilePath }
        return firstFilePath.appendingPathComponent("\(T.self).json")
    }
    
    public func fetchData<T: Codable>(_ type: T.Type) throws -> T {
        guard let data = try? Data(contentsOf: try getFilePath(type: T.self)) else { throw DataPersistencyServiceError.noData }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func storeData<T: Codable>(_ object: T) throws {
        let encodedObject = try JSONEncoder().encode(object)
        try encodedObject.write(to: try getFilePath(type: T.self))
    }
}
