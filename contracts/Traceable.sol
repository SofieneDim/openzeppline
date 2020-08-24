pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;

contract Authentication {
    struct analyse {
        uint256 id;
        string analyseReference;
        string date;
        string value;
        string description;
    }

    struct cycle {
        uint256 id;
        address owner;
        address payable seller;
        uint256 cycleTimes;
        uint256[] analysisIds;
        bool completed;
        uint256 price;
    }

    uint256 cyclesCounter;
    uint256 analysisCounter;

    mapping(address => cycle[]) private cycles;
    mapping(uint256 => analyse) private analysisById;

    function addCycle(
        uint256 cycleTimes,
        uint256 price,
        address owner,
        string memory value,
        string memory analyseReference,
        string memory date,
        string memory description
    ) public {
        cyclesCounter++;
        analysisCounter++;

        analysisById[analysisCounter] = analyse(
            analysisCounter,
            analyseReference,
            date,
            value,
            description
        );
        uint256[] memory _value = new uint256[](1);
        _value[0] = analysisCounter;

        cycles[owner].push(
            cycle(
                cyclesCounter,
                owner,
                msg.sender,
                cycleTimes,
                _value,
                false,
                price
            )
        );
    }

    function addAnalyse(
        string memory value,
        address owner,
        uint256 analyseId,
        string memory analyseReference,
        string memory date,
        string memory description
    ) public {
        analysisCounter++;
        analysisById[analysisCounter] = analyse(
            analyseId,
            analyseReference,
            date,
            value,
            description
        );
        for (uint256 i = 0; i <= cycles[owner].length; i++) {
            if (cycles[owner][i].id == analyseId) {
                cycles[owner][i].analysisIds.push(analyseId);
            }
        }
    }

    function getCycles() public view returns (cycle[] memory) {
        if (cycles[msg.sender].length > 0) {
            cycle[] memory _cycles = new cycle[](cycles[msg.sender].length);
            uint256 counter = 0;
            for (uint256 i = 0; i <= cycles[msg.sender].length; i++) {
                if (!cycles[msg.sender][i].completed) {
                    _cycles[counter] = (cycles[msg.sender][i]);
                }
            }
            return cycles[msg.sender];
        }
        return new cycle[](0);
    }
}
