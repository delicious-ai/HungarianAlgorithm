//
//  HungarianAlgorithm.swift
//
//
//  Created by Spencer Young on 7/13/23.
//

import LASwift

enum AssignmentError: Error {
    case infeasibleCostMatrix
}

enum HungarianAlgorithm {
    /**
     Use the Hungarian Algorithm to solve the two-dimensional rectangular assignment problem (given an appropriate cost matrix).

     If the given cost matrix is infeasible (this occurs when all possible assignments for a worker have infinite cost), an AssignmentError is thrown.

     Given a set of `m` "workers" and `n` "jobs", where `costMatrix[i, j]` is the cost of assigning worker `i` to job `j`, the Hungarian Algorithm
     returns the optimal assignments (minimizing total cost in an efficient manner) until either the number of workers or number of jobs is exhausted.

     In accordance with Scipy's version of the Hungarian Algorithm, `scipy.optimize.linear_sum_assignment`, this implementation
     is largely drawn from the algorithm detailed in pages 1685-1686 of:

         DF Crouse. On implementing 2D rectangular assignment algorithms.
         IEEE Transactions on Aerospace and Electronic Systems
         52(4):1679-1696, August 2016
         doi: 10.1109/TAES.2016.140952

     - Parameters:
        - costMatrix: A `(m,n)` matrix where the `[i, j]` entry represents the cost of assigning worker `i` to job `j`.

     - Returns: `(rowIndices, columnIndices)`: The optimal assignments, where `zip(rowIndices, columnIndices)`  creates a list
                                              of the found pairings. The assignments will come back sorted in ascending order by row index.
     */
    static func findOptimalAssignment(_ costMatrix: Matrix) throws
        -> (rowIndices: [Int], columnIndices: [Int]) {
        var numRows: Int = costMatrix.rows
        var numColumns: Int = costMatrix.cols

        var costMatrixCopy: Matrix

        let transposeCostMatrix: Bool = (numColumns < numRows)
        if transposeCostMatrix {
            costMatrixCopy = costMatrix.T
            swap(&numRows, &numColumns)
        } else {
            costMatrixCopy = costMatrix
        }

        var u = Array(repeating: 0.0, count: numRows)
        var v = Array(repeating: 0.0, count: numColumns)
        var shortestPathCosts = Array(repeating: Double.infinity, count: numColumns)
        var path = Array(repeating: -1, count: numColumns)
        var rowAssignments = Array(repeating: -1, count: numRows)
        var columnAssignments = Array(repeating: -1, count: numColumns)
        var visitedRows = Array(repeating: false, count: numRows)
        var visitedColumns = Array(repeating: false, count: numColumns)

        for currentRowIndex in 0 ..< numRows {
            // Find shortest augmenting path.
            let indexOfFinalColumnInAugmentingPath: Int
            let minCost: Double
            (indexOfFinalColumnInAugmentingPath, minCost) = _findShortestAugmentingPath(
                costMatrixCopy, &u, &v, &path, &columnAssignments, &shortestPathCosts,
                currentRowIndex, &visitedRows, &visitedColumns
            )

            if indexOfFinalColumnInAugmentingPath == -1, minCost == Double.infinity {
                throw AssignmentError.infeasibleCostMatrix
            }

            // Update dual variables.
            u[currentRowIndex] += minCost
            for i in 0 ..< numRows where visitedRows[i] && (i != currentRowIndex) {
                u[i] += (minCost - shortestPathCosts[rowAssignments[i]])
            }
            for j in 0 ..< numColumns where visitedColumns[j] {
                v[j] -= (minCost - shortestPathCosts[j])
            }

            // Augment previous solution by stepping through the path.
            var j: Int = indexOfFinalColumnInAugmentingPath
            while true {
                let i = path[j]
                columnAssignments[j] = i
                let temp = rowAssignments[i]
                rowAssignments[i] = j
                j = temp

                if i == currentRowIndex {
                    break
                }
            }
        }

        var rowIndices: [Int] = Array(repeating: -1, count: numRows)
        var columnIndices: [Int] = Array(repeating: -1, count: numRows)

        // Translate assignments into expected row/column index format.
        if transposeCostMatrix {
            var i = 0
            for v in argsort(rowAssignments) {
                rowIndices[i] = rowAssignments[v]
                columnIndices[i] = v
                i += 1
            }
        } else {
            for i in 0 ..< numRows {
                rowIndices[i] = i
                columnIndices[i] = rowAssignments[i]
            }
        }
        return (rowIndices, columnIndices)
    }

    /**
     Find the shortest (lowest cost) augmenting path starting from `currentRowIndex`.

     An augmenting path is defined as an alternating path that starts at an unassigned row and ends at an unassigned column.
     In between, this path must alternate between assigned rows and columns.

     This method is a variation on Dijkstra's algorithm that also utilizes and updates dual variables for the corresponding optimization problem.

     - Parameters:
        - costMatrix: The cost matrix of the corresponding linear assignment problem.
        - u: Vector of dual variables (corresponding to the rows of the cost matrix) for the linear assignment problem.
        - v: Vector of dual variables (corresponding to the columns of the cost matrix) for the linear assignment problem.
        - path: Vector to store the found shortest augmenting path.
        - columnAssignments: Vector to store the assigned row for each respective column.
        - shortestPathCosts: Vector to store the cost of the respective shortest augmenting path from each row.
        - currentRowIndex: The current row to find the shortest augmenting path from.
        - visitedRows: Vector to store which rows have been visited during the augmenting path traversal.
        - visitedColumns: Vector to store which columns have been visited during the augmenting path traversal.
     */
    static func _findShortestAugmentingPath(
        _ costMatrix: Matrix,
        _ u: inout [Double], _ v: inout [Double],
        _ path: inout [Int], _ columnAssignments: inout [Int],
        _ shortestPathCosts: inout [Double], _ currentRowIndex: Int,
        _ visitedRows: inout [Bool], _ visitedColumns: inout [Bool]
    ) -> (indexOfFinalColumnInAugmentingPath: Int, minCost: Double) {
        var i = currentRowIndex
        let numColumns = costMatrix.cols

        visitedRows.replaceSubrange(
            0 ..< visitedRows.count,
            with: repeatElement(false, count: visitedRows.count)
        )
        visitedColumns.replaceSubrange(
            0 ..< visitedColumns.count,
            with: repeatElement(false, count: visitedColumns.count)
        )
        shortestPathCosts.replaceSubrange(
            0 ..< shortestPathCosts.count,
            with: repeatElement(Double.infinity, count: shortestPathCosts.count)
        )

        var minCost = 0.0
        var indexOfFinalColumnInAugmentingPath = -1

        while indexOfFinalColumnInAugmentingPath == -1 {
            visitedRows[i] = true

            var indexOfLowestCostSeen = -1
            var lowestCostSeen = Double.infinity
            let unvisitedColumns = Array(zip(0 ..< numColumns, visitedColumns))
                .filter { !$0.1 }
                .map { $0.0 }

            for columnIndex in unvisitedColumns {
                let x: Double = minCost + costMatrix[i, columnIndex] - u[i] - v[columnIndex]
                if x < shortestPathCosts[columnIndex] {
                    path[columnIndex] = i
                    shortestPathCosts[columnIndex] = x
                }

                let columnHasNotBeenAssignedToRow: Bool = (columnAssignments[columnIndex] == -1)
                let columnIsLowerCost: Bool = (shortestPathCosts[columnIndex] < lowestCostSeen)
                let columnIsEqualCost: Bool = (shortestPathCosts[columnIndex] == lowestCostSeen)

                if columnIsLowerCost || (columnIsEqualCost && columnHasNotBeenAssignedToRow) {
                    lowestCostSeen = shortestPathCosts[columnIndex]
                    indexOfLowestCostSeen = columnIndex
                }
            }

            minCost = lowestCostSeen
            if minCost == Double.infinity {
                return (-1, minCost) // Infeasible cost matrix
            }

            visitedColumns[indexOfLowestCostSeen] = true

            let indexOfNextColumnInPath: Int = indexOfLowestCostSeen
            let columnHasNotBeenAssignedToRow: Bool = (columnAssignments[indexOfNextColumnInPath] == -1)

            if columnHasNotBeenAssignedToRow {
                indexOfFinalColumnInAugmentingPath = indexOfNextColumnInPath
            } else {
                i = columnAssignments[indexOfNextColumnInPath]
            }
        }
        return (indexOfFinalColumnInAugmentingPath, minCost)
    }
}
