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
        return _ranking(data, true);
    }

    function ranking_(uint[] memory data) internal pure returns(uint[] memory){
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
                                CryptoIdols Contract
====================================================================================*/

contract CryptoIdols is Manager, ERC721{
 
    using Address for address;
    uint createId;
    uint initAmount = 0;
	uint _PlayerId;
	uint P_initAmount = 0;
	

    address _starsCha;

    constructor() public{
        createId = initAmount.add(1);
        _PlayerId = P_initAmount.add(1);
        _ownedTokensCount[address(this)].setBalance(0);
    }

    function setStarsWorld(address _address) public onlyManager{
        _starsCha = _address;
    }

    function Stars_World() public view returns(address){
        require(_starsCha != address(0), "StarsWorld contract address is null");
        return _starsCha;
    }

    modifier onlySWorld{
        require(msg.sender == Stars_World(), "yor are not World contract");
        _;
    }

    mapping (uint => ChaS) private idolsPlayer;
    mapping (uint => stars) private cryptoIdols;
	mapping(address => _Game) StarsGame;
	mapping (uint256 => address) internal _RegIDOwner;
	
    event RegResult(address indexed player, uint RegPlayerID, uint8 result);  
    event CreateIdolResult(address indexed player,uint starsId, uint8 result);  
	
    struct ChaS{
        _Game g;
    }
    struct _Game{
        bool IsReg;
        uint PlayerID;
        uint CodeA;
		uint CodeB;
        uint PayAmount;
    }

    struct stars{
        status s;
        initial i;
    }

    struct initial{
        bool status;
    }

    struct status{
        uint8 GameID;
        uint8 Type;
        uint Amount;
        uint XPlayerID;
        uint TrxPrice;
        uint ETC;
    }

/////////////////////////////////_set////////////////////////////////////
    function _set_status(stars storage st, status memory s) internal{

        if(!st.i.status){
            st.i.status = true;
        }
        st.s = s;
    }

////////////////////////////////inquire function//////////////////////////////////
    function _starsstatus(uint starsId) internal view returns(status memory){
        require(_exist(starsId), "stars is not exist");
        return cryptoIdols[starsId].s;
    }
	
//--Inquire--//
    function inqstarsStatus(uint starsId) external view returns
    (uint8 GameID, uint8 Type, uint Amount, uint XPlayerID, uint TrxPrice, uint ETC){
        status memory s = _starsstatus(starsId);
        return(s.GameID, s.Type, s.Amount, s.XPlayerID, s.TrxPrice, s.ETC);
    }

    function inq_StarsGame(address player) public view returns(bool IsReg, uint PlayerID, uint CodeA, uint CodeB, uint PayAmount){
        return (StarsGame[player].IsReg, StarsGame[player].PlayerID, StarsGame[player].CodeA, StarsGame[player].CodeB, StarsGame[player].PayAmount);
    }
	
    function inqRegistered(address player) public view returns(bool){
        return (StarsGame[player].IsReg);
    }
	
    function inq_PlayerID() public view returns(uint){
        return (_PlayerId);
    }
	
	function _exist(uint starsId) public view returns(bool){
        return createId >= starsId;
    }
////////////////////////////////////Game function////////////////////////////////	
    function register(uint _CodeA, uint _CodeB) public {
        require(StarsGame[msg.sender].IsReg == false, "Registered!");
        StarsGame[msg.sender].IsReg = true;
		StarsGame[msg.sender].PlayerID = _PlayerId;
        StarsGame[msg.sender].CodeA = _CodeA;
        StarsGame[msg.sender].CodeB = _CodeB;
		_RegIDOwner[_PlayerId] = msg.sender;
		_PlayerId = _PlayerId.add(1);
		emit CreateIdolResult(msg.sender, StarsGame[msg.sender].PlayerID, 1);
    }
	
    function CreateIdol(uint8 GameID, uint8 Type, uint Amount) public payable{
        require(StarsGame[msg.sender].IsReg == true, "Not registered!");
		uint _payAmount = msg.value.div(1000000);
		StarsGame[msg.sender].PayAmount = StarsGame[msg.sender].PayAmount.add(_payAmount);
		_toCreateIdol(GameID, Type, Amount, _payAmount);
		superManager.toPayable().transfer(msg.value);
    }
	
    function _toCreateIdol(uint8 GameID, uint8 Type, uint Amount, uint _payAmount) private {
        _mint(address(this), createId);
		cryptoIdols[createId].s = status(GameID, Type, Amount, StarsGame[msg.sender].PlayerID, _payAmount, 0);
		emit CreateIdolResult(msg.sender, createId, 1);
        createId = createId.add(1);
    }
	
    function _levelUp(uint starsId, uint8 _GameID, uint8 _Type, uint _Amount) public onlySWorld{
        require(_exist(starsId), "stars is not exist");
		status storage s = cryptoIdols[starsId].s;
		s.GameID = _GameID;
		s.Type = _Type;
		s.Amount = _Amount;
    }

    function P_levelUp(uint starsId, uint8 _GameID, uint8 _Type, uint _Amount) private {
        require(_exist(starsId), "stars is not exist");
		status storage s = cryptoIdols[starsId].s;
		s.GameID = _GameID;
		s.Type = _Type;
		s.Amount = _Amount;
    }

	function _dice() public {
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "Dice"));
		uint8 _DiceNO = range8(uint8(seed[1]), 1, 255);
		if(_DiceNO > 254)
		{
			_toCreateIdol(1, 1, 150, 0);
		}
    }
	
	function _dicePay() public payable{
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "Dice"));
		uint8 _DiceNO = range8(uint8(seed[1]), 1, 255);
		address PlayerA = msg.sender;
		if(_DiceNO < 2)
		{
			_toCreateIdol(1, 1, 150, 0);
		}
		
		PlayerA.toPayable().transfer(msg.value);
    }
	
    function _MixStars(uint starsId_C1, uint starsId_C2) public onlySWorld {
		require(ownerOf(starsId_C1) == msg.sender && ownerOf(starsId_C2) == msg.sender, "Incorrect.");
	    status storage s = cryptoIdols[starsId_C2].s;
		P_levelUp(starsId_C1, 1, 1, 1800);
		_burn(msg.sender, starsId_C2);
    }

    function MixDone(uint starsId) public onlySWorld {
		require(_exist(starsId) && ownerOf(starsId) == address(this), "Incorrect.");
		_burn(address(this), starsId);
    }
	
	function IDOwnerOf(uint256 PlayId) public view returns (address) {
        address owner;
        if(PlayId <= 1000000 && _RegIDOwner[PlayId] == address(0)){
            owner = address(this);
        }else{
            owner = _RegIDOwner[PlayId];
        }
        
        require(owner != address(0), "Play ID nonexistent");
        return owner;
    }
}
