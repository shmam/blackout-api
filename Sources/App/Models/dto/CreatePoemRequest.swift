struct CreatePoemRequest: Codable {
  let value: String
  let blobId: String

  enum CodingKeys: String, CodingKey {
    case value, blobId
  }
}