//
//  ContentView.swift
//  rikaiClient
//
//  Created by natha on 6/6/22.
//
//
//import SwiftUI
//import SocketIO
//import WrappingHStack
//
//
//struct ManualView: View {
//    @EnvironmentObject var service: Service
//    @State var showExternalGoogleTranslate:Bool = false
//    @State var showExternalGoogleSearch: Bool = false
//    @GestureState private var location: CGPoint = .zero
//
//    func rectReader(index: Int) -> some View {
//        return GeometryReader{ (geometry) -> AnyView in
//            if geometry.frame(in: .global).contains(self.location) {
//                DispatchQueue.main.async {
//                    //self.service.maintext.turnOnHighlight(i: index)
//                    self.service.maintext.inBetweenHighlight(i: index)
//                }
//            }
//            return AnyView(Rectangle().fill(Color.clear))
//        }
//    }
//
//    func debug() {
//        print(self.service.manager.defaultSocket.status)
//    }
//
//    func getOpacity(bool: Bool) -> Double {
//        if bool {
//            return 1.0
//        } else {
//            return 0.0
//        }
//    }
//
//    var body: some View {
//        VStack{
//            HStack{
//                Text("Put connection status here")
//                Button {
//                    service.reconnect()
//                } label:{
//                    Image(systemName: "arrow.clockwise.circle")
//
//                }
//            }
////
////            Text($service.maintext.str.wrappedValue)
////                .padding()
//
////            WrappingHStack(stringArray, id: \.self) {str in
////                    Text(str)
////                    .font(.title)
////                    .padding(-3.0)
////            }.padding()
//
//
//
//            VStack {
//                WrappingHStack(0..<service.maintext.arr.count, id: \.self, spacing: WrappingHStack.Spacing.constant(0.0), lineSpacing: CGFloat(10.0)) {i in
//                    ZStack{
//                        Color.red.ignoresSafeArea().opacity(getOpacity(bool: service.maintext.isHighlighted[i]))
//                        Text(service.maintext.arr[i])
//                            .font(.title)
//
//                    }.fixedSize()
//                        .background(self.rectReader(index: i))
//                }
//                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                            .updating($location) { (value, state, transaction) in
//                    state = value.location
//                }).padding()
//                Spacer()
//            }
//            .frame(maxHeight: .infinity).border(Color(red: 1, green: 0.73, blue: 0.77, opacity: 1.0), width: 3).padding()
//
//            Spacer()
//
//            HStack{
//                Button(action:{
//                    service.maintext = MainText(service.maintext.str)
//                }) {
//                Text("Clear Highlight")
//                }
//            }.padding()
//
//            Spacer()
//
//            HStack{
//                Button(action: {
//                    showExternalGoogleTranslate = true
//                }) {
//                    Text("Google Translate")
//                }
//                .sheet(isPresented: self.$showExternalGoogleTranslate) {
//                    SFSafariViewWrapper(url: URL(string: "https://translate.google.com/?sl=ja&tl=en&text=\(self.service.maintext.getSubstring().addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&op=translate")!)
//                }
//
//                Button(action: {
//                    showExternalGoogleSearch = true
//                }) {
//                    Text("Google Search")
//                }
//                .sheet(isPresented: self.$showExternalGoogleSearch) {
//                    SFSafariViewWrapper(url: URL(string: "https://www.google.com/search?q=\((self.service.maintext.getSubstring() + " 意味").addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)")!)
//                }
//            }.padding()
//            Button(action: self.debug) {
//                Text("Debug")
//            }
//        }
//    }
//
////    var stringArray: [String] {
////        let str = service.text
////        return str.map {String($0)}
////    }
////
////    var isHighlighted: [Bool] {
////        return service.text.map {_ in false}
////    }
//
//}
//struct ManualView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualView()
//    }
//}
