import UIKit
import CoreData

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTodoAndUser(todo: Todo, user: User) {
        let fetchRequestUser: NSFetchRequest<UsersCD> = UsersCD.fetchRequest()
        fetchRequestUser.predicate = NSPredicate(format: "id == %d", user.id)
        let fetchRequestTodo: NSFetchRequest<TodoCD> = TodoCD.fetchRequest()
        fetchRequestTodo.predicate = NSPredicate(format: "id == %d", todo.id)
        
        if let existing = try? context.fetch(fetchRequestUser), !existing.isEmpty {
            return // allaqachon saqlangan
        }
        if let existing = try? context.fetch(fetchRequestTodo), !existing.isEmpty {
            return // allaqachon saqlangan
        }
        guard let userEntity = NSEntityDescription.entity(forEntityName: "UsersCD", in: context) else {return}
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "TodoCD", in: context) else {return}
        let todoCD = TodoCD(entity: todoEntity, insertInto: context)
        let userCD = UsersCD(entity: userEntity, insertInto: context)
        todoCD.id = Int64(todo.id)
        todoCD.complated = todo.completed
        todoCD.title = todo.title
        
        userCD.email = user.email
        userCD.id = Int64(user.id)
        userCD.name = user.name
        userCD.phone = user.phone
        userCD.username = user.username
        userCD.website = user.website
        appDelegate.saveContext()
    }
    
    func fetchTodo() -> [TodoTask] {
        let request1: NSFetchRequest<TodoCD> = TodoCD.fetchRequest()
        let request2: NSFetchRequest<UsersCD> = UsersCD.fetchRequest()
        
        do {
            let todoData = try context.fetch(request1)
            let userData = try context.fetch(request2)
            
            let userById = Dictionary(uniqueKeysWithValues: userData.map { ($0.id, $0.asUser) })
            
            let todoTask: [TodoTask] = todoData.compactMap { data -> TodoTask? in
                guard let user = userById[data.userID] else { return nil }
                return TodoTask(todo: data.asTodo, user: user)
            }
            
            return todoTask
        } catch {
            print("❌ Error fetching posts: \(error.localizedDescription)")
            return []
        }
    }


    
    
}
