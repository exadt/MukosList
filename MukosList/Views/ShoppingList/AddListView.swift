//
//  AddLocationView.swift
//  MukosList
//
//  Created by Mayuko Inoue on 5/10/20.
//  Copyright © 2020 Mayuko Inoue. All rights reserved.
//

import SwiftUI

struct AddListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @State var listName = ""
    @Binding var isShowingNewListFlow: Bool
    
    var dataManager = ShoppingListDataManager()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }.padding(.leading, 28)
                    Spacer()
                    Text("New List")
                    .font(.title)
                    .foregroundColor(Color("medium_gray"))
                    Spacer()
                    Text("")
                }.padding(.top, 28)
                Spacer()
                Text("Give your list a name")
                    .font(.headline)
                    .foregroundColor(Color("medium_gray"))
                    .padding(.bottom, 12.0)
                HStack {
                    TextField("Trader Joe's...", text: $listName, onEditingChanged: {_ in
                        print("added \(self.listName)")
                    }, onCommit: {
                        //Call update instead of add just in case we already
                        //have a list of the same name
                        self.dataManager.updateList(name: self.listName, context: self.managedObjectContext)
                    }).frame(height: 56.0).border(Color("light_gray"))
                }.padding(.horizontal, 16)
                NavigationLink(destination: ShoppingItemsView(isShowingNewListFlow: self.$isShowingNewListFlow, listName: listName).environment(\.managedObjectContext, self.managedObjectContext).onAppear(perform: {
                    self.dataManager.updateList(name: self.listName, context: self.managedObjectContext)
                }), label: {
                    Text("Done")
                })
                Spacer()
            }.navigationBarHidden(true).navigationBarTitle(Text("hiding!"))
        }
    }
}


struct AddListView_Previews: PreviewProvider {
    static var previews: some View {
        AddListView(isShowingNewListFlow: .constant(true))
    }
}
