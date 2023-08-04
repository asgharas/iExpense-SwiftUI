//
//  ContentView.swift
//  iExpense
//
//  Created by Asghar on 6/28/23.
//

import SwiftUI


struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    func getItemCostColor(cost: Double) -> Color  {
        if cost <= 10 {
            return .green
        } else if cost > 10 && cost < 100 {
            return .yellow
        } else {
            return .red
        }
    }
    
    
    var body: some View {
        NavigationView {
            List{
                ForEach(Types.allCases, id: \.self) { type in
                    Section(expenses.sessionTitle(type: type)) {
                        ItemsView(expenses: expenses, type: type)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
}

struct ItemsView: View {
    @ObservedObject var expenses: Expenses
    
    let type: Types
    
    var loadExpenses: [ExpenseItem] {
        expenses.loadExpenses(filteredType: type ==  .personal ? .personal : .business)
    }
    
    var body: some View {
        ForEach(loadExpenses) { expense in
            HStack {
                Text(expense.name)
                    .font(.title2)
                
                Spacer()
                
                Text(expense.cost, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .costStyle(cost: expense.cost)
            }
        }
        .onDelete { IndexSet in
            expenses.removeItem(indexSet: IndexSet, loadExpenses: loadExpenses)
        }
    }
}

struct CostStyleModifier: ViewModifier {
    var cost: Double
    
    func body(content: Content) -> some View {
        if cost <= 10 {
            content
                .foregroundColor(.green)
        } else if cost > 10 && cost <= 100 {
            content
                .foregroundColor(.orange)
        } else {
            content
                .foregroundColor(.red)
        }
    }
}

extension View {
    func costStyle(cost: Double) -> some View {
        modifier(CostStyleModifier(cost: cost))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
