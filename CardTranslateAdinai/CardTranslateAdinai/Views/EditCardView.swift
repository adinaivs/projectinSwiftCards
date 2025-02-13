import SwiftUI

struct EditCardView: View {
    @ObservedObject var viewModel: CardViewModel
    var card: CardModel
    @Binding var isPresented: Bool
    
    @State private var englishWord: String
    @State private var russianWord: String
    
    init(viewModel: CardViewModel, card: CardModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.card = card
        self._isPresented = isPresented
        _englishWord = State(initialValue: card.wordEnglish)
        _russianWord = State(initialValue: card.wordRussian)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Английское слово")) {
                    TextField("Введите слово", text: $englishWord)
                }
                
                Section(header: Text("Русское слово")) {
                    TextField("Введите перевод", text: $russianWord)
                }
                
                Button("Сохранить изменения") {
                    saveChanges()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .navigationTitle("Редактирование")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        isPresented = false
                    }
                }
            }
        }
    }
    private func saveChanges() {
        let updatedCard = CardModel(
            id: card.id,
            userId: card.userId, // Добавлен userId
            wordEnglish: englishWord, // Исправлены названия
            wordRussian: russianWord,
            imageUrl: card.imageUrl // Совпадает с объявлением в CardModel
        )
        
        viewModel.updateCard(updatedCard)
        isPresented = false
    }
}
