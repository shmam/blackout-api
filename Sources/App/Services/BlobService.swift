import Vapor
import Foundation
import FluentSQL

final class BlobService {
    
    func getRandomBlob(db: Database) async throws -> Blob? {
        return try await Blob.query(on: db)
            .sort(.sql(raw: "random()"))
            .first()
            .map { $0 }
    }

    func getBlobById(db: Database, id: String) async throws -> Blob? {
        var blobById: Blob? = nil

        do {
            blobById = try await Blob.find(UUID(uuidString: id), on: db)
        } catch {
            return nil
        }
        return blobById
    }

}
