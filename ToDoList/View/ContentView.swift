//
//  ContentView.swift
//  ToDoList
//
//  Created by IKAKOOO on 18.01.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    init() {
        UICollectionView.appearance().backgroundColor = .clear
        UICollectionReusableView.appearance().backgroundColor = .clear
    }
    
    // MARK: - PROPERTIES
    
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTIONS
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.task = task
    //            newItem.timestamp = Date()
    //            newItem.completion = false
    //            newItem.id = UUID()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                
                ZStack {
                    VStack {
                        
                        Button(action: {
                            showNewTaskItem = true
                        }, label: {
                            Spacer()
                            HStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                Spacer()
                                    .frame(maxWidth: 20)
                                Text("ADD TASK")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                            }
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(Color(UIColor.green).cornerRadius(10))
                            Spacer()
                        })
                        
                        
                        
                        //                    VStack(spacing: 16){
                        //                        TextField("New Task", text: $task)
                        //                            .padding()
                        //                            .background(Color(UIColor.systemGray6))
                        //                            .cornerRadius(10)
                        //                        Button(action: {
                        //                            addItem()
                        //                            task = ""
                        //                            hideKeyboard()
                        //                        }, label: {
                        //                            Spacer()
                        //                            Text("SAVE")
                        //                            Spacer()
                        //                        })
                        //                        .padding()
                        //                        .disabled(isButtonDisabled)
                        //                        .font(.headline)
                        //                        .foregroundColor(.white)
                        //                        .background(isButtonDisabled ? Color.gray : Color.pink)
                        //                        .cornerRadius(8)
                        //                    } //: VStack
                        //                    .padding()
                        
                        List {
                            ForEach(items) { item in
                                NavigationLink(destination: {
                                    
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    
                                }){
                                    VStack {
                                        Text(item.task ?? "")
                                            .font(.headline)
                                        Text(item.timestamp!, formatter: itemFormatter)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    } //: VStack
                                }
                                // .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteItems)
                            
                        } //: LIST
                        .listStyle(InsetGroupedListStyle())
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                    } //: VStack
                    
                } //: ZSTACK
                .onAppear(){
                    UICollectionView.appearance().backgroundColor = .clear
                }
                .navigationBarTitle("Daily Tasks", displayMode: .large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                } //: toolbar
                .background(
                    BackgroundImageView()
                )
                .background(
                    backgroundGradient.ignoresSafeArea(.all)
            )
                if showNewTaskItem {
                    NewTaskItemView( showNewTaskItem: $showNewTaskItem)
                        .background(Color.black.ignoresSafeArea(.all).opacity(0.75))
                }
            } //: ZSTACK
            
        } //: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
