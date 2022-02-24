//
//  Example.swift
//  SwiftUI GradientButton
//
//  Created by 김우성 on 2022/02/24.
//

import SwiftUI

struct Example: View {
    var body: some View {
        HStack {
            Color.yellow.frame(width: 50, height: 50, alignment: .center)

            Color.red.frame(width: 50, height: 50, alignment: .center)
                .rotationEffect(.degrees(45))
                .padding(-20)
                .blendMode(.colorBurn)
        }
    }
}

struct Example_Previews: PreviewProvider {
    static var previews: some View {
        Example()
    }
}
