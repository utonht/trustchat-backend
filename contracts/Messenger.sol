pragma solidity >=0.4.23 <0.6.0;

contract Messenger {
    event Message(uint _chatId, uint _msgId, address _from, bytes _message);
    event JoinChat(uint _chatId, address _member);
    event Invitation(uint _chatId, address _member);

    struct ChatInfo {
        bytes32[] publicKeys;
        address[] users;
        mapping (address => bool) invitations;
    }

    mapping (uint => ChatInfo) chats;
    uint public chatCounter;

    function send(uint chatId, uint msgId, bytes memory message) public {
        emit Message(chatId, msgId, msg.sender, message);
    }

    function getChat(uint chatId) public view returns(bytes32[] memory, address[] memory) {
        ChatInfo memory chatInfo = chats[chatId];
        return (chatInfo.publicKeys, chatInfo.users);
    }

    function openChat(bytes32 publicKey, address[] memory initialMemmbers) public returns (uint) {
        for (uint i = 0; i < initialMemmbers.length; i++) {
            chats[chatCounter].invitations[initialMemmbers[i]] = true;
            emit Invitation(chatCounter, initialMemmbers[i]);
        }
        chats[chatCounter].invitations[msg.sender] = true;
        joinChat(chatCounter, publicKey);
        chatCounter += 1;
        return chatCounter;
    }

    function joinChat(uint chatId, bytes32 publicKey) public {
        require(chats[chatId].invitations[msg.sender]);
        chats[chatId].users.push(msg.sender);
        chats[chatId].publicKeys.push(publicKey);
        emit JoinChat(chatId, msg.sender);
    }
}
