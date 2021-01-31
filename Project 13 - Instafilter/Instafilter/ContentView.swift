//
//  ContentView.swift
//  Instafilter
//
//  Created by Massimo Omodei on 17.01.21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

private struct Filter {
    let type: CIFilter
    let name: String
}

private let availableFilters = [
    Filter(type: .sepiaTone(), name: "Sepia Tone"),
    Filter(type: .crystallize(), name: "Crystallize"),
    Filter(type: .edges(), name: "Edges"),
    Filter(type: .gaussianBlur(), name: "Gaussian Blur"),
    Filter(type: .pixellate(), name: "Pixellate"),
    Filter(type: .unsharpMask(), name: "Unsharp Mask"),
    Filter(type: .vignette(), name: "Vignette")
]

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity: Float = 0.5
    @State private var filterRadius: Float = 0.5
    @State private var filterScale: Float = 0.5
    @State private var showingImagePicker = false
    @State private var showingFilterSelection = false
    @State private var showingSaveResultAlert = false
    @State private var saveResultTitle = ""
    @State private var saveResultMessage = ""
    @State private var originalImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var selectedFilter: CIFilter = availableFilters[0].type
    @State private var selectedFilterName = availableFilters[0].name

    private let context = CIContext()

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(image == nil ? Color.secondary : Color.white)

                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .onChange(of: filterScale) { _ in
                                applyProcessing()
                            }
                            .onChange(of: filterIntensity) { _ in
                                applyProcessing()
                            }
                            .onChange(of: filterRadius) { _ in
                                applyProcessing()
                            }
                    } else {
                        Text("Tap to select an image")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .padding(.bottom)
                .onTapGesture {
                    showingImagePicker = true
                }

                VStack {
                    Text("Filter intensity")
                    Slider(value: $filterIntensity)
                        .disabled(!selectedFilter.inputKeys.contains(kCIInputIntensityKey))
                }

                VStack {
                    Text("Filter radius")
                    Slider(value: $filterRadius)
                        .disabled(!selectedFilter.inputKeys.contains(kCIInputRadiusKey))
                }

                VStack {
                    Text("Filter scale")
                    Slider(value: $filterScale)
                        .disabled(!selectedFilter.inputKeys.contains(kCIInputScaleKey))
                }
            }
            .padding(.horizontal)
            .navigationTitle("Instafilter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(selectedFilterName) {
                        showingFilterSelection = true
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let processedImage = processedImage else { return }

                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            showingSaveResultAlert = true
                            saveResultTitle = "Image saved successfully"
                            saveResultMessage = ""
                        }
                        imageSaver.errorHandler = { _ in
                            showingSaveResultAlert = true
                            saveResultTitle = "Something went wrong"
                            saveResultMessage = "Please make sure Instafilter has access to your Photo library"
                        }

                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                    .disabled(image == nil)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $originalImage)
            }
            .actionSheet(isPresented: $showingFilterSelection) {
                filterSelectionActionSheet
            }
            .alert(isPresented: $showingSaveResultAlert) {
                Alert(title: Text(saveResultTitle), message: Text(saveResultMessage))
            }
        }
    }

    private func loadImage() {
        if let uiImage = originalImage {
            selectedFilter.setValue(CIImage(image: uiImage), forKey: kCIInputImageKey)
            applyProcessing()
        }
    }

    private func applyProcessing() {
        let inputKeys = selectedFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            selectedFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            selectedFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            selectedFilter.setValue(filterScale * 100, forKey: kCIInputScaleKey)
        }

        guard let outputImage = selectedFilter.outputImage else { return }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    private func setFilter(_ filter: Filter) {
        selectedFilter = filter.type
        selectedFilterName = filter.name
        loadImage()
    }

    private var filterSelectionActionSheet: ActionSheet {
        var buttons = availableFilters.map { filter in
            Alert.Button.default(Text(filter.name)) {
                setFilter(filter)
            }
        }
        buttons.append(Alert.Button.cancel())

        return ActionSheet(title: Text("Select a filter"), buttons: buttons)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
