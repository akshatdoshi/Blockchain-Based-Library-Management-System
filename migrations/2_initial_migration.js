var studentGrading = artifacts.require("./LMS.sol");

module.exports = function(deployer) {
  deployer.deploy(studentGrading);
};
