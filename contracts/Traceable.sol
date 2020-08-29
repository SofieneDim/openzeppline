pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;

  contract drageableAnalysis {
      
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
        uint256 cycleTimes;
        uint256 analysisIdsCounter;
        uint256[] analysisIds;
    }
    
    mapping(address => cycle) cycles;
    mapping(uint256 => analyse) analysis;
    
    uint256 cyclesCounter;
    uint256 analysisCounter;
    
    function getCycle(address owner) public view returns (cycle memory result){
        return cycles[owner];
    }
  
    function addNewCycle(address client, uint256 cycleTimes, uint256 price, 
        uint256 firstAnalyseId, string memory _reference, string memory date, string memory value, string memory description
    ) public {
        cyclesCounter++;
        analysisCounter++;
        analyse memory firstAnalyse = analyse(
            firstAnalyseId, _reference, date, value, description
            );
        analysis[analysisCounter] = firstAnalyse;
        uint256[] memory _analysis = new uint256[](cycleTimes);
        _analysis[0] = firstAnalyseId;
        cycles[client] = cycle(
                cyclesCounter,
                msg.sender,
                client,
                price,
                cycleTimes,
                1,
                _analysis
            );
    }
  
    function addNewAnalyseToCycle(
    address client, uint256 analyseId, string memory _reference, 
    string memory date, string memory value, string memory description
    ) public {
        cycle memory _cycle = cycles[client];
        uint256[] memory _analysisIds = _cycle.analysisIds;
        analysisCounter++;
        
        
        analysis[analysisCounter] = analyse(analyseId, _reference, date, value, description );
        
        
        _analysisIds[_cycle.analysisIdsCounter] = analysisCounter;
        _cycle.analysisIdsCounter++;
        cycles[client] = _cycle;
    }
    
    
    /*  "0x0A03a6e8Ccb2562aeEF3CE7F63f22f444E116850", 3, 12, 1, "ref", "date", "val", "desc"  */
     /* "0x0A03a6e8Ccb2562aeEF3CE7F63f22f444E116850", 2, "ref", "date", "val", "desc"  */
  
}
