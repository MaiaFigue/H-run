
import SwiftUI

// Enum to represent different types of keyboard events
enum KeyEvent {
    case leftArrowKeyDown
    case rightArrowKeyDown
    case spacebarKeyDown
}

// Singleton class to manage keyboard events and publish them as `KeyEvent`
class Keyboard: ObservableObject {
    static let shared = Keyboard() // Singleton instance
    
    @Published var keyEvent: KeyEvent?  // Published property to notify observers of key events
    
    private var spacebarKeyCode: UInt16 { 49 } // ASCII code for spacebar

    private init() {
        // Add a local monitor for key-down events
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 123 { // Left arrow key
                self.keyEvent = .leftArrowKeyDown
            } else if event.keyCode == 124 { // Right arrow key
                self.keyEvent = .rightArrowKeyDown
            } else if event.keyCode == self.spacebarKeyCode { // Spacebar key
                self.keyEvent = .spacebarKeyDown
            }
            return event
        }
    }
}
