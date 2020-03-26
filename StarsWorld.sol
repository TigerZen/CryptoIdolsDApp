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

/*====================================================================================
                                StarsWorld Contract
====================================================================================*/

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

interface StarsWorld{
    function inqstarsAbility(uint starsId) external view returns
    (uint8 Cha_Life, uint8 Cha_Acting, uint8 Cha_Singing, uint8 Cha_LUCK, uint8 Cha_Level, uint Cha_Popularity);

    function inqstarsMood(uint starsId) external view returns
    (uint8 Cha_Nation, uint8 Cha_Type, uint8 Cha_Avatar, uint8 Cha_Rarity, uint8 Cha_Relationship);
	
    function inqstarsName(uint starsId) external view returns
    (uint8 FirstName, uint8 MiddleName, uint8 LastName, uint8 NickName);

    function _Createstars(address player, uint8 GEM) external;
    
    function _addAbility(uint starsId, uint8 AType, uint Amount) external;

    function _ChangeMoon(uint starsId, uint8 AType, uint8 Amount) external;
	
    function _nameChange(uint starsId, uint8 AType, uint8 N1) external;

    function _levelUp(uint starsId) external;

    function _MixStars(address Player, uint starsId_C1, uint starsId_C2) external;

    function _InheritStars(address Player, uint starsId) external;

    function ownerOf(uint256 tokenId) external view returns (address);

}

contract cStars is Manager{
    address _SChaAddr;

    function SCha721Addr() public view returns(address){
        require(_SChaAddr != address(0), "Address incorrect.");
        return _SChaAddr;
    }

    function setSChaA721(address addr) public onlyManager{
        _SChaAddr = addr;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return StarsWorld(SCha721Addr()).ownerOf(tokenId);
    }

    function inqstarsAbility(uint starsId) public view returns
    (uint8 Cha_Life, uint8 Cha_Acting, uint8 Cha_Singing, uint8 Cha_LUCK, uint8 Cha_Level, uint Cha_Popularity){
        return (StarsWorld(SCha721Addr()).inqstarsAbility(starsId));
    }

    function inqstarsMood(uint starsId) public view returns
    (uint8 Cha_Nation, uint8 Cha_Type, uint8 Cha_Avatar, uint8 Cha_Rarity, uint8 Cha_Relationship){
        return (StarsWorld(SCha721Addr()).inqstarsMood(starsId));
    }

    function inqstarsName(uint starsId) public view returns
    (uint8 FirstName, uint8 MiddleName, uint8 LastName, uint8 NickName){
        return (StarsWorld(SCha721Addr()).inqstarsName(starsId));
    }
}

contract StarsGame is cStars, math{

    using Address for address;
    using Sort for uint[];
    uint _PlayerId;
    uint initAmount = 0;
    uint _PayGems01;
    uint _PayGems02;
    uint _PayGems03;
	
    constructor() public{
        _PlayerId = initAmount.add(1);
    }
	
    mapping (uint => ChaS) private SCharacter;
    mapping(address => _Status) StarsStatus;
    mapping(address => _Game) StarsGame;
    mapping(address => _GameStartInfo) StarsGameInfo;

	event GameDiceResult(address indexed player, uint8 _GameP, uint _PopGet, uint8 result, uint8 XDiceNO);  
	event EndGameResult(address indexed player, uint _StarID, uint _CashGet, uint _PopGet, uint _RPGet);  
	//event ShopResult(address indexed player, uint8 Stype);  

    function() external payable{}

    struct ChaS{
        _Status s;
        _Game g;
        _GameStartInfo gsi;
    }
	
    struct _Status{
        bool IsReg;  //是否註冊
        uint PlayerID;  //玩家編號
        //string AgencyName;  //經紀公司名
        uint SCash;  //現金數
        uint SGem;  //寶石數
    }

    struct _Game{
        bool IsGame;  //是否進入活動
        uint8 GameType;  //活動類型
        uint8 GameSize;  //活動規模
        uint8 Location;  //活動所在地
    }
	
    struct _GameStartInfo{
        uint StarInGame; //活動中的偶像ID
        uint8 Star_Acting; //演技
        uint8 Star_Singing; //唱功
        uint8 Star_LUCK; //幸運
        uint8 Star_Level; //咖位
        uint GamePoint;  //活動點數
        uint Star_PopGet; //取得知名度
    }

    function clearGame(_Game storage g, _GameStartInfo storage gsi) internal{
        g.IsGame = false;
        g.GameType = 0;
        g.GameSize = 0;
        g.Location = 0;
		gsi.StarInGame = 0;
		gsi.Star_Acting = 0;
		gsi.Star_Singing = 0;
		gsi.Star_LUCK = 0;
		gsi.Star_Level = 0;
		gsi.GamePoint = 0;
		gsi.Star_PopGet = 0;
    }

    function setPayGems(uint8 Type, uint Amount) public onlyManager{
		if(Type == 1)
		{
			_PayGems01 = Amount;
		}else if(Type == 2){
			_PayGems02 = Amount;
		}else if(Type == 3){
			_PayGems03 = Amount;
		}
    }
/////////////////////////////////_set////////////////////////////////////

    function _set_Status(ChaS storage c, _Status memory s) internal{
        c.s = s;
    }

    function _set_Game(ChaS storage c, _Game memory g) internal{
        c.g = g;
    }

    function CreateStars(address player, uint8 GEM) private{
        StarsWorld(SCha721Addr())._Createstars(player, GEM);
    }
	
    function addAbility(uint starsId, uint8 AType, uint Amount) private{
        StarsWorld(SCha721Addr())._addAbility(starsId, AType, Amount);
    }
	
    function changeMoon(uint starsId, uint8 AType, uint8 Amount) private{
        StarsWorld(SCha721Addr())._ChangeMoon(starsId, AType, Amount);
    }

    function nameChange(uint starsId, uint8 AType, uint8 N1) public{
        StarsWorld(SCha721Addr())._nameChange(starsId, AType, N1);
    }
	
    function LevelUp(uint starsId) private{
        StarsWorld(SCha721Addr())._levelUp(starsId);
    }
	
    function MixStars(address Player, uint starsId_C1, uint starsId_C2) private{
        StarsWorld(SCha721Addr())._MixStars(Player, starsId_C1, starsId_C2);
    }
	
    function InheritStars(address Player, uint starsId) private{
        StarsWorld(SCha721Addr())._InheritStars(Player, starsId);
    }
    ///////////////////////////////////inquire function///////////////////////////////
    function inqRegistered(address player) public view returns(bool){
        return (StarsStatus[player].IsReg);
    }

    function inq_PlayerID() public view returns(uint){
        return (_PlayerId);
    }
	
    function inq_Status(address player) public view returns(bool IsReg, uint PlayerID, uint SCash, uint SGem){
        return (StarsStatus[player].IsReg, StarsStatus[player].PlayerID, StarsStatus[player].SCash, StarsStatus[player].SGem);
    }
	
    function inq_Game(address player) public view returns(bool IsGame, uint8 GameType, uint8 GameSize, uint8 Location){
        return (StarsGame[player].IsGame, StarsGame[player].GameType, StarsGame[player].GameSize, StarsGame[player].Location);
    }
	
    function inq_GameStartInfo(address player) public view returns(uint StarInGame, uint8 Star_Acting, uint8 Star_Singing, uint8 Star_LUCK, uint8 Star_Level, uint GamePoint, uint Star_PopGet){
        return (StarsGameInfo[player].StarInGame, StarsGameInfo[player].Star_Acting, StarsGameInfo[player].Star_Singing, StarsGameInfo[player].Star_LUCK, StarsGameInfo[player].Star_Level, StarsGameInfo[player].GamePoint, StarsGameInfo[player].Star_PopGet);
    }

	function inq_TimeFree(uint starsId) public view returns(bool){
	    if(StarsGameInfo[msg.sender].StarInGame != starsId)
		{
		return true;
		}else{
		return false;
		}
    }
	
    ////////////////////////////////////Game function////////////////////////////////	
    function register(uint R_ID) public {  //R_ID=介紹人遊戲ID
        require(StarsStatus[msg.sender].IsReg == false, "Registered!");
        StarsStatus[msg.sender].IsReg = true;
        //StarsStatus[msg.sender].AgencyName = _AgencyName;
		StarsStatus[msg.sender].PlayerID = _PlayerId;
        StarsStatus[msg.sender].SCash = 10000;
        StarsStatus[msg.sender].SGem = 0;

		_Status storage s = SCharacter[R_ID].s;
		if(R_ID <= _PlayerId && R_ID != 0)
		{
			s.SCash = s.SCash.add(10000);
			s.SGem = s.SGem.add(30);
			StarsStatus[msg.sender].SCash = 20000;
			StarsStatus[msg.sender].SGem = 30;
		}
		CreateCha(0);
		_PlayerId = _PlayerId.add(1);
		clearGame(StarsGame[msg.sender], StarsGameInfo[msg.sender]);
    }

    function ShopGemBuy() public payable {
        if(msg.value == 500 trx)
		{
			ShopGemPay(msg.sender, _PayGems01);
		}else if(msg.value == 2000 trx)
		{
			ShopGemPay(msg.sender, _PayGems02);
		}else if(msg.value == 5000 trx)
		{
			ShopGemPay(msg.sender, _PayGems03);
		}else{
			ShopGemPay(msg.sender, msg.value.div(4000000));
		}
		superManager.toPayable().transfer(msg.value);
    }
 
    function ShopCash() public {
		require(StarsStatus[msg.sender].SGem >= 100, "Out of Gem!");
		StarsStatus[msg.sender].SCash = StarsStatus[msg.sender].SCash.add(30000);
		StarsStatus[msg.sender].SGem = StarsStatus[msg.sender].SGem.sub(100); 
    }
    
    function ShopGemPay(address player, uint _GemAmount) private{
        StarsStatus[player].SGem = StarsStatus[player].SGem.add(_GemAmount);
    }
    
    function ShopGemPayB(address player, uint _GemAmount) public onlyManager{
        ShopGemPay(player, _GemAmount);
    }

    function ShopCashPayB(address player, uint _GemAmount) public onlyManager{
        StarsStatus[player].SCash = StarsStatus[player].SCash.add(_GemAmount);
    }

    function OpenLBox(uint8 BType) public {
	    if(BType == 1)
	    {
			require(StarsStatus[msg.sender].SGem >= 20, "Out of SGem!");
			CreateCha(0);
			StarsStatus[msg.sender].SGem = StarsStatus[msg.sender].SGem.sub(20);
		}else if(BType == 2)
		{
			require(StarsStatus[msg.sender].SGem >= 100, "Out of SGem!");
			CreateCha(25);
			StarsStatus[msg.sender].SGem = StarsStatus[msg.sender].SGem.sub(100);
		}else if(BType == 3)
		{
			require(StarsStatus[msg.sender].SGem >= 450, "Out of SGem!");
			CreateCha(50);
			StarsStatus[msg.sender].SGem = StarsStatus[msg.sender].SGem.sub(450);
		}
    }
	
    function CreateCha(uint8 GEM) private {
        CreateStars(msg.sender, GEM);
    }
	
    function MixStarsGO(uint starsId_C1, uint starsId_C2) public {
		//require(starsId_C1 != StarsGameInfo[msg.sender].StarInGame && starsId_C2 != StarsGameInfo[msg.sender].StarInGame, "Incorrect.");
		MixStars(msg.sender, starsId_C1, starsId_C2);
    }

    function LevelUpGO(uint starsId) public {
        (,,,,uint8 XLevel,) = inqstarsAbility(starsId);
        uint _GCashCost = (5**uint(XLevel.sub(1))).mul(10000);
        require(StarsStatus[msg.sender].SCash >= _GCashCost && ownerOf(starsId) == msg.sender, "Incorrect.");
        StarsStatus[msg.sender].SCash = StarsStatus[msg.sender].SCash.sub(_GCashCost); //扣除升級費用
		LevelUp(starsId);
    }

    function StartGame(uint starsId, uint8 GType, uint8 GSize) public {  //開啟活動
        uint _GCashCost = (5**uint(GSize.sub(1))).mul(1000);
		(uint8 _Life, uint8 _Acting, uint8 _Singing, uint8 _LUCK, uint8 _Level, ) = inqstarsAbility(starsId);
        require(StarsStatus[msg.sender].IsReg == true && _Life >= 1 && StarsStatus[msg.sender].SCash >= _GCashCost && StarsGame[msg.sender].IsGame == false && ownerOf(starsId) == msg.sender && inq_TimeFree(starsId) == true, "Incorrect.");
        StarsStatus[msg.sender].SCash = StarsStatus[msg.sender].SCash.sub(_GCashCost); //扣除活動費用
		addAbility(starsId, 7, 1);
        StarsGame[msg.sender].IsGame = true;
        StarsGame[msg.sender].GameType = GType;
        StarsGame[msg.sender].GameSize = GSize;

        StarsGameInfo[msg.sender].StarInGame = starsId;
        StarsGameInfo[msg.sender].Star_Acting = _Acting;
        StarsGameInfo[msg.sender].Star_Singing = _Singing;
        StarsGameInfo[msg.sender].Star_LUCK = _LUCK;
        StarsGameInfo[msg.sender].Star_Level = _Level;
    }
	
    function Dice() public {  //丟骰子進行活動
        require(StarsGame[msg.sender].Location < StarsGame[msg.sender].GameSize.mul(20), "Incorrect.");
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "Dice"));
		uint8 _DiceNO = range8(uint8(seed[1]), 1, 6);
		StarsGame[msg.sender].Location = StarsGame[msg.sender].Location.add(_DiceNO);
		GetResult(_DiceNO, StarsGame[msg.sender].GameType, StarsGame[msg.sender].GameSize);
    }

    function GetResult(uint8 XDiceNO, uint8 XGType, uint8 XGSize) private {  //丟完骰子後判斷行動的結果
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "GetResult"));
		uint8 _Event = range8(uint8(seed[1]), StarsGameInfo[msg.sender].Star_LUCK.mul(2), 100);
		uint XPopGet = uint(XGSize).mul(100);
		uint8 AddGameP = 1;
		uint AddRate = 1;
		if(_Event >= 50)
		{
			if(XGType == 1)
			{
				AddGameP = range8(uint8(seed[5]), 1, StarsGameInfo[msg.sender].Star_Singing);
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, StarsGameInfo[msg.sender].Star_Singing)));
			}else if(XGType == 2) {
				AddGameP = range8(uint8(seed[5]), 1, StarsGameInfo[msg.sender].Star_Acting);
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, StarsGameInfo[msg.sender].Star_Acting)));
			}else if(XGType == 3) {
				AddGameP = range8(uint8(seed[5]), 1, (StarsGameInfo[msg.sender].Star_Acting.add(StarsGameInfo[msg.sender].Star_Singing)).div(2));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, (StarsGameInfo[msg.sender].Star_Acting.add(StarsGameInfo[msg.sender].Star_Singing)).div(2))));
			}else if(XGType == 4) {
				AddGameP = range8(uint8(seed[5]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Singing)).div(2));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Singing)).div(2))));
			}else {
				AddGameP = range8(uint8(seed[5]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Acting)).div(2));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Acting)).div(2))));
			}
			StarsGameInfo[msg.sender].GamePoint = StarsGameInfo[msg.sender].GamePoint.add(uint(AddGameP));
			StarsGameInfo[msg.sender].Star_PopGet = StarsGameInfo[msg.sender].Star_PopGet.add(AddRate);
			emit GameDiceResult(msg.sender, AddGameP, AddRate, 1, XDiceNO);
		}else if(_Event >= 20 && _Event < 50){
			if(XGType == 1)
			{
				AddGameP = range8(uint8(seed[5]), 1, StarsGameInfo[msg.sender].Star_Singing.div(2));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, StarsGameInfo[msg.sender].Star_Singing.div(2))));
			}else if(XGType == 2) {
				AddGameP = range8(uint8(seed[5]), 1, StarsGameInfo[msg.sender].Star_Acting.div(2));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, StarsGameInfo[msg.sender].Star_Acting.div(2))));
			}else if(XGType == 3) {
				AddGameP = range8(uint8(seed[5]), 1, (StarsGameInfo[msg.sender].Star_Acting.add(StarsGameInfo[msg.sender].Star_Singing)).div(4));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, (StarsGameInfo[msg.sender].Star_Acting.add(StarsGameInfo[msg.sender].Star_Singing)).div(4))));
			}else if(XGType == 4) {
				AddGameP = range8(uint8(seed[5]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Singing)).div(4));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Singing)).div(4))));
			}else {
				AddGameP = range8(uint8(seed[5]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Acting)).div(4));
				AddRate = XPopGet.mul(uint(range8(uint8(seed[3]), 1, (StarsGameInfo[msg.sender].Star_LUCK.add(StarsGameInfo[msg.sender].Star_Acting)).div(4))));
			}
			StarsGameInfo[msg.sender].GamePoint = StarsGameInfo[msg.sender].GamePoint.add(uint(AddGameP));
			StarsGameInfo[msg.sender].Star_PopGet = StarsGameInfo[msg.sender].Star_PopGet.add(AddRate);
			emit GameDiceResult(msg.sender, AddGameP, AddRate, 2, XDiceNO);
		}else {
			StarsGameInfo[msg.sender].GamePoint = StarsGameInfo[msg.sender].GamePoint.add(1);
			StarsGameInfo[msg.sender].Star_PopGet = StarsGameInfo[msg.sender].Star_PopGet.add(AddRate);
			emit GameDiceResult(msg.sender, 1, AddRate, 3, XDiceNO);
		}
    }
			
    function EndGame() public {  //活動到達終點後結束活動結算成果
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "EndGame"));
		uint _StarID = StarsGameInfo[msg.sender].StarInGame;
		(,,,,uint8 XRP) = inqstarsMood(_StarID);
		uint XCashGet = uint(StarsGame[msg.sender].GameSize).mul(100).mul(StarsGameInfo[msg.sender].GamePoint);
		if(StarsGame[msg.sender].GameType == 5)
		{
			StarsGameInfo[msg.sender].Star_PopGet = StarsGameInfo[msg.sender].Star_PopGet.add(XCashGet);
			XCashGet = 0;
		}
		uint MaxP = StarsGameInfo[msg.sender].GamePoint.div(10);
		if(MaxP > 200)
		{
			MaxP = 200;
		}
		uint8 _EndRP = range8(uint8(seed[1]), 0, uint8(MaxP).add(StarsGameInfo[msg.sender].Star_LUCK));
		uint _SGemGet = uint(_EndRP.mul(StarsGame[msg.sender].GameSize.add(10))).div(10);
		StarsStatus[msg.sender].SCash = StarsStatus[msg.sender].SCash.add(XCashGet);
		addAbility(_StarID, 6, StarsGameInfo[msg.sender].Star_PopGet);
		uint8 _totalRP = XRP.add(_EndRP);
		if(_totalRP < 100)
		{
			changeMoon(_StarID, 2, _totalRP);
		}else
		{
			changeMoon(_StarID, 2, 100);
		}
		StarsStatus[msg.sender].SGem = StarsStatus[msg.sender].SGem.add(_SGemGet);
		emit EndGameResult(msg.sender, _StarID, XCashGet, StarsGameInfo[msg.sender].Star_PopGet, _SGemGet);
		clearGame(StarsGame[msg.sender], StarsGameInfo[msg.sender]);
    }

	function _dicePay() public payable{
		bytes32 seed = keccak256(abi.encodePacked(uint64(now), "Dice"));
		uint8 _DiceNO = range8(uint8(seed[1]), 1, 255);
		address PlayerA = msg.sender;
		if(_DiceNO < 2)
		{
			CreateCha(25);
		}
		
		PlayerA.toPayable().transfer(msg.value);
    }

	function QuitGame() public {
		uint _GCashCost = (5**uint(StarsGame[msg.sender].GameSize.sub(1))).mul(12000).div(10);
		StarsStatus[msg.sender].SCash = StarsStatus[msg.sender].SCash.add(_GCashCost);
		addAbility(StarsGameInfo[msg.sender].StarInGame, 1, 2);
		clearGame(StarsGame[msg.sender], StarsGameInfo[msg.sender]);
    }
}