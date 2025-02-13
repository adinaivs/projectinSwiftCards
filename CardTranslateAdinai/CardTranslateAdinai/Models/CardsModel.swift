import Foundation

struct CardModel: Identifiable, Codable {
    let id: String
    let userId: String
    let wordEnglish: String
    let wordRussian: String
    let imageUrl: String?
}
