//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Massimo Omodei on 18.02.21.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    
    let filter: FilterType
    
    @EnvironmentObject private var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSort = false
    
    private var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    private var filteredPeople: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPeople.sorted(by: prospects.sortType.sortBy)) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        if filter == .none {
                            Spacer()
                            
                            Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                                .padding(.trailing)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            prospects.toggle(prospect.id)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                addNotification(for: prospect)
                            }
                        }
                    }
                }
                .onDelete(perform: removePeople)
            }
            .navigationBarTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSort = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
            }
            .actionSheet(isPresented: $isShowingSort) {
                ActionSheet(title: Text("How do you want to sort the people?"), message: nil, buttons: [
                    ActionSheet.Button.default(Text("Name Ascending")) { prospects.setSortType(.nameAscending) },
                    ActionSheet.Button.default(Text("Name Descending")) { prospects.setSortType(.nameDescending) },
                    ActionSheet.Button.default(Text("Added Ascending")) { prospects.setSortType(.addedAscending) },
                    ActionSheet.Button.default(Text("Added Descending")) { prospects.setSortType(.addedDescending) },
                    ActionSheet.Button.cancel(),
                ])
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr],
                                simulatedData: "Zzz Hudson\nzzz@hackingwithswift.com",
                                completion: handleScan)
            }
        }
    }
    
    private func removePeople(at offsets: IndexSet) {
        offsets.forEach {
            prospects.remove(filteredPeople[$0].id)
        }
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let data):
            let components = data.components(separatedBy: "\n")
            if components.count == 2 {
                prospects.add(Prospect(name: components[0], emailAddress: components[1]))
            } else {
                print("Invalid data")
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func addRequest(for prospect: Prospect, in center: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = "Contact \(prospect.name)"
        content.subtitle = prospect.emailAddress
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest(for: prospect, in: center)
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest(for: prospect, in: center)
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
