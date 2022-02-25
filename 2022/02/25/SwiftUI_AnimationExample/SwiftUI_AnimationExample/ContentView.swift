//
//  ContentView.swift
//  SwiftUI_AnimationExample
//
//  Created by 김우성 on 2022/02/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var bounce = true
    
    var body: some View {
        VStack {
            Text("SwiftUI Animation")
                .font(.largeTitle)
                .bold()
            
            Button(action: {
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                    bounce.toggle()
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
//                        bounce.toggle()
//                    }
//                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    bounce.toggle()
                }
                
            }) {
                Text("농구공 드리블 시작")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 1)
                    )
            }

            Circle()
                .fill(Color.orange)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 0, y: bounce ? 0 : 300)
                .animation(nil, value: bounce)
                .animation(.spring(), value: bounce)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
