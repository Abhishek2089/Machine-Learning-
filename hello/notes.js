console.log("starting node.js");

const fs = require('fs');

var fetchNotes = () {
	try {
	 var noteString = fs.readFileSync('notes-data');

	 return notes = JSON.parse(noteString);
	} catch (e) {

		return [];
	}
}

var saveNotes = (notes) {

	fs.writeFileSynce('notes-data.json', JSON.stringify(notes));

}

var addNote = (title, body) => {
	var notes = fetchNotes();
	var note = {
		title,
		body,
	};

	var duplicateNotes = notes.filter((note) => note.title === title);

    if (duplicateNotes.length === 0) {
    	notes.push(note);
    	saveNotes(notes);
    	return note;
    }
	
};

var getAll = () => {
	console.log('Getting all notes');
};

var getNote = () => {
	console.log('Getting note', title);
};

var removeNote = (title) => {
	//fetch notes

	var notes = fetchNotes();

	//filter 

	var remove = notes.filter((note) => note.title !== title);

	saveNotes(remove);
};


module.export = {
	addNote,
	getAll,
	getNote,
	removeNote,
};