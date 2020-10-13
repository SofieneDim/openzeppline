pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;

contract Authentication {
    struct account {
        uint256 id;
        address owner;
        string date;
        string userName;
        string email;
        string phoneNumber;
        string responsableName;
        string logoLink;
        string country;
        string phAddress;
        bool labo;
    }

    struct status {
        bool pending;
        bool approved;
        bool blocked;
    }

    mapping(uint256 => status) public statuses;
    mapping(address => account) public accounts;
    mapping(address => bool) public adminAccounts;

    // State variables
    uint256 accountsCounter;
    uint256 signupRequestCounter;

    function initContract() public {
        adminAccounts[msg.sender] = true;
    }

    function signup(
        address _address,
        string memory userName,
        string memory email,
        string memory phoneNumber,
        string memory phAddress,
        string memory requestDate,
        string memory responsableName,
        string memory country,
        string memory logoLink,
        bool isLabo
    ) public {
        accountsCounter++;
        accounts[_address] = account(
            accountsCounter,
            _address,
            requestDate,
            userName,
            email,
            phoneNumber,
            responsableName,
            logoLink,
            country,
            phAddress,
            isLabo
        );
        statuses[accountsCounter] = status(true, false, false);
    }

    function approveRequest(uint256 id, string memory _date) public {
        require(adminAccounts[msg.sender], "You are not admin");

        status memory accountStatus = statuses[id];
        statuses[id] = status(false, true, false);
    }
}
