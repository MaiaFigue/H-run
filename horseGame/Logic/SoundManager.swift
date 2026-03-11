import Foundation
import AVFoundation

// SoundManager class handles all sound-related functionalities
class SoundManager {
    // Singleton instance
    static let shared = SoundManager()
    
    // Audio player instances
    var runningPlayer: AVAudioPlayer?
    var bubblesPlayer: AVAudioPlayer?
    var footstepsPlayer: AVAudioPlayer?
    var effectPlayer: AVAudioPlayer?
    var gameOverPlayer: AVAudioPlayer?
    
    // Flag to track sound state
    var isSoundOn: Bool = true
    
    // Enum to define sound types
    enum Sound : String {
        case running = "runningSound"
        case horse = "horseSound"
        case bubbles = "bubblesSound"
        case electricity = "electricitySound"
        case footsteps = "footstepsSound"
        case laser = "laserSound"
        case shield = "shieldSound"
        case star = "starSound"
        case gameOver = "gameOverSound"
    }
    
    // Play running sound looped indefinitely
    func playRunningSound() {
        guard isSoundOn else { return }
        guard let url = Bundle.main.url(forResource: Sound.running.rawValue, withExtension: ".mp3") else { return }
        
        do {
            runningPlayer = try AVAudioPlayer(contentsOf: url)
            runningPlayer?.numberOfLoops = -1
            runningPlayer?.play()
        } catch let error {
            print("Error playing running sound: \(error.localizedDescription)")
        }
    }
    
    // Stop playing running sound
    func stopRunningSound() {
        runningPlayer?.stop()
        runningPlayer = nil
    }
    
    // Play bubbles sound looped indefinitely
    func playBubblesSound() {
        guard isSoundOn else { return }
        guard let url = Bundle.main.url(forResource: Sound.bubbles.rawValue, withExtension: ".mp3") else { return }
        
        do {
            bubblesPlayer = try AVAudioPlayer(contentsOf: url)
            bubblesPlayer?.numberOfLoops = -1
            bubblesPlayer?.play()
        } catch let error {
            print("Error playing bubbles sound: \(error.localizedDescription)")
        }
    }
    
    // Stop playing bubbles sound
    func stopBubblesSound() {
        bubblesPlayer?.stop()
        bubblesPlayer = nil
    }
    
    // Play footsteps sound looped indefinitely
    func playFootStepsSound() {
        guard isSoundOn else { return }
        guard let url = Bundle.main.url(forResource: Sound.footsteps.rawValue, withExtension: ".mp3") else { return }
        
        do {
            footstepsPlayer = try AVAudioPlayer(contentsOf: url)
            footstepsPlayer?.numberOfLoops = -1
            footstepsPlayer?.play()
        } catch let error {
            print("Error playing foot steps sound: \(error.localizedDescription)")
        }
    }
    
    // Stop playing footsteps sound
    func stopFootStepsSound() {
        footstepsPlayer?.stop()
        footstepsPlayer = nil
    }
    
    // Play effect sound based on given Sound enum
    func playEffectSound(sound: Sound) {
        guard isSoundOn else { return }
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer?.play()
        } catch let error {
            print("Error playing \(sound.rawValue): \(error.localizedDescription)")
        }
    }
    
    // Play game over sound
    func playGameOverSound() {
        guard isSoundOn else { return }
        guard let url = Bundle.main.url(forResource: Sound.gameOver.rawValue, withExtension: ".mp3") else { return }
        
        do {
            gameOverPlayer = try AVAudioPlayer(contentsOf: url)
            gameOverPlayer?.play()
        } catch let error {
            print("Error playing game over sound: \(error.localizedDescription)")
        }
    }
    
    // Stop playing game over sound
    func stopGameOverSound() {
        gameOverPlayer?.stop()
    }
    
    // Stop all currently playing sounds
    func stopAllSounds() {
        runningPlayer?.stop()
        bubblesPlayer?.stop()
        footstepsPlayer?.stop()
        effectPlayer?.stop()
    }
    
    // Toggle running sound on/off
    func toggleRunningSound() {
        isSoundOn.toggle()
        if !isSoundOn {
            stopAllSounds()
        } else {
            playRunningSound()
        }
    }
    
    // Toggle bubbles sound on/off
    func toggleBubbleSound() {
        isSoundOn.toggle()
        if !isSoundOn {
            stopAllSounds()
        } else {
            playBubblesSound()
        }
    }
    
    // Toggle footsteps sound on/off
    func toggleFootSTepsSound() {
        isSoundOn.toggle()
        if !isSoundOn {
            stopAllSounds()
        } else {
            playFootStepsSound()
        }
    }
}

