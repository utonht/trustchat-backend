pragma solidity >=0.4.23 <0.6.0;

contract Messenger {
    event Message(address _from, address _to, string _message);
    mapping (address => mapping(address => bytes[3])) public publicKeys;
    mapping (bytes32 => MessageTool) public chat;

    struct MessageTool {
        mapping(bytes32 => bytes) pablicKeys;
        bytes base;
        bytes modulo;
    }

    function send(address to, string memory message) public {
        emit Message(msg.sender, to, message);
    }

    function updateConnection(address mate, bytes memory base, bytes memory modulo, bytes memory publicKey) public {
        publicKeys[msg.sender][mate] = [base, modulo, publicKey];
    }

    function getConnection(address mate) public view returns(bytes memory, bytes memory, bytes memory) {
        return (publicKeys[mate][msg.sender][0], publicKeys[mate][msg.sender][1], publicKeys[mate][msg.sender][2]) ;
    }

    function openChat(address[] memory mates, bytes memory base, bytes memory modulo) public returns (bytes32) {
        bytes32 hash = calculateIdentifier(abi.encodePacked(msg.sender), mates);
        chat[hash] = MessageTool(base, modulo);
        return hash;
    }

    function getChatPubkey(bytes32 chatHash, address[] memory mates) public view returns (bytes memory) {
        bytes32 hash = calculateIdentifier(new bytes(0), mates);
        return chat[chatHash].pablicKeys[hash];
    }

    function setChatPubkey(bytes32 chatHash, address[] memory mates, bytes memory publicKey) public returns (bytes32 hash) {
        hash = calculateIdentifier(abi.encodePacked(msg.sender), mates);
        chat[chatHash].pablicKeys[hash] = publicKey;
    }

    function calculateIdentifier(bytes memory initialIdentifier, address[] memory mates) public pure returns (bytes32 hash) {
        for (uint i = 0; i < mates.length; i++) {
            initialIdentifier = abi.encodePacked(initialIdentifier, mates[i]);
        }
        hash = keccak256(initialIdentifier);
    }
}
