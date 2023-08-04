//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Asghar on 7/30/23.
//

import Foundation

enum Types: String, CaseIterable {
    case personal = "Personal"
    case business = "Business"
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type:String
    let cost: Double
}
