
import Foundation

class Pet {
    let name: String
    let ownerEmail: String
    let age: String
    let race: String
    let color: String
    let medical: String
    let lastVisit: String
    
    
    init(name: String, ownerEmail: String, age: String, race: String, color: String, medical: String, lastVisit: String) {
        self.name = name
        self.ownerEmail = ownerEmail
        self.age = age
        self.race = race
        self.color = color
        self.medical = medical
        self.lastVisit = lastVisit
    }
}
