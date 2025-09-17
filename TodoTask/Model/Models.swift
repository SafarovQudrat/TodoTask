import UIKit

struct Todo:Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

struct User:Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address?
    var phone: String
    var website: String
    var company: Company?
}

struct Address: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo?
}
struct Geo:Codable {
    var lat: String
    var lng: String
}

struct Company:Codable {
    var name: String
    var catchPhrase: String
    var bs: String
}

struct TodoTask: Codable {
    var todo:Todo
    var user: User
}

extension UsersCD {
    var asUser: User {
        return User(
            id: Int(self.id),
            name: self.name ?? "",
            username: self.username ?? "",
            email: self.email ?? "",
            phone: self.phone ?? "",
            website: self.website ?? ""
        )
    }
}

extension TodoCD {
    var asTodo: Todo {
        return Todo(
            userId: Int(self.id),
            id: Int(self.userID),
            title: self.title ?? "",
            completed: self.complated
        )
    }
}

