import SwiftUI

struct FrostedEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .popover // Change this to .light or .dark if needed

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = .behindWindow
        nsView.state = .active // Corrected here
    }
}

struct ContentView: View {
    @State private var folderURL: URL?
    @State private var selectedColor: Color = .white // Change default color to white
    @State private var tintedFolderImage: NSImage? // Store the tinted folder image

    var body: some View {
        FrostedEffectView() // Use the frosted effect view here
            .overlay(
                VStack {
                    Text("SELECT FOLDER COLOUR")
                        .font(.headline)
                        .foregroundColor(.white) // Bold white text
                        .padding(.top)

                    // Directly place the color picker
                    HStack {
                        Text("COLOR SELECTED:")
                        ColorPicker("Select Color", selection: $selectedColor)
                            .labelsHidden() // Hide labels for a cleaner look
                            .frame(width: 200) // Adjust width as needed
                            .onChange(of: selectedColor) { newColor in
                                updateTintedFolderPreview(color: newColor) // Update the preview on color change
                            }
                    }
                    .padding()

                    // Drag and Drop Area with instruction text
                    VStack {
                        Text("DRAG FOLDER HERE TO APPLY CHANGES")
                            .font(.headline)
                            .foregroundColor(.white) // Light gray text for instructions
                            .padding(.bottom, 5)

                        ZStack { // Use ZStack to overlay icon and drop area
                            DropAreaView(folderURL: $folderURL, selectedColor: NSColor(selectedColor)) { image in
                                // Update the tinted folder preview when a folder is dropped
                                tintedFolderImage = image
                            }
                            .frame(width: 300, height: 300)
                            .background(
                                FrostedEffectView() // Add the frosted background
                                    .cornerRadius(20) // Rounded corners
                            )
                            .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5) // Shadow effect for the drop area
                            .padding() // Add some padding

                            // Center icon
                            Image(systemName: "folder") // Use the appropriate system icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50) // Size of the icon
                                .foregroundColor(.white) // Color of the icon
                        }
                    }
                    .padding()

                    // Preview Section
                    Text("PREVIEW")
                        .font(.headline)
                        .foregroundColor(.white) // Bold white text
                        .padding(.top)

                    // Display the tinted folder preview with shadow
                    if let tintedImage = tintedFolderImage {
                        Image(nsImage: tintedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                            .shadow(color: Color.white.opacity(0.5), radius: 10, x: 0, y: 5) // Shadow for the tinted folder preview
                    }

                    Spacer()

                    // Footer Text
                    Text("Made By OCTEXA")
                        .font(.footnote)
                        .foregroundColor(.white) // White text
                        .padding(.bottom)

                    // GitHub Button
                    Button(action: {
                        if let url = URL(string: "https://github.com/OCTEXA") {
                            NSWorkspace.shared.open(url) // Open the GitHub link
                        }
                    }) {
                        Text("GitHub") // Button title
                            .font(.caption) // Smaller font size
                            .foregroundColor(.white) // White text color
                            .padding(5) // Small padding for spacing
                            .shadow(color: Color.white.opacity(0.5), radius: 2, x: 0, y: 1) // Shadow effect
                    }
                    .padding(.bottom, 20) // Add bottom padding to the button

                }
                .padding()
                .background(Color.clear) // Ensure the background is clear
            )
            .frame(width: 500, height: 800) // Set a constant window size to 500x800
            .onAppear {
                updateTintedFolderPreview(color: selectedColor) // Initialize the preview with default color
            }
    }

    private func updateTintedFolderPreview(color: Color) {
        // Load the white folder icon from the project
        guard let whiteFolderImage = NSImage(named: "white_folder") else {
            print("Could not load the white folder image.")
            return
        }

        // Create a tinted version of the white folder icon
        tintedFolderImage = applyColorToImage(image: whiteFolderImage, color: NSColor(color))
    }

    private func applyColorToImage(image: NSImage, color: NSColor) -> NSImage {
        let tintedImage = NSImage(size: image.size)
        tintedImage.lockFocus()

        // Draw the original image
        image.draw(in: NSRect(origin: .zero, size: image.size), from: NSRect(origin: .zero, size: image.size), operation: .sourceOver, fraction: 1.0)

        // Set the color as a tint
        color.set()

        // Create a rectangle for the color overlay
        let rect = NSRect(origin: .zero, size: image.size)

        // Use a blending mode to apply the color as a tint
        rect.fill(using: .sourceAtop)

        tintedImage.unlockFocus()
        return tintedImage
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
