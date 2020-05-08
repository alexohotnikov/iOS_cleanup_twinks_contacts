//
//  ContentView.swift
//  clean-up-contacts
//
//  Created by Саша on 08.05.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import SwiftUI
import ContactsUI

struct ContentView: View {
    @State private var isDone: Bool = false
    @State private var wasDeleted: Int16  = 0

    var body: some View {
        VStack {
            if ( isDone ) {
                Text("Done!")
                .bold()
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Spacer()
                           .frame(height: 20)
                Text("Was Deleted by us: \(wasDeleted) dub constacts.")
            } else {
                Text("Prepare for clean-up dublicate contacts:")
                        .font(.headline)
                    Spacer()
                        .frame(height: 20)
                    Button(action: {
                        let contactStore = CNContactStore()
                        let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey]
                        let request1 = CNContactFetchRequest(keysToFetch: keys  as [CNKeyDescriptor])
                        
                        var watcher = [String]()

                        try? contactStore.enumerateContacts(with: request1) { (contact, error) in
                            for phone in contact.phoneNumbers {
                                let data = watcher.firstIndex(where: { $0.elementsEqual(phone.value.stringValue)})
                                
                                if (data != nil) {
                                    let request = CNSaveRequest()
                                    let mutable = contact.mutableCopy() as! CNMutableContact
                                    request.delete(mutable)
                                    self.wasDeleted += 1
                                    try? contactStore.execute(request)
                                } else {
                                         watcher.append(phone.value.stringValue)
                                }
                                self.isDone = true
                            }
                        }
                    }) {
                        Text("Start NOW!")
                            .bold()
                    }
                
            }
        }.frame(height: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

