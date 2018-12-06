//
//  main.swift
//  AdventofCode2018
//
//  Created by Steven Myers on 12/5/18.
//  Copyright © 2018 Steven Myers. All rights reserved.
//

import Foundation
let path = "/Users/larken/git/AdventOfCode2018/5/AdventofCode2018/Resources/input.txt"

func doesReact(unitA: String, unitB: String) -> Bool {
    return unitA != unitB && unitA.lowercased() == unitB.lowercased()
}

func containsReaction(polymers: Array<String>) -> Bool {
    for i in (1...polymers.count - 1).reversed() {
        if doesReact(unitA: polymers[i], unitB: polymers[i-1]) {
            return true
        }
    }
    return false
}

func react(polymers: inout Array<String>) -> Void {
    for i in (0...polymers.count - 2).reversed() {
        if doesReact(unitA: polymers[i], unitB: polymers[i+1])  {
            polymers.remove(at: i)
            polymers.remove(at: i)
//            if we remove at the very beginning, it's possible to try and grab an element that no longer exists
            if (polymers.count <= i) { return }
        }
    }
}

func solveA(polymerString: String) -> Void {
    var polymers: Array<String> = Array(polymerString).map { String($0)}
    while (containsReaction(polymers: polymers)) {
        react(polymers: &polymers)
    }
    print(polymers.count)
}

func solveB(polymerString: String) -> Void {
    var fewestEndingPolymers = Int.max
    let originalPolymers: Array<String> = Array(polymerString).map { String($0)}
    // Get unique units, regardless of polarity
    let uniqueUnits = Array(Set(originalPolymers.map() { $0.lowercased()}))
    for unit in uniqueUnits {
        // filter the polymer string
        var polymers = originalPolymers.filter { $0 != unit && $0 != unit.uppercased()}
        while (containsReaction(polymers: polymers)) {
            react(polymers: &polymers)
        }
        fewestEndingPolymers = polymers.count < fewestEndingPolymers ? polymers.count : fewestEndingPolymers
    }
   
    print(fewestEndingPolymers)
}

do {
    let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8);
    let polymerString = String(data).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    solveA(polymerString: polymerString)
    solveB(polymerString: polymerString)
    
}


