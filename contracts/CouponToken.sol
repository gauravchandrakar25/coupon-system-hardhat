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

    // Expiration time for each token (tokenId => expirationTime)
    mapping(uint256 => uint256) private _expirationTimes;

    // Mapping to store metadata URIs for each token ID
    mapping(uint256 => string) private _tokenMetadata;

    function initialize(
        string memory _name,
        string memory _symbol
    ) public initializer {
        name = _name;
        symbol = _symbol;
        __ERC1155_init("");
        __Ownable_init();
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
     */
    function mint(
        address account,
        uint256 tokenId,
        uint256 amount,
        uint256 expirationTime,
        string memory metadataURI
    ) external onlyOwner {
        require(
            expirationTime == 0 || expirationTime > block.timestamp,
            "Invalid Expiration time"
        );
        _mint(account, tokenId, amount, "");
        _expirationTimes[tokenId] = expirationTime;
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
        uint256[] memory expirationTimes
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


}
