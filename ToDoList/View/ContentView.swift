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
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
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
                        
                        HStack {
                            // TITLE
                            Text("Just Do It!")
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.heavy)
                                .padding()
                            Spacer()
                            // EDIT BUTTON
                            EditButton()
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 10)
                                .frame(minWidth: 70, minHeight: 24)
                                .background(Capsule().stroke(Color.white, lineWidth: 2))
                            // Appearence Button
                            Button(action: {
                                isDarkMode.toggle()
                            }, label: {
                                Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .font(.system(.title, design: .rounded))
                            })
                            .padding()
                        }
                        .foregroundColor(.white)
                        
                        Spacer(minLength: 30)
                        Button(action: {
                            showNewTaskItem = true
                        }, label: {
                            Spacer()
                            HStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                Spacer()
                                    .frame(maxWidth: 20)
                                Text("ADD TASK")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                            }
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                .clipShape(Capsule())
                            )
                            .cornerRadius(10)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12, x: 0.0, y: 4.0)
                            Spacer()
                        })
                        
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
                    
                    if showNewTaskItem {
                        BlankView()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showNewTaskItem = false
                            }
                        
                        NewTaskItemView( showNewTaskItem: $showNewTaskItem)
                        
                    }
                    
                } //: ZSTACK
                .onAppear(){
                    UICollectionView.appearance().backgroundColor = .clear
                }
                .navigationBarTitle("Just Do It!", displayMode: .large)
                .navigationBarHidden(true)
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
