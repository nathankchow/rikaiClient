import SwiftUI

struct ScrollingView: View {
    @EnvironmentObject var service: Service
    @EnvironmentObject var settings: Settings
    @State var listLength = 4
    @State var detailRawText: RawText? = nil
    
    
    var list2: [RawText] {
        let arraySlice = service.raws.suffix(4)
        let newArray = Array(arraySlice)
        return newArray
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                ForEach(0..<self.list2.count, id:\.self) {i in
                    
                    Button {
                        
                    } label: {
                        Text(list2[i].text)
                            .lineLimit(3)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 125)
                            .border(.primary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}