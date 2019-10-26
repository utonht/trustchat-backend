pragma solidity >=0.4.23 <0.6.0;

contract Messenger {
    event Message(uint _chatId, uint _msgId, address _from, string _message);
    event JoinChat(uint _chatId, address _member);
    event Invitation(uint _chatId, address _member);
    
    struct ChatInfo {
        bytes[] publicKeys;
        address[] users;
    }
    
    mapping(uint => ChatInfo) chats;
    uint public chatCounter;

    function send(uint chatId, uint msgId, string memory message) public {
        emit Message(chatId, msgId, msg.sender, message);
    }

    function openChat(bytes publicKey, address[] initialMemmbers) public {
        joinChat(chatCounter, publicKey);
        for (uint i = 0; i < initialMemmbers.length; i++) {
            emit Invitation(chatCounter, initialMemmbers[i]);
        }
        chatCounter += 1;
    }
    
    function joinChat(uint chatId, bytes publicKey) public {
        chats[chatCounter].users.push(msg.sender);
        chats[chatCounter].publicKeys.push(publicKey);
        emit JoinChat(chatId, msg.sender);
    }
}
