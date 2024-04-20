//
//  ContentView.swift
//  HapticFeedbackSampler
//
//  Created by 13an on 2024/04/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Haptics Sampler")
                    .foregroundStyle(.primary)
                    .font(.system(.largeTitle))
                
                HapticButton(fileName: "medium")
                
                HapticButton(fileName: "light")
            }
            .padding()
        }
    }
}

struct HapticButton: View {
    let fileName: String
    
    var body: some View {
        Button {
            HapticEngine.shared.playHapticsFile(named: fileName)
        } label: {
            Text("\(fileName)")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                .frame(width: 240)
                .background(.blue)
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
        }
        .padding(16)
    }
}

#Preview {
    ContentView()
}

