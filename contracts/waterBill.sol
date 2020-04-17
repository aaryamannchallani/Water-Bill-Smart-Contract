pragma solidity ^0.5.0;
contract waterBill{
    address payable admin;
     uint public rateperliter;
    struct Individual{
        string name;
        string addr;
        uint water;
        uint BillAmount;
        bool BillPaid;
    }
    mapping (address=>Individual) individual;
    address[] Useraccts;
    constructor() public{
        admin=msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender==admin,"Only Admin has access to this function");_;
    }
    modifier RateSet(){
        require(rateperliter!=0,"Please fill rate per liter first!");_;
    }

     event NewUser(
         string _name,
         address _address,
         uint _waterconsumed
         );
      event BillGenerated(
          address _address,
       uint billamount
          );
      event Billpaid(
        address _address,
        uint _amount,
        bool _paid
        );
    function setUser(string memory _name,address _address,uint _waterconsumed,string memory _Physicaladdress) public onlyAdmin()
    {
        Individual storage User=individual[_address];
        User.name=_name;
        User.water=_waterconsumed;
        User.addr=_Physicaladdress;
        Useraccts.push(_address) -1;
    emit NewUser(_name,_address,_waterconsumed);
     }
      function setBill(address _address) public onlyAdmin() RateSet() returns(uint){
          individual[_address].BillAmount=individual[_address].water*rateperliter;
          individual[_address].BillPaid=false;


        emit BillGenerated(_address,individual[_address].BillAmount);
       return individual[_address].BillAmount;
   }
    function getBill(address _address) view public returns(uint){
        return individual[_address].BillAmount;
    }
     function setRate(uint _rate) public onlyAdmin(){
      rateperliter=_rate;
     }
    function getDetails(address _address) public view onlyAdmin() returns(string memory,uint,string memory,uint,bool){
        return (individual[_address].name,individual[_address].water,individual[_address].addr,individual[_address].BillAmount,individual[_address].BillPaid);
    }
    function payBill(address _address) payable public returns(bool){
        require(msg.sender==_address,"Only User can pay his/her own bills");
        require(msg.value==individual[_address].BillAmount*1000000000000000000,"Please pay only the Bill Amount");
        individual[_address].BillPaid=true;
        individual[_address].BillAmount=0;
        individual[_address].water=0;
        admin.transfer(msg.value);
        emit Billpaid(_address,msg.value,true);
        return individual[_address].BillPaid;
    }
}
