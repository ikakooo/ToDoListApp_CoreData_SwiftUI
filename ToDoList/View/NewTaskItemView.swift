//
//  NewTaskItemView.swift
//  ToDoList
//
//  Created by IKAKOOO on 23.01.23.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - PROPERTIES
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @Binding var showNewTaskItem: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.task = task
            newItem.timestamp = Date()
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
                showNewTaskItem = false
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    var body: some View {
        VStack {
          Spacer()
                
            VStack(spacing: 16){
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                Button(action: {
                    addItem()
                    task = ""
                    hideKeyboard()
                    playSound(sound: "sound-ding")
                    feedback.notificationOccurred(.success)
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                })
                .padding()
                .disabled(isButtonDisabled)
                .onTapGesture {
                    if isButtonDisabled {
                        playSound(sound: "sound-tap")
                    }
                }
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(8)
            } //: VStack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        }
        .padding()
        
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    @State static var showNewTaskItem: Bool = true
    
    static var previews: some View {
        NewTaskItemView(showNewTaskItem: $showNewTaskItem)
    }
}
