import Fluent
import Vapor

struct BlobController: RouteCollection {
    
    let service: BlobService = BlobService()
    
    func boot(routes: RoutesBuilder) throws {
        let blobRoutes = routes.grouped("v1").grouped("blob")
        blobRoutes.get(use: getBlob)
    }

    func getBlob(req: Request) async throws -> Blob {
        let response = try await service.getRandomBlob(db: req.db)
        
        if response == nil { throw Abort(.internalServerError) }
        
        return response!
    }
}
