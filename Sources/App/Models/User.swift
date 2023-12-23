import Fluent
import Vapor

final class User: Model, Content, Decodable {
    static let schema = "users"
    
    @ID(custom: "id")
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "createdat")
    var createdAt: Date

    @Field(key: "token")
    var token: String

    init() { }

    init(id: UUID, username: String, createdAt: Date, token: String) {
        self.id = id
        self.username = username
        self.createdAt = createdAt
        self.token = token
    }

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case createdAt
        case token
    }
}