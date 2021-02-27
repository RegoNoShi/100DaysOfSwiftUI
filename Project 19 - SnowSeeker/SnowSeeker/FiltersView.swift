//
//  FilterView.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

struct FiltersView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var filters: Filters

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Size")) {
                    VStack {
                        ForEach(filters.sizeFilters.indices) { index in
                            Toggle(isOn: $filters.sizeFilters[index].enabled) {
                                Text(filters.sizeFilters[index].name)
                            }
                        }
                    }
                }
                
                Section(header: Text("Price")) {
                    VStack {
                        ForEach(filters.priceFilters.indices) { index in
                            Toggle(isOn: $filters.priceFilters[index].enabled) {
                                Text(filters.priceFilters[index].name)
                            }
                        }
                    }
                }
                
                Section(header: Text("Country")) {
                    VStack {
                        ForEach(filters.countriesFilters.indices) { index in
                            Toggle(isOn: $filters.countriesFilters[index].enabled) {
                                Text(filters.countriesFilters[index].name)
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button("Reset all filters") {
                        withAnimation {
                            filters.resetAll()
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
    }
}
