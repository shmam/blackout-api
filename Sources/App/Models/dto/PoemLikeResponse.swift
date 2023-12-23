import Vapor

struct PoemLikeResponse: Codable, AsyncResponseEncodable {
  let poemId: UUID
  let liked: Bool

  enum CodingKeys: String, CodingKey {
    case poemId
    case liked
  }

  func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
    let response = Response()
    try response.content.encode(self, as: .json)
    return response   
  }
}
