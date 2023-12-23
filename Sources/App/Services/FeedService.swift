import Vapor
import Fluent

final class FeedService {
  func getFeed(db: Database, user: User, offset: Int, limit: Int) async throws -> FeedResponse {

    let poemDbObjects = try await Poem.query(on: db)
      .sort(\.$createdAt, .descending)
      .offset(offset)
      .limit(limit)
      .all()

    let poemIds = poemDbObjects.map { $0.id! }
    let poemUserIds = poemDbObjects.map { $0.userId }

    let userLikedPoemIds = try await Likes.query(on: db)
      .filter(\Likes.$poemId ~~ poemIds)
      .filter(\Likes.$userId == user.id!)
      .all()
      .map { $0.poemId }

    let likes = try await Likes.query(on: db)
      .filter(\Likes.$poemId ~~ poemIds)
      .all()
      .reduce(into: [:]) { result, like in
        result[like.poemId] = (result[like.poemId] ?? 0) + 1
      }

    let userDictionary = try await User.query(on: db)
      .filter(\User.$id ~~ poemUserIds)
      .all()
      .reduce(into: [:]) { result, user in
        result[user.id!] = user
    }

    let poems = try await poemDbObjects.map { poem in
      PoemResponse(
        id: poem.id!,
        value: poem.value,
        sourceId: poem.sourceId,
        userId: poem.userId,
        createdAt: poem.createdAt,
        username: userDictionary[poem.userId]?.username ?? "",
        likes: likes[poem.id!] ?? 0,
        userLiked: userLikedPoemIds.contains(poem.id!)
      )
    }

    let total = poemDbObjects.count

    return FeedResponse(poems: poems, offset: offset, total: total)
  }
}
