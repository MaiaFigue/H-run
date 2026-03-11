
import SwiftUI
import WebKit

// NSViewRepresentable struct to display a GIF using WKWebView
struct GifImageView: NSViewRepresentable {
    private let name: String // Name of the GIF file
    
    // Initialize with the name of the GIF file.
    init(_ name: String) {
        self.name = name
    }
    
    // Creates a WKWebView instance and loads the GIF data
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()   // Create a WKWebView
        
        // Load GIF data from the bundle
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        if let data = try? Data(contentsOf: url) {
            // Load GIF data into the WKWebView
            webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        }
        webView.setValue(false, forKey: "drawsBackground")  // Disable drawing of background
        return webView
    }
    
    // Reloads the WKWebView to update the GIF
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.reload()
    }
}

