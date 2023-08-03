//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {EvalUtils} from "../src/EvalUtils.sol";

contract Sample {
    function exampleCheckList() public pure returns (uint256) {
        return EvalUtils.evaluate("(4*5-2)*7/(2/2)*4/2");
    }
}
