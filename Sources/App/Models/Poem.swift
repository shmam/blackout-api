import Fluent 
import Vapor

final class Poem: Model, Content, Decodable {
    static let schema = "poems"
    
    @ID(custom: "id")
    var id: UUID?
    
    @Field(key: "value")
    var value: String

    @Field(key: "sourceid")
    var sourceId: UUID

    @Field(key: "userid")
    var userId: UUID

    @Field(key: "createdat")
    var createdAt: Date


    init() { }

    init(id: UUID, value: String, sourceId: UUID, userId: UUID, createdAt: Date) {
        self.id = id
        self.value = value
        self.sourceId = sourceId
        self.userId = userId
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case value
        case sourceId
        case userId
        case createdAt
    }
}