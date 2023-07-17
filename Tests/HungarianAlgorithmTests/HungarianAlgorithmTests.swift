//
//  HungarianAlgorithmTests.swift
//
//
//  Created by Spencer Young on 7/17/23.
//

@testable import HungarianAlgorithm
import LASwift
import XCTest

final class HungarianAlgorithmTests: XCTestCase {
    func testHungarianAlgorithmIsCorrectWithSquareCostMatrix() throws {
        let costMatrix = Matrix([
            Vector([1.0, 2.0, 3.0]),
            Vector([4.0, 5.0, 6.0]),
            Vector([7.0, 8.0, 12.0]),
        ])
        let expectedRowIndices: [Int] = [0, 1, 2]
        let expectedColumnIndices: [Int] = [2, 1, 0]
        let solution = try HungarianAlgorithm.findOptimalAssignment(costMatrix)
        XCTAssertEqual(solution.rowIndices, expectedRowIndices)
        XCTAssertEqual(solution.columnIndices, expectedColumnIndices)
    }

    func testHungarianAlgorithmIsCorrectWhenCostMatrixHasMoreColumnsThanRows() throws {
        let costMatrix = Matrix([
            Vector([1.0, 45.0, 39.0, 400.0, 29.0, 0.0]),
            Vector([1.0, 12.0, 14.0, 125.0, 16.0, 10.0]),
            Vector([43.0, 0.0, 1000.0, 5.0, 5.0, 3.0]),
        ])
        let expectedRowIndices: [Int] = [0, 1, 2]
        let expectedColumnIndices: [Int] = [5, 0, 1]
        let solution = try HungarianAlgorithm.findOptimalAssignment(costMatrix)
        XCTAssertEqual(expectedRowIndices, solution.rowIndices)
        XCTAssertEqual(expectedColumnIndices, solution.columnIndices)
    }

    func testHungarianAlgorithmIsCorrectWhenCostMatrixHasMoreRowsThanColumns() throws {
        let costMatrix = Matrix([
            Vector([1.0, 13.0, 43.0]),
            Vector([45.0, 13.0, 0.0]),
            Vector([39.0, 0.0, 1000.0]),
            Vector([400.0, 13.0, 5.0]),
            Vector([29.0, 13.0, 5.0]),
            Vector([50.0, 13.0, 3.0]),
        ])
        let expectedRowIndices: [Int] = [0, 1, 2]
        let expectedColumnIndices: [Int] = [0, 2, 1]
        let solution = try HungarianAlgorithm.findOptimalAssignment(costMatrix)

        XCTAssertEqual(solution.rowIndices, expectedRowIndices)
        XCTAssertEqual(solution.columnIndices, expectedColumnIndices)
    }

    func testHungarianAlgorithmIsCorrectWhenCostMatrixHasNegativeValues() throws {
        let costMatrix = Matrix([
            Vector([-25.0, 3.0]),
            Vector([-50.0, 20.0]),
        ])
        let expectedRowIndices: [Int] = [0, 1]
        let expectedColumnIndices: [Int] = [1, 0]
        let solution = try HungarianAlgorithm.findOptimalAssignment(costMatrix)

        XCTAssertEqual(solution.rowIndices, expectedRowIndices)
        XCTAssertEqual(solution.columnIndices, expectedColumnIndices)
    }

    func testHungarianAlgorithmHandlesInfeasibleCostMatrix() throws {
        let costMatrix = Matrix([
            Vector([Double.infinity, Double.infinity]),
            Vector([Double.infinity, Double.infinity]),
        ])
        XCTAssertThrowsError(try HungarianAlgorithm.findOptimalAssignment(costMatrix))
    }
}
