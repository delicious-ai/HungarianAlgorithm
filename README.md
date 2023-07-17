# HungarianAlgorithm

[![Build](https://github.com/spencermyoung513/HungarianAlgorithm/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/spencermyoung513/HungarianAlgorithm/actions/workflows/swift.yml)

This package contains an efficient implementation of the Hungarian Algorithm (otherwise known as the Munkres Assignment Algorithm), which is the optimal 
method to compute the solution to the two-dimensional rectangular assignment problem. The algorithm runs in O(n^3) time. It has been generalized to work
for cost matrices of arbitrary size (not necessarily square) and with both positive and negative costs.

For more information about the history and use of the algorithm, see
[its Wikipedia page](https://en.wikipedia.org/wiki/Hungarian_algorithm).

In recent years, the Hungarian Algorithm has been used in deep learning methods such as Facebook's [DETR](https://arxiv.org/abs/2005.12872) and has a 
[widely-employed implementation](https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.linear_sum_assignment.html) in Python's `scipy` library. However, to date, no fast implementation (using the Jonker-Volgenant variant) of the method exists
in Swift, despite the growing use of machine learning in IOS mobile applications. This package is an attempt to remedy that.

## Installation

### Swift Package Manager

You can install `HungarianAlgorithm` into a local Swift environment by modifying your `Package.swift` file:

```swift
import PackageDescription

 let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(
            url: "https://github.com/spencermyoung513/HungarianAlgorithm",
        )
    ],
    targets: [
        .target(
            name: "YOUR_PROJECT_NAME",
            dependencies: [
                .product(name: "HungarianAlgorithm", package: "hungarianalgorithm"),
            ])
    ]
)
```

## Usage

To use the algorithm, first specify a cost matrix. The `[i, j]` entry of this matrix defines the cost of assigning worker `i` to job `j`.
Matrices must be created using the convention defined in the highly optimized [LASwift package](https://github.com/AlexanderTar/LASwift),
as shown below:

```swift
let costMatrix = Matrix([
    Vector([1.0, 2.0, 3.0]),
    Vector([4.0, 5.0, 6.0]),
    Vector([7.0, 8.0, 12.0]),
])
``` 

Next, simply use the `HungarianAlgorithm.findOptimalAssignment` method with the defined cost matrix. This will return the row indices and column indices, 
respectively, that indicate the optimal assignments -- `(rowIndices[0], columnIndices[0])` is the first pair, and so on. 

```swift
(rowIndices, columnIndices) = HungarianAlgorithm.findOptimalAssignment(costMatrix)
```

For alternative examples, refer to the unit tests found in `Tests/HungarianAlgorithmTests`.

## Future Contributions

To add to this repository, create a branch, push your changes, and submit a Merge Request. I will review it before merging.

## Author

Spencer Young, spencermyoung513@gmail.com

## License

This package is available for unconditional usage under the MIT license. See `LICENSE.md` for more information.
