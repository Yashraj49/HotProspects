//
//  Prospect.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 06/05/23.
//

/// SwiftUI’s environment lets us share data in a really beautiful way: any view can send objects into the environment, then any child view can read those objects back out from the environment at a later date. Even better, if one view changes the object all other views automatically get updated – it’s an incredibly smart way to share data in larger applications.

import SwiftUI



///that’s a class rather than a struct. This is intentional, because it allows us to change instances of the class directly and have it be updated in all other views at the same time. Remember, SwiftUI takes care of propagating that change to our views automatically, so there’s no risk of views getting stale.

class Prospect : Identifiable , Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
   fileprivate (set) var isContacted = false
   
}

@MainActor class Prospects : ObservableObject {

    /// we can use access control to stop external writes to the people array, meaning that our views must use the add() method to add prospects
    
    @Published private(set) var people : [Prospect]
    let saveKey = "SaveData"
  //*  This time our data is stored using a slightly easier format: although the Prospects class uses the @Published property wrapper, the people array inside it is simple enough that it already conforms to Codable just by adding the protocol conformance. So, we can get most of the way to our goal by making three small changes:
     
    /* Updating the Prospects initializer so that it loads its data from UserDefaults where possible.
     Adding a save() method to the same class, writing the current data to UserDefaults.
     Calling save() when adding a prospect or toggling its isContacted property.*/
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }

        people = []
    }
    
   private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
//    In practical terms, this means rather than writing prospects.people.append(person) we’d instead create an add() method on the Prospects class, so we could write code like this: prospects.add(person). 
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}