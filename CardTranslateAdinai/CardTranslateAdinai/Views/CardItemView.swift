import SwiftUI

struct CardItemView: View {
    let card: CardModel
    
    var body: some View {
        HStack {
            if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(card.wordEnglish)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(card.wordRussian)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    CardItemView(card: CardModel(id: "1", userId: "123", wordEnglish: "Apple", wordRussian: "Яблоко", imageUrl: nil))
}
