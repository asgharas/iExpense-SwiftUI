//
//  Expenses.swift
//  iExpense
//
//  Created by Asghar on 7/30/23.
//

import Foundation


class Expenses: ObservableObject {
    
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
    
    func loadExpenses(filteredType: Types) -> [ExpenseItem] {
        return items.filter { $0.type == filteredType.rawValue }
    }
    
    func sessionTitle(type: Types) -> String {
        return loadExpenses(filteredType: type == .personal ? .personal : .business).isEmpty ? "" : type.rawValue
    }
    
    func removeItem(indexSet: IndexSet, loadExpenses: [ExpenseItem]) {
        var uuids = [UUID]()
        
        for index in indexSet {
            uuids.append(loadExpenses[index].id)
        }
        
        if let itemIndex = items.firstIndex(where: { $0.id == uuids[0] }) {
            items.remove(at: itemIndex)
        }
    }
}
