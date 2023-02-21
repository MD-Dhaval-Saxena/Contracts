    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

    contract myIco {
        struct InfoToken {
            ERC20 token;
            address owner;
            uint256 amount;
            uint256 startTIme;
            uint256 endTime;
            uint256 priceToken;
        }
        
        // struct InvestorInfo {
        //     uint256 ICO_NUM;
        //     address owner;
        //     uint256 tokens;
        //     uint256 tokensValue;
        // }
        mapping(uint256 => InfoToken) public icoInfo;
        // mapping(address => mapping(uint256 => InvestorInfo)) public invInfo;
        // mapping(address=>InvestorInfo) public invInfo;
        uint256 counter;
        uint256 public transferAmount;

        function createIco(
            ERC20 _token,
            uint256 _amount,
            uint256 _startTIme,
            uint256 _endTime,
            uint256 _priceToken //100000000000000000
        ) public returns(uint256) {
            counter++;
            // require(_startTIme > 0, "startTime is can't be zero");
            // require(_endTime > _startTIme, "Endtime can't before Starttime");
            icoInfo[counter] = InfoToken(
                _token,
                msg.sender,
                _amount,
                _startTIme,
                _endTime,
                _priceToken
            );

            _token.transferFrom(msg.sender,address(this),_amount);
            // Erc token add.trafFrom(msg.sender,smart contract,amount
            return counter;
        }

        function ChangeStart_time(uint IcoNUm, uint _start) public{
            InfoToken[IcoNUm]=InfoToken(_start);
        }

        function Invest(uint256 numICO, uint256 _amount) public payable {
            // require(icoInfo[numICO].owner != address(0), "No Ico Found");
            // require(block.timestamp >= icoInfo[numICO].startTIme,"Ico not started");
            // require(block.timestamp <= icoInfo[numICO].endTime, "Ico was Ended");
            // require(icoInfo[numICO].amount > 0,"All tokens sold");
            // require(_amount <= icoInfo[numICO].amount, "Tokens Not available");

            // msg.value * 10000000
            transferAmount = icoInfo[numICO].priceToken *  _amount / 10**18 ;
            require(msg.value >= transferAmount ,"You have to Pay token Price");
            payable(icoInfo[numICO].owner).transfer(transferAmount);
            icoInfo[numICO].amount-=_amount;
            icoInfo[numICO].token.transfer(msg.sender,_amount);
        
            

            // invInfo[msg.sender][numICO] = InvestorInfo(
            //     numICO,
            //     msg.sender,
            //     _amount,
            //     transferAmount
            // );
        }

        // function Withdraw(uint256 numICO) public {
        //     // Ico creator Withdraw Or Investor Withdraw after EndTime ?
        // }
    }
    // uncheked
    // investor multiple icoNUm
    // iv 1=700 buy i=2 b=700 if 700 is not aval then give them remaining
