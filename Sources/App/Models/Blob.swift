import Fluent
import Vapor

final class Blob: Model, Content, Decodable {
    static let schema = "blobs"
    
    @ID(custom: "id")
    var id: UUID?

    @Field(key: "sourceid")
    var source: UUID

    @Field(key: "value")
    var value: String

    @Field(key: "sourcename")
    var sourceName: String

    @Field(key: "used")
    var used: Int
    
    init() { }

    init(id: UUID, source: UUID, value: String, sourceName: String, used: Int) {
        self.id = id
        self.source = source
        self.value = value
        self.sourceName = sourceName
        self.used = used
    }

    enum CodingKeys: String, CodingKey {
        case id
        case source
        case value
        case sourceName
        case used
    }
}
