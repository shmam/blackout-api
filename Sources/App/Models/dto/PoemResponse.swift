import Vapor

struct PoemResponse: Codable, AsyncResponseEncodable {
    let id: UUID
    let value: String
    let sourceId: UUID
    let userId: UUID
    let createdAt: Date
    let username: String
    let likes: Int
    let userLiked: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case value
        case sourceId
        case userId
        case createdAt
        case username
        case likes
        case userLiked
    }

    func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        let response = Response()
        try response.content.encode(self, as: .json)
        return response   
    }
}