console.log("Starting app.js");

const fs = require('fs');
const os = require('os');
const _ = require('lodash');
const yargs = require('yargs');
const notes = require('./notes.js');


const argv = yargs.argv;
var command = argv._[0];
console.log('Command: ', command);


console.log(process.argv);



if(command === 'add') {

	var note = notes.addNote(argv.title, argv.body);

	if(note)  {
		console.log('Note created');
		console.log('--');
		console.log(`Title: ${note.title}`);
		console.log(`Body: ${note.body}`);
	} else {
		console.log('Note title taken')
	}

} else if (command === 'list') {

	notes.getAll();
} 
else if (command === 'read') {

	notes.geNote(argv.title);
} 
else if (command === 'remove') {

	notes.removeNote(argv.title);
} 
else {
	console.log('command not recognise');
}



// var res = notes.add(2,6);
// console.log(res);

// var user = os.userInfo();

// fs.appendFile('greeting.txt', `Hello ${user.username}! You are ${notes.age}`, function(err) {
// 	if(err) {
// 		console.log('Unable to write file');
// 	}
// }); 