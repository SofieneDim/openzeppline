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

    struct analyseType {
        string analyseName;
        uint256 times;
        uint256 analysisCounter;
        uint256[] analysisIds;
    }

    struct cycle {
        uint256 id;
        address payable seller;
        address owner;
        uint256 price;
        bool paid;
        uint256[] analysisTypesIds;
    }

    mapping(address => cycle) cycles;
    mapping(uint256 => analyse) analysis;

    mapping(uint256 => analyseType) analysisTypes;

    uint256 cyclesCounter;
    uint256 analysisCounter;
    uint256 analysisTypesCounter;

    function addNewCycle(
        address client,
        uint256 price,
        analyseType[] memory _analysisTypes
    ) public {
        cyclesCounter++;
        analysisTypesCounter++;
        uint256[] memory analysisTypesIds = new uint256[](
            _analysisTypes.length
        );
        for (uint256 i = 0; i < _analysisTypes.length; i++) {
            analysisTypes[analysisTypesCounter] = _analysisTypes[i];
            analysisTypesIds[i] = analysisTypesCounter;
        }
        cycles[client] = cycle(
            cyclesCounter,
            msg.sender,
            client,
            price,
            false,
            analysisTypesIds
        );
    } // [["name 1","3",1,[1,"2",3]]]

    function getCycle(address owner) public view returns (cycle memory result) {
        return cycles[owner];
    }
}
