
function checkShapeInBounds(i){
	if(activePiece.ypos + activePiece.shape[i].ypos >= 0 
	&& activePiece.ypos + activePiece.shape[i].ypos < bHeight
	&& activePiece.xpos + activePiece.shape[i].xpos >= 0
	&& activePiece.xpos + activePiece.shape[i].xpos < bWidth){
		return true;
	}
	return false;
}

function checkShapeFill(p){
	for(var i = 0; i < array_length(p.shape); i++){
		var _x = p.xpos + p.shape[i].xpos;
		var _y = p.ypos + p.shape[i].ypos;
		if(checkPointInBounds(_x, _y) && board[_x][_y].fill){
			return true;
		}
	}
	return false;
}

function checkPointInBounds(_x, _y){
	if(_y >= 0 && _y < bHeight && _x >= 0 && _x < bWidth){
		return true;
	}
	return false;
}

function checkPieceInBounds(p){
	//for(var i = 0; i < array_length(p.shape); i++){
	//	if(p.ypos + p.shape[i].ypos >= 0 
	//	&& p.ypos + p.shape[i].ypos < bHeight
	//	&& p.xpos + p.shape[i].xpos >= 0
	//	&& p.xpos + p.shape[i].xpos < bWidth){
	//		return true;
	//	}
	//	return false;
	//}
	for(var i = 0; i < array_length(p.shape); i++){
		if(p.ypos + p.shape[i].ypos < 0 
		|| p.ypos + p.shape[i].ypos >= bHeight
		|| p.xpos + p.shape[i].xpos < 0
		|| p.xpos + p.shape[i].xpos >= bWidth){
			return false;
		}
	}
	return true;
}

function clearShapeColor(){
	for(var i = 0; i < array_length(activePiece.shape); i++){
		if(checkShapeInBounds(i)){
			var _x = activePiece.xpos + activePiece.shape[i].xpos;
			var _y = activePiece.ypos + activePiece.shape[i].ypos;
			board[_x][_y].clr = emptyClr;
		}
	}
}

function fillShapeColor(){
	for(var i = 0; i < array_length(activePiece.shape); i++){
		if(checkShapeInBounds(i)){
			var _x = activePiece.xpos + activePiece.shape[i].xpos;
			var _y = activePiece.ypos + activePiece.shape[i].ypos;
			board[_x][_y].clr = activePiece.clr;
		}
	}
}

function initNextPiece(){
	//pull next piece from queue
	activePiece = instance_create_layer(0, 0, "Instances", pieceQ[|0]);
	ds_list_delete(pieceQ, 0);
	activePiece.xpos = floor(bWidth/2)-2;
	activePiece.ypos = 0;
	activePieceType = activePiece.pType;
	//replace piece in queue
	if(checkShapeFill(activePiece)){
		return false;
	}
	ds_list_add(pieceQ, global.pieces[floor(random(array_length(global.pieces)))]);
	return true;
}

function checkPieceCollisionY(){
	for(var i = 0; i < array_length(activePiece.shape); i++){
		var indBelow = activePiece.ypos + activePiece.shape[i].ypos + 1;
		var _x = activePiece.xpos + activePiece.shape[i].xpos;
		if(checkShapeInBounds(i) && (indBelow >= bHeight || board[_x][indBelow].fill)){
			return true;
		}
	}
	return false;
}

function checkPieceCollisionX(){
	for(var i = 0; i < array_length(activePiece.shape); i++){
		var _y = activePiece.ypos + activePiece.shape[i].ypos;
		var _x = activePiece.xpos + activePiece.shape[i].xpos;
		var indSide = _x + movedir;
		//screen bounds check
		if(!checkPointInBounds(indSide, _y)){
			return true;
		}
		//filled space check
		if(board[indSide][_y].fill){
			return true;
		}
	}
	return false;
}

function lockPiece(){
	for(var i = 0; i < array_length(activePiece.shape); i++){
		var _x = activePiece.xpos + activePiece.shape[i].xpos;
		var _y = activePiece.ypos + activePiece.shape[i].ypos;
		board[_x][_y].fill = true;
	}
	instance_destroy(activePiece);
	activePiece = noone;
}

function validateXPosition(){
	for(var i = 0; i < array_length(activePiece.shape); i++){
		//handle screen bounds
		while(!checkShapeInBounds(i)){
			var _x = activePiece.xpos + activePiece.shape[i].xpos;
			var _y = activePiece.ypos + activePiece.shape[i].ypos;
			activePiece.xpos = _x < 0 ? activePiece.xpos + 1 : activePiece.xpos - 1;
			activePiece.ypos = _y < 0 ? activePiece.ypos + 1 : activePiece.ypos - 1;
		}
		//handle collision with filled spaces

	}
}

function validateYPosition(p){
	for(var i = 0; i < array_length(p.shape); i++){
		while(!checkPieceInBounds(p)){
			p.ypos++;
		}
	}
}

function validatePieceXPosition(p){
	for(var i = 0; i < array_length(p.shape); i++){
		while(!checkPieceInBounds(p)){
			p.xpos++;
		}
	}
}

function drawQueue(){
	
}

function getCollisionPointX(p){
	for(var i = 0; i < array_length(p.shape); i++){
		var _x = p.xpos + p.shape[i].xpos;
		var _y = p.ypos + p.shape[i].ypos;
		if(!checkPointInBounds(_x, _y) || board[_x][_y].fill){
			return p.shape[i].xpos;
		}
	}
	return -1;
}

function makeTempPiece(){
	var tempPiece = instance_create_layer(x, y, "Instances", activePiece.object_index);
	tempPiece.xpos = activePiece.xpos;
	tempPiece.ypos = activePiece.ypos;
	tempPiece.rot = activePiece.rot;
	for(var i = 0; i < array_length(activePiece.shape); i++){
		tempPiece.shape[i].xpos = activePiece.shape[i].xpos;
		tempPiece.shape[i].ypos = activePiece.shape[i].ypos;
	}
	
	return tempPiece;
}

function tryRotation(tempPiece){
	
	var canRotate = true;
	var canShift = false;
	
	//check if rotation is possible
	for(var i = 0; i < array_length(tempPiece.shape); i++){
		var _x = tempPiece.xpos + tempPiece.shape[i].xpos;
		var _y = tempPiece.ypos + tempPiece.shape[i].ypos;
		if(!checkPointInBounds(_x, _y) || board[_x][_y].fill){
			canRotate = false;
			break;
		}
	}
	
	//if rotation not possible, check if shift is possible
	if(!canRotate){
		//find collision point
		var xPt = getCollisionPointX(tempPiece);
		show_debug_message(xPt);
		if(xPt > -1 && xPt <= 1){//right shift
			while((!checkPieceInBounds(tempPiece) || checkShapeFill(tempPiece)) && checkPointInBounds(tempPiece.xpos, tempPiece.ypos)){
				if(tempPiece.rot == 0 || tempPiece.rot == 1){
					tempPiece.xpos++;
				}else{
					tempPiece.xpos--;
				}
			}
		}else if(xPt > 1){//left shift
			while((!checkPieceInBounds(tempPiece) || checkShapeFill(tempPiece)) && checkPointInBounds(tempPiece.xpos, tempPiece.ypos)){
				if(tempPiece.rot == 0 || tempPiece.rot == 1){
					tempPiece.xpos--;
				}else{
					tempPiece.xpos++;
				}
			}
		}
		if(checkPieceInBounds(tempPiece) && !checkShapeFill(tempPiece)){
			canShift = true;
		}
	}
	
	//if shift is not possible, cancel rotation
	if(!canRotate && !canShift){
		instance_destroy(tempPiece);
	}else{
		//commit rotation
		activePiece.xpos = tempPiece.xpos;
		activePiece.ypos = tempPiece.ypos;
		activePiece.rot = tempPiece.rot;
		for(var i = 0; i < array_length(activePiece.shape); i++){
			activePiece.shape[i].xpos = tempPiece.shape[i].xpos;
			activePiece.shape[i].ypos = tempPiece.shape[i].ypos;
		}
		instance_destroy(tempPiece);
	}
}

function rotateLeft(){
	
	//perform rotation on temporary piece to check validity
	var tempPiece = makeTempPiece();
	
	for(var i = 0; i < array_length(tempPiece.shape); i++){
		var temp = tempPiece.shape[i].xpos;
		tempPiece.shape[i].xpos = tempPiece.shape[i].ypos;
		tempPiece.shape[i].ypos = -temp;
	}
	
	switch(tempPiece.rot){
		case 0:
			//xpos++;
			tempPiece.ypos += 2;
			tempPiece.rot = 3;
			break;
		case 1:
			tempPiece.xpos -= 2;
			tempPiece.rot--;
			break;
		case 2:
			tempPiece.ypos -= 2;
			tempPiece.rot--;
			break;
		case 3:
			tempPiece.xpos += 2;
			tempPiece.rot--;
			break;
		default:
			//
			break;
	}
	
	tryRotation(tempPiece);
	
}

function rotatePieceLeft(piece){
	
	for(var i = 0; i < array_length(piece.shape); i++){
		var temp = piece.shape[i].xpos;
		piece.shape[i].xpos = piece.shape[i].ypos;
		piece.shape[i].ypos = -temp;
	}
	
	switch(piece.rot){
		case 0:
			//xpos++;
			piece.ypos += 2;
			piece.rot = 3;
			break;
		case 1:
			piece.xpos -= 2;
			piece.rot--;
			break;
		case 2:
			piece.ypos -= 2;
			piece.rot--;
			break;
		case 3:
			piece.xpos += 2;
			piece.rot--;
			break;
		default:
			//
			break;
	}

}

function rotateRight(){
	
	var tempPiece = makeTempPiece();
	
	for(var i = 0; i < array_length(tempPiece.shape); i++){
		var temp = tempPiece.shape[i].xpos;
		tempPiece.shape[i].xpos = -tempPiece.shape[i].ypos;
		tempPiece.shape[i].ypos = temp;
	}
	
	switch(tempPiece.rot){
		case 0:
			tempPiece.xpos += 2;
			tempPiece.rot++;
			break;
		case 1:
			tempPiece.ypos += 2;
			tempPiece.rot++;
			break;
		case 2:
			tempPiece.xpos -= 2;
			tempPiece.rot++;
			break;
		case 3:
			tempPiece.ypos -= 2;
			tempPiece.rot = 0;
			break;
		default:
		
			break;
	}
	
	tryRotation(tempPiece);
	
}

function rotatePieceRight(piece){

	for(var i = 0; i < array_length(piece.shape); i++){
		var temp = piece.shape[i].xpos;
		piece.shape[i].xpos = -piece.shape[i].ypos;
		piece.shape[i].ypos = temp;
	}
	
	switch(piece.rot){
		case 0:
			piece.xpos += 2;
			piece.rot++;
			break;
		case 1:
			piece.ypos += 2;
			piece.rot++;
			break;
		case 2:
			piece.xpos -= 2;
			piece.rot++;
			break;
		case 3:
			piece.ypos -= 2;
			piece.rot = 0;
			break;
		default:
		
			break;
	}
}

function shiftRows(row){
	for(var i = row; i > 0; i--){
		for(var j = 0; j < bWidth; j++){
			//shift down
			board[j][i].clr = board[j][i-1].clr;
			board[j][i].fill = board[j][i-1].fill;
		}
	}
}

function checkRowClear(){
	for(var i = 0; i < bHeight; i++){
		var canClear = true;
		for(var j = 0; j < bWidth; j++){
			//check row
			if(!board[j][i].fill){
				canClear = false;
			}
		}
		if(canClear){
			//clear row and shift down
			shiftRows(i);
			numPoints += 100 * level;
			linesCleared++;
			if(linesCleared % 10 == 0){
				level++;
			}
		}
	}
}

function fixPosY(piece){
	while(!checkShapeFill(piece) && checkPieceInBounds(piece)){
		piece.ypos++;
	}
	piece.ypos--;
}

function pointInPiece(piece, _x, _y){
	for(var i = 0; i < array_length(piece.shape); i++){
		if(_x == piece.xpos + piece.shape[i].xpos && _y == piece.ypos + piece.shape[i].ypos){
			return true;
		}
	}
	return false;
}

function buildStateString(piece){
	var stateString = "";
	for(var i = 0; i < bHeight; i++){
		for(var j = 0; j < bWidth; j++){
			if(board[j][i].fill || pointInPiece(piece, j, i)){
				stateString += "1";
			}else{
				stateString += "0";
			}
		}
		stateString += "\n";
	}
	return stateString;
}

function addStateToMap(tp, count){
	fixPosY(tp);
	stateMap[? string(count)] = {
		stateString : buildStateString(tp), 
		rotation : tp.rot, 
		xposition : tp.xpos
	};
	tp.ypos = 0;
	validateYPosition(tp);
	tp.xpos++;
}

function generateStates(){
	var s = activePiece.pType
	var tp = makeTempPiece();
	var count = 0;
	if(s == "i"){
		//2 possible rotations
            //vertical: 10 possible positions
            //horizontal: 7 possible positions
        //vertical states
		rotatePieceRight(tp);
		validateYPosition(tp);
		tp.xpos = 0;
		validatePieceXPosition(tp);
		for(var i = 0; i < 10; i++){
			addStateToMap(tp, count);
			count++;
		}
		//horizontal
		instance_destroy(tp);
		tp = makeTempPiece();
		tp.xpos = 0;
		for(var i = 0; i < 7; i++){
			addStateToMap(tp, count);
			count++;
		}
	}else if(s == "j" || s == "l" || s == "t"){
		//4 possible rotations
            //vertical: 9 possible positions
            //horizontal: 8 possible positions
		//vertical 1
		rotatePieceRight(tp);
		validateYPosition(tp);
		tp.xpos = 0;
		validatePieceXPosition(tp);
		for(var i = 0; i < 9; i++){
			addStateToMap(tp, count);
			count++;
		}
		//horizontal 1
		instance_destroy(tp);
		tp = makeTempPiece();
		rotatePieceRight(tp);
		rotatePieceRight(tp);
		validateYPosition(tp);
		tp.xpos = 0;
		validatePieceXPosition(tp);
		for(var i = 0; i < 8; i++){
			addStateToMap(tp, count);
			count++;
		}
		//vertical 2
		instance_destroy(tp);
		tp = makeTempPiece();
		rotatePieceRight(tp);
		rotatePieceRight(tp);
		rotatePieceRight(tp);
		validateYPosition(tp);
		tp.xpos = 0;
		validatePieceXPosition(tp);
		for(var i = 0; i < 9; i++){
			addStateToMap(tp, count);
			count++;
		}
		//horizontal 2
		instance_destroy(tp);
		tp = makeTempPiece();
		tp.xpos = 0;
		for(var i = 0; i < 8; i++){
			addStateToMap(tp, count);
			count++;
		}
	}else if(s == "s" || s == "z"){
		//2 possible rotations
            //vertical: 9 possible positions
            //horizontal: 8 possible positions
		rotatePieceRight(tp);
		validateYPosition(tp);
		tp.xpos = 0;
		validatePieceXPosition(tp);
		for(var i = 0; i < 9; i++){
			addStateToMap(tp, count);
			count++;
		}
		//horizontal
		instance_destroy(tp);
		tp = makeTempPiece();
		tp.xpos = 0;
		for(var i = 0; i < 8; i++){
			addStateToMap(tp, count);
			count++;
		}
	}else{
		//no possible rotations (every orientation is the same)
            //9 possible positions
		tp.xpos = 0;
		for(var i = 0; i < 9; i++){
			addStateToMap(tp, count);
			count++;
		}
	}
	stateMap[? "count"] = count;
	instance_destroy(tp);
}

function outputGameState(){
	var stateString = "";
	for(var i = 0; i < bHeight; i++){
		for(var j = 0; j < bWidth; j++){
			if(board[j][i].fill){
				stateString += "1";
			}else{
				stateString += "0";
			}
		}
		stateString += "\n";
	}
	
	//generate possible states
	generateStates();
	
	//show_debug_message(stateString);
	//var outData = {
	//	boardState : stateString,
	//	pieceType : activePieceType,
	//	gameScore : numPoints,
	//}
	stateMap[? "boardState"] = stateString;
	stateMap[? "gameScore"] = numPoints;
	
	//show_debug_message(stateMap);
	
	//var writeData = json_stringify(outData);
	var writeData = json_encode(stateMap);
	var file = file_text_open_write("state.json");
	file_text_write_string(file, writeData);
	file_text_close(file);
	ds_map_clear(stateMap);
}

function initCommandFile(){
	var file = file_text_open_write("command.json");
	file_text_write_string(file, "");
	file_text_close(file);
}
function initStateFile(){
	var file = file_text_open_write("state.json");
	file_text_write_string(file, "");
	file_text_close(file);
}

function takeOrder(){
	//read from command file
	var file = file_text_open_read("command.json");
	var command = file_text_read_string(file);
	if(command != ""){
		show_debug_message(command);
		var obj = json_parse(command);
		rotTarget = obj.rotTarget;
		xTarget = obj.xTarget;
	}
	file_text_close(file);
}

function moveDown(){
	
}

function dropDown(){
	
}