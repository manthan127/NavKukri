//
//  ContentView.swift
//  NavKukriu
//
//  Created by home on 22/11/21.
//

import SwiftUI

struct ContentView: View {
    let width = UIScreen.main.bounds.size.width/3
    @State var takeTwoTurn = false
    
    @State var nav = false
    @State var char = false
    @State var x = 1
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: BoardView(takeTwoTurn: takeTwoTurn),
                isActive: $nav){}
            NavigationLink(
                destination: CharKukriBoard(),
                isActive: $char){}
            
            Button(action: {
                nav = x == 1
                char = !nav
                
            }, label: {
                Text("Play")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(width: width, height: (width/3)*2)
                    .background(RadialGradient(gradient: Gradient(colors: [Color.white, Color.blue]), center: .init(x: 0.4, y: 0.4), startRadius: 5, endRadius: 70))
                    .cornerRadius(10)
            })
            
            Picker(selection: $x, label: Text("Picker"), content: {
                Text("Nav Kukri").tag(1)
                Text("Char Kukri").tag(2)
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if x == 1 {
                Toggle("tack two turn ", isOn: $takeTwoTurn)
                    .padding(.horizontal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }
    }
}
