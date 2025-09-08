echo = console.log
range = _.range

SPC = ' ' # Indikerar förgrening
tree = {}
#tree = {0: 'A'} # index 0 är roten. barnen till noden i ligger i 2*i+1 och 2*i+2
#tree = {0:SPC, 1:'A', 2:SPC, 5:'B', 6:SPC, 13:'D', 14:' ', 29:'F', 30:'G' } # index 0 är roten. barnen till noden i ligger i 2*i+1 och 2*i+2

extras = {} # x,y,left,right,down,up

DIR = 'R L D U'.split ' '

RT = 0
LT = 1
DN = 2
UP = 3

curr = 0
created = 0 

drawNode = (i,x,y,w,h) ->
	if i not of tree then return
	if curr == -1 then return
	letter = tree[i]
	if letter != SPC
		noFill()
		stroke 'black'
		rect x, y, w, h
		noStroke()
		textSize (w+h)/4
		fill if curr == i then 'yellow' else 'black'
		text letter,x+w/2, y+h/2
	else
		if w > h
			drawNode 2*i+1, x, y,     w/2, h
			drawNode 2*i+2, x+w/2, y, w/2, h
		else
			drawNode 2*i+1, x, y,     w, h/2
			drawNode 2*i+2, x, y+h/2, w, h/2

calcNode = (i,x,y,w,h) -> # Beräkna x och y för alla synliga tiles
	#echo 'calcNode',tree[i],x,y,w,h
	if i not of tree then return
	if curr == -1 then return
	name = tree[i]
	if name != SPC
		extras[i] = {name, x, y, w, h}
	else
		if w > h 
			calcNode 2*i+1, x, y,     w/2, h
			calcNode 2*i+2, x+w/2, y, w/2, h
		else
			calcNode 2*i+1, x, y,     w, h/2
			calcNode 2*i+2, x, y+h/2, w, h/2

exitPoint = (dir, extra) ->
	{x,y,w,h} = extra
	if dir == RT then return {x:x + w,   y:y + h/2}
	if dir == LT then return {x:x,       y:y + h/2}
	if dir == DN then return {x:x + w/2, y:y + h}
	if dir == UP then return {x:x + w/2, y:y}
	{x:-999, y:-999}

inside = (rect, ep) ->
	{x,y,w,h} = rect
	x <= ep.x <= x+w and y <= ep.y <= y+h

findTarget = (dir) ->
	extras = {}
	calcNode 0, 0, 0, width, height
	extra = extras[curr]
	ep = exitPoint dir, extra

	targets = []
	for key2 in _.keys extras
		if str(curr) == key2 then continue
		extra = extras[key2]
		if inside extra, ep then targets.push {size: extra.w * extra.h, key: int key2}
	if targets.length > 0 
		targets.sort (a,b) -> b.size - a.size
		curr = int targets[0].key

setup = ->
	createCanvas 500,400
	textAlign CENTER,CENTER
	strokeWeight 2
	echo tree
	xdraw()

xdraw = ->
	background 'gray'
	drawNode 0, 0, 0, width, height

makeExtra = ->
	extras = {}
	calcNode 0, 0, 0, width, height
	for i in range 4
		setDirections i
	echo 'makeExtra', extras

keyPressed = ->
	if key == 'n'
		newNode = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[created]
		created += 1
		if 0 == _.size tree
			tree[0] = newNode
			curr = 0
		else
			left  = 2 * curr + 1
			right = 2 * curr + 2
			tree[left] = tree[curr]
			tree[curr] = SPC
			tree[right] = newNode
			curr = right
		# makeExtra()
		echo 'Insert',curr,tree

	if key == 'Delete'
		if curr == -1 then return
		if 1 == _.size tree
			tree = {}
			curr = -1
		else
			parent = (curr-1) // 2
			left = 2 * parent + 1
			right = 2 * parent + 2
			other = if right == curr then left else right
			tree[parent] = tree[other]
			delete tree[right]
			delete tree[left]
			curr = parent
		echo 'Delete',curr,tree

	# if _.includes 'ABCDEFGHabcdefgh', key
	# 	for k in _.keys tree 
	# 		if tree[k] == key.toUpperCase() then curr = int(k)

	if key == 'ArrowRight' then findTarget RT
	if key == 'ArrowLeft'  then findTarget LT
	if key == 'ArrowDown'  then findTarget DN
	if key == 'ArrowUp'    then findTarget UP

	# move left, right, down, up saknas

	xdraw()
