
//
//  ColorPickerView.swift
//  FolderColorChanger
//
//  Created by OCTEXA on 28/10/24.
//


import SwiftUI
import AppKit

struct DropAreaView: NSViewRepresentable {
    @Binding var folderURL: URL?
    var selectedColor: NSColor
    var onImageUpdate: (NSImage?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = DraggingView(folderURL: $folderURL, selectedColor: selectedColor, onImageUpdate: onImageUpdate)
        view.registerForDraggedTypes([.fileURL])
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // Pass the selected color to the dragging view if it changes
        if let draggingView = nsView as? DraggingView {
            draggingView.selectedColor = selectedColor
        }
    }
}

class DraggingView: NSView {
    @Binding var folderURL: URL?
    var selectedColor: NSColor
    var onImageUpdate: (NSImage?) -> Void

    init(folderURL: Binding<URL?>, selectedColor: NSColor, onImageUpdate: @escaping (NSImage?) -> Void) {
        _folderURL = folderURL
        self.selectedColor = selectedColor
        self.onImageUpdate = onImageUpdate
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: .fileURL) as? String,
              let url = URL(string: pasteboard), url.hasDirectoryPath else {
            return false
        }
        folderURL = url
        updateFolderIcon(url: url, color: selectedColor)
        return true
    }

    private func updateFolderIcon(url: URL, color: NSColor) {
        // Load the white folder icon from the project
        guard let whiteFolderImage = NSImage(named: "white_folder") else {
            print("Could not load the white folder image.")
            return
        }

        // Create a tinted version of the white folder icon
        let tintedIcon = applyColorToImage(image: whiteFolderImage, color: color)

        // Set the new icon
        NSWorkspace.shared.setIcon(tintedIcon, forFile: url.path)

        // Update the preview image
        onImageUpdate(tintedIcon)
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
