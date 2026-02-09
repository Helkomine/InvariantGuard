// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;
import "https://github.com/Helkomine/invariant-guard/blob/main/invariant-guard/InvariantGuardInternal.sol";
import "@openzeppelin/contracts/utils/Address.sol";

// This is a simple proxy contract that uses InvariantGuard to protect the proxy slot when making a delegate call to any address.
contract InvariantProxySimple is InvariantGuardInternal {
    // this slot is equivalent to bytes32(uint256(keccak256("InvariantProxySimple")) - 1).
    bytes32 private constant PROXY_SLOT = 0xf1eebf8b6776af738f9499a7db6badff639300d5eb7a311caa6348385f3f764a;

    // this is a function that performs an arbitrary delegatecall optimistically.
    function safeDelegateCall(address target, bytes calldata data) external payable invariantStorage(_getSlot()) {
        Address.functionDelegateCall(target, data);
    }
    
    // this is the function to update the new proxy address.
    // for simplicity, the owner's address is hardcoded.
    function upgradeProxy(address newProxy) public payable {
        require(msg.sender == 0xD8f0aC963E2C667Fc1308601513c7229dfAe3865);
        assembly {
            sstore(PROXY_SLOT, newProxy)
        }
    }

    // this function retrieves the exact slot to be protected, in this case, PROXY_SLOT.
    function _getSlot() private pure returns (bytes32[] memory) {
        bytes32[] memory slots = new bytes32[](1);
        slots[0] = PROXY_SLOT;
        return slots;
    }
}
