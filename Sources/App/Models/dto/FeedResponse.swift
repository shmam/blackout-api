import Vapor

struct FeedResponse: Codable, AsyncResponseEncodable {
  let poems: [PoemResponse]
  let offset: Int
  let total: Int

  enum CodingKeys: String, CodingKey {
    case poems
    case offset
    case total
  }

  func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
    let response = Response()
    try response.content.encode(self, as: .json)
    return response   
  }
}