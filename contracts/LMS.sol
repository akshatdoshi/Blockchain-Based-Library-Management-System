pragma solidity ^0.4.18;



contract LMS{
    address public owner;
    uint public issuedate;
    uint public timeDuration;
    uint public returndate;
    uint public addBookEventCnt;
	
    struct book{
        uint ISDN;
        string title;
        string author;
        string publisher;
        uint totalNumberofBook;
        uint numberofAvailableBooks;
        uint bookAdded;
        uint [] bookStack;
        mapping(uint => multipleBookDetails) multipleBooks;
    }
    
    struct multipleBookDetails{
        uint bookId;
        uint ISDN;
        address bookLibrarianArray;
        address memberAddress;
        uint dateAddedBook;
        bool bookAvailable;
    }
    
    struct bookTaken{
        uint bookId;
        uint ISDN;
        uint dateIssued;
        uint dateReturn;
        uint duration;
        uint rate;
        string bookIssueJson;
        string bookReturnJson;
        string bookDurationJson;
        string bookRateJson;
        bool bookStatus;
    }
    
    struct member{
        string memberName;
        address memberAccount;
        string email;
        uint dateAddedMember;
        uint [] memberBookId;
        mapping(uint => uint) memberAllBook;
        mapping(uint => bookTaken) memberBookTaken;
    }
    
    struct librarian{
        address librarianAddress;
        string librarianName;
    }
    
    
    event errorLog(string _errorLog);
    event addBookEvent(uint ISDN, string title, string author, string publisher, uint totalNumberofBook,
        uint numberofAvailableBooks,
        uint bookAdded);
    event allbookdata(uint ISDN,
        string title,
        string author,
        string publisher,
        uint totalNumberofBook,
        uint numberofAvailableBooks,
        uint bookAdded,
        uint [] bookStack
        );
    event bookMulti(uint bookId,
        uint ISDN,
        address bookLibrarianArray,
        address memberAddress,
        uint dateAddedBook,
        bool bookAvailable);
    event bookStackArray(uint _stack);
    
    event bookMember(address _add, uint bookId,
        uint ISDN,
        uint dateIssued,
        uint dateReturn,
        uint duration,
        uint rate,
        string bookIssueJson,
        string bookReturnJson,
        string bookDurationJson,
        string bookRateJson);
    
    string a;
    mapping(uint => book) public bookDetails;
    mapping(address => member) public memberDetails;
    mapping(address => librarian) public librarianDetails;
    
    

    function LMS() public {
        owner = msg.sender;
    }
    
    function addBook(uint _ISDN,string _title, string _author,string _publisher, uint _totalNumberofBook) public{
        if(bookDetails[_ISDN].ISDN == _ISDN){
            emit errorLog("This ISDN book is already exist!");
        }
        else{
            bookDetails[_ISDN].ISDN = _ISDN;
            bookDetails[_ISDN].title = _title;
            bookDetails[_ISDN].author = _author;
            bookDetails[_ISDN].publisher = _publisher;
            bookDetails[_ISDN].totalNumberofBook = _totalNumberofBook;
            bookDetails[_ISDN].numberofAvailableBooks = 0;
            bookDetails[_ISDN].bookAdded = 0;
            
			addBookEventCnt++;
			
            emit addBookEvent(_ISDN, _title, _author, _publisher, _totalNumberofBook, bookDetails[_ISDN].numberofAvailableBooks,bookDetails[_ISDN].bookAdded);
        }
    }
    
    
    function addMultipleBook(address _librarianAddress, uint _bookId, uint _ISDN) public{
        
        if(librarianDetails[_librarianAddress].librarianAddress==_librarianAddress)
        {
            if(bookDetails[_ISDN].multipleBooks[_bookId].bookId == _bookId){
                emit errorLog("This Book ID is already exist!");
            }
            else{
                    if(bookDetails[_ISDN].totalNumberofBook == bookDetails[_ISDN].bookAdded)
                    {
                        emit errorLog("You can not add book more then available stock!");
                    }
                    else
                    {
                        
                        bookDetails[_ISDN].numberofAvailableBooks = bookDetails[_ISDN].numberofAvailableBooks + 1;
                        bookDetails[_ISDN].bookAdded = bookDetails[_ISDN].bookAdded + 1;
                        
                        bookDetails[_ISDN].bookStack.push(_bookId) - 1;
                        
                        bookDetails[_ISDN].multipleBooks[_bookId].bookId = _bookId;
                        bookDetails[_ISDN].multipleBooks[_bookId].ISDN = _ISDN;
                        bookDetails[_ISDN].multipleBooks[_bookId].bookLibrarianArray = _librarianAddress;
                        bookDetails[_ISDN].multipleBooks[_bookId].memberAddress = 0x00;
                        bookDetails[_ISDN].multipleBooks[_bookId].dateAddedBook = now;
                        bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable = true;
        
                    }
                
                }
        }
        else
        {
            emit errorLog("You are not permissioned librarian!");
        }
    }
    
    function addStockofBook(uint _ISDN, uint _stock) public {
        if(bookDetails[_ISDN].ISDN == _ISDN){
            bookDetails[_ISDN].totalNumberofBook = bookDetails[_ISDN].totalNumberofBook + _stock;
        }
        else{
            emit errorLog("This ISDN book number is not exist!");
        }
    }
    
    
    function addLibrarian(address _librarianAddress, string _name) public{
            librarianDetails[_librarianAddress] = librarian(_librarianAddress,_name);
        
    }
    
   
    function addMember(string _memberName, address _memberAccount, string _email) public{
        
		if(memberDetails[_memberAccount].memberAccount == _memberAccount){
            emit errorLog("This Member ID is already exist!");
        }
        else{
            memberDetails[_memberAccount].memberName = _memberName;
            memberDetails[_memberAccount].memberAccount = _memberAccount;
            memberDetails[_memberAccount].email = _email;
            memberDetails[_memberAccount].dateAddedMember = now;
            
        }
            
        
    }
    
    function nextBookAvailable(uint _ISDN) public view returns(uint){
        return (bookDetails[_ISDN].bookStack[0]);
    }
    
    function issueBook(address _memberAddress, uint _ISDN) public{
        
        uint _bookId = bookDetails[_ISDN].bookStack[0];
        
        if(memberDetails[_memberAddress].memberAccount == _memberAddress){
            if(bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable == true){
                
                bookDetails[_ISDN].multipleBooks[_bookId].memberAddress = _memberAddress;
                bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable = false;
                bookDetails[_ISDN].numberofAvailableBooks -= 1;
                
                uint len = bookDetails[_ISDN].bookStack.length-1;
                
                 for (uint i = 0; i<len; i++){
                    bookDetails[_ISDN].bookStack[i] = bookDetails[_ISDN].bookStack[i+1];
                }
                delete bookDetails[_ISDN].bookStack[len];
                bookDetails[_ISDN].bookStack.length--;
        
                memberDetails[_memberAddress].memberBookTaken[_bookId].bookId = _bookId;
                memberDetails[_memberAddress].memberBookTaken[_bookId].ISDN = _ISDN;
                memberDetails[_memberAddress].memberBookTaken[_bookId].dateIssued = now;
                memberDetails[_memberAddress].memberBookTaken[_bookId].bookStatus = false;
                
                if(memberDetails[_memberAddress].memberAllBook[_bookId] > 0)
                {
                    memberDetails[_memberAddress].memberBookId.push(_bookId) - 1;
                    
                    memberDetails[_memberAddress].memberAllBook[_bookId] += 1;
                }
                else
                {
                    emit errorLog("This Book ID is already in array!");
                }
               
            }
            else{
                emit errorLog("Book is Not Available!");
            }
        }
        else{
            emit errorLog("This Member ID is not registerd!");
        }
    }
    
    
    function returnBook(address _memberAddress, uint _bookId, uint _ISDN) public{
        if(bookDetails[_ISDN].multipleBooks[_bookId].memberAddress == _memberAddress){
            
            if(bookDetails[_ISDN].multipleBooks[_bookId].bookId == _bookId){
                
                if(bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable == false )
                {    
                    
                    bookDetails[_ISDN].bookStack.push(_bookId) - 1;
                    
                    bookDetails[_ISDN].numberofAvailableBooks += 1;
                    
                    bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable = true;
                    
                    memberDetails[_memberAddress].memberBookTaken[_bookId].bookStatus = true;
                    
                    memberDetails[_memberAddress].memberBookTaken[_bookId].dateReturn = now;
                    
                    issuedate = memberDetails[_memberAddress].memberBookTaken[_bookId].dateIssued;
                    
                    timeDuration = now - issuedate ;
                    
                    memberDetails[_memberAddress].memberBookTaken[_bookId].duration = timeDuration;
                    
                    memberDetails[_memberAddress].memberBookTaken[_bookId].rate = timeDuration / 10;
                    
                    //var parts = new strings.slice[](1);
                    
                    var new_issue_date = uint2str(issuedate);
                    var appendComma = ",";
                    var result = concatTwoString(memberDetails[_memberAddress].memberBookTaken[_bookId].bookIssueJson, new_issue_date, appendComma);
                    memberDetails[_memberAddress].memberBookTaken[_bookId].bookIssueJson = string(result);
                    
                    var new_reurn_book = uint2str(memberDetails[_memberAddress].memberBookTaken[_bookId].dateReturn);
                    var result1 = concatTwoString(memberDetails[_memberAddress].memberBookTaken[_bookId].bookReturnJson, new_reurn_book , appendComma);
                    memberDetails[_memberAddress].memberBookTaken[_bookId].bookReturnJson = string(result1);
                    
                    var bookDurationJson1 = uint2str(memberDetails[_memberAddress].memberBookTaken[_bookId].duration);
                    var result2 = concatTwoString(memberDetails[_memberAddress].memberBookTaken[_bookId].bookDurationJson, bookDurationJson1 , appendComma);
                    memberDetails[_memberAddress].memberBookTaken[_bookId].bookDurationJson = string(result2);
                    
                    var bookDurationJson2 = uint2str(memberDetails[_memberAddress].memberBookTaken[_bookId].rate);
                    var result3 = concatTwoString(memberDetails[_memberAddress].memberBookTaken[_bookId].bookRateJson, bookDurationJson1 , appendComma);
                    memberDetails[_memberAddress].memberBookTaken[_bookId].bookRateJson = string(result3);
                    
                }
                else
                {
                    emit errorLog("You have already returned this book!");
                }
            }
           else{
               emit errorLog("This Book is not belong to this user!");
           }
        }
        else{
            emit errorLog("This Member ID is not registerd!");
        }
    }
    //GET ALL BOOK DATA

    function getBookAll(uint _ISDN) public {
        
        emit allbookdata(bookDetails[_ISDN].ISDN,
            bookDetails[_ISDN].title,
            bookDetails[_ISDN].author,
            bookDetails[_ISDN].publisher,
            bookDetails[_ISDN].totalNumberofBook,
            bookDetails[_ISDN].numberofAvailableBooks,
            bookDetails[_ISDN].bookAdded,
            bookDetails[_ISDN].bookStack);
    }
    
    function getMultiBookData(uint _ISDN, uint _bookId) public{
        
       emit bookMulti(bookDetails[_ISDN].multipleBooks[_bookId].bookId,
            bookDetails[_ISDN].multipleBooks[_bookId].ISDN,
            bookDetails[_ISDN].multipleBooks[_bookId].bookLibrarianArray,
            bookDetails[_ISDN].multipleBooks[_bookId].memberAddress,
            bookDetails[_ISDN].multipleBooks[_bookId].dateAddedBook,
            bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable);
    }

    function getBookData(uint _ISDN) public view returns(uint,
        string,
        string,
        string,
        uint,
        uint)
    {
        return(bookDetails[_ISDN].ISDN,
            bookDetails[_ISDN].title,
            bookDetails[_ISDN].author,
            bookDetails[_ISDN].publisher,
            bookDetails[_ISDN].totalNumberofBook,
            bookDetails[_ISDN].numberofAvailableBooks
            );
    }
    
    function getMultiBook(uint _ISDN, uint _bookId) public view returns(uint, uint, address, address, uint, bool){
        return(bookDetails[_ISDN].multipleBooks[_bookId].bookId,
            bookDetails[_ISDN].multipleBooks[_bookId].ISDN,
            bookDetails[_ISDN].multipleBooks[_bookId].bookLibrarianArray,
            bookDetails[_ISDN].multipleBooks[_bookId].memberAddress,
            bookDetails[_ISDN].multipleBooks[_bookId].dateAddedBook,
            bookDetails[_ISDN].multipleBooks[_bookId].bookAvailable);
    }
    
    function getBookArray(uint _ISDN) public view returns(uint []){
        return (bookDetails[_ISDN].bookStack);
    }
    
    // GET ALL MEMBER DATA 
    
    function getAllMemberBook(address _memberAdd, uint _bookId) public {
       
        emit bookMember(_memberAdd, 
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookId,
        memberDetails[_memberAdd].memberBookTaken[_bookId].ISDN,
        memberDetails[_memberAdd].memberBookTaken[_bookId].dateIssued,
        memberDetails[_memberAdd].memberBookTaken[_bookId].dateReturn, 
        memberDetails[_memberAdd].memberBookTaken[_bookId].duration,
        memberDetails[_memberAdd].memberBookTaken[_bookId].rate,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookIssueJson,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookReturnJson,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookDurationJson,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookRateJson);
    }
    
    function getMemberBookData(uint _ISDN, uint _bookId) public view returns(address, address, uint, uint, uint, uint){
      
        address memberAdd = bookDetails[_ISDN].multipleBooks[_bookId].memberAddress;
        
        return (bookDetails[_ISDN].multipleBooks[_bookId].bookLibrarianArray,
        memberAdd, 
        memberDetails[memberAdd].memberBookTaken[_bookId].dateIssued,
        memberDetails[memberAdd].memberBookTaken[_bookId].dateReturn, 
        memberDetails[memberAdd].memberBookTaken[_bookId].duration,
        memberDetails[memberAdd].memberBookTaken[_bookId].rate);
        
        getJsonData(_bookId, memberAdd);
    }
    
    
    function getJsonData(uint _bookId, address _memberAdd) public view returns(string, string, string, string){
        return (memberDetails[_memberAdd].memberBookTaken[_bookId].bookIssueJson,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookReturnJson,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookDurationJson,
        memberDetails[_memberAdd].memberBookTaken[_bookId].bookRateJson);
    }
    
    function getMemberBookArr(address _memberAddress) public view returns(address, string, string, uint, uint []){
        return(memberDetails[_memberAddress].memberAccount,
            memberDetails[_memberAddress].memberName,
            memberDetails[_memberAddress].email,
            memberDetails[_memberAddress].dateAddedMember,
            memberDetails[_memberAddress].memberBookId);
    }
    
    function concatTwoString(string old_issue_date,string new_issue_date, string appendComma) pure private returns(bytes){
		bytes memory ba = bytes(old_issue_date);
		bytes memory bb = bytes(new_issue_date);
		bytes memory cc = bytes(appendComma);

		string memory abcde = new string(ba.length + cc.length + bb.length );
		bytes memory babcde = bytes(abcde);
		uint k = 0;
		for (uint i = 0; i < ba.length; i++) babcde[k++] = ba[i];
		for (i = 0; i < cc.length; i++) babcde[k++] = cc[i];
		for (i = 0; i < bb.length; i++) babcde[k++] = bb[i];
		return (babcde);
	}
	
	function uint2str(uint i) private pure returns (string){
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory  bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
}