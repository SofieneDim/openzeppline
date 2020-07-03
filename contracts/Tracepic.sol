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

    mapping(string => analyse) public publicAnalysisByRef;
    mapping(uint256 => analyse) public publicAnalysisById;
    mapping(address => analyse[]) public publicAnalysisBuyer;
    mapping(address => uint256[]) private publicAnalysesPoster;

    mapping(uint256 => privateAnalyse) public privateAnalysis;
    mapping(address => uint256[]) private privateAnalysesPoster;
    mapping(address => privateAnalyse[]) public privateAnalysisBuyer;
    mapping(address => privateAnalyse[]) private privateAnalysesOwner;

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

            privateAnalysesPoster[msg.sender].push(privateAnalysesCounter);

            privateAnalysis[privateAnalysesCounter] = (
                privateAnalyse(
                    privateAnalysesCounter,
                    msg.sender,
                    address(0),
                    _analyseReference,
                    _date,
                    _value,
                    _description,
                    _price,
                    _owner
                )
            );

            privateAnalysesOwner[_owner].push(
                privateAnalyse(
                    privateAnalysesCounter,
                    msg.sender,
                    address(0),
                    _analyseReference,
                    _date,
                    _value,
                    _description,
                    _price,
                    _owner
                )
            );
        } else {
            publicAnalyseCounter++;
            publicAnalysesPoster[msg.sender].push(publicAnalyseCounter);
            publicAnalysisById[publicAnalyseCounter] = analyse(
                publicAnalyseCounter,
                msg.sender,
                address(0),
                _analyseReference,
                _date,
                _value,
                _description,
                _price
            );
            publicAnalysisByRef[_analyseReference] = analyse(
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
        analyse storage analyseToBuy = publicAnalysisById[_id];
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
        publicAnalysisById[_id].buyer = msg.sender;

        publicAnalysisBuyer[msg.sender].push(analyseToBuy);
        // the buyer can buy the analyse
        analyseToBuy.seller.transfer(msg.value);
    }

    // buy a private analyse
    function buyPrivateAnalyse(uint256 analyseId) public payable {
        // we retrieve the analyse
        privateAnalyse memory analyseToBuy = privateAnalysis[analyseId];
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

        require(analyseToBuy.owner == msg.sender, "You are not owner");

        // keep buyer's information
        analyseToBuy.buyer = msg.sender;
        privateAnalysis[analyseId].buyer = msg.sender;

        for (uint256 i = 0; i < privateAnalysesOwner[msg.sender].length; i++) {
            if (privateAnalysesOwner[msg.sender][i].id == analyseId) {
                privateAnalysesOwner[msg.sender][i].buyer = msg.sender;
            }
        }

        privateAnalysis[analyseId].buyer = msg.sender;
        privateAnalysisBuyer[msg.sender].push(analyseToBuy);
        // the buyer can buy the analyse
        analyseToBuy.seller.transfer(msg.value);
    }

    // fetch and returns all analyse IDs available for sale
    function getAnalysesForSale(uint256 lot)
        public
        view
        returns (analyse[] memory)
    {
        // we check whether there is at least one analyse
        if (publicAnalyseCounter == 0) {
            return new analyse[](0);
        }
        // prepare output arrays
        analyse[] memory analysis = new analyse[](10);
        uint256 numberOfAnalysesForSale = 0;
        uint256 fromm = publicAnalyseCounter - (lot * 10) + 10;
        uint256 to = 0;
        if (fromm >= 9) {
            to = fromm - 9;
        } else {
            to = 1;
        }
        for (uint256 i = fromm; i >= to; i--) {
            analysis[numberOfAnalysesForSale] = publicAnalysisById[i];
            numberOfAnalysesForSale++;
        }
        return analysis;
    }

    function getSelfPostedPublicAnalysisIds()
        public
        view
        returns (uint256[] memory)
    {
        return publicAnalysesPoster[msg.sender];
    }

    function getSelfPostedPrivateAnalysisIds()
        public
        view
        returns (uint256[] memory)
    {
        return privateAnalysesPoster[msg.sender];
    }

    function getSelfPostedPrivateAnalyse(uint256 analyseId)
        public
        view
        returns (privateAnalyse memory)
    {
        privateAnalyse memory _analyse = privateAnalysis[analyseId];
        require(
            _analyse.seller == msg.sender,
            "This is a private analyse, and you are not the owner"
        );
        return _analyse;
    }

    function getSelfPostedPrivateAnalyseByAddress(address owner)
        public
        view
        returns (privateAnalyse[] memory)
    {
        privateAnalyse[] memory analysis = privateAnalysesOwner[owner];
        privateAnalyse[] memory postedAnalysis = new privateAnalyse[](
            analysis.length
        );
        uint256 counter = 0;
        for (uint256 i = 0; i < analysis.length; i++) {
            if (analysis[i].seller == msg.sender) {
                postedAnalysis[counter] = analysis[i];
                counter++;
            }
        }
        privateAnalyse[] memory finalAnalysis = new privateAnalyse[](counter);
        for (uint256 i = 0; i < counter; i++) {
            finalAnalysis[i] = postedAnalysis[i];
        }
        return finalAnalysis;
    }

    function getSelfBoughtAnalysis()
        public
        view
        returns (analyse[] memory publicA, privateAnalyse[] memory privateA)
    {
        return (
            publicAnalysisBuyer[msg.sender],
            privateAnalysisBuyer[msg.sender]
        );
    }

    function getAnalyseByReference(string memory _reference)
        public
        view
        returns (analyse memory)
    {
        return publicAnalysisByRef[_reference];
    }

    function getPrivateAnalyse() public view returns (privateAnalyse[] memory) {
        privateAnalyse[] memory _analyse = privateAnalysesOwner[msg.sender];
        return _analyse;
    }

    function getPrivateAnalysisIds() public view returns (uint256 counter) {
        return privateAnalysesCounter;
    }
}
