//
//  ViewColorExtension.swift
//  ToDoList
//
//  Created by IKAKOOO on 22.01.23.
//

import SwiftUI

extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }

        // default separators use same color as background
        // so to have it same but new (say red) it can be
        // used as below, otherwise we just need custom separators
        //
        // set { super.backgroundColor = .red }

    }
}
