//SPDX-License-Identifier: MIT

/*
 * @title String Evaluation Utils Library for Solidity contracts.
 * @author Tega Osowa <https://tega-osowa-portfolio.netlify.app/>
 *
 * @dev This is a comprehensive string evaluation utils library for processing and
 *      programmatically working with arithmetic strings of primitive data. This
 *      library is focused on making arithmetic task on strings more user-friendly, or
 *      programmer friendly.This is a comprehensive string evaluation utils library for
 *      processing and programmatically working with arithmetic strings of primitive
 *      data. This library is focused on making arithmetic task on strings more
 *      user-friendly, or programmer friendly.
 *
 *      The gas cost for implementing various operations would definitely defer,
 *      depending on the size and length of the string being processed. For large strings,
 *      pre-processing is advised, so as to reduce the gas cost. The operation consumes much more
 *      gas  and is advised to be used wisely, preferably on smaller strings.
 *      All functions are written with simplicity in mind, and should be easy to use and
 *      implement, please feel free to make any request or update for request to me,
 *      it's still a work in progress, and this contribution is important to the Web3 Community.
 *      Code Away
 */

pragma solidity ^0.8.18;

import {StringsArrayUtilsLib} from "array-utils-lib/array-utils/StringsArrayUtilsLib.sol";
import {StringUtilsLib} from "string-utils-lib/StringUtilsLib.sol";

library EvalUtils {
    using StringsArrayUtilsLib for string[];
    using StringUtilsLib for string;

    /*
     * @dev Checks if the string is an operation or number
     * @param eval The string to check.
     * @return A bool if the string is an operation.
     */
    function isOperator(string memory val) private pure returns (bool) {
        string[] memory actions = new string[](4);
        actions[0] = "+";
        actions[1] = "-";
        actions[2] = "*";
        actions[3] = "/";

        return actions.includes(val);
    }

    /*
     * @dev Retrieves all the brackets from the string
     * @param index The index to start checking from.
     * @param text The string to check.
     * @return The index where the closing bracket was found, and the content of the bracket.
     */
    function getBrackets(
        uint256 index,
        string memory text
    ) private pure returns (string memory, uint256) {
        string memory textBrack = "";
        uint256 indexBrack = 0;
        for (uint256 i = index + 1; i < text.length(); i++) {
            if (!text.charAt(i).isEqual(")")) {
                textBrack = string.concat(textBrack, text.charAt(i));
                indexBrack = i;
            } else {
                break;
            }
        }
        return (textBrack, indexBrack + 1);
    }

    /*
     * @dev Retrieves the list of all numbers and operations in the string recursively
     * @param i The index to start checking from.
     * @param pa The array to save the found string.
     * @param evaluateA The string to check.
     * @param ca A variable fro keeping track
     * @param paCount A variable for counting the index in the array.
     * @return Nothing to return.
     */
    function getOperatingList(
        uint256 i,
        string[] memory pa,
        string memory evaluateA,
        uint256 ca,
        uint256 paCount
    ) private pure {
        if (i < evaluateA.length()) {
            if (evaluateA.charAt(i).isEqual("(")) {
                (string memory text, uint256 count) = getBrackets(i, evaluateA);
                pa[paCount] = text;
                getOperatingList(count + 1, pa, evaluateA, ca, paCount + 1);
            } else {
                if (isOperator(evaluateA.charAt(i)) == false) {
                    !pa[ca].isEqual("")
                        ? pa[ca] = string.concat(pa[ca], evaluateA.charAt(i))
                        : pa[ca] = evaluateA.charAt(i);
                } else {
                    if (isOperator(pa[pa.length - 1]) == true) {
                        i = evaluateA.length();
                    } else {
                        pa[paCount] = evaluateA.charAt(i);
                    }
                    ca += 2;
                }
                getOperatingList(i + 1, pa, evaluateA, ca, paCount + 1);
            }
        }
    }

    /*
     * @dev Looks ahead to return next operand
     * @param array The string array to check.
     * @param index The index of the array to look from.
     * @return Null if the index is greater than the array, return the operand.
     */
    function getNextOperand(
        string[] memory array,
        uint256 index
    ) private pure returns (string memory) {
        return (index + 2) > (array.length - 1) ? "Null" : array[index + 2];
    }

    /*
     * @dev Arithmetic operation using the operand
     * @param first The first string of the arithmetic.
     * @param operator The operand string of the arithmetic.
     * @param second The second string of the arithmetic.
     * @return The evaluted result as a string.
     */
    function arithmetic(
        string memory first,
        string memory operator,
        string memory second
    ) private pure returns (string memory) {
        uint256 result = 0;
        if (operator.isEqual("+")) {
            result = (first.parseInt() + second.parseInt());
        } else if (operator.isEqual("-")) {
            result = (first.parseInt() - second.parseInt());
        } else if (operator.isEqual("/")) {
            result = (first.parseInt() / second.parseInt());
        } else if (operator.isEqual("*")) {
            result = (first.parseInt() * second.parseInt());
        }
        return StringUtilsLib.parseString(result);
    }

    /*
     * @dev Uses recusion to evaluate the array of strings
     * @param array The array of strings to evaluate.
     * @param scoreChar An array of the operands.
     * @param score An array of the scores of every operand.
     * @return The evaluated first element from the array
     */
    function createTree(
        string[] memory array,
        string[] memory scoreChar,
        uint256[] memory score
    ) private pure returns (string memory) {
        if (array.length > 1) {
            uint256 largestScore = 0;
            uint256 focus = 0;
            for (uint256 i = 1; i < array.length; i += 2) {
                if (score[scoreChar.indexOf(array[i])] > largestScore) {
                    largestScore = score[scoreChar.indexOf(array[i])];
                    focus = i;
                }
            }

            string memory answer = arithmetic(
                createTree(getList(array[focus - 1]), scoreChar, score),
                array[focus],
                createTree(getList(array[focus + 1]), scoreChar, score)
            );
            string[] memory array0 = new string[](array.length);
            uint256 arrCount = 0;
            for (uint256 i = 0; i < array.length; i++) {
                if (i == (focus - 1)) {
                    array0[arrCount] = string.concat(answer, "");
                    arrCount++;
                } else {
                    if ((i != (focus + 1)) && (i != (focus))) {
                        array0[arrCount] = array[i];
                        arrCount++;
                    }
                }
            }

            string[] memory array1 = array0.trim();
            if (array[focus].isEqual("*") || array[focus].isEqual("/")) {
                string memory nextOperator = getNextOperand(array, focus);
                if (!nextOperator.isEqual("Null")) {
                    if (nextOperator.isEqual("/")) {
                        score[scoreChar.indexOf("/")] = 5;
                        score[scoreChar.indexOf("*")] = 4;
                    } else {
                        score[scoreChar.indexOf("/")] = 4;
                        score[scoreChar.indexOf("*")] = 5;
                    }
                    return createTree(array1, scoreChar, score);
                } else {
                    return createTree(array1, scoreChar, score);
                }
            } else {
                return createTree(array1, scoreChar, score);
            }
        } else {
            return array[0];
        }
    }

    /*
     * @dev Returns the string array
     * @param cal the string to evaluate
     * @return The string array
     */
    function getList(string memory cal) private pure returns (string[] memory) {
        string[] memory pa = new string[](cal.length());
        uint256 ca = 0;
        getOperatingList(0, pa, cal, ca, 0);
        return pa.trim();
    }

    /*
     * @dev Evaluates the string
     * @param eval The string to compute.
     * @return The number.
     */
    function evaluate(string memory eval) internal pure returns (uint256) {
        string[] memory array = getList(eval);
        string[] memory scoreChar = new string[](4);
        uint256[] memory score = new uint256[](4);
        scoreChar[0] = "+";
        scoreChar[1] = "-";
        scoreChar[2] = "*";
        scoreChar[3] = "/";

        score[0] = 2;
        score[1] = 1;
        score[2] = 5;
        score[3] = 4;
        return createTree(array, scoreChar, score).parseInt();
    }
}
