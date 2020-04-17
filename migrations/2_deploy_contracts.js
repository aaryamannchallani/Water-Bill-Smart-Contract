const waterBill = artifacts.require("waterBill");

module.exports = function(deployer) {
  deployer.deploy(waterBill);
};
