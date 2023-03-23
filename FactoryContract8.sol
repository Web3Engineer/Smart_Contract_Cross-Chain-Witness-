//SPDX-License-Identifier: FOSS
pragma solidity ^0.8.0;

//DECENTRALIZED AUTOMATED CLEARING HOUSE d-ACH
contract FactoryContract8 {

////**STATE VARIABLES**////
address private antiSpam;
uint private userAddressCt;
uint private comptAddressCt;

////**STATE ARRAYS**////
string[3] private initComptrollersCSV;

constructor (string memory _comptrollersCSV24, string memory _dataLoad1, string memory _dataLoad2){
initComptrollersCSV = [_comptrollersCSV24, _dataLoad1, _dataLoad2];
antiSpam = msg.sender;
}

////**CUSTOM Complex DATA STRUCTURES**////
struct comptroller0Struct{
    bool invoked;
    string compKey;
    string miningAvenue;
    string userCashKeyPromised;
    string userCashKeyAmount;
    uint blockStamp;
    uint blockNum;
}
struct comptroller1Struct{
    bool invoked;
    string userCashKeyPromised;
    uint userCashKeyAmount;
    string txHash_URIdata;
    uint blockStamp;
    uint blockNum;
}


struct userPhase0Struct{
    bool invoked;
    string promisedCompKey;
    uint56 promisedAmount;
    uint time;
    uint blockNum;
}
struct userPhase1Struct{
    bool invoked;
    string txHashAndURIdata;
    uint time;
    uint blockNum;
}

struct userStruct{
    address msgSender;
    string userCashKey;
}
struct comptStruct{
    address comptrollerAddress;
    string userCashKeyPromised;
}


////**MAPPINGS**////
//Simple dictionary for lookup of all Users & Comptrollers Adress'/keys
mapping(uint=>userStruct)private userAddressMap;
mapping(uint=>comptStruct)private comptAddressMap;

mapping( address=>mapping (string=>comptroller0Struct) )private Comptroller0Map;
mapping( address=>mapping (string=>comptroller1Struct) )private Comptroller1Map;

//Top Mapping (Key is msg.sender => Value is Nested Mapping)
//Nested Mapping (Key is Users cash-key => Value is User Phase Structs)
mapping( address=>mapping (string=>userPhase0Struct) )private UserPhase0Map;
mapping( address=>mapping (string=>userPhase1Struct) )private UserPhase1Map;


////**FUNCTIONS**////
//Get Address' & Counts
function getComptAddressCt ()external view returns(uint){return comptAddressCt;}

function getComptAddress (uint _index)external view returns(comptStruct memory){return comptAddressMap[_index];}

function getUserAddressCt ()external view returns(uint){return userAddressCt;}

function getUserAddress (uint _index)external view returns(userStruct memory){return userAddressMap[_index];}

//Anti-Spam Withdrawal
function antiSpamFund() external{
require(antiSpam==msg.sender);
return payable (antiSpam).transfer(address(this).balance); 
}

//Set & Get Comptroller data
function setComptroller_0 (string memory _compKey,
                              string memory _miningAvenue,
                              string memory _userCashKeyPromised,
                              string memory _userCashKeyAmount)external payable{
require(msg.value>400 && Comptroller0Map[msg.sender][_userCashKeyPromised].invoked==false);
Comptroller0Map[msg.sender][_userCashKeyPromised].invoked=true;
Comptroller0Map[msg.sender][_userCashKeyPromised].compKey=_compKey;
Comptroller0Map[msg.sender][_userCashKeyPromised].miningAvenue=_miningAvenue;
Comptroller0Map[msg.sender][_userCashKeyPromised].userCashKeyPromised=_userCashKeyPromised;
Comptroller0Map[msg.sender][_userCashKeyPromised].userCashKeyAmount=_userCashKeyAmount;
Comptroller0Map[msg.sender][_userCashKeyPromised].blockStamp=block.timestamp;
Comptroller0Map[msg.sender][_userCashKeyPromised].blockNum=block.number;
comptAddressCt++;
comptAddressMap[comptAddressCt].comptrollerAddress=msg.sender;
comptAddressMap[comptAddressCt].userCashKeyPromised=_userCashKeyPromised;
}

function setComptroller_1 (string memory _userCashKeyPromised,
                           uint _userCashKeyAmount,
                           string memory _txHash_URIdata)external{
require(Comptroller1Map[msg.sender][_userCashKeyPromised].invoked==false
        && Comptroller0Map[msg.sender][_userCashKeyPromised].invoked==true
        && Comptroller0Map[msg.sender][_userCashKeyPromised].blockStamp<block.timestamp
        && Comptroller0Map[msg.sender][_userCashKeyPromised].blockNum<block.number);
Comptroller1Map[msg.sender][_userCashKeyPromised].invoked=true;
Comptroller1Map[msg.sender][_userCashKeyPromised].userCashKeyPromised=_userCashKeyPromised;
Comptroller1Map[msg.sender][_userCashKeyPromised].userCashKeyAmount=_userCashKeyAmount;
Comptroller1Map[msg.sender][_userCashKeyPromised].txHash_URIdata=_txHash_URIdata;
Comptroller1Map[msg.sender][_userCashKeyPromised].blockStamp=block.timestamp;
Comptroller1Map[msg.sender][_userCashKeyPromised].blockNum=block.number;
}

function getMyComptrollerData (string memory _userCashKeyPromised)external view returns(comptroller0Struct memory, comptroller1Struct memory){
return (Comptroller0Map[msg.sender][_userCashKeyPromised], Comptroller1Map[msg.sender][_userCashKeyPromised]);}

function searchComptrollerData (address _comptrollersAddress, string memory _userCashKeyPromised)external view returns(comptroller0Struct memory, comptroller1Struct memory){
return (Comptroller0Map[_comptrollersAddress][_userCashKeyPromised], Comptroller1Map[_comptrollersAddress][_userCashKeyPromised]);}


//Set & Get User data
function setUserPhase0 (string memory _userCashKey,
                        string memory _promisedCompKey, 
                        uint56 _promisedAmount)external payable{
require(msg.value>321 && UserPhase0Map[msg.sender][_userCashKey].invoked==false);
UserPhase0Map[msg.sender][_userCashKey].invoked=true;
UserPhase0Map[msg.sender][_userCashKey].promisedCompKey=_promisedCompKey;
UserPhase0Map[msg.sender][_userCashKey].promisedAmount=_promisedAmount;
UserPhase0Map[msg.sender][_userCashKey].time=block.timestamp;
UserPhase0Map[msg.sender][_userCashKey].blockNum=block.number;
userAddressCt++;
userAddressMap[userAddressCt].msgSender=msg.sender;
userAddressMap[userAddressCt].userCashKey=_userCashKey;
}
function setUserPhase1 (string memory _userCashKey, string memory _txHashAndURIdata)external{
require(UserPhase1Map[msg.sender][_userCashKey].invoked==false
       && UserPhase0Map[msg.sender][_userCashKey].invoked==true
       && UserPhase0Map[msg.sender][_userCashKey].blockNum<block.number);
UserPhase1Map[msg.sender][_userCashKey].invoked=true;
UserPhase1Map[msg.sender][_userCashKey].txHashAndURIdata=_txHashAndURIdata;
UserPhase1Map[msg.sender][_userCashKey].time=block.timestamp;
UserPhase1Map[msg.sender][_userCashKey].blockNum=block.number;
}

//Grab My User Phase Data
function getMyUserData (string memory _userCashKey)external view returns(userPhase0Struct memory, userPhase1Struct memory){
return (UserPhase0Map[msg.sender][_userCashKey], UserPhase1Map[msg.sender][_userCashKey]);}

//Search User Phase Data By Address
function searchUserData (address _userAddress, string memory _userCashKey)external view returns(userPhase0Struct memory, userPhase1Struct memory){
return (UserPhase0Map[_userAddress][_userCashKey], UserPhase1Map[_userAddress][_userCashKey]);}


}
