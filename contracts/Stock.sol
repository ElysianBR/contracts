// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

import "definitions/StockDef.sol";
import "definitions/StockPksDef.sol";
import "definitions/MovimentDef.sol";

/**
 * @title Stock
 */
contract Stock {
    address public minter;

    mapping(address => StockDef[]) stock;

    constructor() {
        minter = msg.sender;
    }

    error InsuficientStock(uint256 requested, uint256 available);
    error StockNotFound();

    function findStockIndex(StockPksDef calldata pks)
        public
        view
        returns (uint256)
    {
        StockDef[] storage stocksSender = stock[msg.sender];

        for (uint256 i = 0; i < stocksSender.length; i++) {
            StockDef storage i_stock = stocksSender[i];
            if (
                i_stock.pks.product_id == pks.product_id &&
                keccak256(bytes(i_stock.pks.control)) ==
                keccak256(bytes(pks.control))
            ) {
                return i;
            }
        }
        revert StockNotFound();
    }

    function mintStock(StockDef calldata stockMint) public {
        require(msg.sender == minter);

        StockDef[] storage stocksSender = stock[msg.sender];

        uint256 stockIndex;
        bool stockExists;
        try this.findStockIndex(stockMint.pks) returns (uint256 index) {
            stockIndex = index;
            stockExists = true;
        } catch {
            stockExists = false;
        }

        if (stockExists) {
            StockDef storage i_stock = stocksSender[stockIndex];
            i_stock.quantity += stockMint.quantity;
        } else {
            stocksSender.push(stockMint);
        }
    }

    function movimentStock(MovimentDef calldata moviment) public {
        StockDef[] storage stocksSender = stock[msg.sender];

        uint256 stockIndex = findStockIndex(moviment.pks);
        StockDef storage i_stock = stocksSender[stockIndex];

        require(
            moviment.quantity <= i_stock.quantity,
            InsuficientStock(moviment.quantity, i_stock.quantity)
        );

        i_stock.quantity -= moviment.quantity;
    }
}
