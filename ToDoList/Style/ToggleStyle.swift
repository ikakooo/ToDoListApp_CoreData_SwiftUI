//
//  ToggleStyle.swift
//  ToDoList
//
//  Created by IKAKOOO on 27.01.23.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
            Button {
                configuration.isOn.toggle()
                
                if configuration.isOn {
                    playSound(sound: "sound-rise")
                    feedback.notificationOccurred(.success)
                } else {
                    playSound(sound: "sound-tap")
                }
                
            } label: {
                Label {
                    configuration.label
                } icon: {
                    Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(configuration.isOn ? .pink : .primary)
                        .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                        .imageScale(.large)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
}

struct ToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle(isOn: .constant(true), label: {
            Text("ikakooo's Task")
        })
        .padding()
        .toggleStyle(CheckToggleStyle())
        .previewLayout(.sizeThatFits)
    }
}
