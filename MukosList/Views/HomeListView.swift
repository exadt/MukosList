//
//  HomeListView.swift
//  MukosList
//
//  Created by Mayuko Inoue on 5/15/20.
//  Copyright © 2020 Mayuko Inoue. All rights reserved.
//

import SwiftUI

struct HomeListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: ShoppingList.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ShoppingList.lastUpdated, ascending: false),
        ]
    ) var shoppingLists: FetchedResults<ShoppingList>
    
    @State var presentAddItemView = false
    @State var navigationBarHidden = true
    let greyColor = Color("gray_medium")
    let dataManager = ShoppingListDataManager()

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("Table")
                        .foregroundColor(Color("orange"))
                        .font(.system(size:90, weight:.bold, design:.default))
                        .tracking(20)
                        .opacity(0.2)
                        .padding(.top, 30)
                        .padding(.leading, -20)
                    Spacer()
                    Circle()
                        .foregroundColor(Color("orange"))
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding(.top, 85)
                        .padding(.trailing, 15)
                }
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Welcome Back")
                            .font(.system(size: 36.0, weight: .bold, design: .default))
                        Group {
                            if(shoppingLists.count > 0) {
                                Text("Lists updated at \(shoppingLists.first?.lastUpdated?.timeStampString ?? "some time")").foregroundColor(Color("gray_mediumDark"))
                            }
                        }
                    }.padding(.leading, 24)
                    Spacer()
                    Circle()
                        .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding(.trailing, 24)
                }.background(Color.clear).padding(.top, 100)
            }
            
            HStack {
                SearchButton()
                Spacer()
                Button(action: {
                    //edit options
                }) {
                    Image("filter")
                }.buttonStyle(PlainButtonStyle())
            }.padding(.horizontal, 24).padding(.top, 34).padding(.bottom, 24)
            CreateListButton().environment(\.managedObjectContext, self.managedObjectContext).padding(.horizontal, 16)
            Spacer()
            
            List {
                ForEach(shoppingLists, id: \.self) { shoppingList in
                    ListCell(presentAddItemView: self.$presentAddItemView, list: shoppingList).environment(\.managedObjectContext, self.managedObjectContext)
                }
                .onDelete(perform: deleteList(at:))
            }

        }.onAppear {
            self.navigationBarHidden = true
        }
        .background(Color("gray_veryLight"))
        .edgesIgnoringSafeArea(.top)
    }
    
    func deleteList(at offsets: IndexSet) {
        for index in offsets {
            let shoppingList = self.shoppingLists[index]
            self.dataManager.deleteList(shoppingList, context: self.managedObjectContext)
        }
    }
}

struct HomeListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return HomeListView().environment(\.managedObjectContext, context)
    }
}
