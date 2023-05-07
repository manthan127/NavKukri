//
//  CharKukriBoard.swift
//  NavKukriu
//
//  Created by home on 01/12/21.
//

import SwiftUI

struct CharKukriBoard: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    
    @State var blackTurn = false
    
    @State var selected: (row: Int, colum: Int) = (-1, -1)
    
    @State var colorPiece: (white: Int,  black: Int) = (4, 4)
    
    @State var win = false
    
    var body: some View {
        VStack {
            Spacer()
            Circle()
                .fill(blackTurn ? Color.black : Color.white)
                .frame(width: 100, height: 100)
            if colorPiece.black > 0 {
                HStack {
                    Text("black: \(colorPiece.black)")
                    Text("white: \(colorPiece.white)")
                }
            } else {
                Text("black on board:- \(countPeice(for: 1, in: board))")
                Text("white on board:- \(countPeice(for: 2, in: board))")
            }
            boardView
            Spacer()
        }
        .background(RadialGradient(gradient: Gradient(colors: [Color.red.opacity(0.5), Color.blue.opacity(0.5)]), center: .center, startRadius: 5, endRadius: 500))
        .edgesIgnoringSafeArea(.all)
    }
    
    var boardView: some View {
        VStack(spacing: 0) {
            ForEach(board.indices) { row in
                HStack(spacing: 0) {
                    ForEach(board[row].indices) { colum in
                        cellView(row, colum)
                            .padding()
                    }
                }
            }
        }
        .alert(isPresented: $win, content: {
            Alert(title: Text((blackTurn ? "black" : "white") + " won"),
                  primaryButton: Alert.Button.default(Text("Home Screen"), action: {
                    presentationMode.wrappedValue.dismiss()
                  }),
                  secondaryButton: Alert.Button.default(Text("replay"), action: {reset()})
            )
        })
        .aspectRatio(1, contentMode: .fit)
    }
    
    func cellView(_ row: Int, _ colum: Int) -> some View {
        ZStack{
            Circle()
                .strokeBorder(Color.gray, lineWidth: 5)
            
            Button(action: {
                onCellClick(row, colum)
            }, label: {
                Circle()
                    .fill(board[row][colum] == 1 ? Color.black : board[row][colum] == 2 ? Color.white : Color.clear )
            })
            if row == selected.row && colum == selected.colum {
                Circle()
                    .strokeBorder(Color.green, lineWidth: 5)
                    .padding(-5)
            }
        }
        
    }
    
    func onCellClick(_ row: Int, _ colum: Int) {
        if colorPiece.black > 0 {
            placingPeice(row, colum)
        } else {
            move(row, colum)
        }
    }
    
    func placingPeice(_ row: Int, _ colum: Int) {
        guard board[row][colum] == 0 else {return}
        
        board[row][colum] = blackTurn.player
        
        if blackTurn {
            colorPiece.black -= 1
        } else {
            colorPiece.white -= 1
        }
        
        blackTurn.toggle()
    }
    
    func move(_ row: Int, _ colum: Int) {
        func set() {
            board[row][colum] = player
            board[selected.row][selected.colum] = 0
            blackTurn.toggle()
            selected = (-1, -1)
        }
        let player = blackTurn.player
        let oponet = blackTurn.opponent
        if board[row][colum] == player{
            return selected = (row, colum)
        } else if board[row][colum] == 0 {
            if selected.row == row {
                if abs(selected.colum - colum) == 1 {
                    set()
                }
                if abs(selected.colum - colum) == 2 {
                    if board[row][1] == oponet {
                        set()
                        board[row][1] = 0
                    }
                }
            } else if selected.colum == colum {
                if abs(selected.row - row) == 1 {
                    set()
                }
                if abs(selected.row - row) == 2 {
                    if board[1][colum] == oponet {
                        set()
                        board[1][colum] = 0
                    }
                }
            }
            
            for i in board.indices {
                for j in board[i].indices where board[i][j] == oponet {
                    if board[i].contains(0) || board.transpose[j].contains(0) {
                        return
                    }
                }
            }
            blackTurn.toggle()
            
            guard let _ = board.first(where: {$0.contains(oponet)}) else {
                return win = true
            }
            
        }
    }
    
    
    func reset() {
        board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        
        blackTurn = false
        
        selected = (-1, -1)
        
        colorPiece = (4, 4)
    }
    
}

struct CharKukriBoard_Previews: PreviewProvider {
    static var previews: some View {
        CharKukriBoard()
    }
}
