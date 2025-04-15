import Foundation

struct Quote: Identifiable, Codable {
    let id: Int
    let quote: String
    let author: String
}
