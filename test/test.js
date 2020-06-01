let wb = artifacts.require("./waterBill.sol");

let wbinstance;

contract('waterBill', function (accounts) {
  //accounts[0] is the default account
  //Test case 1
  it("Contract Deployed", function() {
    return wb.deployed().then(function (instance) {
      wbinstance = instance;
      assert(wbinstance !== undefined, 'Coin contract should be defined');
    });
  });
});
