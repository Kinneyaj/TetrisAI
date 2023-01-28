/// @description

falling = true;

fallTimer = 0;

moveDelay = 10;
moveTimer = moveDelay;

bWidth = 10;
bHeight = 22;

startx = (window_get_width()/2) - ((bWidth*sprite_get_width(spSquare))/2);
starty = (window_get_height()/2) - ((bHeight*sprite_get_height(spSquare))/2);

emptyClr = c_dkgray;

movedir = 0;

numPoints = 0;
level = 1;

linesCleared = 0;

stateMap = ds_map_create();

rotTarget = 0;
xTarget = 0;

//initialize board
for(var i = 0; i < bWidth; i++){
	for(var j = 0; j < bHeight; j++){
		board[i][j] = {fill:false, clr:emptyClr};
	}
}

qSize = 6;
pieceQ = ds_list_create();
for(var i = 0; i < qSize; i++){
	var r = floor(random(array_length(global.pieces)))
	ds_list_add(pieceQ, global.pieces[r]);
}


orderReceived = false;

//initialize first piece
initCommandFile();
initStateFile();
initNextPiece();
outputGameState();

