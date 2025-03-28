//
//  TravelView.swift
//  Travel-Capture-MVP
//
//  Created by 김민준 on 3/28/25.
//

import SwiftUI

struct TravelView: View {
    
    @Environment(Interactor.self) private var interactor
    
    @State private var isFinishAlertPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(interactor.title)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button("여행 종료") {
                    isFinishAlertPresented.toggle()
                }
            }
            
            Text("2025. 03. 28 15:00 ~")
                .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .alert("여행이 종료되었습니다", isPresented: $isFinishAlertPresented) {
            Button("확인", role: .none) {}
        } message: {
            Text("총 \(interactor.images.count)장 앨범 저장 완료 ")
        }
    }
}

#Preview {
    TravelView()
        .environment(Interactor(title: "포항 여행", images: []))
}
