//
//  AddView.swift
//  iExpense
//
//  Created by Channabasavesh Chandrappa Budihal on 2/8/21.
//

import SwiftUI

struct AddView: View {
    
    @State private var name = ""
    @State private var amount = ""
    @State private var type = "Personal"
    
    @State private var showingAlert = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    static let types = ["Business", "Personal"]
    
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
            }
            .alert(isPresented: $showingAlert) { () -> Alert in
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(trailing: Button("Save", action: {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    showingAlert = true
                    errorTitle = "Sorry"
                    errorMessage = "You need to enter the amount in numbers"
                }
            }))
            .navigationBarTitle("Add new expense")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
