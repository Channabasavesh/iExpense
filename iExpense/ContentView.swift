//
//  ContentView.swift
//  iExpense
//
//  Created by Channabasavesh Chandrappa Budihal on 2/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView {
            List {
                ForEach (expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
                .onDelete(perform: { indexSet in
                    self.removeExpenseItems(at: indexSet)
                })
            }
            .sheet(isPresented: $showingAddExpense, content: {
                AddView(expenses: self.expenses)
            })
            .navigationBarItems(leading: Button(action: {
                self.showingAddExpense = true
            }, label: {
                Image(systemName: "plus")
            }), trailing: EditButton())
            .navigationBarTitle("iExpense")
        }
    }
    
    func removeExpenseItems(at offsets: IndexSet) {
        self.expenses.items.remove(atOffsets: offsets)
    }
}

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    var type: String
    var amount: Int
}

class Expenses: ObservableObject {
    @Published var items : [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(items) {
                UserDefaults.standard.set(data, forKey: "Items")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let expenseItems = try? decoder.decode([ExpenseItem].self, from: data) {
                self.items = expenseItems
                return
            }
        }
        self.items = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
