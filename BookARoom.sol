// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract BookARoom {  

  mapping (bytes32 => bool) private listRoom;

  //---events---
  event RoomAdded(
    address from,   
    string text,
    bytes32 hash,
    string time
  );
  
  event ReserveError(
    address from,
    string text,
    string reason
  );

  // store the proof for a room in the contract state
  function recordProof(bytes32 proof) private {
    listRoom[proof] = true;
  }
  
  // record a room name
  function reservation(string memory name, string memory time) public payable {
    
    //---check if string was previously reserved---
    if (listRoom[hashing(name)]) {
        //---fire the event---
      emit ReserveError(msg.sender, name, "This Room was previously reserved");
        //---refund back to the sender---
      payable(msg.sender).transfer(msg.value);
        //---exit the function---
        return;
    }

    //---check if msg.value != 0.001 ether---
    if (msg.value != 0.001 ether) {
        //---fire the event---
      emit ReserveError(msg.sender, name, "Incorrect amount of Ether. You should pay 0.001 ether");
        //---refund back to the sender---
      payable(msg.sender).transfer(msg.value);
        //---exit the function---
        return;
    }
 
    recordProof(hashing(name));
    
    //---fire the event---
    emit RoomAdded(msg.sender, name, 
        hashing(name), time);
    
  }
  
  // SHA256 for Integrity
  function hashing(string memory name) private 
  pure returns (bytes32) {
    return sha256(bytes(name));
  }
}