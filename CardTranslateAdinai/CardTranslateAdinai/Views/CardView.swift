import SwiftUI

struct CardView: View {
    @StateObject private var viewModel = CardViewModel()
    @State private var showAddCardModal = false
    @State private var currentIndex = 0 // Делаем индекс изменяемым

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cards.isEmpty {
                    Text("У вас нет карточек")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.cards.indices, id: \.self) { index in
                                NavigationLink(destination: CardDetailView(
                                    currentIndex: $currentIndex, // Передаём биндинг
                                    viewModel: viewModel,
                                    cards: viewModel.cards
                                )) {
                                    CardItemView(card: viewModel.cards[index])
                                        .padding(.vertical, 5)
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    currentIndex = index // Обновляем индекс при нажатии
                                })
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Мои карточки")
            .toolbar {
                Button(action: {
                    showAddCardModal.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            }
            .sheet(isPresented: $showAddCardModal) {
                AddCardView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchCards()
        }
    }
}
