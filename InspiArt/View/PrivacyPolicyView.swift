import Foundation
import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var showingThisView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Terms and conditions")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 30)
            
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .font(.system(.subheadline))
                .padding(.bottom, 45)
            
            Text("While using app, you agree to the The Art Institute of Chicago® and InspiArt® Terms of Service and Privacy Policy, you also agree that you are older then 18 years old")
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 40)
                .padding([.leading, .trailing], 25)
            
            Link("Privacy Policy", destination: URL(string: "https://www.artic.edu/terms")!)
                .padding(.bottom, 25)
            
            Button {
                //TODO: ViewModel for privacy policy view
                withAnimation(.spring())
                {
                    UserDefaults.standard.setValue(true, forKey: "acceptedTermsOfService")
                    showingThisView = false
                }
                
            } label: {
                Text("Accept Terms")
                    .frame(width: 150, height: 50)
                    .background(Color(UIColor.systemGray3))
                    .cornerRadius(30)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
    }
}
