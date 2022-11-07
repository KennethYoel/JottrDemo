//
//  EditorToolbar.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/7/22.
//

import CoreData
import Foundation
import SwiftUI

struct MainToolbar: ToolbarContent {
    // MARK: Properties
    
    @Binding var isShowingNewPage: Bool
    @Binding var isShowingAccount: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: { isShowingNewPage.toggle() }, label: {
                Label("New Story", systemImage: "square.and.pencil")
            })
                .buttonStyle(.plain)
            
            Button(action: { isShowingAccount.toggle() }, label: { Label("Account", systemImage: "ellipsis.circle") })
                .padding()
                .buttonStyle(.plain)
        }
    }
}
