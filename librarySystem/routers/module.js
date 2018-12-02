var libraryModule = require('./configuration.js');
//var db = require('../Database/db.js');
var express = require('express');
var Web3 =require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider ("http://localhost:8545"));

var librarySystem = libraryModule.librarySystem;
//var Web3 = libraryModule.web3Module;
var listAccount = web3.eth.accounts;


//var data1 = "";
//var temp = "";
//var teacherID = "";


/*
	Librarian data entry
*/

exports.addLibrarianGet = function(req,res){
	
	console.log(listAccount);
	res.render('addLibrarian', {page_title:"librarian details",data:listAccount});
	
};


exports.addLibrarian = function(req,res){
	
	res.render('addLibrarian', {page_title:"librarian details",data:listAccount});

	var librarianAddress = req.body.librarianAddress;
	var librarianName = req.body.librarianName;
	
	var bodyParser = require('body-parser');
	
	console.log(librarianAddress, librarianName);

	librarySystem.addLibrarian(librarianAddress, librarianName,{gas:400000});
};

/*
		get event of librarian
	
*/

exports.viewBookget = function(req,res){
	
	var eventbook = librarySystem.addBookEvent({_from:web3.eth.coinbase},{fromBlock:0, toBlock :'latest'});
	var cnt = 0;
	var x = "";
	
	
	
	var finalstr;
	
	eventbook.watch( function(error, result)
	{
		var z = librarySystem.addBookEventCnt();
		
		console.log(parseInt(z.toString()));
		
		cnt++;
		
		if(cnt < parseInt(z.toString()))
		{
			x = x + '{' + '"ISDN":' + parseInt(result.args.ISDN.toString()) + ',' + 
					'"title":' + '"' +result.args.title + '"' + ',' +
					'"author":' + '"' +result.args.author + '"' + ',' +
					'"publisher":' + '"' +result.args.publisher+ '"' + ',' +
					'"totalNumberofBook":' + parseInt(result.args.totalNumberofBook.toString()) + ',' +
					'"numberofAvailableBooks":' + parseInt(result.args.numberofAvailableBooks.toString())+ ',' +
					'"bookAdded":' + parseInt(result.args.bookAdded.toString()) +
				'}' + ',';
		}
		
		else
		{
			x = x + '{' + '"ISDN":' + parseInt(result.args.ISDN.toString()) + ',' + 
					'"title":' + '"' +result.args.title + '"' + ',' +
					'"author":' + '"' +result.args.author + '"' + ',' +
					'"publisher":' + '"' +result.args.publisher+ '"' + ',' +
					'"totalNumberofBook":' + parseInt(result.args.totalNumberofBook.toString()) + ',' +
					'"numberofAvailableBooks":' + parseInt(result.args.numberofAvailableBooks.toString())+ ',' +
					'"bookAdded":' + parseInt(result.args.bookAdded.toString()) +
				'}';
			
			finalstr = '[' + x + ']';
			finalstr = JSON.parse(finalstr);
			console.log(finalstr);
			console.log(finalstr.length);
			
			res.render('viewlib', {page_title:"librarian details",data:finalstr});
		}		
	}
	);
	
	
	
	
	
};



/* 
	add member/student details
	
*/

exports.addMemberGet = function(req,res){
	
	res.render('addMember', {page_title:"Teacher details",data:listAccount});

	
};


exports.addMemberPost = function(req,res){
	
	res.render('addMember', {page_title:"Teacher details",data:listAccount});
	
	var bodyParser = require('body-parser');
	var memberName = req.body.memberName;
	var memberAccount = req.body.memberAccount;
	var memberEmail = req.body.email;

	console.log(memberAccount,memberName, memberEmail);

	librarySystem.addMember(memberName, memberAccount, memberEmail,{gas:400000});
};

exports.issueBookGet = function(req,res){
	
	res.render('issueBook', {page_title:"Member Issue Book details",data:listAccount});

	
};


exports.issueBookPost = function(req,res){
	
	res.render('issueBook', {page_title:"Member Issue Book details",data:listAccount});
	

	
	var bodyParser = require('body-parser');

	var memberAccount = req.body.memberAccount;
	var ISDN = req.body.ISDN;

	console.log(memberAccount, ISDN);

	librarySystem.addMember(memberAccount, ISDN,{gas:400000});
};

exports.returnBookGet = function(req,res){
	
	res.render('returnBook', {page_title:"Member Return Book details",data:listAccount});

	
};


exports.returnBookPost = function(req,res){
	
	res.render('returnBook', {page_title:"Member Return Book details",data:listAccount});
	

	
	var bodyParser = require('body-parser');

	var memberAccount = req.body.memberAccount;
	var bookid = req.body.bookid;
	var ISDN = req.body.ISDN;

	console.log(memberAccount, ISDN, bookid);

	librarySystem.addMember(memberAccount, bookid, ISDN,{gas:400000});
};


/* 
	add BOOK details
	
*/

exports.addBookGet = function(req,res){
	
	res.render('addBook', {page_title:"Book details"});
	
};


exports.addBookPost = function(req,res){
	
	res.render('addBook', {page_title:"Book details"});
	
	var bodyParser = require('body-parser');
	
	var ISDN = req.body.ISDN; 
	var title = req.body.title;
	var author = req.body.author;
	var publisher = req.body.publisher;
	var totalNumberofBook = req.body.qty;

	console.log(ISDN, title, author, publisher, totalNumberofBook);

	librarySystem.addBook( ISDN, title, author, publisher, totalNumberofBook,{gas:400000});
};

exports.addMultipleBookGet = function(req,res){
	
	res.render('addMultipleBook', {page_title:"Add Books ",data:listAccount});
	
};


exports.addMultipleBookPost = function(req,res){
	
	res.render('addMultipleBook', {page_title:"Add Books ",data:listAccount});
	
	var bodyParser = require('body-parser');
	
	var librarianAddress = req.body.librarianAccount;
	var ISDN = req.body.ISDN; 
	var Bookid = req.body.Bookid;
	

	console.log(ISDN, librarianAddress, Bookid);

	librarySystem.addMultipleBook( librarianAddress, Bookid, ISDN,{gas:400000});
};

exports.addStockGet = function(req,res){
	
	res.render('addStockBook', {page_title:"Add Books Stock"});
	
};

exports.addStockPost = function(req,res){
	
	res.render('addStockBook', {page_title:"Add Books Stock"});
	
	var bodyParser = require('body-parser');
	
	var ISDN = req.body.ISDN; 
	var stock = req.body.stock;

	console.log(ISDN, stock);

	librarySystem.addMultipleBook( ISDN, stock,{gas:400000});
};


/*
exports.addMarks = function(req,res){
	
	res.render('teacherMarks', {page_title:"student Marks",data:teacherID});	
}

exports.addStudMarks = function(req,res){
	
	res.render('teacherMarks', {page_title:"student Marks",data:teacherID});

	//var teacherId = req.body.TeacherId;
	var studentId = req.body.studentId;
	var marks = req.body.marks;

	
	var bodyParser = require('body-parser');
	
	console.log(teacherID, studentId, marks);
	console.log(data1);
	
	studentResult.addMarks(teacherID, studentId, marks,{gas:400000});
};




exports.grades = function(req,res){

	res.render('grades', {page_title:"student final grades"});	
}

exports.gradesfinal = function(req,res){
	
	//res.render('grades', {page_title:"student final grades"});

	var studentId = req.body.studentId;

	
	var bodyParser = require('body-parser');
	
	studentResult.grade(studentId,{gas:400000});
	
	//res.setHeader('Content-Type','text/plain');
	res.redirect('/studentDataTable');
	
	data1 = studentResult.studentData(studentId).toString();
	data1=data1.split(',');
	console.log(data1);
		
};


exports.studentDataTable = function(req,res){

	res.render('studentDataTable', {page_title:"student final grades",data:data1});	
}


exports.teacherIdCheck = function(req,res) {
  teacherID = req.body.teacherID;
  console.log(teacherID);
  
  var t_id = studentResult.teacherData(teacherID).toString();
	
	t_id=t_id.split(',');
	
	console.log(t_id);
  
   if (t_id[0]==teacherID)
   {
	  //res.redirect('/teacherMarks');
		res.render('teacherMarks', {page_title:"student Marks",data:teacherID});

		//var teacherId = req.body.TeacherId;
		var studentId = req.body.studentId;
		var marks = req.body.marks;

		
		var bodyParser = require('body-parser');
		
		console.log(teacherID, studentId, marks);
		//console.log(data1);
		
		studentResult.addMarks(teacherID, studentId, marks,{gas:400000});
   }
	else
	{
		res.redirect('/error');
	}
}
*/