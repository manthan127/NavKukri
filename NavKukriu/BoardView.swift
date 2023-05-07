//
//  BoardView.swift
//  NavKukriu
//
//  Created by home on 22/11/21.
//

import SwiftUI

struct BoardView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var board = [[ 0, -1, -1,  0, -1, -1,  0],
                        [-2,  0, -1,  0, -1,  0, -2],
                        [-2, -2,  0,  0,  0, -2, -2],
                        [ 0,  0,  0, -3,  0,  0,  0],
                        [-2, -2,  0,  0,  0, -2, -2],
                        [-2,  0, -1,  0, -1,  0, -2],
                        [ 0, -1, -1,  0, -1, -1,  0]]

    @State var blackTurn = false
    @State var shouldRemove = false
    
    @State var colorPiece: (white: Int,  black: Int) = (9, 9)
    
    @State var selected: (row: Int, colum: Int) = (-1, -1)
    @State var win = false
    
    @State var takeTwoTurn: Bool
    
    @State var turnCount = 0
    
    var body: some View {
        VStack{
            Spacer()
            Circle()
                .fill(blackTurn ? Color.black : Color.white)
                .padding()
                .frame(width: 100, height: 100)
            if colorPiece.black > 0 {
                HStack {
                    Text("black:- \(colorPiece.black)")
                    Text("white:- \(colorPiece.white)")
                }
            } else {
                Text("black on board:- \(countPeice(for: 1, in: board))")
                Text("white on board:- \(countPeice(for: 2, in: board))")
            }
            if shouldRemove {
                Text("remove \(blackTurn ? "white" : "black")'s piece")
            }
            boardView
            Spacer()
        }
        .background(RadialGradient(gradient: Gradient(colors: [Color.red.opacity(0.5), Color.blue.opacity(0.5)]), center: .center, startRadius: 5, endRadius: 500))
        .edgesIgnoringSafeArea(.all)
    }
    
    var boardView: some View {
        ZStack {
            Image("navkukri")
                .resizable()
                .padding(14)
            VStack {
                ForEach(board.indices) { row in
                    HStack {
                        ForEach(board[row].indices){ clmn in
                            cellView(row, clmn)
                        }
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
        .padding()
        .aspectRatio(1, contentMode: .fit)
    }
    
    
    func cellView(_ row: Int, _ colum: Int) -> some View {
        ZStack {
//            if board[row][colum] == 0 {
//                Circle()
//                    .strokeBorder(Color.gray, lineWidth: 5)
//            }
//            else if board[row][colum] == -1 {
//                Rectangle()
//                    .frame(height: 2)
//            } else if board[row][colum] == -2 {
//                Rectangle()
//                    .frame(width: 2)
//            }
            
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
    
    func reset() {
        board = [[ 0, -1, -1,  0, -1, -1,  0],
                 [-2,  0, -1,  0, -1,  0, -2],
                 [-2, -2,  0,  0,  0, -2, -2],
                 [ 0,  0,  0, -3,  0,  0,  0],
                 [-2, -2,  0,  0,  0, -2, -2],
                 [-2,  0, -1,  0, -1,  0, -2],
                 [ 0, -1, -1,  0, -1, -1,  0]]
        
        blackTurn = false
        shouldRemove = false
        
        win = false
        
        colorPiece = (9, 9)
        turnCount = 0
    }
    
    func onCellClick(_ row: Int, _ colum: Int) {
        if takeTwoTurn && turnCount < 4 {
            guard board[row][colum] == 0 else {return}
            
            board[row][colum] = blackTurn.player
            if blackTurn {
                colorPiece.black -= 1
            } else {
                colorPiece.white -= 1
            }
            
            turnCount += 1
            if turnCount == 4 {
                takeTwoTurn = false
                blackTurn.toggle()
                return
            } else if turnCount == 2 {
                blackTurn.toggle()
            }
        } else {
            if shouldRemove {
                remove(row,colum)
            } else if colorPiece.black == 0 {
                move(row, colum)
            } else {
                placingPeice(row, colum)
            }
        }
    }
    
    func placingPeice (_ row: Int, _ colum: Int) {
        guard board[row][colum] == 0 else {return}
            
        if blackTurn {
            colorPiece.black -= 1
        } else {
            colorPiece.white -= 1
        }
        board[row][colum] = blackTurn.player
        cheakMatchThree(row, colum)
    }
    
    func move(_ row: Int, _ colum: Int) {
        let player = blackTurn.player
        
        func propper(sttc: Int, diff: Int) -> Bool {
            return max(abs(sttc - 3), 1) == diff
        }
        
        if board[row][colum] == player {
            selected = (row, colum)
        } else if board[row][colum] == 0,
                  (colum == selected.colum && propper(sttc: colum, diff: abs(selected.row - row))) ||
                    ( row == selected.row && propper(sttc: row, diff: abs(selected.colum - colum))) {
            
            board[row][colum] = player
            board[selected.row][selected.colum] = 0
            cheakMatchThree(row, colum)
            selected = (-1, -1)
        }
    }
    
    func cheakMatchThree(_ row: Int, _ colum: Int)  {
        let player = blackTurn.player
        shouldRemove = checkRow(row, colum, for: player) || checkColum(row, colum, for: player)
        
        guard shouldRemove else { return blackTurn.toggle() }
        
        let oponet = blackTurn.opponent
        var removable = false
        
        for i in board.indices {
            for j in board[i].indices where board[i][j] == oponet {
                if !checkRow(i, j, for: oponet) && !checkColum(i, j, for: oponet) {
                    removable = true
                    break
                }
            }
            if removable {break}
        }
        
        if !removable {
            blackTurn.toggle()
            shouldRemove = false
        }
    }
    
    func checkRow(_ row: Int, _ colum: Int, for player: Int) -> Bool {
        if row == 3 {
            if (colum < 3 && board[3][0...2].filter({$0 == player}).count == 3) || board[3][4...6].filter({$0 == player}).count == 3 {
                return true
            }
        } else if board[row].filter({$0 == player}).count == 3 {
            return true
        }
        return false
    }
    
    func checkColum(_ row: Int, _ colum: Int, for player: Int) -> Bool {
        let tempBoard = board.transpose
        
        if colum == 3 {
            if (row < 3 && tempBoard[3][0...2].filter({$0 == player}).count == 3) || tempBoard[3][4...6].filter({$0 == player}).count == 3 {
                return true
            }
        } else if tempBoard[colum].filter({$0 == player}).count == 3 {
            return true
        }
        return false
    }
    
    func remove(_ row: Int, _ colum: Int) {
        let oponet = blackTurn.opponent
        
        guard board[row][colum] == oponet && !(checkRow(row, colum, for: oponet) || checkColum(row, colum, for: oponet)) else{return}
        
        board[row][colum] = 0
        
        if colorPiece.black == 0 && countPeice(for: oponet, in: board) < 3 {
            return win = true
        }
        
        shouldRemove = false
        blackTurn.toggle()
    }
}
func countPeice(for player: Int, in board: [[Int]]) -> Int {
    var c = 0
    for i in board.indices {
        c += board[i].filter{$0 == player}.count
    }
    return c
}


struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(takeTwoTurn: false)
    }
}
