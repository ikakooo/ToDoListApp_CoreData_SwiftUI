//
//  ToDOListWidgetBundle.swift
//  ToDOListWidget
//
//  Created by IKAKOOO on 28.01.23.
//

import WidgetKit
import SwiftUI

@main
struct ToDOListWidgetBundle: WidgetBundle {
    var body: some Widget {
        ToDOListWidget()
        
        if #available(iOSApplicationExtension 16.1, *) {
            ToDOListWidgetLiveActivity()
        } 
    }
}
