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
//struct ContentView: View {
//    @State private var showingSheet = false
    
//    @State private var numbers = [Int]()
//    @State private var currentNumber = 1
//    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
//    var body: some View {
//        Button("Tap Count: \(tapCount)") {
//            self.tapCount += 1
//            UserDefaults.standard.set(self.tapCount, forKey: "Tap")
//        }
//    }
    
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(numbers, id: \.self) {
//                        Text("\($0)")
//                    }
//                    .onDelete(perform: { indexSet in
//                        self.removeRows(at: indexSet)
//                    })
//                }
//
//                Button("Add Number") {
//                    self.numbers.append(self.currentNumber)
//                    self.currentNumber += 1
//                }
//            }
//            .navigationBarItems(leading: EditButton())
//        }
//
//    }
//
//    func removeRows(at offsets: IndexSet) {
//        numbers.remove(atOffsets: offsets)
//    }
    
//    var body: some View {
//        Button("Show Sheet") {
//            self.showingSheet.toggle()
//        }
//        .sheet(isPresented: $showingSheet, content: {
//            SecondView(name: "Channabasavesh")
//        })
//    }
//    @ObservedObject var user = User()
//    var body: some View {
//        VStack {
//            Text("Your name is \(user.firstName) \(user.lastName).")
//            TextField("First name", text: $user.firstName)
//            TextField("Second name", text: $user.lastName)
//        }
//    }
    
//    @State private var user = User(firstName: "Taylor", lastName: "Swift")
//
//    var body: some View {
//        Button("Save User") {
//            let encoder = JSONEncoder()
//            if let data = try? encoder.encode(self.user) {
//                UserDefaults.standard.set(data, forKey: "UserData")
//            }
//        }
//    }
//}

//struct User: Codable{
//    var firstName: String
//    var lastName: String
//}

//class User: ObservableObject {
//    @Published var firstName = "Bilbo"
//    @Published var lastName = "Baggins"
//}

//struct SecondView: View {
//    var name: String
//    @Environment (\.presentationMode) var presentationMode
//    var body: some View {
//        Button("Dismiss") {
//            self.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
