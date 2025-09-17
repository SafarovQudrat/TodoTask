import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = "https://jsonplaceholder.typicode.com"

    func fetchTodosAndUsers(completion: @escaping (Result<[TodoTask], APIError>) -> Void) {
        let todosURL = URL(string: "\(baseURL)/todos")!
        let usersURL = URL(string: "\(baseURL)/users")!

        let group = DispatchGroup()
        var todos: [Todo]?
        var users: [User]?
        var fetchError: APIError?

        group.enter()
        URLSession.shared.dataTask(with: todosURL) { data, response, error in
            defer { group.leave() }
            if let error = error {
                fetchError = .requestFailed(error)
                return
            }
            guard let data = data else {
                fetchError = .invalidResponse
                return
            }
            do {
                todos = try JSONDecoder().decode([Todo].self, from: data)
            } catch {
                fetchError = .decodingError(error)
            }
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: usersURL) { data, response, error in
            defer { group.leave() }
            if let error = error {
                fetchError = .requestFailed(error)
                return
            }
            guard let data = data else {
                fetchError = .invalidResponse
                return
            }
            do {
                users = try JSONDecoder().decode([User].self, from: data)
            } catch {
                fetchError = .decodingError(error)
            }
        }.resume()

        group.notify(queue: .main) {
            if let err = fetchError {
                completion(.failure(err))
                return
            }
            guard let todos = todos, let users = users else {
                completion(.failure(.invalidResponse))
                return
            }
            // Map users by id
            let userById = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
            // Combine
            let combined: [TodoTask] = todos.compactMap { todo in
                guard let user = userById[todo.userId] else { return nil }
                return TodoTask(todo: todo, user: user)
            }
            completion(.success(combined))
        }
    }
}

