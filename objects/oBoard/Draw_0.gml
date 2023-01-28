/// @description


for(var i = 0; i < bWidth; i++){
	for(var j = 0; j < bHeight; j++){
		draw_sprite_ext(spSquare, 0, startx + i*sprite_get_width(spSquare), starty + j*sprite_get_height(spSquare), 1, 1, 0, board[i][j].clr, 1);
	}
}


