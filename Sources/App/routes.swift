import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "ok"
    }

    try app.register(collection: BlobController())
    try app.register(collection: PoemController())
    try app.register(collection: FeedController())
}
