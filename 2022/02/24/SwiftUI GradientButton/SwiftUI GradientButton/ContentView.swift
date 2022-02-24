//
//  ContentView.swift
//  SwiftUI GradientButton
//
//  Created by 김우성 on 2022/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("커스텀 버튼만들기~!")
                    .font(.title.bold())
                    .padding(.bottom, 50)
                
                CustomButton()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
