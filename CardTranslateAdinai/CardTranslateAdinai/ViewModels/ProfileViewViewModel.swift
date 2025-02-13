import Foundation
import FirebaseAuth

class ProfileViewViewModel: ObservableObject {
    @Published var userEmail: String?
    
    init() {
        fetchUserEmail()
    }
    
    func fetchUserEmail() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found")
            return
        }
        
        self.userEmail = currentUser.email ?? "No email"
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
