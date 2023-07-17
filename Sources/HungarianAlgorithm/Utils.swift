//
//  Utils.swift
//  
//
//  Created by Spencer Young on 7/17/23.
//

/**
 Get the indices that will sort an array (in ascending order).

 - Parameters:
 - a: The array to get the sorted indices of.

 - Returns:
 - The indices that will sort `a`.
 */
func argsort<T: Comparable>(_ a: [T]) -> [Int] {
    var r = Array(a.indices)
    r.sort(by: { a[$0] < a[$1] })
    return r
}

/**
 Creates a psuedorandom matrix of size (`rows`, `columns`) with entries between 0 and 1.
 */
func createRandomMatrix(rows: Int, columns: Int) -> [[Double]] {
    var matrix = [[Double]](repeating: [Double](repeating: 0.01, count: columns), count: rows)
    for i in 0 ..< rows {
        for j in 0 ..< columns {
            matrix[i][j] *= Double(Int.random(in: 0 ... 100))
        }
    }
    return matrix
}
