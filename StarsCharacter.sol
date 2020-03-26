pragma solidity >=0.5.1 <0.6.0;

contract Manager{

    address public superManager = 0x786b4a3c8E6042364619314CCd76b77cE65Af28F;
    address public manager;

    constructor() public{
        manager = msg.sender;
    }

    modifier onlyManager{
        require(msg.sender == manager || msg.sender == superManager, "Is not manager");
        _;
    }

    function changeManager(address _new_manager) public {
        require(msg.sender == superManager, "Is not superManager");
        manager = _new_manager;
    }

    function withdraw() external onlyManager{
        (msg.sender).transfer(address(this).balance);
    }
}

library Sort{
    function _ranking(uint[] memory data, bool B2S) public pure returns(uint[] memory){
        uint n = data.length;
        uint[] memory value = data;
        uint[] memory rank = new uint[](n);

        for(uint i = 0; i < n; i++) rank[i] = i;

        for(uint i = 1; i < value.length; i++) {
            uint j;
            uint key = value[i];
            uint index = rank[i];

            for(j = i; j > 0 && value[j-1] > key; j--){
                value[j] = value[j-1];
                rank[j] = rank[j-1];
            }

            value[j] = key;
            rank[j] = index;
        }

        
        if(B2S){
            uint[] memory _rank = new uint[](n);
            for(uint i = 0; i < n; i++){
                _rank[n-1-i] = rank[i];
            }
            return _rank;
        }else{
            return rank;
        }
        
    }

    function ranking(uint[] memory data) internal pure returns(uint[] memory){
        //傳入array, 回傳index對應值的排名(由大到小)
        return _ranking(data, true);
    }

    function ranking_(uint[] memory data) internal pure returns(uint[] memory){
        //傳入array, 回傳index對應值的排名(由小到大)
        return _ranking(data, false);
    }

}

library MathTool{
    using SafeMath for uint256;

    function percent(uint _number, uint _percent) internal pure returns(uint){
        return _number.mul(_percent).div(100);
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a, "add error");
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a, "sub error");
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b, "mul error");
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0, "div error");
        c = a / b;
    }
    function mod(uint a, uint b) internal pure returns (uint c) {
        require(b != 0, "mod error");
        c = a % b;
    }
}

library SafeMath8{
    function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
        c = a + b;
        require(c >= a, "add error");
    }
    function sub(uint8 a, uint8 b) internal pure returns (uint8 c) {
        require(b <= a, "sub error");
        c = a - b;
    }
    function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
        c = a * b;
        require(a == 0 || c / a == b, "mul error");
    }
    function div(uint8 a, uint8 b) internal pure returns (uint8 c) {
        require(b > 0, "div error");
        c = a / b;
    }
    function mod(uint8 a, uint8 b) internal pure returns (uint8 c) {
        require(b != 0, "mod error");
        c = a % b;
    }
}

library SafeMath16 {
    function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
        c = a + b;
        require(c >= a, "add error");
    }
    function sub(uint16 a, uint16 b) internal pure returns (uint16 c) {
        require(b <= a, "sub error");
        c = a - b;
    }
    function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
        c = a * b;
        require(a == 0 || c / a == b, "mul error");
    }
    function div(uint16 a, uint16 b) internal pure returns (uint16 c) {
        require(b > 0, "div error");
        c = a / b;
    }
    function mod(uint16 a, uint16 b) internal pure returns (uint16 c) {
        require(b != 0, "mod error");
        c = a % b;
    }
}

contract math {
    
    using MathTool for uint;
    using SafeMath for uint;
    using SafeMath16 for uint16;
    using SafeMath8 for uint8;

    function Random(uint lowerLimit, uint upperLimet) internal view returns(uint){
        return range(rand(), lowerLimit, upperLimet);
    }

    function range(uint seed, uint lowerLimit, uint upperLimet) internal pure returns(uint){
        require(upperLimet >= lowerLimit, "lowerLimit > upperLimet");
        if(upperLimet == lowerLimit){
            return upperLimet;
        }
        uint difference = upperLimet.sub(lowerLimit);
        return seed.mod(difference).add(lowerLimit).add(1);
    }

    function range8(uint8 seed, uint8 lowerLimit, uint8 upperLimet) internal pure returns(uint8){
        require(upperLimet >= lowerLimit, "lowerLimit > upperLimet");
        if(upperLimet == lowerLimit){
            return upperLimet;
        }
        uint8 difference = upperLimet.sub(lowerLimit);
        return seed.mod(difference).add(lowerLimit).add(1);
    }

    function range16(uint16 seed, uint16 lowerLimit, uint16 upperLimet) internal pure returns(uint16){
        require(upperLimet >= lowerLimit, "lowerLimit > upperLimet");
        if(upperLimet == lowerLimit){
            return upperLimet;
        }
        uint16 difference = upperLimet.sub(lowerLimit);
        return seed.mod(difference).add(lowerLimit).add(1);
    }

    function rand() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(now, gasleft())));
    }

    function linearTransfrom(uint oringinMax, uint nowMax, uint number) public pure returns(uint){
        return number.mul(nowMax).div(oringinMax);
    }

    bytes _seed;

    constructor() public{
        setSeed();
    }

    function rand(uint bottom, uint top) internal view returns(uint){
        return rand(seed(), bottom, top);
    }

    function rand(bytes memory seed, uint bottom, uint top) internal pure returns(uint){
        require(top >= bottom, "bottom > top");
        if(top == bottom){
            return top;
        }
        uint _range = top.sub(bottom);

        uint n = uint(keccak256(seed));
        return n.mod(_range).add(bottom).add(1);
    }

    function setSeed() internal{
        _seed = abi.encodePacked(keccak256(abi.encodePacked(now, _seed, seed(), msg.sender)));
    }

    function seed() internal view returns(bytes memory){

        return abi.encodePacked((keccak256(abi.encodePacked(_seed, now, gasleft()))));
    }
}


contract Context {
    
    constructor () internal {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        return msg.data;
    }
}

interface IERC165 {
    
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) public view returns (uint256 balance);

    function ownerOf(uint256 tokenId) public view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

contract IERC721Receiver {
    
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}

library Address {
    
    function isContract(address account) internal view returns (bool) {
        
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
}

library Counters {
    using SafeMath for uint256;

    struct Counter {
        
        uint256 _value;
    }

    function setBalance(Counter storage counter, uint newValue) internal{
        counter._value = newValue;
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}

contract ERC165 is IERC165 {
    
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        
        
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

contract ERC721 is Context, ERC165, IERC721, math{
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    mapping (address => uint[]) _ownTokens;

    mapping (uint256 => address) internal _tokenOwner;

    mapping (uint256 => address) private _tokenApprovals;

    mapping (address => Counters.Counter) internal _ownedTokensCount;

    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor () public {
        
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    function ownTokens(address _address) public view returns(uint[] memory){
        return _ownTokens[_address];
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].current();
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner;
        if(tokenId <= 1000000 && _tokenOwner[tokenId] == address(0)){
            owner = address(this);
        }else{
            owner = _tokenOwner[tokenId];
        }
        
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

    
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    
    function setApprovalForAll(address to, bool approved) public {
        require(to != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][to] = approved;
        emit ApprovalForAll(_msgSender(), to, approved);
    }

    
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    
    function transferFrom(address from, address to, uint256 tokenId) public {
        
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transferFrom(from, to, tokenId);
    }

    
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransferFrom(from, to, tokenId, _data);
    }

    
    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
        _transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    
    function _safeMint(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId, "");
    }

    
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        _ownTokens[to].push(tokenId);

        emit Transfer(address(0), to, tokenId);
    }

    
    function _burn(address owner, uint256 tokenId) internal {
        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");

        _clearApproval(tokenId);

        _ownedTokensCount[owner].decrement();
        _tokenOwner[tokenId] = address(0);

        //////////////////////////////////////

        uint256[] storage fromTokens = _ownTokens[owner];
        uint i;
        for (i = 0; i < fromTokens.length; i++) {
            if (fromTokens[i] == tokenId) {
                break;
            }
        }
        assert(i < fromTokens.length);

        fromTokens[i] = fromTokens[fromTokens.length - 1];
        delete fromTokens[fromTokens.length - 1];
        fromTokens.length--;

        //////////////////////////////////////

        emit Transfer(owner, address(0), tokenId);
    }

    
    function _burn(uint256 tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _clearApproval(tokenId);

        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();

        _tokenOwner[tokenId] = to;

        /////////////////////////////////////

        _ownTokens[to].push(tokenId);

        if(from != address(this)){
            uint256[] storage fromTokens = _ownTokens[from];
            uint i;
            for (i = 0; i < fromTokens.length; i++) {
                if (fromTokens[i] == tokenId) {
                    break;
                }
            }
            
            assert(i < fromTokens.length);

            fromTokens[i] = fromTokens[fromTokens.length - 1];
            delete fromTokens[fromTokens.length - 1];
            fromTokens.length--;
        }

        ////////////////////////////////////

        emit Transfer(from, to, tokenId);
    }

    
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    
    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

/*====================================================================================
                                Stars Character Contract
====================================================================================*/

contract StarsCharacter is Manager, ERC721{
 
    using Address for address;
    uint createId;
    uint initAmount = 0;
    uint8 Expansion;
    uint8 ExpSkill;
    uint8 ExpGender;

    address _starsCha;
    address _idolsCha;

    constructor() public{
        createId = initAmount.add(1);
        Expansion = 1;
        ExpSkill = 1;
		ExpGender = 1;
        _ownedTokensCount[address(this)].setBalance(0);
    }

    function setStarsWorld(address _address) public onlyManager{
        _starsCha = _address;
    }

    function Stars_World() public view returns(address){
        require(_starsCha != address(0), "StarsWorld contract address is null");
        return _starsCha;
    }
	
    function setIdolsWorld(address _address) public onlyManager{
        _idolsCha = _address;
    }
	
    function Idols_World() public view returns(address){
        require(_idolsCha != address(0), "IdolsWorld contract address is null");
        return _idolsCha;
    }

    modifier onlySWorld{
        require(msg.sender == Stars_World() || msg.sender == Idols_World(), "yor are not World contract");
        _;
    }

    function setExpansion(uint8 Type, uint8 LV) public onlyManager{
		if(Type == 1)
		{
			Expansion = LV;
		}else if (Type == 2)
		{
			ExpSkill = LV;
		}else if (Type == 3)
		{
			ExpGender = LV;
		}
    }

    mapping (uint => stars) private cryptoStars;
    event CreateChaResult(address indexed player,uint starsId, uint8 result);  
    event MixStarsResult(address indexed player,uint starsId, uint result);  
    event InheritStarsResult(address indexed player,uint starsId);  
    
    struct stars{
        ability a;
        mood m;
        name n;
        initial i;
    }

    struct initial{
        bool ability;
        bool mood;
        bool name;
    }

    struct ability{  //能力
        uint8 Cha_Life; //生命週期
        uint8 Cha_Acting; //演技
        uint8 Cha_Singing; //唱功
        uint8 Cha_LUCK; //幸運
        uint8 Cha_Level; //咖位
        uint Cha_Popularity; //知名度
    }

    struct mood{  //心境
        uint8 Cha_Nation; //國籍
        uint8 Cha_Type; //偶像類型
        uint Cha_Avatar; //外觀
        uint8 Cha_Rarity; //稀有度
		uint8 Cha_Relationship; //親密度
    }

    struct name{
        uint8 FirstName; 
        uint8 MiddleName;
        uint8 LastName;
        uint8 NickName;
        uint8 Skill;
    }
/////////////////////////////////_set////////////////////////////////////
    function _set_ability(stars storage s, ability memory a) internal{

        if(!s.i.ability){
            s.i.ability = true;
        }
        s.a = a;
    }

    function _set_mood(stars storage s, mood memory m) internal{

        if(!s.i.mood){
            s.i.mood = true;
        }
        s.m = m;
    }

    function _set_name(stars storage s, name memory n) internal{

        if(!s.i.name){
            s.i.name = true;
        }
        s.n = n;
    }

////////////////////////////////inquire//////////////////////////////////
    function _starsAbility(uint starsId) internal view returns(ability memory){
        require(_exist(starsId), "stars is not exist");
        return cryptoStars[starsId].a;
    }
	
    function _starsMood(uint starsId) internal view returns(mood memory){
        require(_exist(starsId), "stars is not exist");
        return cryptoStars[starsId].m;
    }
	
    function _starsName(uint starsId) internal view returns(name memory){
        require(_exist(starsId), "stars is not exist");
        return cryptoStars[starsId].n;
    }
	
//--Inquire--//
    function inqstarsAbility(uint starsId) external view returns
    (uint8 Cha_Life, uint8 Cha_Acting, uint8 Cha_Singing, uint8 Cha_LUCK, uint8 Cha_Level, uint Cha_Popularity){
        ability memory a = _starsAbility(starsId);
        return(a.Cha_Life, a.Cha_Acting, a.Cha_Singing, a.Cha_LUCK, a.Cha_Level, a.Cha_Popularity);
    }

    function inqstarsMood(uint starsId) external view returns
    (uint8 Cha_Nation, uint8 Cha_Type, uint Cha_Avatar, uint8 Cha_Rarity, uint8 Cha_Relationship){
        mood memory m = _starsMood(starsId);
        return(m.Cha_Nation, m.Cha_Type, m.Cha_Avatar, m.Cha_Rarity, m.Cha_Relationship);
    }

    function inqstarsName(uint starsId) external view returns
    (uint8 FirstName, uint8 MiddleName, uint8 LastName, uint8 NickName, uint8 Skill){
        name memory n = _starsName(starsId);
        return(n.FirstName, n.MiddleName, n.LastName, n.NickName, n.Skill);
    }

    function inqExpansion(address player,int Type) public view returns(uint8){
		if(Type == 1)
		{
			return Expansion;
		}else if (Type == 2)
		{
			return ExpSkill;
		}else if (Type == 3)
		{
			return ExpGender;
		}
    }
	
	function _exist(uint starsId) public view returns(bool){
        return createId >= starsId;
    }
	
//--X Function--//
    function _Createstars(address player, uint8 GEM) public onlySWorld{
        bytes32 seed = keccak256(abi.encodePacked(uint64(now), "Createstars"));
        uint8 RareX = range8(uint8(seed[9]), 1, 100);
        _mint(player, createId);
		
		uint8 Cha_Life = 12;
		uint8 Cha_Acting = 1;
		uint8 Cha_Singing = 1;
		uint8 Cha_LUCK = 1;
		uint8 Cha_Rarity = 1;

		bool Cha_Gender = false;
		if(ExpGender > 2)
		{
			Cha_Gender = range8(uint8(seed[11]), 0, 9) >= 5;
		}
		
        uint8 Cha_Nation = range8(uint8(seed[15]), 1, 5);
        uint8 Cha_Type = range8(uint8(seed[17]), 1, 10);
        uint Cha_Avatar = range8(uint8(seed[19]), 4, Expansion.add(99));

		if(GEM != 0 || RareX >=95)
		{
			uint RareRate = range8(uint8(seed[13]), 1, 100).add(GEM.mul(2));
			if(RareRate <= 50)
			{
				Cha_Life = range8(uint8(seed[1]), 18, 60);
				Cha_Acting = range8(uint8(seed[3]), 2, 7);
				Cha_Singing = range8(uint8(seed[5]), 2, 7);
				Cha_LUCK = range8(uint8(seed[7]), 2, 7);
				Cha_Rarity = 2;
				emit CreateChaResult(msg.sender, createId, 2);
			}else if(RareRate <= 100 && RareRate > 50){
				Cha_Life = range8(uint8(seed[1]), 24, 75);
				Cha_Acting = range8(uint8(seed[3]), 3, 8);
				Cha_Singing = range8(uint8(seed[5]), 3, 8);
				Cha_LUCK = range8(uint8(seed[7]), 3, 8);
				Cha_Rarity = 3;
				emit CreateChaResult(msg.sender, createId, 3);
			}else if(RareRate <= 180 && RareRate > 100){
				Cha_Life = range8(uint8(seed[1]), 30, 90);
				Cha_Acting = range8(uint8(seed[3]), 4, 9);
				Cha_Singing = range8(uint8(seed[5]), 4, 9);
				Cha_LUCK = range8(uint8(seed[7]), 4, 9);
				Cha_Rarity = 4;
				emit CreateChaResult(msg.sender, createId, 4);
			}else {
				if(Cha_Nation == 4)
				{
					Cha_Avatar = range8(uint8(seed[19]), 1, Expansion.add(99));
				}
				Cha_Life = range8(uint8(seed[1]), 36, 120);
				Cha_Acting = range8(uint8(seed[3]), 5, 10);
				Cha_Singing = range8(uint8(seed[5]), 5, 10);
				Cha_LUCK = range8(uint8(seed[7]), 5, 10);
				Cha_Rarity = 5;
				emit CreateChaResult(msg.sender, createId, 5);
			}
		}else {
			Cha_Life = range8(uint8(seed[1]), 12, 60);
			Cha_Acting = range8(uint8(seed[3]), 1, 5);
			Cha_Singing = range8(uint8(seed[5]), 1, 5);
			Cha_LUCK = range8(uint8(seed[7]), 1, 5);
			Cha_Rarity = 1;
		    emit CreateChaResult(msg.sender, createId, 1);
		}

        cryptoStars[createId].a = ability(Cha_Life, Cha_Acting, Cha_Singing, Cha_LUCK, 1, 0);
        cryptoStars[createId].m = mood(Cha_Nation, Cha_Type, Cha_Avatar, Cha_Rarity, 0);
        cryptoStars[createId].n = name(0, 0, 0, 0, 0);
        _Randomname(createId);  
        createId = createId.add(1);
    }

    function _Randomname(uint starsId) private{
        bytes32 seed = keccak256(abi.encodePacked(uint64(now), "_Randomname"));
        uint8 FirstName = range8(uint8(seed[1]), 1, 255);
        uint8 MiddleName = range8(uint8(seed[3]), 1, 255);
        uint8 LastName = range8(uint8(seed[5]), 1, 255);
        uint8 NickName = range8(uint8(seed[5]), 1, 81);
        cryptoStars[starsId].n = name(FirstName, MiddleName, LastName, NickName, 0);
    }
	
    function _addAbility(uint starsId, uint8 AType, uint Amount) public onlySWorld{
        ability storage a = cryptoStars[starsId].a;
        if(AType == 1) {
            a.Cha_Life = a.Cha_Life.add(uint8(Amount));
        }else if(AType == 2) {
            a.Cha_Acting = a.Cha_Acting.add(uint8(Amount));
        }else if(AType == 3) {
            a.Cha_Singing = a.Cha_Singing.add(uint8(Amount));
        }else if(AType == 4) {
            a.Cha_LUCK = a.Cha_LUCK.add(uint8(Amount));
        }else if(AType == 5) {
            a.Cha_Level = a.Cha_Level.add(uint8(Amount));
        }else if(AType == 6) {
            a.Cha_Popularity = a.Cha_Popularity.add(Amount);
        }else if(AType == 7) {
            a.Cha_Life = a.Cha_Life.sub(uint8(Amount));
        }
    }

    function _nameChange(uint starsId, uint8 AType, uint8 N1) public onlySWorld{
        require(AType <= 4 && AType > 0 && N1 <= 255, "Name type is incorrect.");
        name storage n = cryptoStars[starsId].n;
        if(AType == 1) {
            n.FirstName = N1;
        }
		else if(AType == 2)
		{
            n.MiddleName = N1;
        }
		else if(AType == 3)
		{
            n.LastName = N1;
        }
		else if(AType == 4)
		{
            n.NickName = N1;
        }
		else if(AType == 5)
		{
            n.Skill = N1;
        }
    }
	
    function _ChangeMoon(uint starsId, uint8 AType, uint8 Amount) public onlySWorld{
        mood storage m = cryptoStars[starsId].m;
        if(AType == 1) {
            m.Cha_Avatar = Amount;
        }
		else if(AType == 2)
		{
            m.Cha_Relationship = Amount;
        }
    }
	
    function _levelUp(uint starsId) public onlySWorld{
        ability storage a = cryptoStars[starsId].a;
		uint _needP = (5**uint(a.Cha_Level.sub(1))).mul(10000);
		if(a.Cha_Level >= 4)
		{
			_needP = _needP.mul(5);
		}
		require(a.Cha_Popularity >= _needP && a.Cha_Level < 5, "Popularity is incorrect.");
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "levelUp"));
		
		a.Cha_Life = a.Cha_Life.add(range8(uint8(seed[1]), 1, 10));
		a.Cha_Acting = a.Cha_Acting.add(range8(uint8(seed[3]), 1, 2));
		a.Cha_Singing = a.Cha_Singing.add(range8(uint8(seed[7]), 1, 2));
		a.Cha_LUCK = a.Cha_LUCK.add(range8(uint8(seed[9]), 1, 2));	
		a.Cha_Popularity = a.Cha_Popularity.sub(_needP);	
		a.Cha_Level = a.Cha_Level.add(1);
    }
	
    function _MixStars(address Player, uint starsId_C1, uint starsId_C2) public onlySWorld{
		require(ownerOf(starsId_C1) == Player && ownerOf(starsId_C2) == Player, "Incorrect.");
	    ability storage a = cryptoStars[starsId_C2].a;
		mood storage m = cryptoStars[starsId_C2].m;
		uint AddP = uint((5**a.Cha_Level.sub(1))).mul(1000).mul(m.Cha_Rarity);
		_addAbility(starsId_C1, 6, AddP);
		_burn(Player, starsId_C2);
		emit MixStarsResult(msg.sender, starsId_C1, AddP);
    }
	
    function _InheritStars(address Player, uint starsId) public onlySWorld{
	    ability storage a = cryptoStars[starsId].a;
		require(a.Cha_Level >= 4 && ownerOf(starsId) == Player, "Level is incorrect.");
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "_InheritStars"));
	    mood storage m = cryptoStars[starsId].m;
        name storage n = cryptoStars[starsId].n;

        _mint(Player, createId);
		uint8 _Life = range8(uint8(seed[1]), 60, 120);
		uint8 _FirstName = range8(uint8(seed[3]), 1, 255);
        cryptoStars[createId].a = ability(_Life, a.Cha_Acting, a.Cha_Singing, a.Cha_LUCK, 1, 0);
        cryptoStars[createId].m = mood(m.Cha_Nation, m.Cha_Type, m.Cha_Avatar, m.Cha_Rarity, 0);
        cryptoStars[createId].n = name(_FirstName, n.MiddleName, n.LastName, n.NickName, n.Skill);

		_burn(Player, starsId);
		emit InheritStarsResult(msg.sender, createId);
        createId = createId.add(1);
    }

    function _GetSkill(uint starsId) public onlySWorld{
	    name storage n = cryptoStars[starsId].n;
        bytes32 seed = keccak256(abi.encodePacked(uint64(now), "_GetSkill"));
        uint8 _Skill = range8(uint8(seed[1]), 1, ExpSkill.mul(30));
        n.Skill = _Skill;
    }
}
