//
//  ContentView.swift
//  ToWatch
//
//  Created by Sharma McGavin on 03/03/2023.
//

import SwiftUI

enum Category: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    
    case movie = "Movie"
    case documentary = "Documentary"
    case series = "Series"
}

extension Category {
    var title: String {
        switch self {
        case .movie:
            return "Movies"
            
        case .series:
            return "Series"
            
        case .documentary:
            return "Documentary"
        }
    }
}

struct ContentView: View {
    @State private var title: String = ""
    @State private var selectedCategory: Category = .movie
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTasks: FetchedResults<Task>
    
    private func saveTask() {
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.category = selectedCategory.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func styleForCategory(_ value: String) -> Color {
        let category = Category(rawValue: value)
        
        switch category {
        case .movie:
            return Color.red
            
        case .series:
            return Color.green
            
        case .documentary:
            return Color.orange
            
        default:
            return Color.black
        }
        
    }
    
    private func updateTask(_ task: Task) {
        task.isFavorite = !task.isFavorite
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = allTasks[index]
            viewContext.delete(task)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter title:", text: $title)
                    //.border(Color.orange)
                    .textFieldStyle(.roundedBorder)
                    
                Picker("Category", selection: $selectedCategory) {
                    ForEach(Category.allCases) { category in
                        Text(category.title).tag(category)
                    }
                }.pickerStyle(.segmented)
                
                Button("Save") {
                    saveTask()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Circle()
                                .fill(styleForCategory(task.category!))
                                .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavorite ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .foregroundColor(.orange)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    }.onDelete(perform: deleteTask)
                }
                
                Spacer()
            }
            
            .padding()
            .navigationTitle("What To Watch?")
        }
        .environment(\.colorScheme, .dark)
    }
    

}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistentContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
    }
}
