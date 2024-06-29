//
//  Card.swift
//  My Cards
//
//  Created by Conner Yoon on 6/29/24.
//

import Foundation
import SwiftData
import PhotosUI
import SwiftUI

@Model
final class Card {
    var timestamp: Date
    var name : String
    @Attribute (.externalStorage) var imageData : Data?
    init(timestamp: Date = Date(), name : String = "Untitled", imageData: Data? = nil) {
        self.timestamp = timestamp
        self.name = name
    }
}

struct CardEditView: View {
    @State private var photosPickerItem : PhotosPickerItem?
    @State private var profileImage : Image?
    @State private var sourceType : SourceType?
    @State private var isShowingAlert : Bool = false
    @Bindable var card: Card
    var save : (Card)->()
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
//    @FocusState var isTitleFieldFocused : Bool
    var body: some View {
        Form {
            TextField(card.name, text: $card.name).font(.title).textFieldStyle(.roundedBorder)
//                .focused($isTitleFieldFocused)
//                .onAppear{
//                    isTitleFieldFocused = true
//                }
            CardPicView(card: card, height: 200)
            HStack{
                Button {
                    sourceType = .camera
                } label: {
                    Image(systemName: "camera.fill").resizable().frame(width: 50, height: 50)
                }.buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                Button {
                    sourceType = .photoLibrary
                } label: {
                    Image(systemName: "photo.stack.fill").resizable().frame(width: 50, height: 50)
                }.buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)
                
            }
            
            Button("SAVE"){
                save(card)
                dismiss()
            }.frame(maxWidth: .infinity)
                .buttonStyle(BorderedButtonStyle())
            

    
        }
        .toolbar{
            Button(role: .destructive) {
                isShowingAlert = true
            } label: {
                Text("DELETE")
            }.alert("DO YOU WANT TO DELETE?", isPresented:$isShowingAlert) {
                Button("Yes"){
                    modelContext.delete(card)
                    dismiss()
                }
                Button("No"){
                    isShowingAlert = false
                }
                
            }.frame(maxWidth: .infinity)
                .buttonStyle(BorderedButtonStyle())
        }
        .sheet(item: $sourceType) { sourceType in
            CameraView(sourceType: sourceType, imageData: $card.imageData)
        }
    }
}
struct CardPicView :View {
    var card : Card
    var height : CGFloat
    var body: some View {
            if let data = card.imageData, let uiImage = UIImage(data: data){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            else {
              
                    //Image(systemName: "creditcard").resizable()
                Image(.image1)
                    .resizable()
                    .opacity(0.4)
                    .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: height)
            }
        
    }
}
struct CardRowView : View {
    var card : Card
    var body: some View {
        VStack{
            Text(card.name).font(.title)
            CardPicView(card: card, height: 200)
        }
    }
}
