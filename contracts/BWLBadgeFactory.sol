// SPDX-License-Identifier: MIT
/*
 _______   __                      __              __       __
/       \ /  |                    /  |            /  |  _  /  |
$$$$$$$  |$$ |  ______    _______ $$ |   __       $$ | / \ $$ |  ______   __     __  ______
$$ |__$$ |$$ | /      \  /       |$$ |  /  |      $$ |/$  \$$ | /      \ /  \   /  |/      \
$$    $$< $$ |/$$$$$$  |/$$$$$$$/ $$ |_/$$/       $$ /$$$  $$ | $$$$$$  |$$  \ /$$//$$$$$$  |
$$$$$$$  |$$ |$$ |  $$ |$$ |      $$   $$<        $$ $$/$$ $$ | /    $$ | $$  /$$/ $$    $$ |
$$ |__$$ |$$ |$$ \__$$ |$$ \_____ $$$$$$  \       $$$$/  $$$$ |/$$$$$$$ |  $$ $$/  $$$$$$$$/
$$    $$/ $$ |$$    $$/ $$       |$$ | $$  |      $$$/    $$$ |$$    $$ |   $$$/   $$       |
$$$$$$$/  $$/  $$$$$$/   $$$$$$$/ $$/   $$/       $$/      $$/  $$$$$$$/     $/     $$$$$$$/

*/

pragma solidity >=0.7.0 <=0.9.0;
import "./ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BWLBadgeFactory is ERC1155, Ownable {
    uint256 public count;

    string public name;
    string public symbol;

    mapping(uint256 => string) public tokenURI;
    mapping(uint256 => uint256) public prices;

    constructor() ERC1155("") {
        count = 0;
        name = "BWLItems";
        symbol = "BWLI";
    }

    // Action
    // External
    function mintWithUri(
        address _to,
        uint256 _id,
        uint256 _amount,
        string memory _uri
    ) external {
        _mint(_to, _id, _amount, "");
        setURI(_id, _uri);
        count++;
    }

    function mintBatchWithUri(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        string[] memory _uris
    ) external {
        _mintBatch(_to, _ids, _amounts, "");
        for (uint256 i = 0; i < _ids.length; i++) {
            setURI(_ids[i], _uris[i]);
            count++;
        }
    }

    function burn(uint256 _id, uint256 _amount) external {
        _burn(msg.sender, _id, _amount);
    }

    function burnBatch(uint256[] memory _ids, uint256[] memory _amounts)
        external
    {
        _burnBatch(msg.sender, _ids, _amounts);
    }

    function burnForMint(
        address _from,
        uint256[] memory _burnIds,
        uint256[] memory _burnAmounts,
        uint256[] memory _mintIds,
        uint256[] memory _mintAmounts
    ) external onlyOwner {
        _burnBatch(_from, _burnIds, _burnAmounts);
        _mintBatch(_from, _mintIds, _mintAmounts, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public payable override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner nor approved"
        );
        if(isApprovedForAll(from, _msgSender())) {

        } else {
            
        }
    
        _safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public payable override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner nor approved"
        );
        for(uint256 i = 0; i < ids.length; i++) {}
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    // Utils
    function setURI(uint256 _id, string memory _uri) public {
        tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }

    // View
    function totalSupply() public view returns (uint256) {
        return count;
    }

    function uri(uint256 _id) public view override returns (string memory) {
        return tokenURI[_id];
    }
}
