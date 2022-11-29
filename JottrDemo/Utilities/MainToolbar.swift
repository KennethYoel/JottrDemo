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
                Label("New Page", systemImage: "square.and.pencil")
            })
                .buttonStyle(.plain)
                .padding(.trailing)
            
            Button(action: { isShowingAccount.toggle() }, label: { Label("Account", systemImage: "gear") })
                .buttonStyle(.plain)
                .padding(.trailing)
        }
    }
}
