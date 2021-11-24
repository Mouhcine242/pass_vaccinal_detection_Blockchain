pragma solidity >=0.4.22 <0.9.0;

contract Vaccination{

    uint public nbOwners ;

    struct Owner{

        uint256 id ;
        string CIN ;
        string FullName ;
        string qrHash ;
        string vaccine_name;
        uint nb_shots ;

    }
    Owner[] public owners ;

    constructor() public {

        nbOwners = 0;
    }

    event OwnerAdded(uint256 _id);
    event OwnerVerified(uint _id);
    event OwnerDeleted(uint _id);


    function addOwner(string memory _cin , string memory _fullName , string memory _qrhash , string memory _nameOfvaccine, uint _nbOfshots) public {

        owners[nbOwners] = Owner(nbOwners , _cin , _fullName , _qrhash , _nameOfvaccine , _nbOfshots);
        emit OwnerAdded(nbOwners);

        nbOwners++; 

    }

    function deleteOwner(uint256 _id) public{
        delete owners[_id] ;
        emit OwnerDeleted(_id);
        nbOwners--;

    }

    function verifyOwner(string memory qr) public returns(bool ){

        for(uint i=0 ; i< owners.length ; i++){
            if(keccak256(abi.encodePacked(owners[i].qrHash)) == keccak256(abi.encodePacked(qr))){
                return true;
            }
            return false ;
            

        } 
    }

}