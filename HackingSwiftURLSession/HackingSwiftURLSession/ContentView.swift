//
//  ContentView.swift
//  HackingSwiftURLSession
//
//  Created by Daniel Watson on 23/06/2021.
//

import SwiftUI

struct Item: Codable, Hashable {
    var name: String
    var kind: String
}

class ContentModel: ObservableObject {
    
    @Published var items = [Item]()
    
    init() {
        loadData { (items) in
            self.items = items
        }
    }
    func loadData(completion: @escaping([Item]) ->()) {
        guard let url = URL(string: "https://9aff5edb7c63.ngrok.io/iPhoneMySql/service.php") else {
            print("Invalid url")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let posts = try! JSONDecoder().decode([Item].self, from: data!)
            
            DispatchQueue.main.async {
                completion(posts)
            }
        }.resume()
    }
}

struct ContentView: View {
    
    @StateObject var VM = ContentModel()
    
    var body: some View {
        List(VM.items, id:\.self) { item in
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.kind )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
