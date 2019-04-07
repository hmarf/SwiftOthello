import random
import copy
from .Stone import Stone
from .Board import Board
# board, stone, player_name
class player:

	def __init__(self,board_array,stone_color,player_name):
		self.BLACK = Stone("●")
		self.WHITE = Stone("○")
		self.BLANK = Stone("×")
		self.OPPONENT = {self.BLACK: self.WHITE, self.WHITE: self.BLACK}
		if stone_color == 1:
			self.stone = Stone('○')
		else:
			self.stone = Stone('●')
		self.board = Board(board_array)
		self.player = player_name

	def play(self):
		availables = self.board.availables(self.stone)
		if len(availables) == 0:
			return -1, -1
		if len(availables) == 1:
			x, y = availables[0]
			return x, y
		if self.player == 'Random':
			return self.Random(availables)
		elif self.player == 'Naive':
			return self.Naive(availables,self.board)
		elif self.player == 'CountStone':
			return self.CountStone(availables,self.board)

	def Random(self,availables):
		x, y = availables[random.randint(0,len(availables)-1)]
		return x, y

	def Naive(self,availables):
		for i in range(0,8):
			for j in range(0,8):
				if (i,j) in availables:
					return i, j

	def CountStone(self,availables,board):
		max_count = 0
		count = 0
		for x, y in availables:
			board_cp = copy.deepcopy(board)
			board_cp.put(x,y,self.stone)
		for i in range(board_cp.SIZE):
			for j in range(board_cp.SIZE):
				if board_cp[i][j] == self.stone:
					count += 1
				if count > max_count:
					x1 = x
					y1 = y
		return x1, y1
