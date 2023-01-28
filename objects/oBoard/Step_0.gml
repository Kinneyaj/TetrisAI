/// @description

fallTimer++;

if(keyboard_check_pressed(vk_space)){
	falling = falling ? false : true;
}

if(activePiece == noone){
	if(initNextPiece()){
		outputGameState();
		orderReceived = false;
	}else{
		room_restart();
	}
}else{
	//handle piece drop
	
	//reset square colors before piece moves
	clearShapeColor();
	
	//horizontal move
	//movedir = keyboard_check(vk_right) - keyboard_check(vk_left);
	movedir = sign(xTarget - activePiece.xpos);
	if(movedir != 0 && !checkPieceCollisionX()){
		if(moveTimer >= moveDelay){
			activePiece.xpos += movedir;
			moveTimer = 0;
		}
		moveTimer++;
	}
	//reset move delay
	if(keyboard_check_released(vk_right) || keyboard_check_released(vk_left)){
		moveTimer = moveDelay;
	}
	
	if(activePiece.rot != rotTarget){
		rotateRight();
	}
	//left rotation
	if(keyboard_check_pressed(ord("Z")) && activePiece.object_index != oO){
		rotateLeft();
	}
	//right rotation
	if(keyboard_check_pressed(ord("X")) && activePiece.object_index != oO){
		rotateRight();
	}
	
	//if(keyboard_check(vk_down)){
	if(1){
		global.tickRate = global.baseTickRate / 8;
	}else{
		global.tickRate = global.baseTickRate;
	}
	
	if(fallTimer >= global.tickRate && falling == true){
		//update piece position
		activePiece.ypos += global.grav;
		fallTimer = 0;
		//if(keyboard_check(vk_down)){
			numPoints++;
		//}
	}
	
	validateXPosition(); 
	
	//fill in shape color for next frame
	fillShapeColor();
	
	if(checkPieceCollisionY()){
		lockPiece();
	}
	if(!orderReceived){
		takeOrder();
		orderReceived = true;
	}
	checkRowClear();
}



