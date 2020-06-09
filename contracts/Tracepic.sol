pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;


contract Tracepic {
    struct analyse {
        uint256 id;
        address payable seller;
        address buyer;
        string analyseReference;
        string date;
        string value;
        string description;
        uint256 price;
    }

    struct privateAnalyse {
        uint256 id;
        address payable seller;
        address buyer;
        string analyseReference;
        string date;
        string value;
        string description;
        uint256 price;
        address owner;
    }

    mapping(uint256 => analyse) public publicAnalysis;
    mapping(address => privateAnalyse) private privateAnalyses;
    mapping(address => uint256[]) private publicAnalysesOwners;
    mapping(address => uint256[]) private privateAnalysesOwners;

    // State variables
    uint256 publicAnalyseCounter;
    uint256 privateAnalysesCounter;

    // sell an analyse
    function postAnalyse(
        string memory _analyseReference,
        string memory _value,
        string memory _date,
        string memory _description,
        uint256 _price,
        address _owner
    ) public {
        if (_owner != address(0)) {
            privateAnalysesCounter++;
            privateAnalysesOwners[msg.sender].push(privateAnalysesCounter);
            privateAnalyses[_owner] = privateAnalyse(
                privateAnalysesCounter,
                msg.sender,
                address(0),
                _analyseReference,
                _date,
                _value,
                _description,
                _price,
                _owner
            );
        } else {
            publicAnalyseCounter++;
            publicAnalysesOwners[msg.sender].push(publicAnalyseCounter);
            publicAnalysis[publicAnalyseCounter] = analyse(
                publicAnalyseCounter,
                msg.sender,
                address(0),
                _analyseReference,
                _date,
                _value,
                _description,
                _price
            );
        }
    }

    // buy an analyse
    function buyAnalyse(uint256 _id) public payable {
        // we check whether there is at least one analyse
        require(
            publicAnalyseCounter > 0,
            "There should be at least one analyse"
        );

        // we check whether the analyse exists
        require(
            _id > 0 && _id <= publicAnalyseCounter,
            "analyse with this id does not exist"
        );

        // we retrieve the analyse
        analyse storage analyseToBuy = publicAnalysis[_id];

        // we check whether the analyse has not already been sold
        require(analyseToBuy.buyer == address(0), "analyse was already sold");

        // we don't allow the seller to buy his/her own analyse
        require(
            analyseToBuy.seller != msg.sender,
            "Seller cannot buy his own analyse"
        );

        // we check whether the value sent corresponds to the analyse price
        require(
            analyseToBuy.price == msg.value,
            "Value provided does not match price of analyse"
        );

        // keep buyer's information
        analyseToBuy.buyer = msg.sender;

        // the buyer can buy the analyse
        analyseToBuy.seller.transfer(msg.value);
    }

    // buy a private analyse
    function buyPrivateAnalyse() public payable {
        // we retrieve the analyse
        privateAnalyse memory analyseToBuy = privateAnalyses[msg.sender];

        // we check whether the analyse exists
        require(analyseToBuy.seller != address(0), "Analyze not found!");

        // we check whether the analyse has not already been sold
        require(analyseToBuy.buyer == address(0), "analyse was already sold");

        // we don't allow the seller to buy his/her own analyse
        require(
            analyseToBuy.seller != msg.sender,
            "Seller cannot buy his own analyse"
        );

        // we check whether the value sent corresponds to the analyse price
        require(
            analyseToBuy.price == msg.value,
            "Value provided does not match price of analyse"
        );

        // keep buyer's information
        analyseToBuy.buyer = msg.sender;
        privateAnalyses[msg.sender].buyer = msg.sender;

        // the buyer can buy the analyse
        analyseToBuy.seller.transfer(msg.value);
    }

    // fetch the number of analyses in the contract
    function getNumberOfAnalyses() public view returns (uint256) {
        return publicAnalyseCounter;
    }

    function getAllAnalyses() public view returns (uint256[] memory) {
        // we check whether there is at least one analyse
        if (publicAnalyseCounter == 0) {
            return new uint256[](0);
        }
        // prepare output arrays
        uint256[] memory analyseIds = new uint256[](publicAnalyseCounter);
        uint256 numberOfAnalyses = 0;
        // iterate over analyses
        for (uint256 i = 1; i <= publicAnalyseCounter; i++) {
            analyseIds[numberOfAnalyses] = publicAnalysis[i].id;
            numberOfAnalyses++;
        }
        return analyseIds;
    }

    // fetch and returns all analyse IDs available for sale
    function getAnalysesForSale() public view returns (uint256[] memory) {
        // we check whether there is at least one analyse
        if (publicAnalyseCounter == 0) {
            return new uint256[](0);
        }
        // prepare output arrays
        uint256[] memory analyseIds = new uint256[](publicAnalyseCounter);
        uint256 numberOfAnalysesForSale = 0;
        // iterate over analyses
        for (uint256 i = 1; i <= publicAnalyseCounter; i++) {
            // keep only the ID for the analyse not already sold
            if (publicAnalysis[i].buyer == address(0)) {
                analyseIds[numberOfAnalysesForSale] = publicAnalysis[i].id;
                numberOfAnalysesForSale++;
            }
        }
        // copy the analyseIds array into the smaller forSale array
        uint256[] memory forSale = new uint256[](numberOfAnalysesForSale);
        for (uint256 j = 0; j < numberOfAnalysesForSale; j++) {
            forSale[j] = analyseIds[j];
        }
        return forSale;
    }

    function getSelfPublicAnalyses() public view returns (uint256[] memory) {
        return publicAnalysesOwners[msg.sender];
    }

    function getSelfPrivateAnalyses() public view returns (uint256[] memory) {
        return privateAnalysesOwners[msg.sender];
    }

    function getAnalyseByReference(string memory _reference)
        public
        view
        returns (uint256 id)
    {
        for (uint256 i = 1; i <= publicAnalyseCounter; i++) {
            if (
                keccak256(
                    abi.encodePacked(publicAnalysis[i].analyseReference)
                ) == keccak256(abi.encodePacked(_reference))
            ) {
                return publicAnalysis[i].id;
            }
        }
    }

    function getPrivateAnalyse(address _address)
        public
        view
        returns (privateAnalyse memory _privateAnalyse)
    {
        privateAnalyse memory _analyse = privateAnalyses[_address];
        //  bool condition = msg.sender == _analyse.owner || msg.sender == _analyse.seller;
        //   require(condition, 'You cannot access this analyse');
        return _analyse;
    }
}
