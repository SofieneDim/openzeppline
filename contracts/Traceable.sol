pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;

contract TraceableAnalysis {
    struct analyse {
        uint256 id;
        string analyseReference;
        string date;
        string value;
        string description;
    }

    struct cycle {
        uint256 id;
        address payable seller;
        address buyer;
        uint256 price;
        bool paid;
        uint256 cycleTimes;
        uint256 analysisIdsCounter;
        uint256[] analysisIds;
    }

    mapping(address => cycle) cycles;
    mapping(uint256 => analyse) analysis;

    uint256 cyclesCounter;
    uint256 analysisCounter;

    function getCycle(address owner) public view returns (cycle memory result) {
        return cycles[owner];
    }

    function addNewCycle(
        address client,
        uint256 cycleTimes,
        uint256 price,
        string memory _reference,
        string memory date,
        string memory value,
        string memory description
    ) public {
        cyclesCounter++;
        analysisCounter++;
        analyse memory firstAnalyse = analyse(
            analysisCounter,
            _reference,
            date,
            value,
            description
        );
        analysis[analysisCounter] = firstAnalyse;
        uint256[] memory _analysis = new uint256[](cycleTimes);
        _analysis[0] = analysisCounter;
        cycles[client] = cycle(
            cyclesCounter,
            msg.sender,
            client,
            price,
            false,
            cycleTimes,
            1,
            _analysis
        );
    }

    function addNewAnalyseToCycle(
        address client,
        string memory _reference,
        string memory date,
        string memory value,
        string memory description
    ) public returns (bool isComplete) {
        cycle memory _cycle = cycles[client];
        uint256[] memory _analysisIds = _cycle.analysisIds;
        analysisCounter++;
        analysis[analysisCounter] = analyse(
            analysisCounter,
            _reference,
            date,
            value,
            description
        );
        _analysisIds[_cycle.analysisIdsCounter] = analysisCounter;
        _cycle.analysisIdsCounter++;
        cycles[client] = _cycle;
        return (_cycle.analysisIdsCounter == _cycle.cycleTimes);
    }

    function buyCycle() public payable {
        require(cyclesCounter > 0, "There should be at least one analyse");
        cycle storage cycleToBuy = cycles[msg.sender];
        require(cycleToBuy.paid == false, "analyse was already sold");
        require(
            cycleToBuy.price == msg.value,
            "Value provided does not match price of analyse"
        );
        cycleToBuy.paid = true;
        cycleToBuy.seller.transfer(msg.value);
    }

    function getAnalyse(uint256 analyseId)
        public
        view
        returns (analyse memory)
    {
        return analysis[analyseId];
    }
}
