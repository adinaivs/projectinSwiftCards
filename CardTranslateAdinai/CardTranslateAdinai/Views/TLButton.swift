//
//  TLButton.swift
//  snackstore1
//
//  Created by marzhan on 21/11/24.
//

import SwiftUI

struct TLButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        },label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        })
        
    }
}

#Preview {
    TLButton(title: "Значение", background: .pink) {
        //Action
    }
}
