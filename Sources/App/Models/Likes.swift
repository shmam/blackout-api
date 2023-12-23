import Fluent
import Vapor

final class Likes: Model, Content, Decodable {
  static let schema = "likes"

  @ID(custom: "id")
  var id: Int?

  @Field(key: "poemid")
  var poemId: UUID

  @Field(key: "userid")
  var userId: UUID

  init() { }

  init(id: Int? = nil, poemId: UUID, userId: UUID) {
    self.id = id
    self.poemId = poemId
    self.userId = userId
  }

  enum CodingKeys: String, CodingKey {
    case id
    case poemId
    case userId
  }
}