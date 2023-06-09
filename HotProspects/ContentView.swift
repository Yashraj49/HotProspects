//
//  ContentView.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 01/05/23.
//

// @Envireonmet works just like dictionary ie keya value pairs

import SwiftUI
import UserNotifications

enum contactStatus {
    case Contacted
    case Uncontacted
}



struct ContentView: View {
        
    
    @StateObject var prospects = Prospects()
    
    
    var body: some View {
        
    
        
        TabView{
            ProspectsView(filter: .none)
                .tabItem{
                    Label("Everyone" , systemImage: "person.3")
                  
                        }
                
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                        
                       
                        
                }.foregroundColor(.green)
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                      
                }
                .foregroundColor(.red)
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
            }
                
        }.environmentObject(prospects)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


