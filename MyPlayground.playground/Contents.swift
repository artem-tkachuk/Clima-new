func calculator(n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(n1, n2)
}

let result = calculator(n1: 2, n2: 3) { $0 * $1 } //trailing closure

print(result)

func multiply(no1: Int, no2: Int) -> Int {
    return no1 * no2
}


// $0 - first parameter
// $1 - second parameter


var array = [6, 2, 3, 9, 4, 1]


array = array.map{ $0 + 1 }
print(array)

//Type inference for input parameters and output
func addOne(n1: Int) -> Int {
    return n1 + 1 //Delete "return" is implicit return because we only have one expression in out closure
}

//Map, reduce, and filter
let newArray = array.map{String($0)}
print(newArray)
