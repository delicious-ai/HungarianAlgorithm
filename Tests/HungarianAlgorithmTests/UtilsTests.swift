//
//  UtilsTests.swift
//  
//
//  Created by Spencer Young on 7/17/23.
//

@testable import HungarianAlgorithm
import XCTest

final class UtilsTests: XCTestCase {
    func testArgsortWorksForNumericArray() throws {
        let arr: [Double] = [3.0, 1.0, 2.0, -3.0, 15.0]
        let expectedResult: [Int] = [3, 1, 2, 0, 4]

        XCTAssertEqual(argsort(arr), expectedResult)
    }

    func testArgsortWorksForStringArray() throws {
        let arr: [String] = ["a", "z", "c", "g", "x"]
        let expectedResult: [Int] = [0, 2, 3, 4, 1]

        XCTAssertEqual(argsort(arr), expectedResult)
    }

    func testCreateRandomMatrixProducesValuesFromZeroToOne() throws {
        let numRows = 3
        let numColumns = 21
        let matrix = createRandomMatrix(rows: numRows, columns: numColumns)
        for rowIndex in 0 ..< numRows {
            for columnIndex in 0 ..< numColumns {
                XCTAssertTrue(matrix[rowIndex][columnIndex] <= 1.0)
                XCTAssertTrue(matrix[rowIndex][columnIndex] >= 0.0)
            }
        }
    }

    func testCreateRandomMatrixProducesCorrectMatrixShape() throws {
        let numRows = 51
        let numColumns = 27
        let matrix = createRandomMatrix(rows: numRows, columns: numColumns)
        XCTAssertEqual(matrix.count, numRows)
        XCTAssertEqual(matrix[0].count, numColumns)
    }
}
