import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [.green, .blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Заголовок
                VStack(spacing: 10) {
                    Text("Регистрация")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Начните учиться уже сейчас! 😜")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                // Форма регистрации
                VStack(spacing: 15) {
                    TextField("ФИО", text: $viewModel.name)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    SecureField("Пароль", text: $viewModel.password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                    
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text("Создать аккаунт")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Центровка содержимого
        }
    }
}

#Preview {
    RegisterView()
}
