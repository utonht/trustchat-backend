pragma solidity >=0.4.23 <0.6.0;

contract Messenger {
    event Message(uint _chatId, uint _msgId, address _from, bytes _message);
    event JoinChat(uint _chatId, address _member);
    event Invitation(uint _chatId, address _member);

    struct ChatInfo {
        bytes32[] publicKeys;
        address[] users;
        address[] invitations;
        mapping (address => bool) invitationsMap;
    }

    mapping (uint => ChatInfo) chats;
    uint public chatCounter;

    function send(uint chatId, uint msgId, bytes memory message) public {
        emit Message(chatId, msgId, msg.sender, message);
    }

    function getChat(uint chatId) public view returns(bytes32[] memory, address[] memory, address[] memory) {
        ChatInfo memory chatInfo = chats[chatId];
        return (chatInfo.publicKeys, chatInfo.users, chatInfo.invitations);
    }

    function openChat(bytes32 publicKey, address[] memory initialMemmbers) public returns (uint) {
        uint chatId = chatCounter;
        for (uint i = 0; i < initialMemmbers.length; i++) {
            chats[chatId].invitationsMap[initialMemmbers[i]] = true;
            chats[chatId].invitations.push(initialMemmbers[i]);
            emit Invitation(chatId, initialMemmbers[i]);
        }
        chats[chatId].invitationsMap[msg.sender] = true;
        chats[chatId].invitations.push(msg.sender);
        emit Invitation(chatId, msg.sender);
        joinChat(chatId, publicKey);
        chatCounter += 1;
        return chatId;
    }

    function joinChat(uint chatId, bytes32 publicKey) public {
        require(chats[chatId].invitationsMap[msg.sender], "You are not a member");
        chats[chatId].users.push(msg.sender);
        chats[chatId].publicKeys.push(publicKey);
        emit JoinChat(chatId, msg.sender);
    }
}
