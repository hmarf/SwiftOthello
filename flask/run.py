import json
from osero.players import player
from osero.Board import Board
from flask import Flask, jsonify, make_response, Response, request

app = Flask(__name__)

@app.route('/')
def hello():
    name = "Hello World"
    return name

@app.route('/cpu_osero', methods=['POST'])
def osero():
    json = request.get_json()
    board, stone_color, player_name = json['board'], json['color'], json['player_name']
    cpu_player = player(board,stone_color,player_name)
    x, y = cpu_player.play()
    result = {"x":x,"y":y}
    return jsonify(result)

if __name__ == "__main__":
	app.run(host='0.0.0.0')