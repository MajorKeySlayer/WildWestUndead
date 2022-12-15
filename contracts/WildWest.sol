// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WildMestPasses is ERC1155Supply, Ownable {
    bool public saleIsActive = false;
    uint public activeBadgeId = 1;
    uint public maxSupply = 356;
    uint256 public maxPerWallet = 5;
    string public name;
    address public caller;
    uint256 public constant PRICE = 1 ether; //0.5 ETH
    uint256 public constant WLPRICE =  0.5 ether; //1 ETH
    uint public maxToken = 100;
    mapping(address => uint256) public _mintTracker;

    string public contractURIstr = "";

    constructor() ERC1155("https://ipfs.io/ipfs/bafkreibz4egwavfwwvyrh75b52x2kfgskensxsig6cdildprbgoaffo36e") {
        name = "Wild West Access Pass";
    }

    address payable private recipient1  = payable(0xa2ad33b9F39324a99CFAFf4437da15DE41388196);

    function contractURI() public view returns (string memory) {
       return contractURIstr;
    }

    function setContractURI(string memory newuri) external onlyOwner{
       contractURIstr = newuri;
    }

    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    function PUBLICMINT(uint256 amount) external payable {
        require(msg.sender == tx.origin, "Transactions originating from Smart Contracts not allowed!");
        require((_mintTracker[msg.sender] + 1) <= maxPerWallet, "Max tokens allowed per wallet limit exceeded.");
        require(saleIsActive, "Sale must be active to mint.");
        require(amount > 0 && amount <= 5 , "Number of tokens to mint, can't exceed 5.");
        require(totalSupply(activeBadgeId) + amount <= maxSupply , "This purchase would exceed max tokens allowed per wallet.");

        if( totalSupply(activeBadgeId) + amount > maxToken) {
            require(msg.value == (PRICE * amount), "Not enough ETH for this transaction.");
        }
        else {
            require(msg.value == (WLPRICE * amount), "Not enough ETH for this transaction."); 
        }
        _mintTracker[msg.sender] = _mintTracker[msg.sender] + amount;
        _mint(msg.sender, activeBadgeId, amount, "");
    }

    function withdraw() external {
        require(msg.sender == recipient1 || msg.sender == owner(), "Invalid sender.");

        uint part = address(this).balance / 100 * 25;
        recipient1.transfer(part);
        payable(owner()).transfer(address(this).balance);
    }

    function flipSaleState() external onlyOwner {
        saleIsActive = !saleIsActive;
    }
    
    function changeSaleDetails(uint _activeBadgeId, uint _maxSupply) external onlyOwner {
        activeBadgeId = _activeBadgeId;
        maxSupply = _maxSupply;
        saleIsActive = false;
    }
}