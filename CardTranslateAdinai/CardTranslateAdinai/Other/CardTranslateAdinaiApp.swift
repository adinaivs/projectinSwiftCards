
import FirebaseCore
import SwiftUI

@main
struct CardTranslateAdinaiApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
