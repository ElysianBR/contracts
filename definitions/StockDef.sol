// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./StockPksDef.sol";

/**
 * @title StockDef
 */
struct StockDef {
    StockPksDef pks;
    uint256 manufacturing_timestamp;
    uint256 validity_timestamp;
    uint quantity;
}
