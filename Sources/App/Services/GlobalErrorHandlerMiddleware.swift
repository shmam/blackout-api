import Vapor

struct GlobalErrorHandlerMiddleware: Middleware {
  func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {    
    return next.respond(to: request).flatMapError { error in
      let response: Response
      
      switch error {
      default:
        response = Response(status: .internalServerError, body: Response.Body("Internal Server Error"))
      }
      
      return request.eventLoop.makeSucceededFuture(response)
    }
  }
}