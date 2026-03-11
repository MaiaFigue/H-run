
import SwiftUI

//Main application entry point
@main
struct horseGameApp: App {
    var body: some Scene {
        //Main window group scene
        WindowGroup {
            ContentView()
                //Set the frame size of the ContentView
                .frame(width: 600, height: 378)
        }
    }
}

//Extension to add window resizability based on content size
extension Scene {
    func windowResizablityContentSize() -> some Scene {
        //Make the window resizable based on its content size
        return windowResizability(.contentSize)
    }
}

