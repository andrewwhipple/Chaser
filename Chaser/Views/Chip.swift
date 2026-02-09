//
//  Chip.swift
//  Chaser
//
//  Created by Andrew Whipple on 1/8/26.
//

import SwiftUI



struct Chip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding(5)
            .foregroundColor(.secondary)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(5)
    }
}
