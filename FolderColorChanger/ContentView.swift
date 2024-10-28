import SwiftUI

struct FrostedEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .popover

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
        nsView.state = .active
    }
}

struct ContentView: View {
    @State private var folderURL: URL?
    @State private var selectedColor: Color = .white
    @State private var tintedFolderImage: NSImage?

    var body: some View {
        FrostedEffectView()
            .overlay(
                VStack {
                    Text("SELECT FOLDER COLOUR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    HStack {
                        Text("COLOR SELECTED:")
                        ColorPicker("Select Color", selection: $selectedColor)
                            .labelsHidden()
                            .frame(width: 200)
                            .onChange(of: selectedColor) { newColor in
                                updateTintedFolderPreview(color: newColor)
                            }
                    }
                    .padding()

                    VStack {
                        Text("DRAG FOLDER HERE TO APPLY CHANGES")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)

                        ZStack {
                            DropAreaView(folderURL: $folderURL, selectedColor: NSColor(selectedColor).withAlphaComponent(0.3)) { image in
                                if let image = image {
                                    tintedFolderImage = applyColorToImage(image: image, color: NSColor(selectedColor).withAlphaComponent(0.3))
                                }
                            }
                            .frame(width: 300, height: 300)
                            .background(
                                FrostedEffectView()
                                    .cornerRadius(20)
                            )
                            .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding()

                            Image(systemName: "folder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()

                    Text("PREVIEW")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    if let tintedImage = tintedFolderImage {
                        Image(nsImage: tintedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                            .shadow(color: Color.white.opacity(0.5), radius: 10, x: 0, y: 5)
                    }

                    Spacer()

                    Text("Made By OCTEXA")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.bottom)

                    Button(action: {
                        if let url = URL(string: "https://github.com/OCTEXA/FolderColorChanger") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Text("GitHub")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(5)
                            .shadow(color: Color.white.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    .padding(.bottom, 10)
                }
                .padding()
                .background(Color.clear)
            )
            .frame(width: 500, height: 800)
            .onAppear {
                updateTintedFolderPreview(color: selectedColor)
            }
    }

    private func updateTintedFolderPreview(color: Color) {
        guard let whiteFolderImage = NSImage(named: "white_folder") else {
            print("Could not load the white folder image.")
            return
        }
        tintedFolderImage = applyColorToImage(image: whiteFolderImage, color: NSColor(color).withAlphaComponent(0.3))
    }

    private func applyColorToImage(image: NSImage, color: NSColor) -> NSImage {
        let tintedImage = NSImage(size: image.size)
        tintedImage.lockFocus()

        image.draw(in: NSRect(origin: .zero, size: image.size), from: NSRect(origin: .zero, size: image.size), operation: .sourceOver, fraction: 1.0)
        
        color.set()
        
        let rect = NSRect(origin: .zero, size: image.size)
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
