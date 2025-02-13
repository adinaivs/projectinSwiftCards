import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон (как в RegisterView)
                LinearGradient(
                    gradient: Gradient(colors: [.green, .blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Логотип или заголовок
                    VStack(spacing: 10) {
                        Text("Карточки для запоминания слов")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Запоминай новые слова вместе с нами")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Форма входа
                    VStack(spacing: 15) {
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(Color.red)
                                .font(.caption)
                                .padding(.horizontal)
                        }
                        
                        TextField("Адрес почты", text: $viewModel.email)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .textInputAutocapitalization(.none)
                        
                        SecureField("Пароль", text: $viewModel.password)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                        
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Войти")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Создать аккаунт
                    VStack {
                        Text("В первый раз здесь? ☺️")
                            .foregroundColor(.white.opacity(0.9))
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Создать аккаунт")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Заполнение экрана
                .padding() // Внутренние отступы
                .background(GeometryReader { geometry in
                    // Выравнивание по центру
                    Color.clear
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .alignmentGuide(.top) { d in (d.height - geometry.size.height) / 2 }
                })
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
