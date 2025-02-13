import SwiftUI

struct CardDetailView: View {
    @Binding var currentIndex: Int
    @ObservedObject var viewModel: CardViewModel
    let cards: [CardModel]

    @Environment(\.presentationMode) var presentationMode
    @State private var showDeleteConfirmation = false
    @State private var showEditModal = false

    var body: some View {
        VStack {
            if cards.indices.contains(currentIndex) {
                let card = cards[currentIndex]

                VStack {
                    if let imageURL = card.imageUrl {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 350, height: 250)
                                .cornerRadius(15)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    Text(card.wordEnglish)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(card.wordRussian)
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: 380)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 8)
                .padding()

                // Кнопки навигации и управления
                HStack(spacing: 20) {
                    Button(action: {
                        if currentIndex > 0 { currentIndex -= 1 }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .disabled(currentIndex == 0)

                    Button(action: {
                        showEditModal = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        if currentIndex < cards.count - 1 { currentIndex += 1 }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .disabled(currentIndex >= cards.count - 1)
                }
                .padding()

                Spacer()

                // Кнопка "Назад"
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.backward")
                        Text("Назад")
                            .font(.title3)
                    }
                    .padding()
                    .frame(width: 180)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
                .padding(.bottom, 20)
            } else {
                Text("Карточка не найдена")
                    .foregroundColor(.gray)
                    .font(.title2)
                    .padding()
            }
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Удалить карточку?"),
                message: Text("Вы уверены, что хотите удалить эту карточку?"),
                primaryButton: .destructive(Text("Да")) {
                    deleteCard()
                },
                secondaryButton: .cancel(Text("Отмена"))
            )
        }
        .sheet(isPresented: $showEditModal) {
            EditCardView(viewModel: viewModel, card: cards[currentIndex], isPresented: $showEditModal)
        }
    }

    private func deleteCard() {
        let deletedIndex = currentIndex
        viewModel.deleteCard(cards[deletedIndex]) {
            if viewModel.cards.isEmpty {
                presentationMode.wrappedValue.dismiss() // Закрыть экран, если карточек больше нет
            } else {
                currentIndex = min(deletedIndex, viewModel.cards.count - 1) // Обновляем индекс
            }
        }
    }
}
