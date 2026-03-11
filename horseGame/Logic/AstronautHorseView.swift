
import SwiftUI

struct AstronautHorseView: View {
    @Binding var astronautPosition: CGPoint // Binding for astronaut's position
    @State var blockJump: Bool = false // State to control jump blocking
    
    var body: some View {
        GifImageView("astronautHorse") // Display astronaut horse GIF
            .frame(width: 150, height: 150) // Set frame size
            .offset(x: astronautPosition.x, y: astronautPosition.y) // Offset based on position
            .onReceive(Keyboard.shared.$keyEvent) { event in // Listen for keyboard events
                switch event {
                case .leftArrowKeyDown:
                    self.moveAstronautLeft() // Move left on left arrow key press
                case .rightArrowKeyDown:
                    self.moveAstronautRight() // Move right on right arrow key press
                case .spacebarKeyDown:
                    print(astronautPosition.y) // Print current y position on spacebar press
                    if astronautPosition.y == 0 && !blockJump { // Check conditions for jumping
                        jump() // Execute jump if conditions are met
                    }
                default:
                    break
                }
            }
    }
    
    func moveAstronautLeft() {
        if astronautPosition.x > -120 { // Check boundary before moving left
            withAnimation {
                astronautPosition.x -= 50 // Move left with animation
            }
        }
    }
    
    func moveAstronautRight() {
        if astronautPosition.x < 300 { // Check boundary before moving right
            withAnimation {
                astronautPosition.x += 50 // Move right with animation
            }
        }
    }
    
    func jump() {
        blockJump = true // Block further jumps temporarily
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            astronautPosition.y -= 100 // Perform jump animation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                astronautPosition.y += 100 // Return to original position after jump
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                blockJump = false // Unblock jumping after landing
            }
        }
     }
}

#Preview {
    AstronautHorseView(astronautPosition: .constant(CGPoint(x: 0, y: 0))) // Preview AstronautHorseView
}
