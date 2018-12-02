//var db = require('../Database/db.js');
var express = require('express');
var Web3 =require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider ("http://localhost:8545"));
web3.eth.defaultAccount = web3.eth.accounts[0];


var fs = require('fs');
var jsonFile = "../build/contracts/LMS.json";
var parsed= JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;
//console.log(abi);

var librarySystems = web3.eth.contract(abi);

var librarySystem = librarySystems.at("0x5dfd86be6c6022dcb96b24dab1b3aed820583940");


exports.librarySystem = librarySystem;

