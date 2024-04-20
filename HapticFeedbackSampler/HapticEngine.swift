//
//  HapticEngine.swift
//  HapticFeedbackSampler
//
//  Created by 13an on 2024/04/20.
//

import CoreHaptics
import SwiftUI

final class HapticEngine {
    static let shared = HapticEngine()

    private var engine: CHHapticEngine?

    private init() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()

            engine?.resetHandler = onEngineReset
            engine?.stoppedHandler = onEngineStop

        } catch {
            #if targetEnvironment(simulator)
            print("Simulator is not supported for Core Haptics.")
            #else
            fatalError("Engine Creation Error: \(error)")
            #endif
        }
    }

    func playHapticsFile(named filename: String) {

        /// If the device doesn't support Core Haptics, abort.
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine else {
            return
        }

        /// Express the path to the AHAP file before attempting to load it.
        guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else {
            return
        }

        do {
            /// Start the engine in case it's idle.
            try engine.start()

            /// Tell the engine to play a pattern.
            try engine.playPattern(from: URL(fileURLWithPath: path))

        } catch {

        }
    }

    private func onEngineReset() {
        print("Reset Handler: Restarting the engine.")

        guard let engine else { return }

        do {
            /// Try restarting the engine.
            try engine.start()

            /// Register any custom resources you had registered, using registerAudioResource.
            /// Recreate all haptic pattern players you had created, using createPlayer.
        } catch {
            fatalError("Failed to restart the engine: \(error)")
        }
    }

    private func onEngineStop(_ reason: CHHapticEngine.StoppedReason) {
        print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")

        switch reason {
        case .audioSessionInterrupt: print("Audio session interrupt")
        case .applicationSuspended: print("Application suspended")
        case .idleTimeout: print("Idle timeout")
        case .systemError: print("System error")
        case .notifyWhenFinished: print("notifyWhenFinished")
        case .engineDestroyed: print("engineDestroyed")
        case .gameControllerDisconnect: print("gameControllerDisconnect")
        @unknown default:
            print("Unknown error")
        }
    }
}
