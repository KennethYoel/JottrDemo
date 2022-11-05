//
//  FilteredList.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/9/22.
//

import CoreData
import Foundation
import SwiftUI

enum Comparator {
    case equal, lessThan, greaterThan, inTheList, contains, beginsWith
    case containsCaseInsensitive(String)

    func stringComparisons() -> String {
        switch self {
        case .equal:
            return "=="
        case .lessThan:
            return "<"
        case .greaterThan:
            return ">"
        case .inTheList:
            return "IN"
        case .contains:
            return "CONTAINS"
        case .beginsWith:
            return "BEGINSWITH"
        case .containsCaseInsensitive(let ignoreCase):
            return "CONTAINS[\(ignoreCase)]"
        }
    }
}

// generic FetchRequest filter
struct FilteredList<T: NSManagedObject, Content: View>: View {
    /*
     We can loop over the fetch request inside the body. However, we don’t create the fetch request
     here, because we still don’t know what we’re searching for. Instead, we’re going to create a
     custom initializer that accepts a filter string and uses that to set the fetchRequest property.
     */
    
    // store the fetchRequest
    @FetchRequest var fetchRequest: FetchedResults<T>
    // content closure that will accept a T and return some Content
    let content: (T) -> Content
    @Binding var isSearching: Bool
    
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }
    
    init(sortKey: String, orderByAscending: Bool, isSearching: Binding<Bool>, filterKey: String, filterBy: Comparator, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        // sort descriptors for, well sorting the data
        let sort = NSSortDescriptor(key: sortKey, ascending: orderByAscending)
        
        // the predicate for searching for the data
        _isSearching = isSearching
        // TODO: need to add a space value in stringComparison, app crashes with space inluded
        let comparison = filterBy.stringComparisons()
        var nsPredicate: NSPredicate?
        // getting underlying value referenced by the binding variable
        if isSearching.wrappedValue {
            nsPredicate = NSPredicate(format: "%K \(comparison) %@", filterKey, filterValue)
        } else {
            nsPredicate = nil
        }
        
        /*
         Did you notice how there’s an underscore at the start of _fetchRequest? That’s intentional.
         You see, we’re not writing to the fetched results object inside our fetch request, but
         instead writing a wholly new fetch request. Allow us to poke around the actual fetchRequest object and not the
         fetchResult inside it.
         */
        _fetchRequest = FetchRequest<T>(sortDescriptors: [sort], predicate: nsPredicate, animation: .easeOut)
        
//        request.fetchLimit = 10
//        _fetchRequest = FetchRequest<T>(fetchRequest: request)
        
        self.content = content
    }
}
