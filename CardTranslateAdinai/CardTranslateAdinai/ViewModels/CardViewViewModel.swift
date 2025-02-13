import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import SwiftUI

class CardViewModel: ObservableObject {
    @Published var cards: [CardModel] = []
    private let db = Firestore.firestore()
    
    func fetchCards() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("cards")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Ошибка загрузки карточек: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    if let documents = snapshot?.documents {
                        self.cards = documents.compactMap { doc in
                            try? doc.data(as: CardModel.self)
                        }
                    }
                }
            }
    }
    
    func deleteCard(_ card: CardModel, completion: @escaping () -> Void) {
           guard let url = URL(string: "https://your-api-url.com/cards/\(card.id)") else { return }
           
           var request = URLRequest(url: url)
           request.httpMethod = "DELETE"
           
           URLSession.shared.dataTask(with: request) { _, response, error in
               if let error = error {
                   print("Ошибка удаления: \(error.localizedDescription)")
                   return
               }
               DispatchQueue.main.async {
                   self.cards.removeAll { $0.id == card.id }
                   completion()
               }
           }.resume()
       }
    
    func updateCard(_ updatedCard: CardModel) {
           if let index = cards.firstIndex(where: { $0.id == updatedCard.id }) {
               DispatchQueue.main.async {
                   self.cards[index] = updatedCard
               }
           }
       }
    
    // Добавление карточки (с поддержкой URL или изображения)
    func addCard(wordEnglish: String, wordRussian: String, imageUrl: String?, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let userId = FirebaseAuth.Auth.auth().currentUser?.uid else {
            print("❌ Ошибка: Пользователь не авторизован")
            completion(false)
            return
        }
        
        let cardId = UUID().uuidString
        let cardRef = db.collection("cards").document(cardId)
        
        var cardData: [String: Any] = [
            "id": cardId,
            "userId": userId,
            "wordEnglish": wordEnglish,
            "wordRussian": wordRussian,
            "timestamp": Timestamp()
        ]
        
        // ✅ Если передан URL, просто сохраняем его
        if let imageUrl = imageUrl, !imageUrl.isEmpty {
            print("✅ Сохраняем карточку с URL изображения")
            cardData["imageUrl"] = imageUrl
            saveCardData(cardRef: cardRef, cardData: cardData, completion: completion)
            return
        }
        
        // ✅ Если передан UIImage, загружаем его в Firebase Storage
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            let storageRef = Storage.storage().reference().child("card_images/\(cardId).jpg")
            
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("❌ Ошибка загрузки изображения: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                // ✅ Получаем ссылку на загруженное изображение
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("❌ Ошибка получения URL изображения: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    guard let url = url else {
                        print("❌ Ошибка: URL изображения отсутствует после загрузки")
                        completion(false)
                        return
                    }
                    
                    cardData["imageUrl"] = url.absoluteString
                    self.saveCardData(cardRef: cardRef, cardData: cardData, completion: completion)
                }
            }
        } else {
            // ✅ Если нет ни URL, ни изображения — просто сохраняем текст карточки
            print("ℹ️ Добавляем карточку без изображения")
            saveCardData(cardRef: cardRef, cardData: cardData, completion: completion)
        }
    }
    
    private func saveCardData(cardRef: DocumentReference, cardData: [String: Any], completion: @escaping (Bool) -> Void) {
        cardRef.setData(cardData) { error in
            if let error = error {
                print("❌ Ошибка сохранения карточки: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Карточка успешно сохранена!")
                completion(true)
            }
        }
    }
}
