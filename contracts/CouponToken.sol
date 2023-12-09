// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title CouponToken
 * @dev Extension of ERC1155 that introduces an expiration mechanism for ERC1155 tokens.
 */
contract CouponToken is Initializable, ERC1155Upgradeable, OwnableUpgradeable {
    string public name;
    string public symbol;
    string private _contractURI;

    // Expiration time for each token (tokenId => expirationTime)s
    mapping(uint256 => uint256) private _expirationTimes;

    // Unique coupon code for each token (tokenId => uniqueCode)
    mapping(uint256 => uint256) private _uniqueCodes;

    // Mapping to store metadata URIs for each token ID
    mapping(uint256 => string) private _tokenMetadata;

    function initialize(
        string memory _name,
        string memory _symbol
    ) public initializer {
        name = _name;
        symbol = _symbol;
        __ERC1155_init("");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /**
     * @dev Mint, a new token with a specific expiration time
     * @param account, The address to receive the minted tokens.
     * @param tokenId, The ID of the token being minted.
     * @param amount, The amount of tokens to mint.
     * @param expirationTime, The expiration timestamp for the token.
     * @param uniqueCode, The unique code for the token.
     */
    function mint(
        address account,
        uint256 tokenId,
        uint256 amount,
        uint256 expirationTime,
        uint256 uniqueCode,
        string memory metadataURI
    ) external onlyOwner {
        require(
            expirationTime == 0 || expirationTime > block.timestamp,
            "Invalid Expiration time"
        );

        require(
            uniqueCode != 0, "Invalid coupon code"
        );
        _mint(account, tokenId, amount, "");
        _expirationTimes[tokenId] = expirationTime;
        _uniqueCodes[tokenId] = uniqueCode;
        _tokenMetadata[tokenId] = metadataURI; // Set metadata URI for the token
    }

    // Override the base URI to return the correct metadata URI for each token
    function uri(uint256 tokenId) public view override returns (string memory) {
        return _tokenMetadata[tokenId];
    }

    /**
     * @dev Update the expiration time for a specific token.
     * @param tokenId The ID of the token for which to update the expiration time.
     * @param newExpirationTime The new expiration time to be set for the token.
     * Requirements:
     * - Only the owner of the contract can call this function.
     */
    function updateExpirationTime(
        uint256 tokenId,
        uint256 newExpirationTime
    ) external onlyOwner {
        _expirationTimes[tokenId] = newExpirationTime;
    }

    /**
     * @dev Mint, multiple tokens with specific expiration times.
     * @param account, The address to receive the minted tokens.
     * @param tokenIds, An array of token IDs being minted.
     * @param amounts, An array of amounts of tokens to mint for each token ID.
     * @param expirationTimes, An array of expiration timestamps for each token ID.
     */
    function mintBatch(
        address account,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        uint256[] memory expirationTimes,
        uint256[] memory uniqueCodes
    ) external onlyOwner {
        require(account != address(0), "mint to the zero address");
        require(
            tokenIds.length == amounts.length,
            "ids and amounts length mismatch"
        );
        for (uint256 i; i < tokenIds.length; i++) {
            uint256 expirationTime = expirationTimes[i];
            require(
                expirationTime == 0 || expirationTime > block.timestamp,
                "Invalid Expiration time"
            );
            _expirationTimes[tokenIds[i]] = expirationTime;
        }

        for (uint256 i; i < tokenIds.length; i++) {
            uint256 uniqueCode = uniqueCodes[i];
            require(
            uniqueCode == 0,
            "Invalid coupon code"
        );
            _uniqueCodes[tokenIds[i]] = uniqueCode;
        }
        _mintBatch(account, tokenIds, amounts, "");
    }

    /**
     * @dev Override the transfer function to check if the token is still valid (not expired).
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param tokenId The ID of the token being transferred.
     * @param amount The amount of tokens being transferred.
     * @param data Additional data with no specified format.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(_isTokenValid(tokenId), "Token has expired");
        super.safeTransferFrom(from, to, tokenId, amount, data);
    }

    /**
     * @dev Override the batch transfer function to check if each token is still valid (not expired).
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param tokenIds An array of token IDs being transferred.
     * @param amounts An array of amounts of tokens being transferred.
     * @param data Additional data with no specified format.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(
                _isTokenValid(tokenIds[i]),
                "One or more tokens have expired"
            );
        }
        super.safeBatchTransferFrom(from, to, tokenIds, amounts, data);
    }

    /**
     * @dev Allows a user to return expirable tokens to the admin.
     *
     * This function is used to transfer expirable tokens from a user's address to the admin's address.
     * It checks whether the specified token has expired, and if not, the transfer is rejected.
     *
     * @param from The address of the user who wishes to return tokens.
     * @param to The address of the admin who will receive the returned tokens.
     * @param tokenId The unique identifier of the expirable token.
     * @param amount The amount of tokens to be returned.
     *
     * Requirements:
     * - The specified token (tokenId) must be expired for the transfer to proceed.
     * - The 'to' address must match the admin's address to ensure tokens are returned to the admin only.
     *
     * Emits a {Transfer} event indicating the token transfer.
     */
    function returnExpirableTokensToAdmin(
        address from,
        address to,
        uint256 tokenId,
        uint256 amount
    ) public {
        require(!_isTokenValid(tokenId), "Token not expired");
        require(to == owner(), "you can only send to Admin");
        super.safeTransferFrom(from, to, tokenId, amount, "0x00");
    }

    /**
     * @dev Burn function for a single token and give reward to the user who burns an expired token.
     * @param account The address of the token owner.
     * @param id The ID of the token to burn.
     * @param value The amount of tokens to burn.
     */
    function burn(address account, uint256 id, uint256 value) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "caller is not token owner or approved"
        );
        _burn(account, id, value);
    }

    /**
     * @dev Burn function for multiple tokens and give reward to the user for burning expired tokens.
     * @param account The address of the token owner.
     * @param ids An array of token IDs to burn.
     * @param values An array of amounts of tokens to burn.
     */
    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) public virtual {
        require(
            ids.length == values.length,
            "Ids and Values length mismatched"
        );
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "caller is not token owner or approved"
        );
        _burnBatch(account, ids, values);
    }

    /**
     * @dev Sets the contract URI.
     * @param contracturi The new contract URI to be set.
     * Requirements:
     * - Only the owner of the contract can call this function.
     */
    function setContractURI(string memory contracturi) external onlyOwner {
        _contractURI = contracturi;
    }

    /**
     * @dev Retrieves the contract URI.
     * @return The current contract URI.
     */
    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    function isTokenValid(uint256 tokenId) external view returns (bool) {
        return _isTokenValid(tokenId);
    }

    /**
     * @dev Get the expiration time of a token.
     * @param tokenId The ID of the token to query.
     * @return The expiration timestamp of the token.
     */
    function getExpirationTime(
        uint256 tokenId
    ) external view returns (uint256) {
        return _expirationTimes[tokenId];
    }

    /**
     * @dev Internal function to check if a token is still valid (not expired).
     * @param tokenId The ID of the token to check.
     * @return A boolean indicating whether the token is valid or not.
     */
    function _isTokenValid(uint256 tokenId) internal view returns (bool) {
        return (_expirationTimes[tokenId] == 0 ||
            block.timestamp < _expirationTimes[tokenId]);
    }

    // Receiver function for handling single transfer accepting ERC1155 token in `this` contract
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    // Receiver function for handling multiple transfer accepting ERC1155 token in `this` contract
    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}
