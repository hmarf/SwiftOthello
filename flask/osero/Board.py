import copy
import time
import random
from .Stone import Stone

class Board:

    SIZE = 4
    DIRECTIONS_XY = ((-1, -1), (+0, -1), (+1, -1),
                     (-1, +0),           (+1, +0),
                     (-1, +1), (+0, +1), (+1, +1))

    def __init__(self,board_array):
        self.BLACK = Stone("●")
        self.WHITE = Stone("○")
        self.BLANK = Stone("×")
        self.OPPONENT = {self.BLACK: self.WHITE, self.WHITE: self.BLACK}
        size = self.SIZE
        center = size // 2
        square = [[self.BLANK for y in range(size)] for x in range(size)]  # 最初の盤面を定義
        # square[center - 1][center - 1:center + 1] = [self.WHITE, self.BLACK]
        # square[center + 0][center - 1:center + 1] = [self.BLACK, self.WHITE]
        # self.square = square
        for row in range(size):
            for col in range(size):
                if board_array[row][col] == -1:
                    square[row][col] = self.BLACK
                elif board_array[row][col] == 1:
                    square[row][col] = self.WHITE
        self.square = square

    def __str__(self):
        return '\n'.join(''.join(row) for row in self.square)

    def __getitem__(self, x):
        return self.square[x]

    def return_BoardArray(self):
        board_array = []
        for i in self.square:
            board_aa = []
            for j in i:
                if j == self.WHITE:
                    board_aa.append(1)
                elif j == self.BLACK:
                    board_aa.append(-1)
                else:
                    board_aa.append(0)
            board_array.append(board_aa)
        return board_array

    # BLACK: 0
    # WHITE: 1
    # BLANK: 2
    def flatten_data(self):
        _list = []

        for row in self.square:
            for col in row:
                if col == self.BLACK:
                    _list.append('b')
                elif col == self.WHITE:
                    _list.append('w')
                else:
                    _list.append('E')
        return _list

        # return [col
        #         for row in self.square
        #         for col in row]

    def is_playable(self):
        if sum(col == self.BLANK for row in self.square for col in row) == 0:
            return False # game over
        if sum(col == self.WHITE for row in self.square for col in row) == 0:
            return False
        if sum(col == self.BLACK for row in self.square for col in row) == 0:
            return False
        if len(self.availables(self.WHITE)) == len(self.availables(self.BLACK)) == 0:
            return False
        else:
            return True # continue game

    def count(self, stone):         # 石が何個あるかを返す関数
        return sum(col == stone     # True is 1, False is 0
                   for row in self.square
                   for col in row)

    def blank_count(self):
        return sum(col != self.BLANK
                    for row in self.square
                    for col in row)

    def difference_stone(self,stone):
        return sum(col == stone for row in self.square for col in row) - sum(col == self.OPPONENT[stone] for row in self.square for col in row)

    def put(self, x, y, _stone):     # y,xは置く石の座標、stoneにはWHITEかBLACKが入る。
        if _stone == 'WHITE':
            stone = self.WHITE
        else:
            stone = self.BLACK
        self[x][y] = stone
        # reverse
        for dx, dy in Board.DIRECTIONS_XY:
            n = self.count_reversible(x, y, dx, dy, stone)
            for i in range(1, n + 1):
                self[x + i * dx][y + i * dy] = stone

    def count_reversible(self, x, y, dx, dy, stone):
        size = self.SIZE
        for n in range(size):
            x += dx
            y += dy
            if not (0 <= x < size and 0 <= y < size):
                return 0
            if self[x][y] == self.BLANK:
                return 0
            if self[x][y] == stone:
                return n
        return 0

    def is_available(self, x, y, stone):
        if self[x][y] != self.BLANK:
            return False
        return any(self.count_reversible(x, y, dx, dy, stone) > 0
                   for dx, dy in self.DIRECTIONS_XY)

    def availables(self, stone):  # 打てる場所の探索
        return [(x, y)
                for x in range(self.SIZE)
                for y in range(self.SIZE)
                if self.is_available(x, y, stone)]

    def get_winner(self):
        black_score = sum(col == self.BLACK
            for row in self.square
            for col in row)
        white_count = sum(col == self.WHITE
            for row in self.square
            for col in row)
        if black_score > white_count:
            return self.BLACK
        elif black_score < white_count:
            return self.WHITE
        else:
            return 0

    def corner(self,stone):
        size = self.SIZE
        my_corner = 0
        opp_corner = 0
        for i in range(2):
            for j in range(2):
                if self.square[0+(size-1)*i][0+(size-1)*j] == stone:
                    my_corner += 1
                elif self.square[0+(size-1)*i][0+(size-1)*j] == self.OPPONENT[stone]:
                    opp_corner += 1
        return my_corner, opp_corner

    def center_stone(self,stone):
        size = self.SIZE
        my_stone = 0
        opp_stone = 0
        for i in range(2):
            for j in range(2):
                if self.square[i+1][j+1] == stone:
                    my_stone += 1
                else:
                    opp_stone += 1
        return my_stone - opp_stone
        
    def around_corner(self,stone):
        size = self.SIZE
        my_around_corner = 0
        opp_around_corner = 0
        for i in range(2):
            for j in range(2):
                if self.square[0+(size-1)*i][0+(size-1)*j] == self.BLANK:
                    y = 0+(size-1)*i
                    x = 0+(size-1)*j
                    for dx, dy in Board.DIRECTIONS_XY:
                        _y = y + dy
                        _x = x + dx
                        if 0 <= _x < size and 0 <= _y < size:
                            if self.square[_y][_x] == stone:
                                my_around_corner += 1
                            elif self.square[_y][_x] == self.OPPONENT[stone]:
                                opp_around_corner += 1
        return my_around_corner, opp_around_corner



