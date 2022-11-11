//
//  TrashListDetailView.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 11/11/22.
//

import Foundation
import SwiftUI

struct TrashListDetailView: View {
    // MARK: Properties
    
    // data stored in the Core Data
    let trash: TrashBin
    
    var body: some View {
        Text(trash.origin?.complStory ?? "Unknown")
    }
}

//struct TrashListDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrashListDetailView()
//    }
//}
