//
//  yelpbusinessModel.swift
//  IOSHW9
//
//  Created by yuhao on 11/22/22.
//

import SwiftUI


struct Toast<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    let position: Alignment
    var body: some View {

        GeometryReader { geometry in

            ZStack(alignment: position) {

                self.presenting()
                    .blur(radius: self.isShowing ? 2 : 0)

                VStack {
                    self.text
                        .multilineTextAlignment(.center)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)

            }

        }

    }

}
extension View {

    func toast(isShowing: Binding<Bool>, text: Text,position:Alignment = .bottom) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text,
              position:position)
        
    }
}
