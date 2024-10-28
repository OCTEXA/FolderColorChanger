//
//  ColorPickerView.swift
//  FolderColorChanger
//
//  Created by OCTEXA on 28/10/24.
//

import SwiftUI
import AppKit

struct ColorPickerView: View {
    @Binding var selectedColor: NSColor

    var body: some View {
        HStack {
            Text("Select Color:")
                .font(.headline)
            ColorPicker("", selection: Binding(
                get: { Color(selectedColor) },
                set: { selectedColor = NSColor($0) }
            ))
            .labelsHidden()
            .frame(width: 50, height: 25)
        }
        .padding()
    }
}
