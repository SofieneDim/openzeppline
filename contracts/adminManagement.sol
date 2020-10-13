pragma experimental ABIEncoderV2;
pragma solidity >0.4.99 <0.6.0;

contract AdminManagement {
    struct adminAccount {
        uint256 id;
        uint256 machinesId;
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

    mapping(uint256 => machine) public machines;
    mapping(uint256 => humanResource) public humansResources;
}
