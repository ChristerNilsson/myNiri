echo = console.log
range = _.range

tree = [' ', 'A', 'B'] # index 0 är roten. barnen till noden i ligger i 2*i och 2*i+1
curr = tree
 
created = 0

class Node
	constructor : (@letter,@left=null, @right=null) ->
		@parent = null
	draw : (x,y,dx,dy) ->
		if @letter
			noFill()
			stroke 'black'
			rect x-dx, y-dy, 2*dx, 2*dy
			fill if curr.letter == @letter then 'yellow' else 'black'
			noStroke()
			textSize (dx+dy)/2
			text @letter,x,y
		else
			if dx > dy 
				if @left then @left.draw x-dx/2, y, dx/2, dy
				if @right then @right.draw x+dx/2, y, dx/2, dy
			else
				if @left then @left.draw  x, y-dy/2, dx, dy/2
				if @right then @right.draw x, y+dy/2, dx, dy/2

setup = ->
	createCanvas 600,500
	textAlign CENTER,CENTER
	strokeWeight 2
	curr = null
	echo tree
	xdraw()

xdraw = ->
	background 'gray'
	if tree then tree.draw width/2, height/2, width/2, height/2

keyPressed = ->
	echo key

	if key == 'n'
		newNode = new Node("ABCDEFGHIJKLMNOPQRSTUVWXYZ"[created])
		created += 1
		if tree == null 
			tree = newNode
			curr = newNode
		else
			parent = curr
			curr.left = new Node curr.letter
			curr.left.parent = parent
			curr.right = newNode
			curr.right.parent = parent
			curr.parent = parent
			curr.letter = null
			curr = curr.right
		echo 'tree',tree

	if key == 'Delete'
		parent = curr.parent
		if parent.right == curr
			other = parent.left
			parent.left = other.left
			parent.right = other.right
			parent.letter = other.letter
		else
			other = parent.right
			parent.left = other.left
			parent.right = other.right
			parent.letter = other.letter
		curr = parent
		echo 'curr',curr

	####

	if key == 'ArrowLeft' then curr = (curr-1) %% tiles.length
	if key == 'ArrowRight' then curr = (curr+1) %% tiles.length

	if key == 'a' # move left
		other = (curr-1) %% n
		[tiles[curr], tiles[other]] = [tiles[other], tiles[curr]]
		curr = other

	if key == 'd' # move right
		other = (curr+1) %% n
		[tiles[curr], tiles[other]] = [tiles[other], tiles[curr]]
		curr = other


	xdraw()
