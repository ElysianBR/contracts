// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

import "./StockPksDef.sol";

/**
 * @title MovimentDef
 */
struct MovimentDef {
    StockPksDef pks;
    address recipient;
    uint256 manufacturing_timestamp;
    uint256 validity_timestamp;
    uint quantity;
}