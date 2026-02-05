// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;
import "./InvariantGuardHelper.sol";

// Hợp đồng này bảo vệ bất biến trên các token ERC721
// Áp dụng giả định tin tưởng do thực hiện truy vấn bên
// ngoài, vì vậy có thể phát sinh các tình huống không xác
// định nếu hợp đồng token bất thường (metamorphic logic)).
// Các hạng mục bảo vệ : 
// Số dư trên một hoặc nhiều token ERC721 được chỉ định
// Chủ sở hữu trên một hoặc nhiều token ERC721 được chỉ định
abstract contract InvariantGuardERC721 {
    using InvariantGuardHelper for *;

    modifier invariantERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processConstantERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray);
    }

    modifier assertERC721BalanceEquals(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory expectedArray) {
        _;
        uint256[] memory actualBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processConstantERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), expectedArray, actualBalanceArray);
    }

    modifier exactIncreaseERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory exactIncreaseArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processExactIncreaseERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray, exactIncreaseArray);
    }

    modifier maxIncreaseERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory maxIncreaseArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processMaxIncreaseERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray, maxIncreaseArray);
    }

    modifier minIncreaseERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory minIncreaseArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processMinIncreaseERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray, minIncreaseArray);
    }

    modifier exactDecreaseERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory exactDecreaseArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processExactDecreaseERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray, exactDecreaseArray);
    }

    modifier maxDecreaseERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory maxDecreaseArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processMaxDecreaseERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray, maxDecreaseArray);
    }

    modifier minDecreaseERC721Balance(IERC721[] memory tokenArray, address[] memory accountArray, uint256[] memory minDecreaseArray) {
        uint256[] memory beforeBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _;
        uint256[] memory afterBalanceArray = _getERC721BalanceArray(tokenArray, accountArray);
        _processMinDecreaseERC721Balance(ERC721ArrayInvariant(tokenArray), AccountArrayInvariant(accountArray), beforeBalanceArray, afterBalanceArray, minDecreaseArray);
    }

    // OWNER OF

    // bất biến chủ sở hữu trước và sau khi thực thi
    modifier invariantERC721Owner(IERC721[] memory tokenArray, uint256[] memory tokenIdArray) {
        address[] memory beforeOwnerArray = _getERC721OwnerArray(tokenArray, tokenIdArray);
        _;
        address[] memory afterOwnerArray = _getERC721OwnerArray(tokenArray, tokenIdArray);
        _processConstantERC721Owner(ERC721ArrayInvariant(tokenArray), ERC721TokenIdArray(tokenIdArray), beforeOwnerArray, afterOwnerArray);
    }

    // bất biến chủ sở hữu kì vọng và thực tế sau khi thực thi
    modifier assertERC721OwnerEquals(IERC721[] memory tokenArray, uint256[] memory tokenIdArray, address[] memory expectedArray) {
        _;
        address[] memory actualOwnerArray = _getERC721OwnerArray(tokenArray, tokenIdArray);
        _processConstantERC721Owner(ERC721ArrayInvariant(tokenArray), ERC721TokenIdArray(tokenIdArray), expectedArray, actualOwnerArray);
    }

    function _processConstantERC721Owner(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, ERC721TokenIdArray memory tokenIdERC721Array, address[] memory beforeOwnerArray, address[] memory afterOwnerArray) private pure {
        (uint256 violationCount, AddressInvariant[] memory violations) = beforeOwnerArray._validateAddressArray(afterOwnerArray);
        if (violationCount > 0) revert InvariantViolationERC721OwnerArray(tokenERC721ArrayInvariant, tokenIdERC721Array, violations); 
    }

    // BALANCE OF
    function _getERC721Balance(IERC721 token, address account) private view returns (uint256) {
        return token.balanceOf(account);
    }

    function _getERC721BalanceArray(IERC721[] memory tokenArray, address[] memory accountArray) private view returns (uint256[] memory) {
        uint256 length = accountArray._getAddressArrayLength();
        length._revertIfArrayTooLarge();
        uint256[] memory balanceArray = new uint256[](length);
        for (uint256 i = 0 ; i < length ; ) {
            balanceArray[i] = _getERC721Balance(tokenArray[i], accountArray[i]);
            unchecked { ++i; }
        }
        return balanceArray;
    }

    function _processConstantERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, beforeBalanceArray._getUint256ArrayLength()._emptyArray(), DeltaConstraint.NO_CHANGE);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _processExactIncreaseERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray, uint256[] memory exactIncreaseArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, exactIncreaseArray, DeltaConstraint.INCREASE_EXACT);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _processMaxIncreaseERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray, uint256[] memory maxIncreaseArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, maxIncreaseArray, DeltaConstraint.INCREASE_MAX);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _processMinIncreaseERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray, uint256[] memory minIncreaseArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, minIncreaseArray, DeltaConstraint.INCREASE_MIN);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _processExactDecreaseERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray, uint256[] memory exactDecreaseArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, exactDecreaseArray, DeltaConstraint.DECREASE_EXACT);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _processMaxDecreaseERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray, uint256[] memory maxDecreaseArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, maxDecreaseArray, DeltaConstraint.DECREASE_MAX);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _processMinDecreaseERC721Balance(ERC721ArrayInvariant memory tokenERC721ArrayInvariant, AccountArrayInvariant memory accountArrayInvariant, uint256[] memory beforeBalanceArray, uint256[] memory afterBalanceArray, uint256[] memory minDecreaseArray) private pure {
        (uint256 violationCount, ValuePerPosition[] memory violations) = beforeBalanceArray._validateDeltaArray(afterBalanceArray, minDecreaseArray, DeltaConstraint.DECREASE_MIN);
        if (violationCount > 0) revert InvariantViolationERC721BalanceArray(tokenERC721ArrayInvariant, accountArrayInvariant, violations); 
    }

    function _getERC721Owner(IERC721 token, uint256 tokenId) private view returns (address) {
        return token.ownerOf(tokenId);
    }

    function _getERC721OwnerArray(IERC721[] memory tokenArray, uint256[] memory tokenIdArray) private view returns (address[] memory) {
        uint256 length = tokenArray.length;
        length._revertIfArrayTooLarge();
        address[] memory ownerArray = new address[](length);
        for (uint256 i = 0 ; i < length ; ) {
            ownerArray[i] = _getERC721Owner(tokenArray[i], tokenIdArray[i]);
        }
        return ownerArray;
    }
}
