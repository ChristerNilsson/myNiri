echo = console.log
range = _.range

tiles = []
current = -1
antal = 1
 
created = 0

class Tile 
	constructor : (@letter,@x,@y,@dx,@dy) ->
	draw : ->
		noFill()
		rect @x-@dx, @y-@dy, 2*@dx, 2*@dy
		fill 'black'
		text @letter,@x,@y

shownTiles = []

setup = ->
	createCanvas 600,600
	textAlign CENTER,CENTER
	textSize 100

draw = ->
	background 'gray'
	fill 'black'
	for tile in shownTiles
		tile.draw()

	push()
	textSize 20
	for i in range tiles.length
		if i==current then fill 'yellow' else fill 'black'
		text tiles[i],20+20*i,20
	pop()

keyPressed = ->
	echo key
	if key == 'ArrowLeft' then current = (current-1) %% tiles.length
	if key == 'ArrowRight' then current = (current+1) %% tiles.length
	if key == 'n'
		tiles.push "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[created]
		created += 1
		current = tiles.length - 1
	n = tiles.length
	if key == '1' then antal = 1
	if key == '2' then antal = 2
	if key == '3' then antal = 3
	if key == '4' then antal = 4
	if antal > n then antal = n
	if key == 'a' # move left
		other = (current-1) %% n
		[tiles[current], tiles[other]] = [tiles[other], tiles[current]]
		current = other
	if key == 'd' # move right
		other = (current+1) %% n
		[tiles[current], tiles[other]] = [tiles[other], tiles[current]]
		current = other
	if key == 'Delete'
		tiles.splice current,1
		n = tiles.length
		if current == n then current = tiles.length-1
		if antal > n then antal=n

	shownTiles = []
	if antal == 1
		shownTiles.push new Tile tiles[current], 300, 300, 300, 300
	if antal == 2
		shownTiles.push new Tile tiles[current], 150, 300, 150, 300
		shownTiles.push new Tile tiles[(current+1) %% n], 450, 300, 150, 300
	if antal == 3
		shownTiles.push new Tile tiles[current+0], 150, 300, 150, 300
		shownTiles.push new Tile tiles[(current+1) %% n], 450, 150, 150, 150
		shownTiles.push new Tile tiles[(current+2) %% n], 450, 450, 150, 150
	if antal == 4
		shownTiles.push new Tile tiles[current+0], 150, 150, 150, 150
		shownTiles.push new Tile tiles[(current+1) %% n], 450, 150, 150, 150
		shownTiles.push new Tile tiles[(current+2) %% n], 150, 450, 150, 150
		shownTiles.push new Tile tiles[(current+3) %% n], 450, 450, 150, 150
