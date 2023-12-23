import Vapor

struct FeedController: RouteCollection {
  let feedService: FeedService = FeedService()
  let userService: UserService = UserService()

  func boot(routes: RoutesBuilder) throws {
    let feedRoutes = routes.grouped("v1").grouped("feed")
    feedRoutes.get(use: getFeed)
  }

  func getFeed(req: Request) async throws -> FeedResponse {
    let token = req.headers.bearerAuthorization?.token
    let offset = req.query["offset"] ?? "0"
    let limit = req.query["limit"] ?? "10"

    guard let offset = Int(offset), let limit = Int(limit) else {
      throw Abort(.badRequest)
    }

    guard let user = try await userService.getUserByToken(db: req.db, token: token) else {
      throw Abort(.unauthorized)
    }

    let feed = try await feedService.getFeed(
      db: req.db, 
      user: user, 
      offset: offset, 
      limit: limit
    )

    return feed
  }

}