import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            ZStack {
                // Градиентный фон
                LinearGradient(
                    gradient: Gradient(colors: [.green, .blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                TabView {
                    CardView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                Text("Главная")
                            }
                        }
                    
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                Text("Профиль")
                            }
                        }
                }
                .accentColor(.purple) // Цвет выделения кнопок
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.orange, .yellow]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            }
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
