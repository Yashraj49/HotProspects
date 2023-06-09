//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 06/05/23.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum SortType {
    case name, recent
}

struct ProspectsView: View {
    @State private var isShowingScanner = false
    @State private var isShowingSortOptions = false
     @State var sort: SortType = .name
    

    /// Important: When you use @EnvironmentObject you are explicitly telling SwiftUI that your object will exist in the environment by the time the view is created. If it isn’t present, your app will crash immediately – be careful, and treat it like an implicitly unwrapped optional.
    
    
    @EnvironmentObject var prospects: Prospects
    
 
    func handleScan(result : Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            
///            As for the problem of calling save(), this is actually a deeper problem: when we write code like prospects.people.append(person) we’re breaking a software engineering principle known as encapsulation. This is the idea that we should limit how much external objects can read and write values inside a class or a struct, and instead provide methods for reading (getters) and writing (setters) that data
            
            prospects.add(person)
            
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    let filter : FilterType
    
    var title : String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
  

    
///    When filter() runs, it passes every element in the people array through our test. So, $0.isContacted means “does the current element have its isContacted property set to true?” All items in the array that pass that test – that have isContacted set to true – will be added to a new array and sent back from filteredResults. And when we use !$0.isContacted we get the opposite: only prospects that haven’t been contacted get included.
    
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }

    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(filteredSortedProspects) { prospect in
                        VStack(alignment: .leading) {
                            HStack{
                                Text(prospect.name)
                                    .font(.headline)
                                Spacer()
                                if prospect.isContacted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted", systemImage: prospect.isContacted ? "person.crop.circle.badge.xmark" : "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(prospect.isContacted ? .blue : .green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button(action: {
                    isShowingScanner = true
                }) {
                   
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Yashraj Jadhav\nyashrajjadhav@gmail.com" , completion: handleScan)
                }
                .actionSheet(isPresented: $isShowingSortOptions) {
                    ActionSheet(title: Text("Sort by"), buttons: [
                        .default(Text((self.sort == .name ? "✓ " : "") + "Name"), action: { self.sort = .name }),
                        .default(Text((self.sort == .recent ? "✓ " : "") + "Most recent"), action: { self.sort = .recent }),
                    ])
                }}
                .navigationBarTitle(title)
                .navigationBarItems(leading: Button("Sort") {
                        self.isShowingSortOptions = true
                    }, trailing: Button(action: {
                        self.isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    }
)
            
        }
    }
    
    typealias SortComparator<T> = (T, T) -> Bool
    
    var filteredSortedProspects: [Prospect] {
        switch sort {
        case .name:
            return filteredProspects.sorted(by: { (prospect1: Prospect, prospect2: Prospect) -> Bool in
                prospect1.name < prospect2.name
            })
        case .recent:
            return filteredProspects.sorted(by: { (prospect1: Prospect, prospect2: Prospect) -> Bool in
                prospect1.date > prospect2.date
            })
      
        }
        
    }

}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
