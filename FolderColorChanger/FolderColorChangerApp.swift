//
//  ColorPickerView.swift
//  FolderColorChanger
//
//  Created by OCTEXA on 28/10/24.
//

import SwiftUI

@main
struct FolderColorChangerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(VisualEffectBlur())
                .onAppear {
                    setupWindowAppearance()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowStyle(DefaultWindowStyle()) // Change to default window style
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
    }

    private func setupWindowAppearance() {
   
        NSApp.windows.forEach { window in
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)
            window.isOpaque = false
            window.backgroundColor = NSColor.clear
            
            // Set the window size directly
            window.setContentSize(NSSize(width: 500, height: 800))
        }
    }
}


struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .appearanceBased
        return visualEffect
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
       
    }
}

