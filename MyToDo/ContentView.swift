//
//  ContentView.swift
//  MyToDo
//
//  Created by João Moreira on 14/06/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var toDoItem: ToDoItem?
    @Query(
        filter: #Predicate { $0.isCompleted == false },
        sort: \.timestamp,
        order: .forward
    ) private var items: [ToDoItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            
                            if item.isCritical {
                                Image(systemName: "exclamationmark.3")
                                    .symbolVariant(.fill)
                                    .foregroundColor(.red)
                                    .font(.largeTitle)
                                    .bold()
                            }
                            
                            Text(item.title)
                                .font(.largeTitle)
                                .bold()
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                            }
                        
                        } label: {
                            
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundColor(item.isCompleted ? .green : .gray)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            
                            withAnimation {
                                context.delete(item)
                            }
        
                        } label: {
                        Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }

                        Button {
                            toDoItem = item
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("My To Do List")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showCreate.toggle(
                            )
                        }, label: {
                        Label("Add Item", systemImage: "plus")
                        })
                    }
                }
                .sheet(isPresented: $showCreate, content: {
                    NavigationStack {
                        CreateTodoView()
                    }
                    .presentationDetents([.medium])
                })
                .sheet(item: $toDoItem) {
                    toDoItem = nil
                } content: { item in
                    UpdateToDoView(item: item)
                }
        }
    }
}
    
#Preview {
    ContentView()
}
