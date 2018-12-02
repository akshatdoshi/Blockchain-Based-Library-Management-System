pragma solidity ^0.4.18;

contract Darray {

    address creator;
    string imgbyte; 
    
    
    function setArray(string dincoming)  
    {
    	imgbyte = dincoming;
    }
    
    
    
    function getArray() constant returns (string)  
    {
    	return imgbyte;
    }
    
   
}