//
//  helping.swift
//  NavKukriu
//
//  Created by home on 02/12/21.
//

import Foundation

extension Collection where Self.Iterator.Element: Collection {
    var transpose: Array<Array<Self.Iterator.Element.Iterator.Element>> {
        var result = Array<Array<Self.Iterator.Element.Iterator.Element>>()
        if self.isEmpty {return result}
        
        var index = self.first!.startIndex
        while index != self.first!.endIndex {
            var subresult = Array<Self.Iterator.Element.Iterator.Element>()
            for subarray in self {
                subresult.append(subarray[index])
            }
            result.append(subresult)
            index = self.first!.index(after: index)
        }
        return result
    }
}

extension Bool {
    var player: Int { self ? 1 : 2 }
    var opponent : Int { self ? 2 : 1 }
}
