//
//  ContentView.swift
//  Travel-Capture-MVP
//
//  Created by 김민준 on 3/28/25.
//

import SwiftUI

struct StartView: View {
    
    @Environment(Interactor.self) private var interactor
    
    var body: some View {
        @Bindable var interactor = interactor
        VStack(spacing: 16) {
            TextField("여행 제목을 입력해주세요", text: $interactor.title)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 16))
            
            Button("여행 시작하기") {
                
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            .bold()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    StartView()
        .environment(Interactor())
}
