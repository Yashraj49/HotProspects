//
//  SwiftUIView.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 02/05/23.
//

//import SwiftUI
//
//struct practice: View {
//    @State private var output = ""
//
//
//    var body: some View {
//        Text(output)
//            .task {
//                await fetchReadings()
//            }
//    }
//
//
//    ///    That code works just fine, but it doesn’t give us a lot of flexibility – what if we want to stash the work away somewhere and do something else while it’s running? What if we want to read its result at some point in the future, perhaps handling any errors somewhere else entirely? Or what if we just want to cancel the work because it’s no longer needed?
//    //
//    ///   Well, we can get all that by using Result, and it’s actually available through an API you’ve met previously: Task.
//    //
//    func fetchReadings() async {
//
//
//
//        let fetchTask = Task { () -> String in
//            let url = URL(string: "https://hws.dev/readings.json")!
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let readings = try JSONDecoder().decode([Double].self, from: data)
//            return "Found \(readings.count) readings"
//
//
//        }
//        let result = await fetchTask.result
//
//        switch result {
//            case .success(let str):
//                output = str
//            case .failure(let error):
//                output = "Error: \(error.localizedDescription)"
//        }
//
//    }
//}
//
//
//struct practic_Previews: PreviewProvider {
//    static var previews: some View {
//        practice()
//        practiceX()
//    }
//}
//
////Controlling image interpolation in SwiftUI
//
//struct practiceX: View {
//
//    var body: some View {
//        Image("example")
//            .interpolation(.none)
//            .resizable()
//            .scaledToFit()
//            .frame(maxHeight:.infinity)
//            .background()
//            .ignoresSafeArea()
//            }
//    }
//


//
//  ContentView.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 01/05/23.
//

// @Envireonmet works just like dictionary ie keya value pairs


//@MainActor class User : ObservableObject {
//    @Published var name = "Taylor Swift"
//}
  


//@MainActor class DelayedUpdater : ObservableObject {
//    var value = 0 {
//        willSet {
//            objectWillChange.send()
//        }
//    }

    ///    Now, if you remove the @Published property wrapper you’ll see the UI no longer changes. Behind the scenes all the asyncAfter() work is still happening, but it doesn’t cause the UI to refresh any more because no change notifications are being sent out.
    
    /// so if we do not wanna use publis or to be presize dont want to get relied on it We can fix this by sending the change notifications manually using the objectWillChange property I mentioned earlier. This lets us send the change notification whenever we want, rather than relying on @Published to do it automatically.


//        init() {
//            for i in 1...10 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                    self.value += 1
//                }
//            }
//        }
//    }

 //MARK: - old contentView stuff

//struct ContentView: View {
//    @StateObject var updater = DelayedUpdater()
//    @StateObject var user = User()
//    @State private var selectedTab = "One"
//
//    var body: some View {
//
//        VStack {
//            EditView()
//            DisplayView()
//        }
//        .environmentObject(user)
//        .padding(169)
//
//        TabView(selection: $selectedTab){
//            Text("Tab 1")
//                .onTapGesture {
//                    selectedTab = "Two"
//                }
//                .tabItem {
//                    Label("One", systemImage: "star")
//                }
//                .tag("one")
//
//           Text("Tab 2")
//                .tabItem {
//                    Image(systemName: "circle")
//                    Text("Two")
//                }
//                .tag("Two")
//
//
//        }
//        Text("value is \(updater.value)")
//    }
//}
//
//struct EditView : View {
//    @EnvironmentObject var user : User
//
//    var body: some View {
//        TextField("Name", text: $user.name)
//    }
//
//}
//
//struct DisplayView : View {
//    @EnvironmentObject var user : User
//
//    var body: some View {
//        Text(user.name)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}



//VStack {
//
//            List {
//                Text("Taylor Swift")
//                    .swipeActions{
//                        Button(role : .destructive) {
//                            print("hi")
//                        } label: {
//                            Label("Send message" , systemImage: "minus.circle")
//                        }
//                    }
//                    .swipeActions(edge: .leading) {
//                        Button {
//                            print("Hi")
//                        } label: {
//                            Label("Pin" , systemImage: "pin")
//                        }
//                        .tint(.orange)
//                    }
//            //    MoreLists()
//
//            }
//
//            Text("Hello, World!")
//                .padding()
//                .background(backgroundColor)
//
//            Text("Change Color")
//                .padding()
//                .contextMenu {
//                    Button("Red") {
//                        backgroundColor = .red
//                    }
//
//                    Button("Green") {
//                        backgroundColor = .green
//                    }
//
//                    Button("Blue") {
//                        backgroundColor = .blue
//                    }
//                }
//
//            Button(role: .destructive) {
//                backgroundColor = .red
//            } label: {
//                Label("Red", systemImage: "checkmark.circle.fill")
//            }
//
//            }
//        }
//    }
//
////struct MoreLists : View {
////    var body: some View {
////        Text("baba Swift")
////            .swipeActions{
////                Button(role : .destructive) {
////                    print("hi")
////                } label: {
////                    Label("Send message" , systemImage: "minus.circle")
////                }
////            }
////            .swipeActions(edge: .leading) {
////                Button {
////                    print("Hi")
////                } label: {
////                    Label("Pin" , systemImage: "pin")
////                }
////                .tint(.orange)
////            }
////
////
////        Text("nana Swift")
////            .swipeActions{
////                Button(role : .destructive) {
////                    print("hi")
////                } label: {
////                    Label("Send message" , systemImage: "minus.circle")
////                }
////            }
////            .swipeActions(edge: .leading) {
////                Button {
////                    print("Hi")
////                } label: {
////                    Label("Pin" , systemImage: "pin")
////                }
////                .tint(.orange)
////
////            }
////    }
////}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
//  ContentView.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 01/05/23.
//

// @Envireonmet works just like dictionary ie keya value pairs

//import SwiftUI
//import UserNotifications
//import SamplePackage
//
//struct ContentView: View {
//    ///    First, creating a range of numbers from 1 through 60 can be done by adding this property to ContentView    let possibleNumbers = Array(1...60)
//
//    let possibleNumbers = Array(1...60)
    
///   Second, we’re going to create a computed property called results that picks seven numbers from there and makes them into a single string, so add this property too
    
    
///    Inside there we’re going to select seven random numbers from our range, which can be done using the extension you got from my SamplePackage framework. This provides a random() method that accepts an integer and will return up to that number of random elements from your sequence, in a random order. Lottery numbers are usually arranged from smallest to largest, so we’re going to sort them

///   we need to convert that array of integers into strings. This only takes one line of code in Swift, because sequences have a map() method that lets us convert an array of one type into an array of another type by applying a function to each element. In our case, we want to initialize a new string from each integer, so we can use String.init as the function we want to call.
//
//    var results : String {
//        let selected = possibleNumbers.random(7).sorted()
//        let strings = selected.map(String.init)
//        return strings.joined(separator: ", ")
//    }
//
//    var body: some View {
//        Text(results)
//        VStack{
//            Button("Request Permission") {
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound]) { success, error in
//                    if success {
//                        print("All set!")
//                    } else if let error = error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//
//            Button("Schedule Notification") {

    ///  When you’re just learning notifications the easiest trigger type to use is UNTimeIntervalNotificationTrigger, which lets us request a notification to be shown in a certain number of seconds from now.
//
//                let content = UNMutableNotificationContent()
//                content.title = "Feed the cat"
//                content.subtitle = "It look hungry"
//                content.sound = UNNotificationSound.default
//
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request)
//
//            }
//        }
//    }
//
//}
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
//
