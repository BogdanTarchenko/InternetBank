import Foundation

struct Factory<T> {
    let make: () -> T
}

struct ParameterizedFactory<Input, T> {
    let make: (Input) -> T
}
