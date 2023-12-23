import Vapor
import Foundation
import FluentSQL

final class UserService {

  func getUserById(db: Database, id: String) async throws -> User? {
    var userById: User? = nil

    do {
      userById = try await User.find(UUID(uuidString: id), on: db)
    } catch {
      return nil
    }
    return userById
  }

  func getUserByToken(db: Database, token: String?) async throws -> User? {
    var userByToken: User? = nil

    guard let token = token else {
      return nil
    }

    do {
      userByToken = try await User.query(on: db).filter(\.$token == token).first()
    } catch {
      return nil
    }
    return userByToken
  }
}