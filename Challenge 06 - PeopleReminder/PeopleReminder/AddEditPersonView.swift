//
//  AddPersonView.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import SwiftUI
import CoreLocation

struct AddEditPersonView: View {
    var model: PeopleReminderModel
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var locationFetcher = LocationFetcher()
    @State private var showingSelectImage = false
    @State private var showingSaveError = false
    @State private var image: UIImage?
    @State private var name: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var notes: String
    @State private var location: CLLocation?
    @State private var forceLocationUpdate: Bool

    private var id: String?
    
    init(model: PeopleReminderModel, person: Person? = nil) {
        self.model = model
        _name = State(wrappedValue: person?.name ?? "")
        _email = State(wrappedValue: person?.email ?? "")
        _phoneNumber = State(wrappedValue: person?.phoneNumber ?? "")
        _notes = State(wrappedValue: person?.notes ?? "")
        _image = State(wrappedValue: person?.image)
        _location = State(wrappedValue: person?.location)
        _forceLocationUpdate = State(wrappedValue: person?.location == nil)
        id = person?.id
    }
    
    private var isFormInvalid: Bool {
        image == nil || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                }
                
                Button(image == nil ? "Select an image" : "Change image") {
                    showingSelectImage.toggle()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            
            TextField("Name", text: $name)
            
            TextField("Email (optional)", text: $email)
            
            TextField("Phone number (optional)", text: $phoneNumber)
            
            TextField("Notes (optional)", text: $notes)
                .lineLimit(5)
            
            MapView(location: $location)
                .frame(maxWidth: .infinity)
                .aspectRatio(1.5, contentMode: .fill)
                            
            Button("Update location") {
                forceLocationUpdate = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    do {
                        let person = Person(name: name, email: email, phoneNumber: phoneNumber, notes: notes,
                                            coordinate: location?.coordinate, id: id)
                        try person.saveImage(image!)
                        model.savePerson(person)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        showingSaveError.toggle()
                    }
                }
                .disabled(isFormInvalid)
            }
        }
        .navigationTitle(id == nil ? "Add person" : "Edit person")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSelectImage) {
            ImagePickerView(image: $image)
        }
        .alert(isPresented: $showingSaveError) {
            Alert(title: Text("Unable to save the image"), message: Text("Please, try again"), dismissButton: .cancel())
        }
        .onAppear(perform: locationFetcher.start)
        .onDisappear(perform: locationFetcher.stop)
        .onChange(of: locationFetcher.lastKnownLocation) { newLocation in
            if forceLocationUpdate {
                forceLocationUpdate = false
                location = newLocation
            }
        }
    }
}


struct AddEditPersonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddEditPersonView(model: PeopleReminderModel.preview)
        }
    }
}
