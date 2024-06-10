// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomToken is ERC20, Ownable {
    mapping(address => bool) private _whitelist;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) Ownable(msg.sender) {}

    // Function to mint new tokens
    function mint(address account, uint256 amount) external onlyOwnerOrWhitelisted {
        require(_whitelist[msg.sender], "Account not whitelisted for minting");
        _mint(account, amount);
    }

    // Function to burn tokens
    function burn(uint256 amount) external onlyOwnerOrWhitelisted {
        require(_whitelist[msg.sender], "Sender not whitelisted for burning");
        _burn(msg.sender, amount);
    }

    // Function to add address to the whitelist
    function addToWhitelist(address account) external onlyOwner {
        _whitelist[account] = true;
    }

    // Function to remove address from the whitelist
    function removeFromWhitelist(address account) external onlyOwner {
        _whitelist[account] = false;
    }

    modifier onlyOwnerOrWhitelisted() {
        require(_whitelist[msg.sender], "Caller is not the owner or not whitelisted");
        _;
    }
}
