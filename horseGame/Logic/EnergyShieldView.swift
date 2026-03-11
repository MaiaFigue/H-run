
import SwiftUI

struct EnergyShieldView: View {
    var body: some View {
        Image("energyShield") // Load energy shield image
            .resizable() // Make the image resizable
            .frame(width: 90, height: 50) // Set frame size
    }
}

#Preview {
    EnergyShieldView() // Preview the EnergyShieldView
}
