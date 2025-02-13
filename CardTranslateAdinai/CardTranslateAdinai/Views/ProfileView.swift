import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill") // Иконка профиля
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                if let email = viewModel.userEmail {
                    Text(email) // Отображается только email
                        .font(.title)
                        .bold()
                    
                    Button(action: {
                        viewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    ProgressView("Loading profile...")
                }
            }
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
