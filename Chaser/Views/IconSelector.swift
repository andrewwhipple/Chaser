//
//  IconSelector.swift
//  Chaser
//
//  Created by Andrew Whipple on 2/17/26.
//

import SwiftUI



struct IconSelector: View {
    let icon: Icon
    let currentIconName: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.1))
                .frame(width: 80, height: 80)
        
            if let iconImage = UIImage(named: icon.previewImage) {
                Image(uiImage: iconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
            } else {
                Image(systemName: "app.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.primary)
            }
            
            if currentIconName == icon.targetIconName {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
                    .background(Circle().fill(Color.white))
                    .offset(x: 30, y: -30)
            }
        }
        
        Text(icon.displayText)
            .font(.caption)
            .foregroundColor(currentIconName == icon.targetIconName ? .primary : .secondary)
        }
}
