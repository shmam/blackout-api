import Vapor
import Foundation
import FluentSQL

final class PoemService {
  let userService = UserService()
  let blobService = BlobService()

  func getPoemById(db: Database, id: String) async throws -> PoemResponse? {
    var poemById: Poem? = nil

    poemById = try await Poem.find(UUID(id), on: db)

    guard let poem = poemById else {
      return nil
    }

    let userResult = try await userService.getUserById(db: db, id: poem.userId.uuidString)

    guard let user = userResult else {
      throw Abort(.notFound)
    }

    let likes = try await Likes.query(on: db).filter(\.$poemId == poem.id!).count()
    let userLiked = try await Likes.query(on: db).filter(\.$poemId == poem.id!).filter(\.$userId == user.id!).count() > 0

    let poemDto = PoemResponse(
      id: poem.id!, 
      value: poem.value, 
      sourceId: poem.sourceId, 
      userId: poem.userId, 
      createdAt: poem.createdAt, 
      username: user.username, 
      likes: likes,
      userLiked: userLiked
    )
    
    return poemDto
  }

  func postPoem(db: Database, request: CreatePoemRequest, user: User) async throws -> Poem {
    // validate that the blob exists and validate that it matches the values
    let blobResult = try await blobService.getBlobById(db: db, id: request.blobId)

    guard let blob = blobResult else {
      throw Abort(.badRequest)
    }
    
    // guard validateValueFromBlob(value: request.value, blob: blob) else {
    //   throw Abort(.badRequest)
    // }


    let poem = Poem(
      id: UUID(), 
      value: request.value, 
      sourceId: blob.id!, 
      userId: user.id!, 
      createdAt: Date()
    )
    
    try await poem.save(on: db)
    
    return poem
  }

  func toggleLikePoem(db: Database, id: UUID, user: User) async throws -> PoemLikeResponse {
    let poem = try await Poem.find(id, on: db)

    guard poem != nil else {
      throw Abort(.notFound)
    }

    let like = try await Likes.query(on: db).filter(\.$poemId == id).filter(\.$userId == user.id!).first()

    if like != nil {
      try await like!.delete(on: db)

      return PoemLikeResponse(poemId: id, liked: false)
    } else {
      let newLike = Likes(poemId: id, userId: user.id!)
      try await newLike.save(on: db)

      return PoemLikeResponse(poemId: id,  liked: true)
    }
  }

  // value is a string that contians a subset of all the words from blob.
  // validate that the value is a subset of the words from blob
  private func validateValueFromBlob(value: String, blob: Blob) -> Bool {
    let blobWords = blob.value.split(separator: " ")
    let valueWords = value.split(separator: " ")

    for word in valueWords {
      if !blobWords.contains(word) {
        return false
      }
    }

    return true
  }
}