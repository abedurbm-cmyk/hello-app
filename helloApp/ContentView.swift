import SwiftUI

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
}

struct ContentView: View {
    @State private var posts: [Post] = []
    @State private var message = ""

    var body: some View {
        NavigationStack {
            List {
                Section { Text("Hello World").font(.largeTitle) }
                if !message.isEmpty {
                    Text(message).foregroundStyle(.red)
                }
                Section("Posts") {
                    ForEach(posts) { Text($0.title) }
                }
            }
            .navigationTitle("Hello API")
            .toolbar { Button("Reload") { Task { await load() } } }
            .task { await load() }
        }
    }

    func load() async {
        do {
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_limit=5")!
            let (data, _) = try await URLSession.shared.data(from: url)
            posts = try JSONDecoder().decode([Post].self, from: data)
            message = ""
        } catch {
            message = error.localizedDescription
        }
    }
}