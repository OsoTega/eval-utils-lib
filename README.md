# String Evaluation Utils Library for Solidity

# About
This is a comprehensive string evaluation utils library for processing and programmatically working with arithmetic strings of primitive data. This library is focused on making arithmetic task on strings more user-friendly, or programmer friendly.

The gas cost for implementing the operations would definitely defer, depending on the size and length of the string being processed. For large strings, pre-processing is advised, so as to reduce the gas cost. This library only provides one function, the evaluate function, it consumes much more gas than other operations, and is advised to be used wisely, preferably on smaller strings.

The function is written with simplicity in mind, and should be easy to use and implement, please feel free to make any request or update for request to me, it's still a work in progress, and this contribution is important to the Web3 Community. Code Away  


# Getting started
install this library by running this on your terminal
```foundry
forge install OsoTega/eval-utils-lib --no-commit
```

# Examples
## Importing to Project
import the library at the top of the contract you want to use it in
```solidity
//importing the string array library
import {EvalUtils} from "eval-utils-lib/EvalUtils.sol"

contract UseContract{
    using StringsArrayUtilsLib for string[];

    //...
}
```

## Using the evaluate function
The evaluate function is programmed to evaluate arithmetic strings, and return the result as a number. The function would take in the arithemtic operation to run, as they would be typed usually, and then computes the string to provide the arithmetic result as a uint256 number. Currently the only operations available are the basic addition, subtraction, multiplication and division. As the usage progresses, other operations would be added. As stated earlier in the introduction, this function is to be used carefully with smaller strings, to reduce the gas cost, as it can easily cost to much gas. Hopefully the gas optimization would be solved in the next update. The function takes in an arguement.
1. The string to compute,

```solidity

return EvalUtils.evaluate("(4*5-2)*7/(2/2)*4/2");

//expected result is 252

return EvalUtils.evaluate("2+2");

//expected result is 4
```

## Requirements
The contract was written using solidity ^0.8.18

