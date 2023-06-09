//
//  MeView.swift
//  HotProspects
//
//  Created by Yashraj jadhav on 06/05/23.
//

import UIKit
import SwiftUI
import CoreImage.CIFilterBuiltins

///Core Image lets us generate a QR code from any input string, and do so extremely quickly. However, there’s a problem: the image it generates is very small because it’s only as big as the pixels required to show its data. It’s trivial to make the QR code larger, but to make it look good we also need to adjust SwiftUI’s image interpolation. So, in this step we’re going to ask the user to enter their name and email address in a form, use those two pieces of information to generate a QR code identifying them, and scale up the code without making it fuzzy.

struct MeView: View {
    
    ///We’re going to use the name and email address fields to generate a QR code, which is a square collection of black and white pixels that can be scanned by phones and other devices. Core Image has a filter for this built in, and as you’ve learned how to use Core Image filters previously you’ll find this is very similar.
    
    //    In practical terms, this means rather than writing prospects.people.append(person) we’d instead create an add() method on the Prospects class, so we could write code like this: prospects.add(person).
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()   // builtin qr code gen
    
    @State private var qrCode = UIImage()
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    
    func generateQRcode(from string : String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
               return UIImage(cgImage: cgimg)
                
///  (purple warnings)“Undefined behavior” is a fancy way of saying “this could behave in any number of weird ways, so don’t do it.”
                
                
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRcode(from: "\(name)\n\(emailAddress)")
    }
    
         var body: some View {
           NavigationView {
               VStack {
                   Spacer()
                   Text("Your Code")
                       .font(.largeTitle)
                       .bold()
                       .foregroundColor(.black)
                       .padding()
                   Image(uiImage: qrCode)
                       .interpolation(.none)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 300, height: 300)
                       .cornerRadius(29)
                       .padding()
                       .shadow(radius: 20)
                       .background(
                           RoundedRectangle(cornerRadius: 29)
                               .stroke(Color.gray, lineWidth: 2)
                               .background(
                                   LinearGradient(
                                       gradient: Gradient(
                                           colors: [
                                               Color.gray.opacity(0.5),
                                               Color.gray.opacity(0.2)
                                           ]
                                       ),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing
                                   )
                                   .cornerRadius(29)
                                   .shadow(radius: 20)
                               )
                       )
                       .contextMenu {
                           Button {
                               let imageSaver = ImageSaver()
                               imageSaver.writeToPhotoAlbum(image: qrCode)
                           } label: {
                               Label("Save to Photos", systemImage: "square.and.arrow.down")
                           }
                       }
                   TextField("Name", text: $name)
                       .textContentType(.name)
                       .font(.title2)
                       .padding()
                       .background(Color.gray.opacity(0.3))
                       .cornerRadius(20)
                       .padding(.horizontal)
                       .padding(.vertical)
                   TextField("Email address", text: $emailAddress)
                       .textContentType(.emailAddress)
                       .font(.title2)
                       .padding()
                       .background(Color.gray.opacity(0.3))
                       .cornerRadius(20)
                       .padding(.horizontal)
                   Spacer()
               }
               .padding()
               .background(Color.white)
               .ignoresSafeArea()
               .onAppear(perform: updateCode)
               .onChange(of: name) { _ in updateCode() }
               .onChange(of: emailAddress) { _ in updateCode() }
               //.navigationBarTitle("QR Code", displayMode: .inline)
           }
       }

}

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
