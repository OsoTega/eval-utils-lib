//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Sample} from "../src/Sample.sol";
import {Test, console} from "forge-std/Test.sol";

contract EvalUtilsTest is Test {
    Sample sample;

    function setUp() external {
        sample = new Sample();
    }

    function testCheckList() external {
        uint256 a = sample.exampleCheckList();
        assertEq(a, 252);
    }
}
