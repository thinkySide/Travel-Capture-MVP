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
            
            HStack {
                Text(interactor.startDate.description)
                
                Spacer()
                
                Text("총 \(interactor.images.count)장")
            }
            .padding(.top, 8)
            
            ScrollView {
                // 트러블 슈팅 기록
                // ForEach(interactor.images, id: \.accessibilityIdentifier)
                // ID가 동일해서 계속 같은 이미지를 출력하고 있었음,,,
                // 애꿎은 PhotoKit 쪽만 계속 찾아봤네 ㅜ
                // 이건 진짜 항상 주의해서 봐야할 것 같음
                ForEach(interactor.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                }
            }
            .refreshable {
                interactor.refresh()
            }
        }
        .onAppear {
            interactor.setup()
        }
        .padding(.horizontal, 20)
        .alert("여행이 종료되었습니다!", isPresented: $isFinishAlertPresented) {
            Button("확인", role: .none) {
                interactor.stop()
            }
        } message: {
            Text("총 \(interactor.images.count)장 앨범 저장 완료 ")
        }
    }
}

#Preview {
    TravelView()
        .environment(Interactor(title: "포항 여행", images: []))
}
