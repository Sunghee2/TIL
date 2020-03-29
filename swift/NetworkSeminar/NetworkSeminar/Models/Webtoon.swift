// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let webtoon = try? newJSONDecoder().decode(Webtoon.self, from: jsonData)

import Foundation

// MARK: - Webtoon
struct Webtoon: Codable {
    let idx: Int
    let title: String
    let thumnail: String
    let isFinished, likes: Int
    let name: String
}
