import Vapor

struct PoemController: RouteCollection {
  let poemService: PoemService = PoemService()
  let userService: UserService = UserService()

  func boot(routes: RoutesBuilder) throws {
    let poemRoutes = routes.grouped("v1").grouped("poem")
    poemRoutes.post(use: createPoem)

    poemRoutes.group(":id") { poemRoute in
      poemRoute.get(use: getPoemById)
      poemRoute.post("like", use: toggleLikePoem)
    }
  }

  func getPoemById(req: Request) async throws -> PoemResponse {
    let id = req.parameters.get("id")!

    guard UUID(uuidString: id) != nil else {
      throw Abort(.badRequest)
    }

    let poem = try await poemService.getPoemById(db: req.db, id: id)
    
    guard let poem = poem else {
      throw Abort(.notFound)
    }
    return poem
  }

  func createPoem(req: Request) async throws -> Poem {
    let poemRequest = try req.content.decode(CreatePoemRequest.self)
    let token = req.headers.bearerAuthorization?.token

    guard let user = try await userService.getUserByToken(db: req.db, token: token) else {
      throw Abort(.unauthorized)
    }

    return try await poemService.postPoem(db: req.db, request: poemRequest, user: user)
  }

  func toggleLikePoem(req: Request) async throws -> PoemLikeResponse {
    let id = req.parameters.get("id")!
    let token = req.headers.bearerAuthorization?.token

    guard let id = UUID(uuidString: id) else {
      throw Abort(.badRequest)
    }

    guard let user = try await userService.getUserByToken(db: req.db, token: token) else {
      throw Abort(.unauthorized)
    }

    return try await poemService.toggleLikePoem(db: req.db, id: id, user: user)
  }
  
}