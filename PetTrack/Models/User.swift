
import Foundation

class User  {
    let email: String
    let firstName: String?
    let lastName: String?
    let userType: String?
    let vetEmail: String?
    
    init(firstName: String, lastName: String, userType: String, email: String, vetEmail: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userType = userType
        self.email = email
        self.vetEmail = vetEmail
    }
}
