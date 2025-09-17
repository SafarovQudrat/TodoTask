# TodoApp - UIKit (Programmatic) Example

### Vazifa
Mock API (https://jsonplaceholder.typicode.com/) dan todos va users ni yuklab olib, UIKit bilan programmatik UI orqali:
- Local pagination: 20 item / page
- Har cellda todo.title va user.name ko‘rsatiladi
- Details sahifasida todo va user haqidagi barcha ma’lumotlar
- Search bar: title yoki user name bo‘yicha filter
- Caching JSON faylga saqlanadi: offline holatda cache ko‘rsatiladi

### How to run
1. Xcode (14+) da yangi iOS project (App, UIKit) yarat.
2. Fayllarni loyihaga qo‘shing (`Models`, `Networking`, `Persistence`, `Views`, `Controllers` kataloglari).
3. `SceneDelegate.swift` ichida rootViewController ni `TodosViewController()` ga sozlang (kodsampel README ichida).
4. Build & Run.

### Important
- API: https://jsonplaceholder.typicode.com/todos va /users
- Cache: `Documents/todos_cache.json`
- Pagination: client-side — birinchi chaqirishda barcha 200 todo olinadi, lekin UI faqat 20 tadan yuklab ko‘rsatadi; pastga scroll qilinganda navbatdagi sahifalar yuklanadi.
