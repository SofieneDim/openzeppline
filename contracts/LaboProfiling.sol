pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;

contract LaboProfiling {
    struct laboProfile {
        uint256 id;
        uint256[] machinesIds;
        string gestionType;
    }

    struct machine {
        string serialNumber;
        string brand;
    }

    struct humanResource {
        string fullName;
        string role;
        string email;
    }

    uint256 machinesCounter;
    uint256 humanResourceCounter;

    mapping(uint256 => machine) private machines;
    mapping(uint256 => laboProfile) private labosProfiles;
    mapping(uint256 => humanResource) private humansResources;

    function addMachine(
        uint256 laboId,
        string memory serialNumber,
        string memory brand
    ) public {
        machinesCounter++;
        machines[machinesCounter] = machine(serialNumber, brand);
        labosProfiles[laboId].machinesIds.push(machinesCounter);
    }

    function getProfile(uint256 laboId)
        public
        view
        returns (laboProfile memory)
    {
        return labosProfiles[laboId];
    }
}
