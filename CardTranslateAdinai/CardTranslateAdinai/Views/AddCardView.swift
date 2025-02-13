import SwiftUI
import FirebaseAuth
import Foundation

struct AddCardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var englishWord = ""
    @State private var russianWord = ""
    @State private var imageURL = ""
    @State private var isTranslating = false
    @ObservedObject var viewModel: CardViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Слово", text: $russianWord)
                
                HStack {
                    TextField("Перевод слова", text: $englishWord)
                    Button(action: {
                        translateToEnglish(russianWord)
                    }) {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                            .padding(4)
                    }
                    .disabled(russianWord.isEmpty || isTranslating) // Блокировка кнопки, если ввод пустой или идет перевод
                }
                
                if isTranslating {
                    ProgressView("Перевод...")
                }
                
                TextField("URL изображения", text: $imageURL)
                
                if !imageURL.isEmpty {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .navigationBarItems(
                leading: Button("Отмена") {
                    dismiss()
                },
                trailing: Button("Сохранить") {
                    let newCard = CardModel(
                        id: UUID().uuidString,
                        userId: Auth.auth().currentUser?.uid ?? "",
                        wordEnglish: englishWord,
                        wordRussian: russianWord,
                        imageUrl: imageURL.isEmpty ? nil : imageURL
                    )
                    viewModel.addCard(
                        wordEnglish: englishWord,
                        wordRussian: russianWord,
                        imageUrl: imageURL.isEmpty ? nil : imageURL,
                        image: nil // так как загружаем через URL
                    ) { success in
                        if success {
                            dismiss()
                        } else {
                            print("Ошибка при сохранении карточки")
                        }
                    }

                }
                .disabled(englishWord.isEmpty || russianWord.isEmpty || imageURL.isEmpty)
            )
        }
    }
    func translateToEnglish(_ text: String) {
        guard !text.isEmpty else { return }
        isTranslating = true

        let url = URL(string: "https://api.mymemory.translated.net/get")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "ru|en")
        ]

        guard let requestURL = components?.url else {
            print("Ошибка формирования URL")
            isTranslating = false
            return
        }

        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            DispatchQueue.main.async {
                self.isTranslating = false
            }

            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Ошибка: отсутствуют данные в ответе")
                return
            }

            do {
                let translation = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
                DispatchQueue.main.async {
                    self.englishWord = translation.responseData.translatedText
                }
            } catch {
                if let response = response as? HTTPURLResponse {
                    print("HTTP статус: \(response.statusCode)")
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("Ответ сервера: \(dataString)")
                    }
                }
                print("Ошибка декодирования: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    struct MyMemoryResponse: Decodable {
        struct ResponseData: Decodable {
            let translatedText: String
        }
        
        let responseData: ResponseData
    }
}
