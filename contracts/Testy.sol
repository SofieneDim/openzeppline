pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;


contract testy {
    function initContract() public {
        accounts[1] = account(
            1,
            0x1AB71030E9D220588c1FE5DCE9783886eEd7713C,
            "_userName",
            "_email",
            "phoneNumber",
            "_phAddress",
            "_password",
            "logoLink",
            true
        );
    }

    struct account {
        uint256 id;
        address owner;
        string userName;
        string email;
        string phoneNumber;
        string phAddress;
        string password;
        string logoLink;
        bool labo;
    }

    mapping(uint256 => account) public accounts;

    function editUserInfo(
        uint256 _id,
        string memory _userName,
        string memory _email,
        string memory phoneNumber,
        string memory _password,
        string memory _phAddress,
        string memory logoLink
    ) public {
        account memory userAccount = accounts[_id];
        //  require(userAccount.owner == msg.sender, "This is not your acccount");
        accounts[_id] = account(
            _id,
            userAccount.owner,
            _userName,
            _email,
            phoneNumber,
            _phAddress,
            _password,
            logoLink,
            userAccount.labo
        );
    }
}
