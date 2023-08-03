//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {StringsArrayUtilsLib} from "array-utils-lib/array-utils/StringsArrayUtilsLib.sol";
import {StringUtilsLib} from "string-utils-lib/StringUtilsLib.sol";

library EvalUtils {
    using StringsArrayUtilsLib for string[];
    using StringUtilsLib for string;

    function isOperator(string memory val) private pure returns (bool) {
        string[] memory actions = new string[](4);
        actions[0] = "+";
        actions[1] = "-";
        actions[2] = "*";
        actions[3] = "/";

        return actions.includes(val);
    }

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

    function getNextOperand(
        string[] memory array,
        uint256 index
    ) private pure returns (string memory) {
        return (index + 2) > (array.length - 1) ? "Null" : array[index + 2];
    }

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

    function getList(string memory cal) private pure returns (string[] memory) {
        string[] memory pa = new string[](cal.length());
        uint256 ca = 0;
        getOperatingList(0, pa, cal, ca, 0);
        return pa.trim();
    }

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
