//
//  CustomButton.swift
//  SwiftUI GradientButton
//
//  Created by 김우성 on 2022/02/24.
//

import SwiftUI

struct CustomButton: View {
    
    var gradient1: [Color] = [
        Color(red: 101/255, green: 134/255, blue: 1),
        Color(red: 1, green: 64/255, blue: 80/255),
        Color(red: 109/255, green: 1, blue: 185/255),
        Color(red: 39.255, green: 232/255, blue: 1)
    ]
    
    var body: some View {
        Button(action: {}) {
            
            GeometryReader { geo in
                ZStack {
                    // setup backgroundColor
                    AngularGradient(
                        colors: gradient1,
                        center: .center,
                        angle: .degrees(8.0))
                        .blendMode(.overlay)
                        .blur(radius: 8.0)
                        .mask(alignment: .center) {
                            RoundedRectangle(cornerRadius: 16.0)
                                .frame(height: 50)
                                .frame(maxWidth: geo.size.width - 16)
                                .blur(radius: 8.0)
                        }
                        
                    Text("회원가입")
                        .blur(radius: 0.5)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: geo.size.width - 16)
                        .frame(height: 50)
                        .background(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16.0)
                                .stroke(.white, lineWidth: 1.9)
                                .blendMode(.normal)
                                .opacity(0.7)
                        )
                        .cornerRadius(16.0)
                    
                }
            }
        }.frame(height: 50)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
