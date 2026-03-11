
import SwiftUI

// View representing a seahorse with interactive movement and jumping
struct seahorseView: View {
    @Binding var horsePosition: CGPoint // Binding for the position of the seahorse
    @State var blockJump: Bool = false  // State to control blocking multiple jumps
    
    var body: some View {
        GifImageView("seahorse")    // Display the seahorse gif
            .frame(width: 100, height: 100) // Set the size of the seahorse
            .offset(x: horsePosition.x, y: horsePosition.y) // Offset the seahorse based on its position
            .onReceive(Keyboard.shared.$keyEvent) { event in    // Receive keyboard events
                switch event {
                case .leftArrowKeyDown:
                    self.moveHorseLeft()    // Move seahorse left on left arrow key press
                case .rightArrowKeyDown:
                    self.moveHorseRight()   // Move seahorse right on right arrow key press
                case .spacebarKeyDown:
                    print(horsePosition.y)
                    if horsePosition.y == 0 &&  !blockJump {    // Check conditions for jumping
                        jump()  // Perform jump action
                    }
                default:
                    break
                }
            }
    }
    
    // Function to move the seahorse left with animation
    func moveHorseLeft() {
        if horsePosition.x > -120 { // Check if seahorse is within bounds
            withAnimation {
                horsePosition.x -= 50    // Move seahorse left by 50 points
            }
        }
    }
    
    // Function to move the seahorse right with animation
    func moveHorseRight() {
        if horsePosition.x < 300 {  // Check if seahorse is within bounds
            withAnimation {
                horsePosition.x += 50   // Move seahorse right by 50 points
            }
        }
    }
    
    // Function to perform the jump animation
    func jump() {
        blockJump = true    // Block further jumps until current jump is complete
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            horsePosition.y -= 100  // Move seahorse up by 100 points
        }
        
        // After a short delay, move the horse back down
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                // Move the horse back down to its original position
                horsePosition.y += 100
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                blockJump = false   // Unblock jumps after completion
            }
        }
     }
}

// Preview provider for the seahorseView
struct seahorse_Preview: PreviewProvider {
    static var previews: some View {
        seahorseView(horsePosition: .constant(CGPoint(x: 0, y: 0)))
    }
}
