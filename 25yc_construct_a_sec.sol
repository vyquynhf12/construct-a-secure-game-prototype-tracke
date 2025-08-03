pragma solidity ^0.8.0;

contract SecureGamePrototypeTracker {
    address private owner;
    mapping (address => bool) private authorizedUsers;
    mapping (string => Prototype) private prototypes;

    struct Prototype {
        string name;
        string description;
        uint creationTime;
        address creator;
        uint version;
    }

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender], "Only authorized users can call this function");
        _;
    }

    function authorizeUser(address user) public onlyOwner {
        authorizedUsers[user] = true;
    }

    function createPrototype(string memory _name, string memory _description) public onlyAuthorized {
        prototypes[_name] = Prototype(_name, _description, block.timestamp, msg.sender, 1);
    }

    function updatePrototype(string memory _name, string memory _description) public onlyAuthorized {
        require(prototypes[_name].creator == msg.sender, "Only the creator can update the prototype");
        prototypes[_name].description = _description;
        prototypes[_name].version++;
    }

    function getPrototype(string memory _name) public view returns (Prototype memory) {
        return prototypes[_name];
    }

    function getPrototypes() public view returns (Prototype[] memory) {
        uint count = 0;
        for (string memory name in prototypes) {
            count++;
        }
        Prototype[] memory result = new Prototype[](count);
        uint i = 0;
        for (string memory name in prototypes) {
            result[i] = prototypes[name];
            i++;
        }
        return result;
    }
}