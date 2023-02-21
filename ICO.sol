// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./WinToken.sol";

contract myIco {
    struct InfoToken {
        ERC20 token;
        address owner;
        uint256 startTIme;
        uint256 endTime;
        uint256 priceToken;
    }
    mapping(uint=>address) public new_ICO_addr;

    mapping(uint256 => InfoToken) public icoInfo;
    uint256 counter;
    uint256  transferAmount;

    function createIco(
        uint256 _startTIme,
        uint256 _endTime,
        uint256 _priceToken
    ) public {
        counter++;
        // require(_startTIme > 0, "startTime is can't be zero");
        // require(_endTime > _startTIme, "Endtime can't before Starttime");

        Winner wn = new Winner(msg.sender);
        icoInfo[counter] = InfoToken(
            ERC20(wn),
            msg.sender,
            _startTIme,
            _endTime,
            _priceToken
        );
        new_ICO_addr[counter]=address(ERC20(wn));
    }

    function addToken(uint256 icoNum, uint256 _amount)
        public
        payable
        returns (uint256)
    {
        icoInfo[icoNum].token.transferFrom(msg.sender, address(this), _amount);

        return icoInfo[icoNum].token.balanceOf(address(this));
    }

    function Invest(uint256 numICO)
        public
        payable
        returns (uint256 tokenRecived)
    {
        // require(icoInfo[numICO].owner != address(0), "No Ico Found");
        // require(block.timestamp >= icoInfo[numICO].startTIme,"Ico not started");
        // require(block.timestamp <= icoInfo[numICO].endTime, "Ico was Ended");
        // require(icoInfo[numICO].amount > 0,"All tokens sold");
        // require(_amount <= icoInfo[numICO].amount, "Tokens Not available");
        InfoToken memory current = icoInfo[numICO];

        uint256 tokenAmount = current.token.balanceOf(address(this));
        uint256 tokenPrice = icoInfo[numICO].priceToken;
        uint256 amoutnInEth = (tokenAmount * tokenPrice) / 10**18;
        tokenRecived = (msg.value * 10**18) / (tokenPrice);

        if (tokenRecived > tokenAmount) {
            uint256 returnAMount = msg.value -
                (tokenAmount * tokenPrice) /
                10**18;
            payable(current.owner).transfer(msg.value - returnAMount);
            current.token.transfer(msg.sender, tokenAmount);
            payable(msg.sender).transfer(returnAMount);
        } else {
            payable(current.owner).transfer(amoutnInEth);
            current.token.transfer(msg.sender, tokenRecived);
        }
    }
}

// 1,2,10000000000000000

// 0.01 ===10000000000000000
// 0.02 ===20000000000000000
